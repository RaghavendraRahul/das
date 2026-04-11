import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for managing the sidebar collapse state globally.
final sidebarCollapsedProvider = StateProvider<bool>((ref) => true);
