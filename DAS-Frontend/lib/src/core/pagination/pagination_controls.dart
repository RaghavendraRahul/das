import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int pageSize; // Optional, to calculate total pages if needed
  final bool hasNext;
  final bool hasPrevious;
  final bool isLoading;
  final ValueChanged<int>? onPageSelected;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalItems,
    this.pageSize = 10,
    required this.hasNext,
    required this.hasPrevious,
    required this.isLoading,
    this.onNext,
    this.onPrevious,
    this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (totalItems == 0) return const SizedBox.shrink();

    final totalPages = (totalItems / pageSize).ceil();
    // If only 1 page, don't show controls
    if (totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          IconButton(
            onPressed: (hasPrevious && !isLoading) ? onPrevious : null,
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous Page',
            color: Theme.of(context).primaryColor,
            disabledColor: Colors.grey.shade400,
          ),

          const SizedBox(width: 8),

          // Page Numbers
          if (isLoading && totalPages > 1)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            ..._buildPageNumbers(context, totalPages),

          const SizedBox(width: 8),

          // Next Button
          IconButton(
            onPressed: (hasNext && !isLoading) ? onNext : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next Page',
            color: Theme.of(context).primaryColor,
            disabledColor: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context, int totalPages) {
    final List<Widget> buttons = [];

    // Logic to show a range of pages, e.g., 1 ... 4 5 6 ... 10
    // For simplicity in this iteration, we'll show simpler logic:
    // If total pages <= 7, show all.
    // Otherwise show First, ..., Current-1, Current, Current+1, ..., Last.

    if (totalPages <= 7) {
      for (int i = 1; i <= totalPages; i++) {
        buttons.add(_pageButton(context, i, i == currentPage));
      }
    } else {
      // First Page
      buttons.add(_pageButton(context, 1, 1 == currentPage));

      if (currentPage > 3) {
        buttons.add(const Text('...'));
      }

      // Middle Pages
      final start = (currentPage - 1).clamp(2, totalPages - 2);
      final end = (currentPage + 1).clamp(2, totalPages - 1);

      // Ensure we always show at least a small window
      if (start > 2 && (currentPage <= 3)) {
        // Near start, show 2, 3, 4
        for (int i = 2; i <= 4; i++) {
          buttons.add(_pageButton(context, i, i == currentPage));
        }
      } else if (end < totalPages - 1 && (currentPage >= totalPages - 2)) {
        // Near end, show last few
        for (int i = totalPages - 3; i <= totalPages - 1; i++) {
          buttons.add(_pageButton(context, i, i == currentPage));
        }
      } else {
        for (int i = start; i <= end; i++) {
          buttons.add(_pageButton(context, i, i == currentPage));
        }
      }

      if (currentPage < totalPages - 2) {
        buttons.add(const Text('...'));
      }

      // Last Page
      buttons.add(_pageButton(context, totalPages, totalPages == currentPage));
    }

    return buttons;
  }

  Widget _pageButton(BuildContext context, int page, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: isActive
          ? Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$page',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : InkWell(
              onTap: () => onPageSelected?.call(page),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('$page'),
              ),
            ),
    );
  }
}
