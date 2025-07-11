import 'package:cine_memo/core/extensions/async_value_ui.dart';
import 'package:cine_memo/core/res/strings.dart';
import 'package:cine_memo/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/auth_view_model.dart';
import '../view_models/movie_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularMovies = ref.watch(popularMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.popularMoviesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: popularMovies.toWidget(
        (movies) => GridView.builder(
          padding: const EdgeInsets.all(10.0),
          // 그리드의 한줄에 몇 개의 아이템을 보여줄지 설정
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 한줄에 2개
            childAspectRatio: 0.7, // 아이템의 가로세로 비율(가로 기준 세로 높이 결정
            crossAxisSpacing: 10.0, // 아이템 간의 가로 간격
            mainAxisSpacing: 10.0, // 아이템 간의 세로 간격
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieCard(movie: movies[index]);
          },
        ),
      ),
    );
  }
}
