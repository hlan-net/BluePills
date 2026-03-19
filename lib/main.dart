/// BluePills - Privacy-focused medication management application.
///
/// This is the main entry point for the BluePills application, which provides
/// medication tracking and reminder functionality with optional BlueSky sync.
library;

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/screens/medication_list_screen.dart';
import 'package:bluepills/l10n/app_localizations.dart';
import 'package:bluepills/l10n/app_localizations_delegate.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:bluepills/services/backup_service.dart';
import 'package:bluepills/notifications/notification_helper.dart';

/// The main entry point for the BluePills application.
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite FFI for desktop platforms only
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize services with error handling
  try {
    await ConfigService().init();
  } catch (e) {
    debugPrint('Error initializing ConfigService: $e');
  }

  try {
    await BackupService().checkAndRestore();
  } catch (e) {
    debugPrint('Error checking backup: $e');
  }

  try {
    await DatabaseHelper().init();
  } catch (e) {
    debugPrint('Error initializing DatabaseHelper: $e');
  }

  try {
    await NotificationHelper().init();
  } catch (e) {
    debugPrint('Error initializing NotificationHelper: $e');
  }

  runApp(const MyApp());
}

/// The root widget of the BluePills application.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ConfigService _configService = ConfigService();
  Locale? _locale;
  Timer? _configRefreshTimer;

  @override
  void initState() {
    super.initState();
    _updateLocale();
    // Re-read config periodically to handle language changes from settings
    _configRefreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _updateLocale();
    });
  }

  @override
  void dispose() {
    _configRefreshTimer?.cancel();
    super.dispose();
  }

  void _updateLocale() {
    final languageCode = _configService.config.languageCode;
    if (languageCode != null && languageCode.isNotEmpty) {
      if (_locale?.languageCode != languageCode) {
        setState(() {
          _locale = Locale(languageCode);
        });
      }
    } else {
      if (_locale != null) {
        setState(() {
          _locale = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BluePills',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: const MedicationListScreen(),
    );
  }
}
