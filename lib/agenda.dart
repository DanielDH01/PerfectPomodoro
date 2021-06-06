import 'package:flutter/material.dart';
import 'package:perfectpomodoro/page/event_editing_page.dart';
import 'package:perfectpomodoro/widget/calendar_widget.dart';

class AgendaPage extends MaterialPageRoute<Null> {
  AgendaPage()
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Agenda Pomodoro'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName));
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            body: CalendarWidget(),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.red[300],
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventEditingPage(),
                ),
              ),
            ),
          );
        });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
