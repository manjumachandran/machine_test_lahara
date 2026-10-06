import 'package:machine_test_lahara/core/network/api_service.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart'; // adjust path

class PostRepositoryImpl implements PostRepository {
  final ApiService apiService;

  PostRepositoryImpl(this.apiService);

  @override
  Future<List<PostModel>> fetchPosts({required int start, required int limit}) {
    return apiService.getPosts(start: start, limit: limit);
  }

  @override
  Future<PostModel> fetchPostDetail(int id) {
    return apiService.getPostById(id);
  }
}