


import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'S_HELPER/m_profile.dart';

class ChangePIN extends StatefulWidget{
  final String getKaryawanNo;
  const ChangePIN(this.getKaryawanNo);
  @override
  _ChangePIN createState() => _ChangePIN();
}


class _ChangePIN extends State<ChangePIN> {

  TextEditingController _pinValue = TextEditingController();
  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }

  void initState() {
    super.initState();
    getSettings();
  }



  _changePIN() async {

    EasyLoading.show(status: AppHelper().loading_text);
    await m_profile().change_pin(widget.getKaryawanNo, _pinValue.text).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          if(value[0] != '') {
            if(value[0] == '1') {
              Navigator.pop(context);
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                AppHelper().showFlushBarconfirmed(context, getBahasa.toString() == "1" ? "PIN berhasil dganti":"PIN has been changed");
              });
            } else {
              AppHelper().showFlushBarsuccess(context, value[0]);
              return;
            }
          }
        });
      }
    });

  }



  showDialogme(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if(_pinValue.text == "") {
      AppHelper().showFlushBarsuccess(context, getBahasa.toString() == "1" ? "PIN tidak boleh kosong" : "PIN cannot be empty");
      return false;
    }
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: GoogleFonts.lexendDeca(color: Colors.black),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        style: ElevatedButton.styleFrom(
            primary: HexColor("#1a76d2"),
            elevation: 0,
            shape: RoundedRectangleBorder(side: BorderSide(
                color: Colors.white,
                width: 0.1,
                style: BorderStyle.solid
            ),
              borderRadius: BorderRadius.circular(5.0),
            )),
        child: Text(getBahasa.toString() == "1" ? "Iya":"Yes",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold),),
        onPressed:  () {
          Navigator.pop(context);
          _changePIN();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1" ?  "Ubah PIN": "Change PIN", style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),textAlign:
      TextAlign.center,),
      content: Text(getBahasa.toString() == "1" ? "Apakah anda yakin untuk mengubah PIN anda ? ": "Would you like to continue to change PIN ?", style: GoogleFonts.varelaRound(),textAlign:
      TextAlign.center,),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1" ? "Ubah PIN" :"Change PIN", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        leading: Builder(
          builder: (context) =>
              IconButton(
                  icon: new FaIcon(FontAwesomeIcons.arrowLeft, size: 17,),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.only(left: 25,right: 25,top: 30),
        child: TextFormField(
          style: GoogleFonts.nunito(fontSize: 16),
          textCapitalization: TextCapitalization
              .sentences,
          controller: _pinValue,
          maxLength: 6,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 2),
            hintText: getBahasa.toString() == "1" ? 'Masukkan PIN anda':'Enter your PIN',
            labelText: getBahasa.toString() == "1" ? 'PIN anda':'Enter PIN',
            labelStyle: TextStyle(
                fontFamily: "VarelaRound",
                fontSize: 16.5, color: Colors.black87
            ),
            floatingLabelBehavior: FloatingLabelBehavior
                .always,
            hintStyle: GoogleFonts.nunito(
                color: HexColor("#c4c4c4"), fontSize: 15),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: HexColor("#DDDDDD")),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: HexColor("#8c8989")),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: HexColor("#DDDDDD")),
            ),
          ),
          enableInteractiveSelection: false,
        ),
      ),
        bottomSheet: Container(
            padding: EdgeInsets.only(left: 45, right: 45, bottom: 10),
            width: double.infinity,
            height: 58,
            child:
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: HexColor("#00aa5b"),
                    elevation: 0,
                    shape: RoundedRectangleBorder(side: BorderSide(
                        color: Colors.white,
                        width: 0.1,
                        style: BorderStyle.solid
                    ),
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                child: Text(getBahasa.toString() == "1" ? "Simpan":"Save",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                    fontSize: 14),),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  if(_pinValue.text.length < 6) {
                    getBahasa.toString() == "1"?
                    AppHelper().showFlushBarsuccess(context, "PIN tidak boleh kurang dari 6 character") :
                    AppHelper().showFlushBarsuccess(context, "PIN cannot be less than 6 characters");
                    return;
                  } else {
                    showDialogme(context);
                  }

                }
            )
        ),
    ), onWillPop: onWillPop);
  }


  Future<bool> onWillPop() async {
    try {
      Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }


}