import 'package:cine_memo/domain/entities/movie_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart'; // 코드 생성기가 만들 파일

@JsonSerializable()
class MovieModel {
  final int id;
  final String title;
  final String overview;
  @JsonKey(name: 'poster_path') // JSON 필드명과 변수명이 다를 때 사용
  final String posterPath;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  // JSON -> Model 변환
  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  // Model -> JSON 변환
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  // Model(Data Layer)을 Entity(Domain Layer)로 변환
  MovieEntity toEntity() {
    return MovieEntity(
      id: id,
      title: title,
      overview: overview,
      posterPath:
          'https://image.tmdb.org/t/p/w500$posterPath', // 이미지 URL 완전하게 만들기
    );
  }
}
