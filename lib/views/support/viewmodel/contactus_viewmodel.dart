import 'package:flutter/material.dart';
import 'package:onyxswap/utils/launch_link.dart';
import 'package:onyxswap/widgets/app_dialoge.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsViewmodel extends BaseViewModel {
  List title = ['Via whatsapp', 'Via email'];
  List subtitle = ['08172247276', 'hello@onyxswap.africa'];
  launchEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

// ···
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'hello@onyxswap.africa',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );
    // if (Platform.isAndroid) {
    //   PathProviderAndroid.registerWith();
    // }

    await launchUrl(Uri.parse('mailto:hello@onyxswap.africa'));
  }
launchWhatsapp()async{
if (await canLaunchUrl(Uri.parse('https://wa.me/23408172247276?text=Getting%20started'))) {
await launchUrl(Uri.parse('https://wa.me/23408172247276?text=Getting%20started'),
mode: LaunchMode.externalApplication);
}
}
  onTap(int index, BuildContext context) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

// ···
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'hello@onyxswap.africa',
      query: encodeQueryParameters(<String, String>{
        // 'subject': 'Example Subjec',
      }),
    );
    AppDialog.showFancyDialog(
        title: '',
        description:
            'This link will take you out of the app, Are you sure you want to proceed.',
        onConfirm: ()async {
          Navigator.pop(context);
        index==0?launchWhatsapp():  LaunchLink.launchURL(
              
              //Uri.parse('https://wa.me/23408172247276?text=Getting%20started')
               emailLaunchUri);
        });
  }
}
