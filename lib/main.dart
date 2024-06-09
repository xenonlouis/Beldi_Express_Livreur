import 'package:client_app/Pages/Sign_in.dart';
import 'package:client_app/services/ClientAuth.dart';
import 'package:client_app/services/ClientService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Models/cart_model.dart';
import 'NavRoot.dart';
import 'Pages/ChangeEmail.dart';
import 'Pages/Changepassword.dart';
import 'Pages/ForgotPassword.dart';
import 'Pages/ModifyProfile.dart';
import 'Pages/Register.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CartModel()),
          ChangeNotifierProvider(create: (context) => ClientService()),
          ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Firebase Auth',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SignInScreen(),
          routes: {
            '/home': (context) => NavRoot(),
            '/sign-in': (context) => SignInScreen(),
            '/register': (context) => RegisterPage(),
            '/modify-profile': (context) => ModifyProfilePage(),
            '/change-password': (context) => ChangePasswordPage(),
            '/change-email': (context) => ChangeEmailPage(),
            '/forgot-password': (context) => ForgotPasswordPage(),
            // other routes...
          },
        ));
  }
}
