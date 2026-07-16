import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/activities/ui/activities_list_page.dart';
import '../modules/activities/ui/activity_registration_page.dart';
import '../modules/inspections/inspections_routes.dart';
import '../modules/inspections/ui/inspections_screen.dart';
import '../modules/home/home_screen.dart';

abstract final class AppRoutes {
  static const String activities = '/activities';
  static const String activityRegister = '/activities/register';
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (BuildContext context, GoRouterState state) => const HomeScreen()),
    GoRoute(
      path: InspectionsRoutes.list,
      builder: (BuildContext context, GoRouterState state) => const InspectionsScreen(),
    ),

    GoRoute(
      path: AppRoutes.activities,
      builder: (BuildContext context, GoRouterState state) => const ActivitiesListPage(),
    ),
    GoRoute(
      path: AppRoutes.activityRegister,
      builder: (BuildContext context, GoRouterState state) => const ActivityRegistrationPage(),
    ),
  ],
);
