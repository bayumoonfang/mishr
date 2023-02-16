


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_detailnotification.dart';
import 'package:abzeno/Time%20Off/S_HELPER/g_timeoff.dart';
import 'package:abzeno/helper/app_helper.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'S_HELPER/g_myteam.dart';

class PageMyTeam extends StatefulWidget{
  final String getkaryawanNo;
  const PageMyTeam(this.getkaryawanNo);
  @override
  _PageMyTeam createState() => _PageMyTeam();
}


class _PageMyTeam extends State<PageMyTeam> {



  String filter = "";
  Future<List> getData() async {
    return g_myteam().getData_MyTeam(widget.getkaryawanNo);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_myteam().getData_MyTeam(widget.getkaryawanNo);
    });
  }


  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }






  @override
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        //shape: Border(bottom: BorderSide(color: Colors.red)),
        // backgroundColor: HexColor("#3a5664"),
        title: Text("My Team", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.black,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),

      ),
      body: RefreshIndicator(
          onRefresh: getData,
          child : Container(
              padding: EdgeInsets.only(left: 15,right: 15,top: 10),
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child : Column(
                children: [

                  Expanded(
                      child: FutureBuilder(
                        future: g_myteam().getData_MyTeam(widget.getkaryawanNo),
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
                                        Image.asset('assets/empty2.png',width: 150,),
                                        Padding(
                                          padding: EdgeInsets.only(left: 13),
                                          child:  new Text(
                                            getBahasa.toString() == "1" ? "Tidak ada data": "Data Not Found",
                                            style: new TextStyle(
                                                fontFamily: 'VarelaRound', fontSize: 13),
                                          ),
                                        )
                                      ],
                                    )))
                                :
                            Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemExtent: 85,
                                    itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                    padding: const EdgeInsets.only(bottom: 85),
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          Container(
                                          padding: const EdgeInsets.only(top: 10),
                                            child : ListTile(
                                              visualDensity: VisualDensity(vertical: -2),
                                              dense : true,
                                              leading: Container(
                                                width: 35,
                                                height: 35,
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: HexColor("#DDDDDD"), width: 1,)
                                                ),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: AssetImage(
                                                      'assets/user.png'),
                                                ),),
                                              title:Text(snapshot.data![i]["a"].toString(),  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,fontSize: 14.5),),
                                              subtitle: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5),
                                                    child:  Align(alignment: Alignment.centerLeft,
                                                        child:  Text(snapshot.data![i]["c"].toString(),
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.workSans(fontSize: 13,color: Colors.black))),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5),
                                                    child:  Align(alignment: Alignment.centerLeft,
                                                        child:  Text(snapshot.data![i]["b"].toString(),
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.workSans(fontSize: 13,color: Colors.black))),
                                                  ),
                                                ],
                                              ),

                                            ),
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:5),child:
                                          Divider(height: 4,),),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                              ],
                            );

                          }
                        },
                      )
                  ),
                  SizedBox(height: 15,)
                ],
              )
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