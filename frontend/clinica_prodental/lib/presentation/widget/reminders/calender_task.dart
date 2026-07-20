import 'package:clinica_prodental/presentation/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clinica_prodental/presentation/widget/reminders/remindar_datasource_calendar.dart';
import 'package:clinica_prodental/presentation/providers/features/reminders/infraestructure/data/reminders_providers.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:clinica_prodental/core/theme/app_colors.dart';

//? Cuadro de dialogo

class CalenderTask extends ConsumerStatefulWidget {
  final ReminderDataSourceCalendar source;
  const CalenderTask({super.key, required this.source});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarTaskState();
}

class _CalendarTaskState extends ConsumerState<CalenderTask> {
  final List<Color> listColor = AppColors.colors;
  late CalendarController calendarController = CalendarController();
  DateTime current = DateTime.now();
  double offset = 0;

  @override
  void initState() {
    super.initState();

    //calendarController.displayDate = DateTime.now();
  }

  List<DateTime> _currentWeek({required DateTime date}) {
    final first = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(6, (index) => first.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    //? Provider
    final reminders = ref.watch(createReminderProvider);

    final color = Theme.of(context).colorScheme;
    final currentDays = _currentWeek(date: current);

    final TextStyle textHeaderCalender = TextStyle(
      fontFamily: 'sora-light',
      fontWeight: FontWeight.w100,
      fontSize: 20,
    );

    final double startHour = 7;
    final double endHour = 21;
    final double intervalHeight = 120;

    //?Este es el date Time
    //  final currentDate = calendarController.displayDate ?? DateTime.now();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: color.secondary,
        borderRadius: BorderRadius.circular(50),
      ),

      child: Column(
        children: [
          _ContentHeaderMonth(
            current: current,
            textHeaderCalender: textHeaderCalender,
            color: color,
          ),

          ContentHeaderDays(
            currentDays: currentDays,
            textHeaderCalender: textHeaderCalender,
            color: color,
          ),

          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                setState(() {
                  offset = notification.metrics.pixels;
                });

                return false;
              },

              child: SizedBox(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Transform.translate(
                        offset: Offset(0, -offset),
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: DottedLinesPainter(
                              intervalHeight: intervalHeight,
                              startHour: startHour,
                              endHour: endHour,
                              color: color.onSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    reminders.reminders!.isEmpty
                        ? LoaderIcon()
                        : SfCalendar(
                            //? Ver el tipo de calendario, Año, dia,Semana, etc...
                            key: ValueKey(reminders.reminders!.length),
                            view: CalendarView.workWeek,
                            controller: calendarController,
                            backgroundColor: color.secondary.withOpacity(.5),
                            monthViewSettings: MonthViewSettings(
                              showAgenda: false,
                            ),
                            firstDayOfWeek: 1,
                            headerHeight: 0,
                            viewHeaderHeight: 0,
                            cellEndPadding: 5,
                            cellBorderColor: Colors.transparent,

                            //? Tiempo del trabajo
                            timeSlotViewSettings: TimeSlotViewSettings(
                              startHour: startHour,
                              endHour: endHour,
                              timeIntervalHeight: intervalHeight.toDouble(),
                              timeRulerSize: 60,

                              numberOfDaysInView: 6,
                              nonWorkingDays: <int>[DateTime.sunday],
                            ),

                            //? Titulo (Donde va el mes)
                            headerStyle: CalendarHeaderStyle(
                              backgroundColor: color.secondary,
                              textStyle: textHeaderCalender.copyWith(
                                fontSize: 30,
                              ),
                            ),

                            viewHeaderStyle: ViewHeaderStyle(
                              dateTextStyle: textHeaderCalender.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            todayHighlightColor: color.secondary,
                            todayTextStyle: textHeaderCalender.copyWith(
                              fontSize: 18,
                              color: color.primary,
                            ),

                            dataSource: widget.source,

                            onViewChanged: (ViewChangedDetails details) {
                              final newDate =
                                  details.visibleDates[details
                                          .visibleDates
                                          .length ~/
                                      2];
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() {
                                    current = newDate;
                                  });
                                }
                              });
                            },

                            appointmentBuilder: (context, details) {
                              final Appointment appointment =
                                  details.appointments.first;

                              final color =
                                  AppColors.colors[appointment
                                          .subject
                                          .hashCode %
                                      AppColors.colors.length];

                              return SizedBox(
                                width: details.bounds.width,
                                height: details.bounds.height,
                                child: ContainerTask(
                                  heightTask: details.bounds.height,
                                  color: color,
                                  title: appointment.subject,
                                  notes: appointment.notes,
                                  dateInit: appointment.startTime,
                                  dateFin: appointment.endTime,
                                  widthTask: details.bounds.width,
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerTask extends StatelessWidget {
  final double widthTask;
  final double heightTask;
  final Color color;
  final String title;
  final String? notes;
  final DateTime dateInit;
  final DateTime dateFin;

  const ContainerTask({
    super.key,
    required this.color,
    required this.title,
    required this.notes,
    required this.dateInit,
    required this.dateFin,
    required this.heightTask,
    required this.widthTask,
  });

  @override
  Widget build(BuildContext context) {
    final isAfter = dateFin.isAfter(DateTime.now());
    final colorTheme = Theme.of(context).colorScheme;

    final compact = heightTask < 90;

    return Container(
      height: heightTask,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 6 : 15,
      ),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black26)],
      ),

      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isAfter
                ? Bounce(
                    infinite: true,
                    duration: const Duration(milliseconds: 800),
                    from: 5,
                    child: Container(
                      width: 10,
                      height: 10,
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: colorTheme.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  )
                : SizedBox.shrink(),

            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontFamily: 'sora-regular',
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),

            !(heightTask < 120 || widthTask < 90)
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      notes ?? "No hay descripción",
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'sora-light',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )
                : SizedBox.shrink(),

            !compact
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "${DateFormat.Hm().format(dateInit)} - ${DateFormat.Hm().format(dateFin)}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'sora-light',
                        fontSize: compact ? 11 : 14,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class DottedLinesPainter extends CustomPainter {
  final double intervalHeight;
  final double startHour;
  final double endHour;
  final Color color;

  DottedLinesPainter({
    required this.intervalHeight,
    required this.startHour,
    required this.endHour,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    final totalHours = (endHour - startHour).toInt();

    for (int i = 1; i < totalHours; i++) {
      final y = i * intervalHeight;

      double startX = 60;

      while (startX < size.width - 60) {
        canvas.drawLine(Offset(startX, y), Offset(startX + 4, y), paint);

        startX += 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ContentHeaderDays extends StatelessWidget {
  const ContentHeaderDays({
    super.key,
    required this.currentDays,
    required this.textHeaderCalender,
    required this.color,
  });

  final List<DateTime> currentDays;
  final TextStyle textHeaderCalender;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 60),
      child: Row(
        spacing: 5,
        children: List.generate(6, (index) {
          final date = currentDays[index];

          final bool isToday =
              date.day == DateTime.now().day &&
              date.month == DateTime.now().month;

          final styleTextHeaderWeek = textHeaderCalender.copyWith(
            fontSize: 18,
            color: isToday ? color.onPrimary : color.onSecondary,
          );

          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isToday ? color.onSecondary : color.onPrimary,
                borderRadius: BorderRadius.circular(18),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E('en').format(date),
                    style: styleTextHeaderWeek,
                  ),
                  SizedBox(width: 5),
                  Text(date.day.toString(), style: styleTextHeaderWeek),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ContentHeaderMonth extends StatelessWidget {
  const _ContentHeaderMonth({
    required this.current,
    required this.textHeaderCalender,
    required this.color,
  });

  final DateTime current;
  final TextStyle textHeaderCalender;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      width: double.infinity,
      height: 80,
      color: color.secondary,
      child: Text(
        DateFormat.yMMMM('en').format(current),
        style: textHeaderCalender.copyWith(
          color: color.onSecondary,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
