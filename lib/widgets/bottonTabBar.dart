import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  const TabBarMaterialWidget({
    @required this.index,
    @required this.onChangedTab,
    Key key,
  }) : super(key: key);

  @override
  _TabBarMaterialWidgetState createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    final placeholder = Opacity(
      opacity: 0,
      child: IconButton(icon: Icon(Icons.no_cell), onPressed: null),
    );
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
              index: 0,
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              text: "หน้าหลัก"),
          buildTabItem(
              index: 1,
              icon: Icon(
                FontAwesomeIcons.youtube,
              ),
              text: "ดูออนไลน์"),
          placeholder,
          buildTabItem(
              index: 2,
              icon: Icon(
                Icons.visibility,
                size: 30,
              ),
              text: "ทำนาย"),
          buildTabItem(
              index: 3,
              icon: Icon(
                Icons.account_circle_outlined,
                size: 30,
              ),
              text: "ผู้ใช้"),
        ],
      ),
    );
  }

  Widget buildTabItem({@required int index, @required Icon icon, String text}) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? Colors.blue : Colors.black,
      ),
      child: AnimatedContainer(
        width: 52,
        height: 52,
        duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
        child: InkWell(
          onTap: () {
            widget.onChangedTab(index);
          }, // button pressed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon, // icon
              Text(text,style: TextStyle(fontSize: 10),), // text
            ],
          ),
        ),
      ),

      // Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: <Widget>[
      //     IconButton(
      //       icon: icon,
      //       onPressed: () {
      //         widget.onChangedTab(index);
      //       },
      //     ),
      //     Text(text,style: TextStyle(color: isSelected ? Colors.blue : Colors.black),),
      //   ],
      // )

      // IconButton(
      //   icon: icon,
      //   onPressed: () => widget.onChangedTab(index),
      // ),
    );
  }
}