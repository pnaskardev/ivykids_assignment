import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ivykids_assignment/features/auth/screens/auth_screen.dart';
import 'package:ivykids_assignment/features/auth/services/auth_service.dart';
import 'package:ivykids_assignment/features/home/screens/home_screen.dart';
import 'package:ivykids_assignment/providers/user_provider.dart';
import 'package:ivykids_assignment/routes/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authService.getUserData(context: context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
                home: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
          } else {
            return MaterialApp(
                title: 'IvyKids',
                theme: ThemeData(
                  useMaterial3: true,
                  fontFamily: GoogleFonts.lexendDeca().fontFamily,
                  textTheme: TextTheme
                  (
                    titleLarge: GoogleFonts.lexendDeca
                    (
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                    titleMedium: GoogleFonts.lexendDeca
                    (
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    titleSmall: GoogleFonts.lexendDeca
                    (
                      fontSize: 10,
                      // fontWeight: FontWeight.bold,
                      letterSpacing: 2,
        
                    ),
                ),),
                onGenerateRoute: (settings) => generateRoute(settings),
                home: getHome(snapshot.data));
          }
        });
  }
}

Widget getHome(int authLevel) {
  switch (authLevel) {
    case 0:
      return const AutheScreen();
    // break;
    case 1:
      return const HomeScreen();
    // break;
    default:
      return const Center(child: Text('Something Went wrong : ((((('));
  }
}
