abstract class PostDetailEvent {}

class LoadPostDetail extends PostDetailEvent {
  final int id;
  LoadPostDetail(this.id);
}