import 'package:flutter/material.dart';
import 'package:perfectpomodoro/model/event.dart';
import 'package:perfectpomodoro/page/event_editing_page.dart';
import 'package:perfectpomodoro/provider/event_provider.dart';
import 'package:perfectpomodoro/utils.dart';
import 'package:provider/provider.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({
    Key key,
    @required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildViewingActions(context, event),
        ),
        body: buildInformation(),

        ///TODO Make description and all day
        //,
      );
  Widget buildInformation() => Column(
        children: [
          titleInfo(),
          SizedBox(
            height: 12,
          ),
          buildDateTimeInfo()
          // allDayInfo(),
        ],
      );

  Widget buildDateTimeInfo() => Column(
        children: [
          buildFromInfo(),
          buildToInfo(),
        ],
      );

  Widget buildFromInfo() => buildHeader(
        header: '  FROM',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text(Utils.toDate(event.from).toString()),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(Utils.toTime(event.from).toString()),
              ),
            ),
          ],
        ),
      );

  Widget buildToInfo() => buildHeader(
        header: '  TO',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text(Utils.toDate(event.to).toString()),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(Utils.toTime(event.to).toString()),
              ),
            ),
          ],
        ),
      );

  Widget titleInfo() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.(value),
          focusedBorder: InputBorder.none,
          hintText: "   " + event.title,
          hintStyle: TextStyle(),

          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: ' Title: ',
          labelStyle: TextStyle(color: Colors.orangeAccent),
        ),
        readOnly: true,
      );

  List<Widget> buildViewingActions(BuildContext context, Event event) => [
        IconButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EventEditingPage(event: event),
            ),
          ),
          icon: Icon(Icons.edit),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            final provider = Provider.of<EventProvider>(context, listen: false);

            provider.deleteEvent(event);
            Navigator.of(context).pop();
          },
        ),
      ];

  Widget buildHeader({@required String header, @required Widget child}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          child
        ],
      );

  //TODO
  // Widget buildDateTime(Event event) {
  //   return Column(
  //     children: [
  //       buildDate(event.isAllDay ? 'All-Day' : 'From', event.from),
  //       if (!event.isAllDay) buildDate('To', event.to),
  //     ],
  //   );
  // }
}
