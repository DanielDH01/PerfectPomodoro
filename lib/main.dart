import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:perfectpomodoro/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../agenda.dart' as agenda;

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
  int _timerMin = 25 * 60;

  @override
  Widget build(BuildContext context) {
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
      body: Center(
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
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton.extended(
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
          icon: Icon(_isPause ? Icons.play_arrow : Icons.pause),
          label: Text(_isPause ? 'Resume' : 'Pause'),
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton.extended(
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
          label: Text('Skip'),
        )
      ]),
    );
  }
}
