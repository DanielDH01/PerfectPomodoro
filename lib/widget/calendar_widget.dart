import 'package:flutter/material.dart';
import 'package:perfectpomodoro/model/event.dart';
import 'package:perfectpomodoro/model/event_data_source.dart';
import 'package:perfectpomodoro/provider/event_provider.dart';
import 'package:perfectpomodoro/widget/tasks_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// ignore: must_be_immutable
class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventsProvider = Provider.of<EventProvider>(context);
    List<Event> events = eventsProvider.events;
    
    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onLongPress: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date);
        showModalBottomSheet(
          context: context,
          builder: (context) => TasksWidget(),
        );
      },
      onTap: (details) => {
        eventsProvider
            .setDate(details.date.add(Duration(hours: DateTime.now().hour))),
      },
    );
  }
}

// // ignore: must_be_immutable
// class CalendarWidget extends StatelessWidget {
//   List<Event> events;

//   Future refreshEvents(EventProvider eventProvider) async {
//     this.events = eventProvider.events;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final eventsProvider = Provider.of<EventProvider>(context);
//     refreshEvents(eventsProvider);
//     return SfCalendar(
//       view: CalendarView.month,
//       dataSource: EventDataSource(events),
//       initialSelectedDate: DateTime.now(),
//       cellBorderColor: Colors.transparent,
//       onLongPress: (details) {
//         final provider = Provider.of<EventProvider>(context, listen: false);

//         provider.setDate(details.date);
//         showModalBottomSheet(
//           context: context,
//           builder: (context) => TasksWidget(),
//         );
//       },
//       onTap: (details) => {
//         eventsProvider
//             .setDate(details.date.add(Duration(hours: DateTime.now().hour))),
//       },
//     );
//   }
// }
