import 'dart:convert';

import 'package:book_movie/model/cast.dart';
import 'package:book_movie/model/episode.dart';
import 'package:book_movie/model/media_item_model.dart';
import 'package:book_movie/model/tvseason.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class ApiClient {
  final String baseUrl = 'https://api.themoviedb.org/';

  Future<dynamic> _getJson(String url) async {
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future<List<MediaItem>> fetchMovies({
    int page: 1,
    String category: "popular",
  }) async {
    var url = 'https://api.themoviedb.org/'
        '3/movie/$category'
        '?page=$page&api_key=$API_KEY';
    print(url);

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
        .toList());
  }

  Future<List<MediaItem>> getSimilarMedia(int mediaId,
      {String type: "movie"}) async {
    var url = 'https://api.themoviedb.org/'
        '3/$type/$mediaId/similar'
        '?api_key=$API_KEY';
    print(url);

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(
            item, (type == "movie") ? MediaType.movie : MediaType.show))
        .toList());
  }

  Future<dynamic> getMediaDetails(int mediaId, {String type: "movie"}) async {
    var url = 'https://api.themoviedb.org/'
        '3/$type/$mediaId'
        '?api_key=$API_KEY';
    print(url);

    return _getJson(url);
  }

  Future<List<Actor>> getMediaCredits(int mediaId,
      {String type: "movie"}) async {
    var url = 'https://api.themoviedb.org/'
        '3/$type/$mediaId/credits'
        '?api_key=$API_KEY';
    print(url);

    return _getJson(url).then((json) =>
        json['cast'].map<Actor>((item) => Actor.fromJson(item)).toList());
  }

  Future<List<TvSeason>> getShowSeasons(int showId) async {
    var detailJson = await getMediaDetails(showId, type: 'tv');
    return detailJson['seasons']
        .map<TvSeason>((item) => TvSeason.fromMap(item))
        .toList();
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) async {
    var url = 'https://api.themoviedb.org/'
        '3/discover/movie'
        '?api_key=$API_KEY&with_cast=$actorId&sort_by=popularity.desc';
    print(url);

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
        .toList());
  }

  Future<List<MediaItem>> getShowsForActor(int actorId) async {
    var url = 'https://api.themoviedb.org/'
        '3/person/$actorId/tv_credits'
        '?api_key=$API_KEY';
    print(url);

    return _getJson(url).then((json) => json['cast']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.show))
        .toList());
  }

  Future<List<MediaItem>> fetchShows(
      {int page: 1, String category: "popular"}) async {
    var url = 'https://api.themoviedb.org/'
        '3/tv/$category/'
        '?api_key=$API_KEY&page=$page';
    print(url);

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.show))
        .toList());
  }

  Future<List<Episode>> fetchEpisodes(int showId, int seasonNumber) {
    var url = 'https://api.themoviedb.org/'
        '3/tv/$showId/season/$seasonNumber'
        '?api_key=$API_KEY';
    print(url);

    return _getJson(url).then((json) => json['episodes']).then(
            (data) => data.map<Episode>((item) => Episode.fromJson(item)).toList());
  }

}
