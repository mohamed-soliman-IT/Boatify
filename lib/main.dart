import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Boatify/firebase_options.dart';
import 'package:flutter/services.dart';
import 'screens/favorite.dart';
import 'screens/login.dart';
import 'screens/splashScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/auth/auth_cubit.dart';
import 'repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepository()),
        ),
        // Add other BlocProviders here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Boatify',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        routes: {
          '/': (context) => SplashScreen(), // Route to the Getstart screen
          '/login': (context) => LoginPage(),
          '/favorite': (context) => FavoritePage(),
        },
      ),
    );
  }
}
