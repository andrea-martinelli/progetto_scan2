import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_scan2/widget/HomePage.dart'; // Assicurati di importare la pagina corretta

void main() {
  // Wrappiamo l'app con ProviderScope per abilitare Riverpod
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Barcode Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Imposta la pagina dello scanner come schermata iniziale
    );
  }
}
