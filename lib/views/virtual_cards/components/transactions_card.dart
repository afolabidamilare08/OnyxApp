import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/utils/text.dart';

class TransactionsCard extends StatelessWidget {
  const TransactionsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 19),
      margin: const EdgeInsets.only(top: 19),
      height: 94.5,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff353159),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
            ),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl:
                  "https://images.pexels.com/photos/2050994/pexels-photo-2050994.jpeg",
            ),
          ),
          const SizedBox(
            width: 13.5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.body1L("Mc Donalds"),
              const SizedBox(
                height: 10,
              ),
              AppText.body3L("26.07.2019 - 3:13 PM")
            ],
          ),
          const Spacer(),
          AppText.heading6L("-0.0034")
        ],
      ),
    );
  }
}
