import 'package:cine_memo/domain/entities/movie_entity.dart';

class MemoWithMovieEntity {
  final MovieEntity movie;
  final String memoText;
  final DateTime timestamp;

  MemoWithMovieEntity({
    required this.movie,
    required this.memoText,
    required this.timestamp,
  });
}
