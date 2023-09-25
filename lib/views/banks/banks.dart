import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';

import 'package:onyxswap/utils/app_colors.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/banks/components/bottom_sheet.dart';
import 'package:onyxswap/views/banks/components/container_widget.dart';
import 'package:onyxswap/views/banks/view%20model/add_bank_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

final _addBankViewModel =
    ChangeNotifierProvider.autoDispose((ref) => AddBankViewModel());

class AddBank extends ConsumerStatefulWidget {
  AddBank({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddBankState();
}

AddBankViewModel addBankViewModel = AddBankViewModel();

class _AddBankState extends ConsumerState<AddBank> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero, () => ref.read(_addBankViewModel).getAddedbank(context));
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var model = ref.watch(_addBankViewModel);
    return Scaffold(
      body: LoaderPage(
        loading: model.isLoading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                NyxIcons.arrow_back,
                                color: kSecondaryColor,
                              ),
                            ),
                            AppText.heading1L(
                              'Banks',
                              color: kSecondaryColor,
                            ),
                            const SizedBox(
                              width: 40,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 42,
                        ),
                        AppText.heading7L(
                          'Add or remove bank accounts. you need at least one bank account to receive withdrawals.',
                          multitext: true,
                          color: kSecondaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    model.add_bank!.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset('assets/pngs/bankbgSvg.svg'),
                                  SvgPicture.asset('assets/pngs/bankSvg.svg'),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              AppText.heading7L(
                                'Add new bank account',
                                color: kSecondaryColor,
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              AppText.caption1N(
                                'You haven’t added any bank accounts yet, tap the button below to get started ',
                                centered: true,
                                color: kSecondaryColor,
                                multitext: true,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          )
                        : SizedBox(
                            height:
                                (MediaQuery.of(context).size.height * 55) / 100,
                            child: ListView.builder(
                              itemBuilder: ((context, index) => ContainerWidget(
                                  accountname: model.add_bank![index][5],
                                  accountNumber: model.add_bank![index][3],
                                  bank: model.add_bank![index][4])),
                              shrinkWrap: true,
                              itemCount: model.add_bank!.length,
                            ),
                            // child: Column(
                            //   children: [
                            //     ...List.generate(
                            //         model.add_bank!.length,
                            //         (index) => ContainerWidget(
                            //             accountname: model.add_bank![index][5],
                            //             accountNumber: model.add_bank![index]
                            //                 [3],
                            //             bank: model.add_bank![index][4]),
                            //         growable: false)
                            //   ],
                            // ),
                          ),
                    // : Column(
                    //     children: [
                    //       ...List.generate(
                    //         9,
                    //         (index) => ContainerWidget(
                    //           bank: "",
                    //           accountNumber: 'accountNumber',
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 70,
                      ),
                      child: AppButton(
                          title: 'Add new bank account',
                          height: 54,
                          onTap: () => showModalBottomSheet(
                              context: context,
                              enableDrag: true,
                              isDismissible: true,
                              isScrollControlled: true,
                              backgroundColor: AppColors.backgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              builder: (context) => BottomSheetWidget())),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
