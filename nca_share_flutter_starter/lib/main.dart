
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NCA Share',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2218),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 18),
            Text('NCA Share', style: TextStyle(color: Colors.white70, fontSize: 22)),
            SizedBox(height: 8),
            Text('Peer-to-peer File Transfer', style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PlatformFile> selectedFiles = [];
  List<TransferItem> transfers = [];

  Future<void> pickFiles() async {
    if (!(await _requestStoragePermission())) {
      Fluttertoast.showToast(msg: "Storage permission required");
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        selectedFiles = result.files;
      });
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS handled by file_picker prompt
  }

  void startSend() {
    if (selectedFiles.isEmpty) {
      Fluttertoast.showToast(msg: "No files selected");
      return;
    }
    // For each file create a TransferItem and simulate progress
    for (var f in selectedFiles) {
      TransferItem item = TransferItem(name: f.name, size: f.size, progress: 0);
      setState(() => transfers.insert(0, item));
      _simulateTransfer(item);
      // TODO: Replace _simulateTransfer with real P2P send logic using WebRTC / wifi-direct
      // e.g. createDataChannel.send(fileBytesChunk)
    }
    setState(() => selectedFiles = []);
  }

  void startReceive() {
    // TODO: Start listening/advertising for incoming P2P connections.
    // - For WebRTC: create offer/answer exchange through signaling or local QR.
    // - For WiFi Direct: use platform channel or plugin to accept connections.
    Fluttertoast.showToast(msg: "Receive mode started (placeholder)");
  }

  // Simulate file transfer progress (placeholder)
  void _simulateTransfer(TransferItem item) {
    Timer.periodic(Duration(milliseconds: 300), (t) {
      setState(() {
        item.progress += 0.12;
        if (item.progress >= 1.0) {
          item.progress = 1.0;
          item.completed = true;
          item.timestamp = DateTime.now();
          t.cancel();
        }
      });
    });
  }

  Widget _buildSelectedFilesView() {
    if (selectedFiles.isEmpty) return Text('No files selected');
    return Column(
      children: selectedFiles.map((f) => ListTile(
        leading: Icon(Icons.insert_drive_file),
        title: Text(f.name),
        subtitle: Text('${(f.size/1024).toStringAsFixed(2)} KB'),
      )).toList(),
    );
  }

  Widget _buildTransfers() {
    if (transfers.isEmpty) return Text('No transfers yet');
    return Column(
      children: transfers.map((t) => Card(
        margin: EdgeInsets.symmetric(vertical:6),
        child: ListTile(
          leading: Icon(t.completed ? Icons.check_circle : Icons.cloud_upload),
          title: Text(t.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(value: t.progress),
              SizedBox(height:4),
              Text(t.completed ? 'Completed' : '${(t.progress*100).toStringAsFixed(0)}%'),
            ],
          ),
          trailing: Text(t.timestamp==null ? '' : _fmt(t.timestamp!)),
        ),
      )).toList(),
    );
  }

  String _fmt(DateTime t) {
    return '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NCA Share'),
        centerTitle: true,
        backgroundColor: Color(0xFF3b2e22),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: [
            // Header with small logo
            Row(
              children: [
                Image.asset('assets/images/logo.png', width: 56, height:56),
                SizedBox(width:12),
                Expanded(child: Text('Peer-to-peer file sharing — Documents & Media', style: TextStyle(fontSize: 16)))
              ],
            ),
            SizedBox(height:16),
            // File selector
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Align(alignment: Alignment.centerLeft, child: Text('Selected Files', style: TextStyle(fontWeight: FontWeight.bold))),
                    SizedBox(height:8),
                    _buildSelectedFilesView(),
                    SizedBox(height:8),
                    Row(
                      children: [
                        ElevatedButton.icon(onPressed: pickFiles, icon: Icon(Icons.attach_file), label: Text('Pick files')),
                        SizedBox(width:10),
                        ElevatedButton.icon(onPressed: startSend, icon: Icon(Icons.send), label: Text('Send'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
                        SizedBox(width:10),
                        OutlinedButton.icon(onPressed: startReceive, icon: Icon(Icons.wifi), label: Text('Receive')),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height:12),
            Text('Transfers', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height:8),
            _buildTransfers(),
            SizedBox(height:30),
            Text('Notes: P2P capabilities are not yet implemented. Use the TODO points to plug in WebRTC or native Wi-Fi Direct logic.', style: TextStyle(color: Colors.grey)),
            SizedBox(height:20),
          ],
        ),
      ),
    );
  }
}

class TransferItem {
  String name;
  int size;
  double progress;
  bool completed;
  DateTime? timestamp;
  TransferItem({required this.name, required this.size, this.progress = 0.0, this.completed = false, this.timestamp});
}
