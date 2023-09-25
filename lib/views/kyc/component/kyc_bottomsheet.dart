import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../viewmodel/nin_viewmodel.dart';

final _ninViemodel = ChangeNotifierProvider.autoDispose(
  (ref) => NinViewModel(),
);

class KycBottonsheet extends ConsumerWidget {
  const KycBottonsheet(
      {Key? key,
      required this.fullname,
       this.idNumber,
      required this.idType,
      required this.loading,
      this.image,
      this.ontap})
      : super(key: key);
  final String fullname;
  final String idType;
  final String? idNumber;
  final Uint8List? image;
  final Function()? ontap;
  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(_ninViemodel);
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      width: double.infinity,
      child: LoaderPage(
        loading: model.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.body3L(
                    'Full Name',
                    color: kSecondaryColor.withOpacity(0.5),
                  ),
                  AppText.body3L(
                    fullname,
                    color: kSecondaryColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.body3L(
                   idType=='NIN'?'': '$idType number',
                    color: kSecondaryColor.withOpacity(0.5),
                  ),
                  AppText.body3L(
                    idNumber??'',
                    color: kSecondaryColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.body3L(
                    'Picture',
                    color: kSecondaryColor.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.memory(image!),
                  )
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: ontap,
                child: Container(
                  height: 61,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: kBorderColor),
                      borderRadius: BorderRadius.circular(8),
                      color: kSecondaryColor),
                  child: AppText.button2L(
                    'Next',
                    color: kPrimaryColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
