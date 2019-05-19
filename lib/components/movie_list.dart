import 'package:book_movie/navigator/navigator.dart';
import 'package:book_movie/providers/media_provider.dart';
import 'package:book_movie/util/utils.dart';
import 'package:flutter/material.dart';

import 'package:book_movie/model/media_item_model.dart';

class MovieList extends StatefulWidget {
  MovieList(this.provider, this.category, {Key key}) : super(key: key);
  final MediaProvider provider;
  final String category;

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<MediaItem> _moviesList = List();
  int _pageNumber = 1;
  LoadingState _loadingState = LoadingState.LOADING;
  bool _isLoading = false;

  _loadNextPage() async {
    _isLoading = true;
    try {
      var nextMovies =
          await widget.provider.loadMedia(widget.category, page: _pageNumber);
      setState(() {
        _loadingState = LoadingState.DONE;
        _moviesList.addAll(nextMovies);
        _isLoading = false;
        _pageNumber++;
      });
    } catch (e) {
      _isLoading = false;
      if (_loadingState == LoadingState.LOADING) {
        setState(() => _loadingState = LoadingState.ERROR);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  Widget _getContentSection() {
    switch (_loadingState) {
      case LoadingState.DONE:
        return Container(
          child: GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: _moviesList.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              if (!_isLoading && index > (_moviesList.length * 0.7)) {
                _loadNextPage();
              }
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Movie(_moviesList[index]),
              );
            },
          ),
        );
      case LoadingState.ERROR:
        return Text('Sorry, there was an error loading the data!');
      case LoadingState.LOADING:
        return CircularProgressIndicator();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getContentSection();
  }
}

class Movie extends StatelessWidget {
  final MediaItem movie;

  Movie(this.movie);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: Text("hero"),
        child: Material(
          child: InkWell(
            onTap: () => goToMovieDetails(context, movie),
            child: GridTile(
              footer: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          movie.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  )),
              //child: Image.asset(moviePic, fit: BoxFit.cover),
              child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                placeholder: 'assets/placeholder.jpg',
                image: movie.getBackDropUrl(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
