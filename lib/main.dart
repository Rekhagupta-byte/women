import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:women/core/secrets/app_secrets.dart';
import 'package:women/core/theme/theme.dart';
import 'package:women/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:women/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:women/features/auth/domain/usecases/user_login.dart';
import 'package:women/features/auth/domain/usecases/user_sign_up.dart';
import 'package:women/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:women/features/auth/presentation/pages/home_page.dart';
import 'package:women/features/auth/presentation/pages/login_page.dart';
import 'package:women/database/database_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await requestStoragePermission();
    await DatabaseHelper.instance.database;
    await _initializeDatabase();
    await exportDatabaseOnStartup();
  }

  // ✅ Initialize Supabase BEFORE creating BlocProviders
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseanonKey,
  );

  final supabase = Supabase.instance; // ✅ Ensure it's initialized safely

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            userSignUp: UserSignUp(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(
                    supabase.client), // ✅ Uses safely initialized instance
              ),
            ),
            userLogin: UserLogin(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(supabase.client),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// ✅ Ensures SQLite database is set up before running the app
Future<void> _initializeDatabase() async {
  final dbHelper = DatabaseHelper.instance;
  final user = await dbHelper.getUser();

  if (user == null) {
    await dbHelper.insertUser("Test User", "test@example.com");
    print("✅ Inserted Test User in SQLite.");
  } else {
    print("✅ Existing User: ${user['name']}");
  }
  await dbHelper.getAllUsers();
}

Future<void> requestStoragePermission() async {
  if (await Permission.manageExternalStorage.request().isGranted) {
    print("✅ Storage Permission Granted");
  } else if (await Permission.manageExternalStorage.isPermanentlyDenied) {
    print(
        "❌ Storage Permission Permanently Denied. Please enable it in settings.");
    await openAppSettings();
  } else {
    print("❌ Storage Permission Denied");
  }
}

Future<void> exportDatabaseOnStartup() async {
  await DatabaseHelper.instance.exportDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women Security Application',
      theme: AppTheme.darkThemeMode,
      home: Supabase.instance.client.auth.currentSession?.user != null
          ? HomePage()
          : const LoginPage(),
    );
  }
}
