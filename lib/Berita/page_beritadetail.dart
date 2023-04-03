



import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Inbox/S_HELPER/m_inbox.dart';
import 'package:abzeno/Notification/S_HELPER/m_notification.dart';
import 'package:abzeno/Notification/page_notificationspecific.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Time Off/page_DetailFileAttendanceReq.dart';
class PageBeritaDetail extends StatefulWidget{
  final String getTittle;
  final String getMessage;
  final String getDate;
  final String getMessageID;
  final String getAttachment;
  const PageBeritaDetail(this.getTittle, this.getMessage, this.getDate, this.getMessageID, this.getAttachment);
  @override
  _PageBeritaDetail createState() => _PageBeritaDetail();
}


class _PageBeritaDetail extends State<PageBeritaDetail> {

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }



  _read_pesanpribadi() async {
    EasyLoading.show(status: AppHelper().loading_text);
    await m_inbox().pesanpribadi_read(widget.getMessageID).then((value){
      if(value[0] == 'ConnInterupted'){
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...");
        return false;
      }
    });
  }


  @override
  void initState() {
    super.initState();
    getSettings();
    _read_pesanpribadi();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1" ? 'Detail Berita' : 'Reprimand Detail', style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
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
        padding: EdgeInsets.only(left: 25,right: 25,top: 20),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child : Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(widget.getTittle, style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold),),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Text(widget.getDate, style: GoogleFonts.workSans(fontSize: 13,color: Colors.black),),
                        widget.getAttachment.isNotEmpty ?
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("-"),
                        ) : Container(),
                        widget.getAttachment.isNotEmpty ?
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: FaIcon(FontAwesomeIcons.paperclip,size: 14,color: Colors.blue),
                        ) : Container(),
                        widget.getAttachment.isNotEmpty ?
                        InkWell(
                          onTap: (){
                            Navigator.push(context, ExitPage(page: DetailImageAttRequest(widget.getAttachment)));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(getBahasa.toString() == "1" ? "Lihat Berkas":"View Attachment", style: GoogleFonts.workSans(fontSize: 13,color: Colors.blue),),
                          ),
                        ) : Container()
                      ],
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Divider(height: 5,),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(top: 25,bottom: 30),
                    child:
                    HtmlWidget(widget.getMessage)
                  //Text(widget.getMessage, style: GoogleFonts.workSans(fontSize: 14,color: Colors.black,height: 1.8,wordSpacing: 2),),

                ),
              )
            ],
          ),
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