import 'dart:convert';

import 'package:firebase_dart/firebase_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'config.dart';

class Devfest {
  Handler get handler {
    Router router = Router();

    router.get('/speaker', (request) async {
      var app = await initApp();

      final db = FirebaseDatabase(
        app: app,
        databaseURL: Configuration.firebaseConfig['databaseUrl'],
      );
      final ref = db.reference().child('speaker');

      var responseData;

      await ref.once().then((value) {
        responseData = value.value;
      });

      return Response.ok(json.encode(responseData), headers: {});
    });

    return router;
  }

  Future<FirebaseApp> initApp() async {
    late FirebaseApp app;

    try {
      app = Firebase.app();
    } catch (e) {
      app = await Firebase.initializeApp(
          options: FirebaseOptions.fromMap(Configuration.firebaseConfig));
    }

    return app;
  }
}
