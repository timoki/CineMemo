import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/movie_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularMovies = ref.watch(popularMoviesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('CineMemo - 인기 영화')),
      body: popularMovies.when(
        data: (movies) {
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: Image.network(movie.posterPath),
                title: Text(movie.title),
                subtitle: Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text("에러 발생: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
