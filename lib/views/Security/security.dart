import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/views/Security/component/security_widget.dart';
import 'package:onyxswap/views/Security/component/setup_pin.dart';
import 'package:onyxswap/views/Security/component/update_password.dart';
import 'package:onyxswap/views/Security/view_model/checkpin.dart';
import 'package:onyxswap/widgets/loaderpage.dart';
import '../../core/routes/routing_constants.dart';
import '../../utils/text.dart';

final _checkpin =
    ChangeNotifierProvider.autoDispose((ref) => CheckPinViewmodel());

class Security extends ConsumerWidget {
  const Security({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(_checkpin);
    NavigationService _navigationService = NavigationService.I;
    return Scaffold(
      body: SafeArea(
        child: LoaderPage(
          loading: model.isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    'Security',
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
                  'Manage your password, Pin and general account security',
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
                          onTap:()=> model.onSecurityWidgetTapped(index)
                            //index == 1
                            // ? Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => PinSetup(
                            //             heading: 'Setup Pin',
                            //             title: 'Pin',
                            //             subtitle: 'Confirm pin')))
                            // : index == 0
                            //     ? Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) =>
                            //                 UpdatePassword()))
                            //     : index == 2 || model.title[1] != 'Pin'
                            //         ? NavigatorRoutes.twoFactorAuthenticaton
                            //         : () {}
                          ))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
