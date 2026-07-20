//?Framework Imports
import 'dart:math';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/citas_count_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/citas/appoitments_state.dart';
import 'package:flutter/material.dart';

//?External Imports
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clinica_prodental/core/theme/app_colors.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/presentation/shared/shared.dart';
import 'package:clinica_prodental/presentation/widget/widgets.dart';
import 'package:clinica_prodental/helpers/format/date/hour_formater.dart';
import 'package:clinica_prodental/presentation/screens/px/px_screen.dart';
import 'package:clinica_prodental/presentation/providers/custom/preferences/type_layout_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/cita_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/citas/cita_state.dart';

class CitasScreen extends StatelessWidget {
  static const String namePage = 'citas';

  const CitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Row(children: [CustomAppBar(), ContentCita()]));
  }
}

class ContentCita extends ConsumerStatefulWidget {
  const ContentCita({super.key});

  @override
  ConsumerState<ContentCita> createState() => _ContentCitaState();
}

class _ContentCitaState extends ConsumerState<ContentCita> {
  Toats? toats;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(citasProvider.notifier).loadCitas();
      ref.read(citasProvider.notifier).loadCitaUpcoming();
    });
  }

  Widget wrapperGenInformation(Widget child, ColorScheme color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: color.onSecondary.withValues(alpha: .12)),
        borderRadius: BorderRadius.circular(15),
      ),

      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(citasProvider, (previus, next) {
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

    //? Theme
    final ColorScheme color = Theme.of(context).colorScheme;
    //? Providers
    final citasProv = ref.watch(citasProvider);
    final selectedLayoutProvider = ref.watch(typeLayoutProvider);
    final appointmentCount = ref.watch(appointmentsCount);
    /*   final double childAspectRatio = Endpoints.isDesktop(context)
        ? 1.1
        : Endpoints.isTablet(context)
        ? .8
        : .5;

    final double maxCrossAxisExtent = Endpoints.isDesktop(context) ? 400 : 500; */

    return Expanded(
      child: citasProv.isLoading!
          ? LoaderIcon()
          : SizedBox(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        ContentHeader(title: "Citas"),
                        ContentFiltersRegister(
                          color: color,
                          dataDropDown: [],
                          onOpenDialog: (context) {},
                          titleButton: 'Cita',
                          hintText: 'Buscar cita...(Id)',
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                selectedLayoutProvider == LayoutType.grid
                                    ? ListLayoutView(
                                        citasProv: citasProv,
                                        color: color,
                                      )
                                    : Expanded(child: ListView()),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          wrapperGenInformation(
                                            TableCalendar(
                                              focusedDay: DateTime.now(),
                                              firstDay: DateTime(2025),
                                              lastDay: DateTime(2400),
                                              headerStyle: HeaderStyle(
                                                formatButtonVisible: false,
                                                titleCentered: true,
                                              ),
                                            ),
                                            color,
                                          ),
                                          SizedBox(height: 10),

                                          wrapperGenInformation(
                                            ContentSummary(
                                              color: color,
                                              appoitmentsCount:
                                                  appointmentCount,
                                            ),
                                            color,
                                          ),

                                          SizedBox(height: 10),
                                          wrapperGenInformation(
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Próxima cita",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                citasProv.citaUpcoming != null
                                                    ? Row(children: [
                                                      
                                                  ],
                                                )
                                                    : SizedBox(
                                                        width: double.infinity,
                                                        child: MessageEmptyData(
                                                          widthLottie: 100,
                                                          message:
                                                              "No hay próximas citas por el momento...",
                                                          color: color,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            color,
                                          ),
                                        ],
                                      ),
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
                      Align(alignment: Alignment.bottomRight, child: toats),

                    if (citasProv.pagination != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Pagination(
                          onChangePage: (page) {
                            ref
                                .read(citasProvider.notifier)
                                .loadCitas(page: page);
                          },
                          totalPages: citasProv.pagination!.totalPages,
                          page: citasProv.pagination!.page,
                          hasNext: citasProv.pagination!.hasNext,
                          hasPrevius: citasProv.pagination!.hasPrevius,
                          colorTheme: color,
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ContentSummary extends StatelessWidget {
  const ContentSummary({
    super.key,
    required this.color,
    required this.appoitmentsCount,
  });
  final ColorScheme color;
  final AppoitmentsState appoitmentsCount;

  @override
  Widget build(BuildContext context) {
    final String now = DateFormat.yMMMEd('es').format(DateTime.now());

    return Column(
      children: [
        ItemSummary(
          infoSummary: now,
          titleSummary: 'Resumen del dia',
          colorScheme: color,
          isHeader: true,
        ),
        SizedBox(height: 8),
        ItemSummary(
          infoSummary: "${appoitmentsCount.scheduled}",
          titleSummary: 'Citas programadas',
          icon: HugeIcons.strokeRoundedCalendar02,
          colorIcon: color.onSecondary.withValues(alpha: .6),
          colorScheme: color,
        ),

        ItemSummary(
          infoSummary: "${appoitmentsCount.complete}",
          titleSummary: 'Completado(s)',
          icon: HugeIcons.strokeRoundedCheckmarkCircle01,
          colorIcon: color.primary,
          colorScheme: color,
        ),

        ItemSummary(
          infoSummary: "${appoitmentsCount.wait}",
          titleSummary: 'Pendiente(s)',
          icon: HugeIcons.strokeRoundedTimeHalfPass,
          colorIcon: Colors.yellowAccent,
          colorScheme: color,
        ),

        ItemSummary(
          infoSummary: "${appoitmentsCount.postponed}",
          titleSummary: 'Pospuesto(s)',
          icon: HugeIcons.strokeRoundedTimeline,
          colorIcon: Colors.deepOrange,
          colorScheme: color,
        ),

        ItemSummary(
          infoSummary: "${appoitmentsCount.cancel}",
          titleSummary: 'Cancelado(s)',
          icon: HugeIcons.strokeRoundedCancelCircle,
          colorIcon: color.error,
          colorScheme: color,
        ),
      ],
    );
  }
}

class ItemSummary extends StatelessWidget {
  const ItemSummary({
    super.key,
    required this.infoSummary,
    required this.titleSummary,
    this.icon,
    this.isHeader = false,
    required this.colorScheme,
    this.colorIcon = Colors.black,
  });

  final String infoSummary;
  final String titleSummary;
  final dynamic icon;
  final bool isHeader;
  final ColorScheme colorScheme;
  final Color colorIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: isHeader ? 0 : 5),
      child: Row(
        children: [
          icon != null
              ? Container(
                  margin: EdgeInsets.only(right: 10),
                  child: HugeIcon(icon: icon, color: colorIcon),
                )
              : SizedBox.shrink(),
          Text(
            titleSummary,
            style: TextStyle(
              fontSize: isHeader ? 17 : 14,
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
              color: isHeader
                  ? colorScheme.onSecondary
                  : colorScheme.onSecondary.withValues(alpha: .6),
            ),
          ),
          Spacer(),
          Text(infoSummary),
        ],
      ),
    );
  }
}

class ListLayoutView extends StatelessWidget {
  const ListLayoutView({
    super.key,
    required this.citasProv,
    required this.color,
  });

  final CitaState citasProv;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 20),
        child: ListView.builder(
          itemCount: citasProv.citas!.length,
          itemBuilder: (context, index) {
            final int indexRandom = Random().nextInt(AppColors.colors.length);

            final cita = citasProv.citas![index];

            final List<String> shortName = cita.px!.fullNamePx.toString().split(
              ' ',
            );

            final int age =
                DateTime.now().year -
                (cita.px!.birthdatePx != null
                    ? DateTime.parse("${cita.px!.birthdatePx!}").year
                    : DateTime.now().year);

            final double heightCard = 120;

            return ContentCardCita(
              heightCard: heightCard,
              color: color,
              indexRandom: indexRandom,
              cita: cita,
              age: age,
              shortName: shortName,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class ContentCardCita extends StatelessWidget {
  const ContentCardCita({
    super.key,
    required this.heightCard,
    required this.color,
    required this.indexRandom,
    required this.cita,
    required this.age,
    required this.shortName,
    required this.index,
  });

  final double heightCard;
  final ColorScheme color;
  final int indexRandom;
  final CitaEntity cita;
  final int age;
  final List<String> shortName;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 350),
      delay: Duration(milliseconds: index * 50),
      child: Expanded(
        child: Container(
          height: heightCard,
          padding: EdgeInsets.only(top: 15, bottom: 15, right: 10),

          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2,
              color: color.onSecondary.withValues(alpha: .05),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 2,
                height: heightCard,
                decoration: BoxDecoration(color: AppColors.colors[indexRandom]),
              ),
              SizedBox(width: 10),

              DateHourCita(
                cita: cita,
                date: cita.dateCita,
                hour: cita.hourCita,
                color: color,
              ),

              SizedBox(width: 40),
              AvatarCita(indexRandom: indexRandom, cita: cita),

              SizedBox(width: 20),

              ContentBasicInformationPx(
                age: age,
                color: color,
                sex: cita.px!.sexPx!,
                shortName:
                    "${shortName.first} ${shortName[shortName.length - 2]} (PX${cita.px!.idPx})",
                idPx: cita.px!.idPx,
                phone: "+504 ${cita.px!.phone}",
                colorSubtitle: color.onSecondary.withValues(alpha: .6),
              ),

              SizedBox(width: 80),
              Container(
                width: 1,
                height: heightCard,
                color: color.onSecondary.withValues(alpha: .12),
              ),
              SizedBox(width: 40),
              ContentInformationCita(cita: cita, color: color),
              SizedBox(width: 40),
              ActionButtonMore(colorTheme: color),
              SizedBox(width: 10),
              ButtonAction(
                color: color,
                onTapButton: () {},
                icon: HugeIcons.strokeRoundedMoreHorizontal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonAction extends StatefulWidget {
  const ButtonAction({
    super.key,
    required this.color,
    this.icon,
    required this.onTapButton,
  });

  final ColorScheme color;
  final dynamic icon;
  final VoidCallback onTapButton;

  @override
  State<ButtonAction> createState() => _ButtonActionState();
}

class _ButtonActionState extends State<ButtonAction> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTapButton,
      onHover: (hover) {
        setState(() {
          isHover = hover;
        });
      },
      mouseCursor: SystemMouseCursors.click,

      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isHover
                ? Colors.transparent
                : widget.color.onSecondary.withValues(alpha: .2),
          ),
          color: isHover ? widget.color.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: HugeIcon(
          icon: widget.icon,
          size: 25,
          color: isHover
              ? Colors.white70
              : widget.color.onSecondary.withValues(alpha: .7),
        ),
      ),
    );
  }
}

class ContentInformationCita extends StatelessWidget {
  const ContentInformationCita({
    super.key,
    required this.cita,
    required this.color,
  });

  final CitaEntity cita;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cita.reasonDate,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),

        SizedBox(height: 5),

        SizedBox(
          width: 200,
          child: SubTitleText(
            subtitle: cita.observation ?? 'No hay observacion previa...',
            lines: 2,
            color: color,
          ),
        ),
        Spacer(),

        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: color.primary.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(15),
          ),

          child: Text(
            "Completada",
            style: TextStyle(color: color.primary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class AvatarCita extends StatelessWidget {
  const AvatarCita({super.key, required this.indexRandom, required this.cita});

  final int indexRandom;
  final CitaEntity cita;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,

      decoration: BoxDecoration(
        color: AppColors.colors[indexRandom],
        borderRadius: BorderRadius.circular(50),
      ),

      child: Center(
        child: Text(
          "CT${cita.idCita}",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}

class DateHourCita extends StatelessWidget {
  final String date;
  final String hour;
  final ColorScheme color;
  const DateHourCita({
    super.key,
    required this.cita,
    required this.date,
    required this.hour,
    required this.color,
  });

  final CitaEntity cita;

  @override
  Widget build(BuildContext context) {
    final DateTime dateParse = DateTime.parse(date);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          HourFormater.hourAmPm(hour),

          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),

        SubTitleText(
          subtitle: DateFormat.MMMEd('es').format(dateParse),
          color: color,
        ),
      ],
    );
  }
}

class ContentBasicInformationPx extends StatelessWidget {
  const ContentBasicInformationPx({
    super.key,

    required this.age,
    required this.color,
    required this.sex,
    required this.shortName,
    required this.idPx,
    required this.phone,
    required this.colorSubtitle,
  });

  final String sex;
  final String shortName;
  final int idPx;
  final String phone;
  final int age;
  final ColorScheme color;
  final Color colorSubtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(shortName, style: TextStyle(fontSize: 18)),
        SizedBox(height: 2),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "$age años "),

              TextSpan(text: "  •  "),
              TextSpan(text: sex),
            ],
            style: TextStyle(color: colorSubtitle, fontSize: 13),
          ),
        ),
        SizedBox(height: 2),
        Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedCall02,
              size: 16,
              color: colorSubtitle,
            ),
            SizedBox(width: 4),
            SubTitleText(subtitle: phone, color: color),
          ],
        ),
      ],
    );
  }
}

