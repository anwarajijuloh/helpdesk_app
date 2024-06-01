import 'package:flutter/material.dart';

import '../config/constants.dart';

// ignore: must_be_immutable
class MyPopMenuButton extends StatefulWidget {
  String selected;
  final List<String> myList;
  MyPopMenuButton({super.key, required this.myList, required this.selected});

  @override
  State<MyPopMenuButton> createState() => _MyPopMenuButtonState();
}

class _MyPopMenuButtonState extends State<MyPopMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        setState(() {
          widget.selected = value;
        });
      },
      initialValue: widget.myList[0],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: grey2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.selected,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: grey2,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.filter_list_rounded,
              size: 18,
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        return widget.myList.map((x) {
          return PopupMenuItem(
            value: x,
            child: Text(x),
          );
        }).toList();
      },
    );
  }
}
