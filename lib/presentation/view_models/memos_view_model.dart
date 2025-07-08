import 'dart:async';

import 'package:cine_memo/domain/usecases/get_all_memos_usecase.dart';
import 'package:cine_memo/presentation/view_models/movie_provider.dart';
import 'package:cine_memo/presentation/view_models/user_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/memo_with_movie_entity.dart';

final getAllMemosUseCaseProvider = Provider<GetAllMemosUseCase>((ref) {
  return GetAllMemosUseCase(
    ref.watch(userDataRepositoryProvider),
    ref.watch(movieRepositoryProvider),
  );
});

final memosViewModelProvider =
    AsyncNotifierProvider<MemosViewModel, List<MemoWithMovieEntity>>(
      MemosViewModel.new,
    );

class MemosViewModel extends AsyncNotifier<List<MemoWithMovieEntity>> {
  @override
  Future<List<MemoWithMovieEntity>> build() {
    return ref.watch(getAllMemosUseCaseProvider)();
  }
}
