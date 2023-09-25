import 'package:flutter/material.dart';
import 'package:onyxswap/widgets/keyboard_key.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({Key? key}) : super(key: key);

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  List keys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '',
    '0',
    const Icon(Icons.backspace)
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.count(childAspectRatio: 3.0, crossAxisCount: 3, children: [
      ...List.generate(
          12,
          (index) => KeyboardKey(
                label: keys[index],
                value: keys[index],
                onTap: (value) {
                  setState(() {
                    value = keys[index];
                    print(value);
                  });
                },
              )),
    ]);
  }
}
