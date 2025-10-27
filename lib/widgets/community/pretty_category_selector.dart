import 'package:flutter/material.dart';

class PrettyCategorySelector extends StatefulWidget {
  final List<String> categories;
  final String? selected;
  final void Function(String?) onChanged;

  const PrettyCategorySelector({
    super.key,
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<PrettyCategorySelector> createState() => _PrettyCategorySelectorState();
}

class _PrettyCategorySelectorState extends State<PrettyCategorySelector> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF4A4A4A),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => isOpen = !isOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E1E6), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selected ?? '카테고리를 선택하세요',
                  style: TextStyle(
                    color: widget.selected == null
                        ? Colors.grey.shade500
                        : const Color(0xFF2D2D2D),
                    fontSize: 14,
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF888888),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: isOpen ? (widget.categories.length * 44.0) : 0,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E4E7), width: 1.2),
            boxShadow: [
              if (isOpen)
                BoxShadow(
                  color: Colors.black.withAlpha(18),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: widget.categories.map((cat) {
                final bool selected = widget.selected == cat;
                return InkWell(
                  onTap: () {
                    widget.onChanged(cat);
                    setState(() => isOpen = false);
                  },
                  hoverColor: const Color(0xFFF1F1F4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: selected
                        ? const Color(0xFFEDE9FE)
                        : Colors.transparent,
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFF2D2D2D),
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
