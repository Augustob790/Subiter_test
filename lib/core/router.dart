import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/companies/activities_routes.dart';
import '../modules/companies/ui/activities_list_page.dart';
import '../modules/companies/ui/activity_registration_page.dart';
import '../modules/inspections/inspections_routes.dart';
import '../modules/inspections/ui/inspections_screen.dart';
import '../modules/home/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (BuildContext context, GoRouterState state) => const HomeScreen()),
    GoRoute(
      path: InspectionsRoutes.list,
      builder: (BuildContext context, GoRouterState state) => const InspectionsScreen(),
    ),

    GoRoute(
      path: ActivitiesRoutes.list,
      builder: (BuildContext context, GoRouterState state) => const ActivitiesListPage(),
    ),
    GoRoute(
      path: ActivitiesRoutes.register,
      builder: (BuildContext context, GoRouterState state) => const ActivityRegistrationPage(),
    ),
  ],
);
