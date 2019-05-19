import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xff2b5876),
                  const Color(0xff4e4376),
                ]),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Movies'),
              leading: Icon(
                Icons.movie,
                color: Colors.blueGrey,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('TV Shows'),
              leading: Icon(
                Icons.live_tv,
                color: Colors.blueGrey,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Discover'),
              leading: Icon(
                Icons.event_seat,
                color: Colors.blueGrey,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Popular People'),
              leading: Icon(
                Icons.person,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Reminders'),
              leading: Icon(
                Icons.alarm,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Contact Developer'),
              leading: Icon(
                Icons.help,
                color: Colors.blueGrey,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Google+ Community'),
              leading: Icon(
                Icons.help,
                color: Colors.blueGrey,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Unlock Pro'),
              leading: Icon(
                Icons.lock_open,
                color: Colors.blueGrey,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Settings'),
              leading: Icon(
                Icons.settings,
                color: Colors.blueGrey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
