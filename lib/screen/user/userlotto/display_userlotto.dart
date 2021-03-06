import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/provider/auth_provider.dart';
import 'package:lotto/screen/user/sumary/purchaseShow.dart';

import 'package:lotto/screen/user/add/userlotteryDetail.dart';
import 'package:lotto/widgets/paddingStyle.dart';
import 'package:lotto/widgets/searchWidget.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import '../add/formshowlotto.dart';

class UserprofileLottery extends StatefulWidget {
  @override
  _UserprofileLotteryState createState() => _UserprofileLotteryState();
}

class _UserprofileLotteryState extends State<UserprofileLottery> {
  final user = FirebaseAuth.instance.currentUser;
  String selectedStatus = "allStatus";
  String selectedReward = "allReward";
  List<dynamic> lottos = [];
  List<String> docID = [];

  String number, query = '';
  bool searchStatus = false, checkstate = false;
  _DisplayScreenState paddingStyle;
  String filterSelect = "";
  String sTypeS = "allStatus";
  String sTypeR = "allReward";

  ScrollController _scrollController =
      new ScrollController(); // set controller on scrolling
  bool _show = true;

  void initiateSearch(String val) {
    setState(() {
      number = val.toLowerCase().trim();
    });
  }

  @override
  void initState() {
    //loadData();

    //

    if (lottos == null) {
      UserNotifier userNotifier = Provider.of(context, listen: false);
      userNotifier.keyCurrentUser.values.toList();
    }
    handleScroll();
    super.initState();
  }

