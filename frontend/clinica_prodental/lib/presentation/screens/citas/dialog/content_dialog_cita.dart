//? Framework Import
import 'package:clinica_prodental/helpers/format/date/combinate_date.dart';
import 'package:clinica_prodental/infraestructure/dtos/appoitment/dtos_date_appoitment.dart';
import 'package:clinica_prodental/infraestructure/dtos/appoitment/dtos_reminder.dart';
import 'package:clinica_prodental/presentation/providers/features/auth/data/login_providers.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/citas/cita_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/reminders/infraestructure/data/reminders_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//? External Import
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//? Local Import
import 'package:clinica_prodental/presentation/widget/widgets.dart';
import 'package:clinica_prodental/helpers/functions/date/function_hour.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/px_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/citas/cita_form_provider.dart';
import 'package:intl/intl.dart';
import 'package:phone_number_controller/phone_number_controller.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/patient/patient_dtos.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/add_data_px_input.dart';
import 'package:clinica_prodental/presentation/shared/shared.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/helpers/format/date/age_calculate.dart';
import 'package:clinica_prodental/presentation/providers/features/dentist/data/notifier/dentist_notifier_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/px_state.dart';

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
  List<String> listHour = [];

  bool isCreatePx = false;
  DateTime? date;

  late final TextEditingController controllerSearchPx;
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

    listHour = FunctionHour.addHours();
  }

  Future<DateTime?> selectDate() async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year + 2),
      initialDate: DateTime.now(),
    );
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
    final dentistProv = ref.watch(dentistNotifierProvider);
    final userProv = ref.watch(authUserProviders);
    //final citaRead = ref.read(citaFormProvider.notifier);
    //? Reads - Provider
    final readCitaForm = ref.read(citaFormProvider.notifier);
    final formPx = ref.read(addDataPxInput.notifier);
    //? Validaciones
    final bool searchIsNotEmpty =
        pxProv.search != null && pxProv.search!.isNotEmpty;
    final bool searchDentistIsNotEmpty =
        dentistProv.search != null && dentistProv.search!.isNotEmpty;
    final double heightCard = 90;
    final double maxHeight = 300;
    final double heightClampPx = heightClamp(
      heightCard,
      maxHeight,
      pxProv.search!.length,
    );
    final double heightClampDentist = heightClamp(
      heightCard,
      maxHeight,
      dentistProv.search!.length,
    );

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
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
                      child: ContentInputSearch(
                        onChangedSearch: (String value) {
                          Future.delayed(const Duration(milliseconds: 100));
                          ref.read(pxProvider.notifier).searchPx(value);
                        },
                        color: widget.color,
                      ),
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      flex: 1,
                      child: ButtonAddPatient(
                        theme: widget.color,
                        onAddPx: () {
                          setState(() {
                            isCreatePx = true;
                          });
                        },
                        isCreatePx: isCreatePx,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              layoutResult(
                citaFormProv.px,
                ResultSearch<PxEntity>(
                  items: pxProv.search!,
                  theme: widget.color,
                  onUpdateSelected: (selected) {
                    readCitaForm.updatePatient(selected!);
                  },
                  getItem: (item) => item,
                  getId: (item) => "PX${item.idPx}",
                  getName: (item) => item.fullNamePx,
                  getPhone: (item) => item.phone!,
                  getAge: (item) {
                    final age = AgeCalculate.calculate(item.birthdatePx);
                    return age;
                  },
                ),
                heightClampPx,
                searchIsNotEmpty,
                pxProv.isLoading,
                pxProv.error,
                widget.color,
                heightCard,
                ContainerSelectedResult<PxEntity>(
                  theme: widget.color,
                  isSelected: true,
                  onDeletedPx: () {
                    readCitaForm.clearPatient();
                    ref.read(pxProvider.notifier).clearPatient();
                  },
                  id: "PX${citaFormProv.px?.idPx}",
                  names: citaFormProv.px?.fullNamePx,
                  phone: citaFormProv.px?.phone,
                  age: AgeCalculate.calculate(citaFormProv.px?.birthdatePx),
                ),
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
                        (
                          String name,
                          String lastName,
                          String phone,
                          String age,
                        ) {
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

              SizedBox(height: 30),

              ContainerTitle(
                styleLabel: TextStyle(),
                color: widget.color.primary,
                title: "Información de la cita",
                icon: HugeIcons.strokeRoundedCalendar01,
                fontSize: 20,
              ),

              ContentInformationAppointment(
                theme: widget.color,

                heightClamp: heightClampDentist,
                searchIsNotEmpty: searchDentistIsNotEmpty,
                isLoading: dentistProv.isLoading!,
                error: dentistProv.error,
                listDentist: dentistProv.search,
                dentist: citaFormProv.dentist,
                selectedHour: citaFormProv.hourDate,
                listHour: listHour,

                onChangedSearch: (value) {
                  Future.delayed(const Duration(milliseconds: 100));
                  ref
                      .read(dentistNotifierProvider.notifier)
                      .dentistSearch(value);
                },
                onUpdateSelected: (selected) =>
                    readCitaForm.updateDentist(selected!),
                onDeleted: () => readCitaForm.clearDentist(),
                onChangedReason: (String value) =>
                    readCitaForm.updateReasonDate(value),
                oxnChangedHour: (String? newValue) {
                  setState(() {
                    readCitaForm.updateHour(newValue);
                  });
                },

                onUpdateIsReminder: (bool newValue) =>
                    readCitaForm.updateIsReminder(newValue),
                onChangedPrice: (String value) =>
                    readCitaForm.updatePrice(value),
                onChangedObservation: (String value) =>
                    readCitaForm.updateObservation(value),
                onChangedDiagnosis: (String value) =>
                    readCitaForm.updateDiagnosis(value),
                onAddDate: () async {
                  final dateSelected = await selectDate();

                  if (dateSelected != null && date != dateSelected) {
                    readCitaForm.updateDate(dateSelected);
                  }
                },

                date: citaFormProv.fechaAppointment,
                isReminder: citaFormProv.isReminder!,
              ),
            ],
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: widget.color.onPrimary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonActionText(
                  text: "Cancelar",
                  color: widget.color.error,
                  icon: HugeIcons.strokeRoundedCancel01,
                  onAction: () {
                    context.pop();
                  },
                ),
                SizedBox(width: 10),

                ButtonActionText(
                  text: "Guardar",
                  color: widget.color.primary,
                  icon: HugeIcons.strokeRoundedAdd01,
                  onAction: () {
                    if (!(citaFormProv.reasonDate != null)) {
                      return ViewDialog.viewDialog(
                        context,
                        "Datos incompletos",
                        "El campo << razón de la cita >> está vacio.",
                        TypeAnimation.warning,
                      );
                    }

                    if (!(citaFormProv.fechaAppointment != null)) {
                      return ViewDialog.viewDialog(
                        context,
                        "Datos incompletos",
                        "El campo << fecha de la cita >> está vacio.",
                        TypeAnimation.warning,
                      );
                    }

                    if (!(citaFormProv.hourDate != null)) {
                      return ViewDialog.viewDialog(
                        context,
                        "Datos incompletos",
                        "El campo <<hora de la cita>> está vacio.",
                        TypeAnimation.warning,
                      );
                    }

                    final DtosDateAppoitment dtos = DtosDateAppoitment(
                      reasonAppoitment: citaFormProv.reasonDate!,
                      fechaAppoitment: citaFormProv.fechaAppointment!,
                      hourDate: citaFormProv.hourDate!,
                      price: double.parse(citaFormProv.price!),
                      diagnosis: citaFormProv.diagnosis,
                      idPx: citaFormProv.px!.idPx,
                      observation: citaFormProv.observation,
                      idDentist: citaFormProv.dentist?.idDentist,
                    );

                    if (citaFormProv.isReminder!) {
                      final String hourEnd =
                          (int.parse(citaFormProv.hourDate!.substring(0, 1)) +
                                  2)
                              .toString() +
                          citaFormProv.hourDate!.substring(2);

                      final DtosReminder dtosReminder = DtosReminder(
                        titleReminder: "Cita: ${citaFormProv.reasonDate}",
                        descriptionReminder: "cita dental del paciente ",
                        dateInit: DateFormater.combineDateAndHour(
                          citaFormProv.fechaAppointment!,
                          citaFormProv.hourDate!,
                        ),
                        dateLimit: DateFormater.combineDateAndHour(
                          citaFormProv.fechaAppointment!,
                          hourEnd,
                        ),
                        idUser: userProv.user!.idUser,
                        idDentist: citaFormProv.dentist?.idDentist,
                      );

                      ref
                          .read(createReminderProvider.notifier)
                          .postReminder(dtosReminder);
                    }

                    ref
                        .read(citasProvider.notifier)
                        .postMedicalAppoitment(dtos);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ResultSearch<T> extends StatelessWidget {
  const ResultSearch({
    super.key,
    required this.items,
    required this.theme,
    required this.onUpdateSelected,
    required this.getItem,
    required this.getId,
    required this.getName,
    this.getPhone,
    this.getAge,
  });

  final List<T> items;
  final ColorScheme theme;
  final Function(T? selected) onUpdateSelected;
  final T Function(T) getItem;
  final String Function(T item) getId;
  final String Function(T item) getName;
  final String Function(T item)? getPhone;
  final int Function(T item)? getAge;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ContainerSelectedResult(
          theme: theme,
          onSelectedPx: onUpdateSelected,

          id: getId(item),
          names: getName(item),
          age: getAge!(item),
          phone: getPhone!(item),
          item: getItem(item),
        );
      },
    );
  }
}

class ContainerSelectedResult<T> extends StatelessWidget {
  const ContainerSelectedResult({
    super.key,

    required this.theme,
    this.onSelectedPx,
    this.isSelected = false,
    this.onDeletedPx,

    required this.id,
    required this.names,
    this.phone,
    this.age,
    this.item,
  });

  final ColorScheme theme;

  final bool isSelected;

  final void Function(T? selected)? onSelectedPx;
  final VoidCallback? onDeletedPx;
  final T? item;

  final String? id;
  final String? names;
  final String? phone;
  final int? age;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelectedPx?.call(item),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        height: 90,
        child: Row(
          children: [
            Avatar(color: theme.primary, id: id),

            SizedBox(width: 30),
            ContentBasicInformation(
              name: names,
              phone: phone,
              age: age,
              theme: theme,
            ),

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

class ContentBasicInformation extends StatelessWidget {
  const ContentBasicInformation({
    super.key,
    required this.theme,
    required this.name,
    this.phone,
    this.age,
  });

  final String? name;
  final String? phone;
  final int? age;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(name != null ? name! : "Sin nombre..."),
        SizedBox(height: 4),
        Row(
          children: [
            Text(
              "+504 ${phone ?? "Sin número de teléfono"}",
              style: TextStyle(color: theme.onSecondary.withValues(alpha: .25)),
            ),

            Text(" · ", style: TextStyle(color: theme.primary, fontSize: 17)),

            Text(
              " $age años",
              style: TextStyle(color: theme.onSecondary.withValues(alpha: .25)),
            ),
          ],
        ),
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.id, required this.color});

  final Color color;
  final String? id;

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
            ? Text(id != null ? id! : "XX")
            : HugeIcon(icon: HugeIcons.strokeRoundedUser02),
      ),
    );
  }
}

