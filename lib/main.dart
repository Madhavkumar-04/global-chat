import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/screens/details.dart';
import 'package:group_chat/screens/home.dart';
import 'package:group_chat/utils.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/chat_page.dart';
import 'screens/login_screen.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCkvPiRVyb6uiw8_b0sBSU3bI0oeQNCYcQ",
          authDomain: "global-group-chat.firebaseapp.com",
          projectId: "global-group-chat",
          storageBucket: "global-group-chat.appspot.com",
          messagingSenderId: "265253015743",
          appId: "1:265253015743:web:bb4d6474a5caaa80def60a"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Global Chat',
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthChecker(),         // Default route
          "/details":(context)=>const Details(),
          '/login': (context) => const LoginScreen(),     // Login Screen
          '/chat': (context) => const ChatPage(),// Additional screen for user profile, as an example
        },

      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          // If authenticated, return Details() or ChatPage based on first-time login status
          return authProvider.isFirstTimeLogin ? const ChatPage(): const Details();
        } else {
          // If not authenticated, return the home or login screen
          return const Home(); // Replace with your login page
        }
      },
    );
  }
}

