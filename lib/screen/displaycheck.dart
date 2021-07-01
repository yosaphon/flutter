import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotto/model/check_dialog.dart';
import 'package:lotto/screen/qr_scan_page.dart';

class Formqrcodescan extends StatefulWidget {
  @override
  _FormqrcodescanState createState() => _FormqrcodescanState();
}

String scanresult;
bool checkLineURL = false;
bool checkFacebookURL = false;
bool checkYoutubeURL = false;

class _FormqrcodescanState extends State<Formqrcodescan> {
  final _formKey = GlobalKey<FormState>();
  static List<String> lottery = [null];

  @override
  void initState() {
    super.initState();

    CheckDialog('25640616', '000000').alertChecking(context);  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ตรวจรางวัล",
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                ),
                ..._getLottery(),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanPage()),
          );
        },
        child: Icon(Icons.qr_code_scanner_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  List<Widget> _getLottery() {
    List<Widget> lotteryTextFields = [];
    for (int i = 0; i < lottery.length; i++) {
      lotteryTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: LotteryyTextFiled(i)),
            SizedBox(
              width: 16,
            ),
            _addRemoveButton(i == lottery.length - 1, i),
          ],
        ),
      ));
    }
    return lotteryTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          lottery.insert(0, null);
        } else
          lottery.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class LotteryyTextFiled extends StatefulWidget {
  final int index;
  LotteryyTextFiled(this.index);
  @override
  _LotteryyTextFiledState createState() => _LotteryyTextFiledState();
}

class _LotteryyTextFiledState extends State<LotteryyTextFiled> {
  TextEditingController _lotteryController;

  @override
  void initState() {
    super.initState();
    _lotteryController = TextEditingController();
  }

  @override
  void dispose() {
    _lotteryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _lotteryController.text =
          _FormqrcodescanState.lottery[widget.index] ?? '';
    });

    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(6),
      ],
      style: TextStyle(fontSize: 30),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
          border: OutlineInputBorder(),
          hintText: 'กรอกเลขสลากของคุณ'),
      controller: _lotteryController,
      onChanged: (v) => _FormqrcodescanState.lottery[widget.index] = v,
      validator: (v) {
        if (v.isEmpty) {
          return null;
        } else if (v.trim().length < 5 && v.isNotEmpty)
          return 'กรุณากรอกเลขสลากให้ครบ 6 หลัก';
        return null;
      },
    );
  }
}
