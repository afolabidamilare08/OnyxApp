import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({Key? key, required this.child, required this.loading})
      : super(key: key);
  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          child,
          if (loading)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.35),
              child:  SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: 
                        Lottie.asset("assets/lotties/loader.json",height: 40,width: 40)
                        )),
            )
        ],
      ),
    );
  }
}