class ContentInputSearch extends StatefulWidget {
  final ValueChanged<String> onChangedSearch;
  final ColorScheme color;

  const ContentInputSearch({
    super.key,
    required this.onChangedSearch,
    required this.color,
  });

  @override
  State<ContentInputSearch> createState() => _ContentInputSearchState();
}

class _ContentInputSearchState extends State<ContentInputSearch> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: TextInputForm(
        hintText: "Buscar paciente por id, nombre o teléfono",
        controller: controller,
        onChanged: widget.onChangedSearch,
        color: widget.color,
        lines: 1,
      ),
    );
  }
}

class ContentInformationAppointment extends StatefulWidget {
  final ColorScheme theme;

  final String? selectedHour;
  final double heightClamp;
  final DateTime? date;

  final bool searchIsNotEmpty;
  final bool isLoading;
  final bool isReminder;

  final ErrorEntity? error;
  final DentistEntity? dentist;
  final List<DentistEntity>? listDentist;

  final ValueChanged<String> onChangedSearch;
  final ValueChanged<String> onChangedReason;
  final ValueChanged<String?> oxnChangedHour;
  final ValueChanged<String> onChangedPrice;
  final ValueChanged<String> onChangedObservation;
  final ValueChanged<String> onChangedDiagnosis;

  final Function(DentistEntity? dentist) onUpdateSelected;
  final Function() onAddDate;
  final Function(bool newValue) onUpdateIsReminder;

