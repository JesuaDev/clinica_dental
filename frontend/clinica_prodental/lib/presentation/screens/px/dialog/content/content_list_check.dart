import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:lottie/lottie.dart';

class ContentListCheck<T> extends StatefulWidget {
  final String title;
  final dynamic icon;
  final Color color;
  final List<T> listItems;
  final List<T>? selectedItems;
  final String Function(T item) getName;
  final ValueChanged<List<T>>? onchagedSelected;
  final Future<T> Function(String name, String description) onAddItem;

  const ContentListCheck({
    super.key,
    required this.listItems,
    required this.getName,
    required this.onchagedSelected,
    this.selectedItems,
    required this.title,
    this.icon,
    required this.color,
    required this.onAddItem,
  });

  @override
  State<ContentListCheck> createState() => _ContentListCheckState<T>();
}

class _ContentListCheckState<T> extends State<ContentListCheck<T>> {
  late List<T> listSelected;
  late List<T> items;
  @override
  void initState() {
    super.initState();
    listSelected = [...?widget.selectedItems];
    items = [...widget.listItems];
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;

    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        width: 500,
        height: 600,
        child: Column(
          children: [
            TitleContentAddsItems(widget: widget),

            SizedBox(height: 10),
            ButtonNewItem(
              color: color,
              title: widget.title,
              onAddItem: widget.onAddItem,
              onAddLocalItem: (item) async {
                setState(() {
                  if (!items.contains(item)) {
                    items.add(item);
                  }
                });
              },
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: items.isEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: LottieBuilder.asset(
                                "assets/lottie/not-found.json",
                              ),
                            ),

                            SizedBox(
                              width: 400,
                              child: Text(
                                "No hay ningun registro de ${widget.title}",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: List.generate(items.length, (index) {
                          final item = items[index];

                          return Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: 2),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  if (listSelected.contains(item)) {
                                    listSelected.remove(item);
                                  } else {
                                    listSelected.add(item);
                                  }
                                });
                              },

                              tileColor: listSelected.contains(item)
                                  ? widget.color.withValues(alpha: .15)
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10),
                                side: BorderSide(
                                  width: 1,
                                  color: listSelected.contains(item)
                                      ? Colors.transparent
                                      : color.secondary.withValues(alpha: .8),
                                ),
                              ),
                              leading: HugeIcon(
                                icon: widget.icon,
                                color: widget.color,
                              ),
                              title: Text(
                                widget.getName(item),
                                style: TextStyle(
                                  color: listSelected.contains(item)
                                      ? widget.color
                                      : color.onSecondary,
                                ),
                              ),
                              trailing: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: listSelected.contains(item)
                                    ? HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedCheckmarkCircle03,
                                        key: ValueKey(true),
                                        color: widget.color,
                                      )
                                    : HugeIcon(
                                        icon: HugeIcons.strokeRoundedCircle,
                                        key: ValueKey(false),
                                      ),
                              ),
                            ),
                          );
                        }),
                      ),
              ),
            ),

            Spacer(),

            ButtonAddItem(
              onchagedSelected: widget.onchagedSelected,
              listSelected: listSelected,
              color: color,
              colorItemsMedical: widget.color,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonNewItem<T> extends ConsumerStatefulWidget {
  const ButtonNewItem({
    super.key,
    required this.color,
    required this.title,

    required this.onAddItem,
    required this.onAddLocalItem,
  });

  final ColorScheme color;
  final String title;
  final void Function(T item) onAddLocalItem;
  final Future<T> Function(String name, String description) onAddItem;

  @override
  ConsumerState<ButtonNewItem> createState() => _ButtonNewItemState<T>();
}

class _ButtonNewItemState<T> extends ConsumerState<ButtonNewItem<T>> {
  bool isAdd = false;
  bool isHover = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(10),
        color: widget.color.onSecondary.withValues(alpha: .2),
        dashPattern: [3, 5],
      ),
      child: isAdd
          ? SizedBox(
              height: 50,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Nombre de ${widget.title}",
                  hintStyle: TextStyle(
                    color: widget.color.onSecondary.withValues(alpha: .4),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),

                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () async {
                        final response = await widget.onAddItem(
                          controller.text,
                          "",
                        );
                        widget.onAddLocalItem(response);
                      },
                      child: MouseRegion(
                        onEnter: (event) => setState(() {
                          isHover = true;
                        }),
                        onExit: (event) => setState(() {
                          isHover = false;
                        }),
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedSent,
                              size: 23,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : GestureDetector(
              onTap: () => setState(() {
                isAdd = true;
              }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 500,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text("Agregar nuevo(a) ${widget.title}"),
              ),
            ),
    );
  }
}

class TitleContentAddsItems extends StatelessWidget {
  const TitleContentAddsItems({super.key, required this.widget});

  final ContentListCheck<Object?> widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // HugeIcon(icon: widget.icon, color: widget.color),
        SizedBox(width: 10),
        Text(
          "Agregar ${widget.title[0].toLowerCase()}${widget.title.substring(1)}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class ButtonAddItem<T> extends StatefulWidget {
  const ButtonAddItem({
    super.key,

    required this.listSelected,
    required this.color,
    required this.onchagedSelected,
    required this.colorItemsMedical,
  });
  final ValueChanged<List<T>>? onchagedSelected;
  final List<T>? listSelected;
  final ColorScheme color;
  final Color colorItemsMedical;

  @override
  State<ButtonAddItem<T>> createState() => _ButtonAddItemState<T>();
}

class _ButtonAddItemState<T> extends State<ButtonAddItem<T>> {
  bool isHover = false;
  bool isHoverCancel = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (event) => setState(() {
              isHoverCancel = true;
            }),
            onExit: (event) => setState(() {
              isHoverCancel = false;
            }),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isHoverCancel
                    ? widget.color.error
                    : widget.color.secondary.withValues(alpha: .8),
              ),
              child: Row(
                children: [
                  Text(
                    "Cancelar",
                    style: TextStyle(
                      color: isHoverCancel
                          ? Colors.white
                          : widget.color.onSecondary.withValues(alpha: .8),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Spacer(),
        GestureDetector(
          onTap: () {
            widget.onchagedSelected!(widget.listSelected!);
            Future.delayed(Duration(milliseconds: 300));
            context.pop();
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (event) => setState(() {
              isHover = true;
            }),

            onExit: (event) => setState(() {
              isHover = false;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isHover
                    ? widget.colorItemsMedical
                    : widget.colorItemsMedical.withValues(alpha: .15),
              ),
              child: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedAdd01,
                    color: isHover ? Colors.white : widget.colorItemsMedical,
                  ),
                  Text(
                    "Agregar seleccionadas (${widget.listSelected!.length})",
                    style: TextStyle(
                      color: isHover ? Colors.white : widget.colorItemsMedical,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
