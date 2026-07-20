import 'package:flutter/material.dart';

class Endpoints {
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 768 &&
      MediaQuery.sizeOf(context).width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1200;

  static bool isResizable(BuildContext context) =>
      MediaQuery.sizeOf(context).height == 850 &&
      MediaQuery.sizeOf(context).width == 1080;
}
