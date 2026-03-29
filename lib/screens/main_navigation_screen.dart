import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navigation_cubit.dart';
import '../cubit/navigation_state.dart';
import '../utils/app_logger.dart';
import '../widgets/custom_nav_bar.dart';
import 'dashboard_screen.dart';
import 'orders_screen.dart';
import 'account_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => NavigationCubit(), child: const MainNavigationView());
  }
}

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  // List of screens corresponding to each tab
  static const List<Widget> _screens = [DashboardScreen(), OrdersScreen(), AccountScreen()];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        int selectedIndex = 0;
        if (state is NavigationChanged) {
          selectedIndex = state.selectedIndex;
        }

        return PopScope(
          canPop: selectedIndex == 0, // Only allow pop when on Dashboard
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && selectedIndex != 0) {
              // If not on Dashboard, navigate to Dashboard first
              AppLogger.navigation('Back pressed - navigating to Dashboard from tab $selectedIndex');
              context.read<NavigationCubit>().goToDashboard();
            } else if (didPop) {
              // If on Dashboard and popping, exit app
              AppLogger.navigation('Back pressed - exiting app from Dashboard');
            }
          },
          child: Scaffold(
            body: IndexedStack(index: selectedIndex, children: _screens),
            bottomNavigationBar: const CustomNavBar(),
          ),
        );
      },
    );
  }
}
