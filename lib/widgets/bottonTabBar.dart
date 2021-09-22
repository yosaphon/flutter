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
            icon: Icon(Icons.home,size: 30,),
          ),
          buildTabItem(
            index: 1,
            icon: Icon(FontAwesomeIcons.youtube,),
          ),
          placeholder,
          buildTabItem(
            index: 2,
            icon: Icon(Icons.visibility,size: 30,),
          ),
          buildTabItem(
            index: 3,
            icon: Icon(Icons.account_circle_outlined,size: 30,),
            
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    @required int index,
    @required Icon icon,
  }) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? Colors.blue : Colors.black,
      ),
      child: IconButton(
        icon: icon,
        onPressed: () => widget.onChangedTab(index),
      ),
    );
    // IconTheme(
    //   data: IconThemeData(
    //     color: isSelected ? Colors.blue : Colors.black,
    //   ),
    //   child: AnimatedContainer(
    //     width: 80,
    //     height: 80,
    //     duration: const Duration(seconds: 2),
    //   curve: Curves.easeIn,
    //     child: InkWell(
          
    //       onTap: () {
    //         widget.onChangedTab(index);
    //       }, // button pressed
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           icon, // icon
    //           Text(text,style: TextStyle(fontSize: 10),), // text
    //         ],
    //       ),
    //     ),
    //   ),
  }
}