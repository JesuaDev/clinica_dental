import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:clinica_prodental/presentation/screens/citas/citas_screen.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/px_provider.dart';
import 'package:clinica_prodental/presentation/screens/px/px_details_screen.dart';
import 'package:clinica_prodental/presentation/screens/px/dialog/view_dialog_form_px.dart';

import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clinica_prodental/presentation/widget/widgets.dart';
import 'package:clinica_prodental/core/theme/app_colors.dart';
import 'package:clinica_prodental/presentation/shared/shared.dart';
import 'package:clinica_prodental/presentation/providers/custom/preferences/type_layout_provider.dart';
import 'package:clinica_prodental/core/utils/responsive/endpoints.dart';
import 'package:intl/intl.dart';

const List<String> dataDropDown = [
  "Todos los pacientes",
  "A - Z",
  "Z - A",
  "Registros recientes",
  "Registros antiguos",
  "Proxima cita",
  "Sexo",
  "Mas frecuentes",
];

class PxScreen extends ConsumerStatefulWidget {
  static const String namePage = 'pantient';
  const PxScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PxScreenState();
}

class _PxScreenState extends ConsumerState<PxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Row(children: [CustomAppBar(), _ContentPx()]));
  }
}

class _ContentPx extends ConsumerStatefulWidget {
  const _ContentPx();

  @override
  ConsumerState<_ContentPx> createState() => _ContentPxState();
}

