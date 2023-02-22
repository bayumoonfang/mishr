


import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Profile/S_HELPER/m_profile.dart';
import 'package:abzeno/Profile/page_aboutus.dart';
import 'package:abzeno/Profile/page_activity.dart';
import 'package:abzeno/Profile/page_attendancehistory.dart';
import 'package:abzeno/Profile/page_changepin.dart';
import 'package:abzeno/Profile/page_fullprofile.dart';
import 'package:abzeno/helper/page_route.dart';
import 'package:abzeno/page_intoduction.dart';
import 'package:abzeno/page_login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';


class Profile extends StatefulWidget{
  final String getKaryawanNama;
  final String getKaryawanJabatan;
  final String getKaryawanNo;
  const Profile(this.getKaryawanNama, this.getKaryawanJabatan, this.getKaryawanNo);
  @override
  _Profile createState() => _Profile();
}


class _Profile extends State<Profile>{

  String getBahasa = "1";
  String getToken = "0";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
        getToken = value[23];
      });});
  }



  String versionVal = '...';
  String codeVal = '...';
  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      String version = packageInfo.version;
      String code = packageInfo.buildNumber;
      versionVal = version;
      codeVal = code;
    });
  }

  String photo_path = "";
  _getPhoto() async {
    await m_profile().getPhoto(widget.getKaryawanNo).then((value){
      setState(() {
        photo_path = value[0];
      });});
  }


  _loaddata() async {
    await _getPhoto();
    await getSettings();
    await getVersion();
    EasyLoading.dismiss();
  }

  void initState() {
    super.initState();
    _loaddata();
  }

  _clearallpref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushReplacement(context, ExitPage(page: Introduction(getToken)));
  }

  _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("email", '');
      preferences.setString("username", '');
      preferences.setString("karyawan_id", '');
      preferences.setString("karyawan_nama", '');
      preferences.setString("karyawan_no", '');
      preferences.commit();
      _clearallpref();
    });
  }


  _profile_changephoto() async {
    EasyLoading.show(status: AppHelper().loading_text);
    await m_profile().profile_changephoto(widget.getKaryawanNo, Base64).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          if (value[0] == '1') {
            AppHelper().showFlushBarsuccess(context, "Photo berhasil dirubah");
            _loaddata();
          }
        });
      }
    });
  }



  clearPhoto() async {
    EasyLoading.show(status: AppHelper().loading_text);
    await m_profile().clearPhoto(widget.getKaryawanNo).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          if (value[0] == '1') {
            AppHelper().showFlushBarsuccess(context, "Photo berhasil dihapus");
            _loaddata();
          }
        });
      }
    });
  }


  String fileName = "";
  var Base64;
  imageSelectorGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 5243194) {
        AppHelper().showFlushBarerror(context, "File tidak boleh lebih dari 5 MB");
        return false;
      } else {
        final file = result.files.first;
        final bytes = File(file.path!).readAsBytesSync();
        setState(() {
          fileName = file.name;
          Base64 = base64Encode(bytes);
        });
        _profile_changephoto();
      }}else{}
  }


  Offset _tapPosition = Offset.zero;
  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
    Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        context: context,

        // Show the context menu at the tap location
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        // set a list of choices for the context menu
        items: [
          const PopupMenuItem(
            value: '1',
            child: Text('Clear Avatar',style: TextStyle(fontFamily: 'VarelaRound',fontSize: 16),),
          ),
          const PopupMenuItem(
            value: '2',
            child: Text('Change Avatar',style: TextStyle(fontFamily: 'VarelaRound',fontSize: 15),),
          ),
        ]);

    // Implement the logic for each choice here
    switch (result) {
      case '1':
        clearPhoto();
        break;
      case '2':
        imageSelectorGallery();
        break;
    }
  }

  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: onWillPop, child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(bottom:15,top: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
             Padding(
               padding: const EdgeInsets.only(right: 25),
               child:  Align(alignment: Alignment.topRight,
                 child:
                 GestureDetector(
                   onTapDown: (details){
                     _getTapPosition(details);
                   },
                   onTap: (){
                     _showContextMenu(context);
                   },
                   child:
                Container(
                  width: 20,
                  child:  FaIcon(FontAwesomeIcons.ellipsisVertical,size: 19,),
                ),)),
             ),
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25,bottom: 20),
                child:   ListTile(
                  leading: SizedBox(
                        width: 55,
                        height: 55,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                            photo_path == '' || photo_path == 'null' ?
                            applink+"assets/file_upload/fotokaryawan/user.png"
                                :
                            applink+"assets/file_upload/fotokaryawan/"+photo_path,
                            progressIndicatorBuilder: (context, url,
                                downloadProgress) =>
                                CircularProgressIndicator(value:
                                downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                  ),
                  title: Text(widget.getKaryawanNama, style: GoogleFonts.nunitoSans(fontSize: 17),),
                  subtitle: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft,child:
                      Text(widget.getKaryawanJabatan, style: GoogleFonts.nunitoSans(fontSize: 14),),)
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 6,
                padding: const EdgeInsets.only(top: 50),
                color: HexColor("#f5f5f5"),
              ),


             Container(
               padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
               child: Column(
                 children: [
                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.user,size: 24,color : HexColor("#5ebef0")),
                         title: Text(getBahasa.toString() == "1" ? "Profil Saya" : "My Profile", style: GoogleFonts.nunito(fontSize: 16),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Detail penuh profil saya" : "Full Detail of my profile", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: PageFullProfile(widget.getKaryawanNo)));
                     },
                   ),

                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),
                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.lock,color : HexColor("#e28743")),
                         title: Text(getBahasa.toString() == "1" ?  "Ubah PIN" : "Change PIN", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Ubah PIN untuk keamanan lebih":"Change my PIN for better security", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: ChangePIN(widget.getKaryawanNo)));
                     },
                   ),

                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),
                  /* InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.penToSquare,color : HexColor("#3bc188")),
                         title: Text("My Approval", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text("My list need my approval", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){},
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),
                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.bullhorn,color : HexColor("#f6706a")),
                         title: Text("My Activity", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text("My Daily activity", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: MyActivity(widget.getKaryawanNo)));
                     },
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),*/
                   Opacity(
                     opacity: 0.4,
                     child: InkWell(
                       child : Padding(
                         padding: const EdgeInsets.only(bottom: 5),
                         child: ListTile(
                           minLeadingWidth : 25,
                           dense:true,
                           contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                           leading: FaIcon(FontAwesomeIcons.laptopFile,color : HexColor("#ffa427")),
                           title: Text(getBahasa.toString() == "1" ? "Histori Karir": "Career History", style: GoogleFonts.nunitoSans(fontSize: 16),),
                           subtitle: Text(getBahasa.toString() == "1" ? "Histori karir saya" : "My Career History", style: GoogleFonts.nunito(fontSize: 13),),
                           trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                         ),
                       ),
                       onTap: (){},
                     ),
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),

                   /* InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.clock,color : HexColor("#b35ef6")),
                         title: Text("Attendance History", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text("All My Attendance History", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: AttendanceHistory(widget.getKaryawanNo)));
                     },
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),

                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.clipboardList,color : HexColor("#622df7")),
                         title: Text("My Schedule", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text("All My Shift Schedule", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){},
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),*/

                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.infoCircle,color : HexColor("#3ad3e1")),
                         title: Text(getBahasa.toString() == "1" ? "Tentang Kami":"About Us", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Semua Tentang Kami": "All About Us", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: AboutUs()));
                     },
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),

                  Padding(padding: EdgeInsets.only(top: 30),child:  Container(
                      padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                      width: double.infinity,
                      height: 55,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: HexColor("#fc6e67"),
                            elevation: 0,
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.white,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        child: Text("Logout"),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _logout();
                        },
                      )
                  ),),

                  Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Center(
                       child: Text("Version "+versionVal+ " build "+codeVal, style: GoogleFonts.workSans(fontSize: 13)),
                     ),
                   ),
                 ],
               ),
             )
            ],
          ),
        ),
      ),
    ));
  }

  Future<bool> onWillPop() async {
    try {
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

}