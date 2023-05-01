

import 'dart:io';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/local_auth_service.dart';
import 'package:abzeno/page_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import 'Helper/page_route.dart';

class PageAuth extends StatefulWidget{
  final String getTokenMe;
  final String getPIN;
  const PageAuth(this.getTokenMe, this.getPIN);
  @override
  _PageAuth createState() => _PageAuth();
}



class _PageAuth extends State<PageAuth> {
  bool authenticated = false;
  String getBiometricSetting = "0";
  bool getFingerscanActive = false;
  String getBiometricPriority = "1";
  var selectedValue = "Fingerscan";
  bool isSwitched = true;
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() async {
        getBiometricSetting = value[25];
        getFingerscanActive = value[26];
        getBiometricPriority = value[27];
        // selectedValue = getBiometricPriority;
        getFingerscanActive == "0" || getFingerscanActive == null ? isSwitched = false : true;
      });});
  }


  @override
  void initState() {
    super.initState();
    getSettings();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
    Container(
      width: double.infinity,
      height: double.infinity,

      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage("assets/backpin2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: ScreenLock(
        correctString: widget.getPIN.toString(),
        title: Text('Please enter your PIN'),
        //onCancelled: Navigator.of(context).pop,
        customizedButtonChild: getFingerscanActive == true ? Icon(Icons.fingerprint,size: 40,) : Container(),
        onUnlocked: () {
          Navigator.pushReplacement(context, ExitPage(page: PageCheck("",widget.getTokenMe)));
        },
        customizedButtonTap: () async {
          final authenticate = await LocalAuth.authenticate(getFingerscanActive, getBiometricPriority);
          setState(() {
            authenticated = authenticate;
            if(authenticate) {
              Navigator.pushReplacement(context, ExitPage(page: PageCheck("",widget.getTokenMe)));
            }
          });
        },
        // onOpened: () async {
        //   final authenticate = await LocalAuth.authenticate(getFingerscanActive, getBiometricPriority);
        //   authenticated = authenticate;
        // },
        footer: Container(
          width: double.infinity,
          height: 68,
          padding: const EdgeInsets.only(top: 10),
          child: OutlinedButton(
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text('Enter correct pin to enter misHR'),
            ),
            onPressed: () => {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
          ),
        ),

      ),
    ), onWillPop: onWillPop);
  }

  bool shouldPop = true;
  DateTime BackPressTime = DateTime.now();
  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if(now.difference(BackPressTime)< Duration(seconds: 2)){
      exit(0);
      return Future(() => true);
    }
    else{
      BackPressTime = DateTime.now();
      Fluttertoast.showToast(msg: 'Tap 2x untuk keluar aplikasi');
      return Future(()=> false);
    }
  }


}
