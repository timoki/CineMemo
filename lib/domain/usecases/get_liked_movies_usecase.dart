import 'package:firebase_auth/firebase_auth.dart';

import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';
import '../repositories/user_data_repository.dart';

class GetLikedMoviesUseCase {
  final UserDataRepository _userDataRepository;
  final MovieRepository _movieRepository;

  GetLikedMoviesUseCase(this._movieRepository, this._userDataRepository);

  Future<List<MovieEntity>> call() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    final likedMovieIds = await _userDataRepository.getLikedMovieIds(
      uid: user.uid,
    );
    if (likedMovieIds.isEmpty) {
      return [];
    }

    final movieFutures = likedMovieIds
        .map((id) => _movieRepository.getMovieDetailById(id))
        .toList();

    final movies = await Future.wait(movieFutures);
    return movies;
  }
}
