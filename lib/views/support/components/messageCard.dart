// ignore_for_file: file_names, must_be_immutable, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:onyxswap/models/chatMessgaeModel.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class MessgaeCard extends StatelessWidget {
  MessgaeCard({
    Key? key,
    required this.messages,
    required this.index,
  }) : super(key: key);
  List<ChatMessage> messages;

  int index;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: (messages[index].messageType == "receiver"
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          child: Row(
            mainAxisAlignment: messages[index].messageType == "receiver"
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              messages[index].messageType == "receiver"
                  ? Container(
                      clipBehavior: Clip.hardEdge,
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            "https://images.pexels.com/photos/2050994/pexels-photo-2050994.jpeg",
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 2,
                    maxWidth: MediaQuery.of(context).size.width / 2),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: messages[index].messageType == "receiver"
                        ? const BorderRadius.only(
                            topRight: Radius.circular(7),
                            bottomRight: Radius.circular(7),
                            bottomLeft: Radius.circular(7))
                        : const BorderRadius.only(
                            topLeft: Radius.circular(7),
                            bottomRight: Radius.circular(7),
                            bottomLeft: Radius.circular(7)),
                    color: messages[index].messageType == "receiver"
                        ? Colors.lightGreen[200]
                        : const Color(0xffd9d9d9)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.body4L(
                      messages[index].messageContent,
                      multitext: true,
                      maxlines: 9999999,
                      color: kPrimaryColor,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      AppText.body6L(
                        messages[index].sentat,
                        color: kPrimaryColor,
                      )
                    ])
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
