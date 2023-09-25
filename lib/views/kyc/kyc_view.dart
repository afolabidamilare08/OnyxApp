import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';

import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/views/kyc/component/kyc_widget.dart';
import 'package:onyxswap/views/kyc/component/nationality.dart';
import 'package:onyxswap/views/kyc/viewmodel/nin_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/loaderpage.dart';
import '../../utils/text.dart';

final _ninViemodel = ChangeNotifierProvider.autoDispose(
  (ref) => NinViewModel(),
);

class Kyc extends ConsumerStatefulWidget {
  const Kyc({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KycState();
}

class _KycState extends ConsumerState<Kyc> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero, () => ref.read(_ninViemodel).checkBvn('BVN', context));
    Future.delayed(
        Duration.zero, () => ref.read(_ninViemodel).checkBvn('NIN', context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(_ninViemodel);
    return Scaffold(
      body: SafeArea(
        child: LoaderPage(
          loading: model.isLoading,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      NyxIcons.arrow_back,
                      color: kSecondaryColor,
                    )),
                AppText.body1L(
                  'We need a litttle more information to complete your account verification',
                  multitext: true,
                  color: kSecondaryColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView(
                  children: [
                    const KycWidget(
                      title: 'Verify Email',
                      icon: Icons.email_outlined,
                      isverified: true,
                      subtitle:
                          'A verification Link has been sent to you email address, Please click on the link to complete email verification',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    KycWidget(
                        title: 'BVN verification',
                        icon: NyxIcons.bvn,
                        isverified: model.bvnvalidate,
                        subtitle:
                            'Please verify your BVN to be able to create Nairawallet and perform transaction',
                        onTap: () => !model.bvnvalidate
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Nationality(
                                        type: 'BVN', hint: 'BVN number')))
                            : () {}),
                    const SizedBox(
                      height: 20,
                    ),
                    KycWidget(
                        title: 'NIN verification',
                        icon: NyxIcons.nin,
                        isverified: model.ninvalidate,
                        subtitle: 'Verify Your Nin for better access',
                        onTap: () => !model.ninvalidate
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Nationality(
                                        type: 'NIN', hint: 'NIN number')))
                            : () {})
                  ],
                )),
                SizedBox(
                  height: 10,
                ),
                AppButton(
                  title: 'Remind me later',
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
