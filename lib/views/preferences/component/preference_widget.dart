import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';

import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/preferences/component/switch.dart';

class PreferenceWidget extends StatelessWidget {
   PreferenceWidget({Key? key, required this.title, required this.lang,}) : super(key: key);
final String title;
final bool lang;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20),
      height: MediaQuery.of(context).size.height/10,
      width: double.infinity,
      decoration:  BoxDecoration(
        border: Border(bottom:lang?BorderSide.none: const BorderSide(color: kBorderColor),top: const BorderSide(color: kBorderColor))
        
      ),
    child: Row(
      children: [
     
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            AppText.button2L(title),
            // const SizedBox(height: 5,),
            // AppText.body2L(subtitle,color: kSecondaryColor.withOpacity(0.72),),

          ],
        ),
       const Spacer(),
        lang?Row(
          children: [
            AppText.body2L('English',color: kSecondaryColor,),
            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios,color: kSecondaryColor,))
          ],
        ):
        SizedBox(
          height: 31,
          width: 64,
          child: SwitchView())
          
      ],
    ),
    );
  }
}