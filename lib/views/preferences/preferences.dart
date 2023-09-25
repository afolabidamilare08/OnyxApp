import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/preferences/component/preference_widget.dart';
import '../../utils/color.dart';
import '../../utils/text.dart';
// final _preferences =
//     ChangeNotifierProvider.autoDispose((ref) => PreferencesViewModel());
class PreferenceView extends ConsumerWidget {
  const PreferenceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
   // var model=ref.watch(_preferences);
    List<String> preferences = [
      // 'SMS Alerts',
      // 'Email Alerts',
      'Push Notification',
      // 'Show price in USD',
      // 'Privacy mode',
      // 'Language'
    ];
    return Scaffold(
      body: SafeArea(
          child: Column(children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: kSecondaryColor,
                )),
            SizedBox(width: MediaQuery.of(context).size.width / 2 - 100),
            AppText.heading1L(
              'Preferences',
              color: kSecondaryColor,
            ),
          ],
        ),
        const SizedBox(
          height: 42,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: AppText.heading7L(
            'Manage notification & Language',
            multitext: true,
            color: kSecondaryColor,
            centered: true,
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        Column(children: [
          ...List.generate(
              preferences.length,
              (index) => PreferenceWidget(
                    title: preferences[index],
                    lang: index == 5 ? true : false,
                  ))
        ])
      ])),
    );
  }
}
