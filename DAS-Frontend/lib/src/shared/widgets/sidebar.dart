import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:project_pm/src/core/constants/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_pm/src/shared/providers/sidebar_providers.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import '../../core/utils/user_color_service.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';

import 'package:project_pm/src/core/database/database.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class Sidebar extends HookConsumerWidget {
  final User currentUser;
  final ViewMode viewMode;
  final Function(ViewMode) onViewModeChange;
  final bool isProjectSelected;
  final int pendingApprovalsCount;

  const Sidebar({
    super.key,
    required this.currentUser,
    required this.viewMode,
    required this.onViewModeChange,
    required this.isProjectSelected,
    this.pendingApprovalsCount = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIXED MINIMIZED: Hardcode isCollapsed to true
    const isCollapsed = true; 
    const isEffectivelyExpanded = false;

    // Parse role from string to enum for logic
    final userRole = UserRole.fromString(currentUser.role);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Themed Sidebar Color: #05263E
    const sidebarThemeColor = Color(0xFF05263E);

    final borderColor =
        isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2);

    // Backgrounds - Consistent blue theme as requested
    const sidebarBg = sidebarThemeColor;
    final spotlightGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        sidebarThemeColor,
        sidebarThemeColor.withOpacity(0.8),
      ],
    );

    const textColor = Colors.white;
    final mutedColor = Colors.white.withOpacity(0.7);
    final sectionColor = Colors.white.withOpacity(0.5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
      width: 80, // FIXED MINIMIZED: Always 80px
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: sidebarBg,
        gradient: spotlightGradient,
        border: Border(right: BorderSide(color: borderColor, width: 1.0)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
        ],
      ),
      child: Column(
        children: [
              // Logo Area
              Container(
                height: 88,
                padding: const EdgeInsets.symmetric(
                    horizontal: isEffectivelyExpanded ? 16 : 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                child: Row(
                  mainAxisAlignment: !isEffectivelyExpanded
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    // Wrap Logo and Text with InkWell for dashboard redirection
                    InkWell(
                      onTap: () {
                        ref.read(selectedProjectIdProvider.notifier).state =
                            null;
                        onViewModeChange(ViewMode.dashboard);
                      },
                      borderRadius: BorderRadius.circular(8),
                      hoverColor: Colors.white.withOpacity(0.05),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: isEffectivelyExpanded ? 8.0 : 0.0,
                            vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Professional Stylized Logo Icon
                            Container(
                              width: isEffectivelyExpanded
                                  ? 72
                                  : 44, // Reduced size when collapsed to fix overflow
                              height: isEffectivelyExpanded ? 72 : 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const SweepGradient(
                                  startAngle: 0.0,
                                  endAngle: 3.14 * 2,
                                  colors: [
                                    Color(0xFF00F2FE),
                                    Color(0xFF4FACFE),
                                    Color(0xFF764BA2),
                                    Color(0xFF667EEA),
                                    Color(0xFF00F2FE),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark ? Colors.blue.withOpacity(0.4) : Colors.blue.withOpacity(0.2),
                                    blurRadius: 12,
                                    spreadRadius: -1,
                                  ),
                                ],
                              ),
                              child: Tooltip(
                                message: !isEffectivelyExpanded ? 'Home / Dashboard' : '',
                                waitDuration: const Duration(milliseconds: 100),
                                child: Container(
                                  margin: const EdgeInsets.all(3.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(isEffectivelyExpanded
                                          ? 12.0
                                          : 4.0), // Smaller padding when collapsed
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/logo.jpeg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ).animate(onPlay: (c) => c.repeat()).shimmer(
                                      duration: 3.seconds,
                                      color: Colors.blue.shade100,
                                    ),
                              ),
                            ).animate(onPlay: (c) => c.repeat()).shimmer(
                                  duration: 4.seconds,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                            if (isEffectivelyExpanded) ...[
                              const SizedBox(width: 14),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DAS',
                                    style: GoogleFonts.orbitron(
                                      fontSize: 22, // Size adjusted for balance
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.5,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.blue.shade400
                                              .withOpacity(0.8),
                                          blurRadius: 10,
                                        ),
                                        const Shadow(
                                          color: Colors.white24,
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ).animate(onPlay: (c) => c.repeat()).shimmer(
                                      duration: 2.seconds,
                                      color: isDark ? Colors.blue.shade100 : Colors.blue.shade600.withOpacity(0.3)),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (isEffectivelyExpanded) const Spacer(),
                    if (isEffectivelyExpanded)
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 20),
                        onPressed: () => ref
                            .read(sidebarCollapsedProvider.notifier)
                            .state = true,
                        color: mutedColor,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                  ],
                ),
              ),

              // Toggle button removed (FIXED MINIMIZED)

              // Nav Links
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  children: [
                    // Show all items if no project is selected
                    if (!isProjectSelected) ...[
                      buildNavItem(
                          context,
                          isEffectivelyExpanded,
                          ViewMode.dashboard,
                          Icons.dashboard_outlined,
                          ViewMode.dashboard.label),
                      buildNavItem(
                          context,
                          isEffectivelyExpanded,
                          ViewMode.today,
                          Icons.date_range_outlined,
                          "Planner"),
                      buildNavItem(
                          context,
                          isEffectivelyExpanded,
                          ViewMode.projects,
                          Icons.menu_book_outlined,
                          ViewMode.projects.label),
                      buildNavItem(
                          context,
                          isEffectivelyExpanded,
                          ViewMode.quickNotes,
                          Icons.text_snippet_outlined,
                          ViewMode.quickNotes.label),
                    ],

                    if (isProjectSelected) ...[
                      // Back to Dashboard Button
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Tooltip(
                          message:
                              !isEffectivelyExpanded ? 'Back to Dashboard' : '',
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(selectedProjectIdProvider.notifier)
                                  .state = null;
                              onViewModeChange(ViewMode.dashboard);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: !isEffectivelyExpanded ? 0 : 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                mainAxisAlignment: !isEffectivelyExpanded
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.arrow_back,
                                      size: 20, color: mutedColor),
                                  if (isEffectivelyExpanded) ...[
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Back to Dashboard",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: mutedColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!isEffectivelyExpanded) ...[
                        Divider(height: 24, thickness: 1, color: borderColor),
                        buildNavItem(
                            context,
                            isEffectivelyExpanded,
                            ViewMode.projectOverview,
                            Icons.pie_chart_outline,
                            "Overview"),
                        buildNavItem(context, isEffectivelyExpanded,
                            ViewMode.plan, Icons.list_alt_outlined, "Plan"),
                        buildNavItem(context, isEffectivelyExpanded,
                            ViewMode.gantt, Icons.timeline_outlined, "Gantt"),
                        // buildNavItem(context, isEffectivelyExpanded,
                        //     ViewMode.grid, FontAwesomeIcons.tableCells, "Grid"),
                      ] else ...[
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              "CURRENT PROJECT",
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: sectionColor,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                            tilePadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            childrenPadding: EdgeInsets.zero,
                            iconColor: sectionColor,
                            collapsedIconColor: sectionColor,
                            children: [
                              buildNavItem(
                                  context,
                                  isEffectivelyExpanded,
                                  ViewMode.projectOverview,
                                  Icons.pie_chart_outline,
                                  ViewMode.projectOverview.label),
                              buildNavItem(
                                  context,
                                  isEffectivelyExpanded,
                                  ViewMode.plan,
                                  Icons.list_alt_outlined,
                                  ViewMode.plan.label),
                              buildNavItem(
                                  context,
                                  isEffectivelyExpanded,
                                  ViewMode.gantt,
                                  Icons.timeline_outlined,
                                  ViewMode.gantt.label),
                              // buildNavItem(
                              //     context,
                              //     isEffectivelyExpanded,
                              //     ViewMode.grid,
                              //     FontAwesomeIcons.tableCells,
                              //     ViewMode.grid.label),
                            ],
                          ),
                        ),
                      ],
                    ],

                    // Only show Management and General if NO project is selected
                    if (!isProjectSelected) ...[
                      if (userRole.isAdmin ||
                          userRole.isManager ||
                          userRole.isTeamLead) ...[
                        buildSectionTitle(isEffectivelyExpanded, borderColor,
                            sectionColor, "Management"),
                        buildNavItem(
                            context,
                            isEffectivelyExpanded,
                            ViewMode.teamOverview,
                            Icons.people_outline,
                            ViewMode.teamOverview.label),
                        buildNavItem(
                            context,
                            isEffectivelyExpanded,
                            ViewMode.approvals,
                            Icons.check_circle_outline,
                            ViewMode.approvals.label,
                            badge: pendingApprovalsCount),
                        if (userRole.isAdmin)
                          // Admin Panel removed
                          const SizedBox.shrink(),
                      ],
                    ],
                  ],
                ),
              ),

              // User Profile
              Container(
                padding: const EdgeInsets.all(isEffectivelyExpanded ? 16 : 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                child: Row(
                  mainAxisAlignment: !isEffectivelyExpanded
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: UserColorService.getColorForUser(currentUser.id),
                      backgroundImage: currentUser.avatarUrl.isNotEmpty
                          ? NetworkImage(currentUser.avatarUrl)
                          : null,
                      child: currentUser.avatarUrl.isEmpty
                          ? Text(
                              (currentUser.name.isNotEmpty
                                      ? currentUser.name[0]
                                      : '?')
                                  .toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    if (isEffectivelyExpanded) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: textColor,
                              ),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                            ),
                            Text(
                              userRole.label,
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Logout Button
              Container(
                padding: const EdgeInsets.fromLTRB(isEffectivelyExpanded ? 16 : 12, 0,
                    isEffectivelyExpanded ? 16 : 12, 16),
                child: Tooltip(
                  message: !isEffectivelyExpanded ? 'Logout' : '',
                  waitDuration: const Duration(milliseconds: 100),
                  child: InkWell(
                    onTap: () async {
                      // Show confirmation dialog
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true && context.mounted) {
                        await ref.read(authNotifierProvider.notifier).logout();
                        if (context.mounted) {
                          // Check if DAS was launched from HRM
                          try {
                            final prefs = await SharedPreferences.getInstance();
                            final launchedFromHrm =
                                prefs.getBool('launched_from_hrm') ?? false;
                            final hrmOrigin =
                                prefs.getString('hrm_origin') ?? '';

                            // Clear the HRM launch flags
                            await prefs.remove('launched_from_hrm');
                            await prefs.remove('hrm_origin');

                            if (launchedFromHrm && hrmOrigin.isNotEmpty) {
                              // Redirect back to HRM
                              html.window.location.href = hrmOrigin;
                              return;
                            }
                          } catch (_) {}

                          // Fallback: navigate to DAS login
                          if (context.mounted) {
                            context.router.replaceNamed('/');
                          }
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: !isEffectivelyExpanded ? 0 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: !isEffectivelyExpanded
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            FontAwesomeIcons.rightFromBracket,
                            size: 18,
                            color: Colors.red.shade400,
                          )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .shimmer(
                                  duration: 3.seconds,
                                  color: Colors.white.withOpacity(0.3)),
                          if (isEffectivelyExpanded) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'LOGOUT',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                  color: Colors.red.shade400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget buildNavItem(BuildContext context, bool isEffectivelyExpanded,
      ViewMode mode, IconData icon, String label,
      {int badge = 0}) {
    final isSelected = viewMode == mode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Selected item background: White-alpha for glass effect on the blue theme
    final selectedBg = Colors.white.withOpacity(0.15);

    final iconColor =
        isSelected ? Colors.white : Colors.white.withOpacity(0.5);

    final labelColor =
        isSelected ? Colors.white : Colors.white.withOpacity(0.6);

    return Tooltip(
      message:
          !isEffectivelyExpanded ? '$label ${badge > 0 ? "($badge)" : ""}' : '',
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 100),
      child: InkWell(
        onTap: () => onViewModeChange(mode),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: !isEffectivelyExpanded ? 0 : 16,
          ),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected && isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.transparent,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Sliding Spotlight Indicator
              if (isSelected)
                Positioned(
                  left: isEffectivelyExpanded ? -16 : -4,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: isDark ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ] : [],
                    ),
                  ).animate().fadeIn().scaleY(begin: 0.5),
                ),
              Row(
                mainAxisAlignment: !isEffectivelyExpanded
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(icon, size: 22, color: iconColor)
                          .animate(target: isSelected ? 1 : 0)
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.15, 1.15),
                            duration: 300.ms,
                            curve: Curves.easeOutBack,
                          )
                          .shimmer(
                              duration: 1.seconds,
                              color:
                                  Colors.blue.shade200.withOpacity(0.5)),
                      if (badge > 0 && !isEffectivelyExpanded)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF1E40AF), width: 1.5),
                            ),
                            child: Text(
                              badge > 9 ? '9+' : badge.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  if (isEffectivelyExpanded) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        label.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          letterSpacing: 0.5,
                          color: labelColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        softWrap: false,
                      ),
                    ),
                    if (badge > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge > 9 ? '9+' : badge.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(bool isEffectivelyExpanded, Color borderColor,
      Color sectionColor, String title) {
    if (!isEffectivelyExpanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Divider(color: borderColor, thickness: 1),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: sectionColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