class SubTitleText extends StatelessWidget {
  const SubTitleText({
    super.key,
    required this.subtitle,
    required this.color,
    this.lines = 1,
  });

  final String subtitle;
  final ColorScheme color;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: TextStyle(
        color: color.onSecondary.withValues(alpha: .6),
        fontSize: 13,
      ),
      maxLines: lines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ActionButtonMore extends StatefulWidget {
  const _ActionButtonMore({required this.colorTheme});

  final ColorScheme colorTheme;

  @override
  State<_ActionButtonMore> createState() => _ActionButtonMoreState();
}

class _ActionButtonMoreState extends State<_ActionButtonMore> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle styleItemsText = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w200,
      color: widget.colorTheme.onSecondary.withValues(alpha: .6),
      letterSpacing: 1,
    );

    return PopupMenuButton<ActionsRegisters>(
      surfaceTintColor: Colors.transparent,
      splashRadius: 0,
      tooltip: "",
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
      ),

      onSelected: (value) {
        switch (value) {
          case ActionsRegisters.details:
            break;
          case ActionsRegisters.update:
            break;
          case ActionsRegisters.delete:
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ActionsRegisters.details,
          child: Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedProfile),
              SizedBox(width: 8),
              Text("Ver detalles", style: styleItemsText),
            ],
          ),
        ),
        PopupMenuItem(
          value: ActionsRegisters.update,
          child: Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedEdit01),
              SizedBox(width: 8),
              Text("Actualizar", style: styleItemsText),
            ],
          ),
        ),
        PopupMenuItem(
          value: ActionsRegisters.delete,
          child: Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedDelete01),
              SizedBox(width: 8),
              Text("Eliminar", style: styleItemsText),
            ],
          ),
        ),
      ],
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() {
          isHover = true;
        }),
        onExit: (_) => setState(() {
          isHover = false;
        }),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isHover
                ? widget.colorTheme.primary.withValues(alpha: .6)
                : Colors.transparent,
            border: Border.all(
              width: 2,
              color: widget.colorTheme.secondary.withValues(alpha: .5),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: HugeIcon(icon: HugeIcons.strokeRoundedMoreHorizontal),
        ),
      ),
    );
  }
}
