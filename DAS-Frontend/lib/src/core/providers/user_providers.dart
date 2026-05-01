import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/database/database_provider.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import 'package:project_pm/src/features/team/team_api_service.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as drift;
import '../utils/user_color_service.dart';

/// Current user ID - handles role-based authorization for user switching
final currentUserIdProvider = NotifierProvider<UserIdentifierNotifier, String?>(UserIdentifierNotifier.new);

class UserIdentifierNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  /// Update the current user ID
  void updateId(String? newId) {
    state = newId;
  }

  /// Reset to the original logged-in user
  void reset() {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    if (authState != null) {
      state = authState.userId.toString();
    } else {
      state = null;
    }
  }
}

/// User being impersonated from (for manager view-as feature)
final impersonatingFromUserIdProvider = StateProvider<String?>((ref) => null);

/// Name of the impersonated user (for display in UI)
final impersonatingUserNameProvider = StateProvider<String?>((ref) => null);

/// Load impersonated user name. Falls back to SharedPreferences if not in StateProvider
final impersonatingUserNameFutureProvider =
    FutureProvider<String?>((ref) async {
  final nameState = ref.watch(impersonatingUserNameProvider);
  if (nameState != null) return nameState;

  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('impersonate_user_name');
});

/// The employee the admin is currently viewing in read-only mode from Team Overview.
/// When set, the admin view pages display this employee's data.
/// Setting to null means admin is viewing their own data.
final viewingUserProvider = StateProvider<User?>((ref) => null);

/// Whether the app is in read-only mode (when impersonating)
final isReadOnlyProvider = Provider<bool>((ref) {
  return ref.watch(impersonatingFromUserIdProvider) != null;
});

