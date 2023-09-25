import 'package:flutter/material.dart';

import '../../../utils/color.dart';




class DateWidget extends StatelessWidget {
  const DateWidget(
      {Key? key,
      required this.onChange,
      this.currentValue,
      this.validator,
      this.label})
      : super(key: key);
  final ValueChanged<DateTime> onChange;
  final DateTime? currentValue;
  final FormFieldValidator? validator;
  final String? label;

  String get _label {
    if (currentValue == null) return label!;

    return label!;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
        autovalidateMode:
      AutovalidateMode.onUserInteraction,
      initialValue:currentValue,
      validator: validator,

      builder: (formState) {
    

      if(formState.hasError){
        
      }
      return Column(
        children: [
          Stack(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                trailing: const Icon(
                  Icons.date_range,
                  color: kBorderColor,
                ),
                title: Text(_label),
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 36500)),
                      lastDate: DateTime.now());
                  if (date != null) {
                    onChange(date);
                    formState.didChange(date);
                  }
                },
              )
            ],
          )
        ],
      );
    });
  }
}