  final VoidCallback onDeleted;

  final List<String> listHour;

  const ContentInformationAppointment({
    super.key,
    required this.theme,
    required this.onChangedSearch,
    this.dentist,
    required this.heightClamp,
    required this.searchIsNotEmpty,
    required this.isLoading,
    required this.error,
    required this.listDentist,
    required this.onUpdateSelected,
    required this.onDeleted,
    required this.onChangedReason,
    required this.listHour,
    required this.oxnChangedHour,
    this.selectedHour,
    required this.onChangedPrice,
    required this.onChangedObservation,
    required this.onChangedDiagnosis,
    this.date,
    required this.onAddDate,
    required this.isReminder,
    required this.onUpdateIsReminder,
  });

  @override
  State<ContentInformationAppointment> createState() =>
      _ContentInformationAppointmentState();
}

class _ContentInformationAppointmentState
    extends State<ContentInformationAppointment> {
  late final TextEditingController controllerReasonAppointment;
  late final TextEditingController controllerSearchDentist;
  late final TextEditingController controllerObservation;
  late final TextEditingController controllerDiagnosis;

  @override
  void initState() {
    super.initState();
    controllerReasonAppointment = TextEditingController();
    controllerSearchDentist = TextEditingController();
    controllerObservation = TextEditingController();
    controllerDiagnosis = TextEditingController();
  }

  @override
  void dispose() {
    controllerReasonAppointment.dispose();
    controllerSearchDentist.dispose();
    controllerObservation.dispose();
    controllerDiagnosis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(height: 12),

                Row(
                  children: [
                    InputAndLabel(
                      label: 'Razón de la cita',
                      theme: widget.theme,
                      icon: HugeIcons.strokeRoundedDentalTooth,
                      constraintWidth: constraints.maxWidth * .48,

                      childInput: TextInputForm(
                        hintText: "(Ej.) Limpieza dental",
                        controller: controllerReasonAppointment,
                        onChanged: widget.onChangedReason,
                        color: widget.theme,
                        lines: 1,
                      ),
                    ),

                    SizedBox(width: 10),
                    InputAndLabel(
                      theme: widget.theme,
                      label: 'Dentista',
                      constraintWidth: constraints.maxWidth * .45,
                      icon: HugeIcons.strokeRoundedDoctor01,
                      childInput: TextInputForm(
                        hintText: "Buscar por Id, nombre, apellido",
                        controller: controllerSearchDentist,
                        onChanged: widget.onChangedSearch,
                        color: widget.theme,
                        lines: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                layoutResult<DentistEntity>(
                  widget.dentist,
                  ResultSearch<DentistEntity>(
                    items: widget.listDentist!,
                    theme: widget.theme,
                    onUpdateSelected: widget.onUpdateSelected,
                    getItem: (item) => item,
                    getId: (item) => "DT${item.idDentist}",
                    getName: (item) =>
                        "${item.nameDentist} ${item.lastNameDentist}",
                    getAge: (item) => item.age != null ? item.age! : 0,
                    getPhone: (item) => item.phone != null ? item.phone! : "",
                  ),
                  widget.heightClamp,
                  widget.searchIsNotEmpty,
                  widget.isLoading,
                  widget.error,
                  widget.theme,
                  90,
                  ContainerSelectedResult<DentistEntity>(
                    theme: widget.theme,
                    isSelected: true,
                    onDeletedPx: widget.onDeleted,
                    id: "DT${widget.dentist?.idDentist}",
                    names:
                        "${widget.dentist?.nameDentist} ${widget.dentist?.lastNameDentist}",
                    phone: widget.dentist?.phone,
                    age: AgeCalculate.calculate(widget.dentist?.age),
                  ),
                ),

                SizedBox(height: 18),

                ContentDateAndHour(
                  widget: widget,
                  selectedHour: widget.selectedHour,
                  onChangedHour: widget.oxnChangedHour,
                  constraints: constraints,
                  onAddDate: widget.onAddDate,
                  date: widget.date,
                ),

                SizedBox(height: 10),

                InputAndLabel(
                  label: "Precio",
                  theme: widget.theme,
                  constraintWidth: constraints.maxWidth,
                  icon: HugeIcons.strokeRoundedDollarCircle,
                  childInput: NumberInput(
                    theme: widget.theme,
                    onChanged: widget.onChangedPrice,
                  ),
                ),

                SizedBox(height: 15),

                ContainerSwitchReminder(
                  theme: widget.theme,
                  isReminder: widget.isReminder,
                  onUpdateIsReminder: widget.onUpdateIsReminder,
                ),

                SizedBox(height: 15),

                InputAndLabel(
                  label: "Observación",
                  theme: widget.theme,
                  constraintWidth: constraints.maxWidth,
                  childInput: TextInputForm(
                    hintText: "Escribe un diagnóstico. (opcional)",
                    controller: controllerDiagnosis,
                    onChanged: widget.onChangedDiagnosis,
                    color: widget.theme,
                    lines: 4,
                  ),
                ),
                SizedBox(height: 10),

                InputAndLabel(
                  label: "Tratamiento",
                  theme: widget.theme,
                  constraintWidth: constraints.maxWidth,
                  childInput: TextInputForm(
                    hintText: "Escribe el observación. (opcional)",
                    controller: controllerObservation,
                    onChanged: widget.onChangedObservation,
                    color: widget.theme,
                    lines: 4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ContainerSwitchReminder extends StatelessWidget {
  const ContainerSwitchReminder({
    super.key,
    required this.theme,
    required this.isReminder,
    required this.onUpdateIsReminder,
  });

  final ColorScheme theme;
  final bool isReminder;
  final Function(bool newValue) onUpdateIsReminder;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: ContainerTitle(
        styleLabel: TextStyle(),
        color: theme.primary,
        title: "Crear Recordatorio",
        subTitle: "Se agregará el recordatorio al calendario.",
        icon: HugeIcons.strokeRoundedNotification01,
      ),

      value: isReminder,
      onChanged: onUpdateIsReminder,
      mouseCursor: SystemMouseCursors.click,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      hoverColor: theme.primary.withValues(alpha: .2),
    );
  }
}

class ContentDateAndHour extends StatelessWidget {
  const ContentDateAndHour({
    super.key,
    required this.widget,
    required this.selectedHour,
    required this.onChangedHour,
    required this.constraints,
    this.date,
    required this.onAddDate,
  });

  final ContentInformationAppointment widget;
  final BoxConstraints constraints;

  final DateTime? date;
  final String? selectedHour;

  final ValueChanged<String?> onChangedHour;
  final Function() onAddDate;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HugeIcon(icon: HugeIcons.strokeRoundedCalendar02),
                SizedBox(width: 8),
                Text("Fecha de la cita"),
              ],
            ),

            SizedBox(height: 12),

            SizedBox(
              width: constraints.maxWidth * .50,
              child: ButtonSelectDate(
                color: widget.theme.onSecondary.withValues(alpha: .4),
                background: widget.theme.secondary,
                hint: date != null
                    ? DateFormat("dd/MM/yyyy").format(date!)
                    : 'Seleccionar fecha.',
                icon: HugeIcons.strokeRoundedCalendar01,
                onAddDate: onAddDate,
                date: date,
              ),
            ),
          ],
        ),

        SizedBox(width: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HugeIcon(icon: HugeIcons.strokeRoundedTime02),
                SizedBox(width: 8),
                Text("Hora de la cita"),
              ],
            ),

            SizedBox(height: 12),

            SizedBox(
              width: constraints.maxWidth * .42,
              child: DropDownHour(
                color: widget.theme,
                listHours: widget.listHour,

                onChanged: onChangedHour,
                backgroundColor: widget.theme.secondary,
                selected: selectedHour,
                hint: 'Seleccionar hora.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ButtonSelectDate extends StatefulWidget {
  final Color color;
  final Color background;
  final String hint;
  final dynamic icon;
  final Function() onAddDate;
  final DateTime? date;

  const ButtonSelectDate({
    super.key,
    required this.color,
    required this.hint,
    this.icon,
    required this.background,
    required this.onAddDate,
    this.date,
  });

  @override
  State<ButtonSelectDate> createState() => _ButtonSelectDateState();
}

class _ButtonSelectDateState extends State<ButtonSelectDate> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onAddDate,
      mouseCursor: SystemMouseCursors.click,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Text(
              widget.hint,
              style: TextStyle(color: widget.color, fontSize: 16),
            ),
            Spacer(),
            HugeIcon(icon: widget.icon, color: widget.color),
          ],
        ),
      ),
    );
  }
}

