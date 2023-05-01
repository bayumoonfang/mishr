


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/g_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_detailnotification.dart';
import 'package:abzeno/helper/app_helper.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Time Off/S_HELPER/g_timeoff.dart';
import 'S_HELPER/m_notification.dart';
class PageNotification extends StatefulWidget{
  final String getEmail;
  final String getModul;
  final Function runLoopMe;
  const PageNotification(this.getEmail, this.getModul, this.runLoopMe);
  @override
  _PageNotification createState() => _PageNotification();
}


class _PageNotification extends State<PageNotification> {



  String filter = "";
  Future getData() async {
    setState(() {
      g_timeoff().getData_NotificationSpecific(widget.getEmail, filter, widget.getModul);
      widget.runLoopMe();
    });
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_timeoff().getData_NotificationSpecific(widget.getEmail, filter, widget.getModul);
      widget.runLoopMe();
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
    EasyLoading.show(status: AppHelper().loading_text);
    await m_notification().notification_readall(widget.getEmail).then((value){
      if(value[0] == 'ConnInterupted'){
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...");
        return false;
      } else {
        setState(() {
          g_timeoff().getData_NotificationSpecific(widget.getEmail, filter, widget.getModul);
          widget.runLoopMe();
        });
      }
    });
    //Navigator.pop(context);
  }






  showDialogAllRead(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 150,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"?  "MARK ALL READ":"APPROVE"
          ,style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          Navigator.pop(context);
          _read_allnotif();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Tandai Semua Dibaca" :"Approve Request"
        , style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
        TextAlign.left,),
      content: Text("Apakah anda yakin menandai semua telah dibaca ? "
        , style: GoogleFonts.nunitoSans(),textAlign:
        TextAlign.left,),
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
    final textScale = MediaQuery.of(context).textScaleFactor;
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
              hintText: getBahasa.toString() == "1"? 'Cari Notifikasi...' : 'Search Notification...',
            ),
          ),
        ),automaticallyImplyLeading: false,elevation: 0,
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
                                child: const SpinKitThreeBounce(
                                  size: 30,
                                  color: Colors.indigo,
                                ),
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
                                            getBahasa.toString() == "1" ? "Tidak ada data": "No Data",
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
                                    itemExtent: textScale.toString() == '1.17' ? 95:89,
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
                                              badges.Badge(
                                                showBadge: true,
                                                position: badges.BadgePosition.topStart(top: -2,start: -5),
                                                badgeAnimation: badges.BadgeAnimation.scale (
                                                  animationDuration: Duration(seconds: 1),
                                                  loopAnimation: false,
                                                ),
                                                badgeStyle: badges.BadgeStyle(
                                                  shape: badges.BadgeShape.circle,
                                                  badgeColor: Colors.red,
                                                  padding: EdgeInsets.all(5),
                                                  elevation: 0,
                                                ),
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
                                                                fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black))),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5),
                                                    child:  Align(alignment: Alignment.centerLeft,
                                                      child: Text(snapshot.data![i]["c"].toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.workSans(fontSize: 12,color: Colors.black)),),
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
                                          Padding(padding: const EdgeInsets.only(top:10)),
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
     // Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

}