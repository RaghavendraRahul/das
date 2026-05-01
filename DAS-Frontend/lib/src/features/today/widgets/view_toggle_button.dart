import 'package:flutter/material.dart';

class ViewToggleButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badgeCount;

  const ViewToggleButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.badgeCount,
  });

  @override
  State<ViewToggleButton> createState() => _ViewToggleButtonState();
}

class _ViewToggleButtonState extends State<ViewToggleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // When selected: White text/icon on Navy/Blue background
    // When unselected: Grey text/icon
    const isSelectedColor = Colors.white;
    final unselectedColor =
        isDark ? Colors.grey.shade500 : Colors.grey.shade600;

    final labelStyle = TextStyle(
      fontSize: 13,
      fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
      color: widget.isSelected ? isSelectedColor : unselectedColor,
      letterSpacing: 0.3,
    );

    // Sidebar Matching Selection Color
    final selectedBg =
        isDark ? const Color(0xFF312E81) : const Color(0xFF2563EB);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? selectedBg
                    : (_isHovered
                        ? (isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.shade200)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(8),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: selectedBg.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon,
                      size: 16,
                      color: widget.isSelected
                          ? isSelectedColor
                          : unselectedColor),
                  const SizedBox(width: 8),
                  Text(widget.label, style: labelStyle),
                  if (widget.badgeCount != null && widget.badgeCount! > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? Colors.white
                            : const Color(
                                0xFFEF4444), // White on blue, else Red
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${widget.badgeCount}',
                        style: TextStyle(
                          color: widget.isSelected ? selectedBg : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Subtle highlight indicator on top of blue background to give depth
          if (widget.isSelected)
            Positioned(
              left: 6,
              top: 6,
              bottom: 6,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
