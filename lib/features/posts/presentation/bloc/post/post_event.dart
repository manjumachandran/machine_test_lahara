part of 'post_bloc.dart';

abstract class PostEvent {}


class FetchPosts extends PostEvent {}


class LoadMorePosts extends PostEvent {}


class RefreshPosts extends PostEvent {
  final Completer<void>? completer;
  RefreshPosts({this.completer});
}