//? Framework Import
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/px_state.dart';
import 'package:flutter/material.dart';

//? External Import
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//? Local Import
import 'package:clinica_prodental/domain/entities/px/px_entity.dart';
import 'package:clinica_prodental/presentation/widget/widgets.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/px_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/citas/cita_form_provider.dart';
import 'package:phone_number_controller/phone_number_controller.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/patient/patient_dtos.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/add_data_px_input.dart';
import 'package:clinica_prodental/presentation/shared/shared.dart';

class ContentDialogCita extends StatelessWidget {
  const ContentDialogCita({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ColorScheme color = Theme.of(context).colorScheme;
    return Dialog(
      child: Container(
        width: size.width * .40,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        child: BodyDialog(color: color),
      ),
    );
  }
}

class BodyDialog extends ConsumerStatefulWidget {
  final ColorScheme color;
  const BodyDialog({super.key, required this.color});

  @override
  ConsumerState<BodyDialog> createState() => _BodyDialogState();
}

class _BodyDialogState extends ConsumerState<BodyDialog> {
  late final TextEditingController controllerSearchPx;
  bool isCreatePx = false;
  late final ProviderSubscription<PxState> _subscriptionPx;

  @override
  void initState() {
    super.initState();
    controllerSearchPx = TextEditingController();
    //? Escuchar si el state cambio, osea que si se creo un nuevo paciente y si se creó, utilizarlo en el state form.
    //? y usando el listenManual, para que no este en el build, y no se este ejecuentando cada vez que se reconstruya el build
    _subscriptionPx = ref.listenManual(pxProvider, (previus, next) {
      if (next.px != null) {
        ref.read(citaFormProvider.notifier).updatePatient(next.px!);
      }
    });
  }

  @override
  void dispose() {
    controllerSearchPx.dispose();
    _subscriptionPx.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? Provider
    final pxProv = ref.watch(pxProvider);
    final citaFormProv = ref.watch(citaFormProvider);
    final pxFormProv = ref.watch(addDataPxInput);
    //final citaRead = ref.read(citaFormProvider.notifier);
    final formPx = ref.read(addDataPxInput.notifier);
    //? Validaciones
    final bool searchIsNotEmpty =
        pxProv.search != null && pxProv.search!.isNotEmpty;
    final double heightCard = 90;
    final double maxHeight = 300;
    final double heightClamp = (heightCard * pxProv.search!.length + 10).clamp(
      0,
      maxHeight,
    );

    return Column(
      children: [
        ContentHeaderForm(
          title: "Crear cita",
          subTitle: 'Registra una nueva cita en el sistema.',
          icon: HugeIcons.strokeRoundedAppointment02,
        ),

        SizedBox(height: 40),

        ContainerTitle(
          styleLabel: TextStyle(),
          color: widget.color.primary,
          title: "Paciente",
          icon: HugeIcons.strokeRoundedPatient,
          fontSize: 20,
        ),

        SizedBox(height: 20),

        SizedBox(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextInput(
                  hintText: "Buscar paciente por id, nombre o teléfono",
                  controller: controllerSearchPx,
                  onChanged: (value) {
                    Future.delayed(const Duration(milliseconds: 100));
                    ref.read(pxProvider.notifier).searchPx(value);
                  },
                  color: widget.color,
                  lines: 1,
                ),
              ),
              SizedBox(width: 10),
              ButtonAddPatient(
                theme: widget.color,
                onAddPx: () {
                  setState(() {
                    isCreatePx = true;
                  });
                },
                isCreatePx: isCreatePx,
              ),
            ],
          ),
        ),

        SizedBox(height: 8),

        if (!(citaFormProv.px != null))
          AnimatedContainer(
            height: searchIsNotEmpty ? heightClamp : 0,
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: widget.color.secondary),
              borderRadius: BorderRadius.circular(15),
            ),
            child: pxProv.isLoading!
                ? Center(child: LoaderIcon())
                : pxProv.error != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MessageEmptyData(
                        widthLottie: 200,
                        message: pxProv.error!.message,
                        color: widget.color,
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: pxProv.search!.length,
                    itemBuilder: (context, index) {
                      final px = pxProv.search![index];
                      return ContainerPatient(
                        px: px,
                        theme: widget.color,
                        onSelectedPx: (PxEntity pxUp) {
                          ref
                              .read(citaFormProvider.notifier)
                              .updatePatient(pxUp);
                        },
                      );
                    },
                  ),
          ),

        if (citaFormProv.px != null)
          cardResult(
            ContainerPatient(
              px: citaFormProv.px!,
              theme: widget.color,
              isSelected: true,
              onDeletedPx: () {
                ref.read(citaFormProvider.notifier).clearPatient();
                ref.read(pxProvider.notifier).clearPatient();
              },
            ),
            heightCard,
            widget.color,
          ),

        if (isCreatePx && citaFormProv.px == null)
          cardResult(
            ContainerCreate(
              theme: widget.color,
              onClose: () {
                setState(() {
                  isCreatePx = false;
                });
              },
              addItem:
                  (String name, String lastName, String phone, String age) {
                    final PatientDtos dtosPatient = PatientDtos(
                      names: name,
                      lastNames: lastName,
                      birthdate: age,
                      phone: phone,
                    );
                    ref.read(pxProvider.notifier).postPx(dtosPatient);
                  },
              onChangedName: formPx.updateNamesPx,
              onChangedLastName: formPx.updateLastNamesPx,
              onChangedPhone: formPx.updatePhone,
              onchagedAge: formPx.updateBirthday,
              name: pxFormProv.names,
              lastName: pxFormProv.lastNames,
              phone: pxFormProv.phone,
              age: pxFormProv.birthday,
            ),
            heightCard,
            widget.color,
          ),

        ContentInformationAppointment(theme: widget.color),
      ],
    );
  }
}

