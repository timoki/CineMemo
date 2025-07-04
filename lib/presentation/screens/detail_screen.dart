import 'package:flutter/material.dart';

import '../../domain/entities/movie_entity.dart';

class DetailScreen extends StatelessWidget {
  final MovieEntity movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 영화 포스터
              Hero(
                tag: movie.id,
                child: Image.network(
                  movie.posterPath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // 영화 제목
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 영화 줄거리
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
