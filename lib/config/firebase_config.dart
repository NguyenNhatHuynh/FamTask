import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';


  class DefaultFirebaseOptions {
       static FirebaseOptions get currentPlatform {
         if (kIsWeb) {
           return const FirebaseOptions(
             apiKey: 'AIzaSyCmSAPZ2njXeC5T8RIMn4JevrzfeZobs3c', // Thay bằng apiKey từ Firebase
             appId: '1:229019082339:web:662c1819e518f888046256', // Thay bằng appId từ Firebase
             messagingSenderId: '229019082339', // Thay bằng messagingSenderId
             projectId: 'famtask-2d42e', // Thay bằng projectId từ Firebase
             authDomain: 'famtask-2d42e.firebaseapp.com', // Thay bằng authDomain
             storageBucket: 'famtask-2d42e.appspot.com', // Thay bằng storageBucket
             measurementId: "G-PBQ1CRFQ12"
           );
         }
         // Cấu hình cho các nền tảng khác (Android, iOS) nếu cần
         return const FirebaseOptions(
           apiKey: 'AIzaSyCmSAPZ2njXeC5T8RIMn4JevrzfeZobs3c',
           appId: '1:229019082339:web:662c1819e518f888046256',
           messagingSenderId: '229019082339',
           projectId: 'famtask-2d42e',
           storageBucket: 'famtask-2d42e.appspot.com',
         );
       }
     }

