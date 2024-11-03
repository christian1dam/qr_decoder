import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_reader/models/scan_model.dart';

Future<void> launchURL(BuildContext context, ScanModel scan) async {
  final String valor = scan.valor;
  final Uri url = Uri.parse(valor);

  if (scan.tipo == 'http') {
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not launch $url';
  } else {
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}
