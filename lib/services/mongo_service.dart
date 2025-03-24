import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class MongoService {
  static late Db db;
  static late DbCollection userCollection;
  static const String mongoUrl =
      "mongodb+srv://flutterUser:flutterUser@fluttercluster.tmrgi.mongodb.net/?retryWrites=true&w=majority&appName=FlutterCluster";
  static const String dbName = "flutter_db";
  static const String collectionName = "users";

  static Future<void> connect() async {
    db = await Db.create(mongoUrl);
    await db.open();
    userCollection = db.collection(collectionName);
    print("MongoDB Connected!");
  }

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Save session
  static Future<void> saveUserSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUser', email);
  }

  // Get session
  static Future<String?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUser');
  }

  // Logout
  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');
  }

  // Fetch user data safely
  static Future<Map<String, dynamic>?> getUserData(String email) async {
    if (db == null || !db.isConnected) {
      print("Database is not connected!");
      return null;
    }
    return await userCollection.findOne(where.eq('email', email));
  }

  static Future<Map<String, dynamic>?> getUserDetails() async {
    String? userEmail = await MongoService.getUserSession();
    if (userEmail == null) return null;

    var db = await Db.create(mongoUrl);
    await db.open();
    var collection = db.collection(collectionName);

    var user = await collection.findOne(where.eq('email', userEmail));
    await db.close();

    return user;
  }
}
