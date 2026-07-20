//? Local import
import 'package:clinica_prodental/core/theme/app_colors.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/patient/patient_dtos.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/px_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/px_dental_record_form.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/px_form_state.dart';

import 'package:clinica_prodental/presentation/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/add_data_px_input.dart';
import 'package:clinica_prodental/presentation/screens/px/dialog/content/content_list_check.dart';

//? External Import
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_number_controller/phone_number_controller.dart';

//? Providers
import 'package:clinica_prodental/presentation/providers/features/px/data/allergy/allergys_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/disease/disease_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/medication/medication_provider.dart';
//? Domain
import 'package:clinica_prodental/domain/entities/entities.dart';
//? Infraestructure
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';

//*? Screen
import 'package:clinica_prodental/presentation/widget/widgets.dart';

const List<String> sex = ["Femenino", "Masculino"];

class ContentDialogPx extends ConsumerStatefulWidget {
  const ContentDialogPx({super.key});

  @override
  ConsumerState<ContentDialogPx> createState() => _ContentDialogPxState();
}

class _ContentDialogPxState extends ConsumerState<ContentDialogPx> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(allergysProvider.notifier).getAllergys();
      ref.read(medicationProvider.notifier).getMedications();
      ref.read(diseaseProvider.notifier).getDiseases();
    });
  }

  @override
  Widget build(BuildContext context) {
    //*? Provider para datos del input
    final pxDataInput = ref.watch(addDataPxInput);

    //? Provider Alergias, Enfermedades, Medicaciones
    final allergys = ref.watch(allergysProvider);
    final medications = ref.watch(medicationProvider);
    final diseases = ref.watch(diseaseProvider);

    final Size size = MediaQuery.of(context).size;
    final TextStyle textLabels = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    final ColorScheme color = Theme.of(context).colorScheme;

    return Dialog(
      child: Container(
        width: size.width * .6,
        height: size.height * 1,
        padding: EdgeInsets.only(top: 30, bottom: 10, right: 20, left: 20),
        child:
            allergys.isLoading! || medications.isLoading! || diseases.isLoading!
            ? LoaderIcon()
            : allergys.error != null ||
                  medications.error != null ||
                  diseases.error != null
            ? Center(child: ViewError(statusCode: diseases.statusCode))
            : Stack(
                children: [
                  SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ContentHeaderDialog(),
                          ContentBodyDialog(
                            textLabels: textLabels,
                            color: color,
                            pxDataInput: pxDataInput,
                            allergys: allergys.allergys,
                            medications: medications.medications,
                            diseases: diseases.diseases,
                            dentalRecords: pxDataInput.medicalRecord!,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: AlignmentGeometry.bottomEnd,

                    child: Container(
                      width: size.width * .6,
                      height: 65,
                      padding: EdgeInsets.only(top: 10, right: 20, bottom: 10),
                      decoration: BoxDecoration(
                        color: color.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: color.error,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    HugeIcon(
                                      icon: HugeIcons.strokeRoundedCancel01,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Cancelar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          ButtonSave(
                            color: color,
                            onAddPatient: () {
                              List<int>? idsAllergy = [];
                              List<int>? idsMedication = [];
                              List<int>? idsDiseases = [];

                              if (!(pxDataInput.names != null &&
                                      pxDataInput.names!.isNotEmpty) ||
                                  !(pxDataInput.names != null &&
                                      pxDataInput.names!.isNotEmpty) ||
                                  !(pxDataInput.sex != null &&
                                      pxDataInput.sex!.isNotEmpty)) {
                                return ViewDialog.viewDialog(
                                  context,
                                  "Datos Icompletos",
                                  "Llenar los campos requeridos",
                                  TypeAnimation.warning,
                                );
                              }

                              if (pxDataInput.allergySelected != null &&
                                  pxDataInput.allergySelected!.isNotEmpty) {
                                idsAllergy = pxDataInput.allergySelected!
                                    .map((item) => item.idAllergy)
                                    .toList();
                              }

                              if (pxDataInput.medicationSelected != null &&
                                  pxDataInput.medicationSelected!.isNotEmpty) {
                                idsMedication = pxDataInput.medicationSelected!
                                    .map((item) => item.idMedication)
                                    .toList();
                              }
                              if (pxDataInput.diseasesSelected != null &&
                                  pxDataInput.diseasesSelected!.isNotEmpty) {
                                idsDiseases = pxDataInput.diseasesSelected!
                                    .map((item) => item.idDiaseases)
                                    .toList();
                              }

                              final PatientDtos dtos = PatientDtos(
                                names: pxDataInput.names!,
                                lastNames: pxDataInput.lastNames,
                                sex: pxDataInput.sex!,
                                birthdate: pxDataInput.birthday!,
                                phone: pxDataInput.phone!,
                                allergys: idsAllergy,
                                diseases: idsDiseases,
                                medications: idsMedication,
                                medicalRecord: pxDataInput.medicalRecord,
                              );

                              ref.read(pxProvider.notifier).postPx(dtos);
                              ref.read(addDataPxInput.notifier).clearForm();

                              context.pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ButtonSave extends StatelessWidget {
  const ButtonSave({
    super.key,
    required this.color,
    required this.onAddPatient,
  });

  final ColorScheme color;
  final VoidCallback onAddPatient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAddPatient,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: color.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedFolderUpload,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text("Guardar paciente", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

/*
 */

class ContentBodyDialog extends ConsumerStatefulWidget {
  const ContentBodyDialog({
    super.key,
    required this.textLabels,
    required this.color,
    required this.pxDataInput,
    required this.allergys,
    required this.medications,
    required this.diseases,
    required this.dentalRecords,
  });

  final TextStyle textLabels;
  final ColorScheme color;
  final PxFormState pxDataInput;
  final List<AllergyEntity>? allergys;
  final List<MedicationPxEntiy>? medications;
  final List<DiseasesEntity>? diseases;
  final List<PxDentalRecordForm> dentalRecords;

  @override
  ConsumerState<ContentBodyDialog> createState() => _ContentBodyDialogState();
}

class _ContentBodyDialogState extends ConsumerState<ContentBodyDialog> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(addDataPxInput.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsetsGeometry.only(top: 25, left: 20, right: 20),
          child: Column(
            children: [
              ContentPatientName(
                namesText: widget.pxDataInput.names,
                lastNamesText: widget.pxDataInput.lastNames,
                namesOnChaged: notifier.updateNamesPx,
                lastNamesOnChanged: notifier.updateLastNamesPx,
              ),

              ContentPersonalData(
                onchangedSex: notifier.updateSexPx,
                sexPx: widget.pxDataInput.sex,
                onchagedBirthdate: notifier.updateBirthday,
                dateBirthdate: widget.pxDataInput.birthday,
                onchagedPhone: notifier.updatePhone,
                phone: widget.pxDataInput.phone,
              ),

              SizedBox(height: 45),

              ContentDirectionPx(
                textLabels: widget.textLabels,
                color: widget.color,
                directionText: widget.pxDataInput.direction,
                onchagedDirection: notifier.updateDirection,
              ),

              ContentSelectedDetails(
                color: widget.color,
                labelStyle: widget.textLabels,
                allergys: widget.allergys!,
                allergySelected: widget.pxDataInput.allergySelected,
                onChangedAllergy: notifier.updateIdsAllergy,
                onAddItemAllergy: (name, description) async {
                  final DtosAllergy dtos = DtosAllergy(nameAllergy: name);
                  return await ref
                      .read(allergysProvider.notifier)
                      .postAllergy(dtos);
                },
                medications: widget.medications!,
                medicationSelected: widget.pxDataInput.medicationSelected,
                onChangedMedication: notifier.updateIdsMedication,
                onAddItemMedication: (name, description) async {
                  final DtosMedication dtos = DtosMedication(
                    nameMedication: name,
                  );
                  return await ref
                      .read(medicationProvider.notifier)
                      .postMedication(dtos);
                },
                diseases: widget.diseases!,
                diseasesSelected: widget.pxDataInput.diseasesSelected,
                onChangedDiseases: notifier.updateIdsDiseases,
                onAddItemDiseases: (name, observation) async {
                  final DtosDiseases dtos = DtosDiseases(nameDisease: name);

                  return await ref
                      .read(diseaseProvider.notifier)
                      .postDiseases(dtos);
                },
              ),

              ContentMedicalRecord(
                styleLable: widget.textLabels,
                addData: (List<PxDentalRecordForm> dentalRecord) =>
                    notifier.updateMedicalRecord(dentalRecord),

                dentalRecords: widget.dentalRecords,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ContentMedicalRecord extends StatefulWidget {
  final TextStyle styleLable;
  final Function(List<PxDentalRecordForm> dentalRecord) addData;
  final List<PxDentalRecordForm> dentalRecords;
  const ContentMedicalRecord({
    super.key,
    required this.styleLable,
    required this.addData,
    required this.dentalRecords,
  });

  @override
  State<ContentMedicalRecord> createState() => _ContentMedicalRecordState();
}

class _ContentMedicalRecordState extends State<ContentMedicalRecord> {
  late int countCards;
  int currentIndex = 0;
  bool isForm = false;
  DateTime? dateCita;
  bool isComplete = false;
  late PxDentalRecordForm newRecord;
  List<PxDentalRecordForm> listLocalNewDentalRecord = [];

  final List<TextEditingController> controllersDentalName = [];
  final List<TextEditingController> controllersDentalDescription = [];

  @override
  void initState() {
    super.initState();

    countCards = widget.dentalRecords.isEmpty
        ? 2
        : widget.dentalRecords.length + 1;

    for (int i = 0; i < countCards; i++) {
      controllersDentalName.add(TextEditingController());
      controllersDentalDescription.add(TextEditingController());
    }
  }

  void addFormDentalRecord(int index) {
    setState(() {
      controllersDentalName.add(TextEditingController());
      controllersDentalDescription.add(TextEditingController());
      if (index > 0) {
        countCards++;
      }
      currentIndex = index;
    });
  }

  Future<DateTime?> viewCalendar() async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
  }

  @override
  void dispose() {
    for (var controllerName in controllersDentalName) {
      controllerName.dispose();
    }

    for (var controllerDescription in controllersDentalDescription) {
      controllerDescription.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

    final TextStyle textLabels = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 40, bottom: 100),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContainerTitle(
            styleLabel: textLabels,
            color: colorTheme.primary,
            title: "Antecedentes dentales",
            subTitle:
                "Registro de tratamientos y procedimientos dentales previos",
            icon: HugeIcons.strokeRoundedDentalTooth,
          ),

          SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 10,
                runSpacing: 15,
                children: List.generate(countCards, (index) {
                  double widthCard = (constraints.maxWidth - 10 * 2) / 2;
                  final hasIndex = index < widget.dentalRecords.length;
                  final recordInfo = hasIndex
                      ? widget.dentalRecords[index]
                      : null;
                  isForm = index == currentIndex;

                  final double heightCard =
                      hasIndex && widget.dentalRecords.length - index == 0
                      ? 280
                      : 450;

                  if (recordInfo != null &&
                      widget.dentalRecords[index].name.isNotEmpty) {
                    return KeyedSubtree(
                      key: ValueKey(index),
                      child: ContentViewInfoDentalRecord(
                        widthCard: widthCard,
                        heightCard: heightCard,
                        colorTheme: colorTheme,
                        dentalRecord: recordInfo,
                      ),
                    );
                  }

                  if (!isForm) {
                    return DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        radius: Radius.circular(15),
                        color: colorTheme.onSecondary.withValues(alpha: .3),
                        dashPattern: [2, 6],
                      ),
                      child: ContainerEmptyDentalRecord(
                        heightCard: heightCard,
                        widthCard: countCards % 2 == 0
                            ? widthCard
                            : constraints.maxWidth,
                        colorTheme: colorTheme,
                        onAddDentalRecord: () => addFormDentalRecord(index),
                      ),
                    );
                  }

                  return ContentFormDentalRecord(
                    colorTheme: colorTheme,
                    widthCard: widthCard,
                    heightCard: heightCard,
                    textLabels: textLabels,
                    controllerRegister: controllersDentalName[index],
                    controllerDescription: controllersDentalDescription[index],
                    onAddDate: () async {
                      final date = await viewCalendar();
                      if (date != null && dateCita != date) {
                        setState(() {
                          dateCita = date;
                        });
                      }
                    },
                    dateCita: dateCita,
                    onNotComplete: () {
                      setState(() {
                        isComplete = false;
                      });
                    },
                    onYesComplete: () {
                      setState(() {
                        isComplete = true;
                      });
                    },

                    isComplete: isComplete,
                    onAddDataFromState: () => {
                      newRecord = PxDentalRecordForm(
                        index: index,
                        name: controllersDentalName[index].text,
                        description: controllersDentalDescription[index].text,
                        dateCita: dateCita == null ? DateTime.now() : dateCita!,
                        isComplete: isComplete,
                      ),

                      if (listLocalNewDentalRecord.length > index)
                        {listLocalNewDentalRecord[index] = newRecord}
                      else
                        {listLocalNewDentalRecord.add(newRecord)},

                      widget.addData(listLocalNewDentalRecord),
                    },
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ContentFormDentalRecord extends StatelessWidget {
  final ColorScheme colorTheme;
  final double widthCard;
  final double heightCard;
  final TextStyle textLabels;
  final TextEditingController controllerRegister;
  final TextEditingController controllerDescription;
  final Function() onAddDate;
  final VoidCallback onNotComplete;
  final VoidCallback onYesComplete;
  final VoidCallback onAddDataFromState;
  final DateTime? dateCita;
  final bool isComplete;

  const ContentFormDentalRecord({
    super.key,
    required this.colorTheme,
    required this.widthCard,
    required this.heightCard,
    required this.textLabels,
    required this.controllerRegister,
    required this.controllerDescription,
    required this.onAddDate,
    this.dateCita,
    required this.onNotComplete,
    required this.onYesComplete,
    required this.isComplete,
    required this.onAddDataFromState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthCard,
      height: heightCard,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: colorTheme.onSecondary.withValues(alpha: .3),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Registro Dental", style: textLabels),
          SizedBox(height: 10),
          TextInput(
            hintText: "Limpieza dental",
            controller: controllerRegister,
            onChanged: (value) {},
            color: colorTheme,
            lines: 1,
          ),

          SizedBox(height: 20),
          Text("Descripción", style: textLabels),
          SizedBox(height: 10),
          TextInput(
            hintText: "Tratamientos, observaciones, etc...",
            controller: controllerDescription,
            onChanged: (value) {},
            color: colorTheme,
            lines: 3,
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fecha de la cita", style: textLabels),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: onAddDate,

                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 55,
                        width: 200,
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                          color: colorTheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            HugeIcon(icon: HugeIcons.strokeRoundedCalendar02),
                            SizedBox(width: 15),
                            Text(
                              dateCita != null
                                  ? DateFormat('dd/MM/yyyy').format(dateCita!)
                                  : "Seleccionar",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 20),

              Column(
                children: [
                  Text("¿Completado?", style: textLabels),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ButtonSelectOption(
                        title: "Si",
                        onTap: onYesComplete,
                        onSelected: isComplete,
                        color: isComplete
                            ? colorTheme.primary
                            : colorTheme.onSecondary.withValues(alpha: .6),
                      ),

                      SizedBox(width: 5),

                      ButtonSelectOption(
                        title: "No",
                        onTap: onNotComplete,
                        onSelected: !isComplete,
                        color: !isComplete
                            ? colorTheme.error
                            : colorTheme.onSecondary.withValues(alpha: .6),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          Spacer(),

          InkWell(
            onTap: onAddDataFromState,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                color: colorTheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedAdd01,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Agregar registro dental",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
! Agregar datos 
widget.addData(
              PxDentalRecordForm(
                index: index,
                name: controllersDentalName[index].text,
                description: controllersDentalDescription[index].text,
                dateCita: DateTime.now(),
                isComplete: true,
              ),
            )*/
class ContentViewInfoDentalRecord extends StatelessWidget {
  const ContentViewInfoDentalRecord({
    super.key,
    required this.widthCard,
    required this.heightCard,
    required this.colorTheme,
    required this.dentalRecord,
  });

  final double widthCard;
  final double heightCard;
  final ColorScheme colorTheme;
  final PxDentalRecordForm dentalRecord;

  @override
  Widget build(BuildContext context) {
    final String indexCount = dentalRecord.index + 1 > 9
        ? " "
        : "0${(dentalRecord.index + 1).toString()}";

    final String messageStatus = dentalRecord.isComplete
        ? "Completado"
        : "Seguimiento";

    final Color colorStatus = dentalRecord.isComplete
        ? colorTheme.primary
        : Colors.blueAccent;
    return Container(
      width: widthCard,
      height: heightCard,
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: colorTheme.onSecondary.withValues(alpha: .3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorTheme.primary.withValues(alpha: .3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedDentalCare,
                  color: colorTheme.primary,
                ),
              ),
              SizedBox(width: 10),
              Text(
                dentalRecord.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: colorTheme.primary.withValues(alpha: .3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  indexCount,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorTheme.primary,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

          Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedCalendar01),
              Text(
                DateFormat("dd MMMM yyyy", "es").format(dentalRecord.dateCita!),
              ),
            ],
          ),

          SizedBox(height: 25),

          Text(
            "Descripción",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorTheme.primary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            dentalRecord.description!,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),

          Spacer(),

          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: colorStatus.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  icon: dentalRecord.isComplete
                      ? HugeIcons.strokeRoundedTick01
                      : HugeIcons.strokeRoundedInformationCircle,

                  color: colorStatus,
                ),
                SizedBox(width: 10),
                Text(messageStatus, style: TextStyle(color: colorStatus)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerEmptyDentalRecord extends StatelessWidget {
  const ContainerEmptyDentalRecord({
    super.key,
    required this.heightCard,
    required this.widthCard,
    required this.colorTheme,
    required this.onAddDentalRecord,
  });

  final double heightCard;
  final double widthCard;
  final ColorScheme colorTheme;
  final VoidCallback onAddDentalRecord;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAddDentalRecord,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: heightCard,
          width: widthCard,

          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedAddCircle,
                size: 70,
                color: colorTheme.primary,
              ),
              SizedBox(height: 20),
              Text(
                "Agregar registro dental",
                style: TextStyle(
                  color: colorTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),

              SizedBox(height: 10),
              Text(
                "Añade tratamientos, procedimiento u observaciones",
                style: TextStyle(
                  color: colorTheme.onSecondary.withValues(alpha: .3),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentSelectedDetails extends StatefulWidget {
  final ColorScheme color;
  final TextStyle labelStyle;
  //*? Allergy
  final List<AllergyEntity> allergys;
  final List<AllergyEntity>? allergySelected;
  final ValueChanged<List<AllergyEntity>> onChangedAllergy;
  final Future<AllergyEntity> Function(String name, String description)
  onAddItemAllergy;
  //? Medication
  final List<MedicationPxEntiy> medications;
  final List<MedicationPxEntiy>? medicationSelected;
  final ValueChanged<List<MedicationPxEntiy>> onChangedMedication;
  final Future<MedicationPxEntiy> Function(String name, String description)
  onAddItemMedication;

  //? Medication
  final List<DiseasesEntity> diseases;
  final List<DiseasesEntity>? diseasesSelected;
  final ValueChanged<List<DiseasesEntity>> onChangedDiseases;
  final Future<DiseasesEntity> Function(String name, String description)
  onAddItemDiseases;

  const ContentSelectedDetails({
    super.key,
    required this.color,
    required this.labelStyle,
    required this.allergys,
    this.allergySelected,
    required this.onChangedAllergy,
    required this.onAddItemAllergy,
    required this.medications,
    this.medicationSelected,
    required this.onChangedMedication,
    required this.onAddItemMedication,
    required this.diseases,
    this.diseasesSelected,
    required this.onChangedDiseases,
    required this.onAddItemDiseases,
  });

  @override
  State<ContentSelectedDetails> createState() => _ContentSelectedDetailsState();
}

class _ContentSelectedDetailsState extends State<ContentSelectedDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 45),
      child: Column(
        children: [
          ContainerTitle(
            styleLabel: widget.labelStyle,
            color: Colors.deepPurple,
            title: "Información médica",
            subTitle:
                "Registro de Alergias, Medicaciones y enfermedades del paciente.",
            icon: HugeIcons.strokeRoundedDoctor01,
          ),

          SizedBox(height: 20),

          Row(
            spacing: 10,
            children: [
              ContentInformationMedical<AllergyEntity>(
                widget: widget,
                color: Color.fromARGB(255, 238, 20, 100),
                countSelected: 3,
                title: 'Alergias',
                icon: HugeIcons.strokeRoundedFlower,
                listItems: widget.allergys,
                getName: (item) => item.nameAllergy,
                listSelected: widget.allergySelected,
                onchagedSelected: widget.onChangedAllergy,
                onAddItem: widget.onAddItemAllergy,
              ),
              ContentInformationMedical<MedicationPxEntiy>(
                widget: widget,
                color: Colors.blue,
                countSelected: 5,
                title: 'Medicación',
                icon: HugeIcons.strokeRoundedPill,
                listItems: widget.medications,
                listSelected: widget.medicationSelected,
                onchagedSelected: widget.onChangedMedication,
                onAddItem: widget.onAddItemMedication,
                getName: (MedicationPxEntiy item) => item.nameMedication,
              ),
              ContentInformationMedical<DiseasesEntity>(
                widget: widget,
                color: Colors.green,
                countSelected: 1,
                title: 'Enfermedades',
                icon: HugeIcons.strokeRoundedCardiogram02,
                listItems: widget.diseases,
                listSelected: widget.diseasesSelected,
                onchagedSelected: widget.onChangedDiseases,
                onAddItem: widget.onAddItemDiseases,
                getName: (DiseasesEntity item) => item.nameDiseases,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContentInformationMedical<T> extends StatefulWidget {
  const ContentInformationMedical({
    super.key,
    required this.widget,
    required this.color,
    required this.countSelected,
    required this.title,
    required this.listItems,
    required this.getName,
    this.listSelected,
    this.icon,
    this.onchagedSelected,
    this.onAddItem,
  });

  final List<T> listItems;
  final List<T>? listSelected;
  final ValueChanged<List<T>>? onchagedSelected;
  final String Function(T item) getName;
  final ContentSelectedDetails widget;
  final Color color;
  final int countSelected;
  final String title;
  final dynamic icon;
  final Future<T> Function(String name, String description)? onAddItem;

  @override
  State<ContentInformationMedical> createState() =>
      _ContentInformationMedicalState<T>();
}

class _ContentInformationMedicalState<T>
    extends State<ContentInformationMedical<T>> {
  bool isHover = false;

  void showDialogSelected(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ContentListCheck(
          listItems: widget.listItems,
          getName: widget.getName,
          onchagedSelected: widget.onchagedSelected,
          selectedItems: widget.listSelected,
          title: widget.title,
          icon: widget.icon,
          color: widget.color,
          onAddItem: widget.onAddItem!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: widget.widget.color.onSecondary.withValues(alpha: .2),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            TitleInformationMedical(widget: widget),

            SizedBox(height: 5),

            (widget.listSelected == null || widget.listSelected!.isEmpty)
                ? DottedBorder(
                    options: RectDottedBorderOptions(
                      dashPattern: [3, 5],
                      color: colorTheme.onSecondary.withValues(alpha: .3),
                    ),
                    child: BodyEmptyMedicalInformation(
                      colorTheme: colorTheme,
                      viewDialog: () => showDialogSelected(context),
                    ),
                  )
                : SizedBox(
                    height: 100,

                    child: ScrollConfiguration(
                      behavior: ScrollBehavior().copyWith(
                        scrollbars: false,
                        overscroll: false,
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 2,
                          runSpacing: 5,
                          children: List.generate(
                            widget.listSelected!.length,
                            ((index) {
                              final item = widget.listSelected![index];

                              return GestureDetector(
                                onTap: () => showDialogSelected(context),

                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      /*  border: Border.all(
                                      width: 1,
                                      color: colorTheme.onSecondary.withValues(
                                        alpha: .3,
                                      ),
                                    ), */
                                      color: widget.color.withValues(alpha: .1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      widget.getName(item),
                                      style: TextStyle(
                                        color: widget.color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ).toList(),
                        ),
                      ),
                    ),
                  ),

            SizedBox(height: 10),

            GestureDetector(
              onTap: () => showDialogSelected(context),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (event) => setState(() {
                  isHover = true;
                }),
                onExit: (event) => setState(() {
                  isHover = false;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 1,
                      color: colorTheme.onSecondary.withValues(alpha: .2),
                    ),
                    color: isHover ? colorTheme.primary : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedAdd01,
                        color: isHover ? Colors.white : colorTheme.onSecondary,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Agregar ${widget.title}",
                        style: TextStyle(
                          color: isHover
                              ? Colors.white
                              : colorTheme.onSecondary,
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
    );
  }
}

class BodyEmptyMedicalInformation extends StatelessWidget {
  final VoidCallback viewDialog;
  const BodyEmptyMedicalInformation({
    super.key,
    required this.colorTheme,
    required this.viewDialog,
  });

  final ColorScheme colorTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewDialog(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 100,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text(
            "¿Quieres seleccionar?",
            style: TextStyle(
              color: colorTheme.onSecondary.withValues(alpha: .3),
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class TitleInformationMedical extends StatelessWidget {
  const TitleInformationMedical({super.key, required this.widget});

  final ContentInformationMedical<Object?> widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(icon: widget.icon, color: widget.color),
          SizedBox(width: 12),
          Text(widget.title, style: widget.widget.labelStyle),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),

            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.listSelected != null
                  ? widget.listSelected!.length.toString()
                  : "0",
              style: TextStyle(
                color: widget.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContentDirectionPx extends StatefulWidget {
  const ContentDirectionPx({
    super.key,
    required this.textLabels,
    required this.color,
    this.directionText,
    required this.onchagedDirection,
  });

  final TextStyle textLabels;
  final ColorScheme color;
  final String? directionText;
  final ValueChanged<String> onchagedDirection;

  @override
  State<ContentDirectionPx> createState() => _ContentDirectionPxState();
}

class _ContentDirectionPxState extends State<ContentDirectionPx> {
  bool isDirection = false;
  bool isHover = false;
  final TextEditingController controllerDirection = TextEditingController();
  final Color colorDirection = AppColors.colors[1];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContainerTitle(
          styleLabel: widget.textLabels,
          color: colorDirection,
          title: "Dirección",
          subTitle: "Registro de la dirección domiciliaria del paciente.",
          icon: HugeIcons.strokeRoundedLocation01,
        ),

        SizedBox(height: 15),

        isDirection
            ? TextInput(
                hintText: "Ingrese la dirección...",
                controller: controllerDirection,
                onChanged: widget.onchagedDirection,
                color: widget.color,
                lines: 2,
              )
            : DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(15),
                  color: widget.color.onSecondary.withValues(alpha: .3),
                  dashPattern: [3, 5],
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isDirection = true;
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) => setState(() {
                      isHover = true;
                    }),
                    onExit: (event) => setState(() {
                      isHover = false;
                    }),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedAddCircle,
                            size: 25,
                            color: colorDirection,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Agregar dirección",
                            style: TextStyle(
                              fontSize: 17,
                              color: colorDirection,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class ContentPersonalData extends StatefulWidget {
  final String? sexPx;
  final ValueChanged<String> onchangedSex;
  final DateTime? dateBirthdate;
  final ValueChanged<DateTime> onchagedBirthdate;
  final String? phone;
  final ValueChanged<String> onchagedPhone;

  const ContentPersonalData({
    super.key,
    this.sexPx,
    required this.onchangedSex,
    this.dateBirthdate,
    required this.onchagedBirthdate,
    this.phone,
    required this.onchagedPhone,
  });

  @override
  State<ContentPersonalData> createState() => _ContentPersonalDataState();
}

class _ContentPersonalDataState extends State<ContentPersonalData> {
  late final PhoneNumberController phoneController;

  @override
  void initState() {
    super.initState();
    phoneController = PhoneNumberController(countryCode: 'HN');
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextStyle textLabels = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return Padding(
      padding: EdgeInsetsGeometry.only(top: 20),
      child: Row(
        children: [
          //? Seleccionador del sexo del paciente
          ContentSexSelect(
            color: color,
            textLabels: textLabels,
            sex: widget.sexPx,
            onChangedSex: widget.onchangedSex,
          ),
          SizedBox(width: 20),
          //? Fecha de nacimiento - Input
          ContentBirthdatePx(
            textLabels: textLabels,
            color: color,
            onChangedBirthdate: widget.onchagedBirthdate,
            birthdatePx: widget.dateBirthdate,
          ),
          SizedBox(width: 20),
          //? Telefono del paciente - Input
          ContentPhonePx(
            textLabels: textLabels,
            phoneController: phoneController,
            widget: widget,
            color: color,
          ),
        ],
      ),
    );
  }
}

class ContentPhonePx extends StatelessWidget {
  const ContentPhonePx({
    super.key,
    required this.textLabels,
    required this.phoneController,
    required this.widget,
    required this.color,
  });

  final TextStyle textLabels;
  final PhoneNumberController phoneController;
  final ContentPersonalData widget;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Teléfono", style: textLabels),
          SizedBox(height: 10),
          SizedBox(
            child: TextInput(
              hintText: "8872-8321",
              controller: phoneController,
              onChanged: widget.onchagedPhone,
              color: color,
              lines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ContentBirthdatePx extends ConsumerStatefulWidget {
  final TextStyle textLabels;
  final ColorScheme color;
  final DateTime? birthdatePx;
  final ValueChanged<DateTime> onChangedBirthdate;

  const ContentBirthdatePx({
    super.key,
    required this.textLabels,
    required this.color,
    this.birthdatePx,
    required this.onChangedBirthdate,
  });

  @override
  ConsumerState<ContentBirthdatePx> createState() => _ContentBirthdatePxState();
}

class _ContentBirthdatePxState extends ConsumerState<ContentBirthdatePx> {
  @override
  void initState() {
    super.initState();
  }

  Future<DateTime?> viewCalendar() async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectDate = ref.watch(addDataPxInput);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Fecha de nacimiento", style: widget.textLabels),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final date = await viewCalendar();
            if (date != null && selectDate.birthday != date) {
              widget.onChangedBirthdate(date);
            }
          },

          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              height: 55,
              width: 250,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              decoration: BoxDecoration(
                color: widget.color.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  HugeIcon(icon: HugeIcons.strokeRoundedCalendar02),
                  SizedBox(width: 15),
                  Text(
                    selectDate.birthday != null
                        ? DateFormat('dd/MM/yyyy').format(widget.birthdatePx!)
                        : "Seleccionar Fecha",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ContentSexSelect extends ConsumerStatefulWidget {
  final ColorScheme color;
  final TextStyle textLabels;
  final String? sex;
  final ValueChanged<String> onChangedSex;

  const ContentSexSelect({
    super.key,
    required this.color,
    required this.textLabels,
    this.sex,
    required this.onChangedSex,
  });

  @override
  ConsumerState<ContentSexSelect> createState() => _ContentSexSelectState();
}

class _ContentSexSelectState extends ConsumerState<ContentSexSelect> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sexo", style: widget.textLabels),
        SizedBox(height: 10),
        Row(
          children: [
            ButtonSelectOption(
              title: "Femenino",
              icon: HugeIcons.strokeRoundedFemaleSymbol,
              onTap: () => widget.onChangedSex("Femenino"),
              color: widget.sex == "Femenino"
                  ? Colors.pink
                  : widget.color.onSecondary.withValues(alpha: .6),
              onSelected: widget.sex == "Femenino",
            ),

            SizedBox(width: 10),

            ButtonSelectOption(
              title: "Masculino",
              onTap: () => widget.onChangedSex("Masculino"),
              icon: HugeIcons.strokeRoundedMaleSymbol,
              color: widget.sex == "Masculino"
                  ? Colors.blue
                  : widget.color.onSecondary.withValues(alpha: .6),
              onSelected: widget.sex == "Masculino",
            ),
          ],
        ),
      ],
    );
  }
}

class ButtonSelectOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool onSelected;
  final Color color;
  final dynamic icon;

  const ButtonSelectOption({
    super.key,
    required this.title,
    required this.onTap,
    required this.onSelected,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 55,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),

          decoration: BoxDecoration(
            border: Border.all(width: 1, color: color),
            borderRadius: BorderRadius.circular(20),
            color: onSelected
                ? color.withValues(alpha: .2)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              icon != null
                  ? HugeIcon(icon: icon, color: color)
                  : SizedBox.shrink(),
              icon != null ? SizedBox(width: 10) : SizedBox.shrink(),
              Text(title, style: TextStyle(color: color, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentPatientName extends StatefulWidget {
  final String? namesText;
  final String? lastNamesText;
  final ValueChanged<String> namesOnChaged;
  final ValueChanged<String> lastNamesOnChanged;
  const ContentPatientName({
    super.key,
    required this.namesText,
    required this.lastNamesText,
    required this.namesOnChaged,
    required this.lastNamesOnChanged,
  });

  @override
  State<ContentPatientName> createState() => _ContentPatientNameState();
}

class _ContentPatientNameState extends State<ContentPatientName> {
  late final TextEditingController controllerNames;
  late final TextEditingController controllerLastNames;

  @override
  void initState() {
    super.initState();

    controllerNames = TextEditingController(text: widget.namesText);
    controllerLastNames = TextEditingController(text: widget.lastNamesText);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textLabels = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return Row(
      children: [
        ContentInputsText(
          labelText: "Nombre(s)",
          hintText: "Ej. Juan Carlos",
          onChanged: widget.namesOnChaged,
          textLabels: textLabels,
          controller: controllerNames,
        ),

        SizedBox(width: 20),

        ContentInputsText(
          labelText: "Apellido(s)",
          hintText: "Ej. Perez López",
          onChanged: widget.lastNamesOnChanged,
          textLabels: textLabels,
          controller: controllerLastNames,
        ),
      ],
    );
  }
}

class ContentInputsText extends StatelessWidget {
  const ContentInputsText({
    super.key,
    required this.textLabels,
    required this.controller,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
  });
  final String labelText;
  final String hintText;
  final TextStyle textLabels;
  final TextEditingController controller;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return Expanded(
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText, style: textLabels),
            SizedBox(height: 10),
            TextInput(
              hintText: hintText,
              controller: controller,
              onChanged: onChanged,
              color: color,
              lines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class ContentHeaderDialog extends StatefulWidget {
  const ContentHeaderDialog({super.key});

  @override
  State<ContentHeaderDialog> createState() => _ContentHeaderDialogState();
}

class _ContentHeaderDialogState extends State<ContentHeaderDialog> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final childIcon = HugeIcon(
      icon: HugeIcons.strokeRoundedCancel01,
      color: isHover ? Colors.white70 : color.onSecondary,
    );

    return Row(
      children: [
        Text(
          "Crear Paciente",
          style: TextStyle(
            fontSize: 23,
            letterSpacing: 0,
            fontWeight: FontWeight.w600,
          ),
        ),

        Spacer(),

        GestureDetector(
          onTap: () => context.pop(),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (event) => setState(() {
              isHover = true;
            }),
            onExit: (event) => setState(() {
              isHover = false;
            }),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: color.onSecondary.withValues(alpha: .15),
                ),
                borderRadius: BorderRadius.circular(15),
                color: isHover ? Colors.red : Colors.transparent,
              ),
              child: isHover ? Spin(child: childIcon) : childIcon,
            ),
          ),
        ),
      ],
    );
  }
}

/*   Row(
                        children: List.generate(2, (index) {
                          return ChoiceChip(
                            color: WidgetStatePropertyAll(
                              value == index ? Colors.red : Colors.transparent,
                            ),
                            label: Text(sex[index]),
                            labelPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 8,
                            ),

                            selected: value == index,
                            onSelected: (bool newValue) {
                              setState(() {
                                value = newValue ? index : null;
                              });
                            },
                          );
                        }),
                      ), */
