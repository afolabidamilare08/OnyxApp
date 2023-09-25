import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';

import 'package:onyxswap/utils/text.dart';

class SecurityWidget extends StatelessWidget {
  const SecurityWidget({Key? key, required this.title, required this.subtitle, this.onTap}) : super(key: key);
final String title;
final String subtitle;
final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        height: MediaQuery.of(context).size.height/10,
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorderColor),top: BorderSide(color: kBorderColor))
          
        ),
      child: Row(
        children: [
       
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              AppText.button2L(title),
              const SizedBox(height: 5,),
              AppText.body2L(subtitle,color: kSecondaryColor.withOpacity(0.72),),
    
            ],
          ),
         const Spacer(),
          const Icon(Icons.arrow_forward_ios,color: kSecondaryColor,size:15)
            
        ],
      ),
      ),
    );
  }
}