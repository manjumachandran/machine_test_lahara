import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_lahara/core/network/api_service.dart' show ApiException;
import 'package:machine_test_lahara/features/posts/data/models/post_model.dart'; 
import 'package:machine_test_lahara/features/posts/domain/repositories/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  static const int initialCount = 15;
  static const int pageSize = 10;
  static const int totalPosts = 100;

  final PostRepository repository;

  PostBloc(this.repository) : super(PostInitial()) {
    on<FetchPosts>(_onFetch);
    on<LoadMorePosts>(_onLoadMore);
    on<RefreshPosts>(_onRefresh);
  }

  bool _hasMore(int fetched, int requested, int total) =>
      fetched == requested && total < totalPosts;

  String _message(Object e) =>
      e is ApiException ? e.message : 'Something went wrong. Please try again.';

  Future<void> _onFetch(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final posts =
          await repository.fetchPosts(start: 0, limit: initialCount);
      emit(PostLoaded(
        posts: posts,
        hasMore: _hasMore(posts.length, initialCount, posts.length),
      ));
    } catch (e) {
      emit(PostError(_message(e)));
    }
  }

  Future<void> _onLoadMore(
      LoadMorePosts event, Emitter<PostState> emit) async {
    final current = state;
    if (current is! PostLoaded || current.isLoadingMore || !current.hasMore) {
      return;
    }

    emit(PostLoaded(posts: current.posts, hasMore: true, isLoadingMore: true));

    try {
      final more = await repository.fetchPosts(
        start: current.posts.length,
        limit: pageSize,
      );
      final all = [...current.posts, ...more];
      emit(PostLoaded(
        posts: all,
        hasMore: _hasMore(more.length, pageSize, all.length),
      ));
    } catch (e) {
     
      emit(PostLoaded(
        posts: current.posts,
        hasMore: true,
        loadMoreError: _message(e),
      ));
    }
  }

  Future<void> _onRefresh(
      RefreshPosts event, Emitter<PostState> emit) async {
    try {
      final posts =
          await repository.fetchPosts(start: 0, limit: initialCount);
      emit(PostLoaded(
        posts: posts,
        hasMore: _hasMore(posts.length, initialCount, posts.length),
      ));
    } catch (e) {
      final current = state;
      if (current is PostLoaded) {
        emit(PostLoaded(
          posts: current.posts,
          hasMore: current.hasMore,
          refreshError: _message(e),
        ));
      } else {
        emit(PostError(_message(e)));
      }
    } finally {
      event.completer?.complete();
    }
  }
}