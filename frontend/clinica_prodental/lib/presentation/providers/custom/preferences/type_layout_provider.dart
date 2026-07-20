import 'package:flutter_riverpod/legacy.dart';
import '../../../shared/shared.dart';

final typeLayoutProvider =
    StateNotifierProvider<TypeLayoutProvider, LayoutType>((ref) {
      return TypeLayoutProvider();
    });

class TypeLayoutProvider extends StateNotifier<LayoutType> {
  TypeLayoutProvider() : super(LayoutType.grid);

  void toggleLayout(Set type) {
    state = type.first;
  }
}
