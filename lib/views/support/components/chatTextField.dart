// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:onyxswap/core/constants/textstyle.dart';
import 'package:onyxswap/utils/color.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({Key? key, required this.message, required this.onTap,required this .onTFTap})
      : super(key: key);
  final TextEditingController message;
  final Function() onTap;
  final Function() onTFTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      //constraints: BoxConstraints(maxHeight: 300),

      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      margin: const EdgeInsets.all(24),
      width: double.infinity,
      //height: 53,
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const CircleAvatar(
          //   radius: 18,
          //   backgroundColor: Color(0xff2b2d2b),
          //   child: Center(
          //     child: Icon(
          //       Icons.photo_camera_outlined,
          //       color: kSecondaryColor,
          //     ),
          //   ),
          // ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              // expands: true,
              maxLines: 10,
              minLines: 1,
              cursorWidth: 1.5,
              cursorHeight: 17,
              cursorColor: kSecondaryColor,
              controller: message,
              keyboardType: TextInputType.multiline,
              style: body4PB,
              decoration: const InputDecoration(border: InputBorder.none),
              onTap: onTFTap
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          // const Icon(
          //   Icons.mic,
          //   size: 24,
          //   color: kSecondaryColor,
          // ),
          // const SizedBox(
          //   width: 15,
          // ),
          GestureDetector(
            onTap: onTap,
            child: const Icon(
              Icons.send,
              size: 24,
              color: kSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
