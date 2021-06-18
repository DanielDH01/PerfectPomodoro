import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:perfectpomodoro/page/event_viewing_page.dart';
import 'package:perfectpomodoro/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../agenda.dart' as agenda;
import 'model/event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Timer(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(
            accentColor: Colors.yellowAccent, primaryColor: Colors.yellow[900]),
      ),
    );
  }
}

class Timer extends StatefulWidget {
  const Timer({Key key}) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  CountDownController _controller = CountDownController();
  bool _isPause = false;
  bool _isBreak = false;
  bool _isBlocked = false;
  int _timerMin = 25 * 60;

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Perfected'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context, agenda.AgendaPage());
            },
            icon: Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 20,
            child: Column(
              children: [
                Text("Calendar Events: "),
                Expanded(
                  flex: 9,
                  child: Container(
                    child: ListView(
                      children: makeList(events),
                    ),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 90,
            child: Align(
              alignment: Alignment.topCenter,
              child: CircularCountDownTimer(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                duration: _timerMin,
                fillColor: Colors.red,
                ringColor: Colors.transparent,
                controller: _controller,
                backgroundColor: Colors.transparent,
                strokeWidth: 5.0,
                strokeCap: StrokeCap.round,
                isTimerTextShown: true,
                isReverse: true,
                isReverseAnimation: true,
                onComplete: () {
                  Alert(
                          context: context,
                          title: 'Done',
                          style: AlertStyle(
                            isCloseButton: true,
                            isButtonVisible: false,
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          ),
                          type: AlertType.success)
                      .show();
                },
                textStyle: TextStyle(fontSize: 50.0, color: Colors.amber),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildRowButtons(),
        ],
      ),
    );
  }

  List<Widget> makeList(List<Event> events) {
    List<Widget> texts = <Widget>[];
    if (events.isNotEmpty) {
      for (Event el in events) {
        texts.add(
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EventViewingPage(event: el),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Text(
                      el.title,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white10,
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.greenAccent[400],
                      ),
                      onPressed: () {
                        final provider =
                            Provider.of<EventProvider>(context, listen: false);

                        provider.deleteEvent(el);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        texts.add(Divider(
          height: 5,
          color: Colors.white10,
        ));
      }
    } else {
      texts.add(Text("Add something to Calender"));
    }

    return texts;
  }

  Widget buildRowButtons() {
    if (MediaQuery.of(context).size.width < 342) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(),
              onPressed: () {
                setState(() {
                  if (_isBreak) {
                    _timerMin = 25 * 60;
                    _isBreak = false;
                    _controller.restart(duration: _timerMin);
                    if (_isPause) {
                      _controller.restart(duration: _timerMin);
                      _controller.pause();
                    } else {
                      _controller.restart(duration: _timerMin);
                    }
                  } else {
                    _timerMin = 5 * 60;
                    _isBreak = true;
                    if (_isPause) {
                      _controller.restart(duration: _timerMin);
                      _controller.pause();
                    } else {
                      _controller.restart(duration: _timerMin);
                    }
                  }
                });
              },
              icon: Icon(_isBreak ? Icons.wb_sunny : Icons.work),
              label: Text('   Skip   '),
              elevation: 0,
            ),
          ),
          Container(
            //TODO Make BUttons nice
            color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(),
              onPressed: () {
                setState(() {
                  if (_isPause) {
                    _isPause = false;
                    _controller.resume();
                  } else {
                    _isPause = true;
                    _controller.pause();
                  }
                });
              },
              child: Icon(
                _isPause ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: 60,
              ),
              backgroundColor: Colors.transparent,

              // label: Text(_isPause ? 'Resume' : 'Pause'),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(),
              onPressed: () {
                setState(() {
                  if (_isBlocked) {
                    _isBlocked = false;
                  } else {
                    _isBlocked = true;
                  }
                });
              },
              icon: Icon(
                  _isBlocked ? Icons.check_box_outline_blank : Icons.check_box),
              label: Text("Block Apps"),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 60,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.yellow[900],
              shape: RoundedRectangleBorder(),
              onPressed: () {
                setState(() {
                  if (_isBreak) {
                    _timerMin = 25 * 60;
                    _isBreak = false;
                    _controller.restart(duration: _timerMin);
                    if (_isPause) {
                      _controller.restart(duration: _timerMin);
                      _controller.pause();
                    } else {
                      _controller.restart(duration: _timerMin);
                    }
                  } else {
                    _timerMin = 5 * 60;
                    _isBreak = true;
                    if (_isPause) {
                      _controller.restart(duration: _timerMin);
                      _controller.pause();
                    } else {
                      _controller.restart(duration: _timerMin);
                    }
                  }
                });
              },
              icon: Icon(
                _isBreak ? Icons.wb_sunny : Icons.work,
                color: Colors.white,
              ),
              label: Text(
                '   Skip   ',
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
            ),
          ),
          Container(
            //TODO Make BUttons nice
            color: Colors.red,
            width: MediaQuery.of(context).size.width / 3,
            height: 60,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(),
              onPressed: () {
                setState(() {
                  if (_isPause) {
                    _isPause = false;
                    _controller.resume();
                  } else {
                    _isPause = true;
                    _controller.pause();
                  }
                });
              },
              child: Icon(
                _isPause ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: 60,
              ),
              backgroundColor: Colors.transparent,

              // label: Text(_isPause ? 'Resume' : 'Pause'),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 60,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.yellow[900],
              shape: RoundedRectangleBorder(),
              onPressed: () {
                setState(() {
                  if (_isBlocked) {
                    _isBlocked = false;
                  } else {
                    _isBlocked = true;
                  }
                });
              },
              icon: Icon(
                _isBlocked ? Icons.check_box_outline_blank : Icons.check_box,
                color: Colors.white,
              ),
              elevation: 0,
              label: Text("Block Apps", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }
  }
}
