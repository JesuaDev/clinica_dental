import 'dart:math';
import 'package:flutter/material.dart';
//TODO ORGANIZAR LOS IMPORTS 
import 'package:clinica_prodental/presentation/widget/reminders/remindar_datasource_calendar.dart';
import 'package:clinica_prodental/presentation/widget/reminders/upcoming_task.dart';
import 'package:clinica_prodental/helpers/format/date/combinate_date.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';
import 'package:clinica_prodental/presentation/providers/features/auth/data/login_providers.dart';
import 'package:clinica_prodental/presentation/providers/features/reminders/infraestructure/data/reminders_providers.dart';
import 'package:clinica_prodental/presentation/shared/enums/view/enum_type_animation.dart';
import 'package:clinica_prodental/presentation/widget/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

class CalendarReminders extends ConsumerStatefulWidget {
  static const namePage = 'calendar-reminders';
  const CalendarReminders({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalendarRemindersState();
}

class _CalendarRemindersState extends ConsumerState<CalendarReminders> {
  Toats? toats;
  late final ReminderDataSourceCalendar source;
  DateTime? dateSelectedStart = DateTime.now();
  DateTime? dateSelectedEnd = DateTime.now();
  String? _selectedValueInit;
  String? _selectedValueEnd;
  List<String> listHours = [];
  DateTime now = DateTime.now();

  late final TextEditingController controllerTitle;
  late final TextEditingController controllerBody;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(createReminderProvider.notifier).getRemindersCalendar();
      ref.read(createReminderProvider.notifier).getRemindersUpgcoming();
    });
    controllerTitle = TextEditingController();
    controllerBody = TextEditingController();
    source = ReminderDataSourceCalendar([]);
    addListHours();
  }

  void addListHours() {
    listHours.clear();

    for (int hour = 7; hour <= 21; hour++) {
      for (int min = 0; min < 60; min += 30) {
        String hourFormat = hour.toString().padLeft(2, '0');
        String minFormat = min.toString().padLeft(2, '0');

        listHours.add('$hourFormat:$minFormat');
      }
    }
  }

  /*  void resizeWindow() async {
    final Size size = Size(720, 920);
    WidgetsFlutterBinding.ensureInitialized();
    await WindowManager.instance.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: size,
      minimumSize: size,
      maximumSize: size,
      center: true,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();

      await windowManager.setResizable(false);
    });
  } */

  Future<DateTime?> _showCalendar(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: now.copyWith(year: now.year + 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;
    final userProfile = ref.watch(authUserProviders);
    final state = ref.watch(createReminderProvider);

    final remindersUpcoming = state.upcoming;

    //final bool isLaptop = size.width >= 1024 && size.width < 1440;

    ref.listen(createReminderProvider, (previus, next) {
      setState(() {
        source.update(next.reminders ?? []);
      });

      if (next.message != null) {
        setState(() {
          toats = Toats(
            message: next.message!,
            typeAnimation: TypeAnimation.succes,
          );
        });
      }

      if (next.error != null) {
        setState(() {
          toats = Toats(
            message: next.error!.message,
            typeAnimation: TypeAnimation.error,
          );
        });
      }
    });

    return Scaffold(
      backgroundColor: color.onPrimary,
      body: SizedBox(
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: SizedBox(
                    width: size.width * .7,
                    height: size.height,
                    child: CalenderTask(source: source),
                  ),
                ),

                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20, right: 10),

                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsetsGeometry.symmetric(
                            vertical: 20,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: color.secondary,
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              HeaderContentReminder(color: color),
                              SizedBox(height: 20),

                              Wrap(
                                runSpacing: 5,
                                spacing: 5,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final date = await _showCalendar(context);
                                      if (date != null &&
                                          dateSelectedStart != date) {
                                        setState(() {
                                          dateSelectedStart = date;
                                        });
                                      }
                                    },
                                    child: ContainerSelectDate(
                                      color: color,
                                      dateSelected: dateSelectedStart,
                                    ),
                                  ),

                                  SizedBox(width: 15),

                                  GestureDetector(
                                    onTap: () async {
                                      final date = await _showCalendar(context);
                                      if (date != null &&
                                          dateSelectedEnd != date) {
                                        setState(() {
                                          dateSelectedEnd = date;
                                        });
                                      }
                                    },
                                    child: ContainerSelectDate(
                                      color: color,
                                      dateSelected: dateSelectedEnd,
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _dropDownButton(color, (newValue) {
                                      setState(() {
                                        _selectedValueInit = newValue;
                                      });
                                    }, _selectedValueInit),
                                    SizedBox(width: 5),
                                    _dropDownButton(color, (newValue) {
                                      setState(() {
                                        _selectedValueEnd = newValue;
                                      });
                                    }, _selectedValueEnd),
                                  ],
                                ),
                              ),

                              InputFormField(
                                color: color,
                                hintText: 'Titulo...',
                                icon: HugeIcons.strokeRoundedPencilEdit01,
                                controller: controllerTitle,
                              ),

                              InputFormField(
                                color: color,
                                hintText: 'Nota...',
                                icon: HugeIcons.strokeRoundedNote,
                                controller: controllerBody,
                                lines: 2,
                              ),

                              GestureDetector(
                                onTap: () {
                                  debugPrint(controllerBody.text);
                                  if (_selectedValueInit == null ||
                                      _selectedValueEnd == null) {
                                    return ViewDialog.viewDialog(
                                      context,
                                      "Hora No Seleccionada",
                                      "Debe Seleccionar la Hora de Inicio y la Hora de limite ",
                                      TypeAnimation.warning,
                                    );
                                  }
                                  final DateTime dateHourInit =
                                      DateFormater.combineDateAndHour(
                                        dateSelectedStart!,
                                        _selectedValueInit!,
                                      );
                                  final DateTime dateHourEnd =
                                      DateFormater.combineDateAndHour(
                                        dateSelectedEnd!,
                                        _selectedValueEnd!,
                                      );

                                  final DtosReminder dto = DtosReminder(
                                    titleReminder: controllerTitle.text,
                                    descriptionReminder: controllerBody.text,
                                    dateInit: dateHourInit.toIso8601String(),
                                    dateLimit: dateHourEnd.toIso8601String(),
                                    idUser: userProfile.user!.idUser,
                                  );

                                  dateHourEnd.isBefore(dateHourInit) ||
                                          dateHourInit.isAfter(dateHourEnd) ||
                                          dateHourInit.isAtSameMomentAs(
                                            dateHourEnd,
                                          )
                                      ? ViewDialog.viewDialog(
                                          context,
                                          "Fecha Mal Seleccionada",
                                          "La fecha de inicio es mayor a la fecha limite",
                                          TypeAnimation.warning,
                                        )
                                      : ref
                                            .read(
                                              createReminderProvider.notifier,
                                            )
                                            .postReminder(dto);

                                  controllerTitle.clear();
                                  controllerBody.clear();
                                  dateSelectedStart = DateTime.now();
                                  dateSelectedEnd = DateTime.now();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 15,
                                  ),
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: color.primary,
                                  ),

                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        HugeIcon(
                                          icon: HugeIcons
                                              .strokeRoundedCalendarAdd01,
                                          color: Colors.white70,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Guardar recordatorio",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(top: 20),
                            child: UpcomingTask(
                              remindersUpcoming: remindersUpcoming ?? [],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (toats != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: toats,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Expanded _dropDownButton(
    ColorScheme color,
    ValueChanged<String?> onChanged,
    String? selected,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.onPrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: DropdownButton(
          hint: Text('Hora.'),
          icon: Container(
            margin: EdgeInsets.only(left: 10),
            child: HugeIcon(icon: HugeIcons.strokeRoundedClock01),
          ),

          underline: SizedBox.shrink(),
          mouseCursor: SystemMouseCursors.click,
          dropdownMenuItemMouseCursor: SystemMouseCursors.click,

          value: selected,
          items: listHours.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class InputFormField extends StatelessWidget {
  const InputFormField({
    super.key,
    required this.color,
    required this.hintText,
    required this.controller,
    this.icon,
    this.lines = 1,
  });

  final ColorScheme color;
  final String hintText;
  final TextEditingController controller;
  final dynamic icon;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),

      child: TextFormField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          fillColor: color.onPrimary,

          filled: true,
          prefixIcon: Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
            child: SizedBox(
              width: 50,
              child: HugeIcon(icon: icon, color: color.onSecondary),
            ),
          ),

          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          hintText: hintText,
          hintStyle: TextStyle(color: color.onSecondary),
          contentPadding: EdgeInsets.only(left: 30, top: 20, bottom: 20),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.transparent),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: color.primary),
          ),
        ),
      ),
    );
  }
}

class ContainerSelectDate extends StatelessWidget {
  const ContainerSelectDate({
    super.key,
    required this.color,
    required this.dateSelected,
  });

  final ColorScheme color;
  final DateTime? dateSelected;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: color.onPrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            HugeIcon(icon: HugeIcons.strokeRoundedCalendar01),

            SizedBox(width: 10),

            Text(
              dateSelected != null
                  ? DateFormat.MEd().format(dateSelected!)
                  : '',
              style: TextStyle(
                color: color.onSecondary,
                fontSize: 18,
                fontFamily: 'sora-light',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderContentReminder extends StatelessWidget {
  const HeaderContentReminder({super.key, required this.color});

  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Recordatorios",
          style: TextStyle(
            color: color.onSecondary,
            fontFamily: 'sora-regular',
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),

        HugeIcon(icon: HugeIcons.strokeRoundedNote01),
      ],
    );
  }
}
