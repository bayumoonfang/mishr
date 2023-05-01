



import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/g_helper.dart';
import 'package:abzeno/Helper/m_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:unicons/unicons.dart';


class ChangeBahasa extends StatefulWidget{
  final String getEmail;
  const ChangeBahasa(this.getEmail);
  @override
  _ChangeBahasa createState() => _ChangeBahasa();
}



class _ChangeBahasa extends State<ChangeBahasa> {

  late List data;


  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }



  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      getBahasa.toString() == "1"?
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
      AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
      EasyLoading.dismiss();
      return false;
    }});
  }

  @override
  void initState() {
    super.initState();
    getSettings();
    _startingVariable();
  }


  _change_bahasa(getBahasaID) async {
    await m_helper().change_bahasa(getBahasaID, widget.getEmail ).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          if(value[0] != '') {
            if(value[0] == '1') {
              setState(() {
                Navigator.pop(context);
                AppHelper().cekSettings();
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  AppHelper().showFlushBarconfirmed(context, "Bahasa has been changed, please reopen application to better result");
                });
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



  String filter = "";
  Future<List> getData() async {
    return g_helper().getData_AllBahasa();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        // backgroundColor: HexColor("#3a5664"),
        title: Text(
          getBahasa.toString() == "1"? "Ubah Bahasa" : "Change Language",
          style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black,),),
        backgroundColor: Colors.white,
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
      body: RefreshIndicator(
          onRefresh: getData,
          child :
          Container(
            child: Column(
              children: [


                Padding(padding: const EdgeInsets.only(top: 10),),
                Expanded(
                    child: FutureBuilder(
                      future: g_helper().getData_AllBahasa(),
                      builder: (context, snapshot){
                        if (snapshot.data == null) {
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        } else {
                          return snapshot.data == 0 || snapshot.data?.length == 0 ?
                          Container(
                              height: double.infinity, width : double.infinity,
                              child: new
                              Center(
                                  child :
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        "Data tidak ditemukan",
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 18),
                                      ),
                                      new Text(
                                        "Mohon hubungi HRD terkait hal ini",
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 12),
                                      ),
                                    ],
                                  )))
                              :
                          ListView.builder(
                            itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                            padding: const EdgeInsets.only(left: 10,right: 15),
                            itemBuilder: (context, i) {
                              return Column(
                                children: [
                                  InkWell(
                                    child : ListTile(
                                      leading: Icon(UniconsLine.mobile_android,),
                                      title: Row(
                                        children: [
                                          Padding(padding: const EdgeInsets.only(right: 5),child:
                                          Text(snapshot.data![i]["b"].toString(), style: GoogleFonts.nunito(fontSize: 15),),),
                                        ],
                                      ),
                                    ),
                                    onTap: (){
                                      EasyLoading.show(status: "Loading...");
                                      _change_bahasa(snapshot.data![i]["a"].toString());
                                    },
                                  ),
                                  Padding(padding: const EdgeInsets.only(top: 0),child:
                                  Divider(height: 4,),)
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                ),

              ],
            ),
          )),
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