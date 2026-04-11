import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProjectsPlaceholderPage extends StatelessWidget {
  const ProjectsPlaceholderPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
      body: Center(child: Text("Projects Component Coming Soon")));
}

// Classes removed as they are now implemented separately:
// ReportsPlaceholderPage, SettingsPlaceholderPage, KnowledgeBasePage,
// TeamOverviewPage, ApprovalsPage, AdminPanelPage

@RoutePage()
class ProjectDetailsPage extends StatelessWidget {
  final String projectId;
  const ProjectDetailsPage(
      {super.key, @PathParam('id') required this.projectId});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text("Project: $projectId")));
}
