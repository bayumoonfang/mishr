



import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Time%20Off/ARCHIVED/page_myapproval.dart';
import 'package:abzeno/page_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'S_HELPER/g_timeoff.dart';
import 'page_addtimeoff.dart';
import 'ARCHIVED/page_myrequest.dart';
import 'package:http/http.dart' as http;

import 'page_timeoffapprovedetail.dart';
import 'page_timeoffdetail.dart';
class PageTimeOffApprovalList extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  const PageTimeOffApprovalList(this.getKaryawanNo,this.getKaryawanNama);
  @override
  _PageTimeOffApprovalList createState() => _PageTimeOffApprovalList();
}

class _PageTimeOffApprovalList extends State<PageTimeOffApprovalList> {
  late TabController controller;




  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }




  loadData() async {
    await getSettings();
    EasyLoading.dismiss();
    //await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_timeoff().getData_AllTimeOffApproval(widget.getKaryawanNo, filter, filter2);
    });
  }

  Future getData() async {
    setState(() {
      g_timeoff().getData_AllTimeOffApproval(widget.getKaryawanNo, filter, filter2);
    });
  }



  String filter = "";
  String filter2 = "";
  @override
  Widget build(BuildContext context) {
    var onWillPop;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        //shape: Border(bottom: BorderSide(color: Colors.red)),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Container(
          padding: EdgeInsets.only(right: 20),
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
                  hintText: getBahasa.toString() == "1" ? 'Cari Persetujuan Time Off...' : 'Search Time Off Approval',
                ),
              ),
            ),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.black,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
          child : Column(
            children: [
                Container(
                  padding: EdgeInsets.only(top: 15,bottom: 5,left: 10),
                  height: 52,
                  width: double.infinity,
                  child: FutureBuilder(
                      future: g_timeoff().getData_timeOffType(),
                      builder: (context, snapshot){
                        return Container(
                          height: 50,
                          width: double.infinity,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: OutlinedButton(child: Text(snapshot.data![i]["a"].toString(),
                                    style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                                    style: OutlinedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      side: BorderSide(width: 1, color: HexColor("#6b727c")),
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        filter2 = snapshot.data![i]["a"].toString();
                                      });
                                    },)
                                );
                              }
                          )
                        );
                      })
                ),

              Expanded(
                  child: RefreshIndicator(
                    onRefresh: getData,
                    child: Padding(
                        padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                        child:FutureBuilder(
                          future: g_timeoff().getData_AllTimeOffApproval(widget.getKaryawanNo, filter, filter2),
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
                                      itemExtent: textScale.toString() == '1.17' ? 95 : 85,
                                      itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                      padding: const EdgeInsets.only(bottom: 85,top: 5),
                                      itemBuilder: (context, i) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              child :
                                              ListTile(
                                                  visualDensity: VisualDensity(horizontal: -2),
                                                  dense : true,
                                                  title: Opacity(
                                                      opacity: 0.9,
                                                      child:
                                                      Padding(padding: EdgeInsets.only(top: 2),child:
                                                      Text(snapshot.data![i]["m"].toString(),
                                                        overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.bold,fontSize: 14),),)
                                                  ),
                                                  subtitle: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 2),
                                                        child:   Align(alignment: Alignment.centerLeft,child:
                                                        Text(
                                                            AppHelper().getTanggalCustom(snapshot.data![i]["c"].toString()) + " "+
                                                                AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["c"].toString()) + " "+
                                                                AppHelper().getTahunCustom(snapshot.data![i]["c"].toString())+
                                                                " - "+
                                                                AppHelper().getTanggalCustom(snapshot.data![i]["d"].toString()) + " "+
                                                                AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["d"].toString()) + " "+
                                                                AppHelper().getTahunCustom(snapshot.data![i]["d"].toString())+
                                                                " ("+snapshot.data![i]["k"].toString()+" Hari"+")",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),),
                                                      ),

                                                      Padding(
                                                          padding: EdgeInsets.only(top: 2),
                                                          child: Align(alignment: Alignment.centerLeft,
                                                              child:Text("#"+snapshot.data![i]["j"].toString(),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: GoogleFonts.nunito(fontSize: 13)))),
                                                    ],
                                                  ),
                                                  trailing:
                                                  snapshot.data![i]["l"].toString() != 'Fully Approved' ?
                                                  Opacity(
                                                    opacity: 0.9,
                                                    child: Container(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          backgroundColor: snapshot.data![i]["l"].toString() == 'Pending'? Colors.black54 :
                                                          snapshot.data![i]["l"].toString() == 'Approved 1' ? HexColor("#0074D9")  :
                                                          HexColor("#FF4136"),
                                                        ),
                                                        child: Text(snapshot.data![i]["l"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                            color: snapshot.data![i]["l"].toString() == 'Pending'? Colors.white :
                                                            snapshot.data![i]["l"].toString() == 'Approved 1' ? Colors.white :
                                                            Colors.white,fontWeight: FontWeight.bold),),
                                                        onPressed: (){},
                                                      ),
                                                      height: 25,
                                                    ),
                                                  ) :  FaIcon(FontAwesomeIcons.circleCheck,color: HexColor("#3D9970"),size: 30,)
                                              ),
                                              onTap: (){
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                EasyLoading.show(status: AppHelper().loading_text);
                                                Navigator.push(context, ExitPage(page: TimeOffApproveDetail(snapshot.data![i]["a"].toString(), widget.getKaryawanNo, widget.getKaryawanNama,"1"))).then(onGoBack); //_changeLocation(snapshot.data![i]["a"].toString());
                                              },
                                            ),
                                            Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                                child : Divider(thickness: 1,)),
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
                    )
                  )
              )
            ],
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