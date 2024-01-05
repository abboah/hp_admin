import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hp_admin/controllers/menu_controller.dart' as menu_controller;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hp_admin/constants/style.dart';
import 'package:hp_admin/controllers/navigation_controller.dart';
import 'package:hp_admin/layout.dart';
import 'package:hp_admin/pages/404/error.dart';
import 'package:hp_admin/pages/authentication/authentication.dart';
import 'package:hp_admin/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA-MyQY5S1isF4IzxcuYbFJSUeyqZ1m68g",
        appId: "1:873008769804:web:874fcc47587ac2e9ba3729",
        messagingSenderId: "873008769804",
        projectId: "hope-pursuit",
      ),
    );

    print('Firebase initialized successfully');

    Get.put(menu_controller.MenuController());
    Get.put(NavigationController());
    Get.put(ProductProvider());

    runApp(
      const MyApp(),
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider())
      ],
      child: GetMaterialApp(
        initialRoute: rootRoute,
        unknownRoute: GetPage(
            name: '/not-found',
            page: () => const PageNotFound(),
            transition: Transition.fadeIn),
        getPages: [
          GetPage(
              name: rootRoute,
              page: () {
                return SiteLayout();
              }),
          GetPage(
              name: authenticationPageRoute,
              page: () => const AuthenticationPage()),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Dashboard',
        theme: ThemeData(
          scaffoldBackgroundColor: light,
          textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          }),
          primarySwatch: Colors.blue,
        ),
        // home: AuthenticationPage(),
      ),
    );
  }
}
