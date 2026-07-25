//? Framework Import
import 'package:flutter/material.dart';

//? External Import
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//? Local Import
import 'package:clinica_prodental/domain/entities/px/px_entity.dart';
import 'package:clinica_prodental/presentation/widget/widgets.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/px_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/citas/cita_form_provider.dart';

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
  late final TextEditingController controllerPx;

  @override
  void initState() {
    super.initState();
    controllerPx = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    //? Provider
    final pxProv = ref.watch(pxProvider);
    final citaFormProv = ref.watch(citaFormProvider);
    //final citaRead = ref.read(citaFormProvider.notifier);
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
                  controller: controllerPx,
                  onChanged: (value) {
                    Future.delayed(const Duration(milliseconds: 100));
                    ref.read(pxProvider.notifier).searchPx(value);
                  },
                  color: widget.color,
                  lines: 1,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {},
                  mouseCursor: SystemMouseCursors.click,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: widget.color.primary,
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
            child: ListView.builder(
              itemCount: pxProv.search!.length,
              itemBuilder: (context, index) {
                final px = pxProv.search![index];
                return ContainerPatient(
                  px: px,
                  theme: widget.color,
                  onSelectedPx: (PxEntity pxUp) {
                    ref.read(citaFormProvider.notifier).updatePatient(pxUp);
                  },
                );
              },
            ),
          ),

        if (citaFormProv.px != null)
          Container(
            height: heightCard,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: widget.color.secondary),
              borderRadius: BorderRadius.circular(15),
            ),

            child: ContainerPatient(
              px: citaFormProv.px!,
              theme: widget.color,
              isSelected: true,
              onDeletedPx: () {
                ref.read(citaFormProvider.notifier).clearPatient();
                debugPrint("Presionado");
              },
            ),
          ),
      ],
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
            Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: theme.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(child: Text("PX${px.idPx}")),
            ),

            SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(px.fullNamePx),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "+504 ${px.phone ?? "Sin número de teléfono"}",
                      style: TextStyle(
                        color: theme.onSecondary.withValues(alpha: .25),
                      ),
                    ),

                    Text(
                      " · ",
                      style: TextStyle(color: theme.primary, fontSize: 17),
                    ),

                    Text(
                      "28 años",
                      style: TextStyle(
                        color: theme.onSecondary.withValues(alpha: .25),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Spacer(),
            if (isSelected)
              InkWell(
                onTap: onDeletedPx!,

                mouseCursor: SystemMouseCursors.click,
                child: Container(
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
