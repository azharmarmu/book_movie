import 'package:book_movie/components/movie_list.dart';
import 'package:book_movie/components/drawer_widget.dart';
import 'package:book_movie/providers/media_provider.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;


  final MediaProvider movieProvider = MovieProvider();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = AppBar(
      elevation: 0.1,
      backgroundColor: Colors.black87,
      title: Text("Book Movie"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: null,
        ),
      ],
      bottom: TabBar(
        tabs: [
          Tab(
            text: 'NOW PLAYING',
          ),
          Tab(
            text: 'TOP BOX OFFICE',
          ),
          Tab(
            text: 'ANTICIPATED',
          ),
        ],
        controller: _tabController,
      ),
    );

    Widget body = TabBarView(
      controller: _tabController,
      children: <Widget>[
        MovieList(movieProvider,"popular"),
        MovieList(movieProvider,"popular"),
        MovieList(movieProvider,"popular"),
      ],
    );

    return Scaffold(
      drawer: MyDrawer(),
      appBar: appBar,
      body: body,
    );
  }
}
