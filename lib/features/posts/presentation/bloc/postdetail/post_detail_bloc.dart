import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_lahara/core/network/api_service.dart';
import 'package:machine_test_lahara/features/posts/domain/repositories/post_repository.dart';
import 'package:machine_test_lahara/features/posts/presentation/bloc/postdetail/post_detail_event.dart';
import 'package:machine_test_lahara/features/posts/presentation/bloc/postdetail/post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final PostRepository repository;

  PostDetailBloc(this.repository) : super(PostDetailLoading()) {
    on<LoadPostDetail>((event, emit) async {
      emit(PostDetailLoading());
      try {
        emit(PostDetailLoaded(await repository.fetchPostDetail(event.id)));
      } catch (e) {
        emit(PostDetailError(e is ApiException
            ? e.message
            : 'Something went wrong. Please try again.'));
      }
    });
  }
}
