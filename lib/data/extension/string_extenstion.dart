extension StringExtension on String {
  ///check if the string is an email
  bool isEmail() {
    //email regex pattern
    const String emmailRegExpString =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final RegExp emmailRegExp = RegExp(emmailRegExpString);
    return emmailRegExp.hasMatch(this);
  }

  ///check if the string is an email
  bool isNotEmail() {
    return !isEmail();
  }

  /// this would capitalize the first letter of the String
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  bool isPhonenumber() {
    const String reg = "^(?:[+0]9)?[0-9]{10}";
    final RegExp phoneRegExp = RegExp(reg);
    return phoneRegExp.hasMatch(this);
  }

  bool isNotPhonenumber() {
    return !isPhonenumber();
  }
  // String toMoney() {
  //   var f = NumberFormat('###.0#', 'en_US');
  //   return f.format(this);
  // }
}
