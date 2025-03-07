import 'package:car_challenge/core/di/service_locator.dart';
import 'package:car_challenge/core/notification/notification_factory.dart';
import 'package:car_challenge/core/usecase/usecase.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/get_user_identification.dart';
import 'package:car_challenge/features/user_identification/presentation/pages/user_identification_page.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/auction_details_page.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/vehicle_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: _initialRedirect,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: UserIdentificationPage(
            notificationService: NotificationServiceFactory.create(context),
          ),
        ),
      ),
      GoRoute(
        path: '/vehicle_selection',
        name: 'vehicleSelection',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const VehicleSelectionPage(),
        ),
      ),
      GoRoute(
        path: '/auction_details',
        name: 'auctionDetails',
        pageBuilder: (context, state) {
          final VehicleAuction? auction = state.extra as VehicleAuction?;
          return MaterialPage(
            key: state.pageKey,
            child: AuctionDetailsPage(auction: auction!),
          );
        },
      ),
    ],
  );

  // Initial redirect to check if a user is already identified
  static Future<String?> _initialRedirect(
      BuildContext context, GoRouterState state) async {
    // Check if user is already identified by calling the use case
    final getUserIdentification = locator<GetUserIdentification>();
    final result = await getUserIdentification(const NoParams());

    // If result is Right, it means we have a user identified
    return result.fold(
      (failure) =>
          null, // User not identified, stay at current route (user identification page)
      (user) {
        // User is identified, go to vehicle selection page if not already there
        if (state.matchedLocation == '/') {
          return '/vehicle_selection';
        }
        return null;
      },
    );
  }
}
