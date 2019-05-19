import 'package:book_movie/components/actor_detail.dart';
import 'package:book_movie/components/movie_booking.dart';
import 'package:book_movie/components/season_detail_screen.dart';
import 'package:book_movie/model/cast.dart';
import 'package:book_movie/model/media_item_model.dart';
import 'package:book_movie/model/tvseason.dart';
import 'package:book_movie/pages/media_detail.dart';
import 'package:book_movie/providers/media_provider.dart';
import 'package:flutter/material.dart';

goToMovieDetails(BuildContext context, MediaItem movie) {
  MediaProvider provider =
      (movie.type == MediaType.movie) ? MovieProvider() : ShowProvider();
  _pushWidgetWithFade(context, MediaDetailScreen(movie, provider));
}

goToActorDetails(BuildContext context, Actor actor) =>
    _pushWidgetWithFade(context, ActorDetailScreen(actor));

goToSeasonDetails(BuildContext context, MediaItem show, TvSeason season) =>
    _pushWidgetWithFade(context, SeasonDetailScreen(show, season));

goToBookingDetails(BuildContext context, MediaItem movie, String tickets) =>
    _pushWidgetWithFade(context, BookingDetailScreen(movie,tickets));

_pushWidgetWithFade(BuildContext context, Widget widget) {
  Navigator.of(context).push(
    PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return widget;
        }),
  );
}
