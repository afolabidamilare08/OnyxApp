


import 'package:onyxswap/data/extension/extension.dart';

class TextFieldValidators {
  static var numbers = RegExp(r'^[0-9]+$');
  static var capitalLetter = RegExp(r'^[A-Z]+$');
  static var smallLetter = RegExp(r'^[a-z]+$');
  var i = RegExp(r"^[$&+,:;=?@#|'<>.^*()%!-]");
  static var specialCharacters = RegExp(r"^[$&+,:;=?@#|'<>.^*()%!-]");

  static String? password(String? value) {
    const String title = "password";
    if (value == null || value.isEmpty) {
      return "$title can not be empty".capitalize();
    } else {
      // check length of string
      if (value.length <= 7) {
        // print(value.length);
        return "$title must be at least 8 chars".capitalize();
      }
      //RegExp regExp = RegExp(numbers);
      else if (!numbers.hasMatch(value)) {
        return 'Must contain a number';
      } else if (!capitalLetter.hasMatch(value)) {
        return 'Must contain capital letter';
      } else if (!smallLetter.hasMatch(value)) {
        return 'Must contain small letter';
      } else if (!specialCharacters.hasMatch(value)) {
        return 'Must contain a special character ie #*&?';
      } else {
        return null;
      }
    }
  }

  static String? email(String? value) {
    const String title = "email";
    if (value == null || value.isEmpty) {
      return "$title can not be empty".capitalize();
    } else {
      // check length of string
      if (value.isNotEmail()) {
        return "Please enter a valid $title".capitalize();
      } else {
        return null;
      }
    }
  }

  static String? phonenumber(String? value) {
    const String title = "Phonenumber";
    if (value == null || value.isEmpty) {
      return "$title can not be empty".capitalize();
    } else {
      // check length of string
      if (value.isNotPhonenumber()) {
        return "Please enter a valid $title".capitalize();
      } else {
        return null;
      }
    }
  }

  static String? otp(String? value) {
    if (value!.isEmpty) {
      return "OTP Code cannot be empty";
    } else if (value.length < 4) {
      return "Please completly fill your OTP code";
    }
    return null;
  }

  static String? pin(String? value) {
    if (value!.isEmpty) {
      return "Pin Code cannot be empty";
    } else if (value.length < 4) {
      return "Please completly fill your Pin code";
    } else if (value.length > 4) {
      return 'Pin cannot be more than 4 digit';
    }
    return null;
  }

  static String? fullName({required String title, String? val}) {
    if (val == null || val.isEmpty) {
      return "FullName can not be empty";
    } else {
      var values = val.split(" ");
      // ignore: prefer_is_empty
      if (values.length <= 1) {
        return "please enter a valid fullname";
      } else {
        if (values[0].length < 3 && values[1].length < 3) {
          return "Either name must be at least 3 char";
        }
        {
          return null;
        }
      }
    }
  
  }
  // static String? dob(String? value) {
  //   const String title = 'Date of birth';
  //    if (value == null || value.isEmpty) {
  //     return "$title can not be empty".capitalize();
  //   } else{
  //     if (value>=DateTime.now().)
  //   }
  // }
}
