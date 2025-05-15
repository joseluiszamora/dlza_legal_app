import 'package:flutter/material.dart';

class FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;
  final Color? selectedColor;
  final Color? backgroundColor;

  const FilterChipItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.selectedColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white70,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: backgroundColor ?? theme.chipTheme.backgroundColor,
      selectedColor:
          selectedColor ?? theme.colorScheme.primary.withOpacity(0.2),
      checkmarkColor: theme.colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side:
            isSelected
                ? BorderSide(color: theme.colorScheme.primary)
                : BorderSide.none,
      ),
    );
  }
}
