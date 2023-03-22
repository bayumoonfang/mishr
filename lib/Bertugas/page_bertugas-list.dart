


import 'dart:async';

import 'package:abzeno/Bertugas/S_HELPER/g_bertugas.dart';
import 'package:abzeno/Bertugas/S_HELPER/m_bertugas.dart';
import 'package:abzeno/Bertugas/page_bertugasdetail-appr.dart';
import 'package:abzeno/Bertugas/page_bertugasdetail.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Time%20Off/page_timeoffdetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';



class PageBertugasList extends StatefulWidget{
  final String getKaryawanNo;
  final String getType;
  const PageBertugasList(this.getKaryawanNo, this.getType);
  @override
  _PageBertugasList createState() => _PageBertugasList();
}



class _PageBertugasList extends State<PageBertugasList> {

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

  @override
  void initState() {
    super.initState();
    //FocusScope.of(context).requestFocus(FocusNode());
    loadData();
  }
  @override
  void dispose(){
    super.dispose();
  }


  String approval_count = "0";
  loadData() async {
    await getSettings();
    EasyLoading.dismiss();
    //await _startingVariable();
  }



  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_bertugas().getdata_bertugas(widget.getKaryawanNo, filter, filter2, widget.getType);
      loadData();
    });
  }

  Future getData() async {
    setState(() {
      g_bertugas().getdata_bertugas(widget.getKaryawanNo, filter, filter2, widget.getType);
    });
  }




  _bertugas_delete(String getIdRequest) async {
    Navigator.pop(context);
    await m_bertugas().bertugas_delete(getIdRequest).then((value){
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
                g_bertugas().getdata_bertugas(widget.getKaryawanNo, filter, filter2, widget.getType);
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
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text("HAPUS",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _bertugas_delete(getIDRequest);
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        getBahasa.toString() == "1" ?
        "Hapus Request":
        "Delete Request", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Text(
        getBahasa.toString() == "1" ? "Apakah anda yakin menghapus data ini ?":
        "Would you like to delete this request ?", style: GoogleFonts.nunitoSans(),textAlign:
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

  void showNothing() {}

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
        body: Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child : Column(
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
                              hintText: getBahasa.toString() == "1" ? 'Cari Data...' : 'Search Time Off...',
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
                                                        subtitle: Text(getBahasa.toString() == "1" ? "Semua status Time Off": "Time Off with all status",
                                                            style: GoogleFonts.workSans(
                                                                fontSize: 12)),
                                                      ),
                                                      onTap: (){
                                                        setState(() {
                                                          Navigator.pop(context);
                                                          filter2 = "";
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
                                                          filter2 = "Pending";
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
                                                          filter2 = "Approved 1";
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
                                                      filter2 = "Canceled";
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
                                                      filter2 = "Rejected";
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
                                                      filter2 = "Fully Approved";
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
                          child:FutureBuilder(
                            future: g_bertugas().getdata_bertugas(widget.getKaryawanNo, filter, filter2, widget.getType),
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
                                        itemExtent: textScale.toString() == '1.17' ? 95 : 85,
                                        itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                        padding: const EdgeInsets.only(bottom: 85,top: 5),
                                        itemBuilder: (context, i) {
                                          return Column(
                                            children: [
                                              InkWell(
                                                child :
                                                snapshot.data![i]["g"].toString() == 'Canceled'?
                                                Opacity(
                                                  opacity: 0.5,
                                                  child: ListTile(
                                                      visualDensity: VisualDensity(horizontal: -2),
                                                      dense : true,
                                                      title: Opacity(
                                                          opacity: 0.9,
                                                          child:
                                                          Padding(padding: EdgeInsets.only(top: 2),child:
                                                          Text(snapshot.data![i]["b"].toString(),
                                                            overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 14.5),),)
                                                      ),
                                                      subtitle: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 5),
                                                            child:   Align(alignment: Alignment.centerLeft,child:
                                                            Text(
                                                                AppHelper().getTanggalCustom(snapshot.data![i]["c"].toString()) + " "+
                                                                    AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["c"].toString()) + " "+
                                                                    AppHelper().getTahunCustom(snapshot.data![i]["c"].toString())+
                                                                    " - "+
                                                                    AppHelper().getTanggalCustom(snapshot.data![i]["d"].toString()) + " "+
                                                                    AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["d"].toString()) + " "+
                                                                    AppHelper().getTahunCustom(snapshot.data![i]["d"].toString())+
                                                                    " ("+snapshot.data![i]["f"].toString()+" Hari"+")",
                                                                overflow: TextOverflow.ellipsis,
                                                                style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),),
                                                          ),

                                                          Padding(
                                                              padding: EdgeInsets.only(top: 2),
                                                              child: Align(alignment: Alignment.centerLeft,
                                                                  child:Text("#"+snapshot.data![i]["e"].toString(),
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: GoogleFonts.varelaRound(fontSize: 13)))),
                                                        ],
                                                      ),
                                                      trailing:
                                                      snapshot.data![i]["g"].toString() != 'Fully Approved' ?
                                                      Opacity(
                                                        opacity: 0.9,
                                                        child: Container(
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 0,
                                                              backgroundColor: snapshot.data![i]["g"].toString() == 'Pending'? Colors.black54 :
                                                              snapshot.data![i]["g"].toString() == 'Approved 1' ? HexColor("#0074D9")  :
                                                              HexColor("#FF4136"),
                                                            ),
                                                            child: Text(snapshot.data![i]["g"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                                color: snapshot.data![i]["g"].toString() == 'Pending'? Colors.white :
                                                                snapshot.data![i]["g"].toString() == 'Approved 1' ? Colors.white :
                                                                Colors.white,fontWeight: FontWeight.bold),),
                                                            onPressed: (){},
                                                          ),
                                                          height: 25,
                                                        ),
                                                      ) :  Padding(padding: EdgeInsets.only(right: 5),
                                                        child: FaIcon(FontAwesomeIcons.circleCheck,color: HexColor("#3D9970"),size: 27,),)
                                                  ),
                                                ) :
                                                ListTile(
                                                    visualDensity: VisualDensity(horizontal: -2),
                                                    dense : true,
                                                    title: Opacity(
                                                        opacity: 0.9,
                                                        child:
                                                        Padding(padding: EdgeInsets.only(top: 2),child:
                                                        Text(snapshot.data![i]["b"].toString(),
                                                          overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                              fontWeight: FontWeight.bold,fontSize: 14.5),),)
                                                    ),
                                                    subtitle: Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 5),
                                                          child:   Align(alignment: Alignment.centerLeft,child:
                                                          Text(
                                                              AppHelper().getTanggalCustom(snapshot.data![i]["c"].toString()) + " "+
                                                                  AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["c"].toString()) + " "+
                                                                  AppHelper().getTahunCustom(snapshot.data![i]["c"].toString())+
                                                                  " - "+
                                                                  AppHelper().getTanggalCustom(snapshot.data![i]["d"].toString()) + " "+
                                                                  AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["d"].toString()) + " "+
                                                                  AppHelper().getTahunCustom(snapshot.data![i]["d"].toString())+
                                                                  " ("+snapshot.data![i]["f"].toString()+" Hari"+")",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),),
                                                        ),

                                                        Padding(
                                                            padding: EdgeInsets.only(top: 2),
                                                            child: Align(alignment: Alignment.centerLeft,
                                                                child:Text("#"+snapshot.data![i]["e"].toString(),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: GoogleFonts.varelaRound(fontSize: 13)))),
                                                      ],
                                                    ),
                                                    trailing:
                                                    snapshot.data![i]["g"].toString() != 'Fully Approved' ?
                                                    Opacity(
                                                      opacity: 0.9,
                                                      child: Container(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            elevation: 0,
                                                            backgroundColor: snapshot.data![i]["g"].toString() == 'Pending'? Colors.black54 :
                                                            snapshot.data![i]["g"].toString() == 'Approved 1' ? HexColor("#0074D9")  :
                                                            HexColor("#FF4136"),
                                                          ),
                                                          child: Text(snapshot.data![i]["g"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                              color: snapshot.data![i]["g"].toString() == 'Pending'? Colors.white :
                                                              snapshot.data![i]["g"].toString() == 'Approved 1' ? Colors.white :
                                                              Colors.white,fontWeight: FontWeight.bold),),
                                                          onPressed: (){},
                                                        ),
                                                        height: 25,
                                                      ),
                                                    ) :  Padding(padding: EdgeInsets.only(right: 5),
                                                      child: FaIcon(FontAwesomeIcons.circleCheck,color: HexColor("#3D9970"),size: 27,),)
                                                ),
                                                onTap: (){
                                                  EasyLoading.show(status: AppHelper().loading_text);
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                 widget.getType == 'Request' ?
                                                  Navigator.push(context, ExitPage(page: BertugasDetail(snapshot.data![i]["i"].toString(), widget.getKaryawanNo))).then(onGoBack)
                                                      :
                                                  Navigator.push(context, ExitPage(page: BertugasDetailAppr(snapshot.data![i]["i"].toString(), widget.getKaryawanNo))).then(onGoBack); //_changeLocation(snapshot.data![i]["a"].toString());
                                                  //_changeLocation(snapshot.data![i]["a"].toString());
                                                },
                                                onLongPress: () {
                                                  snapshot.data![i]["g"].toString() == 'Canceled' ?
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
                            },
                          )
                      ),
                    )
                )
              ],
            )

        ),);
  }

}

