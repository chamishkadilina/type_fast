// lib/services/url_launcher_service.dart
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future<void> launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }
}
