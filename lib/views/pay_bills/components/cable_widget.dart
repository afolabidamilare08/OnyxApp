
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onyxswap/utils/color.dart';


import '../viewmodels/cable_viwmmodel.dart';

final _cablViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => CableViewmodel());

class CableWidget extends ConsumerStatefulWidget {
  const CableWidget( {
    Key? key,
    required this.type,
    this.selected=false,
  }) : super(key: key);
  final String type;
  final bool selected;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CableWidgetState();
}

class _CableWidgetState extends ConsumerState<CableWidget> {
  bool picked = false;
  @override
  Widget build(BuildContext context) {

    return
        // GestureDetector(
        //   onTap: () {
        //     setState(() {
        //       picked = !picked;
        //     });
        //     model.serviceId = widget.type.split('.')[0];
        //     model.getSubsciptionPlan();
        //   },
        //   child:
        Container(
      margin: const EdgeInsets.only(right: 20),
      height: 55,
      width: 97,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: kBorderColor),
          image:
              DecorationImage(image: AssetImage('assets/pngs/${widget.type}'))),
      child: widget.selected
          ? Container(
              height: 55,
              width: 97,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.topRight,
              child: const Icon(
                Icons.check,
                color: kSecondaryColor,
              ),
            )
          : SizedBox(),
    );
    //  );
  }
}
