import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_lahara/core/network/api_service.dart';
import 'package:machine_test_lahara/core/utils/app_navigator.dart';

import 'package:machine_test_lahara/core/utils/notification_service.dart';
import 'package:machine_test_lahara/features/posts/data/repositories/post_repository_impl.dart';
import 'package:machine_test_lahara/features/posts/domain/repositories/post_repository.dart';
import 'package:machine_test_lahara/features/posts/presentation/bloc/post/post_bloc.dart';
import 'package:machine_test_lahara/features/posts/presentation/pages/post_pages.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  final PostRepository repository = PostRepositoryImpl(ApiService());
  runApp(MyApp(repository: repository));

  
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => NotificationService.handleLaunchNotification(),
  );
}

class MyApp extends StatelessWidget {
  final PostRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
   
    return RepositoryProvider<PostRepository>.value(
      value: repository,
      child: BlocProvider(
        create: (_) => PostBloc(repository)..add(FetchPosts()),
        child: MaterialApp(
          title: 'Posts',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.indigo,
          ),
          home: const PostsPage(),
        ),
      ),
    );
  }
}