import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart'; // Importamos qr_code_tools
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrCodeLink = "Aquí aparecerá el link del QR generado";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Método para escanear desde la cámara (solo QR)
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeLink = scanData.code!;
      });
    });
  }

  // Método para seleccionar y escanear imagen desde el archivo (solo QR)
  Future<void> _scanQRCodeFromFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        // Usamos qr_code_tools para escanear el código QR desde la imagen seleccionada
        String result = await QrCodeToolsPlugin.decodeFromPath(
            pickedFile.path); // Cambiamos decodeFrom a decodeFromPath
        setState(() {
          qrCodeLink = result.isEmpty ? "No es un código QR válido" : result;
        });
      } catch (e) {
        setState(() {
          qrCodeLink = "Error al escanear QR desde imagen: $e";
        });
      }
    }
  }

  // Método para abrir el link con url_launcher
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear QR'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(qrCodeLink),
                ElevatedButton(
                  onPressed: qrCodeLink.contains('http')
                      ? () => _launchURL(qrCodeLink)
                      : null,
                  child: Text("Abrir Link"),
                ),
                ElevatedButton(
                  onPressed: _scanQRCodeFromFile,
                  child: Text("Escanear QR desde archivo"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
