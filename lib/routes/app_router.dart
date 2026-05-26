import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/supabase/auth_service.dart';

/// AUTH PAGES
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';

/// PROFILE
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/profile/presentation/pages/change_password_page.dart';

/// ROLE DASHBOARDS
import '../features/role_dashboards/principal/principal_dashboard_page.dart';
import '../features/role_dashboards/founder/founder_dashboard_page.dart';
import '../features/role_dashboards/event_manager/dashboard/pages/event_manager_dashboard_page.dart';
import '../features/role_dashboards/headcrew/dashboard/pages/headcrew_dashboard_page.dart';
import '../features/role_dashboards/crew/crew_dashboard_page.dart';
import '../features/role_dashboards/coach/coach_dashboard_page.dart';

/// EVENTS
import '../features/role_dashboards/event_manager/events/pages/create_event_page.dart';

/// VENUES
import '../features/role_dashboards/event_manager/venues/pages/setup_venue_page.dart';
import '../features/venues/presentation/pages/pick_venue_location_page.dart';

/// ASSIGN HEADCREW
import '../features/role_dashboards/event_manager/manpower/pages/assign_headcrew_page.dart';

// SETUP MANPOWER
import '../features/role_dashboards/event_manager/manpower/pages/setup_manpower_page.dart';

import '../features/role_dashboards/event_manager/manpower/pages/review_manpower_page.dart';

/// MANAGEMENT ACTIONS
import '../features/role_dashboards/event_manager/workforce/pages/create_employee_page.dart';
import '../features/workforce_identity/presentation/pages/register_form_page.dart';

/// WORKFORCE
import '../features/role_dashboards/headcrew/workforce/pages/manpower_filling_page.dart';
import '../features/role_dashboards/headcrew/workforce/pages/workforce_assignment_page.dart';
import '../features/workforce_identity/presentation/pages/headcrew_workforce_register_page.dart';
import '../../features/role_dashboards/headcrew/workforce/pages/workforce_review_page.dart';
import '../features/role_dashboards/event_manager/events/pages/events_page.dart';

final AuthService authService = AuthService();

