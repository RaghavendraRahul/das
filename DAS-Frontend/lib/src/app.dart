import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/theme/theme_provider.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/features/notifications/widgets/notification_listener_wrapper.dart';

class ProjectPmApp extends ConsumerStatefulWidget {
  const ProjectPmApp({super.key});

  @override
  ConsumerState<ProjectPmApp> createState() => _ProjectPmAppState();
}

class _ProjectPmAppState extends ConsumerState<ProjectPmApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(ref);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(resolvedThemeModeProvider);

    return MaterialApp.router(
      title: 'DAS',
      theme: lightTheme,
      // darkTheme: darkTheme, // Disabled as per user request
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
      builder: (context, child) {
        return NotificationListenerWrapper(child: child);
      },
    );
  }
}
