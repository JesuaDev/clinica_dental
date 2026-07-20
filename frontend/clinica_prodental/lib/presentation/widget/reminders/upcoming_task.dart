import 'package:flutter/material.dart';

import 'package:clinica_prodental/core/theme/app_colors.dart';
import 'package:clinica_prodental/domain/entities/calendar/calendar_entity.dart';
import 'package:clinica_prodental/helpers/format/date/combinate_date.dart';

import '../widgets.dart';

class UpcomingTask extends StatelessWidget {
  final List<CalendarEntity> remindersUpcoming;
  const UpcomingTask({super.key, required this.remindersUpcoming});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: color.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Próximos recordatorios",
            style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w600,
            
            ),
          ),

          SizedBox(height: 10),

          remindersUpcoming.isEmpty
              ? SizedBox(
                  width: double.infinity,
                  child: MessageEmptyData(
                    widthLottie: 150,
                    message: "No hay recordatorios por el momento.",
                    color: color,
                  ),
                )
              : Expanded(
            child: ListView.builder(
              itemCount: remindersUpcoming.length,
              itemBuilder: (context, index) {
                final Color colorRandom =
                    AppColors.colors[(index % remindersUpcoming.length) >= 5
                        ? 2
                        : index % remindersUpcoming.length];
                final reminder = remindersUpcoming[index];
                return _TileUpcomingReminder(
                  colorRandom: colorRandom,
                  reminder: reminder,
                  color: color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TileUpcomingReminder extends StatelessWidget {
  const _TileUpcomingReminder({
    required this.colorRandom,
    required this.reminder,
    required this.color,
  });

  final Color colorRandom;
  final CalendarEntity reminder;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, right: 12, bottom: 10),
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.6, 1],
          colors: [colorRandom.withValues(alpha: .2), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 2,
            height: 30,
            decoration: BoxDecoration(
              color: colorRandom,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reminder.titleReminder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${DateFormater.formatDateHour(reminder.dateInit)} - ${DateFormater.formatDateHour(reminder.dateLimit)}",
                style: TextStyle(
                  color: color.onSecondary.withValues(alpha: .4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
