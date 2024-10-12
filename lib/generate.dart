import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  _GeneratePageState createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  final TextEditingController _textController = TextEditingController();
  String _qrData = '';

  void _generateQR() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _qrData = _textController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter data to generate QR',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateQR,
              child: const Text('Generate'),
            ),
            const SizedBox(height: 20),
            if (_qrData.isNotEmpty)
              QrImageView(
                data: _qrData,
                version: QrVersions.auto,
                size: 200.0,
              )
            else
              const SizedBox(
                height: 200.0,
                width: 200.0,
                child: Center(
                  child: Text('QR will appear here'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
