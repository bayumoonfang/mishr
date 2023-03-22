

import 'package:abzeno/Bertugas/page_bertugas-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class PageBertugasListHome extends StatefulWidget {
  final String getKaryawanNo;
  const PageBertugasListHome(this.getKaryawanNo);
  @override
  _PageBertugasListHome createState() => _PageBertugasListHome();
}


class _PageBertugasListHome extends State<PageBertugasListHome> with SingleTickerProviderStateMixin {

  late TabController controller;


  showInfoDialog(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue,
          fontSize: textScale.toString() == '1.17' ? 13 : 15),),
      onPressed:  () {Navigator.pop(context);},
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text("Informasi",
        style: GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 16 : 18,fontWeight: FontWeight.bold),textAlign:
        TextAlign.left,),
      content: Container(
          height: 65,
          child : Column(
            children: [
              Text("Ini adalah adalah menu untuk melihat daftar pengajuan dan approval untuk bertugas anda",
                style: GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 13 : 15),textAlign:
                TextAlign.left,),
            ],
          )
      ),
      actions: [
        cancelButton,
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
    controller = new TabController(vsync: this, length: 2);
    EasyLoading.dismiss();
  }


  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar : new AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        title: Text("Pengajuan Bertugas", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.black,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),
        actions: [
          Container(
              width: 50,
              height: 50,
              child :
              Padding(
                padding: EdgeInsets.only(top: 17,right: 22),
                child: InkWell(
                  child : FaIcon(FontAwesomeIcons.circleInfo,color: HexColor("#535967"),size: 22,),
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    showInfoDialog(context);
                  },
                ),))
        ],
        bottom: new TabBar(
          indicatorColor: Colors.black,
          controller: controller,
          labelColor: Colors.black,
          labelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
          unselectedLabelStyle: GoogleFonts.varelaRound(fontSize: 13,color: Colors.black),
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            new Tab(text: "My Request"),
            new Tab(text: "Approval"),
          ],
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          PageBertugasList(widget.getKaryawanNo, "Request"),
          PageBertugasList(widget.getKaryawanNo, "Approve"),
        ],
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