class _ContentPxState extends ConsumerState<_ContentPx> {
  Toats? toats;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pxProvider.notifier).getPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(pxProvider);
    final selectedLayoutProvider = ref.watch(typeLayoutProvider);
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

    ref.listen(pxProvider, (previus, next) {
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

    final double childAspectRatio = Endpoints.isDesktop(context)
        ? 1.1
        : Endpoints.isTablet(context)
        ? .8
        : .5;

    final double maxCrossAxisExtent = Endpoints.isDesktop(context) ? 400 : 500;

    return (patients.isLoading == true)
        ? Expanded(child: Center(child: LoaderIcon()))
        : Expanded(
            child: SizedBox(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        ContentHeader(title: "Pacientes"),

                        patients.error != null
                            ? ViewError(
                                statusCode: patients.error!.status,
                                message: patients.error!.message,
                              )
                            : ContentFiltersRegister(
                                color: colorTheme,
                                dataDropDown: dataDropDown,
                                onOpenDialog: (BuildContext context) {
                                  ViewDialogFormPx.showDialogFormPx(context);
                                },
                                titleButton: 'Paciente',
                                hintText: 'Buscar paciente...',
                              ),

                        selectedLayoutProvider == LayoutType.grid
                            ? Expanded(
                                child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    vertical: 15,
                                  ),
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent:
                                              maxCrossAxisExtent,
                                          childAspectRatio: childAspectRatio,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                        ),
                                    itemCount: patients.data!.length,
                                    itemBuilder: (context, index) {
                                      final patient = patients.data![index];

                                      //*? Como el nombre completo viene en un solo campo entonces separamos los nombres
                                      final nameSeparate = patient.fullNamePx
                                          .toString()
                                          .split(' ');

                                      //? Index random para el app color para que tenga diferentes colores el avatar del card
                                      final int indexRandom = Random().nextInt(
                                        AppColors.colors.length,
                                      );
                                      //? Calcular que edad tiene el px
                                      final int age =
                                          DateTime.now().year -
                                          (patient.birthdatePx != null
                                              ? DateTime.parse(
                                                  "${patient.birthdatePx!}",
                                                ).year
                                              : DateTime.now().year);

                                      return ContentGridCards(
                                        colorTheme: colorTheme,
                                        indexRandom: indexRandom,
                                        patient: patient,
                                        nameSeparate: nameSeparate,
                                        age: age,
                                        index: index,
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CellTable(content: "Id", flex: 0),
                                          CellTable(
                                            content: "Nombres/Apellidos",
                                            flex: 2,
                                          ),
                                          CellTable(content: "Edad", flex: 1),
                                          CellTable(content: "Sexo", flex: 1),
                                          CellTable(
                                            content: "Teléfono",
                                            flex: 1,
                                          ),
                                          CellTable(
                                            content: "Dirección",
                                            flex: 2,
                                          ),
                                          CellTable(
                                            content: "Actividad",
                                            flex: 1,
                                          ),
                                          CellTable(
                                            content: "Última cita",
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: patients.data!.length,
                                          itemBuilder: (context, index) {
                                            final patient =
                                                patients.data![index];

                                            final now = DateTime.now();

                                            final fourMonthsAgo = DateTime(
                                              now.year,
                                              now.month - 6,
                                              now.day,
                                            );

                                            final isActive =
                                                patient.lastAppointmentDate !=
                                                    null &&
                                                patient.lastAppointmentDate!
                                                    .isAfter(fourMonthsAgo);

                                            return Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: colorTheme.onSecondary
                                                      .withValues(alpha: 0.07),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  CellTable(
                                                    content: patient.idPx
                                                        .toString(),
                                                    flex: 0,
                                                    isHeader: false,
                                                  ),
                                                  CellTable(
                                                    content: patient.fullNamePx
                                                        .toString(),
                                                    flex: 2,
                                                    isHeader: false,
                                                  ),

                                                  CellTable(
                                                    content:
                                                        "${(DateTime.now().year - patient.birthdatePx!.year)} años",
                                                    flex: 1,
                                                    isHeader: false,
                                                  ),

                                                  CellTable(
                                                    content: patient.sexPx!,
                                                    flex: 1,
                                                    isHeader: false,
                                                  ),

                                                  CellTable(
                                                    content: patient.phone!,
                                                    flex: 1,
                                                    isHeader: false,
                                                  ),

                                                  CellTable(
                                                    content:
                                                        patient.directionPx!,
                                                    flex: 2,
                                                    isHeader: false,
                                                  ),

                                                  CellTable(
                                                    content: isActive
                                                        ? "Activo"
                                                        : "Inactivo",
                                                    flex: 0,
                                                    isHeader: false,
                                                    isItem: true,
                                                  ),

                                                  CellTable(
                                                    content:
                                                        DateFormat.yMMMd(
                                                          "es",
                                                        ).format(
                                                          patient
                                                              .lastAppointmentDate!,
                                                        ),
                                                    flex: 1,
                                                    isHeader: false,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
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

                    if (patients.pagination != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Pagination(
                          onChangePage: (page) {
                            ref
                                .read(pxProvider.notifier)
                                .getPatients(page: page);
                          },
                          totalPages: patients.pagination!.totalPages,
                          page: patients.pagination!.page,
                          hasNext: patients.pagination!.hasNext,
                          hasPrevius: patients.pagination!.hasPrevius,
                          colorTheme: colorTheme,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}

class CellTable extends StatelessWidget {
  final String content;
  final int flex;
  final bool isHeader;
  final bool isItem;
  const CellTable({
    super.key,
    required this.content,
    required this.flex,
    this.isHeader = true,
    this.isItem = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final isActive = content == "Activo";
    return Expanded(
      flex: flex,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            width: .9,
            color: !isHeader
                ? Colors.transparent
                : color.onSecondary.withValues(alpha: 0.07),
          ),
        ),
        child: !isItem
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isHeader ? content.toUpperCase() : content,
                  style: TextStyle(
                    fontSize: isHeader ? 12 : 14,
                    fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                    color: !isHeader
                        ? color.onSecondary
                        : color.onSecondary.withValues(alpha: .5),
                  ),
                  textAlign: TextAlign.start,
                ),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 30,
                  width: 80,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: isActive
                        ? color.primary.withValues(alpha: .2)
                        : color.error.withValues(alpha: .2),
                  ),
                  child: Center(
                    child: Text(
                      content,
                      style: TextStyle(
                        color: isActive ? color.primary : color.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class ContentGridCards extends StatefulWidget {
  const ContentGridCards({
    super.key,
    required this.colorTheme,
    required this.indexRandom,
    required this.patient,
    required this.nameSeparate,
    required this.age,
    required this.index,
  });

  final int indexRandom;
  final ColorScheme colorTheme;
  final PxEntity patient;
  final List<String> nameSeparate;
  final int age;
  final int index;

  @override
  State<ContentGridCards> createState() => _ContentGridCardsState();
}

class _ContentGridCardsState extends State<ContentGridCards> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final fourMonthsAgo = DateTime(now.year, now.month - 6, now.day);

    final isActive =
        widget.patient.lastAppointmentDate != null &&
        widget.patient.lastAppointmentDate!.isAfter(fourMonthsAgo);

    return GestureDetector(
      onTap: () => context.pushNamed(
        PxDetailsScreen.namePage,
        pathParameters: {"idPx": widget.patient.idPx.toString()},
      ),

      child: MouseRegion(
        onEnter: (_) => setState(() {
          isHover = true;
        }),
        onExit: (_) => setState(() {
          isHover = false;
        }),

        cursor: SystemMouseCursors.click,

        child: FadeInDown(
          duration: const Duration(milliseconds: 350),
          delay: Duration(milliseconds: widget.index * 50),
          child: AnimatedContainer(
            duration: const Duration(microseconds: 1500),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),

            decoration: BoxDecoration(
              color: isHover ? widget.colorTheme.secondary : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 2,
                color: widget.colorTheme.secondary.withValues(alpha: .8),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                AvatarPx(
                  indexRandom: widget.indexRandom,
                  patient: widget.patient,
                ),

                SizedBox(height: 15),

                Text(
                  "${widget.nameSeparate.first} ${widget.nameSeparate[widget.nameSeparate.length - 2]}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: widget.colorTheme.onSecondary.withValues(alpha: .9),
                  ),
                ),

                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "${widget.age} años  "),

                      TextSpan(text: "  •  "),
                      TextSpan(text: widget.patient.sexPx),
                    ],
                    style: TextStyle(
                      color: widget.colorTheme.onSecondary.withValues(
                        alpha: .6,
                      ),
                    ),
                  ),
                ),

                Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: isActive
                        ? widget.colorTheme.primary.withValues(alpha: .2)
                        : widget.colorTheme.error.withValues(alpha: .2),
                  ),
                  child: Text(
                    isActive ? "Activo" : "Inactivo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isActive
                          ? widget.colorTheme.primary
                          : widget.colorTheme.error,
                    ),
                  ),
                ),

                Spacer(),

                ContentAction(
                  colorTheme: widget.colorTheme,
                  lastAppointmentDate:
                      widget.patient.lastAppointmentDate ?? DateTime.now(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContentAction extends StatelessWidget {
  const ContentAction({
    super.key,
    required this.colorTheme,
    this.lastAppointmentDate,
  });

  final ColorScheme colorTheme;
  final DateTime? lastAppointmentDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedCalendar01,
          color: colorTheme.onSecondary.withValues(alpha: .6),
        ),

        SizedBox(width: 6),

        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Última cita",
                style: TextStyle(
                  fontSize: 13,
                  color: colorTheme.onSecondary.withValues(alpha: .6),
                ),
              ),
              TextSpan(text: "\n"),

              TextSpan(
                text: DateFormat.yMMMEd("es").format(lastAppointmentDate!),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        Spacer(),

        ActionButtonMore(colorTheme: colorTheme),
      ],
    );
  }
}

class ActionButtonMore extends StatefulWidget {
  const ActionButtonMore({super.key, required this.colorTheme});

  final ColorScheme colorTheme;

  @override
  State<ActionButtonMore> createState() => _ActionButtonMoreState();
}

class _ActionButtonMoreState extends State<ActionButtonMore> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle styleItemsText = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w200,
      color: widget.colorTheme.onSecondary.withValues(alpha: .7),
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

        child: ButtonAction(
          color: widget.colorTheme,
          onTapButton: () {},
          icon: HugeIcons.strokeRoundedCalendar01,
        )
      ),
    );
  }
}

class AvatarPx extends StatelessWidget {
  const AvatarPx({super.key, required this.indexRandom, required this.patient});

  final int indexRandom;
  final PxEntity patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.colors[indexRandom],
      ),

      child: Center(
        child: Text(
          "PX${patient.idPx}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
