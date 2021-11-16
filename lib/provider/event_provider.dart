import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfectpomodoro/model/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => _events;

  void addEvent(Event event) {
    _events.add(event);

    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);

    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;

    notifyListeners();
  }

  // THEME

  ThemeData _selectedTheme;

  ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.yellow[900],
    secondaryHeaderColor: Colors.yellow[600],
    appBarTheme: AppBarTheme(backgroundColor: Colors.yellow[800]),
  );

  ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: Colors.black,
  );

  EventProvider({bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  Future<void> swapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      prefs.setBool('isDarkTheme', false);
    } else {
      _selectedTheme = dark;
      prefs.setBool('isDarkTheme', true);
    }
    notifyListeners();
  }

  ThemeData get getTheme => _selectedTheme;
}