class ContentInformationAppointment extends StatefulWidget {
  final ColorScheme theme;
  const ContentInformationAppointment({super.key, required this.theme});

  @override
  State<ContentInformationAppointment> createState() =>
      _ContentInformationAppointmentState();
}

class _ContentInformationAppointmentState
    extends State<ContentInformationAppointment> {
  late final TextEditingController controllerReasonAppointment;

  @override
  void initState() {
    super.initState();
    controllerReasonAppointment = TextEditingController();
  }

  @override
  void dispose() {
    controllerReasonAppointment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              ContainerTitle(
                styleLabel: TextStyle(),
                color: widget.theme.primary,
                title: "Información de la cita",
                icon: HugeIcons.strokeRoundedCalendar01,
                fontSize: 20,
              ),

              SizedBox(height: 12),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    InputAndLabel(
                      label: 'Razón de la cita',
                      onChanged: (value) {},
                      theme: widget.theme,
                      icon: HugeIcons.strokeRoundedDentalTooth,
                      controller: controllerReasonAppointment,
                      constraintWidth: constraints.maxWidth * .50,
                      hintText: "(Ej.) Limpieza dental",
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

//TODO : TERMINAR FORMULARIOM CON DENTISTA, FECHA DE LA CITA, HORA, PRECIO, DIAGNOSTICO, Y AGREGAR RECORDATORIO

class InputAndLabel extends StatelessWidget {
  final String label;
  final String hintText;
  final dynamic icon;
  final ColorScheme theme;
  final ValueChanged onChanged;
  final TextEditingController controller;
  final double constraintWidth;
  const InputAndLabel({
    super.key,
    required this.label,
    required this.onChanged,
    this.icon,
    required this.theme,
    required this.controller,
    required this.constraintWidth,
    this.hintText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon != null ? HugeIcon(icon: icon) : SizedBox.shrink(),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: theme.onSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                letterSpacing: .6,
              ),
            ),
          ],
        ),

        SizedBox(height: 10),

        SizedBox(
          width: constraintWidth,
          child: TextInput(
            hintText: hintText,
            controller: controller,
            onChanged: onChanged,
            color: theme,
            lines: 1,
          ),
        ),
      ],
    );
  }
}

class ContainerCreate extends StatefulWidget {
  const ContainerCreate({
    super.key,
    required this.theme,
    required this.onClose,
    this.addItem,
    required this.onChangedName,
    required this.onChangedLastName,
    required this.onChangedPhone,
    required this.onchagedAge,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.age,
  });

  final ColorScheme theme;
  final VoidCallback onClose;
  final Function(String name, String lastName, String phone, String age)?
  addItem;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedLastName;
  final ValueChanged<String> onChangedPhone;
  final ValueChanged<String> onchagedAge;
  final String? name;
  final String? lastName;
  final String? phone;
  final String? age;

  @override
  State<ContainerCreate> createState() => _ContainerCreateState();
}

class _ContainerCreateState extends State<ContainerCreate> {
  late final TextEditingController controllerName;
  late final TextEditingController controllerLastName;
  late final PhoneNumberController controllerPhone;
  late final TextEditingController controllerAge;

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    controllerLastName = TextEditingController();
    controllerPhone = PhoneNumberController(countryCode: "HN");
    controllerAge = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(color: widget.theme.error),
        SizedBox(width: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InputInformation(
                  fontSize: 12,
                  height: 35,
                  width: 150,
                  hintText: 'Nombre(s)',
                  controller: controllerName,
                  onchaged: (value) {
                    widget.onChangedName(value);
                  },
                ),

                SizedBox(width: 15),

                InputInformation(
                  fontSize: 12,
                  height: 35,
                  width: 150,
                  hintText: 'Apellido(s)',
                  controller: controllerLastName,
                  onchaged: (value) {
                    widget.onChangedLastName(value);
                  },
                ),
              ],
            ),
            Row(
              children: [
                InputInformation(
                  width: 100,
                  height: 30,
                  fontSize: 10,
                  hintText: 'Teléfono',
                  controller: controllerPhone,
                  onchaged: (value) {
                    widget.onChangedPhone(value);
                  },
                ),

                SizedBox(width: 20),
                InputInformation(
                  width: 100,
                  height: 30,
                  fontSize: 10,
                  hintText: 'Edad',
                  controller: controllerAge,
                  onchaged: (value) {
                    widget.onchagedAge(value);
                  },
                ),
              ],
            ),
          ],
        ),

        Spacer(),

        IconButtonBasicAction(
          icon: HugeIcons.strokeRoundedUpload01,
          colorHover: widget.theme.primary,
          theme: widget.theme,
          addItem: widget.addItem != null
              ? () {
                  debugPrint(widget.name);
                  widget.addItem!(
                    widget.name!,
                    widget.lastName!,
                    widget.phone!,
                    widget.age!,
                  );
                }
              : null,
        ),

        SizedBox(width: 20),

        IconButtonBasicAction(
          icon: HugeIcons.strokeRoundedCancel01,
          colorHover: widget.theme.error,
          theme: widget.theme,
          onClose: widget.onClose,
        ),
      ],
    );
  }
}

