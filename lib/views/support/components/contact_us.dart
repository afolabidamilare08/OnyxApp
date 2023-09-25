import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/support/viewmodel/contactus_viewmodel.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../../../widgets/loaderpage.dart';
import '../../Security/component/security_widget.dart';

final _contactus =
    ChangeNotifierProvider.autoDispose((ref) => ContactUsViewmodel());

class ContactUs extends ConsumerWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(_contactus);
    return Scaffold(
      body: SafeArea(
        child: LoaderPage(
          loading: model.isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  AppText.heading1L(
                    'Contact Us',
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
                  'Contact us via Whatsapp or send an Email',
                  multitext: true,
                  color: kSecondaryColor,
                  centered: true,
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Expanded(
                  child: ListView(
                children: [
                  ...List.generate(
                      model.title.length,
                      (index) => SecurityWidget(
                          title: model.title[index],
                          subtitle: model.subtitle[index],
                          onTap: ()=>model.onTap(index, context)
                    ))  ],
              ))
            ],
          ),
        ),
      ),
    );
    ;
  }
}