  @override
  void dispose() {
    lottos = [];
    _scrollController.removeListener(() {});
    selectedStatus = "allStatus";
    selectedReward = "allReward";
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  loadData(
      UserNotifier userNotifier, UserSumaryNotifier userSumaryNotifier) async {
    await getUser(userNotifier, user.uid,
        userSumaryNotifier: userSumaryNotifier);

    lottos = userNotifier.keyCurrentUser.values.toList();
    docID = userNotifier.keyCurrentUser.keys.toList();
    checkstate = true;
  }

  void changeIndexfirst(String index) {
    setState(() {
      selectedStatus = index;
    });
  }

  void changeIndexsecon(String index) {
    setState(() {
      selectedReward = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    UserSumaryNotifier userSumaryNotifier =
        Provider.of<UserSumaryNotifier>(context, listen: false);
    docID = userNotifier.keyCurrentUser.keys.toList();

    searchLotto(String query) {
      List<dynamic> allLottos = userNotifier.currentUser;
      //??????????????????????????????
      print("status = $sTypeS");
      print("reward = $sTypeR");
      print("==============================================");
      switch (sTypeS) {
        case "true":
          allLottos = this.lottos.where((lotto) {
            return lotto.state == true;
          }).toList();
          break;
        case "false":
          allLottos = this.lottos.where((lotto) {
            return lotto.state == false;
          }).toList();
          break;
        case "null":
          allLottos = this.lottos.where((lotto) {
            return lotto.state == null;
          }).toList();
          break;
        default:
        //allLottos = this.lottos;
      }
      //?????????????????????????????????
      setState(() {
        checkstate = false;
        switch (sTypeR) {
        case "last2":
          lottos = allLottos.where((lotto) {
            var last2 = lotto.number.substring(4, 6);
            //final lNumber = lotto.number;
            return last2.contains(query);
          }).toList();
          break;
        case "first3":
          lottos = allLottos.where((lotto) {
            var first3 = lotto.number.substring(0, 3);
            //final lNumber = lotto.number;
            return first3.contains(query);
          }).toList();
          break;
        case "last3":
          lottos = allLottos.where((lotto) {
            var last3 = lotto.number.substring(3, 6);
            //final lNumber = lotto.number;
            return last3.contains(query);
          }).toList();
          break;
        default:
          lottos = allLottos.where((lotto) {
            final lNumber = lotto.number;
            return lNumber.contains(query);
          }).toList();
      }
      });
      

      setState(() {
        this.query = query;
        this.lottos = lottos;
      });
    }

    Future<void> _refreshProducts(BuildContext context) async {
      UserNotifier userNotifier = Provider.of(context, listen: false);
      UserSumaryNotifier userSumaryNotifier =
          Provider.of(context, listen: false);
      await loadData(userNotifier, userSumaryNotifier);
    }

    Widget buildSearch() => SearchWidget(
          text: query,
          hintText: '?????????????????????????????????????????????',
          onChanged: searchLotto,
        );
    String getKeyByValue(Map<String, UserData> curr, UserData userData) {
      return curr.keys
          .firstWhere((k) => curr[k] == userData, orElse: () => null);
    }

    Widget buildLotto(UserData lotto, String docID) {
      return ListTile(
        tileColor: Colors.white54,
        leading: lotto.imageurl != null
            ? Image.network(
                lotto.imageurl,
                width: 50,
                height: 50,
                fit: BoxFit.fitWidth,
              )
            : Image.asset(
                'asset/guraLottery.png',
                width: 50,
                fit: BoxFit.fitWidth,
              ), //????????????????????????????????????????????????????????????????????? ??????????????????????????????????????????????????????????????????
        title: Row(
          children: [
            Text(
              lotto.number,
              style: TextStyle(color: Colors.indigo),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Text(
                "${numToWord(lotto.date)}",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.6),
                child: lotto.state == true
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.lightGreenAccent,
                      )
                    : lotto.state == false
                        ? Icon(
                            Icons.cancel,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.hourglass_bottom,
                            color: Color(0xFFB3B7C0),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "???????????? ",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Mitr")),
                      TextSpan(
                          text: lotto.lotteryprice,
                          style: TextStyle(
                              color: Colors.orange, fontFamily: "Mitr")),
                      TextSpan(
                          text: " ?????????",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Mitr")),
                    ])),
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "  ??????????????? ",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Mitr")),
                      TextSpan(
                          text: lotto.amount,
                          style: TextStyle(
                              color: Colors.orange, fontFamily: "Mitr")),
                      TextSpan(
                          text: " ??????",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Mitr"))
                    ])),
                    Spacer(),
                  ],
                ),
              ),
            ]),
          ],
        ),
        onTap: () async {
          //?????????????????????????????????????????????????????????
          String docid = docID;
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Formshowdetaillotto(
                    userID: userNotifier.keyCurrentUser[docid].userid,
                    docid: docid)),
          );
          setState(() {
            checkstate = result;
          });
        },
        onLongPress: () async {
          await confirmDialog(context, docID, lotto.imageurl, user.uid);
          setState(() {
            checkstate = false;
          });
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Color(0xFFF3FFFE),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.photoURL),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              user.displayName,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme().apply(bodyColor: Colors.white),
            ),
            child: PopupMenuButton<int>(
              color: Colors.white,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        Text('Sign Out',
                            style: TextStyle(
                                color: Colors.black, fontFamily: "Mitr")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: checkstate == true
              ? searchLotto(query)
              : loadData(userNotifier, userSumaryNotifier),
          builder: (context, AsyncSnapshot snapshot) {
            if (userNotifier.currentUser.isEmpty) {
              return Center(
                child: Text("????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????",
                    style: TextStyle(fontSize: 18)),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.83),
                        child: buildSearch()),
                    Container(
                        constraints: BoxConstraints(maxHeight: 42,maxWidth: 50),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.amberAccent,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                     
                        child: TextButton(
                          
                          child: Icon(
                            FontAwesomeIcons.alignJustify,
                            color: Colors.black87,
                            size: 20,
                          ),
                          onPressed: () {
                            _lotteryEditModalBottomSheet(context);
                          },
                        )) //_lotteryEditModalBottomSheet(context)))
                  ],
                ),
                Expanded(
                  child: Container(
                      constraints: BoxConstraints(
                        minHeight: 3000,
                        // maxHeight: 200, //minimum height
                      ),
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          ...lottos.map((e) {
                            UserData lotto = e;
                            return frameWidget(buildLotto(lotto,
                                getKeyByValue(userNotifier.keyCurrentUser, e)));
                          }).toList(),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      )),
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: Visibility(
        visible: _show,
        child: Column(
          children: [
            Spacer(),
            userNotifier.currentUser.isNotEmpty
                ? FloatingActionButton.extended(
                    heroTag: "sumary",
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      List<String> date1 = [];
                      userNotifier.currentUser.forEach((element) {
                        date1.add(element.date);
                      });
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowPurchaseReport(
                                  dateUser: date1.toSet().toList(),
                                )
                            //ShowPurchaseReport(dateUser: date1.toSet().toList())
                            ),
                      );
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Icon(Icons.feed),
                    ),
                    label: const Text(
                      '??????????????????',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Color(0xFF6390E9),
                  )
                : SizedBox(),
            SizedBox(
              height: 7,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: FloatingActionButton.extended(
                heroTag: "add",
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Formshowlotto()),
                  );
                  setState(() {
                    checkstate = result;
                  });
                },
                icon: Icon(Icons.add),
                label: const Text(
                  '?????????????????????????????????',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.amber,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  void _lotteryEditModalBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFF3FFFE),
      
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.58,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: Row(
                      children: [
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              selectedReward = sTypeR ;
                              selectedStatus = sTypeS;
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.indigo,
                              size: 25,
                            ))
                      ],
                    ),
                  ),
                  textcutom("???????????????"),
                  SizedBox(
                    height: 5,
                  ),
                  Wrap(
                    spacing: 20,
                    children: [
                      filterOption(mystate, "?????????????????????", "allStatus"),
                      filterOption(mystate, "???????????????????????????", "true"),
                      filterOption(mystate, "????????????????????????????????????", "false"),
                      filterOption(mystate, "??????????????????????????????", "null"),
                    ],
                  ),
                  textcutom("??????????????????"),
                  Wrap(
                    spacing: 20,
                    children: [
                      filterOptionByReward(mystate, "?????????????????????", "allReward"),
                      filterOptionByReward(mystate, "???????????????????????????????????????", "last2"),
                      filterOptionByReward(mystate, "???????????????????????????????????????", "first3"),
                      filterOptionByReward(mystate, "???????????????????????????????????????", "last3"),
                    ],
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      FloatingActionButton.extended(
                        onPressed: () {
                          mystate(() {
                            changeIndexfirst("allStatus");
                            changeIndexsecon("allReward");
                          });
                        },
                        label: const Text(
                          '????????????',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: Color(0xFFB3B7C0),
                      ),
                      Spacer(),
                      FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            // checkstate = false;
                            sTypeR = selectedReward;
                            sTypeS = selectedStatus;
                          });

                          Navigator.pop(context);
                        },
                        label: const Text(
                          '????????????',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: Colors.amberAccent,
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

  OutlinedButton filterOptionByReward(
      StateSetter mystate, String name, String i) {
    return OutlinedButton(
      onPressed: () {
        mystate(() {
          changeIndexsecon(i);
        });
      },
      child: Container(
        width: 120,
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline_outlined,
              color: selectedReward == i ? Colors.white : Colors.white10,
              size: 20,
            ),
            Text(
              name,
              style: TextStyle(
                  color: selectedReward == i ? Colors.white : Colors.black87),
            ),
          ],
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor:selectedReward == i ? Color(0xFF6390E9) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        side: BorderSide(
        
            width: 2,
            color: selectedReward == i ? Colors.indigo : Colors.black54),
      ),
    );
  }

  OutlinedButton filterOption(StateSetter mystate, String name, String i) {
    return OutlinedButton(
      onPressed: () {
        mystate(() {
          changeIndexfirst(i);
        });
      },
      child: Container(
        width: 120,
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline_outlined,
              color: selectedStatus == i ? Colors.white : Colors.white10,
              size: 20,
            ),
            Text(
              name,
              style: TextStyle(
                  color: selectedStatus == i ? Colors.white : Colors.black87),
            ),
          ],
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor:selectedStatus == i ? Color(0xFF6390E9) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        side: BorderSide(
            width: 2,
            color: selectedStatus == i ? Colors.indigo : Colors.black54),
      ),
    );
  }

  Widget textcutom(String data) {
    return Text(
      data,
      style: TextStyle(color: Colors.black87, fontSize: 20),
    );
  }
}

class _DisplayScreenState {}

Future<Null> confirmDialog(
    BuildContext context, String documentId, String imageurl, String userID) {
  return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('??????????????????????????????????????????????????????????????????????????????'),
          actions: <Widget>[
            new TextButton(
              child: Container(
                width: 60.0,
                child: Text('????????????????????????',
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
                if (imageurl != null) {
                  deleteImage(imageurl);
                }
                await FirebaseFirestore.instance
                    .collection('userlottery')
                    .doc(documentId)
                    .delete();
              },
            ),
            SizedBox(
              width: 20,
            ),
            new TextButton(
              child: Container(
                width: 60.0,
                child: Text('??????????????????',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        backgroundColor: Colors.white70)),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

Future<void> deleteImage(String imageFileUrl) async {
  var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
      .replaceAll(new RegExp(r'(\?alt).*'), '');

  final firebase_storage.Reference firebaseStorageRef =
      firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
  await firebaseStorageRef.delete();
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      AuthClass().signOut();
  }
}
