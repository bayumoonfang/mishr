

import 'dart:async';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Inbox/page_pesanpribadi_detail.dart';
import 'package:abzeno/Profile/page_attendancehistory.dart';
import 'package:abzeno/Setting/page_bahasa.dart';
import 'package:abzeno/Setting/page_notification.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'S_HELPER/g_inbox.dart';


class PagePesanPribadi extends StatefulWidget{
  final String getKaryawanNo;
  final Function runLoopMe;
  const PagePesanPribadi(this.getKaryawanNo, this.runLoopMe);
  @override
  _PagePesanPribadi createState() => _PagePesanPribadi();
}


class _PagePesanPribadi extends State<PagePesanPribadi> {



  String filter = "";
  String filter2 = "";
  Future<bool> onWillPop() async {
    try {
      Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
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

  Future getData() async {
    setState(() {
      g_inbox().getData_PesanPribadi(widget.getKaryawanNo, filter, filter2);
    });
  }



  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_inbox().getData_PesanPribadi(widget.getKaryawanNo, filter, filter2);
      widget.runLoopMe();
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
                  hintText: getBahasa.toString() == "1"? 'Cari Pesan...' : 'Search Message...',
                ),
              ),
            ),automaticallyImplyLeading: false,elevation: 0,
          ),
        body: Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 5,left: 5,right: 15),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top: 5,bottom: 5,left: 10),
                    height: 42,
                    width: double.infinity,
                    child: ListView (
                                  scrollDirection: Axis.horizontal,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: OutlinedButton(child: Text(getBahasa.toString() == "1" ?"Semua Pesan" :
                                            "All Message",
                                            style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                                            style: OutlinedButton.styleFrom(
                                              shape: StadiumBorder(),
                                              side: BorderSide(width: 1, color: HexColor("#6b727c")),
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                filter2 = "";
                                              });
                                              //AppHelper().showFlushBarconfirmed(context, filter2);
                                            },)
                                      ),

                                      Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: OutlinedButton(child: Text(getBahasa.toString() == "1" ? "Sudah Dibaca" : "Already Read",
                                            style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                                            style: OutlinedButton.styleFrom(
                                              shape: StadiumBorder(),
                                              side: BorderSide(width: 1, color: HexColor("#6b727c")),
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                filter2 = "1";
                                              });
                                              //AppHelper().showFlushBarconfirmed(context, filter2);
                                            },)
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: OutlinedButton(child: Text(getBahasa.toString() == "1" ? "Belum Dibaca" : "Unread",
                                            style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                                            style: OutlinedButton.styleFrom(
                                              shape: StadiumBorder(),
                                              side: BorderSide(width: 1, color: HexColor("#6b727c")),
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                filter2 = "0";
                                              });
                                              //AppHelper().showFlushBarconfirmed(context, filter2);
                                            },)
                                      )
                                    ],

                              )
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: getData,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                      child: FutureBuilder(
                        future: g_inbox().getData_PesanPribadi(widget.getKaryawanNo, filter, filter2),
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
                                        itemExtent: 102,
                                        itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                        padding: const EdgeInsets.only(bottom: 85,top: 5),
                                        itemBuilder: (context, i) {
                                            return Column(
                                              children: [
                                                 InkWell(
                                                   child: ListTile(
                                                     leading:
                                            snapshot.data![i]["l"].toString() == "0" ?
                                                Badge(
                                                  showBadge: true,
                                                  badgeAnimation: BadgeAnimation.scale (
                                                    animationDuration: Duration(seconds: 1),
                                                    loopAnimation: false,
                                                  ),
                                                  badgeStyle: BadgeStyle(
                                                    shape: BadgeShape.circle,
                                                    badgeColor: Colors.red,
                                                    padding: EdgeInsets.all(5),
                                                    elevation: 0,
                                                  ),
                                                  position: BadgePosition.topStart(top: -2,start: -3),
                                                  child: Container(
                                                    width: 35,height: 35,
                                                    decoration: new BoxDecoration(
                                                      color: HexColor("#000000"),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          snapshot.data![i]["c"].toString().substring(0,1),
                                                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),
                                                          textAlign: TextAlign.center ),
                                                    ),
                                                  ),
                                                )

                                                :
                                                     Container(
                                                       width: 35,height: 35,
                                                       decoration: new BoxDecoration(
                                                         color: HexColor("#000000"),
                                                         shape: BoxShape.circle,
                                                       ),
                                                       child: Center(
                                                         child: Text(
                                                           snapshot.data![i]["c"].toString().substring(0,1),
                                                           style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),
                                                           textAlign: TextAlign.center ),
                                                       ),
                                                     ),
                                                     title: Column(
                                                       children: [
                                                         Opacity(opacity: 0.7,child: Align(
                                                           alignment: Alignment.centerLeft,
                                                           child: Text(
                                                               snapshot.data![i]["c"].toString()+" - "+snapshot.data![i]["g"].toString(),
                                                               overflow: TextOverflow.ellipsis, style: GoogleFonts.nunito(color: Colors.black,fontSize: 12)),
                                                         ),),
                                                         Padding(padding: EdgeInsets.only(top: 5),
                                                         child:   Align(
                                                           alignment: Alignment.centerLeft,
                                                           child: Text(snapshot.data![i]["i"].toString(),
                                                               overflow: TextOverflow.ellipsis,style: GoogleFonts.montserrat(color: Colors.black,fontWeight: FontWeight.bold,
                                                                   fontSize: 14)),
                                                         ))
                                                       ],
                                                     ),
                                                     subtitle:     Padding(padding: EdgeInsets.only(top: 15),
                                                         child:   Align(
                                                           alignment: Alignment.centerLeft,
                                                           child: Text(
                                                               AppHelper().getTanggalCustom(snapshot.data![i]["k"].toString()) + " "+
                                                               AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["k"].toString()) + " "+
                                                               AppHelper().getTahunCustom(snapshot.data![i]["k"].toString())+ " - "+
                                                                   snapshot.data![i]["n"].toString(),
                                                               overflow: TextOverflow.ellipsis,style: GoogleFonts.nunito(color: Colors.black, fontSize: 12)),
                                                         )),
                                                   ),
                                                   onTap: (){
                                                     FocusScope.of(context).requestFocus(FocusNode());
                                                     Navigator.push(context, ExitPage(page: PagePesanPribadiDetail(
                                                         snapshot.data![i]["g"].toString(),
                                                         snapshot.data![i]["i"].toString(),
                                                         AppHelper().getTanggalCustom(snapshot.data![i]["k"].toString()) + " "+
                                                             AppHelper().getNamaBulanCustomFull(snapshot.data![i]["k"].toString()) + " "+
                                                             AppHelper().getTahunCustom(snapshot.data![i]["k"].toString()),
                                                         snapshot.data![i]["a"].toString(),
                                                         snapshot.data![i]["j"].toString()))).then(onGoBack);
                                                   },
                                                 ),
                                                
                                                Padding(padding: EdgeInsets.only(top: 2),child: Divider(),)
                                              ],
                                            );
                                        }
                                      ),
                                    )
                                  ],
                                );
                          }
                        }
                      ),
                    ),
                  )
                )



              ],
            ),
          ),
        ),
      ),
    );

  }
}