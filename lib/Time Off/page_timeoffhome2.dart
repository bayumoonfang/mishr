



import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_notificationspecific.dart';
import 'package:abzeno/Time%20Off/ARCHIVED/page_myapproval.dart';
import 'package:abzeno/page_home.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'S_HELPER/g_timeoff.dart';
import 'S_HELPER/m_timeoff.dart';
import 'page_addtimeoff.dart';
import 'ARCHIVED/page_myrequest.dart';
import 'package:http/http.dart' as http;

import 'page_timeoffapprovallist.dart';
import 'page_timeoffdetail.dart';
class PageTimeOffHome2 extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  final String getKaryawanEmail;
  const PageTimeOffHome2(this.getKaryawanNo,this.getKaryawanNama, this.getKaryawanEmail);
  @override
  _PageTimeOffHome2 createState() => _PageTimeOffHome2();
}

class _PageTimeOffHome2 extends State<PageTimeOffHome2> {
  late TabController controller;
  String getNotifCountme = "0";
  getNotif() async {
    await AppHelper().getSpecificNotifCount("Attendance Request TimeOff").then((value){
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



  String approval_count = "0";
  loadData() async {
    await getSettings();
    await getNotif();
    await g_timeoff().get_TimeOffApprovalCount(widget.getKaryawanNo).then((value){
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
     // g_timeoff().getData_AllTimeOffRequest(widget.getKaryawanNo, filter, filter2, filter3);
      loadData();
    });
  }

  Future getData() async {
    setState(() {
     // g_timeoff().getData_AllTimeOffRequest(widget.getKaryawanNo, filter, filter2, filter3);
    });
  }




  _timeoff_delete(String getIdRequest) async {
    Navigator.pop(context);
    await m_timeoff().timeoff_delete(getIdRequest).then((value){
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
                //g_timeoff().getData_AllTimeOffRequest(widget.getKaryawanNo, filter, filter2, filter3);
                loadData();
                getBahasa.toString() == "1" ?
                AppHelper().showFlushBarconfirmed(context, "Request berhasil dihapus"):
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
        child: Text("Yes",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold),),
        onPressed:  () {
          _timeoff_delete(getIDRequest);
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        getBahasa.toString() == "1" ?
            "Hapus Request":
        "Delete Request", style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),textAlign:
      TextAlign.center,),
      content: Text(
        getBahasa.toString() == "1" ? "Apakah anda yakin menghapus data ini ?":
        "Would you like to delete this request ?", style: GoogleFonts.varelaRound(),textAlign:
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




  String filter = "";
  String filter2 = "";
  String filter3 = "";
  @override
  Widget build(BuildContext context) {
    var onWillPop;
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
        //shape: Border(bottom: BorderSide(color: Colors.red)),
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
                  hintText: getBahasa.toString() == "1" ? 'Cari Time Off...' : 'Search Time Off...',
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
        actions: [
         getNotifCountme != '0' ?
         badges.Badge(
         showBadge: true,
         position: badges.BadgePosition.topStart(top: 9,start: 10),
         badgeContent: Text(getNotifCountme.toString(),style: GoogleFonts.nunitoSans(color:Colors.white,fontSize: 9),),
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
         child: Padding(
           padding: EdgeInsets.only(top: 0,right: 22,left: 18),
           child: Positioned(
             top: -10,
             child : InkWell(
               child : FaIcon(FontAwesomeIcons.bell,color: HexColor("#535967"),size: 20,),
               onTap: (){
                 FocusScope.of(context).requestFocus(FocusNode());
                 Navigator.push(context, ExitPage(page: PageSpecificNotification(widget.getKaryawanEmail, "Attendance Request TimeOff"))).then(onGoBack);

               },
             )
           ) ,),
       ) :
         Padding(
           padding: EdgeInsets.only(top: 17,right: 22,left: 18),
           child: FaIcon(FontAwesomeIcons.bell,color: HexColor("#535967"),size: 20,),),

          Padding(
            padding: EdgeInsets.only(top: 19,right: 22),
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
                                      title: Text(getBahasa.toString() == "1" ? "Semua Status":"All Status",style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,fontSize: 15),),
                                      subtitle: Text(getBahasa.toString() == "1" ? "Semua status Time Off": "Time Off with all status",
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
                                      title: Text(getBahasa.toString() == "1" ? "Terbuka":"Pending",style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,fontSize: 15),),
                                      subtitle: Text(getBahasa.toString() == "1" ? "Time Off dengan status terbuka": "Time Off with pending status",
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
                                      title: Text(getBahasa.toString() == "1" ? "Disetujui 1":"Approved 1",style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,fontSize: 15),),
                                      subtitle: Text(getBahasa.toString() == "1" ? "Time Off dengan status disetujui sebagian":"Time Off with Approved 1 status",
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
                                      title: Text(getBahasa.toString() == "1" ? "Dibatalkan": "Cancel",style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,fontSize: 15),),
                                      subtitle: Text(getBahasa.toString() == "1" ? "Time Off dengan status dibatalkan": "Time Off with Cancel status",
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
                                      title: Text(getBahasa.toString() == "1" ? "Ditolak": "Reject",style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,fontSize: 15),),
                                      subtitle: Text(getBahasa.toString() == "1" ? "Time Off dengan status ditolak": "Time Off with Reject status",
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
                                      title: Text(getBahasa.toString() == "1" ? "Sepenuhnya disetujui": "Fully Approved",style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,fontSize: 15),),
                                      subtitle: Text(getBahasa.toString() == "1" ? "Time Off dengan status sepenuhnya disetujui": "Time Off with Fully Approved status",
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
                                        //AppHelper().showFlushBarconfirmed(context, filter2);
                                    },)
                                );
                              }
                          )
                        );
                      })
                ),
              Padding(
                  padding: EdgeInsets.only(left: 20,right: 20, top: 10),
                child : InkWell(
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.push(context, ExitPage(page: PageTimeOffApprovalList(widget.getKaryawanNo, widget.getKaryawanNama))).then(onGoBack);
                  },
                  child:

                  approval_count.toString() != "0" ?
                  badges.Badge(
                      showBadge: true,
                      position: badges.BadgePosition.topStart(top: -7,start: -5),
                      badgeContent: Text(approval_count.toString(),style: GoogleFonts.nunitoSans(color:Colors.white,fontSize: 13),),
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
                          title: Text(getBahasa.toString() == "1" ? "Butuh Persetujuan Saya" : "Need My approval",style: GoogleFonts.nunitoSans(fontSize: 14),),
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
                      title: Text(getBahasa.toString() == "1" ? "Butuh Persetujuan Saya" : "Need My Approval",style: GoogleFonts.nunitoSans(fontSize: 14),),
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
                        child:FutureBuilder(
                          future: g_timeoff().getData_AllTimeOffRequest(widget.getKaryawanNo, filter, filter2,"Asas"),
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
                                      itemExtent: 85,
                                      itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                      padding: const EdgeInsets.only(bottom: 85,top: 5),
                                      itemBuilder: (context, i) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              child :

                                              snapshot.data![i]["l"].toString() == 'Cancel'?
                                              Opacity(
                                                opacity: 0.5,
                                                child: ListTile(
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
                                              ) :
                                              ListTile(
                                                  visualDensity: VisualDensity(horizontal: -2),
                                                  dense : true,
                                                  title: Opacity(
                                                      opacity: 0.9,
                                                      child:
                                                      Padding(padding: EdgeInsets.only(top: 2),child:
                                                      Text(snapshot.data![i]["m"].toString(),
                                                        overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.bold,fontSize: 15),),)
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
                                                            style: GoogleFonts.workSans(fontSize: 14,color: Colors.black)),),
                                                      ),

                                                      Padding(
                                                          padding: EdgeInsets.only(top: 2),
                                                          child: Align(alignment: Alignment.centerLeft,
                                                              child:Text("#"+snapshot.data![i]["j"].toString(),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: GoogleFonts.nunito(fontSize: 14)))),
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
                                                EasyLoading.show(status: AppHelper().loading_text);
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                Navigator.push(context, ExitPage(page: TimeOffDetail(snapshot.data![i]["a"].toString(), widget.getKaryawanNo, widget.getKaryawanNama))).then(onGoBack);
                                                //_changeLocation(snapshot.data![i]["a"].toString());
                                              },
                                              onLongPress: () {
                                                snapshot.data![i]["l"].toString() == 'Cancel' ?
                                                showDeleteDialog(context, snapshot.data![i]["n"].toString()): showNothing();

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
                    ),
                  )
              )
            ],
          )

      ),
      floatingActionButton: Container(

        width: 62,
        height: 62,
        child: FloatingActionButton(
          backgroundColor: HexColor("#00a884"),
          child: FaIcon(FontAwesomeIcons.plus),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.push(context, ExitPage(page: PageAddTimeOff(widget.getKaryawanNo, widget.getKaryawanNama))).then(onGoBack);
          },
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