final appRouter = GoRouter(
  initialLocation: '/login',

  redirect: (context, state) async {
    final bool isLoggedIn = authService.currentUser != null;

    final bool isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    /// =========================
    /// NOT LOGGED IN
    /// =========================
    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    /// =========================
    /// LOGGED IN
    /// =========================
    if (isLoggedIn) {
      final profile = await authService.getCurrentProfile();

      final String role = (profile['role'] ?? '').toString().trim();

      final String employmentStatus =
          (profile['employment_status'] ?? 'pending').toString().trim();

      /// CORE ROLES
      final bool bypassOnboarding =
          role == 'founder' || role == 'principal' || role == 'event_manager';

      /// =========================
      /// ONBOARDING CHECK
      /// =========================
      if (!bypassOnboarding &&
          employmentStatus != 'active' &&
          state.matchedLocation != '/complete-profile') {
        return '/complete-profile';
      }

      /// =========================
      /// BLOCK AUTH PAGE
      /// =========================
      if (isAuthRoute) {
        switch (role) {
          case 'founder':
            return '/founder';

          case 'principal':
            return '/principal';

          case 'event_manager':
            return '/event-manager';

          case 'headcrew':
            return '/headcrew';

          case 'coach':
            return '/coach';

          case 'crew':
            return '/crew';

          default:
            return '/unauthorized';
        }
      }

      /// =========================
      /// ROLE ACCESS CONTROL
      /// =========================

      /// FOUNDER
      if (state.matchedLocation.startsWith('/founder') && role != 'founder') {
        return '/unauthorized';
      }

      /// PRINCIPAL
      if (state.matchedLocation.startsWith('/principal') &&
          role != 'principal') {
        return '/unauthorized';
      }

      /// EVENT MANAGER
      if (state.matchedLocation.startsWith('/event-manager') &&
          role != 'event_manager') {
        return '/unauthorized';
      }

      /// HEADCREW
      if (state.matchedLocation.startsWith('/headcrew') && role != 'headcrew') {
        return '/unauthorized';
      }

      /// COACH
      if (state.matchedLocation.startsWith('/coach') && role != 'coach') {
        return '/unauthorized';
      }

      /// CREW
      if (state.matchedLocation.startsWith('/crew') && role != 'crew') {
        return '/unauthorized';
      }
    }

    return null;
  },

  routes: [
    /// =========================
    /// AUTH
    /// =========================

    /// LOGIN
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    /// REGISTER
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    /// =========================
    /// PROFILE
    /// =========================

    /// COMPLETE PROFILE
    GoRoute(
      path: '/complete-profile',
      builder: (context, state) => const EditProfilePage(),
    ),

    /// CHANGE PASSWORD
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordPage(),
    ),

    /// =========================
    /// UNAUTHORIZED
    /// =========================
    GoRoute(
      path: '/unauthorized',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Unauthorized Access'))),
    ),

    /// =========================
    /// FOUNDER
    /// =========================
    GoRoute(
      path: '/founder',
      builder: (context, state) => const FounderDashboardPage(),
    ),

    /// =========================
    /// PRINCIPAL
    /// =========================
    GoRoute(
      path: '/principal',
      builder: (context, state) => const PrincipalDashboardPage(),
    ),

    /// =========================
    /// EVENT MANAGER
    /// =========================

    /// DASHBOARD
    GoRoute(
      path: '/event-manager/events',
      builder: (context, state) => const EventsPage(),
    ),
    GoRoute(
      path: '/event-manager',
      builder: (context, state) => const EventManagerDashboardPage(),
    ),

    /// CREATE EMPLOYEE
    GoRoute(
      path: '/event-manager/create-employee',
      builder: (context, state) => const CreateEmployeePage(),
    ),

    /// CREATE EVENT
    GoRoute(
      path: '/event-manager/create-event',
      builder: (context, state) => const CreateEventPage(),
    ),

    /// SETUP VENUE
    GoRoute(
      path: '/event-manager/setup-venue',

      builder: (context, state) {
        final eventDraft = state.extra as Map<String, dynamic>;

        return SetupVenuePage(eventDraft: eventDraft);
      },
    ),

    GoRoute(
      path: '/event-manager/review-manpower',

      builder: (context, state) {
        final eventId = state.extra as String;

        return ReviewManpowerPage(eventId: eventId);
      },
    ),

    GoRoute(
      path: '/register-form',

      builder: (context, state) {
        final nationalId = state.extra as String;

        return RegisterFormPage(nationalId: nationalId);
      },
    ),

    /// PICK VENUE LOCATION
    GoRoute(
      path: '/pick-venue-location',
      builder: (context, state) => const PickVenueLocationPage(),
    ),

    /// ASSIGN HEADCREW
    GoRoute(
      path: '/event-manager/assign-headcrew',

      builder: (context, state) {
        final eventDraft = state.extra as Map<String, dynamic>;

        return AssignHeadcrewPage(eventDraft: eventDraft);
      },
    ),
    GoRoute(
      path: '/event-manager/setup-manpower',
      builder: (context, state) {
        final eventId = state.extra as String;

        return SetupManpowerPage(eventId: eventId);
      },
    ),

    /// WORKFORCE REVIEW
    GoRoute(
      path: '/headcrew/workforce-review',

      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return WorkforceReviewPage(
          eventId: extra['eventId'],
          role: extra['role'],
        );
      },
    ),

    /// =========================
    /// HEADCREW
    /// =========================
    GoRoute(
      path: '/headcrew',
      builder: (context, state) => const HeadcrewDashboardPage(),
    ),

    /// MANPOWER FILLING
    GoRoute(
      path: '/headcrew/manpower-filling',

      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return ManpowerFillingPage(
          eventId: data['eventId'],
          eventName: data['eventName'],
          venueName: data['venueName'],
        );
      },
    ),

    /// WORKFORCE ASSIGNMENT
    GoRoute(
      path: '/headcrew/workforce-assignment',

      builder: (context, state) {
        final extra = (state.extra as Map<String, dynamic>?) ?? {};

        final String eventId = extra['eventId']?.toString() ?? '';

        final String role = extra['role']?.toString() ?? '';

        return WorkforceAssignmentPage(eventId: eventId, role: role);
      },
    ),

    /// HEADCREW REGISTER WORKFORCE
    GoRoute(
      path: '/headcrew/register-workforce',

      builder: (context, state) {
        final extra = (state.extra as Map<String, dynamic>?) ?? {};

        return HeadcrewWorkforceRegisterPage(
          nationalId: extra['nationalId']?.toString() ?? '',

          role: extra['role']?.toString() ?? 'crew',
        );
      },
    ),
    GoRoute(
      path: '/headcrew/workforce-review',

      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return WorkforceReviewPage(
          eventId: extra['eventId'],

          role: extra['role'],
        );
      },
    ),

    /// =========================
    /// CREW
    /// =========================
    GoRoute(
      path: '/crew',
      builder: (context, state) => const CrewDashboardPage(),
    ),

    /// =========================
    /// COACH
    /// =========================
    GoRoute(
      path: '/coach',
      builder: (context, state) => const CoachDashboardPage(),
    ),
  ],
);
