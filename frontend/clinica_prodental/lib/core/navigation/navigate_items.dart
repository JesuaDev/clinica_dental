import 'package:clinica_prodental/presentation/screens/screens.dart';
import 'package:hugeicons/hugeicons.dart';

class NavigateItems {
  final int? index;
  final String route;
  final String name;
  final dynamic icon;

  NavigateItems({
    this.index,
    required this.name,
    required this.icon,
    required this.route,
  });

  static final List<NavigateItems> itemsNavigate = [
    NavigateItems(
      index: 0,
      name: HomeScreen.namePage,
      route: '/home',
      icon: HugeIcons.strokeRoundedHome04,
    ),

    NavigateItems(
      index: 1,
      name: PxScreen.namePage,
      route: '/patient',
      icon: HugeIcons.strokeRoundedPatient,
    ),

    NavigateItems(
      index: 2,
      name: "Citas",
      route: '/citas',
      icon: HugeIcons.strokeRoundedCalendarUser,
    ),

    NavigateItems(
      index: 3,
      name: HomeScreen.namePage,
      route: '/calendar-reminders',
      icon: HugeIcons.strokeRoundedCalendar04,
    ),

    NavigateItems(
      index: 4,
      name: "Cajas",
      route: '/cajas',
      icon: HugeIcons.strokeRoundedMoneySafe,
    ),

    NavigateItems(
      index: 5,
      name: "Usuarios",
      route: '/usuarios',
      icon: HugeIcons.strokeRoundedUser,
    ),
    NavigateItems(
      index: 6,
      name: "Inventario",
      route: '/inventario',
      icon: HugeIcons.strokeRoundedDeliveryBox01,
    ),
  ];
}
