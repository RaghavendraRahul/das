import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:project_pm/src/core/constants/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import '../../core/utils/user_color_service.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';

import 'package:project_pm/src/core/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// ── Design tokens ────────────────────────────────────────────────────────────
const _kSidebarBg    = Color(0xFF05263E);   // dark navy
const _kActiveStart  = Color(0xFF3B82F6);   // blue gradient start
const _kActiveEnd    = Color(0xFF1D4ED8);   // blue gradient end
const _kBoxInactive  = Color(0x33000000);   // Semi-transparent black (20%) for a 'black shaded' look
const _kTextActive   = Colors.white;
const _kTextInactive = Color(0xFF8EA3B3);   // muted blue-grey
const _kBorder       = Color(0x1AFFFFFF);   // white-10%
// Box dimensions matching reference image
const _kBoxW = 62.0;
const _kBoxH = 46.0;
const _kBoxR = 12.0;

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
    final userRole = UserRole.fromString(currentUser.role);

    return Container(
      width: 88,   // slightly wider than default 80
      decoration: const BoxDecoration(
        color: _kSidebarBg,
        border: Border(right: BorderSide(color: _kBorder, width: 1)),
      ),
      child: Column(
        children: [
          // ── Logo ──────────────────────────────────────────────────────────
          _LogoArea(
            onTap: () {
              ref.read(selectedProjectIdProvider.notifier).state = null;
              onViewModeChange(ViewMode.dashboard);
            },
          ),

          // ── Nav items ─────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              children: [
                if (!isProjectSelected) ...[
                  _NavBox(
                    icon: Icons.grid_view_rounded,         // exact: 2×2 squares grid
                    label: 'Dashboard',
                    isActive: viewMode == ViewMode.dashboard,
                    onTap: () => onViewModeChange(ViewMode.dashboard),
                  ),
                  _NavBox(
                    icon: Icons.calendar_month,            // exact: calendar w/ date cells
                    label: 'Planner',
                    isActive: viewMode == ViewMode.today,
                    onTap: () => onViewModeChange(ViewMode.today),
                  ),
                  _NavBox(
                    icon: Icons.auto_stories,              // exact: open book w/ pages
                    label: 'Projects',
                    isActive: viewMode == ViewMode.projects,
                    onTap: () => onViewModeChange(ViewMode.projects),
                  ),
                  _NavBox(
                    icon: Icons.article_outlined,          // exact: lined document
                    label: 'Quick Notes',
                    isActive: viewMode == ViewMode.quickNotes,
                    onTap: () => onViewModeChange(ViewMode.quickNotes),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(color: _kBorder, height: 1, thickness: 1),
                  ),
                  const SizedBox(height: 12),
                ],

                if (isProjectSelected) ...[
                  // Back button
                  _NavBox(
                    icon: Icons.arrow_back_rounded,
                    label: 'Back',
                    isActive: false,
                    onTap: () {
                      ref.read(selectedProjectIdProvider.notifier).state = null;
                      onViewModeChange(ViewMode.dashboard);
                    },
                  ),
                  const SizedBox(height: 4),
                  const Divider(color: _kBorder, height: 1, thickness: 1),
                  const SizedBox(height: 4),
                  _NavBox(
                    icon: Icons.pie_chart_outline,
                    label: 'Overview',
                    isActive: viewMode == ViewMode.projectOverview,
                    onTap: () => onViewModeChange(ViewMode.projectOverview),
                  ),
                  _NavBox(
                    icon: Icons.list_alt_outlined,
                    label: 'Plan',
                    isActive: viewMode == ViewMode.plan,
                    onTap: () => onViewModeChange(ViewMode.plan),
                  ),
                  _NavBox(
                    icon: Icons.timeline_outlined,
                    label: 'Gantt',
                    isActive: viewMode == ViewMode.gantt,
                    onTap: () => onViewModeChange(ViewMode.gantt),
                  ),
                ],

                // ── Management items (no section header text) ──────────────
                if (!isProjectSelected &&
                    (userRole.isAdmin || userRole.isManager || userRole.isTeamLead)) ...[
                  const SizedBox(height: 4),
                  const Divider(color: _kBorder, height: 1, thickness: 1),
                  const SizedBox(height: 4),
                  _NavBox(
                    icon: Icons.groups_outlined,           // exact: group of people
                    label: 'Team Overview',
                    isActive: viewMode == ViewMode.teamOverview,
                    onTap: () => onViewModeChange(ViewMode.teamOverview),
                  ),
                  _NavBox(
                    icon: Icons.fact_check_outlined,       // exact: checklist clipboard
                    label: 'Approvals',
                    isActive: viewMode == ViewMode.approvals,
                    badge: pendingApprovalsCount,
                    onTap: () => onViewModeChange(ViewMode.approvals),
                  ),
                ],
              ],
            ),
          ),

          // ── Avatar + Logout ───────────────────────────────────────────────
          _BottomArea(
            currentUser: currentUser,
            userRole: userRole,
            onLogout: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
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
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    final launchedFromHrm = prefs.getBool('launched_from_hrm') ?? false;
                    final hrmOrigin = prefs.getString('hrm_origin') ?? '';
                    await prefs.remove('launched_from_hrm');
                    await prefs.remove('hrm_origin');
                    if (launchedFromHrm && hrmOrigin.isNotEmpty) {
                      html.window.location.href = hrmOrigin;
                      return;
                    }
                  } catch (_) {}
                  if (context.mounted) context.router.replaceNamed('/');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo Area
