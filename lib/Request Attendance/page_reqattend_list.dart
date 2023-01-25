



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

import 'S_HELPER/m_reqattend.dart';
import 'page_reqattend_addhome.dart';
import 'page_reqattend_approve_list.dart';
import 'page_reqattendanceadd2.dart';
import 'page_reqattenddetail.dart';



class PageReqAttend extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  final String getEmail;
  const PageReqAttend(this.getKaryawanNo, this.getKaryawanNama, this.getEmail);
  @override
  _PageReqAttend createState() => _PageReqAttend();
}

class _PageReqAttend extends State<PageReqAttend> {
  String filter = "";
  String filter2 = "";
  String filter3 = "";
  String approval_count = "0";
  String getNotifCountme = "0";
  getNotif() async {
    await AppHelper().getSpecificNotifCount("Attendance Correction").then((value){
      setState(() {
        getNotifCountme = value[0];
      });});
  }


  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }


  loadData() async {
    await getSettings();
    await getNotif();
    await g_reqattend().get_ReqAttendApprCount(widget.getKaryawanNo).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          approval_count = value[0];
        });
      }
    });
  }

  Future getData() async {
    setState(() {
      g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, "Request");
    });
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, "Request");
      loadData();
    });
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }
  @override
  void dispose(){
    super.dispose();
  }



  _reqattend_delete(String getIdRequest) async {
    Navigator.pop(context);
    await m_reqattend().reqattend_delete(getIdRequest).then((value){
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
                g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, "Request");
                loadData();
                getBahasa.toString() == "1"?
                AppHelper().showFlushBarconfirmed(context, "Permintaan berhasil dihapus") :
                AppHelper().showFlushBarconfirmed(context, "Request has been Deleted");
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




  showDeleteDialog(BuildContext context, getIDRequest) {
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: GoogleFonts.lexendDeca(color: Colors.black),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        style: ElevatedButton.styleFrom(
            primary: HexColor("#e21b4c"),
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
          _reqattend_delete(getIDRequest);
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Hapus Permintaan":"Delete Request", style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),textAlign:
      TextAlign.center,),
      content: Text(getBahasa.toString() == "1"? "Apakah anda yakin untuk menghapus permintaan ini ?": "Would you like to delete this request ?", style: GoogleFonts.varelaRound(),textAlign:
      TextAlign.center,),
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


  void showNothing() {

  }




  @override
  Widget build(BuildContext context) {
    var onWillPop;
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
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
        actions: [
          getNotifCountme != '0' ?
          Badge(
            showBadge: true,
            position: BadgePosition.topStart(top: 9,start: 10),
            badgeContent: Text(getNotifCountme.toString(),style: GoogleFonts.nunitoSans(color:Colors.white,fontSize: 9),),
            animationType:  BadgeAnimationType.scale,
            shape: BadgeShape.circle,
            child: Padding(
              padding: EdgeInsets.only(top: 0,right: 22,left: 18),
              child: Positioned(
                  top: -10,
                  child : InkWell(
                    child : FaIcon(FontAwesomeIcons.bell,color: HexColor("#535967"),size: 20,),
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push(context, ExitPage(page: PageSpecificNotification(widget.getEmail, "Attendance Correction"))).then(onGoBack);
                    },
                  )
              ) ,),
          ) :
          Padding(
            padding: EdgeInsets.only(top: 17,right: 22,left: 18),
            child: FaIcon(FontAwesomeIcons.bell,color: HexColor("#535967"),size: 20,),),

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
                                          title: Text(getBahasa.toString() == "1"? "Semua Status": "All Status",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                          subtitle: Text(getBahasa.toString() == "1"? "Permintaan dengan semua status": "Request Attendance with all status",
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
                                          title: Text(getBahasa.toString() == "1"? "Terbuka": "Pending",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                          subtitle: Text(getBahasa.toString() == "1"? "Permintaan dengan status terbuka": "Request Attendance with pending status",
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
                                          title: Text(getBahasa.toString() == "1"? "Persetujuan 1": "Approved 1",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                          subtitle: Text(getBahasa.toString() == "1"? "Permintaan dengan status disetujui sebagian": "Request Attendance with Approved 1 status",
                                              style: GoogleFonts.workSans(
                                                  fontSize: 12)),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.pop(context);
                                            filter3 = "Approved 1";
                                          });
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),)
                                    ],
                                  ),

                                  InkWell(
                                    child : ListTile(
                                      visualDensity: VisualDensity(horizontal: -2),
                                      dense : true,
                                      title: Text(getBahasa.toString() == "1"? "Dibatalkan": "Cancel",style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,fontSize: 15),),
                                      subtitle: Text(getBahasa.toString() == "1"? "Permintaan dengan status dibatalkan": "Request Attendance with Cancel status",
                                          style: GoogleFonts.workSans(
                                              fontSize: 12)),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        Navigator.pop(context);
                                        filter3 = "Cancel";
                                      });
                                    },
                                  ),
                                  Padding(padding: const EdgeInsets.only(top:1),child:
                                  Divider(height: 1,),),

                                  InkWell(
                                    child : ListTile(
                                      visualDensity: VisualDensity(horizontal: -2),
                                      dense : true,
                                      title: Text(getBahasa.toString() == "1"? "Ditolak": "Reject",style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,fontSize: 15),),
                                      subtitle: Text(getBahasa.toString() == "1"? "Permintaan dengan status ditolak": "Request Attendance with Reject status",
                                          style: GoogleFonts.workSans(
                                              fontSize: 12)),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        Navigator.pop(context);
                                        filter3 = "Rejected";
                                      });
                                    },
                                  ),
                                  Padding(padding: const EdgeInsets.only(top:1),child:
                                  Divider(height: 1,),),

                                  InkWell(
                                    child : ListTile(
                                      visualDensity: VisualDensity(horizontal: -2),
                                      dense : true,
                                      title: Text(getBahasa.toString() == "1"? "Sepenuhnya Disetujui": "Fully Approved",style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,fontSize: 15),),
                                      subtitle: Text(getBahasa.toString() == "1"? "Permintaan dengan status sepenuhnya disetujui": "Request Attendance with Fully Approved status",
                                          style: GoogleFonts.workSans(
                                              fontSize: 12)),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        Navigator.pop(context);
                                        filter3 = "Fully Approved";
                                      });
                                    },
                                  ),
                                  Padding(padding: const EdgeInsets.only(top:1),child:
                                  Divider(height: 1,),)
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
                             /*  Padding(
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
            Padding(
                padding: EdgeInsets.only(left: 20,right: 20, top: 10),
                child : InkWell(
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push(context, ExitPage(page: PageReqAttendApprovalList(widget.getKaryawanNo, widget.getKaryawanNama))).then(onGoBack);
                    },
                    child:
                    approval_count.toString() != "0" ?
                    Badge(
                      showBadge: true,
                      position: BadgePosition.topStart(top: -7,start: -5),
                      animationType:  BadgeAnimationType.scale,
                      badgeContent: Text(approval_count.toString(),style: GoogleFonts.nunitoSans(color:Colors.white,fontSize: 13),),
                      shape: BadgeShape.circle,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#DDDDDD")),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          visualDensity: VisualDensity(horizontal: -2),
                          dense : true,
                          minLeadingWidth : 25,
                          minVerticalPadding: 10,
                          leading: FaIcon(FontAwesomeIcons.clipboardCheck,size: 22,color : HexColor("#02ac0e")),
                          title: Text(getBahasa.toString() == "1"? "Butuh Persetujuan Saya" : "Need My Approval",style: GoogleFonts.nunitoSans(fontSize: 14),),
                          trailing: FaIcon(FontAwesomeIcons.angleRight,size: 18,),
                        ),
                      ),
                    ) : Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: HexColor("#DDDDDD")),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        visualDensity: VisualDensity(horizontal: -2),
                        dense : true,
                        minLeadingWidth : 25,
                        minVerticalPadding: 10,
                        leading: FaIcon(FontAwesomeIcons.clipboardCheck,size: 22,color : HexColor("#02ac0e")),
                        title: Text(getBahasa.toString() == "1"? "Butuh Persetujuan Saya" : "Need My Approval",style: GoogleFonts.nunitoSans(fontSize: 14),),
                        trailing: FaIcon(FontAwesomeIcons.angleRight,size: 18,),
                      ),
                    )
                )
            ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: getData,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                    child: FutureBuilder(
                        future: g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, "Request"),
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
                                    itemExtent: 85,
                                    itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                    padding: const EdgeInsets.only(bottom: 85),
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            child :


                                      snapshot.data![i]["e"].toString() == 'Cancel' ?
                                            Opacity(
                                              opacity: 0.5,
                                              child: ListTile(
                                                  visualDensity: VisualDensity(horizontal: -2),
                                                  dense : true,
                                                  title:  Text(snapshot.data![i]["f"].toString(),  style: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.bold,fontSize: 15),),
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
                                                                style: GoogleFonts.workSans(fontSize: 14,color: Colors.black)),
                                                          ],
                                                        ),),
                                                      ),

                                                      Padding(
                                                          padding: EdgeInsets.only(top: 1),
                                                          child: Align(alignment: Alignment.centerLeft,
                                                              child:Text(getBahasa.toString() == "1"?
                                                              "Alasan : "+snapshot.data![i]["d"].toString() :
                                                              "Reason : "+snapshot.data![i]["d"].toString()   ,
                                                                  style: GoogleFonts.nunito(fontSize: 14)))),
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
                                            ) :
                                      ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title:  Text(snapshot.data![i]["f"].toString(),  style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
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
                                                        style: GoogleFonts.workSans(fontSize: 14,color: Colors.black)),
                                                  ],
                                                ),),
                                              ),

                                              Padding(
                                                  padding: EdgeInsets.only(top: 1),
                                                  child: Align(alignment: Alignment.centerLeft,
                                                      child:Text(getBahasa.toString() == "1"?
                                                      "Alasan : "+snapshot.data![i]["d"].toString() :
                                                      "Reason : "+snapshot.data![i]["d"].toString()   ,
                                                          style: GoogleFonts.nunito(fontSize: 14)))),
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
                                              Navigator.push(context, ExitPage(page: ReqAttendDetail(snapshot.data![i]["g"].toString(), widget.getKaryawanNo))).then(onGoBack);
                                            },
                                            onLongPress: () {
                                              snapshot.data![i]["e"].toString() == 'Cancel' ?
                                                  showDeleteDialog(context, snapshot.data![i]["i"].toString()): showNothing();

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
      /*floatingActionButton: Container(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          backgroundColor: HexColor("#00a884"),
          child: FaIcon(FontAwesomeIcons.plus),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            //Navigator.push(context, ExitPage(page: RequestAttendAddHome(widget.getKaryawanNo))).then(onGoBack);
          },
        ),
      ),*/
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