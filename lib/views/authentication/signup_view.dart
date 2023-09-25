import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/authentication/view%20model/signup_viewmodel.dart';
import 'package:onyxswap/widgets/background_widget.dart';


final signupViewModel =
    ChangeNotifierProvider.autoDispose((ref) => SignupViewModel());

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  @override
  Widget build(BuildContext context) {
    var model = ref.watch(signupViewModel);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BackgroundWidget(
        flexibleSpace: MediaQuery.of(context).size.height < 700
            ? 30
            : model.index == 5 || model.index == 2
                ? 86
                : 190,
        buyAndSell: false,
        sendAndRecieve: false,
        children: [
          SizedBox(
            height:  model.index != 5 || model.index != 2 ? 490 : 500,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) => model.setCurrentPage(value),
              controller: model.controller,
              children: model.pages,
            ),
          ),
          //SizedBox(height: MediaQuery.of(context).size.height,)
        ],
      ),
    );
  }
}
