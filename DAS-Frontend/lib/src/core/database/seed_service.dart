import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/database/database_provider.dart';
import 'package:drift/drift.dart' as drift;

final seedServiceProvider = Provider<SeedService>((ref) {
  return SeedService(ref.read(databaseProvider));
});

class SeedService {
  final AppDatabase _db;

  SeedService(this._db);

  Future<void> seedData() async {
    try {
      // Seed Users if they don't exist
      final existingUsers = await _db.select(_db.users).get();
      final existingIds = existingUsers.map((u) => u.id).toSet();

      await _db.batch((batch) {
        if (!existingIds.contains('u1')) {
          batch.insert(
              _db.users,
              UsersCompanion.insert(
                  id: 'u1',
                  name: 'Alice Admin',
                  avatarUrl: '',
                  email: 'alice@company.com',
                  role: 'ADMIN',
                  department: const drift.Value('Management')));
        }
        if (!existingIds.contains('u2')) {
          batch.insert(
              _db.users,
              UsersCompanion.insert(
                  id: 'u2',
                  name: 'Bob Manager',
                  avatarUrl: '',
                  email: 'bob@company.com',
                  role: 'MANAGER',
                  reportingManagerId: const drift.Value('u1'),
                  department: const drift.Value('Engineering')));
        }
        if (!existingIds.contains('u3')) {
          batch.insert(
              _db.users,
              UsersCompanion.insert(
                  id: 'u3',
                  name: 'Charlie Lead',
                  avatarUrl: '',
                  email: 'charlie@company.com',
                  role: 'TEAM_LEAD',
                  reportingManagerId: const drift.Value('u2'),
                  department: const drift.Value('Frontend')));
        }
        if (!existingIds.contains('u4')) {
          batch.insert(
              _db.users,
              UsersCompanion.insert(
                  id: 'u4',
                  name: 'Diana Dev',
                  avatarUrl: '',
                  email: 'diana@company.com',
                  role: 'EMPLOYEE',
                  reportingManagerId: const drift.Value('u3'),
                  department: const drift.Value('Frontend')));
        }
        // New Users as requested
        if (!existingIds.contains('u5')) {
          batch.insert(
              _db.users,
              UsersCompanion.insert(
                  id: 'u5',
                  name: 'Eve Lead',
                  avatarUrl: '',
                  email: 'eve@company.com',
                  role: 'TEAM_LEAD',
                  reportingManagerId: const drift.Value('u2'),
                  department: const drift.Value('Backend')));
        }
        if (!existingIds.contains('u6')) {
          batch.insert(
              _db.users,
              UsersCompanion.insert(
                  id: 'u6',
                  name: 'Frank Employee',
                  avatarUrl: '',
                  email: 'frank@company.com',
                  role: 'ADMIN',
                  reportingManagerId: const drift.Value('u5'),
                  department: const drift.Value('Backend')));
        }
      });

      // Seed Projects if they don't exist (basic check)
      final projectsCount = await _db
          .customSelect('SELECT COUNT(*) as c FROM projects')
          .map((row) => row.read<int>('c'))
          .getSingle();
      if (projectsCount == 0) {
        await _db.batch((batch) {
          batch.insertAll(_db.projects, [
            ProjectsCompanion.insert(
              id: 'p1',
              name: 'Instagram Clone Development',
              context: '# Software Requirements Specification...',
              status: 'active',
              approvalStatus: const drift.Value('approved'),
            ),
            ProjectsCompanion.insert(
              id: 'p2',
              name: 'E-commerce Platform',
              context: '# SRS E-commerce...',
              status: 'active',
              approvalStatus: const drift.Value('approved'),
            ),
          ]);
        });
      }

      // Seed Tasks if they don't exist
      final tasksCount = await _db
          .customSelect('SELECT COUNT(*) as c FROM tasks')
          .map((row) => row.read<int>('c'))
          .getSingle();
      if (tasksCount == 0) {
        await _db.batch((batch) {
          batch.insertAll(_db.tasks, [
            TasksCompanion.insert(
                id: 't1',
                name: 'User Authentication',
                projectId: 'p1',
                progress: const drift.Value(25),
                priority: 'High',
                startDate: DateTime(2024, 7, 20),
                endDate: DateTime(2024, 7, 30),
                assigneesJson: '["u4", "u5"]', // Assigned to Diana and Eve
                approvalStatus: const drift.Value('approved')),
            TasksCompanion.insert(
                id: 't2',
                name: 'Feed Page',
                projectId: 'p1',
                progress: const drift.Value(40),
                priority: 'High',
                startDate: DateTime(2024, 7, 28),
                endDate: DateTime(2024, 8, 10),
                assigneesJson:
                    '["u3", "u4", "u6"]', // Assigned to Charlie, Diana, Frank
                approvalStatus: const drift.Value('approved')),
          ]);
        });
      }

      // Force update assignments for existing tasks to ensure new users (u5, u6) are included
      // This accounts for dev environments where tasks were already seeded without these users.
      await _ensureTaskAssignment('t1', ['u4', 'u5']);
      await _ensureTaskAssignment('t2', ['u3', 'u4', 'u6']);
    } catch (e) {
      debugPrint('SeedService: Failed to seed data: $e');
    }
  }

  Future<void> _ensureTaskAssignment(
      String taskId, List<String> requiredUserIds) async {
    final task = await (_db.select(_db.tasks)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (task != null) {
      // Parse existing
      List<String> currentAssignees = [];
      try {
        final jsonStr = task.assigneesJson.replaceAll(
            "'", '"'); // simple fix for potentially malformed manual strings
        if (jsonStr.startsWith('[')) {
          // Quick parse manual
          currentAssignees = jsonStr
              .substring(1, jsonStr.length - 1)
              .split(',')
              .map((e) => e.trim().replaceAll('"', '').replaceAll("'", ''))
              .where((e) => e.isNotEmpty)
              .toList();
        }
      } catch (e) {
        // ignore
      }

      bool changed = false;
      for (var uid in requiredUserIds) {
        if (!currentAssignees.contains(uid)) {
          currentAssignees.add(uid);
          changed = true;
        }
      }

      if (changed) {
        // Simple manual JSON construction to avoid import issues
        final newJson = '[${currentAssignees.map((e) => '"$e"').join(', ')}]';
        await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
          TasksCompanion(assigneesJson: drift.Value(newJson)),
        );
      }
    }
  }
}
