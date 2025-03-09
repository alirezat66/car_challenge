import 'package:car_challenge/core/di/service_locator.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:user_identification/user_identification.dart';
import 'package:vehicle_selection/vehicle_search.dart';

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
          child: BlocProvider(
            create: (context) => locator<UserIdentificationCubit>(),
            child: UserIdentificationPage(
              onUserIdentified: () {
                GoRouter.of(context).go('/vehicle_selection');
              },
              notificationService: NotificationServiceFactory.create(context),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/vehicle_selection',
        name: 'vehicleSelection',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => locator<SearchCubit>(),
            child: SearchPage(onAuctionLoaded: (auction) {
              GoRouter.of(context).go('/auction_details', extra: auction);
            }),
          ),
        ),
      ),
      GoRoute(
        path: '/auction_details',
        name: 'auctionDetails',
        pageBuilder: (context, state) {
          final Auction? auction = state.extra as Auction?;
          return MaterialPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (context) => locator<UserIdentificationCubit>(),
              child: AuctionDetailsPage(auction: auction!),
            ),
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
