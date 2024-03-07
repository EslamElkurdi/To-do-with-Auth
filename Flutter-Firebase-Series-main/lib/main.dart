import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Import Firebase Auth
import 'package:flutter_firebase/features/app/splash_screen/splash_screen.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/home_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Layout/todo_app_layout.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Shared/bloc_observer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyAL12HWds58XhVj35r7kftbNBO4jwDoiJ8',
      appId: '1:830403420764:web:11c4a77385925f25707c99',
      messagingSenderId: '830403420764',
      projectId: 'to-do-app-55d7a',
      authDomain: 'to-do-app-55d7a.firebaseapp.com',
      storageBucket: 'to-do-app-55d7a.appspot.com',
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/todolayout': (context) => ToDoApp(),
      },
    );
  }
}
