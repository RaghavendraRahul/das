import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import 'package:project_pm/src/features/dashboard/dashboard_state.dart';
import 'package:project_pm/src/features/dashboard/models/search_result.dart';

import 'package:project_pm/src/features/dashboard/global_search_providers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';

class GlobalSearchOverlay extends HookConsumerWidget {
  final LayerLink layerLink;
  final VoidCallback onClose;
  final TextEditingController controller;

  const GlobalSearchOverlay({
    super.key,
    required this.layerLink,
    required this.onClose,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(globalSearchQueryProvider);
    final resultsAsync = ref.watch(globalSearchResultsProvider);
    final historyAsync = ref.watch(searchHistoryListProvider);
    final selectedIndex = ref.watch(globalSearchIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Compute flattened list for navigation (used by tiles for selection highlight)
    final List<dynamic> flatItems = useMemoized(() {
      if (query.isEmpty) {
        return historyAsync.value ?? [];
      } else {
        return resultsAsync.value ?? [];
      }
    }, [query, resultsAsync.value, historyAsync.value]);

    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      offset: const Offset(0, 48),
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 600, // Fixed wide overlay for premium feel
          constraints: const BoxConstraints(maxHeight: 500),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (query.isEmpty) ...[
                _buildSectionHeader(context, "Recent Searches", Icons.history),
                historyAsync.when(
                  data: (history) => history.isEmpty
                      ? const _NoResults(message: "No recent searches")
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: history.length,
                          itemBuilder: (context, index) => _HistoryTile(
                            query: history[index],
                            isSelected: selectedIndex == index,
                            onTap: () {
                              controller.text = history[index];
                              ref.read(globalSearchQueryProvider.notifier).state = history[index];
                            },
                          ),
                        ),
                  loading: () => const _LoadingIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ] else ...[
                resultsAsync.when(
                  data: (results) {
                    if (results.isEmpty) {
                      return const _NoResults(message: "No results found");
                    }
                    
                    return Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final result = results[index];
                          return _ResultTile(
                            result: result,
                            isSelected: selectedIndex == index,
                            onTap: () => _handleNavigation(context, ref, result),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const _LoadingIndicator(),
                  error: (err, _) => _NoResults(message: "Error searching: $err"),
                ),
              ],
              
              // Footer
              _buildFooter(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color ?? (isDark ? Colors.white54 : Colors.black45)),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: color ?? (isDark ? Colors.white54 : Colors.black45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        border: Border(
            top: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          _buildKeyHint("↑↓", "Navigate"),
          const SizedBox(width: 12),
          _buildKeyHint("↵", "Open"),
          const SizedBox(width: 12),
          _buildKeyHint("ESC", "Close"),
          const Spacer(),
          const Text(
            "Global Search v2.1",
            style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyHint(String key, String action) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(50),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.withAlpha(80)),
          ),
          child: Text(key, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 4),
        Text(action, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  void _handleNavigation(BuildContext context, WidgetRef ref, GlobalSearchResult result) {
    // Capture router and notifier BEFORE closing overlay — context becomes invalid after onClose()
    final router = AutoRouter.of(context);
    final projectIdNotifier = ref.read(selectedProjectIdProvider.notifier);

    ref.read(searchHistoryServiceProvider).addToHistory(result.title);
    onClose();

    switch (result.type) {
      case SearchResultType.project:
        projectIdNotifier.state = result.id.toString();
        router.push(const ProjectPlanRoute());
        break;
      case SearchResultType.task:
      case SearchResultType.subtask:
        projectIdNotifier.state = result.id.toString();
        router.push(const ProjectPlanRoute());
        break;
      case SearchResultType.employee:
        break;
      case SearchResultType.catalog:
        router.navigate(const TodayRoute());
        break;
    }
  }
}

class _HistoryTile extends StatelessWidget {
  final String query;
  final bool isSelected;
  final VoidCallback onTap;

  const _HistoryTile({required this.query, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history, size: 18, color: Colors.grey),
      title: Text(query, style: const TextStyle(fontSize: 13)),
      dense: true,
      onTap: onTap,
      tileColor: isSelected ? Colors.blue.withAlpha(30) : null,
      hoverColor: Colors.blue.withAlpha(20),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final GlobalSearchResult result;
  final bool isSelected;
  final VoidCallback onTap;

  const _ResultTile({required this.result, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: result.type.color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(result.type.icon, size: 18, color: result.type.color),
      ),
      title: Row(
        children: [
          Expanded(child: Text(result.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          if (result.status.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(result.status).withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                result.status.replaceAll('_', ' '),
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _getStatusColor(result.status)),
              ),
            ),
        ],
      ),
      subtitle: result.subtitle.isNotEmpty 
        ? Text(result.subtitle, style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54))
        : null,
      dense: false,
      onTap: onTap,
      tileColor: isSelected ? result.type.color.withAlpha(30) : null,
      hoverColor: result.type.color.withAlpha(20),
    );
  }

  Color _getStatusColor(String status) {
    final s = status.toUpperCase();
    if (s.contains('DONE') || s.contains('COMPLETE')) return Colors.green;
    if (s.contains('PROGRESS')) return Colors.blue;
    if (s.contains('PENDING')) return Colors.orange;
    if (s.contains('REJECTED')) return Colors.red;
    return Colors.grey;
  }
}

class _NoResults extends StatelessWidget {
  final String message;
  const _NoResults({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: Colors.grey.withAlpha(100)),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
