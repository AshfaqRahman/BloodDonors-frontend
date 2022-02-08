import 'package:bms_project/providers/blood_post.dart';
import 'package:bms_project/screen/home_screen.dart';
import 'package:bms_project/screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/users.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // print(dotenv.env['API_URL']);
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
        ChangeNotifierProvider.value(
          value: BloodPost(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'blood management system',
        theme: _buildTheme(),
        home: const AuthScreen(),
        routes: {
          HomeScreen.route: (ctx) => HomeScreen(),
          AuthScreen.route: (context) => const AuthScreen(),
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    ThemeData base = ThemeData(
      primaryColor: primrayColor,
      primaryColorDark: primrayColorDark,
      primaryColorLight: primrayColorLight,
      fontFamily: GoogleFonts.openSans().fontFamily,
    );
    return base.copyWith(
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: Colors.white, //const Color(0xFFEA5B70),
      cardColor: const Color(0xFFEA5B70),
      errorColor: const Color(0xFFEA5B70),
      buttonTheme: const ButtonThemeData(
        colorScheme: _colorScheme,
        textTheme: ButtonTextTheme.normal,
      ),
      primaryIconTheme: _customIconTheme(base.iconTheme),
      textTheme: base.textTheme,
      primaryTextTheme: base.primaryTextTheme,
      iconTheme: _customIconTheme(base.iconTheme),
    );
  }

  IconThemeData _customIconTheme(IconThemeData original) {
    return original.copyWith(color: Color(0xFFEA5B70));
  }

  static const ColorScheme _colorScheme = ColorScheme(
    primary: primrayColor,
    onPrimary: Colors.white,
    secondary: primrayColorLight,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: primrayColor,
    background: Colors.white,
    onBackground: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static const Color primrayColor = Color(0xFFEA5B70);
  static const Color primrayColorDark = Color(0xFFb32645);
  static const Color primrayColorLight = Color(0xFFff8d9e);
}