/// All users from database or API
final allUsersProvider = FutureProvider<List<User>>((ref) async {
  ref.keepAlive(); // Cache user list — used by all feature modules
  if (kIsWeb) {
    // Fetch from backend API for web
    try {
      final teamApi = ref.read(teamApiServiceProvider);
      final response = await teamApi.getTeamMembers();
      final members = response['members'] as List;

      return members
          .map((json) => User(
                id: json['id'].toString(),
                name: json['name'] != null &&
                        (json['name'] as String).trim().isNotEmpty
                    ? json['name'] as String
                    : (json['email'] as String)
                        .split('@')[0]
                        .replaceAll('.', ' ')
                        .replaceAll('_', ' ')
                        .trim(),
                email: json['email'],
                role: _normalizeRole(json['role'] as String),
                department: json['department'],
                avatarUrl: _generateAvatarUrl(
                    json['name'] ?? json['email'].split('@')[0], json['id']),
                reportingManagerId: null,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error fetching users from API: $e');
      // Fallback to empty list or show error
      return [];
    }
  }
  final db = ref.read(databaseProvider);
  return db.select(db.users).get();
});

/// All users for project assignments (includes admins, managers, etc.)
/// This provider fetches all active users regardless of the current user's role
final allUsersForProjectsProvider = FutureProvider<List<User>>((ref) async {
  ref.keepAlive(); // Cache all-users list — prevents redundant API calls on every module
  if (kIsWeb) {
    // Fetch from backend API with all_users=true parameter
    try {
      final teamApi = ref.read(teamApiServiceProvider);
      final response = await teamApi.getTeamMembers(allUsers: true);
      final members = response['members'] as List;

      return members
          .map((json) => User(
                id: json['id'].toString(),
                name: json['name'] != null &&
                        (json['name'] as String).trim().isNotEmpty
                    ? json['name'] as String
                    : (json['email'] as String)
                        .split('@')[0]
                        .replaceAll('.', ' ')
                        .replaceAll('_', ' ')
                        .trim(),
                email: json['email'],
                role: _normalizeRole(json['role'] as String),
                department: json['department'],
                avatarUrl: _generateAvatarUrl(
                    json['name'] ?? json['email'].split('@')[0], json['id']),
                reportingManagerId: null,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error fetching all users for projects from API: $e');
      return [];
    }
  }
  final db = ref.read(databaseProvider);
  return db.select(db.users).get();
});

/// Normalize backend role strings so 'TEAMLEAD' becomes 'TEAM_LEAD' etc.
String _normalizeRole(String role) {
  switch (role.toUpperCase()) {
    case 'TEAMLEAD':
      return 'TEAM_LEAD';
    case 'ADMIN':
      return 'ADMIN';
    case 'MANAGER':
      return 'MANAGER';
    default:
      return role.toUpperCase();
  }
}

/// Generate avatar URL using ui-avatars.com
String _generateAvatarUrl(String name, dynamic userId) {
  final hexColor = UserColorService.getHexColorForUser(userId);
  final encodedName = Uri.encodeComponent(name);
  return 'https://ui-avatars.com/api/?name=$encodedName&background=$hexColor&color=fff';
}

/// Current user object - Optimized for zero-latency refresh
final currentUserProvider = FutureProvider<User?>((ref) async {
  ref.keepAlive(); // Cache current user — prevents profile re-fetch on every rebuild
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;

  // 1. FAST PATH: Use AuthNotifier's cached state to return immediately
  final authStateAsync = ref.watch(authNotifierProvider);
  final authState = authStateAsync.valueOrNull;

  if (authState != null &&
      authState.isAuthenticated &&
      authState.userId.toString() == userId) {
    // We can immediately construct a user object from auth state
    final basicUser = User(
      id: userId,
      name: authState.userEmail?.split('@')[0].replaceAll('.', ' ').trim() ??
          'User',
      email: authState.userEmail ?? '',
      role: _normalizeRole(authState.userRole?.name.toUpperCase() ?? 'USER'),
      department: null, // Will be filled by background fetch if needed
      avatarUrl: _generateAvatarUrl(authState.userEmail ?? userId, userId),
      reportingManagerId: null,
    );

    // For local database, we still want the specific user record if possible
    final db = ref.read(databaseProvider);
    
    // Trigger background update without awaiting it for the initial return
    _fetchFullProfile(ref, userId).then((fullUser) async {
      if (fullUser != null && !kIsWeb) {
        // Update local database with the latest profile from server
        await db.into(db.users).insertOnConflictUpdate(
          UsersCompanion(
            id: drift.Value(fullUser.id),
            name: drift.Value(fullUser.name),
            email: drift.Value(fullUser.email),
            role: drift.Value(fullUser.role),
            department: drift.Value(fullUser.department),
            avatarUrl: drift.Value(fullUser.avatarUrl),
          )
        );
        // Invalidate so the UI rebuilds with the new localUser
        ref.invalidateSelf();
      }
    }).catchError((e) {
      debugPrint('Background profile fetch failed: $e');
    });

    if (kIsWeb) {
      return basicUser;
    }

    final localUser = await (db.select(db.users)
          ..where((t) => t.id.equals(userId)))
        .getSingleOrNull();
    return localUser ?? basicUser;
  }

  // 2. FALLBACK PATH: Only used if authState is missing (unlikely if authenticated)
  try {
    final fullUser = await _fetchFullProfile(ref, userId);
    if (fullUser != null && !kIsWeb) {
      final db = ref.read(databaseProvider);
      await db.into(db.users).insertOnConflictUpdate(
        UsersCompanion(
          id: drift.Value(fullUser.id),
          name: drift.Value(fullUser.name),
          email: drift.Value(fullUser.email),
          role: drift.Value(fullUser.role),
          department: drift.Value(fullUser.department),
          avatarUrl: drift.Value(fullUser.avatarUrl),
        )
      );
    }
    return fullUser;
  } catch (e) {
    debugPrint('Error in fallback profile fetch: $e');
    if (!kIsWeb) {
      final db = ref.read(databaseProvider);
      return (db.select(db.users)..where((t) => t.id.equals(userId))).getSingleOrNull();
    }
    return null;
  }
});

/// Helper to fetch full profile from API
Future<User?> _fetchFullProfile(Ref ref, String userId) async {
  try {
    final dio = ref.read(dioProvider);
    final response = await dio.get('/user-preferences/me/');
    final data = response.data as Map<String, dynamic>;

    final rawRole = (data['role'] as String? ?? 'USER');
    return User(
      id: data['id'].toString(),
      name: data['name'] ??
          (data['email'] as String)
              .split('@')[0]
              .replaceAll('.', ' ')
              .replaceAll('_', ' ')
              .trim(),
      email: data['email'],
      role: _normalizeRole(rawRole),
      department: data['department'],
      avatarUrl: _generateAvatarUrl(data['name'] ?? data['email'], data['id']),
      reportingManagerId: null,
    );
  } catch (e) {
    debugPrint('Error fetching full profile: $e');
    rethrow;
  }
}

/// Provider to fetch stats for all users from backend API
final teamStatsProvider =
    FutureProvider<Map<String, Map<String, int>>>((ref) async {
  if (kIsWeb) {
    // Fetch from backend API for web
    try {
      final teamApi = ref.read(teamApiServiceProvider);
      final response = await teamApi.getTeamMembers();
      final members = response['members'] as List;

      final Map<String, Map<String, int>> stats = {};

      for (final member in members) {
        final userId = member['id'].toString();
        stats[userId] = {
          'active': member['active_tasks'] ?? 0,
          'completed': member['completed_tasks'] ?? 0,
          'workload': member['workload_intensity'] ?? 0,
        };
      }

      return stats;
    } catch (e) {
      debugPrint('Error fetching team stats from API: $e');
      return {};
    }
  }

  // Fallback to local database for non-web platforms
  final db = ref.read(databaseProvider);
  final allTasks = await db.select(db.tasks).get();

  final Map<String, Map<String, int>> stats = {};

  for (final task in allTasks) {
    final assigneesStr = task.assigneesJson;
    List<String> assigneeIds = [];
    try {
      assigneeIds = assigneesStr
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } catch (_) {
      continue;
    }

    final isCompleted = task.progress >= 100;

    for (final userId in assigneeIds) {
      if (!stats.containsKey(userId)) {
        stats[userId] = {'active': 0, 'completed': 0, 'workload': 0};
      }

      if (isCompleted) {
        stats[userId]!['completed'] = (stats[userId]!['completed'] ?? 0) + 1;
      } else {
        stats[userId]!['active'] = (stats[userId]!['active'] ?? 0) + 1;
        int currentWorkload = stats[userId]!['workload'] ?? 0;
        stats[userId]!['workload'] = (currentWorkload + 10).clamp(0, 100);
      }
    }
  }

  return stats;
});

/// Utility to get all reports (direct + indirect) for a manager
List<User> getReports(String managerId, List<User> allUsers) {
  final directReports =
      allUsers.where((u) => u.reportingManagerId == managerId).toList();
  List<User> allReports = [...directReports];
  for (final report in directReports) {
    allReports.addAll(getReports(report.id, allUsers));
  }
  return allReports;
}

/// Team members visible to current user based on role
final visibleTeamMembersProvider = Provider<List<User>>((ref) {
  final currentUserAsync = ref.watch(currentUserProvider);
  final allUsersAsync = ref.watch(allUsersProvider);

  return currentUserAsync.maybeWhen(
    data: (currentUser) {
      if (currentUser == null) return [];
      return allUsersAsync.maybeWhen(
        data: (allUsers) {
          switch (currentUser.role.toUpperCase()) {
            case 'ADMIN':
              return allUsers.where((u) => u.id != currentUser.id).toList();
            case 'MANAGER':
              return getReports(currentUser.id, allUsers);
            case 'TEAM_LEAD':
              return getReports(currentUser.id, allUsers);
            default:
              return []; // Employees can't see team
          }
        },
        orElse: () => [],
      );
    },
    orElse: () => [],
  );
});

// UserRole enum is now in src/core/constants/enums.dart
