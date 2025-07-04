import 'package:firebase_core/firebase_core.dart';
import 'package:famtask/config/firebase_config.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}