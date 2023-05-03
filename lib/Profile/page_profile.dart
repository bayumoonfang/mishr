


import 'dart:convert';

import 'package:abzeno/ApprovalList/page_approvallist.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/m_helper.dart';
import 'package:abzeno/Profile/S_HELPER/g_profile.dart';
import 'package:abzeno/Profile/S_HELPER/m_profile.dart';
import 'package:abzeno/Profile/page_aboutus.dart';
import 'package:abzeno/Profile/page_changepin.dart';
import 'package:abzeno/Profile/page_fullprofile.dart';
import 'package:abzeno/helper/page_route.dart';
import 'package:abzeno/page_intoduction.dart';
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

import 'package:steps/steps.dart';
import 'package:unicons/unicons.dart';

import '../My Team/page_myteam.dart';


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
    await _get_ApprovalDaftar();
    await _getPhoto();
    getSettings();
    getVersion();

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
      preferences.setString("karyawan_jabatan", '');
      preferences.setString("decode_pin", '');
      preferences.commit();
      _clearallpref();
    });
  }




  showDialogLogout(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"?  "LOG OUT":"APPROVE"
          ,style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _logout();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Konfirmasi Log Out" :"Approve Request"
        , style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
        TextAlign.left,),
      content: Text("Apakah anda yakin keluar dari akun anda ? "
        , style: GoogleFonts.nunitoSans(),textAlign:
        TextAlign.left,),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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

  String appr1_name = "...";
  String appr2_name = "...";
  String appr3_name = "...";
  String appr1_jabatan = "...";
  String appr2_jabatan = "...";
  String appr3_jabatan = "...";
  _get_ApprovalDaftar() async {
    await g_profile().getdata_approvaldaftar(widget.getKaryawanNo).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          appr1_name = value[0];
          appr1_jabatan = value[1];
          appr2_name = value[2];
          appr2_jabatan = value[3];
          appr3_name = value[4];
          appr3_jabatan = value[5];
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
  _review_create() async {
    await m_helper().review_create(_ulasanController.text, widget.getKaryawanNo, widget.getKaryawanNama);
    setState(() {
      _ulasanController.clear();
      _ulasanController.text = '';
    });
  }

  TextEditingController _ulasanController = TextEditingController();
  showDialogme(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    if (_ulasanController.text == '') {
      AppHelper().showFlushBarsuccess(context, "Kritik dan saran tidak boleh kosong");
      return false;
    }

    Widget cancelButton = TextButton(
      child: Text(
        getBahasa.toString() == "1" ? "TUTUP" : "CLOSE",
        style: GoogleFonts.lexendDeca(color: Colors.blue,fontSize: textScale.toString() == '1.17' ? 13 : 15),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget continueButton = Container(
      width: 120,
      child: TextButton(
        child: Text(
          getBahasa.toString() == "1" ? "POST" : "POST",
          style: GoogleFonts.lexendDeca(
              color: Colors.blue,
              fontSize: textScale.toString() == '1.17' ? 13 : 15
          ),
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          Navigator.pop(context);
          Navigator.pop(context);
          AppHelper().showFlushBarconfirmed(context, "Kritik dan saran berhasil diposting");
          _review_create();
        },
      ),
    );


    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        getBahasa.toString() == "1" ? "Posting Kritik dan Saran" : "Add Review",
        style:
        GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 16 : 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      content: Text(
        getBahasa.toString() == "1"
            ? "Apakah anda yakin memposting kritik dan saran ini ?"
            : "Would you like to continue add review ?",
        style: GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 13 : 15),
        textAlign: TextAlign.left,
      ),
      actions: [
        cancelButton,
        continueButton,
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
                         leading: Icon(UniconsLine.user_square,size: 25),
                         title: Text(getBahasa.toString() == "1" ? "Profil Saya" : "My Profile", style: GoogleFonts.nunitoSans(fontSize: 16,fontWeight: FontWeight.bold),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Detail penuh profil saya" : "Full Detail of my profile", style: GoogleFonts.nunito(fontSize: 12),),
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
                         leading:  Icon(UniconsLine.user_check,size: 25),
                         title: Text(getBahasa.toString() == "1" ? "Approval List":"About Us", style: GoogleFonts.nunitoSans(fontSize: 16,fontWeight: FontWeight.bold),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Lihat daftar approval untuk ijin kamu": "All About Us", style: GoogleFonts.nunito(fontSize: 12),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
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
                                             Text(getBahasa.toString() == "1"? "Daftar Persetujuan" :"Approval List",
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
                                           child: Divider(height: 2,),
                                         ),
                                         Container(
                                             width: double.infinity,
                                             height: MediaQuery.of(context).size.height * 0.30,
                                             child:
                                             Steps(
                                               direction: Axis.vertical,
                                               size: 10.0,
                                               path: {
                                                 'color': HexColor("#DDDDDD"),
                                                 'width': 1.0},
                                               steps: [
                                                 {
                                                   'color': Colors.white,
                                                   'background': HexColor("#00aa5b"),
                                                   'label': '1',
                                                   'content': Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: <Widget>[
                                                       Text(appr1_name.toString(),style: GoogleFonts.montserrat(
                                                           fontWeight: FontWeight.bold,fontSize: 15),
                                                         overflow: TextOverflow.ellipsis,),
                                                       Padding(
                                                         padding: EdgeInsets.only(top:5),
                                                         child: Text("Jabatan : "+appr1_jabatan.toString(),style: GoogleFonts.nunitoSans(fontSize: 13)),
                                                       ),
                                                       Padding(
                                                         padding: EdgeInsets.only(top:2),
                                                         child: Text("as Approval 1",style: GoogleFonts.nunitoSans(fontSize: 13)),
                                                       ),
                                                     ],
                                                   ),
                                                 },

                                                 {
                                                   'color': Colors.white,
                                                   'background': HexColor("#00aa5b"),
                                                   'label': '2',
                                                   'content': Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: <Widget>[
                                                       Text(appr3_name.toString(),style: GoogleFonts.montserrat(
                                                           fontWeight: FontWeight.bold,fontSize: 15),
                                                         overflow: TextOverflow.ellipsis,),
                                                       Padding(
                                                         padding: EdgeInsets.only(top:5),
                                                         child: Text("Jabatan : "+appr3_jabatan.toString(),style: GoogleFonts.nunitoSans(fontSize: 13)),
                                                       ),
                                                       Padding(
                                                         padding: EdgeInsets.only(top:2),
                                                         child: Text("as Approval 2",style: GoogleFonts.nunitoSans(fontSize: 13)),
                                                       ),

                                                     ],
                                                   ),
                                                 },



                                               ],

                                             )),


                                       ],
                                     ),
                                   ),
                                 )
                             );
                           });
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
                         leading: Icon(UniconsLine.users_alt,size: 25,),
                         title: Text(getBahasa.toString() == "1" ?  "My Team" : "Change PIN", style: GoogleFonts.nunitoSans(fontSize: 16,fontWeight: FontWeight.bold),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Kenal lebih lanjut dengan tim kamu":"Change my PIN for better security", style: GoogleFonts.nunito(fontSize: 12),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: PageMyTeam(widget.getKaryawanNo)));
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
                         leading: Icon(UniconsLine.lock_access,size: 25),
                         title: Text(getBahasa.toString() == "1" ?  "Ubah PIN" : "Change PIN", style: GoogleFonts.nunitoSans(fontSize: 16,fontWeight: FontWeight.bold),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Ubah PIN untuk keamanan lebih":"Change my PIN for better security", style: GoogleFonts.nunito(fontSize: 12),),
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
                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: Icon(UniconsLine.comment_add,size: 25),
                         title: Text("Kritik dan Saran", style: GoogleFonts.nunitoSans(fontSize: 16,fontWeight: FontWeight.bold),),
                         subtitle: Text("Kirim kritik dan saran kamu", style: GoogleFonts.nunito(fontSize: 12),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
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
                               child: Container(
                                   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                   child : Padding(
                                     padding: EdgeInsets.only(left: 25,right: 25,top: 25),
                                     child: Column(
                                       children: [

                                         Padding(
                                           padding: EdgeInsets.only(top: 15,bottom: 15),
                                           child: TextFormField(
                                             style: GoogleFonts.nunitoSans(fontSize: 16),
                                             textCapitalization: TextCapitalization
                                                 .sentences,
                                             maxLines: 4,
                                             controller: _ulasanController,
                                             decoration: InputDecoration(
                                               prefixIcon: Padding(
                                                 padding: const EdgeInsets.only(right: 10),
                                                 child: Icon(UniconsLine.text_fields,size: 30,),
                                               ),
                                               contentPadding: const EdgeInsets.only(
                                                   top: 2),
                                               hintText: 'Tulis kritik dan saran kamu',
                                               labelText: 'Kritik dan Saran',
                                               labelStyle: TextStyle(
                                                   fontFamily: "VarelaRound",
                                                   fontSize: 16.5, color: Colors.black87
                                               ),
                                               floatingLabelBehavior: FloatingLabelBehavior
                                                   .always,
                                               hintStyle: GoogleFonts.nunito(
                                                   color: HexColor("#c4c4c4"),
                                                   fontSize: 15),
                                               enabledBorder: UnderlineInputBorder(
                                                 borderSide: BorderSide(
                                                     color: HexColor("#DDDDDD")),
                                               ),
                                               focusedBorder: UnderlineInputBorder(
                                                 borderSide: BorderSide(
                                                     color: HexColor("#8c8989")),
                                               ),
                                               border: UnderlineInputBorder(
                                                 borderSide: BorderSide(
                                                     color: HexColor("#DDDDDD")),
                                               ),
                                             ),

                                           ),
                                         ),

                                         Padding(
                                             padding: EdgeInsets.only(top:15,bottom: 15),
                                             child: Container(
                                               width: double.infinity,
                                               height: 50,
                                               child: ElevatedButton(
                                                 child: Text(getBahasa.toString() == "1"? "Kirim" : "Send Review",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                     fontSize: 14)),
                                                 onPressed: (){
                                                   showDialogme(context);
                                                 },
                                               ),
                                             )
                                         )
                                       ],
                                     ),
                                   )
                               ),
                             );
                           }
                       );
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
                   ),
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
                   ),*/

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
                         leading: Icon(UniconsLine.info_circle,size: 25),
                         title: Text(getBahasa.toString() == "1" ? "Tentang Kami":"About Us", style: GoogleFonts.nunitoSans(fontSize: 16,fontWeight: FontWeight.bold),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Semua Tentang Kami": "All About Us", style: GoogleFonts.nunito(fontSize: 12),),
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
                          showDialogLogout(context);

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