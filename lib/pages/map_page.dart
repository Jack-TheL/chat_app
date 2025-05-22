import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareLocationPage extends StatelessWidget {
  static String tag = 'map-page';
  const ShareLocationPage({Key? key}) : super(key: key);

  Future<void> _openGoogleMap() async {
    // ตำแหน่ง lat และ lng ของสถานที่ที่คุณต้องการแชร์
    const double lat = 14.036462698183556;
    const double lng = 100.72544090489826;
    
    // สร้าง URL สำหรับ Google Map โดยใช้ lat และ lng ของตำแหน่ง
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    // เปิดแอป Google Map บนอุปกรณ์ผู้ใช้
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Location'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _openGoogleMap,
          child: const Text('Open Google Map'),
        ),
      ),
    );
  }
}