import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'utils/app_theme.dart';
import 'utils/size_utils.dart';
import 'utils/app_logger.dart';
import 'screens/splash_screen.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/splash_cubit.dart';
import 'cubit/products_cubit.dart';
import 'services/app_initializer.dart';

void main() async {
  // Initialize all app services at startup
  await AppInitializer.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => SplashCubit()..checkAuthenticationStatus()),
        BlocProvider(create: (context) => ProductsCubit()),
      ],
      child: MaterialApp(
        title: 'Bazaar Live',
        debugShowCheckedModeBanner: false,
        home: const AppWrapper(),
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Add observer to handle app lifecycle
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove observer only - don't dispose services here
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in foreground
        AppLogger.lifecycle('App resumed');
        break;
      case AppLifecycleState.paused:
        // App is in background
        AppLogger.lifecycle('App paused');
        break;
      case AppLifecycleState.detached:
        // App is being terminated - dispose services
        AppLogger.lifecycle('App detached - disposing services');
        AppInitializer.dispose();
        break;
      default:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize size utils with context
    SizeUtils.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: const SplashScreen(),
    );
  }
}
