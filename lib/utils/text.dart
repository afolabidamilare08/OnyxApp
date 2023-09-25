import 'package:flutter/material.dart';

import '../core/constants/textstyle.dart';


class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool centered;
  final bool multitext;
  final TextOverflow overflow;
  final Color? color;
  final int? maxlines;
  final double? height;
  final TextAlign? textAlign;

  /// this is heading 1 NeueMachina , font size = 32, fontweight = 800.
  AppText.heading1N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading1N.copyWith(color: color),
        super(key: key);

  /// this is heading 2 NeueMachina , font size = 26, fontweight = 800.
  AppText.heading2N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading2N.copyWith(color: color),
        super(key: key);

  /// this is heading 3 NeueMachina , font size = 24, fontweight = 800.
  AppText.heading3N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading3N.copyWith(color: color),
        super(key: key);

  /// this is heading 4 NeueMachina , font size = 22, fontweight = 800.
  AppText.heading4N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading4N.copyWith(color: color),
        super(key: key);

  /// this is heading 5 NeueMachina , font size = 20, fontweight = 800.
  AppText.heading5N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading5N.copyWith(color: color),
        super(key: key);

  /// this is heading 6 NeueMachina , font size = 16, fontweight = 800.
  AppText.heading6N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading6N.copyWith(color: color),
        super(key: key);

  /// this is heading 6 lato , font size = 15, fontweight = 700.
  AppText.heading6L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading6L.copyWith(color: color),
        super(key: key);
  AppText.heading7L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading7L.copyWith(color: color),
        super(key: key);

  /// this is heading 7 NeueMachina , font size = 15, fontweight = 800.
  AppText.heading7N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading7N.copyWith(color: color),
        super(key: key);

  /// this is heading 8 NeueMachina , font size = 12, fontweight = 800.
  AppText.heading8N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading8N.copyWith(color: color),
        super(key: key);

  /// this is heading 8 NeueMachina , font size = 12, fontweight = 800.
  AppText.heading1L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading1L.copyWith(color: color),
        super(key: key);

  /// this is heading 8 NeueMachina , font size = 12, fontweight = 800.
  AppText.heading2L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading2L.copyWith(color: color),
        super(key: key);

  /// this is heading 8 NeueMachina , font size = 12, fontweight = 800.
  AppText.heading3L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = heading3L.copyWith(color: color),
        super(key: key);

  /// this is caption 1 NeueMachina , font size = 16, fontweight = 400.
  AppText.caption1N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = caption1N.copyWith(color: color),
        super(key: key);

  /// this is caption 2 NeueMachina , font size = 15, fontweight = 400.
  AppText.caption2N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = caption2N.copyWith(color: color),
        super(key: key);

  /// this is caption 3 NeueMachina , font size = 13, fontweight = 400.
  AppText.caption3N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = caption3N.copyWith(color: color),
        super(key: key);

  /// this is caption 4 NeueMachina , font size = 11, fontweight = 400.
  AppText.caption4N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = caption4N.copyWith(color: color),
        super(key: key);

  /// this is body 1 poppins bold and large,
  /// font size = 29, fontweight = 600.
  AppText.body1PBL(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body1PBL.copyWith(color: color),
        super(key: key);

  /// this is body 1 poppins bold , font size = 24, fontweight = 600.
  AppText.body1PB(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body1PB.copyWith(color: color),
        super(key: key);

  /// this is body 1 poppins semibold , font size = 21, fontweight = 500.
  AppText.body1PSB(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body1PSB.copyWith(color: color),
        super(key: key);

  /// this is body 1 poppins , font size = 17, fontweight = 600.
  AppText.body1P(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body1P.copyWith(color: color),
        super(key: key);

  /// this is body 2 poppins , font size = 16, fontweight = 400.
  AppText.body2P(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body2P.copyWith(color: color),
        super(key: key);

  /// this is body 3 poppins , font size = 15, fontweight = 500.
  AppText.body3P(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body3P.copyWith(color: color),
        super(key: key);

  /// this is body 4 poppins bold , font size = 14, fontweight = 600.
  AppText.body4PB(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body4PB.copyWith(color: color),
        super(key: key);

  /// this is body 4 poppins , font size = 14, fontweight = 500
  AppText.body4P(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body4P.copyWith(color: color),
        super(key: key);

  /// this is body 1 lato , font size = 16, fontweight = 600.
  AppText.body1L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body1L.copyWith(color: color),
        super(key: key);

  /// this is body 2 lato , font size = 15, fontweight = 400.
  AppText.body2L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = true,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body2L.copyWith(color: color),
        super(key: key);

  /// this is body 3 lato , font size = 14, fontweight = 400.
  AppText.body3L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body3L.copyWith(color: color),
        super(key: key);

  /// this is body 4 lato , font size = 13, fontweight = 400.
  AppText.body4L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body4L.copyWith(color: color),
        super(key: key);

  /// this is body 4 lato , font size = 9, fontweight = 500.
  AppText.body5L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body5L.copyWith(color: color),
        super(key: key);

  /// this is body 4 lato , font size = 9, fontweight = 500.
  AppText.body6L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body6L.copyWith(color: color),
        super(key: key);
  AppText.body7L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body7L.copyWith(color: color),
        super(key: key);
  AppText.body8L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body8L.copyWith(color: color),
        super(key: key);
  AppText.body9L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body9L.copyWith(color: color),
        super(key: key);
  AppText.body10L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body10L.copyWith(color: color),
        super(key: key);

  /// this is body 1 NeueMachina , font size = 14, fontweight = 400.
  AppText.body1N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = body1N.copyWith(color: color),
        super(key: key);

  /// this is button 1 NeueMachina , font size = 20, fontweight = 800.
  AppText.button1N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = button1N.copyWith(color: color),
        super(key: key);
  AppText.pinStyle(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = pinStyle.copyWith(color: color),
        super(key: key);

  /// this is button 2 NeueMachina , font size = 16, fontweight = 800.
  AppText.button2N(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = button2N.copyWith(color: color),
        super(key: key);

  /// this is button 2 poppins , font size = 16, fontweight = 700.
  AppText.button2P(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = button2P.copyWith(color: color),
        super(key: key);

  /// this is button 2 lato , font size = 16, fontweight = 600.
  AppText.button2L(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = button2L.copyWith(color: color),
        super(key: key);

  /// this is button 3 poppins , font size = 13, fontweight = 500.
  AppText.button3P(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = button3P.copyWith(color: color),
        super(key: key);

  /// this is button 4 lato , font size = 9, fontweight = 700.
  AppText.lato(
    this.text, {
    Key? key,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.centered = false,
    this.multitext = true,
    this.textAlign,
    this.maxlines,
    this.height,
  })  : style = button4L.copyWith(color: color),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(
        height: height,
      ),
      overflow: overflow,
      textAlign: centered ? TextAlign.center : textAlign ?? TextAlign.left,
      maxLines: multitext || maxlines != null ? maxlines ?? 999999 : 1,
    );
  }
}