// ─────────────────────────────────────────────────────────────────────────────
class _LogoArea extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoArea({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _kBorder, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'DAS',
              style: GoogleFonts.orbitron(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual Nav Box (icon + label below)
// ─────────────────────────────────────────────────────────────────────────────
class _NavBox extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badge;

  const _NavBox({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge = 0,
  });

  @override
  State<_NavBox> createState() => _NavBoxState();
}

class _NavBoxState extends State<_NavBox> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.label,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 400),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Icon Box ────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: _kBoxW,
                  height: _kBoxH,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_kBoxR),
                    color: widget.isActive
                        ? Colors.white
                        : _hovered
                            ? const Color(0x22FFFFFF)
                            : _kBoxInactive,
                    boxShadow: widget.isActive
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: Icon(
                          widget.icon,
                          size: 26,             // Increased icon size to reduce padding feel
                          color: widget.isActive
                              ? _kActiveStart
                              : _kTextInactive,
                        ),
                      ),
                      // Badge
                      if (widget.badge > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: _kSidebarBg, width: 1.5),
                            ),
                            child: Text(
                              widget.badge > 9 ? '9+' : widget.badge.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // ── Label ───────────────────────────────────────────
                SizedBox(
                  width: _kBoxW,
                  child: Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight:
                          widget.isActive ? FontWeight.w700 : FontWeight.w500,
                      color: widget.isActive ? _kTextActive : _kTextInactive,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Area (avatar + logout)
// ─────────────────────────────────────────────────────────────────────────────
class _BottomArea extends StatelessWidget {
  final User currentUser;
  final UserRole userRole;
  final VoidCallback onLogout;

  const _BottomArea({
    required this.currentUser,
    required this.userRole,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1,
          color: _kBorder,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              // Avatar
              Tooltip(
                message: '${currentUser.name} • ${userRole.label}',
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      UserColorService.getColorForUser(currentUser.id),
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              // Logout button
              Tooltip(
                message: 'Logout',
                child: GestureDetector(
                  onTap: onLogout,
                  child: Container(
                    width: 52,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.red.withOpacity(0.15)),
                    ),
                    child: Icon(
                      FontAwesomeIcons.rightFromBracket,
                      size: 16,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
