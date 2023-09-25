import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/navigation_service.dart';
import '../../utils/color.dart';
import '../../utils/text.dart';
import 'components/account_detail_card.dart';
import 'components/arc.dart';
import 'viewmodel/account_viewmodel.dart';

final _accountViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => AccountViewmodel());

class AccountView extends ConsumerWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(_accountViewmodel);
    NavigationService _navigationService = NavigationService.I;
    return Scaffold(
      backgroundColor: const Color(0xff1e1f1e),
      body: ColorfulSafeArea(
        color: const Color(0xff373837),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 35),
                          height: 142,
                          width: double.infinity,
                          color: const Color(0xff373837),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Container(
                              //   clipBehavior: Clip.hardEdge,
                              //   width: 49,
                              //   height: 49,
                              //   decoration:
                              //       const BoxDecoration(shape: BoxShape.circle),
                              //   child: CachedNetworkImage(
                              //     fit: BoxFit.cover,
                              //     imageUrl:
                              //         "https://images.pexels.com/photos/2050994/pexels-photo-2050994.jpeg",
                              //   ),
                              // ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.heading1L(model.fullname ?? ''),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const SizedBox(
                                  //       width: 3,
                                  //     ),
                                  //     //AppText.body4L("veni@gmail.com"),
                                  //   ],
                                  // ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: kSecondaryColor,
                                  ))
                            ],
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          left: 0,
                          child: AccountArc(
                            diameter: 120,
                          ),
                        )
                      ],
                    ),
                  ),
                  ...List.generate(
                      3,
                      (index) => AccountDetailCard(
                            title: model.title[index],
                            subtitle: model.subtitle[index],
                            icon: model.icons[index],
                            onTap: () => _navigationService
                                .navigateTo(model.routes[index]),
                          )),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () => model.logout(),
                    child: Center(
                      child: AppText.button2L("Sign Out"),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