class InputAndLabel extends StatelessWidget {
  final String label;
  final dynamic icon;
  final ColorScheme theme;
  final double constraintWidth;
  final Widget childInput;

  const InputAndLabel({
    super.key,
    required this.label,
    this.icon,
    required this.theme,
    required this.constraintWidth,
    required this.childInput,
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

        SizedBox(width: constraintWidth, child: childInput),
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

Widget layoutResult<T>(
  T? entity,
  Widget result,
  double heightClamp,
  bool searchIsNotEmpty,
  bool? isLoading,
  ErrorEntity? error,
  ColorScheme theme,
  double heightCard,
  Widget contentCard,
) {
  return Column(
    children: [
      if (!(entity != null))
        AnimatedContainer(
          height: searchIsNotEmpty ? heightClamp : 0,
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: theme.secondary),
            borderRadius: BorderRadius.circular(15),
          ),
          child: isLoading!
              ? Center(child: LoaderIcon())
              : error != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MessageEmptyData(
                      widthLottie: 200,
                      message: error.message,
                      color: theme,
                    ),
                  ],
                )
              : result,
        ),

      if (entity != null) cardResult(contentCard, heightCard, theme),
    ],
  );
}

double heightClamp(double height, double maxHeight, int length) {
  return (height * length + 10).clamp(0, maxHeight);
}
