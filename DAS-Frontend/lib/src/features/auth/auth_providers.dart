import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_pm/src/core/database/database_provider.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/auth/user_repository.dart';

part 'auth_providers.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final db = ref.watch(databaseProvider);
  return UserRepository(db);
}

@riverpod
Stream<List<User>> allUsersStream(AllUsersStreamRef ref) {
  final userRepo = ref.watch(userRepositoryProvider);

  // Web Fallback for Admin Panel
  if (identical(0, 0.0)) {
    // Simple way to check for web in riverpod if kIsWeb not imported
    return Stream.value([
      const User(
        id: 'u1',
        name: 'Alice Admin',
        avatarUrl:
            'https://ui-avatars.com/api/?name=Alice+Admin&background=0D8ABC&color=fff',
        email: 'alice@company.com',
        role: 'ADMIN',
        department: 'Management',
      ),
      const User(
        id: 'u2',
        name: 'Bob Manager',
        avatarUrl:
            'https://ui-avatars.com/api/?name=Bob+Manager&background=6D28D9&color=fff',
        email: 'bob@company.com',
        role: 'MANAGER',
        department: 'Engineering',
        reportingManagerId: 'u1',
      ),
      const User(
        id: 'u3',
        name: 'Charlie Lead',
        avatarUrl:
            'https://ui-avatars.com/api/?name=Charlie+Lead&background=F59E0B&color=fff',
        email: 'charlie@company.com',
        role: 'TEAM_LEAD',
        department: 'Design',
        reportingManagerId: 'u2',
      ),
    ]);
  }

  return userRepo.watchAllUsers();
}
