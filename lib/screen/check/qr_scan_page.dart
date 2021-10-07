import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lotto/model/PrizeData.dart';
import 'package:lotto/model/checkNumber.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/screen/check/displaycheck.dart';
import 'package:lotto/screen/check/showResultCheck.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  final bool wantToCheck;
  final PrizeNotifier prizeNotifier;
  QRScanPage({@required this.wantToCheck, this.prizeNotifier});
  @override
  _QRScanPageState createState() =>
      _QRScanPageState(wantToCheck, prizeNotifier);
}

class _QRScanPageState extends State<QRScanPage> {
  final bool _wantToCheck;
  final PrizeNotifier prizeNotifier;
  _QRScanPageState(this._wantToCheck, this.prizeNotifier);
  final qrkey = GlobalKey(debugLabel: 'QR');

  Barcode barcode;
  QRViewController controller;
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getDateAndNumber(""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //PrizeNotifier prizeNotifier = Provider.of<PrizeNotifier>(context,listen: false);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Scan QR CodeScan QR Code",
            style: TextStyle(color: Colors.black),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          backgroundColor: Colors.white.withOpacity(0.1),
          elevation: 0,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            Positioned(bottom: 10, child: buildResult()),
            Positioned(right: 10, child: buildControlButtons()),
          ],
        ),
      ),
    );
  }

  Widget buildControlButtons() => Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: FutureBuilder<bool>(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Icon(snapshot.data ? Icons.flash_on : Icons.flash_off);
                } else {
                  return Container();
                }
              },
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
          )
        ],
      ));

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white24),
        child: Text(
          barcode != null ? "result :${barcode.code}" : "สแกน 2D barcode สลาก",
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrkey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderWidth: 10,
            borderLength: 20,
            borderRadius: 10,
            borderColor: Theme.of(context).colorScheme.secondary,
            cutOutSize: MediaQuery.of(context).size.width * 0.5),
      );
  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((barcode) {
      setState(() => this.barcode = barcode);
      getDateAndNumber(barcode.code.toString());
      //var data = barcode.code;
    });
  }

  bool _popBack = false;
  bool _popup = false;
  getDateAndNumber(String barcode) {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
    List<String> data = barcode.split('-');
    print(data);
    if (data.length == 4) {
      String number = data[3];
      String date = '25' + data[0] + data[1] + data[2];
      print(date);
      print(number);
      // int times = int.parse(data[1]); //งวด
      // int index = (times / 2).ceil();
      int peroid = 37; //int.parse(data[1]);
      print(peroid);
      //แสกนแล้วตรวจ
      if (_wantToCheck) {
        print("แสกนตรวจ");
        List<PrizeData> _prizeData = prizeNotifier.prizeList.values
            .where((element) => element.period.contains(peroid))
            .toList();
        if (_prizeData[0].data['first'].number[0].value == '') {
          if (_popup == false) {
            showDialog<Null>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: Center(
                        child: Text(
                      'กำลังออกรางวัลงวดนี้ โปรดรอสักครู่',
                      style: TextStyle(color: Colors.redAccent),
                    )),
                    actions: <Widget>[
                      Center(
                        child: new TextButton(
                          child: Text(
                            'ตกลง',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            bool status = await controller.getFlashStatus();
                            print(status);
                            if (status == true) {
                              controller?.toggleFlash();
                            }
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2)
                            ;
                          },
                        ),
                      ),
                    ],
                  );
                });
            _popup = true;
          }
        } else {
          var check = new CheckNumber(
              userNum: [number],
              peroid: peroid,
              prizeNotifier: this.prizeNotifier);
          print(check.getCheckedData());
          setState(() {
            if (_popBack != true) {
              _popBack = true;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowResultCheck(
                          allResult: check.getCheckedData(),
                          length: check.getLength())));
            }
          });
        }
      }
      //แสกนแล้วคืนค่า
      else {
        print("แสกน แต่ไม่ตรวจ");
        QRCodeData qrCodeData = QRCodeData(number: number, peroid: peroid);
        print("หลังแสกน ${qrCodeData.number}");
        //print(userNotifier.qrcodeData.number);
        setState(() {
          if (_popBack != true) {
            _popBack = true;
            Navigator.pop(context, qrCodeData);
          }
        });
      }
    }
  }
}

class QRCodeData {
  String number;
  int peroid;

  QRCodeData({this.number, this.peroid});
}
