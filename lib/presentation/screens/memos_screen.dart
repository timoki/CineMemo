import 'package:cine_memo/core/extensions/async_value_ui.dart';
import 'package:cine_memo/core/res/app_values.dart';
import 'package:cine_memo/core/res/strings.dart';
import 'package:cine_memo/presentation/view_models/memos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import 'detail_screen.dart';

class MemosScreen extends ConsumerWidget {
  const MemosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoState = ref.watch(memosViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.myMemoTitle)),
      body: memoState.toWidget((memos) {
        if (memos.isEmpty) {
          return const Center(child: Text(AppStrings.noResultMemos));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppDimens.defaultPadding),
          itemCount: memos.length,
          itemBuilder: (context, index) {
            final memoWithMovie = memos[index];
            return Hero(
              tag: memoWithMovie.movie.id,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    AppRouter.createSharedAxisRoute(
                      page: DetailScreen(movie: memoWithMovie.movie),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          memoWithMovie.movie.posterPath,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                memoWithMovie.movie.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                memoWithMovie.memoText,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
