import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/dashboard/widgets/modern_project_card.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/routes/app_router.dart';

import 'package:project_pm/src/features/dashboard/modals/create_new_workspace_modal.dart';

import 'package:project_pm/src/shared/providers/sidebar_providers.dart';
import 'package:project_pm/src/core/pagination/pagination_controls.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';

@RoutePage()
class ProjectsPage extends HookConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useState(1);
    final currentUserAsync = ref.watch(currentUserProvider);
    final isEmployee = currentUserAsync.valueOrNull?.role == 'EMPLOYEE';

    final selectedProjectType = useState<String>(isEmployee ? 'my' : 'team');

    // Sync state if employee role is detected after initial build
    useEffect(() {
      if (isEmployee && selectedProjectType.value == 'team') {
        selectedProjectType.value = 'my';
      }
      return null;
    }, [isEmployee]);

    final searchQuery = useState('');
    final searchController = useTextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Debounce search input
    useEffect(() {
      Timer? debounceTimer;
      void listener() {
        debounceTimer?.cancel();
        debounceTimer = Timer(const Duration(milliseconds: 300), () {
          if (searchQuery.value != searchController.text) {
            searchQuery.value = searchController.text;
            currentPage.value = 1;
          }
        });
      }

      searchController.addListener(listener);
      return () {
        debounceTimer?.cancel();
        searchController.removeListener(listener);
      };
    }, [searchController]);

    final projectsAsync = ref.watch(projectsPageProjectsProvider(
        page: currentPage.value,
        filter: selectedProjectType.value == 'team'
            ? null
            : selectedProjectType.value,
        search: searchQuery.value));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero toolbar — filters, search, and primary action in one row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2937) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isDark ? const Color(0xFF374151) : Colors.grey.shade200,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isDark
                              ? Colors.transparent
                              : Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ProjectTypeButton(
                          label: 'My Projects',
                          icon: Icons.person_outline,
                          isSelected: selectedProjectType.value == 'my',
                          onTap: () => selectedProjectType.value = 'my',
                          isDark: isDark,
                        ),
                        if (!isEmployee) ...[
                          Container(
                              width: 1,
                              height: 24,
                              color: isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300),
                          _ProjectTypeButton(
                            label: 'Team Projects',
                            icon: Icons.group_outlined,
                            isSelected: selectedProjectType.value == 'team',
                            onTap: () => selectedProjectType.value = 'team',
                            isDark: isDark,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        hintText: "Search projects...",
                        hintStyle: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade500),
                        prefixIcon: Icon(Icons.search,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600),
                        suffixIcon:
                            useListenable(searchController).text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.close,
                                        size: 20,
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600),
                                    onPressed: () {
                                      searchController.clear();
                                    },
                                  )
                                : null,
                        filled: true,
                        fillColor:
                            isDark ? const Color(0xFF374151) : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: isDark
                                  ? Colors.transparent
                                  : Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: isDark
                                  ? Colors.transparent
                                  : Colors.grey.shade300),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  // Primary CTA
                  ElevatedButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const CreateNewWorkspaceModal(),
                      );
                      currentPage.value = 1;
                      ref.invalidate(projectsPageProjectsProvider(
                          page: 1,
                          filter: selectedProjectType.value == 'team'
                              ? null
                              : selectedProjectType.value,
                          search: searchQuery.value));
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Project'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: const Color(0xFF4F46E5).withAlpha(100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ), // Row
            ), // Container
            const SizedBox(height: 20),

            // Grid Content
            Expanded(
              child: projectsAsync.when(
                data: (paginatedProjects) {
                  final projects = paginatedProjects.results;
                  final totalCount = paginatedProjects.count;
                  final totalPages =
                      (totalCount / 8).ceil(); // Assuming page size is 8

                  if (projects.isEmpty) {
                    return Center(
                      child: Text(
                        "No projects found",
                        style: TextStyle(
                          color: isDark ? Colors.grey : Colors.grey.shade600,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 380,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            return ModernProjectCard(
                              project: projects[index],
                              isDark: isDark,
                              onTap: () {
                                ref
                                    .read(selectedProjectIdProvider.notifier)
                                    .state = projects[index].project.id;
                                ref
                                    .read(sidebarCollapsedProvider.notifier)
                                    .state = false;
                                context.router
                                    .navigate(const ProjectPlanRoute());
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Pagination Controls
                      if (totalPages > 1)
                        PaginationControls(
                          currentPage: currentPage.value,
                          totalItems: totalCount,
                          pageSize: 8,
                          hasNext: paginatedProjects.next != null,
                          hasPrevious: paginatedProjects.previous != null,
                          isLoading: false,
                          onNext: () => currentPage.value++,
                          onPrevious: () => currentPage.value--,
                          onPageSelected: (page) => currentPage.value = page,
                        ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _ProjectTypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF4F46E5) : const Color(0xFFEEF2FF))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF4F46E5))
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF4F46E5))
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
