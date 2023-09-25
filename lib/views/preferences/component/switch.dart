import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/preferences/viewmodel/preferences_viewmodel.dart';

import '../../../data/local/local_cache/local_cache.dart';
import '../../../utils/locator.dart';
import '../../authentication/models/messaging.dart';

final _messaging =
    ChangeNotifierProvider.autoDispose((ref) => MessagingSetup());
final _preferences =
    ChangeNotifierProvider.autoDispose((ref) => PreferencesViewModel());

class SwitchView extends ConsumerStatefulWidget {
  const SwitchView({Key? key}) : super(key: key);

  @override
  ConsumerState<SwitchView> createState() => _SwitchViewState();
}


 LocalCache _localCache = locator<LocalCache>();
class _SwitchViewState extends ConsumerState<SwitchView> {
  bool on = false;
 bool isSwitched() {
    if (_localCache.getFromLocalCache('firebaseToken') != null) {
      setState(() {
        on = true;
      });
      // on = true;
      //notifyListeners();
      return on;
    } else {
      setState(() {
        on = false;
      });
      
      // on = false;
      //notifyListeners();
      return on;
    }
  }


  void toggleSwitch(bool newState) async {
    
      
        setState(() {
            on = newState;
        });
        // if (on == true)  {
        //   ref.watch(_messaging).messagingSetup();
        //   if(ref.read(_messaging).token != null){
        //     ref.watch(_preferences).pushNotificationSetup(ref.read(_messaging).token!);
        //   }
          
          
        // }else{
        //   await FirebaseMessaging.instance.deleteToken();
        // }
    
  }
  // @override
  // void initState() {
  //   isSwitched();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    
    var model=ref.watch(_preferences);
   //on = model.isSwitched();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: MySwitch(
            value: on,
            onChange: toggleSwitch,
          )),
        ],
      ),
    );
  }
}

class MySwitch extends StatefulWidget {
  const MySwitch({
    Key? key,
    required this.value,
    required this.onChange,
    this.onColor = kBorderColor,
    this.offColor = kPrimaryColor,
    this.thumbColor = const Color(0xffffffff),
  }) : super(key: key);

  final bool value;
  final Color onColor;
  final Color offColor;
  final Color thumbColor;
  final Function(bool) onChange;

  @override
  State<MySwitch> createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
    //userd to set initial vale
    value: widget.value ? 1 : 0,
  );
  late Animation<Color?> color;
  late Animation<double?> postion;
  // Animation animation = Animation();
  @override
  initState() {
    color = ColorTween(
      begin: Colors.grey,
      end: kBorderColor,
    ).animate(animationController);

    postion = Tween<double>(begin: 10, end: 40).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
      reverseCurve: Curves.decelerate,
    ));

    color = ColorTween(begin: widget.offColor, end: widget.onColor)
        .animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
      reverseCurve: Curves.decelerate,
    ));
    // .animate(animationController);
    super.initState();
  }

  @override
  void didUpdateWidget(MySwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      animateToValue();
    }
  }

  animateToValue() {
    setState(() {
      widget.value
          ? animationController.forward()
          : animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            return GestureDetector(
              onTap: () => widget.onChange(!widget.value),
              child: CustomPaint(
                painter: SwitchPaint(color.value!, postion.value!),
                child: const SizedBox(
                  height: 20,
                  width: 50,
                ),
              ),
            );
          }),
    );
  }
}

class SwitchPaint extends CustomPainter {
  final Color backgroundColor;
  final double position;

  SwitchPaint(this.backgroundColor, this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()..color = backgroundColor;
    final circlePaint = Paint()..color = Colors.white;

    canvas.drawRRect(
      RRect.fromLTRBR(
        0,
        0,
        size.width,
        size.height,
        const Radius.circular(15),
      ),
      bodyPaint,
    );

    final circleRadius = size.height / 2;
    canvas.drawCircle(
      Offset(position, circleRadius),
      //for slight padding
      circleRadius - 1,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
