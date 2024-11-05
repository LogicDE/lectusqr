import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String? barcode;
  bool _isDialogOpen = false; // Evitar diálogos múltiples

  Future<void> _launchURL(String url) async {
    // Asegúrate de que la URL sea válida
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Si no se puede abrir, muestra un mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir la URL: $url')),
        );
      }
    } catch (e) {
      // Manejo de excepciones para errores de apertura de URL
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al intentar abrir la URL: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Escáner de QR',
          style: GoogleFonts.lato(),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          // Cuadrado de escaneo en el centro
          Center(
            child: Container(
              width: 250, // Ancho del cuadrado
              height: 250, // Alto del cuadrado
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.teal,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
              ),
              child: ClipRect(
                child: MobileScanner(
                  onDetect: (BarcodeCapture barcodeCapture) {
                    if (!_isDialogOpen) {
                      // Solo permitir un diálogo a la vez
                      final String? code = barcodeCapture.barcodes.isNotEmpty
                          ? barcodeCapture.barcodes.first.rawValue
                          : null;
                      setState(() {
                        barcode = code;
                      });

                      // Mostrar un cuadro de diálogo con el código QR detectado
                      _isDialogOpen = true; // Evitar abrir más diálogos

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Código QR detectado'),
                          content: Text(barcode ?? 'El código no es válido'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _isDialogOpen =
                                    false; // Permitir abrir un nuevo diálogo
                              },
                              child: const Text('Cerrar'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (barcode != null) {
                                  Navigator.of(context)
                                      .pop(); // Cierra el diálogo
                                  _launchURL(
                                      barcode!); // Llama a la función para abrir la URL
                                  _isDialogOpen =
                                      false; // Permitir abrir un nuevo diálogo
                                }
                              },
                              child: const Text('Abrir URL'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          // Mostrar el código escaneado si está disponible
          if (barcode != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Código escaneado:',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    barcode!,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para usar el código QR (ej. abrir un enlace)
                      if (barcode != null) {
                        _launchURL(
                            barcode!); // Llama a la función para abrir la URL
                      }
                    },
                    child: const Text('Acceder al Código QR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
