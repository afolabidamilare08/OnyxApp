import 'package:flutter/material.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

import '../../../core/constants/textstyle.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../../../utils/validators.dart';

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({Key? key, required this.controller}) : super(key: key);
  //final controller = TextEditingController();
  final TextEditingController controller;
  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  final showCountryPicker = const FlCountryCodePicker(
      filteredCountries: ['NG', 'ZA', 'GH'], showSearchBar: false);
  CountryCode? country;
  @override
  Widget build(BuildContext context) {
    //final countryPicker=showCountryPicker(context: context, onSelect: onSelect)
    return TextFormField(
      style: body4PB,
      controller: widget.controller,
      maxLines: 1,
      validator: (v) => TextFieldValidators.phonenumber(v),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          labelText: 'PhoneNumber',
          labelStyle: body4P,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              width: 2,
              style: BorderStyle.solid,
              color: kSecondaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: kBorderColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: kBorderColor,
            ),
          ),
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            margin: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () async {
                  final code = await showCountryPicker.showPicker(
                      context: context, pickerMaxHeight: 250);

                  setState(() {
                    country = code!;
                  });
                  print(country?.code ?? '');
                  //showCountryPicker.filteredCountries=[]
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: kSecondaryColor),
                    ),
                  ),
                  child: AppText.body4P(country?.dialCode ?? '+234'),
                ),
              )
            ]),
          )),
    );
  }
}
