import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/textstyle.dart';
import '../../../utils/color.dart';

class BuildLinearDateOfBirthField extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  const BuildLinearDateOfBirthField(
      {Key? key, required this.controller, this.validator})
      : super(key: key);

  @override
  State<BuildLinearDateOfBirthField> createState() =>
      _BuildLinearDateOfBirthFieldState();
}

class _BuildLinearDateOfBirthFieldState
    extends State<BuildLinearDateOfBirthField> {
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AppText.body2("Date of birth"),
        const SizedBox(
          height: 3,
        ),
        TextFormField(
          style: body1N,
          controller: widget.controller,
          keyboardType: TextInputType.none,
          validator: (v) {
            if (v!.isEmpty) {
              return 'Date cannot be empty';
            } else {
              return null;
            }
          },
          onTap: () async {
            FocusScope.of(context).unfocus();
            Future.delayed(const Duration(milliseconds: 300));
            date = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: date.subtract(const Duration(days: 100 * 365)),
                  lastDate: date,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme:const ColorScheme.dark(
                            primary: kSecondaryColor, // <-- SEE HERE
                            onPrimary: kPrimaryColor, // <-- SEE HERE
                            onSurface: kSecondaryColor,
                            onSecondary: kSecondaryColor,
                            onPrimaryContainer: kSecondaryColor
                            // <-- SEE HERE
                            ),
                        dialogBackgroundColor: kPrimaryColor,
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: kSecondaryColor, // button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                ) ??
                date;
            setState(() {
              widget.controller.text = DateFormat("dd-MM-yyyy").format(date);
            });
          },
          enabled: true,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(
                  width: 2,
                  style: BorderStyle.solid,
                  color: kSecondaryColor,
                ),
              ),
              suffixIcon: const Icon(
                Icons.calendar_month,
                color: kSecondaryColor,
              ),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: kBorderColor),
                  borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: kBorderColor,
                ),
              ),
              hintText: "yyyy/mm/dd",
              hintStyle: body1N),
        )
      ],
    );
  }
}
