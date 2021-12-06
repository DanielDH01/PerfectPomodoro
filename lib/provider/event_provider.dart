import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfectpomodoro/database/events_database.dart';
import 'package:perfectpomodoro/model/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider extends ChangeNotifier {
  // final List<Event> _events = getEvents();

  List<Event> events;

  EventsDatabase database;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => events;

  void addEvent(Event event) {
    EventsDatabase.instance.create(event);
    notifyListeners();
  }

  refreshEvents() async {
    events = await EventsDatabase.instance.readAllEvents();
    notifyListeners();
  }

  Future getEventsFromSelected(DateTime selectedDate) async {
    events = await EventsDatabase.instance.readAllEvents();
    notifyListeners();
  }

  void deleteEvent(Event event) {
    EventsDatabase.instance.delete(event.id);
    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    EventsDatabase.instance.edit(oldEvent, newEvent);

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

  EventProvider({bool isDarkMode, EventsDatabase database}) {
    this.database = database;
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
