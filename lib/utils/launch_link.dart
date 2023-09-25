import 'package:url_launcher/url_launcher.dart';

class LaunchLink {
  static launchPhone(String telephoneNumber) async {
    String telephoneUrl = "tel:$telephoneNumber";
    if (await canLaunchUrl(Uri.parse(telephoneUrl))) {
      await launchUrl(Uri.parse(telephoneUrl));
    } else {
      throw "Error occured trying to call that number.";
    }
  }

  static launchURL(Uri link) async {
    if (await canLaunchUrl(link)) {
      await launchUrl(link);
    } else {
      throw "Error occured trying to call that number.";
    }
  }

}