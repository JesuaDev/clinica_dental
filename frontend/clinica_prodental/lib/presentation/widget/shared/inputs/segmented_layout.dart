import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../shared/shared.dart';

class SegmentedLayout extends ConsumerStatefulWidget {
  final ColorScheme color;
  final Function(Set value) onSelectedChanged;
  final LayoutType selectedType;

  const SegmentedLayout({
    super.key,
    required this.color,
    required this.onSelectedChanged,
    required this.selectedType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SegmentedLayoutState();
}

class _SegmentedLayoutState extends ConsumerState<SegmentedLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: widget.color.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: LayoutType.values.map((layout) {
          final selected = widget.selectedType == layout;

          return GestureDetector(
            onTap: () => widget.onSelectedChanged({layout}),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 45,
              decoration: BoxDecoration(
                color: selected
                    ? widget.color.onPrimary.withValues(alpha: .8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: widget.color.onSecondary.withValues(alpha: .2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: HugeIcon(
                icon: layout == LayoutType.grid
                    ? HugeIcons.strokeRoundedGridView
                    : HugeIcons.strokeRoundedListFilterPlus,
                color: selected
                    ? widget.color.onSecondary.withValues(alpha: .8)
                    : widget.color.onSecondary.withValues(alpha: .6),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
