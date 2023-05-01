



import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/PageFirstLoad.dart';
import 'package:abzeno/page_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageBiometricSetting2 extends StatefulWidget {

  @override
  _PageBiometricSetting2 createState() => _PageBiometricSetting2();
}


class _PageBiometricSetting2 extends State<PageBiometricSetting2> {

  String getBiometricSetting = "0";
  bool getFingerscanActive = false;
  String getBiometricPriority = "1";
  var selectedValue = "Passcode";
  bool isSwitched = true;

  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBiometricSetting = value[25];
        getFingerscanActive = value[26];
        getBiometricPriority = value[27];
        if(getBiometricPriority == "" || getBiometricPriority == null) {
          selectedValue = "Passcode";
        } else {
          selectedValue = getBiometricPriority.toString();
        }

        getFingerscanActive == false || getFingerscanActive == null ? isSwitched = false : true;
      });});
  }




  @override
  void initState() {
    super.initState();
    getSettings();
  }


  _action_fitur (String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("biometric_priority", selectedValue.toString());
    preferences.setBool("fingerscan_active", isSwitched);
    //Navigator.pushReplacement(context, ExitPage(page: PageFirstLoad("","")));
    Navigator.pop(context);
    AppHelper().showFlushBarsuccess(context, "Pengaturan berhasil diubah");




  }



  dialog_aktif(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text("UBAH",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _action_fitur("Aktif");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text("Ubah Pengaturan", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Text("Apakah anda yakin untuk mengubah pengaturan ?", style: GoogleFonts.nunitoSans(),textAlign:
      TextAlign.left,),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  dialog_nonaktif(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text("MATIKAN",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _action_fitur("Matikan");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text("Matikan Fitur", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Text("Apakah anda yakin untuk menonaktifkan fitur ini ?", style: GoogleFonts.nunitoSans(),textAlign:
      TextAlign.left,),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Passcode", style: GoogleFonts.nunito(fontSize: 16, color: Colors.black)),value: "Passcode"),
      DropdownMenuItem(child: Text("Fingerscan", style: GoogleFonts.nunito(fontSize: 16, color: Colors.black)),value: "Fingerscan")

    ];
    return menuItems;
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (context) =>
                IconButton(
                    icon: new FaIcon(FontAwesomeIcons.arrowLeft, size: 17,),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
          ),
          title: Text(
            "Fingerscan and Passcode", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.black),),
          elevation: 1,
        ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: 15,left: 15,right: 15),
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(top: 5),
            //   child :     Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text("Security Priority", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14.5),),
            //       DropdownButton(
            //           value: selectedValue,
            //           items: dropdownItems,
            //           onChanged: (String? value) {
            //             setState(() {
            //               selectedValue = value!;
            //             });
            //           },
            //       )
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 6),
              child :     Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Fingerscan", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14.5),),

                  SizedBox(
                    width:65,
                    height: 50,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ),
                  ),


                ],
              ),
            ),

            getBiometricSetting == "0" || getBiometricSetting == null ?
            Padding(
              padding: EdgeInsets.only(top: 25,left: 10,right: 10),
              child :    Container(
                  padding: EdgeInsets.only(top: 8,bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor("#fb8fb1")),
                    color: HexColor("#ffeaef"),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  ListTile(
                    visualDensity: VisualDensity(horizontal: -2),
                    dense : true,
                    leading: FaIcon(FontAwesomeIcons.circleInfo,color:HexColor("#d52f58"),

                    ),
                    title:Text("Aktifkan dahulu fitur Fingerscan and Passcode untuk bisa melakukan pengaturan di modul ini",
                        style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                  )
              )
            ) : Container()

          ],
        ),
    ),
      bottomNavigationBar:
              Container(
                color: Colors.white,
              padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
              width: double.infinity,
              height: 68,
              child :
              getBiometricSetting == "0" || getBiometricSetting == null ?
              Padding(
                padding: EdgeInsets.only(top:10),
                child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#DDDDDD"),
                        elevation: 0,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.white,
                            width: 0.1,
                            style: BorderStyle.solid
                        ),
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    child: Text("Simpan",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                        fontSize: 14),),
                    onPressed: () {
                      //dialog_aktif(context);
                    }
                ),
              ) :
              Padding(
                padding: EdgeInsets.only(top:10),
                child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // primary: HexColor("#00aa5b"),
                        elevation: 0,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.white,
                            width: 0.1,
                            style: BorderStyle.solid
                        ),
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    child: Text("Simpan",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                        fontSize: 14),),
                    onPressed: () {
                      dialog_aktif(context);
                    }
                ),
              )

              ),), onWillPop: onWillPop);
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