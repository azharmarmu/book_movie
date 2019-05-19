import 'package:book_movie/model/media_item_model.dart';
import 'package:book_movie/util/shared_preferences.dart';
import 'package:book_movie/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class BookingDetailScreen extends StatefulWidget {
  final MediaItem _mediaItem;
  final String _tickets;

  BookingDetailScreen(this._mediaItem, this._tickets);

  @override
  BookingDetailScreenState createState() {
    return BookingDetailScreenState();
  }
}

class BookingDetailScreenState extends State<BookingDetailScreen> {
  int _tickets;
  bool enableBook;
  List<String> bookedList;
  List<String> alreadyBookedList;

  @override
  void initState() {
    super.initState();
    _tickets = int.parse(widget._tickets);
    enableBook = false;
    bookedList = [];
    Future<dynamic> _future = SharedPreferencesHelper().getBookedTickets();
    _future.then((onValue) {
      alreadyBookedList = onValue;
    });
  }

  var seatList = [
    {
      "name": "A",
    },
    {
      "name": "B",
    },
    {
      "name": "C",
    },
    {
      "name": "D",
    },
    {
      "name": "E",
    },
    {
      "name": "F",
    },
  ];

  Widget _buildSeat() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 750.0,
          child: ListView.builder(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: seatList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: 40.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int _index) {
                      return SeatSelection(
                        parent: this,
                        rowName: seatList[index]['name'],
                        index: _index,
                        tickets: widget._tickets,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(MediaItem movie, String tickets) {
    return AppBar(
      title: Text(movie.title),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('$tickets Tickets')),
        )
      ],
    );
  }

  Widget _buildBody() {
    return ListView(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text("Screen"),
        ),
      ),
      Divider(),
      SizedBox(height: 50.0),
      _buildSeat(),
      enableBook
          ? RaisedButton(
              onPressed: () {
                print('Booked: $bookedList');
                bookedList.addAll(alreadyBookedList);
                SharedPreferencesHelper().setBookedTickets(bookedList);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('BOOK', style: TextStyle(fontSize: 16)),
            )
          : Container(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(widget._mediaItem, widget._tickets),
      body: _buildBody(),
    );
  }
}

class SeatSelection extends StatefulWidget {
  final BookingDetailScreenState parent;
  final rowName;
  final index;
  final tickets;

  const SeatSelection(
      {Key key, this.parent, this.rowName, this.index, this.tickets})
      : super(key: key);

  @override
  _SeatSelectionState createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  Color color;
  bool alreadyBooked = false;
  List<String> alreadyBookedList;

  @override
  void initState() {
    super.initState();
    Future<dynamic> _future = SharedPreferencesHelper().getBookedTickets();
    _future.then((onValue) {
      alreadyBookedList = onValue;
      alreadyBooked = widget.parent.alreadyBookedList
          .contains('${widget.rowName}${widget.index + 1}');
      setState(() {
        color = alreadyBooked ? Colors.blueGrey : Colors.transparent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!alreadyBooked) {
          if (color == colorAccent) {
            setState(() {
              color = Colors.transparent;
            });
            widget.parent.setState(() {
              widget.parent._tickets++;
              widget.parent.bookedList
                  .remove('${widget.rowName}${widget.index + 1}');
            });
            if (widget.parent._tickets != 0) {
              widget.parent.setState(() {
                widget.parent.enableBook = false;
              });
            }
          } else {
            if (widget.parent._tickets != 0) {
              setState(() {
                color = colorAccent;
              });
              widget.parent.setState(() {
                widget.parent._tickets--;
                widget.parent.bookedList
                    .add('${widget.rowName}${widget.index + 1}');
              });
              if (widget.parent._tickets == 0) {
                widget.parent.setState(() {
                  widget.parent.enableBook = true;
                });
              }
            }
          }
        } else {
          Toast.show(
            "Already-Booked",
            context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: color, border: Border.all(width: 2.0, color: colorAccent)),
        width: 50.0,
        height: 40.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            '${widget.rowName}${widget.index + 1}',
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}
