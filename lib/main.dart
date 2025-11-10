import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/family_provider.dart';
import 'providers/chore_provider.dart';
import 'services/notification_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize notification service
  await NotificationService().initialize();
  await NotificationService().requestPermissions();

  runApp(const FamilyChoresApp());
}

class FamilyChoresApp extends StatelessWidget {
  const FamilyChoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => FamilyProvider()),
        ChangeNotifierProvider(create: (_) => ChoreProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Family Chores',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: _buildHome(authProvider),
          );
        },
      ),
    );
  }

  Widget _buildHome(AuthProvider authProvider) {
    // Show loading while checking auth state
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check if user is logged in and has completed setup
    if (authProvider.isLoggedIn && authProvider.hasCompletedSetup) {
      return HomeScreen(
        userType: authProvider.userModel!.role,
        familyId: authProvider.familyId!,
        userId: authProvider.firebaseUser!.uid,
      );
    }

    // Show login screen if not logged in
    return const LoginScreen();
  }
}
