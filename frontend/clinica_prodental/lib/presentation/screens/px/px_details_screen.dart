import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PxDetailsScreen extends ConsumerStatefulWidget {
  static const namePage = 'px-details';
  final String idPx;

  const PxDetailsScreen({super.key, required this.idPx});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PxDetailsScreenState();
}

class _PxDetailsScreenState extends ConsumerState<PxDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(widget.idPx)));
  }
}
