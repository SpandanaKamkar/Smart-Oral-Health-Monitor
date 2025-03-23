import 'package:flutter/material.dart';
import '../services/mongo_service.dart';
import '../pages/login_page.dart';
import '../main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService.connect();

  String? userEmail = await MongoService.getUserSession();
  Map<String, dynamic>? user;

  if (userEmail != null) {
    user = await MongoService.getUserData(userEmail);
  }

  runApp(MyAppWrapper(user: user));
}

class MyAppWrapper extends StatelessWidget {
  final Map<String, dynamic>? user;

  const MyAppWrapper({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user != null ? MyApp() : LoginPage(),
    );
  }
}
