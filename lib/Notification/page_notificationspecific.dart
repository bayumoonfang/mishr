


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

import 'S_HELPER/m_notification.dart';
class PageSpecificNotification extends StatefulWidget{
  final String getEmail;
  final String getModul;
  const PageSpecificNotification(this.getEmail, this.getModul);
  @override
  _PageSpecificNotification createState() => _PageSpecificNotification();
}


class _PageSpecificNotification extends State<PageSpecificNotification> {



  String filter = "";
  Future<List> getData() async {
    return g_timeoff().getData_NotificationSpecific(widget.getEmail, filter, widget.getModul);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_timeoff().getData_NotificationSpecific(widget.getEmail, filter, widget.getModul);
    });
  }


  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }




  _read_allnotif() async {
    EasyLoading.show(status: "Loading...");
    await m_notification().notificationspecific_readall(widget.getEmail, widget.getModul).then((value){
      if(value[0] == 'ConnInterupted'){
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...");
        return false;
      } else {
        setState(() {
          g_timeoff().getData_NotificationSpecific(widget.getEmail, filter, widget.getModul);
        });
      }
    });
    //Navigator.pop(context);
  }



  showDialogAllRead(BuildContext context) {
    //FocusScope.of(context).requestFocus(FocusNode());
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
        child: Text(getBahasa.toString() == "1"? "Iya": "Yes",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold),),
        onPressed:  () {
          Navigator.pop(context);
          _read_allnotif();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Tandai Semua Dibaca": "Mark All As Read", style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),textAlign:
      TextAlign.center,),
      content: Text(getBahasa.toString() == "1"? "Apakah anda yakin menandai semua dibaca ?": "Would you like to continue mark all as read ?", style: GoogleFonts.varelaRound(),textAlign:
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
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          height: 40,
          child: TextFormField(
            enableInteractiveSelection: false,
            onChanged: (text) {
              setState(() {
                filter = text;
              });
            },
            style: GoogleFonts.nunito(fontSize: 15),
            decoration: new InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              fillColor: HexColor("#f4f4f4"),
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.search,size: 18,color: HexColor("#6c767f"),),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0,),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#f4f4f4"), width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              hintText: getBahasa.toString() == "1"? 'Cari Aktifitas...' : 'Search Activity...',
            ),
          ),
        ),elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.black,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),
        actions: [
          Padding(padding: EdgeInsets.only(right: 10,top: 4),
            child: TextButton(
              child: Text(getBahasa.toString() == "1"? "Tandai Semua Dibaca": "Mark All As Read",overflow: TextOverflow.ellipsis, style: GoogleFonts.workSans(
                  fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
              onPressed: (){
                showDialogAllRead(context);
              },
            ),)
        ],
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
                        future: g_timeoff().getData_NotificationSpecific(widget.getEmail, filter, widget.getModul),
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
                                        Image.asset('assets/empty2.png',width: 170,),
                                        Padding(
                                          padding: EdgeInsets.only(left: 13),
                                          child:  new Text(
                                            getBahasa.toString() == "1" ? "Data Tidak Ditemukan": "Data Not Found",
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
                                    itemExtent: 92,
                                    itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                    padding: const EdgeInsets.only(bottom: 85),
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            child : ListTile(
                                              visualDensity: VisualDensity(vertical: -2),
                                              dense : true,
                                              title:
                                              snapshot.data![i]["f"].toString() == "0" ?
                                              Badge(
                                                showBadge: true,
                                                position: BadgePosition.topStart(top: -2,start: -5),
                                                animationType:  BadgeAnimationType.scale,
                                                shape: BadgeShape.circle,
                                                child: Container(
                                                  width: double.infinity,
                                                  padding : EdgeInsets.all(6),
                                                  child: Text(AppHelper().getTanggalCustom(snapshot.data![i]["e"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFull(snapshot.data![i]["e"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["e"].toString()),
                                                      style: GoogleFonts.workSans(fontSize: 12,color: Colors.black)),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: HexColor("#EDEDED"),
                                                  ),
                                                ),
                                              ) : Container(
                                                width: double.infinity,
                                                padding : EdgeInsets.all(6),
                                                child: Text(AppHelper().getTanggalCustom(snapshot.data![i]["e"].toString()) + " "+
                                                    AppHelper().getNamaBulanCustomFull(snapshot.data![i]["e"].toString()) + " "+
                                                    AppHelper().getTahunCustom(snapshot.data![i]["e"].toString()),
                                                    style: GoogleFonts.workSans(fontSize: 12,color: Colors.black)),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: HexColor("#EDEDED"),
                                                ),
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5),
                                                    child:  Align(alignment: Alignment.centerLeft,
                                                        child:  Text(snapshot.data![i]["b"].toString(),
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black))),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5),
                                                    child:  Align(alignment: Alignment.centerLeft,
                                                      child: Text(snapshot.data![i]["c"].toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),),
                                                  )
                                                ],
                                              ),

                                            ),
                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              Navigator.push(context, ExitPage(page: PageDetailNotification(snapshot.data![i]["b"].toString(),
                                                  snapshot.data![i]["c"].toString(),
                                                  AppHelper().getTanggalCustom(snapshot.data![i]["e"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFull(snapshot.data![i]["e"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["e"].toString()),
                                                  snapshot.data![i]["g"].toString()))).then(onGoBack);

                                            },
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:15)),
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