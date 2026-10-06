part of 'post_bloc.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> posts;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError; 
  final String? refreshError; 

  PostLoaded({
    required this.posts,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.refreshError,
  });
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}