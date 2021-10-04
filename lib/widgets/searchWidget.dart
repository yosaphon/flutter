import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotto/screen/check/displaycheck.dart';

class SearchWidget extends StatefulWidget {
  final String text, type;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key key,
    this.text,
    this.type,
    this.onChanged,
    this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return  Container(
          height: 42,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.black26),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            // กรอกได้เฉพาะตัวเลย กับ ยาวสุก 6
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(6),
              ],
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: style.color),
              //ปุ่มท้าย textfild
              suffixIcon: widget.text.isNotEmpty
                  ? GestureDetector(
                      child: Icon(Icons.close, color: style.color),
                      onTap: () {
                        controller.clear();
                        widget.onChanged('');
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    )
                  : null,
              hintText: widget.hintText,
              hintStyle: style,
              border: InputBorder.none,
            ),
            style: style,
            onChanged: widget.onChanged,
          ), 
    );
  }


  

}
