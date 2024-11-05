import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'qrlector.dart'; // Asegúrate de tener el import correcto

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LectusQR',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: Colors.teal,
          )),
      home: const QRScanner(),
    );
  }
}
