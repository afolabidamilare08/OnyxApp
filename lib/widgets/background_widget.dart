// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:onyxswap/custom_paints/black_painter.dart';
import 'package:onyxswap/custom_paints/buy_painter.dart';
import 'package:onyxswap/custom_paints/primary_painter.dart';
import 'package:onyxswap/custom_paints/sell_painter.dart';
import 'package:onyxswap/utils/text.dart';


class BackgroundWidget extends StatefulWidget {
  BackgroundWidget(
      {Key? key,
      required this.flexibleSpace,
      this.flexibleChild,
      required this.buyAndSell,
      required this.sendAndRecieve,
      this.onTapBuy,
      this.onTapSell,
      this.loading,
      this.buyIsTapped,
      required this.children})
      : super(key: key);
  //this is required, at least 100 due to safearea
  final double flexibleSpace;
  final Widget? flexibleChild;
  final bool buyAndSell;
  final bool sendAndRecieve;
  bool? buyIsTapped;
  Function()? onTapBuy;
  Function()? onTapSell;
  bool? loading;
  List<Widget> children;

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: widget.flexibleSpace +
                    ((widget.buyAndSell || widget.sendAndRecieve) ? 135 : 90),
                decoration: const BoxDecoration(),
                child: Image.asset(
                  "assets/pngs/bg.png",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: widget.flexibleChild ?? const SizedBox.shrink(),
                height: widget.flexibleSpace,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                top: widget.flexibleSpace,
                child: SizedBox(
                  height: (MediaQuery.of(context).size.height),
                  width: MediaQuery.of(context).size.width,
                  child: CustomPaint(
                    painter: PrimaryCustomPainter(),
                  ),
                ),
              ),
              Positioned(
                top: widget.flexibleSpace + 37,
                child: SizedBox(
                  height: (MediaQuery.of(context).size.height),
                  width: MediaQuery.of(context).size.width,
                  child: CustomPaint(
                    painter: BlackCustomPainter(),
                  ),
                ),
              ),
              (widget.buyAndSell || widget.sendAndRecieve)
                  ? Positioned(
                      right: 0,
                      top: widget.flexibleSpace + 47,
                      child: SizedBox(
                        height: 97,
                        // height: 819,
                        width: MediaQuery.of(context).size.width / 2,
                        //color: kPrimaryColor,
                        child: CustomPaint(
                          //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                          painter: SellCustomPainter(widget.buyIsTapped!
                              ? const Color(0xff252725)
                              : Colors.transparent),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              (widget.buyAndSell || widget.sendAndRecieve)
                  ? Positioned(
                      left: 0,
                      top: widget.flexibleSpace + 37,
                      child: SizedBox(
                        height: 97,
                        // height: 819,
                        width: MediaQuery.of(context).size.width / 2,
                        //color: kPrimaryColor,
                        child: CustomPaint(
                          //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                          painter: BuyCustomPainter(
                            widget.buyIsTapped ?? false
                                ? Colors.transparent
                                : const Color(0xff252725),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              (widget.buyAndSell || widget.sendAndRecieve)
                  ? Positioned(
                      left: 0,
                      top: widget.flexibleSpace + 47,
                      child: GestureDetector(
                        onTap: widget.onTapBuy,
                        child: SizedBox(
                          height: 97,
                          // height: 819,
                          width: MediaQuery.of(context).size.width / 2,
                          //color: kPrimaryColor,
                          child: Center(
                              child: AppText.heading1L(
                                  widget.buyAndSell ? "Buy" : "Send")),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              (widget.buyAndSell || widget.sendAndRecieve)
                  ? Positioned(
                      right: 0,
                      top: widget.flexibleSpace + 47,
                      child: GestureDetector(
                        onTap: widget.onTapSell,
                        child: SizedBox(
                          height: 97,
                          // height: 819,
                          width: MediaQuery.of(context).size.width / 2,
                          //color: kPrimaryColor,
                          child: Center(
                              child: AppText.heading1L(
                                  widget.buyAndSell ? "Sell" : "Recieve")),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Column(
            //children after the flexible space
            children: widget.children,
          )
        ],
      ),
    );
  }
}
