import 'package:flutter/material.dart';
import 'package:perfectpomodoro/model/event_data_source.dart';
import 'package:perfectpomodoro/provider/event_provider.dart';
import 'package:perfectpomodoro/widget/tasks_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventsProvider = Provider.of<EventProvider>(context);

    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(eventsProvider.events),
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
