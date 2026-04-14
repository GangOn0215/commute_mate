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
  // ── Design Tokens ──────────────────────────────────────
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);
  static const _bg = Color(0xFFF9FAFB);

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '카테고리',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _ink,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => setState(() => isOpen = !isOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isOpen ? _ink : _border,
                width: isOpen ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selected ?? '카테고리를 선택하세요',
                  style: TextStyle(
                    fontSize: 15,
                    color: widget.selected == null ? _muted : _ink,
                    fontWeight: widget.selected == null
                        ? FontWeight.w400
                        : FontWeight.w500,
                  ),
                ),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _muted,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: isOpen ? (widget.categories.length * 44.0) : 0,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(12),
            border: isOpen ? Border.all(color: _border) : null,
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: selected ? _bg : Colors.transparent,
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 14,
                        color: selected ? _ink : _muted,
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
