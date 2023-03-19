import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_management_app/providers/auth.dart';
import 'package:provider/provider.dart';

import './screens/authentication_screen.dart';
import './widgets/bottom_navigation_bar.dart';
import './screens/loading_screen.dart';
import './screens/warehouse_product_add_screen.dart';
import './providers/product_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initializationFirebase =
        Firebase.initializeApp();

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initializationFirebase,
      builder: (context, appSnapShot) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: ProductProvider(),
            ),
            ChangeNotifierProvider.value(
              value: Auth(),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WAERHOUSEBOX',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.blue.shade700,
                secondary: Colors.blue.shade700,
              ),
              fontFamily: 'Roboto',
              textTheme: const TextTheme(
                headline6: TextStyle(
                  fontSize: 24.0,
                ),
                bodyText2: TextStyle(fontSize: 24),
              ),
            ),
            home: appSnapShot.connectionState != ConnectionState.done
                ? const LoadingScreen()
                : StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    initialData: FirebaseAuth.instance.currentUser,
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const LoadingScreen();
                      }
                      //render your application if aut
                      if (userSnapshot.hasData) {
                        return const NavigationBarScreen();
                      }
                      //user is no signed in
                      return const AuthScreen();
                    },
                  ),
            routes: {
              WarehouseProductAddScreen.routeName: (context) =>
                  const WarehouseProductAddScreen(),
            },
          ),
        );
      },
    );
  }
}
