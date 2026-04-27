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
    final selectedStatus = useState<String?>(null); // Default to 'All' to show everything initially

    // Sync state if employee role is detected after initial build
    useEffect(() {
      if (isEmployee && selectedProjectType.value == 'team') {
        selectedProjectType.value = 'my';
      }
      return null;
    }, [isEmployee]);

    final searchQuery = useState('');
    final searchController = useTextEditingController();
    useListenable(searchController);
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
        search: searchQuery.value,
        status: selectedStatus.value));

    // Watch page-1 counts for BOTH tabs in parallel — no extra API calls,
    // Riverpod caches these; they resolve from the same provider family.
    final myCountAsync = ref.watch(
        projectsPageProjectsProvider(page: 1, filter: 'my', search: '', status: selectedStatus.value));
    final teamCountAsync = ref.watch(
        projectsPageProjectsProvider(page: 1, filter: null, search: '', status: selectedStatus.value));

    final myCount = myCountAsync.valueOrNull?.count;
    final teamCount = teamCountAsync.valueOrNull?.count;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero toolbar — filters, search, and primary action in one row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2937) : Colors.white,
                borderRadius: BorderRadius.circular(24),
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
                          count: myCount,
                          onTap: () {
                            selectedProjectType.value = 'my';
                            currentPage.value = 1;
                          },
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
                            count: teamCount,
                            onTap: () {
                              selectedProjectType.value = 'team';
                              currentPage.value = 1;
                            },
                            isDark: isDark,
                          ),
                        ],
                      ],
                    ),
                  ),
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
                        _StatusButton(
                          label: 'All',
                          icon: Icons.filter_list_rounded,
                          isSelected: selectedStatus.value == null,
                          onTap: () {
                            selectedStatus.value = null;
                            currentPage.value = 1;
                          },
                          isDark: isDark,
                        ),
                        Container(
                            width: 1,
                            height: 24,
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade300),
                        _StatusButton(
                          label: 'Active',
                          icon: Icons.play_arrow_outlined,
                          isSelected: selectedStatus.value == 'ACTIVE',
                          onTap: () {
                            selectedStatus.value = 'ACTIVE';
                            currentPage.value = 1;
                          },
                          isDark: isDark,
                        ),
                        Container(
                            width: 1,
                            height: 24,
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade300),
                        _StatusButton(
                          label: 'Completed',
                          icon: Icons.check_circle_outline,
                          isSelected: selectedStatus.value == 'COMPLETED',
                          onTap: () {
                            selectedStatus.value = 'COMPLETED';
                            currentPage.value = 1;
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 300,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.transparent : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0B1B2F),
                          fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Search projects...",
                        hintStyle: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : const Color(0xFF94A3B8),
                            fontSize: 13),
                        prefixIcon: Icon(Icons.search,
                            color: isDark
                                ? Colors.grey.shade400
                                : const Color(0xFF94A3B8),
                            size: 18),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 42,
                        ),
                        suffixIcon:
                            searchController.text.isNotEmpty
                                ? MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => searchController.clear(),
                                      child: Icon(Icons.close,
                                          size: 16,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : const Color(0xFF94A3B8)),
                                    ),
                                  )
                                : null,
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
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
                          search: searchQuery.value,
                          status: selectedStatus.value));
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('New Project',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      backgroundColor: const Color(0xFF05263E),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: const Color(0xFF05263E).withAlpha(100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Grid Content
            Expanded(
              child: projectsAsync.when(
                data: (paginatedProjects) {
                  final projects = paginatedProjects.results;
                  final totalCount = paginatedProjects.count;
                  final totalPages = (totalCount / 8).ceil();

                  if (projects.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder_open_rounded,
                              size: 64,
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.value.isNotEmpty
                                ? 'No results for "${searchQuery.value}"'
                                : selectedProjectType.value == 'my'
                                    ? 'You have no projects yet'
                                    : 'No team projects found',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 360,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.05,
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
                                    .navigate(const ProjectOverviewRoute());
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
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
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
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
  final int? count;
  final VoidCallback onTap;
  final bool isDark;

  const _ProjectTypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF05263E);
    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.grey.shade400 : Colors.grey.shade600);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: textColor,
              ),
            ),
            // Count badge — fades/scales in when available
            if (count != null) ...[
              const SizedBox(width: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Container(
                  key: ValueKey(count),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withAlpha(50)
                        : (isDark
                            ? const Color(0xFF4B5563)
                            : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade700),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _StatusButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = label == 'Completed'
        ? Colors.green.shade700
        : (label == 'Active' ? Colors.blue.shade700 : const Color(0xFF05263E));
    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.grey.shade400 : Colors.grey.shade600);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
