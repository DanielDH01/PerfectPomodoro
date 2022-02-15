import 'package:flutter/material.dart';
import 'package:perfectpomodoro/model/event.dart';
import 'package:perfectpomodoro/model/event_data_source.dart';
import 'package:perfectpomodoro/page/event_viewing_page.dart';
import 'package:perfectpomodoro/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TasksWidget extends StatefulWidget {
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  List<Event> eventList;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    eventList = provider.events;
    if (eventList.isEmpty) {
      return Center(
        child: Text(
          'No Events Found!',
          style: TextStyle(color: Colors.amber, fontSize: 24),
        ),
      );
    }
    // SfCalendarTheme(
    //   data: SfCalendarThemeData(),
    //   child:
    return SfCalendar(
      headerHeight: 0,
      view: CalendarView.timelineDay,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appointmentBuilder,
      onTap: (details) {
        if (details.appointments == null) return;

        final event = details.appointments.first;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventViewingPage(event: event),
          ),
        );
      },
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: Colors.purple.withAlpha(80),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        event.title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
