import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';





import '../view model/signup_viewmodel.dart';
import 'country_flag.dart';
import 'signup_widget.dart';

final signupViewModel =
    ChangeNotifierProvider.autoDispose((ref) => SignupViewModel());

class Country extends ConsumerWidget {
  const Country( {Key? key, this.onBack,this.onNext,}) : super(key: key);
  final Function()? onBack;
  final Function()? onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SignupWidget(
        onBack: onBack,
        text: 'Country of Residence',
        children: 
        CountryFlag(),
     
        
        subText: 'What country do you currently live in?',
      ),
    );
  }
}
