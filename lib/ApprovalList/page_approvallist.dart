


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/ApprovalList/page_apprdetailbertugas.dart';
import 'package:abzeno/ApprovalList/page_apprdetaillembur.dart';
import 'package:abzeno/ApprovalList/page_apprdetailreqattend.dart';
import 'package:abzeno/ApprovalList/page_apprdetailtimeoff.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/g_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_detailnotification.dart';
import 'package:abzeno/helper/app_helper.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
class PageApprovalList extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  final Function runLoopMe;
  const PageApprovalList(this.getKaryawanNo, this.getKaryawanNama, this.runLoopMe);
  @override
  _PageApprovalList createState() => _PageApprovalList();
}


class _PageApprovalList extends State<PageApprovalList> {

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }

  String filter = "";
  String filter2 = "";
  String filter3 = "";

  Future getData() async {
    setState(() {
      g_helper().getData_AllApprove(widget.getKaryawanNo, filter, filter2, filter3);
      widget.runLoopMe();
    });
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_helper().getData_AllApprove(widget.getKaryawanNo, filter, filter2, filter3);
      widget.runLoopMe();
    });
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
              hintText: getBahasa.toString() =="1" ? 'Cari Persetujuan...' : 'Search Approval...',
            ),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 18,right: 22),
            child: InkWell(
              child : FaIcon(FontAwesomeIcons.arrowDownWideShort,color: HexColor("#535967"),size: 20,),
              onTap: (){
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                          child : Container(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Padding(
                              padding: EdgeInsets.only(left: 25,right: 25,top: 25),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Filter By Status",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),),
                                      InkWell(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: FaIcon(FontAwesomeIcons.times,size: 20,),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top:15),
                                  ),
                                  Column(
                                    children: [

                                      InkWell(
                                        child : ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title: Text(getBahasa.toString() =="1" ? "Semua Status": "All Status",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                          subtitle: Text(getBahasa.toString() =="1" ? "Permintaan dengan semua status": "Request Attendance with all status",
                                              style: GoogleFonts.workSans(
                                                  fontSize: 12)),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.pop(context);
                                            filter3 = "";
                                          });
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),),


                                      InkWell(
                                        child : ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title: Text(getBahasa.toString() =="1" ? "Terbuka ": "Pending",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                          subtitle: Text(getBahasa.toString() =="1" ? "Permintaan dengan status terbuka": "Request Attendance with pending status",
                                              style: GoogleFonts.workSans(
                                                  fontSize: 12)),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.pop(context);
                                            filter3 = "Pending";
                                          });
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),),

                                      InkWell(
                                        child : ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title: Text(getBahasa.toString() =="1" ? "Disetujui": "Approved",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                          subtitle: Text(getBahasa.toString() =="1" ? "Permintaan dengan status disetujui": "Request Attendance with Approved 1 status",
                                              style: GoogleFonts.workSans(
                                                  fontSize: 12)),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.pop(context);
                                            filter3 = "Approved";
                                          });
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      );
                    });
              },
            ),)
        ],
      ),
      body: RefreshIndicator(
          onRefresh: getData,
          child : Container(
              padding: EdgeInsets.only(left: 15,right: 15,top: 5),
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child : Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5,left: 10),
                    height: 35,
                    width: double.infinity,
                    child: Container(
                        height: 50,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: OutlinedButton(child: Text(getBahasa.toString() =="1" ? "Semua Approval" : "All Approval",
                                  style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                                  style: OutlinedButton.styleFrom(
                                    shape: StadiumBorder(), side: BorderSide(width: 1, color: HexColor("#6b727c")),
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      filter2 = "Semua Approval";
                                    });
                                  },)
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: OutlinedButton(child: Text(getBahasa.toString() =="1" ? "Persetujuan 1": "Approval 1",
                                  style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                                  style: OutlinedButton.styleFrom(
                                    shape: StadiumBorder(), side: BorderSide(width: 1, color: HexColor("#6b727c")),
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      filter2 = "Approval 1";
                                    });
                                  },)
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: OutlinedButton(child: Text(getBahasa.toString() =="1" ? "Persetujuan 2": "Approval 2",
                                  style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                                  style: OutlinedButton.styleFrom(
                                    shape: StadiumBorder(), side: BorderSide(width: 1, color: HexColor("#6b727c")),
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      filter2 = "Approval 2";
                                    });
                                  },)
                            )
                          ],
                        )
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(bottom: 5,left: 15,right: 15),
                      child: Padding(padding: const EdgeInsets.only(top: 10,bottom: 15),
                          child : Container(
                              padding: EdgeInsets.only(top: 2,bottom: 2),
                              decoration: BoxDecoration(
                                border: Border.all(color: HexColor("#8fe4f0")),
                                color: HexColor("#ebfffe"),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:  ListTile(
                                visualDensity: VisualDensity(horizontal: -2),
                                dense : true,
                                leading: FaIcon(FontAwesomeIcons.circleInfo,color:HexColor("#28b9e0"),

                                ),
                                title:Text(getBahasa.toString() =="1" ? "Lakukan dengan mudah dengan menu ini, pastikan data sudah benar sebelum melakukan approved" :
                                    "Do the approval through the menu according to the type of request",
                                    style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                              )
                          )
                      )
                  ),
                  Expanded(
                      child: FutureBuilder(
                        future: g_helper().getData_AllApprove(widget.getKaryawanNo, filter, filter2, filter3),
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
                                        Image.asset('assets/empty2.png',width: 150,),
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
                                    itemExtent: textScale.toString() == '1.17' ? 110: 105,
                                    itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                    padding: const EdgeInsets.only(left: 10,right: 15,bottom: 85),
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            child : ListTile(
                                              visualDensity: VisualDensity(vertical: -2),
                                              dense : true,
                                              title:Opacity(
                                                  opacity: 0.9,
                                                  child:
                                                  Padding(padding: EdgeInsets.only(top: 2),child:
                                                  Text(
                                                    getBahasa.toString() == "1" ?
                                                    AppHelper().getTanggalCustom(snapshot.data![i]["c"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFull(snapshot.data![i]["c"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["c"].toString()) :
                                                    AppHelper().getTanggalCustom(snapshot.data![i]["c"].toString()) + " "+
                                                        AppHelper().getNamaBulanCustomFullEnglish(snapshot.data![i]["c"].toString()) + " "+
                                                        AppHelper().getTahunCustom(snapshot.data![i]["c"].toString()),
                                                    overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.bold,fontSize: 14.5),),)
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5),
                                                    child:   Align(alignment: Alignment.centerLeft,child:
                                                    Text(snapshot.data![i]["a"].toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),),
                                                  ),

                                                  Padding(
                                                      padding: EdgeInsets.only(top: 3),
                                                      child: Align(alignment: Alignment.centerLeft,
                                                          child:Text("#"+snapshot.data![i]["b"].toString(),
                                                              style: GoogleFonts.workSans(fontSize: 13)))),
                                                  Padding(
                                                      padding: EdgeInsets.only(top: 3,bottom: 1),
                                                      child: Align(alignment: Alignment.centerLeft,
                                                          child:Text("as "+snapshot.data![i]["d"].toString(),
                                                              style: GoogleFonts.workSans(fontSize: 13)))),
                                                ],
                                              ),
                                                trailing:
                                                snapshot.data![i]["e"].toString() == 'Pending' ?
                                                Opacity(
                                                  opacity: 0.9,
                                                  child: Container(
                                                    child: OutlinedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        side: BorderSide(
                                                          width: 1,
                                                          color: Colors.black54,
                                                          style: BorderStyle.solid,
                                                        ),
                                                      ),
                                                      child: Text(snapshot.data![i]["e"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                          color: Colors.black54),),
                                                      onPressed: (){},
                                                    ),
                                                    height: 25,
                                                  ),
                                                ) : snapshot.data![i]["e"].toString() == 'Approved' ?
                                                FaIcon(FontAwesomeIcons.circleCheck,color: HexColor("#3D9970"),size: 30,)
                                                    :
                                                Opacity(
                                                  opacity: 0.9,
                                                  child: Container(
                                                    child: OutlinedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        side: BorderSide(
                                                          width: 1,
                                                          color:
                                                          HexColor("#FF4136"),
                                                          style: BorderStyle.solid,
                                                        ),
                                                      ),
                                                      child: Text(snapshot.data![i]["e"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                          color:
                                                          HexColor("#FF4136")),),
                                                      onPressed: (){},
                                                    ),
                                                    height: 25,
                                                  ),
                                                )
                                            ),
                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              snapshot.data![i]["b"].toString().substring(0,6) == 'REQATT' ?
                                              Navigator.push(context, ExitPage(page: ApprReqAttenDetail(snapshot.data![i]["b"].toString(), widget.getKaryawanNo, widget.getKaryawanNama))).then(onGoBack)
                                              : snapshot.data![i]["b"].toString().substring(0,6) == 'OVERTI' ?
                                              Navigator.push(context, ExitPage(page: ApprLemburDetail(snapshot.data![i]["b"].toString(), widget.getKaryawanNo, widget.getKaryawanNama))).then(onGoBack)
                                              :snapshot.data![i]["b"].toString().substring(0,1) == 'B' ?
                                              Navigator.push(context, ExitPage(page: ApprBertugasDetail(snapshot.data![i]["b"].toString(), widget.getKaryawanNo))).then(onGoBack)
                                              : Navigator.push(context, ExitPage(page: ApprTimeOffDetail(snapshot.data![i]["b"].toString(), widget.getKaryawanNo, widget.getKaryawanNama))).then(onGoBack);


                                            },
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
      //Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

}