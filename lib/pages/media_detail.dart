import 'dart:async';
import 'dart:math';

import 'package:book_movie/components/bottom_gradient.dart';
import 'package:book_movie/components/cast_section.dart';
import 'package:book_movie/components/meta_section.dart';
import 'package:book_movie/components/season_section.dart';
import 'package:book_movie/components/similar_section.dart';
import 'package:book_movie/components/text_bubble.dart';
import 'package:book_movie/model/cast.dart';
import 'package:book_movie/model/media_item_model.dart';
import 'package:book_movie/model/tvseason.dart';
import 'package:book_movie/navigator/navigator.dart';
import 'package:book_movie/providers/media_provider.dart';
import 'package:book_movie/util/api_client.dart';
import 'package:book_movie/util/styles.dart';
import 'package:book_movie/util/utils.dart';
import 'package:flutter/material.dart';

class MediaDetailScreen extends StatefulWidget {
  final MediaItem _mediaItem;
  final MediaProvider provider;
  final ApiClient _apiClient = ApiClient();

  MediaDetailScreen(this._mediaItem, this.provider);

  @override
  MediaDetailScreenState createState() {
    return MediaDetailScreenState();
  }
}

class MediaDetailScreenState extends State<MediaDetailScreen> {
  List<Actor> _actorList;
  List<TvSeason> _seasonList;
  List<MediaItem> _similarMedia;
  dynamic _mediaDetails;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _loadCast();
    _loadDetails();
    _loadSimilar();
    if (widget._mediaItem.type == MediaType.show) _loadSeasons();

    Timer(Duration(milliseconds: 100), () => setState(() => _visible = true));
  }

  void _loadCast() async {
    try {
      List<Actor> cast = await widget.provider.loadCast(widget._mediaItem.id);
      setState(() => _actorList = cast);
    } catch (e) {}
  }

  void _loadDetails() async {
    try {
      dynamic details = await widget.provider.getDetails(widget._mediaItem.id);
      setState(() => _mediaDetails = details);
    } catch (e) {
      e.toString();
    }
  }

  void _loadSeasons() async {
    try {
      List<TvSeason> seasons =
          await widget._apiClient.getShowSeasons(widget._mediaItem.id);
      setState(() => _seasonList = seasons);
    } catch (e) {}
  }

  void _loadSimilar() async {
    try {
      List<MediaItem> similar =
          await widget.provider.getSimilar(widget._mediaItem.id);
      setState(() => _similarMedia = similar);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(widget._mediaItem),
            _buildContentSection(widget._mediaItem),
          ],
        ));
  }

  Widget _buildAppBar(MediaItem movie) {
    return SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return ShowModal(
                      movie: movie,
                    );
                  },
                );
              },
              child: Text('BOOK-TICKET'),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: "Movie-Tag-${widget._mediaItem.id}",
              child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: "assets/placeholder.jpg",
                  image: widget._mediaItem.getBackDropUrl()),
            ),
            BottomGradient(),
            _buildMetaSection(movie)
          ],
        ),
      ),
    );
  }

  Widget _buildMetaSection(MediaItem mediaItem) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextBubble(
                  mediaItem.getReleaseYear().toString(),
                  backgroundColor: Color(0xffF47663),
                ),
                Container(
                  width: 8.0,
                ),
                TextBubble(mediaItem.voteAverage.toString(),
                    backgroundColor: Color(0xffF47663)),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(mediaItem.title,
                  style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 20.0)),
            ),
            Row(
              children: getGenresForIds(mediaItem.genreIds)
                  .sublist(0, min(5, mediaItem.genreIds.length))
                  .map((genre) => Row(
                        children: <Widget>[
                          TextBubble(genre),
                          Container(
                            width: 8.0,
                          )
                        ],
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(MediaItem media) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: BoxDecoration(color: const Color(0xff222128)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "SYNOPSIS",
                  style: const TextStyle(color: Colors.white),
                ),
                Container(
                  height: 8.0,
                ),
                Text(media.overview,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 12.0)),
                Container(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: primary),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _actorList == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : CastSection(_actorList)),
        ),
        Container(
          decoration: BoxDecoration(color: primaryDark),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _mediaDetails == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : MetaSection(_mediaDetails)),
        ),
        (widget._mediaItem.type == MediaType.show)
            ? Container(
                decoration: BoxDecoration(color: primary),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _seasonList == null
                        ? Container()
                        : SeasonSection(widget._mediaItem, _seasonList)),
              )
            : Container(),
        Container(
            decoration: BoxDecoration(
                color: (widget._mediaItem.type == MediaType.movie
                    ? primary
                    : primaryDark)),
            child: _similarMedia == null
                ? Container()
                : SimilarSection(_similarMedia))
      ]),
    );
  }
}

class ShowModal extends StatefulWidget {
  final MediaItem movie;

  const ShowModal({Key key, this.movie}) : super(key: key);

  @override
  _ShowModalState createState() => _ShowModalState();
}

class _ShowModalState extends State<ShowModal> {
  String dropDownValue = "1";

  void changeDropDownValue(String value) {
    setState(() {
      dropDownValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget ticketCategory(String name, String rate, String availability) {
      return Column(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(fontSize: 14),
          ),
          Text(
            rate,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            availability,
            style: TextStyle(fontSize: 12),
          ),
        ],
      );
    }

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('How many seats'),
          trailing: new DropdownButton<String>(
            items: <String>['1', '2', '3', '4'].map((String v) {
              return new DropdownMenuItem<String>(
                value: v,
                child: new Text(v),
              );
            }).toList(),
            onChanged: (newValue) {
              changeDropDownValue(newValue);
            },
            value: dropDownValue,
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ticketCategory(
              "Balcony",
              "\u20B9150.0",
              "Available",
            ),
            SizedBox(width: 50.0),
            ticketCategory(
              "First-Class",
              "\u20B9120.0",
              "Available",
            ),
          ],
        ),
        SizedBox(height: 50.0),
        RaisedButton(
          onPressed: () {
            goToBookingDetails(context, widget.movie, dropDownValue);
          },
          child: const Text('Select Seats', style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 50.0)
      ],
    );
  }
}
