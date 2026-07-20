import 'package:clinica_prodental/presentation/providers/custom/preferences/dark_ligth_mode_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/presentation/providers/features/auth/data/login_providers.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';
/* import 'package:flutter_svg/flutter_svg.dart'; */
import 'package:go_router/go_router.dart';

import 'package:clinica_prodental/presentation/screens/screens.dart';
import 'package:clinica_prodental/presentation/widget/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

class LoginScreen extends StatelessWidget {
  static const namePage = 'login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * .35,
            child: _ContentLogin(size: size),
          ),
          SizedBox(width: size.width * .65, child: _ContentImage()),
        ],
      ),
    );
  }
}

class _ContentLogin extends StatelessWidget {
  final Size size;

  const _ContentLogin({required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        children: [
          LogLetter(),

          SizedBox(height: size.height * .8, child: _ContentForm()),
        ],
      ),
    );
  }
}

class _ContentForm extends ConsumerStatefulWidget {
  const _ContentForm();

  @override
  ConsumerState<_ContentForm> createState() => _ContentFormState();
}

class _ContentFormState extends ConsumerState<_ContentForm> {
  late final TextEditingController userEmail;
  late final TextEditingController userPassword;

  @override
  void initState() {
    super.initState();

    userEmail = TextEditingController();
    userPassword = TextEditingController();
  }

  @override
  void dispose() {
    userEmail.dispose();
    userPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authUserProviders);
    final color = Theme.of(context).colorScheme;

    ref.listen(authUserProviders, (previus, next) {
      debugPrint("${next.user}");
      if (next.user != null) {
        context.replaceNamed(HomeScreen.namePage);
      }
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '¡Iniciar Sesión!',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'sora-regular',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 350,
          child: Text(
            'Para iniciar sesión en su cuenta, ingrese su correo y contraseña correctamente',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'sora-light',
              fontSize: 15,
              color: color.tertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 100),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Correo Electrónico",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 400,
              child: InputFormLogin(
                controller: userEmail,
                hintText: 'ejemplo@prodental.com',
                icon: HugeIcons.strokeRoundedMail01,
              ),
            ),
          ],
        ),

        SizedBox(height: 40),

        SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contraseña",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              InputFormLogin(
                controller: userPassword,
                hintText: 'Ingresa tu Contraseña',
                icon: HugeIcons.strokeRoundedLockPassword,
                isPassword: true,
              ),
            ],
          ),
        ),

        if (authProvider.error != null)
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              authProvider.error!.message,
              style: TextStyle(
                fontFamily: 'sora-light',
                fontSize: 16,
                color: color.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        Container(
          width: 400,
          height: 50,
          margin: EdgeInsets.only(top: 50),
          child: FilledButton(
            onPressed: () async {
              final dto = DtosLogin(
                emailUser: userEmail.text,
                passwordUser: userPassword.text,
              );

              await ref.read(authUserProviders.notifier).login(dto);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(color.primary),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 1,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InputFormLogin extends StatefulWidget {
  final String hintText;
  final dynamic icon;
  final bool isPassword;
  final TextEditingController controller;

  const InputFormLogin({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    required this.controller,
  });

  @override
  State<InputFormLogin> createState() => _InputFormLoginState();
}

class _InputFormLoginState extends State<InputFormLogin> {
  late bool password;

  @override
  void initState() {
    super.initState();
    password = widget.isPassword;
  }

  void handlePassword() {
    setState(() {
      password = !password;
    });
  }

  @override
  Widget build(BuildContext context) {
    //? Colores del sistema
    final color = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      obscureText: password,

      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
          child: SizedBox(
            width: 50,
            child: Row(
              children: [
                SizedBox(width: 10),
                HugeIcon(icon: widget.icon, color: color.tertiary),
                SizedBox(width: 8),
                Container(width: 1, height: 30, color: color.tertiary),
              ],
            ),
          ),
        ),

        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: color.tertiary),
        contentPadding: EdgeInsets.only(left: 30, top: 20, bottom: 20),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(width: 1, color: color.tertiary),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(width: 1, color: color.primary),
        ),

        suffixIcon: widget.isPassword
            ? Padding(
                padding: EdgeInsets.only(right: 10),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => handlePassword(),
                    child: Container(
                      child: HugeIcon(
                        icon: password
                            ? HugeIcons.strokeRoundedView
                            : HugeIcons.strokeRoundedViewOff,
                        color: color.tertiary,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}

class _ContentImage extends ConsumerStatefulWidget {
  const _ContentImage();

  @override
  ConsumerState<_ContentImage> createState() => _ContentImageState();
}

class _ContentImageState extends ConsumerState<_ContentImage> {
  @override
  Widget build(BuildContext context) {
    /*final Size size = MediaQuery.of(context).size; */

    final Color color = Theme.of(context).colorScheme.surface;
    final toogleMode = ref.watch(darkLightModeProvider);

    return Stack(
      children: [
        SizedBox.expand(
          child: Container(
            margin: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(30),
              child: Image.asset(
                'assets/images/front-pages/illustration_dental.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 10,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 60,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  ref.read(darkLightModeProvider.notifier).toggleMode();
                },
                child: Container(
                  child: HugeIcon(
                    icon: toogleMode
                        ? HugeIcons.strokeRoundedSun02
                        : HugeIcons.strokeRoundedMoon02,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
