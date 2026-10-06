import '../../data/models/post_model.dart'; // adjust to where your model lives

abstract class PostRepository {
  Future<List<PostModel>> fetchPosts({required int start, required int limit});
  Future<PostModel> fetchPostDetail(int id);
}