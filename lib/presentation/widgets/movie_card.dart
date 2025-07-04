import 'package:cine_memo/domain/entities/movie_entity.dart';
import 'package:flutter/material.dart';

import '../screens/detail_screen.dart';

class MovieCard extends StatelessWidget {
  final MovieEntity movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(movie: movie)),
        );
      },
      child: Card(
        // 카드가 주변과 잘 구분되도록 그림자 효과
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // 카드의 내용물이 모서리 밖으로 나가지 않도록
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 영화 포스터
            Expanded(
              child: Hero(
                tag: movie.id,
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  // 로딩 중 보여줄 위젯
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.movie);
                  },
                ),
              ),
            ),
            // 영화 제목
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
