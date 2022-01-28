import 'package:bms_project/screen/home_screen.dart';
import 'package:bms_project/screen/login_screen.dart';
import 'package:bms_project/widgets/location_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Users(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'blood management system',
        theme: ThemeData(
          primaryColor: Colors.red.shade300,
        ),
        home: const LoginScreen(),
        routes: {
          HomePage.route: (ctx) => HomePage(),
          // CartScreen.routeName: (ctx) => CartScreen(),
          // OrdersScreen.routeName: (ctx) => OrdersScreen(),
          // UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          // EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
