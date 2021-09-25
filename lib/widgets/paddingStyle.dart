import 'package:flutter/material.dart';

Widget frameWidget(Widget dataWidget) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 4), // changes position of shadow
                ),
              ],
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: dataWidget),
    );
  }