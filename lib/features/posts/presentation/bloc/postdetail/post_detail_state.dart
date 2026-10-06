import 'package:machine_test_lahara/features/posts/data/models/post_model.dart';

abstract class PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  final PostModel post;
  PostDetailLoaded(this.post);
}

class PostDetailError extends PostDetailState {
  final String message;
  PostDetailError(this.message);
}