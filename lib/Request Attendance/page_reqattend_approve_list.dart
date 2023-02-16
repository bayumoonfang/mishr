



import 'dart:async';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_notificationspecific.dart';
import 'package:abzeno/Request%20Attendance/S_HELPER/g_reqattend.dart';
import 'package:abzeno/Request%20Attendance/page_reqattendance.dart';
import 'package:abzeno/Time%20Off/ARCHIVED/page_myapproval.dart';
import 'package:abzeno/page_home.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'page_reqattend_addhome.dart';
import 'page_reqattendanceadd2.dart';
import 'page_reqattendapprovedetail.dart';
import 'page_reqattenddetail.dart';



class PageReqAttendApprovalList extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  const PageReqAttendApprovalList(this.getKaryawanNo, this.getKaryawanNama);
  @override
  _PageReqAttendApprovalList createState() => _PageReqAttendApprovalList();
}

class _PageReqAttendApprovalList extends State<PageReqAttendApprovalList> {
  String filter = "";
  String filter2 = "";
  String filter3 = "";

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }




  Future getData() async {
    setState(() {
      g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, "Approval");
    });
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, "Approval");
    });
  }


  @override
  void initState() {
    super.initState();
    getSettings();
  }


  @override
  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var onWillPop;
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
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
              hintText: getBahasa.toString() == "1"? 'Cari Permintaan...' : 'Search Request...',
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
      ),
      body: new Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15,bottom: 5,left: 10),
              height: 52,
              width: double.infinity,
              child: Container(
                  height: 50,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: OutlinedButton(child: Text(getBahasa.toString() == "1"? "Semua Tipe" : "All Type",
                            style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(), side: BorderSide(width: 1, color: HexColor("#6b727c")),
                            ),
                            onPressed: (){
                              setState(() {
                                filter2 = "Semua Tipe";
                              });
                            },)
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: OutlinedButton(child: Text("Correction",
                            style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(), side: BorderSide(width: 1, color: HexColor("#6b727c")),
                            ),
                            onPressed: (){
                              setState(() {
                                filter2 = "Correction";
                              });
                            },)
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: OutlinedButton(child: Text("Ganti Shift",
                            style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(), side: BorderSide(width: 1, color: HexColor("#6b727c")),
                            ),
                            onPressed: (){
                              setState(() {
                                filter2 = "Ganti Shift";
                              });
                            },)
                      ),
                      /*Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: OutlinedButton(child: Text("Lembur Same Day",
                            style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(), side: BorderSide(width: 1, color: HexColor("#6b727c")),
                            ),
                            onPressed: (){
                              setState(() {
                                filter2 = "Lembur Same Day";
                              });
                            },)
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: OutlinedButton(child: Text("Lembur Other Day",
                            style: GoogleFonts.nunitoSans(color: HexColor("#6b727c"),fontSize: 13),),
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(), side: BorderSide(width: 1, color: HexColor("#6b727c")),
                            ),
                            onPressed: (){
                              setState(() {
                                filter2 = "Lembur Other Day";
                              });
                            },)
                      )*/
                    ],
                  )
              ),
            ),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: getData,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                    child: FutureBuilder(
                        future: g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, "Approval"),
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
                                    ))) :
                            Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemExtent: 89,
                                    itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                    padding: const EdgeInsets.only(bottom: 85),
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            child :
                                            ListTile(
                                                visualDensity: VisualDensity(horizontal: -2),
                                                dense : true,
                                                title:  Text(snapshot.data![i]["f"].toString(),  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,fontSize: 14),),
                                                subtitle: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 2),
                                                      child:   Align(alignment: Alignment.centerLeft,child: Row(
                                                        children: [
                                                          Text(
                                                              getBahasa.toString() == "1"?
                                                              AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                                  AppHelper().getNamaBulanCustomFull(snapshot.data![i]["a"].toString()) + " "+
                                                                  AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()) :
                                                              AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                                  AppHelper().getNamaBulanCustomFullEnglish(snapshot.data![i]["a"].toString()) + " "+
                                                                  AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()),
                                                              style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),
                                                        ],
                                                      ),),
                                                    ),

                                                    Padding(
                                                        padding: EdgeInsets.only(top: 1),
                                                        child: Align(alignment: Alignment.centerLeft,
                                                            child:Text(getBahasa.toString() == "1"?
                                                            "Alasan : "+snapshot.data![i]["d"].toString() :
                                                            "Reason : "+snapshot.data![i]["d"].toString()   ,
                                                                style: GoogleFonts.nunito(fontSize: 13)))),
                                                  ],
                                                ),
                                                trailing:
                                                snapshot.data![i]["e"].toString() != 'Fully Approved' ?
                                                Opacity(
                                                  opacity: 0.9,
                                                  child: Container(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        backgroundColor: snapshot.data![i]["e"].toString() == 'Pending'? Colors.black54 :
                                                        snapshot.data![i]["e"].toString() == 'Approved 1' ? HexColor("#0074D9")  :
                                                        HexColor("#FF4136"),
                                                      ),
                                                      child: Text(snapshot.data![i]["e"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                          color: snapshot.data![i]["e"].toString() == 'Pending'? Colors.white :
                                                          snapshot.data![i]["e"].toString() == 'Approved 1' ? Colors.white :
                                                          Colors.white,fontWeight: FontWeight.bold),),
                                                      onPressed: (){},
                                                    ),
                                                    height: 25,
                                                  ),
                                                ) :
                                                FaIcon(FontAwesomeIcons.circleCheck,color: HexColor("#3D9970"),size: 30,)
                                            ),

                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              EasyLoading.show(status: AppHelper().loading_text);
                                             // Navigator.push(context, ExitPage(page: ReqAttendApproveDetail(snapshot.data![i]["g"].toString(), widget.getKaryawanNo, widget.getKaryawanNama,"1"))).then(onGoBack);
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
                        }
                    ),
                  ),
                )

            )

          ],
        ),
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