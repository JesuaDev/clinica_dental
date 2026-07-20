import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class Pagination extends StatefulWidget {
  final Function(int page) onChangePage;
  final int totalPages;
  final int page;
  final bool hasNext;
  final bool hasPrevius;
  final ColorScheme colorTheme;
  const Pagination({
    super.key,
    required this.onChangePage,
    required this.totalPages,
    required this.page,
    required this.hasNext,
    required this.hasPrevius,
    required this.colorTheme,
  });

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: widget.colorTheme.onPrimary,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: widget.colorTheme.secondary,
            offset: Offset(0, 3),
            blurRadius: 12,
          ),
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HasButton(
            hasPages: widget.hasPrevius,
            page: widget.page,
            onHasPage: (int page) {},
            icon: HugeIcons.strokeRoundedArrowLeft01,
            colorTheme: widget.colorTheme,
          ),

          SizedBox(width: 5),

          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: widget.colorTheme.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              spacing: 5,
              children: List.generate(widget.totalPages, (index) {
                final int pageIn = index + 1;

                return Pages(
                  widget: widget,
                  pageIn: pageIn,
                  page: widget.page,
                  onChangePage: (int page) {
                    widget.onChangePage(page);
                  },
                );
              }),
            ),
          ),

          SizedBox(width: 5),

          HasButton(
            hasPages: widget.hasPrevius,
            page: widget.page,
            onHasPage: (int page) {},
            icon: HugeIcons.strokeRoundedArrowRight01,
            colorTheme: widget.colorTheme,
          ),
        ],
      ),
    );
  }
}

class HasButton extends StatefulWidget {
  final dynamic icon;
  final bool hasPages;
  final int page;
  final Function(int page) onHasPage;
  final ColorScheme colorTheme;

  const HasButton({
    super.key,
    this.icon,
    required this.hasPages,
    required this.page,
    required this.onHasPage,
    required this.colorTheme,
  });

  @override
  State<HasButton> createState() => _HasButtonState();
}

class _HasButtonState extends State<HasButton> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.hasPages
          ? () {
              widget.onHasPage(widget.page);
            }
          : null,
      onHover: (value) {
        setState(() {
          isHover = value;
        });
      },
      mouseCursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isHover
              ? widget.colorTheme.primary
              : widget.colorTheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: HugeIcon(icon: widget.icon, size: 20),
      ),
    );
  }
}

class Pages extends StatefulWidget {
  const Pages({
    super.key,

    required this.widget,
    required this.pageIn,
    required this.onChangePage,
    required this.page,
  });

  final Pagination widget;
  final int pageIn;
  final int page;
  final Function(int page) onChangePage;

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChangePage(widget.pageIn);
      },
      onHover: (bool value) {
        setState(() {
          isHover = value;
        });
      },

      mouseCursor: SystemMouseCursors.click,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: isHover || widget.pageIn == widget.page
              ? widget.widget.colorTheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text("${widget.pageIn}"),
      ),
    );
  }
}
