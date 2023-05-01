


import 'dart:async';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Request%20Attendance/page_reqattendapprovedetail.dart';
import 'package:abzeno/Request%20Attendance/page_reqattenddetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'S_HELPER/g_reqattend.dart';
import 'S_HELPER/m_reqattend.dart';

class RequestAttendance extends StatefulWidget{
  final String getKaryawanNo;
  final String getKategori;
  const RequestAttendance(this.getKaryawanNo, this.getKategori);
  @override
  _RequestAttendance createState() => _RequestAttendance();
}


class _RequestAttendance extends State<RequestAttendance> {


    String filter = "";
    String filter2 = "";
    String filter3 = "";
    String getBahasa = "1";
    getSettings() async {
      //==========================
      await AppHelper().getSession().then((value){
        setState(() {
          getBahasa = value[20];
        });});
    }

    Future getData() async {
      setState(() {
        g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, widget.getKategori);
      });
    }

    FutureOr onGoBack(dynamic value) {
      setState(() {
        g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, widget.getKategori);
        loadData();
      });
    }


    loadData() async {
      await getSettings();
      EasyLoading.dismiss();
    }


    @override
    void initState() {
      super.initState();
      loadData();
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
                  g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, widget.getKategori);
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
        child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {Navigator.pop(context);},
      );
      Widget continueButton = Container(
        width: 100,
        child: TextButton(
          child: Text("HAPUS",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
          onPressed:  () {
            _reqattend_delete(getIDRequest);
          },
        ),
      );
      AlertDialog alert = AlertDialog(
        actionsAlignment: MainAxisAlignment.end,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(getBahasa.toString() == "1"? "Hapus Permintaan":"Delete Request", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
        TextAlign.left,),
        content: Text(getBahasa.toString() == "1"? "Apakah anda yakin untuk menghapus permintaan ini ?": "Would you like to delete this request ?", style: GoogleFonts.nunitoSans(),textAlign:
        TextAlign.left,),
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
    final textScale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(child: Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
            height: 70,
            width: double.infinity,
            child:
            ListTile(
                dense : true,
                title:  Container(
                  padding: EdgeInsets.only(left: 10,right: 5,top: 15),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    onChanged: (text) {
                      setState(() {
                        filter = text;
                      });
                    },
                    style: GoogleFonts.nunito(fontSize: 14),
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
                      hintText: 'Cari Pengajuan...',
                    ),
                  ),
                ),
                trailing:  Padding(
                  padding: EdgeInsets.only(top: 19,right: 22),
                  child: InkWell(
                    child : FaIcon(FontAwesomeIcons.arrowDownWideShort,color: HexColor("#535967"),size: 20,),
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
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
                                                subtitle: Text(getBahasa.toString() == "1" ? "Semua status Pengajuan Kehadiran": "Time Off with all status",
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
                                                subtitle: Text(getBahasa.toString() == "1" ? "Pengajuan Kehadiran dengan status terbuka": "Time Off with pending status",
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
                                                subtitle: Text(getBahasa.toString() == "1" ? "Pengajuan Kehadiran dengan status disetujui sebagian":"Time Off with Approved 1 status",
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
                                            subtitle: Text(getBahasa.toString() == "1" ? "Pengajuan Kehadiran dengan status dibatalkan": "Time Off with Cancel status",
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
                                            subtitle: Text(getBahasa.toString() == "1" ? "Pengajuan Kehadiran dengan status ditolak": "Time Off with Reject status",
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
                                            subtitle: Text(getBahasa.toString() == "1" ? "Pengajuan Kehadiran dengan status sepenuhnya disetujui": "Time Off with Fully Approved status",
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
            )
        ),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: getData,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                    child: FutureBuilder(
                      future: g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, widget.getKategori),
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
                                          "Tidak ada data",
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
                                  itemExtent: textScale.toString() == '1.17' ? 100: 90,
                                  itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                  padding: const EdgeInsets.only(bottom: 85),
                                  itemBuilder: (context, i) {
                                    return Column(
                                      children: [
                                        snapshot.data![i]["e"].toString() == "Cancel" ?
                                        InkWell(
                                          child :
                                          Opacity(
                                                opacity: 0.5,
                                                child: ListTile(
                                                    visualDensity: VisualDensity(horizontal: -2),
                                                    dense : true,
                                                    title:  Text(snapshot.data![i]["f"].toString(),
                                                      overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                          fontWeight: FontWeight.bold,fontSize: 14.5),),
                                                    subtitle: Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 5),
                                                          child:   Align(alignment: Alignment.centerLeft,child: Row(
                                                            children: [
                                                              Text(
                                                                  AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                                      AppHelper().getNamaBulanCustomFull(snapshot.data![i]["a"].toString()) + " "+
                                                                      AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),
                                                            ],
                                                          ),),
                                                        ),

                                                        Padding(
                                                            padding: EdgeInsets.only(top: 2),
                                                            child: Align(alignment: Alignment.centerLeft,
                                                                child:Text("Alasan : "+snapshot.data![i]["d"].toString(),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: GoogleFonts.varelaRound(fontSize: 13)))),
                                                      ],
                                                    ),
                                                    trailing:
                                                    snapshot.data![i]["e"].toString() != 'Fully Approved' ?
                                                    Opacity(
                                                      opacity: 0.9,
                                                      child: Container(
                                                        child: OutlinedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            elevation: 0,
                                                            side: BorderSide(
                                                              width: 1,
                                                              color: snapshot.data![i]["e"].toString() == 'Pending'? Colors.black54 :
                                                              snapshot.data![i]["e"].toString() == 'Approved 1' ? HexColor("#0074D9") :
                                                              HexColor("#FF4136"),
                                                              style: BorderStyle.solid,
                                                            ),
                                                          ),
                                                          child: Text(snapshot.data![i]["e"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                              color: snapshot.data![i]["e"].toString() == 'Pending'? Colors.black54 :
                                                              snapshot.data![i]["e"].toString() == 'Approved 1' ? HexColor("#0074D9") :
                                                              HexColor("#FF4136")),),
                                                          onPressed: (){},
                                                        ),
                                                        height: 25,
                                                      ),
                                                    ) :
                                                    FaIcon(FontAwesomeIcons.circleCheck,color: HexColor("#3D9970"),size: 30,)
                                                )),
                                          onTap: (){
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            EasyLoading.show(status: AppHelper().loading_text);
                                            Navigator.push(context, ExitPage(page: ReqAttendDetail(snapshot.data![i]["g"].toString(), widget.getKaryawanNo))).then(onGoBack);
                                          },
                                          onLongPress: () {
                                            snapshot.data![i]["e"].toString() == 'Cancel' ?
                                            showDeleteDialog(context, snapshot.data![i]["i"].toString()): showNothing();
                                          },
                                        ) :
                                    InkWell(
                                      child : ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title:  Text(snapshot.data![i]["f"].toString(),
                                            overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,fontSize: 14.5),),
                                          subtitle: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(top: 5),
                                                child:   Align(alignment: Alignment.centerLeft,child: Row(
                                                  children: [
                                                    Text(
                                                        AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                            AppHelper().getNamaBulanCustomFull(snapshot.data![i]["a"].toString()) + " "+
                                                            AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),
                                                  ],
                                                ),),
                                              ),

                                              Padding(
                                                  padding: EdgeInsets.only(top: 2),
                                                  child: Align(alignment: Alignment.centerLeft,
                                                      child:Text("Alasan : "+snapshot.data![i]["d"].toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.varelaRound(fontSize: 13)))),
                                            ],
                                          ),
                                          trailing:
                                          snapshot.data![i]["e"].toString() != 'Fully Approved' ?
                                          Opacity(
                                            opacity: 0.9,
                                            child: Container(
                                              child: OutlinedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  side: BorderSide(
                                                    width: 1,
                                                    color: snapshot.data![i]["e"].toString() == 'Pending'? Colors.black54 :
                                                    snapshot.data![i]["e"].toString() == 'Approved 1' ? HexColor("#0074D9") :
                                                    HexColor("#FF4136"),
                                                    style: BorderStyle.solid,
                                                  ),
                                                ),
                                                child: Text(snapshot.data![i]["e"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                    color: snapshot.data![i]["e"].toString() == 'Pending'? Colors.black54 :
                                                    snapshot.data![i]["e"].toString() == 'Approved 1' ? HexColor("#0074D9") :
                                                    HexColor("#FF4136")),),
                                                onPressed: (){},
                                              ),
                                              height: 25,
                                            ),
                                          ) :
                                          FaIcon(FontAwesomeIcons.circleCheck,color: HexColor("#3D9970"),size: 30,)
                                    ), onTap: (){
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      EasyLoading.show(status: AppHelper().loading_text);
                                      widget.getKategori == 'Request' ?
                                      Navigator.push(context, ExitPage(page: ReqAttendDetail(snapshot.data![i]["g"].toString(), widget.getKaryawanNo))).then(onGoBack) :
                                      Navigator.push(context, ExitPage(page: ReqAttendApproveDetail(snapshot.data![i]["g"].toString(), widget.getKaryawanNo, "1"))).then(onGoBack);
                                    },),
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

                  )
                )
            ),

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