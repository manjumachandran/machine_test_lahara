import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:machine_test_lahara/features/posts/data/models/post_model.dart';
import 'package:machine_test_lahara/features/posts/domain/repositories/post_repository.dart';
import 'package:machine_test_lahara/features/posts/presentation/bloc/postdetail/post_detail_bloc.dart';
import 'package:machine_test_lahara/features/posts/presentation/bloc/postdetail/post_detail_event.dart';
import 'package:machine_test_lahara/features/posts/presentation/bloc/postdetail/post_detail_state.dart';

class PostDetailsPage extends StatelessWidget {
  final int id;
  const PostDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          PostDetailBloc(ctx.read<PostRepository>())..add(LoadPostDetail(id)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Post Details')),
        body: BlocBuilder<PostDetailBloc, PostDetailState>(
          builder: (context, state) {
            if (state is PostDetailLoaded) return _Content(post: state.post);

            if (state is PostDetailError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 56, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context
                            .read<PostDetailBloc>()
                            .add(LoadPostDetail(id)),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final PostModel post;
  const _Content({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = post.title.isEmpty
        ? post.title
        : post.title[0].toUpperCase() + post.title.substring(1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            children: [
              _InfoChip(icon: Icons.tag, label: 'ID: ${post.id}'),
              _InfoChip(
                  icon: Icons.person_outline, label: 'User ID: ${post.userId}'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            post.body,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.onPrimaryContainer),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}