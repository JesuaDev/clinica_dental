import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewError extends StatelessWidget {
  final int? statusCode;
  final String? message;

  const ViewError({super.key, required this.statusCode, this.message});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //final ColorScheme color = Theme.of(context).colorScheme;

    final nameSvg = statusCode == 404
        ? "404-error"
        : statusCode == 400
        ? "400-error"
        : "500-error";

    final String messageError = statusCode == 500
        ? "Nuestro servidor de mantenimiento está experimentando problemas técnicos ¡Ten paciencia mientras hacemos nuestra magia! "
        : "¡Uy! Parece que la solicitud de la consulta que buscas se ha tomado un descanso para el café. Vamos a redirigirte de vuelta al panel de control.";

    return LayoutBuilder(
      builder: (context, constraints) {
        final List<Widget> children = [
          SizedBox(
            width: size.width * .4,
            height: constraints.maxWidth <= size.width * .65
                ? size.height * .45
                : size.height * .7,
            child: SvgPicture.asset(
              "assets/images/svg/$nameSvg.svg",
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 40),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * .3,

                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Oops!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: "\n"),
                      TextSpan(text: "\n"),
                      TextSpan(text: messageError),
                    ],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              SizedBox(height: 30),
              GestureDetector(
                onTap: () {},
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Ir al panel de control",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ];

        return Container(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          child: constraints.maxWidth <= size.width * .65
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
        );
      },
    );
  }
}
