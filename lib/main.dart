import 'package:wpclonemn/features/landing/screens/landing_screen.dart';
import 'package:wpclonemn/screens/mobile_layout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/controller/auth_controller.dart';
import 'package:wpclonemn/common/widgets/error.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wpclonemn/colors.dart';
import 'package:wpclonemn/router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      onGenerateRoute: (settings) => generateRoute(settings),
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp clone',
      theme: ThemeData.dark().copyWith(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent.withOpacity(0),
        ),
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(
                text: err.toString(),
              );
            },
            loading: () => Scaffold(
              backgroundColor: backgroundColor,
              body: Center(
                child: Text('Loading...'),
              ),
            ),
          ),
    );
  }
}
