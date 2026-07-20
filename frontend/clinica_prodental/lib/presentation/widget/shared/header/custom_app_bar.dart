import 'package:flutter/material.dart';
import 'package:clinica_prodental/core/navigation/navigate_items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:clinica_prodental/presentation/providers/custom/preferences/dark_ligth_mode_provider.dart';
import 'package:clinica_prodental/domain/entities/user/user_with_profile.dart';
import 'package:clinica_prodental/presentation/providers/features/auth/data/login_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  const CustomAppBar({super.key});

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    //? Providers
    final user = ref.watch(authUserProviders).user;
    final isDark = ref.watch(darkLightModeProvider);
    //? Theme - MediaQuery
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;

    return Container(
      width: size.width * 0.07,
      height: size.height,
      color: color.secondary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            _AvatarUser(user: user),
            SizedBox(height: 60),
            ItemsNavigate(),

            Spacer(),

            ButtonToggleTheme(ref: ref, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class ItemsNavigate extends ConsumerStatefulWidget {
  const ItemsNavigate({super.key});

  @override
  ConsumerState<ItemsNavigate> createState() => _ItemsNavigateState();
}

class _ItemsNavigateState extends ConsumerState<ItemsNavigate> {
  //int _currentIndex = 0;
  int _prevIndex = 0;
  int currentIndex = 0;
  void currentItem({required int index, required String name}) {
    _prevIndex = _currentIndex(context);
    setState(() {});

    context.go(name);
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final int current = NavigateItems.itemsNavigate.indexWhere(
      (e) => e.route == location,
    );

    return current;
  }

  @override
  Widget build(BuildContext context) {
    //? Color Theme
    final color = Theme.of(context).colorScheme;
    final List<NavigateItems> listNavigate = NavigateItems.itemsNavigate;
    currentIndex = _currentIndex(context);

    return Column(
      children: List.generate(listNavigate.length, (index) {
        final item = listNavigate[index];
        final child = Container(width: 2, height: 25, color: color.primary);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //? Aqui Validamos si el index que oprimimos es el mismo al currentIndex ques es cuando se manda el mismo index a la funcion Void para que asigne ese valor al currentIndex
            currentIndex == index
                ? currentIndex < _prevIndex
                      ? SlideInUp(
                          from: 25,
                          duration: const Duration(milliseconds: 700),
                          child: child,
                        )
                      : SlideInDown(
                          from: 25,
                          duration: const Duration(milliseconds: 700),
                          child: child,
                        )
                : SizedBox.shrink(),
            GestureDetector(
              onTap: () => currentItem(index: index, name: item.route),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 25,
                  height: 25,
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: HugeIcon(
                    icon: item.icon,
                    color: currentIndex == index
                        ? color.primary
                        : color.onSecondary,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ButtonToggleTheme extends StatelessWidget {
  const ButtonToggleTheme({super.key, required this.ref, required this.isDark});

  final WidgetRef ref;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ref.read(darkLightModeProvider.notifier).toggleMode(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 25,
          height: 25,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: HugeIcon(
            icon: isDark
                ? HugeIcons.strokeRoundedSun02
                : HugeIcons.strokeRoundedMoon02,
          ),
        ),
      ),
    );
  }
}

class _AvatarUser extends StatelessWidget {
  const _AvatarUser({required this.user});

  final UserWithProfile? user;

  @override
  Widget build(BuildContext context) {
    //? Theme - MediaQuery
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;

    return SizedBox(
      width: 70,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: user != null
                    ? Image.asset(user!.profile.pictureUser, fit: BoxFit.cover)
                    : SizedBox.shrink(),
              ),
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 30,
              height: 25,
              padding: EdgeInsets.only(left: 10, top: 5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: user != null
                  ? Text(
                      user!.profile.nameUser[0],
                      style: TextStyle(color: Colors.white),
                    )
                  : SizedBox.shrink(),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 3,
              height: size.height * .5,
              decoration: BoxDecoration(
                color: color.primary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