class IconButtonBasicAction<T> extends StatefulWidget {
  const IconButtonBasicAction({
    super.key,
    this.icon,
    required this.colorHover,
    required this.theme,
    this.addItem,
    this.onClose,
  });

  final dynamic icon;
  final Color colorHover;
  final ColorScheme theme;
  final Function? addItem;
  final VoidCallback? onClose;

  @override
  State<IconButtonBasicAction> createState() =>
      _IconButtonBasicActionState<T>();
}

class _IconButtonBasicActionState<T> extends State<IconButtonBasicAction<T>> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.addItem != null
          ? () {
              widget.addItem!();
            }
          : widget.onClose,
      mouseCursor: SystemMouseCursors.click,
      onHover: (hover) {
        setState(() {
          isHover = hover;
        });
      },
      child: HugeIcon(
        icon: widget.icon,
        size: 25,
        color: isHover ? widget.colorHover : widget.theme.onSecondary,
      ),
    );
  }
}

class InputInformation extends StatelessWidget {
  const InputInformation({
    super.key,
    required this.fontSize,
    required this.height,
    required this.width,
    required this.hintText,
    required this.controller,
    required this.onchaged,
  });
  final double fontSize;
  final double height;
  final double width;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged onchaged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        controller: controller,
        onChanged: onchaged,
        decoration: InputDecoration(
          hint: Text(
            hintText,
            style: TextStyle(
              fontSize: fontSize,
              color: theme.onSecondary.withValues(alpha: .4),
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 10),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: theme.onSecondary.withValues(alpha: .5),
            ),
          ),
        ),
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}

class ButtonAddPatient extends StatelessWidget {
  const ButtonAddPatient({
    super.key,

    required this.isCreatePx,
    required this.onAddPx,
    required this.theme,
  });

  final ColorScheme theme;
  final bool isCreatePx;
  final VoidCallback onAddPx;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onAddPx,
        mouseCursor: SystemMouseCursors.click,
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: theme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              "Crear paciente",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerPatient extends StatelessWidget {
  const ContainerPatient({
    super.key,
    required this.px,
    required this.theme,
    this.onSelectedPx,
    this.isSelected = false,
    this.onDeletedPx,
  });

  final ColorScheme theme;
  final PxEntity px;
  final bool isSelected;
  final Function(PxEntity px)? onSelectedPx;
  final VoidCallback? onDeletedPx;

  @override
  Widget build(BuildContext context) {
    final onSelected = onSelectedPx;
    return InkWell(
      onTap: onSelected == null ? null : () => onSelected(px),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        height: 90,
        child: Row(
          children: [
            Avatar(color: theme.primary, id: px.idPx),

            SizedBox(width: 30),
            ContentBasicInformation(px: px, theme: theme),

            Spacer(),
            if (isSelected)
              InkWell(
                onTap: onDeletedPx!,

                mouseCursor: SystemMouseCursors.click,
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.id, required this.color});

  final Color color;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: id != null
            ? Text("PX${id!}")
            : HugeIcon(icon: HugeIcons.strokeRoundedUser02),
      ),
    );
  }
}

class ContentBasicInformation extends StatelessWidget {
  const ContentBasicInformation({
    super.key,
    required this.px,
    required this.theme,
  });

  final PxEntity px;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    final int age = px.birthdatePx != null && px.birthdatePx!.contains('-')
        ? DateTime.now().year - DateTime.parse(px.birthdatePx!).year
        : int.parse(px.birthdatePx!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(px.fullNamePx),
        SizedBox(height: 4),
        Row(
          children: [
            Text(
              "+504 ${px.phone ?? "Sin número de teléfono"}",
              style: TextStyle(color: theme.onSecondary.withValues(alpha: .25)),
            ),

            Text(" · ", style: TextStyle(color: theme.primary, fontSize: 17)),

            Text(
              "$age años",
              style: TextStyle(color: theme.onSecondary.withValues(alpha: .25)),
            ),
          ],
        ),
      ],
    );
  }
}

//? Functions

Widget cardResult(Widget child, double heightCard, ColorScheme color) {
  return Container(
    height: heightCard,
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    decoration: BoxDecoration(
      border: Border.all(color: color.secondary),
      borderRadius: BorderRadius.circular(15),
    ),
    child: child,
  );
}
