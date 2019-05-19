import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  final String _kBookedTickets = "bookedTickets";

  setBookedTickets(List<String> _list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Recent: $_list');
    return prefs.setStringList(_kBookedTickets, _list);
  }

  getBookedTickets() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList(_kBookedTickets));
    return prefs.getStringList(_kBookedTickets) ?? null;
  }
}
