//? Modules Dart
import 'package:clinica_prodental/domain/entities/calendar/calendar_entity.dart';
import 'package:clinica_prodental/presentation/providers/features/reminders/infraestructure/data/reminders_providers.dart';
import 'package:clinica_prodental/presentation/widget/reminders/upcoming_task.dart';
import 'package:flutter/material.dart';

//? Modules Terceros
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hugeicons/hugeicons.dart';

//? Providers
/* import 'package:clinica_prodental/presentation/providers/providers_data/login/login_providers.dart'; */

//? Widgets
import 'package:clinica_prodental/presentation/widget/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const namePage = 'home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final color = Theme.of(context).colorScheme;
    return Scaffold(body: ContentDashboard());
  }
}

class ContentDashboard extends ConsumerStatefulWidget {
  const ContentDashboard({super.key});

  @override
  ConsumerState<ContentDashboard> createState() => _ContentDashboardState();
}

class _ContentDashboardState extends ConsumerState<ContentDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(createReminderProvider.notifier).getRemindersUpgcoming();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final userProfile = ref.watch(authUserProviders);
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;
    final List<CalendarEntity>? remindersUpcoming = ref
        .watch(createReminderProvider)
        .upcoming;

    return Row(
      children: [
        CustomAppBar(),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: color.onPrimary,
            child: _ContentDashboard(
              size: size,
              color: color,
              remindersUpcoming: remindersUpcoming ?? [],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContentDashboard extends StatelessWidget {
  const _ContentDashboard({
    required this.size,
    required this.color,
    required this.remindersUpcoming,
  });

  final Size size;
  final ColorScheme color;
  final List<CalendarEntity> remindersUpcoming;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 20),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard",
                style: TextStyle(
                  fontFamily: 'sora-light',
                  fontSize: 40,
                  letterSpacing: 1,
                ),
              ),

              LayoutBuilder(
                builder: (context, constraints) {
                  double cardWidth = 0;
                  final width = constraints.maxWidth;
                  int columns = 4;

                  final isDesktop = width > 1400;
                  final isTablet = width > 900 && width <= 1400;
                  final isLaptop = width >= 1024 && width < 1440;
                  double mainCardEstadistic = .7;

                  if (isDesktop) {
                    columns = 4;
                  }

                  if (isLaptop) {
                    columns = 3;
                  }

                  if (width < 700) {
                    columns = 1;
                  }

                  //final isMobile = width <= 900;

                  if (isDesktop) {
                    cardWidth = (width / 4) - 20;
                  } else if (isLaptop) {
                    cardWidth = (width / 3) - 20;
                  } else if (isTablet) {
                    cardWidth = (width / 2) - 20;
                  } else {
                    cardWidth = width;
                  }
                  return StaggeredGrid.count(
                    crossAxisCount: columns,

                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: mainCardEstadistic,

                        child: FadeIn(
                          duration: const Duration(milliseconds: 500),

                          child: CardDashboardEstadistic(
                            size: size,
                            color: color,
                            title: 'Ingresos',
                            numbers: 'L.35.2K',
                            percentage: '20%',
                            colorChart: color.primary,
                            widthCard: double.infinity,
                          ),
                        ),
                      ),

                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: mainCardEstadistic,

                        child: FadeIn(
                          duration: const Duration(milliseconds: 600),

                          child: CardDashboardEstadistic(
                            size: size,
                            color: color,
                            title: 'Gastos',
                            numbers: 'L.10.1K',
                            percentage: '10%',
                            colorChart: color.error,
                            widthCard: double.infinity,
                          ),
                        ),
                      ),

                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: mainCardEstadistic,

                        child: FadeIn(
                          duration: const Duration(milliseconds: 700),

                          child: CardDashboardEstadistic(
                            size: size,
                            color: color,
                            title: 'Ganancias N.',
                            numbers: 'L.45.2K',
                            percentage: '25%',
                            colorChart: color.primary,
                            widthCard: double.infinity,
                          ),
                        ),
                      ),

                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: mainCardEstadistic,

                        child: FadeIn(
                          duration: const Duration(milliseconds: 700),

                          child: UpcomingTask(
                            remindersUpcoming: remindersUpcoming,
                          ),
                        ),
                      ),

                      /*  StaggeredGridTile.count(
                        crossAxisCellCount: columns >= 2 ? 1 : 1,
                        mainAxisCellCount: columns <= 3 ? .75 : 1.4,

                        child: FadeIn(
                          duration: const Duration(milliseconds: 800),

                          child: CardDashboardListProduct(
                            cardWidth: double.infinity,

                            size: size,
                            color: color,
                          ),
                        ),
                      ), */

                      /* StaggeredGridTile.count(
                        crossAxisCellCount: columns <= 3 ? 1 : 2,
                        mainAxisCellCount: columns <= 3 ? .75 : 1.4,
                        child: CalenderTask(),
                      ), */
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDashboardListProduct extends StatefulWidget {
  const CardDashboardListProduct({
    super.key,
    required this.cardWidth,
    required this.size,
    required this.color,
  });

  final double cardWidth;
  final Size size;
  final ColorScheme color;

  @override
  State<CardDashboardListProduct> createState() =>
      _CardDashboardListProductState();
}

class _CardDashboardListProductState extends State<CardDashboardListProduct> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      thumbVisibility: false,
      interactive: false,
      thickness: 0,
      child: SizedBox(
        child: Container(
          width: widget.cardWidth,

          padding: EdgeInsets.only(top: 20, bottom: 15, left: 30, right: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: widget.color.secondary.withValues(alpha: .4),
          ),

          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              scrollbars: false,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TileCardProduct(size: widget.size, isTitle: true),
                  TileCardProduct(size: widget.size),
                  TileCardProduct(size: widget.size),
                  TileCardProduct(size: widget.size),
                  TileCardProduct(size: widget.size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TileCardProduct extends StatelessWidget {
  const TileCardProduct({super.key, required this.size, this.isTitle = false});

  final Size size;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
      fontSize: 20,
      fontFamily: 'sora-ligh',
      fontWeight: FontWeight.w200,
      letterSpacing: 1,
    );
    return DottedBorder(
      options: CustomPathDottedBorderOptions(
        strokeWidth: 1,
        dashPattern: [3, 10],
        color: Colors.white,
        customPath: (size) => Path()
          ..moveTo(0, size.height)
          ..relativeLineTo(size.width, 0),
      ),

      child: Container(
        width: size.width,
        padding: EdgeInsets.only(bottom: 10),
        margin: EdgeInsets.only(top: isTitle ? 0 : 30),
        child: isTitle
            ? Text("Próximo Comprar", style: titleStyle)
            : Row(
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYGQk4hmj5iDHTN5m4vqMKYFZiVLVA2eVWGg&s',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Espejito", style: titleStyle),
                      SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'sora-light',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          children: [
                            TextSpan(text: 'Cantidad:'),
                            TextSpan(
                              text: ' 10',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  GestureDetector(
                    onTap: () {},
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: SizedBox(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedMoreVertical,
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

class CardDashboardEstadistic extends StatefulWidget {
  final Size size;
  final ColorScheme color;
  final String title;
  final String numbers;
  final String percentage;
  final Color colorChart;
  final double widthCard;

  const CardDashboardEstadistic({
    super.key,
    required this.size,
    required this.color,
    required this.title,
    required this.numbers,
    required this.percentage,
    required this.colorChart,
    required this.widthCard,
  });

  @override
  State<CardDashboardEstadistic> createState() =>
      _CardDashboardEstadisticState();
}

class _CardDashboardEstadisticState extends State<CardDashboardEstadistic> {
  bool isZoom = false;

  @override
  Widget build(BuildContext context) {
    //final heightCard = widget.size.height * .35;

    final child = Container(
      padding: EdgeInsets.only(top: 20, bottom: 15, left: 30, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: widget.color.primary.withValues(alpha: 0.08),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentTitle(
            color: widget.color,
            title: widget.title,
            numbers: widget.numbers,
            percentage: widget.percentage,
          ),

          ContentChart(colorChart: widget.colorChart),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          isZoom = true;
        });
      },
      onExit: (event) {
        setState(() {
          isZoom = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,

        transform: Matrix4.identity()..translate(0.0, isZoom ? -5.0 : 0.0),

        child: child,
      ),
    );
  }
}

class ContentChart extends StatelessWidget {
  final Color colorChart;

  const ContentChart({super.key, required this.colorChart});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDesktop = size.width > 1400;
    final isLaptop = size.width >= 1024 && size.width < 1440;
    /*    final isTablet = size.width > 900 && size.width <= 1400;
    final isMobile = size.width <= 900; */

    return Expanded(
      child: Container(
        height: isDesktop
            ? 220
            : isLaptop
            ? 110
            : 100,
        padding: EdgeInsets.only(top: 20),

        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(enable: true),

          series: <LineSeries<Map<String, dynamic>, String>>[
            LineSeries<Map<String, dynamic>, String>(
              color: colorChart,
              dataSource: [
                {'x': 'Lun', 'y': 3522},
                {'x': 'Mart', 'y': 2800},
                {'x': 'Mier', 'y': 5032},
                {'x': 'Jue', 'y': 15000},
                {'x': 'Vie', 'y': 2023},
                {'x': 'Sab', 'y': 4021},
              ],
              xValueMapper: (data, _) => data['x'],
              yValueMapper: (data, _) => data['y'],
            ),
          ],
        ),
      ),
    );
  }
}

class ContentTitle extends StatelessWidget {
  const ContentTitle({
    super.key,
    required this.color,
    required this.title,
    required this.numbers,
    required this.percentage,
  });

  final ColorScheme color;
  final String title;
  final String numbers;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDesktop = size.width > 1400;
    final isLaptop = size.width >= 1024 && size.width < 1440;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'sora-ligh',
            fontWeight: FontWeight.w200,
            letterSpacing: 1,
          ),
        ),

        SizedBox(width: 10),

        Column(
          children: [
            Text(
              numbers,
              style: TextStyle(
                fontSize: isDesktop
                    ? 30
                    : isLaptop
                    ? 25
                    : 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [
                      HugeIcon(icon: HugeIcons.strokeRoundedArrowUp01),
                      Text(percentage, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),

                SizedBox(
                  width: 80,
                  child: Text(
                    "vs Semana Pasada",
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
