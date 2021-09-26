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
              //size: 28,
            ),
            text: "หน้าหลัก",
          ),
          buildTabItem(
            index: 1,
            icon: Icon(
              FontAwesomeIcons.youtube,
              //size: 26,
            ),
            text: "ดูออนไลน์",
          ),
          placeholder,
          buildTabItem(
            index: 2,
            icon: Icon(
              Icons.visibility,
              //size: 27,
            ),
            text: "ทำนาย",
          ),
          buildTabItem(
            index: 3,
            icon: Icon(
              FontAwesomeIcons.userAlt,
              //size: 27,
            ),
            text: "ผู้ใช้",
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    @required int index,
    @required Icon icon,
    String text
  }) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? Colors.indigo : Color(0xFFB3B7C0),
        size: isSelected ? 28: 23
      ),
      child: AnimatedContainer(
        width: 52,
        height: 52,
        duration: const Duration(seconds: 5),
        curve: Curves.easeIn,
        child: InkWell(
          onTap: () {
            widget.onChangedTab(index);
          }, // button pressed
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                icon, // icon
                Text(text,style: TextStyle(fontSize: 10,color: isSelected ? Colors.indigo : Color(0xFFB3B7C0)),), // text
              ],
            ),
          ),
        ),
      ),
    );
    //  IconTheme(
    //   data: IconThemeData(
    //     color: isSelected ? Colors.blue : Colors.black,
    //   ),
    //   child: IconButton(
    //     icon: icon,
    //     onPressed: () => widget.onChangedTab(index),
    //   ),
    // );
  }
}
