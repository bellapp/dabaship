import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/login_screen.dart';
import 'features/menu/menu_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(const ProviderScope(child: MyApp()));
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Firebase Init Failed: $e"),
        ),
      ),
    ));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, we might watch a locale provider here.
    // For now, we'll just use the system locale or default.
    // To make it dynamic, we would need a LocaleProvider.
    // Let's assume we want to support dynamic locale later.
    
    return MaterialApp(
      title: 'Daba Delivery',
      theme: AppTheme.getTheme(const Locale('fr')), // Default to FR for theme generation
      // Note: If we want the theme to update with locale, we need to rebuild this widget when locale changes.
      // For now, let's just pass a default or current locale if we had access.
      // Since we are using flutter_localizations, the actual locale is handled by the widgets.
      // But our getTheme depends on it for Font selection.
      // A simple fix is to use a builder or just rely on the fact that we might not switch fonts dynamically instantly without a rebuild.
      
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/menu': (context) => const MenuScreen(),
      },
      builder: (context, child) {
        // This is a trick to update the theme when the locale changes if we were using a provider.
        // But since we are not yet, let's just keep it simple.
        // Actually, to support the Font switch (Rubik vs Poppins), we should ideally rebuild the Theme.
        // Let's stick to a static theme for now or use a Provider if requested.
        // Given the spec, let's use the context's locale if possible, but context inside MaterialApp builder is needed.
        return Theme(
          data: AppTheme.getTheme(Localizations.localeOf(context)),
          child: child!,
        );
      },
    );
  }
}

