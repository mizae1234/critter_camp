import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/storage/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await LocalStorage.getInstance();
  runApp(CritterCampApp(storage: storage));
}
