import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:perfectpomodoro/database/events_database.dart';
import 'package:perfectpomodoro/page/event_viewing_page.dart';
import 'package:perfectpomodoro/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vibration/vibration.dart';
import '../agenda.dart' as agenda;
import 'model/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _prefs = await SharedPreferences.getInstance();
  if (_prefs.getBool("isDarkTheme") == null) {
    _prefs.setBool("isDarkTheme", false);
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => EventProvider(
        isDarkMode: _prefs.getBool("isDarkTheme"),
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Timer(),
      theme: Provider.of<EventProvider>(context).getTheme,
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
  int _timerMin = 3;
  bool isLoading = false;
  EventProvider eventProvider;

  @override
  Widget build(BuildContext context) {
    eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfect Pomodoro'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.brightness_6_outlined,
          ),
          onPressed: () => {
            eventProvider.swapTheme(),
          },
        ),
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
                    child: EventsList(),
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
              child: InkWell(
                onTap: () => setState(() {
                  if (_isPause) {
                    _isPause = false;
                    _controller.resume();
                  } else {
                    _isPause = true;
                    _controller.pause();
                  }
                }),
                splashFactory: NoSplash.splashFactory,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(50.0),
                  child: CircularCountDownTimer(
                    //TODO add SOUNDS on alert
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 1.5,
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
                      Vibration.vibrate();
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
                      setState(() {
                        if (_isPause == false) {
                          _isPause = true;
                        }
                        if (_isBreak) {
                          _timerMin = 25 * 60;
                          _isBreak = false;
                        } else {
                          _timerMin = 5 * 60;
                          _isBreak = true;
                        }
                        _controller.restart(duration: _timerMin);
                        _controller.pause();
                      });
                    },
                    textStyle: TextStyle(fontSize: 50.0, color: Colors.amber),
                  ),
                ),
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

  Widget buildRowButtons() {
    if (MediaQuery.of(context).size.width < 342) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
              heroTag: 'btnRestart',
              shape: RoundedRectangleBorder(),
              onPressed: () {
                setState(() {
                  if (_isBreak) {
                    _timerMin = 25 * 60;
                    _isBreak = false;
                    _isPause = true;
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
              // label: Text('   Skip   '),
              label: Center(
                child: Text('skip'),
              ),
              elevation: 0,
            ),
          ),
          Container(
            //TODO Make BUttons nice
            color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: FloatingActionButton(
              heroTag: 'btnBlocked',
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
              highlightElevation: 0,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              elevation: 0,
              child: Icon(
                _isPause ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: 60,
              ),
              backgroundColor: Colors.transparent,
              tooltip: _isPause ? 'Resume' : 'Pause',
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
              heroTag: 'btnBlocked',
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
              label: Center(
                child: Text("Block Apps"),
              ),
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
              heroTag: 'btnBreak',
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
            color: Colors.red,
            width: MediaQuery.of(context).size.width / 3,
            height: 60,
            child: FloatingActionButton(
              heroTag: 'Btnpaused',
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
              highlightElevation: 0,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              elevation: 0,
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
              heroTag: 'Btn-Blocked',
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

class EventsList extends StatefulWidget {
  const EventsList({Key key}) : super(key: key);

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: makeList(Provider.of<EventProvider>(context)),
    );
  }

  List<Widget> makeList(EventProvider eventProvider) {
    List<Widget> texts = <Widget>[];
    List<Event> events = eventProvider.events;
    if (events != null) {
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
                          eventProvider.deleteEvent(el);
                          // provider.refreshEvents();
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
      }
    } else {
      texts.add(Text("Add something to Calender"));
    }
    return texts;
  }
}
