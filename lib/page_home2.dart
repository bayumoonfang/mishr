import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';
import 'package:abzeno/Bertugas/page_bertugashome.dart';
import 'package:abzeno/Helper/g_helper.dart';
import 'package:abzeno/Time%20Off/S_HELPER/g_timeoff.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_location/trust_location.dart';
import 'package:abzeno/Profile/page_changepin.dart';
import 'package:abzeno/page_changecabang.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_device/safe_device.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Attendance/page_attendancelembur.dart';
import 'Berita/page_berita.dart';
import 'Helper/m_helper.dart';
import 'Lembur/page_lemburhome.dart';
import 'My Team/page_myteam.dart';
import 'MySchedule/page_myschedule2.dart';
import 'Report/page_report.dart';
import 'Reprimand/page_reprimand.dart';
import 'Request Attendance/page_attendancehome.dart';
import 'Setting/page_biometricsetting.dart';
import 'Setting/page_setting.dart';
import 'Time Off/page_timeoffhome2a.dart';
import 'helper/app_helper.dart';
import 'helper/app_link.dart';
import 'helper/page_route.dart';
import 'attendance/page_attendance.dart';

class Home2 extends StatefulWidget {
  final String getKaryawanNama;
  final String getKaryawanJabatan;
  final String getKaryawanNo;
  final String getScheduleName;
  final String getStartTime;
  final String getEndTime;
  final String getScheduleID;
  final String getJamMasukSebelum;
  final String getJamKeluarSebelum;
  final String getPIN;
  final String getScheduleBtn;
  final String getKaryawanEmail;
  final Function runLoopMe;
  const Home2(
      this.getKaryawanNama,
      this.getKaryawanJabatan,
      this.getKaryawanNo,
      this.getScheduleName,
      this.getStartTime,
      this.getEndTime,
      this.getScheduleID,
      this.getJamMasukSebelum,
      this.getJamKeluarSebelum,
      this.getPIN,
      this.getScheduleBtn,
      this.getKaryawanEmail,
      this.runLoopMe);

  @override
  _Home2 createState() => _Home2();
}

class _Home2 extends State<Home2> with AutomaticKeepAliveClientMixin<Home2> {
  @override
  bool get wantKeepAlive => true;
  bool _isVisibleBtn = false;
  var getJam = DateFormat('HH:mm').format(DateTime.now());
  PushNotification? _notificationInfo;


  String getWorkLocation = "...";
  String getWorkLocationId = "...";
  String getWorkLong = "...";
  String getWorkLat = "...";
  String pressBtnSemua = "1";
  String pressBtnCuti = "0";
  String pressBtnKehadiran = "0";
  String pressBtnInformasi = "0";

  String getBahasa = "1";
  String getNationalDay = "";
  getSettings() async {
    await AppHelper().getSession().then((value) {
      setState(() {
        getBahasa = value[20];
      });
    });
    /* await AppHelper().getNationalDay(AppHelper().getNamaBulanToday).then((value){
      setState(() {
        getNationalDay = value[0];
      });});*/
  }

  showVersionDialog(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
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
          getBahasa.toString() == "1" ? "UPDATE NOW" : "UPDATE NOW",
          style: GoogleFonts.lexendDeca(
            color: Colors.blue,
              fontSize: textScale.toString() == '1.17' ? 13 : 15
          ),
        ),
        onPressed: () {
          //Navigator.pop(context);
          if (Platform.isAndroid) {
            final appId =
                Platform.isAndroid ? 'com.Android.mishr' : 'YOUR_IOS_APP_ID';
            final url = Uri.parse(
              Platform.isAndroid
                  ? "https://play.google.com/store/apps/details?id=$appId"
                  : "https://apps.apple.com/app/id$appId",
            );
            launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        getBahasa.toString() == "1"
            ? "Perbarui Versi ?"
            : "New Version Available",
        style:
            GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 16 : 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      content: Container(
          height: textScale.toString() == '1.17' ? 140 : 150,
          child: Column(
            children: [
              Text(
                "Versi terbaru untuk aplikasi MISHR sudah tersedia ! Untuk versi terbaru adalah " +
                    getFullVersionNew +
                    ", sedangkan versi anda saat ini adalah " +
                    getFullVersionExisting,
                style: GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 13 : 15),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Apakah anda ingin memperbarui ?",
                  style: GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 13 : 15),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          )),
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


  showBiometricDialog(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    Widget cancelButton = TextButton(
      child: Text(
        getBahasa.toString() == "1" ? "LEWATI" : "CLOSE",
        style: GoogleFonts.lexendDeca(color: Colors.blue,fontSize: textScale.toString() == '1.17' ? 13 : 15),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = Container(
      width: 150,
      child: TextButton(
        child: Text(
          getBahasa.toString() == "1" ? "COBA SEKARANG" : "UPDATE NOW",
          style: GoogleFonts.lexendDeca(
              color: Colors.blue,
              fontSize: textScale.toString() == '1.17' ? 13 : 15
          ),
        ),
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("biometric_dialog", "0");
          Navigator.pop(context);
          Navigator.push(context, ExitPage(page: PageBiometricSetting()));
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        getBahasa.toString() == "1"
            ? "Fitur Baru"
            : "New Version Available",
        style:
        GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 16 : 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      content: Container(
          height: textScale.toString() == '1.17' ? 140 : 150,
          child: Column(
            children: [
              Text(
                "Cobain fitur terbaru misHR, Fingerscan dan Passcode. Tingkatkan keamaan akun kamu dengan mengaktifkan fitur ini. Ayo cobain sekarang",
                style: GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 13 : 15),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Apakah anda ingin mencoba fitur ini ?",
                  style: GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 13 : 15),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          )),
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



  String getFullVersionNew = "";
  String getVersionNew = "";
  String getFullVersionExisting = "";
  String getVersionExisting = "";
  CekVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String code = packageInfo.buildNumber;
    await AppHelper().getNewVersion2().then((value) {
      setState(() {

        if(Platform.isIOS) {
          getFullVersionNew = value[2] + " build " + value[3];
          getVersionNew = value[2];
          getFullVersionExisting = version + " build " + code;
          getVersionExisting = version;
        } else {
          getFullVersionNew = value[0] + " build " + value[1];
          getVersionNew = value[0];
          getFullVersionExisting = version + " build " + code;
          getVersionExisting = version;
        }

        //String getVersion = version+ " build "+code;

        if (getFullVersionExisting != getFullVersionNew) {
          // getNewVersion = value[0];
          //getNewVersion = version;
          //getVersionExisting = version+ " build "+code;
          showVersionDialog(context);
        }
      });
    });
  }

  refreshworklocation() async {
    await AppHelper().getWorkLocation().then((value) {
      setState(() {
        getWorkLocation = value[0];
        getWorkLocationId = value[1];
        getWorkLat = value[2];
        getWorkLong = value[3];
      });
    });
  }

  String getJamMasuk = "...";
  String getJamKeluar = "...";
  refreshAttendance() async {
    await AppHelper().getAttendance().then((value) {
      setState(() {
        getJamMasuk = value[0];
        getJamKeluar = value[1];
        EasyLoading.dismiss();
      });
    });
  }

  String getPINq = '...';
  getDefaultPass() async {
    await AppHelper().getDetailUser();
    await AppHelper().getSession().then((value) {
      setState(() {
        getPINq = value[18];
      });
    });
  }

  String getCountLembur = '0';
  String getClockInLembur = '00:00:00';
  String getClockOutLembur = '00:00:00';
  String getScheduleClockInLembur = '00:00:00';
  String getScheduleClockOutLembur = '00:00:00';
  getLemburCount() async {
    await AppHelper().getLemburDetail().then((value) {
      setState(() {
        getCountLembur = value[0];
        getScheduleClockInLembur = value[1];
        getScheduleClockOutLembur = value[2];
        getClockInLembur = value[3];
        getClockOutLembur = value[4];

      });
    });
  }

  String getSpecialday_name = '0';
  String getSpecialday_tagline = '...';
  String getSpecialday_banner = '0';
  getSpecialDay() async {
    await AppHelper().getSpecialDay().then((value) {
      setState(() {
        getSpecialday_name = value[0];
        getSpecialday_tagline = value[1];
        getSpecialday_banner = value[2];
      });
    });
  }

  String getbiometric_dialog = '0';
  cekBiometricDialog() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getbiometric_dialog = value[28];
      });});
  }


  Timer? timer;

  loadData() async {
    await getSpecialDay();
    await refreshworklocation();
    await refreshAttendance();
    await CekVersion();
    await cekBiometricDialog();
     //getLemburCount();
     getSettings();
     getDefaultPass();

    setState(() {
      widget.runLoopMe();
      _isVisibleBtn = true;
      if(getbiometric_dialog == "1" || getbiometric_dialog == null) {
        showBiometricDialog(context);
      }
    });
  }

  TextEditingController _ulasanController = TextEditingController();

  _review_create() async {
    await m_helper()
        .review_create(_ulasanController.text, widget.getKaryawanNo, widget.getKaryawanNama);
  }

  showDialogme(BuildContext context) {
    if (_ulasanController.text == '') {
      getBahasa.toString() == "1"
          ? AppHelper()
              .showFlushBarsuccess(context, "Ulasan tidak boleh kosong")
          : AppHelper().showFlushBarsuccess(context, "Review cant be empty");
      return false;
    }

    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: GoogleFonts.lexendDeca(color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        style: ElevatedButton.styleFrom(
            primary: HexColor("#1a76d2"),
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.white, width: 0.1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(5.0),
            )),
        child: Text(
          getBahasa.toString() == "1" ? "Iya" : "Yes",
          style: GoogleFonts.lexendDeca(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          Navigator.pop(context);
          Navigator.pop(context);
          getBahasa.toString() == "1"
              ? AppHelper()
                  .showFlushBarsuccess(context, "Ulasan berhasil diposting")
              : AppHelper()
                  .showFlushBarsuccess(context, "Review has been posted");
          _review_create();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        getBahasa.toString() == "1" ? "Tambah Ulasan" : "Add Review",
        style:
            GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Text(
        getBahasa.toString() == "1"
            ? "Apakah anda yakin memposting ulasan ini ?"
            : "Would you like to continue add review ?",
        style: GoogleFonts.varelaRound(),
        textAlign: TextAlign.center,
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

  FutureOr onGoBack(dynamic value2) {
    refreshworklocation();
    getDefaultPass();
  }

  FutureOr onGoBack2(dynamic value2) {
    setState(() {
      widget.runLoopMe();
    });
  }

  void runLoopMe() async {
    setState(() {
      getJam = DateFormat('HH:mm').format(DateTime.now());
    });
  }

  bool scroll_visibility = true;
  @override
  void initState() {
    /*scrollcontroller.addListener(() {
      if (scrollcontroller.position.pixels > 0) {
        setState(() {
          scroll_visibility = false;
        });
      } else {
        setState(() {
          scroll_visibility = true;
        });
      }
    });*/
    super.initState();
    loadData();
  }

  Future refreshData() async {
    setState(() {
      EasyLoading.show(status: AppHelper().loading_text);
      loadData();
    });
  }

  showInvalidDateTimeSettingDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        getBahasa.toString() == "1" ? "Tutup" : "Close",
        style: GoogleFonts.lexendDeca(color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        style: ElevatedButton.styleFrom(
            primary: HexColor("#1a76d2"),
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.white, width: 0.1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(5.0),
            )),
        child: Text(
          getBahasa.toString() == "1" ? "Pengaturan" : "Setting",
          style: GoogleFonts.lexendDeca(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          DatetimeSetting.openSetting();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        getBahasa.toString() == "1" ? "Kesalahan Ditemukan" : "Error Found",
        style:
            GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Text(
        getBahasa.toString() == "1"
            ? "Kami menemukan pengaturan waktu anda tidak standart, silahkan nyalakan pengaturan waktu dan tanggal otomatis di perangkat anda,"
                " atau tap button pengaturan di bawah ini"
            : "We found your time settings are not standard, please turn on automatic time and date settings on your device, or tap the settings button below",
        style: GoogleFonts.nunitoSans(),
        textAlign: TextAlign.center,
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

  showMockLocDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        getBahasa.toString() == "1" ? "Tutup" : "Close",
        style: GoogleFonts.lexendDeca(color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        style: ElevatedButton.styleFrom(
            primary: HexColor("#1a76d2"),
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.white, width: 0.1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(5.0),
            )),
        child: Text(
          getBahasa.toString() == "1" ? "Pengaturan" : "Setting",
          style: GoogleFonts.lexendDeca(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          DatetimeSetting.openSetting();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        getBahasa.toString() == "1" ? "Kesalahan Ditemukan" : "Error Found",
        style:
            GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Text(
        getBahasa.toString() == "1"
            ? "Kami menemukan pengaturan mock location, silahkan matikan pengaturan MOCK LOCATION di perangkat anda,"
                " atau tap button pengaturan di bawah ini"
            : "We found the mock location setting, please turn off the MOCK LOCATION setting on your device, or tap the settings button below",
        style: GoogleFonts.nunitoSans(),
        textAlign: TextAlign.center,
      ),
      actions: [cancelButton, continueButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool servicestatus = false;

  cekPermissionGeolocator(String Type2, String TimeMe2) async {
    if (Platform.isIOS) {
      if (Type2 == 'Daily' && TimeMe2 == 'Clock In') {
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (context) => PageClockIn(
                widget.getKaryawanNo,
                getJam,
                getWorkLocationId,
                AppHelper().getNamaHari().toString(),
                getWorkLat.toString(),
                getWorkLong.toString(),
                "Clock In",
                widget.getKaryawanNama.toString(),
                widget.getKaryawanJabatan.toString(),
                widget.getStartTime.toString(),
                widget.getEndTime.toString(),
                widget.getScheduleName,
                getWorkLocation.toString())))
            .then(onGoBack);
      } else if (Type2 == 'Daily' && TimeMe2 == 'Clock Out') {
        Navigator.push(
            context,
            ExitPage(
                page: PageClockIn(
                    widget.getKaryawanNo,
                    getJam,
                    getWorkLocationId,
                    AppHelper().getNamaHari().toString(),
                    getWorkLat.toString(),
                    getWorkLong.toString(),
                    "Clock Out",
                    widget.getKaryawanNama.toString(),
                    widget.getKaryawanJabatan.toString(),
                    widget.getStartTime.toString(),
                    widget.getEndTime.toString(),
                    widget.getScheduleName,
                    getWorkLocation.toString())))
            .then(onGoBack);
      } else if (Type2 == 'Lembur' && TimeMe2 == 'Clock In') {
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (context) => PageClockInLembur(
                widget.getKaryawanNo,
                getJam,
                getWorkLocationId,
                AppHelper().getNamaHari().toString(),
                getWorkLat.toString(),
                getWorkLong.toString(),
                "CLOCK IN",
                widget.getKaryawanNama.toString(),
                widget.getKaryawanJabatan.toString(),
                widget.getStartTime.toString(),
                widget.getEndTime.toString(),
                widget.getScheduleName,
                getWorkLocation.toString())))
            .then(onGoBack);
      } else if (Type2 == 'Lembur' && TimeMe2 == 'Clock Out') {
        Navigator.push(
            context,
            ExitPage(
                page: PageClockInLembur(
                    widget.getKaryawanNo,
                    getJam,
                    getWorkLocationId,
                    AppHelper().getNamaHari().toString(),
                    getWorkLat.toString(),
                    getWorkLong.toString(),
                    "CLOCK OUT",
                    widget.getKaryawanNama.toString(),
                    widget.getKaryawanJabatan.toString(),
                    widget.getStartTime.toString(),
                    widget.getEndTime.toString(),
                    widget.getScheduleName,
                    getWorkLocation.toString())))
            .then(onGoBack);
      }
    } else {
      cek_datetimesetting(Type2, TimeMe2);
    }
  }



  cek_datetimesetting(String Type, String TimeMe) async {
    bool timeAuto = await DatetimeSetting.timeIsAuto();
    bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();

    if(timeAuto.toString() == 'false' || timezoneAuto.toString() == 'false') {
      DatetimeSetting.openSetting();
      EasyLoading.dismiss();
      showInvalidDateTimeSettingDialog(context);
      return;
    }else {
      if (Type == 'Daily' && TimeMe == 'Clock In') {
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (context) => PageClockIn(
                widget.getKaryawanNo,
                getJam,
                getWorkLocationId,
                AppHelper().getNamaHari().toString(),
                getWorkLat.toString(),
                getWorkLong.toString(),
                "Clock In",
                widget.getKaryawanNama.toString(),
                widget.getKaryawanJabatan.toString(),
                widget.getStartTime.toString(),
                widget.getEndTime.toString(),
                widget.getScheduleName,
                getWorkLocation.toString())))
            .then(onGoBack);
      } else if (Type == 'Daily' && TimeMe == 'Clock Out') {
        Navigator.push(
            context,
            ExitPage(
                page: PageClockIn(
                    widget.getKaryawanNo,
                    getJam,
                    getWorkLocationId,
                    AppHelper().getNamaHari().toString(),
                    getWorkLat.toString(),
                    getWorkLong.toString(),
                    "Clock Out",
                    widget.getKaryawanNama.toString(),
                    widget.getKaryawanJabatan.toString(),
                    widget.getStartTime.toString(),
                    widget.getEndTime.toString(),
                    widget.getScheduleName,
                    getWorkLocation.toString())))
            .then(onGoBack);
      } else if (Type == 'Lembur' && TimeMe == 'Clock In') {
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (context) => PageClockInLembur(
                widget.getKaryawanNo,
                getJam,
                getWorkLocationId,
                AppHelper().getNamaHari().toString(),
                getWorkLat.toString(),
                getWorkLong.toString(),
                "CLOCK IN",
                widget.getKaryawanNama.toString(),
                widget.getKaryawanJabatan.toString(),
                widget.getStartTime.toString(),
                widget.getEndTime.toString(),
                widget.getScheduleName,
                getWorkLocation.toString())))
            .then(onGoBack);
      } else if (Type == 'Lembur' && TimeMe == 'Clock Out') {
        Navigator.push(
            context,
            ExitPage(
                page: PageClockInLembur(
                    widget.getKaryawanNo,
                    getJam,
                    getWorkLocationId,
                    AppHelper().getNamaHari().toString(),
                    getWorkLat.toString(),
                    getWorkLong.toString(),
                    "CLOCK OUT",
                    widget.getKaryawanNama.toString(),
                    widget.getKaryawanJabatan.toString(),
                    widget.getStartTime.toString(),
                    widget.getEndTime.toString(),
                    widget.getScheduleName,
                    getWorkLocation.toString())))
            .then(onGoBack);
      }
    }

  }

  final ScrollController scrollcontroller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
        child: Scaffold(
          body: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(bottom: 15),
              child: RefreshIndicator(
                  onRefresh: refreshData,
                  child: SingleChildScrollView(
                    controller: scrollcontroller,
                    child: Stack(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 28, right: 25),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  HexColor(AppHelper().second_color),
                                  HexColor(AppHelper().main_color),
                                ],
                              ),
                              color: HexColor("#3aa13d"),
                              image: DecorationImage(
                                image :
                                getSpecialday_name.toString() != '0' ?
                                CachedNetworkImageProvider(applink+"mobile/banner/"+getSpecialday_banner.toString()):
                                CachedNetworkImageProvider(applink+"mobile/banner/ddf29.png")
                                ,
                                fit: BoxFit.cover,
                              ),
                              /*  borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                                MediaQuery.of(context).size.width, 10.0)),*/
                            ),
                            width: double.infinity,
                            height: 180,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              children: [
                                Positioned(
                                    top: -18,
                                    right: 0,
                                    left: -8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 160,
                                          width: 118,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  ExitPage(
                                                      page: SettingHome(widget
                                                          .getKaryawanEmail)));
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.cog,
                                              color: Colors.white,
                                            ))
                                      ],
                                    )),
                                Positioned(
                                    top: 50,
                                    right: 0,
                                    left: 0,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        getBahasa.toString() == "1"
                                            ? 'Halo'
                                            : "Helo",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'VarelaRound',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                                Positioned(
                                    top: 70,
                                    right: 0,
                                    left: 0,
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      applink ==
                                              "https://dev.mishr.missolution.id/"
                                          ? widget.getKaryawanNama.toString() +
                                              " (UAT. Ver.) "
                                          : widget.getKaryawanNama.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'VarelaRound',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    )),
                                Positioned(
                                  top: 100,
                                  right: 0,
                                  left: 0,
                                  child: Text(
                                    widget.getKaryawanJabatan.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'VarelaRound',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 130, left: 20, right: 20),
                            child: Container(
                                height: 208,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  /*image: DecorationImage(
                              image: AssetImage("assets/ddf29a.png"),
                              //image: AssetImage("assets/doodleme30.png"),
                              fit: BoxFit.cover,
                            ),*/
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, left: 25, right: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      StreamBuilder(
                                        stream: Stream.periodic(
                                            const Duration(seconds: 1)),
                                        builder: (context, snapshot) {
                                          return Center(
                                            child: Text(
                                              DateFormat('HH:mm')
                                                  .format(DateTime.now()),
                                              style:
                                              textScale.toString() == '1.17' ?
                                              GoogleFonts.lato(fontSize: 27, fontWeight: FontWeight.bold)
                                              : GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 25, right: 25),
                                        child: Text(
                                            getBahasa.toString() == "1"
                                                ? AppHelper()
                                                    .getTanggal_withhari()
                                                    .toString()
                                                : AppHelper()
                                                    .getTanggal_withhariEnglish()
                                                    .toString(),
                                            style:
                                             textScale.toString() == '1.17' ?
                                            GoogleFonts.nunito(fontSize:11)
                                                 : GoogleFonts.nunito(fontSize: 13)

                                        ),
                                      ),
                                      widget.getScheduleID.toString() == '1' ||
                                              widget.getScheduleID.toString() ==
                                                  '3'
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, left: 25, right: 25),
                                              child: Text(
                                                  widget.getScheduleName
                                                      .toString(),
                                                  style:  textScale.toString() == '1.17' ?
                                                  GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold)
                                                      : GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.bold)
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, left: 25, right: 25),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center, //Center Row contents horizontally,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center, //Center Row contents vertically,
                                                  children: [
                                                    Text(
                                                        widget.getStartTime
                                                            .toString(),
                                                        style:
                                                        textScale.toString() == '1.17' ?
                                                        GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold)
                                                            : GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.bold)
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text("-",
                                                          style:
                                                          textScale.toString() == '1.17' ?
                                                          GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold)
                                                              : GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.bold)
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(
                                                          widget.getEndTime
                                                              .toString(),
                                                          style:
                                                          textScale.toString() == '1.17' ?
                                                              GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold)
                                                            : GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.bold)
                                                              ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 13, left: 18, right: 25),
                                          child: InkWell(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.mapMarker,
                                                  size: 12,
                                                  color: Colors.blue,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                      getWorkLocation.toString()
                                                      /*getWorkLocation.toString() != 'null' || getWorkLocation.toString() != '' ? getWorkLocation.toString() :
                                              "Belum Disetting"*/
                                                      ,
                                                      style:
                                                      textScale.toString() == '1.17' ?
                                                      GoogleFonts.nunito(fontSize:14, color: Colors.blue)
                                                          :
                                                      GoogleFonts.nunito(fontSize: 17, color: Colors.blue)
                                                  ),
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              //show_otherlocation();
                                              Navigator.push(
                                                      context,
                                                      ExitPage(
                                                          page: ChangeCabang(widget
                                                              .getKaryawanNo)))
                                                  .then(onGoBack);
                                            },
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, left: 25, right: 25),
                                          child: Visibility(
                                            visible: _isVisibleBtn,
                                            child: Wrap(
                                              spacing: 30,
                                              children: [
                                                Container(
                                                    width: 90,
                                                    height: 35,
                                                    child: (widget.getScheduleBtn
                                                                        .toString() !=
                                                                    'disable' &&
                                                                getJamMasuk
                                                                        .toString() ==
                                                                    '0') ||
                                                            (widget.getScheduleBtn
                                                                        .toString() !=
                                                                    'disable' &&
                                                                getJamMasuk
                                                                        .toString() ==
                                                                    '00:00')
                                                        ? ElevatedButton(
                                                            child: Text(

                                                              "Clock In",
                                                              style:
                                                              textScale.toString() == '1.17' ?
                                                              GoogleFonts.lexendDeca(
                                                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8.5)
                                                                  :
                                                              GoogleFonts.lexendDeca(
                                                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5),
                                                            ),
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    primary:
                                                                        HexColor(
                                                                            "#075E54"),
                                                                    elevation:
                                                                        0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              0.1,
                                                                          style:
                                                                              BorderStyle.solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    )),
                                                            onPressed: () {
                                                              EasyLoading.show(
                                                                  status: AppHelper()
                                                                      .loading_text);
                                                              cekPermissionGeolocator(
                                                                  "Daily",
                                                                  "Clock In");
                                                              //cek_datetimesetting("Daily","Clock In");
                                                              /* Navigator.push(context, ExitPage(page: PageClockIn(
                                                      widget.getKaryawanNo,
                                                      getJam, getWorkLocationId,AppHelper().getNamaHari().toString(),
                                                      getWorkLat.toString(),
                                                      getWorkLong.toString(),"Clock In",
                                                      widget.getKaryawanNama.toString(),
                                                      widget.getKaryawanJabatan.toString(),
                                                      widget.getStartTime.toString(),
                                                      widget.getEndTime.toString(),
                                                      widget.getScheduleName,
                                                      getWorkLocation.toString()
                                                  ))).then(onGoBack);*/
                                                            },
                                                          )
                                                        : Opacity(
                                                            opacity: 0.6,
                                                            child:
                                                                ElevatedButton(
                                                              child: Text(
                                                                "Clock In",
                                                                style:
                                                                textScale.toString() == '1.17' ?
                                                                GoogleFonts.lexendDeca(
                                                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8.5)
                                                                    :
                                                                GoogleFonts.lexendDeca(
                                                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5),
                                                              ),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      elevation:
                                                                          0,
                                                                      primary:
                                                                          HexColor(
                                                                              "#DDDDDD"),
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: Colors
                                                                                .white,
                                                                            width:
                                                                                0.1,
                                                                            style:
                                                                                BorderStyle.solid),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                      )),
                                                              onPressed: () {
                                                                //sendPushMessage('Notification Body', 'Notification Title', 'REPLACEWITHDEVICETOKEN');
                                                              },
                                                            ))),
                                                Container(
                                                    width: 90,
                                                    height: 35,
                                                    child: widget.getScheduleBtn
                                                                    .toString() !=
                                                                'disable' &&
                                                            getJamMasuk.toString() !=
                                                                '0' &&
                                                            getJamKeluar
                                                                    .toString() ==
                                                                '00:00' &&
                                                            getJamMasuk
                                                                    .toString() !=
                                                                '00:00'
                                                        ? ElevatedButton(
                                                            child: Text(
                                                              "Clock Out",
                                                              style:
                                                              textScale.toString() == '1.17' ?
                                                              GoogleFonts.lexendDeca(
                                                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8.5)
                                                                  :
                                                              GoogleFonts.lexendDeca(
                                                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5),
                                                            ),
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    elevation:
                                                                        0,
                                                                    primary:
                                                                        HexColor(
                                                                            "#075E54"),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              0.1,
                                                                          style:
                                                                              BorderStyle.solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    )),
                                                            onPressed: () {
                                                              EasyLoading.show(
                                                                  status: AppHelper()
                                                                      .loading_text);
                                                              cekPermissionGeolocator(
                                                                  "Daily",
                                                                  "Clock Out");
                                                              //cek_datetimesetting("Daily","Clock Out");
                                                            },
                                                          )
                                                        : Opacity(
                                                            opacity: 0.6,
                                                            child:
                                                                ElevatedButton(
                                                              child: Text(
                                                                "Clock Out",
                                                                style:
                                                                textScale.toString() == '1.17' ?
                                                                GoogleFonts.lexendDeca(
                                                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8.5)
                                                                    :
                                                                GoogleFonts.lexendDeca(
                                                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5),
                                                              ),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      elevation:
                                                                          0,
                                                                      primary:
                                                                          HexColor(
                                                                              "#DDDDDD"),
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: Colors
                                                                                .white,
                                                                            width:
                                                                                0.1,
                                                                            style:
                                                                                BorderStyle.solid),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                      )),
                                                              onPressed: () {},
                                                            )))
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ))),
                        SizedBox(
                          height: 25,
                        ),


                        

                        Padding(
                            padding: getPINq == AppHelper().default_pass ||
                                    getCountLembur == "1"
                                ? const EdgeInsets.only(
                                    top: 375, left: 25, right: 25)
                                : const EdgeInsets.only(
                                    top: 385, left: 25, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                getCountLembur == "1"
                                    ? Container(
                                        padding: EdgeInsets.all(5),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          //border: Border.all(color: HexColor("#0a5d5f")),
                                          color: HexColor("#e8fcfb"),
                                          image: DecorationImage(
                                            image:
                                                AssetImage("assets/ddf29c.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                    context,
                                                    ExitPage(
                                                        page: ChangePIN(widget
                                                            .getKaryawanNo)))
                                                .then(onGoBack);
                                          },
                                          child: ListTile(
                                            title: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  color: Colors.white,
                                                  child: Text(
                                                    getBahasa.toString() == '1'
                                                        ? "Lembur Hari ini"
                                                        : "Today Overtime",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )),
                                            subtitle: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    color: Colors.white,
                                                    child: Text(
                                                        getScheduleClockInLembur
                                                                .toString()
                                                                .substring(
                                                                    0, 5) +
                                                            " - " +
                                                            getScheduleClockOutLembur
                                                                .toString()
                                                                .substring(
                                                                    0, 5),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black)),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: Visibility(
                                                        visible: _isVisibleBtn,
                                                        child: Wrap(
                                                          spacing: 30,
                                                          children: [
                                                            Container(
                                                                width: 90,
                                                                height: 35,
                                                                child: getClockInLembur
                                                                            .toString() ==
                                                                        '00:00:00'
                                                                    ? ElevatedButton(
                                                                        child:
                                                                            Text(
                                                                          "Clock In",
                                                                          style: GoogleFonts.lexendDeca(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: textScale.toString() == '1.17' ? 8.5: 11.5),
                                                                        ),
                                                                        style: ElevatedButton.styleFrom(
                                                                            elevation: 0,
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(color: Colors.white, width: 0.1, style: BorderStyle.solid),
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            )),
                                                                        onPressed:
                                                                            () {
                                                                          EasyLoading.show(
                                                                              status: AppHelper().loading_text);
                                                                          cekPermissionGeolocator(
                                                                              "Lembur",
                                                                              "Clock In");
                                                                          //cek_datetimesetting("Lembur","Clock In");
                                                                        },
                                                                      )
                                                                    : Opacity(
                                                                        opacity:
                                                                            0.6,
                                                                        child:
                                                                            ElevatedButton(
                                                                          child:
                                                                              Text(
                                                                            "Clock In",
                                                                            style: GoogleFonts.lexendDeca(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: textScale.toString() == '1.17' ? 8.5: 11.5),
                                                                          ),
                                                                          style: ElevatedButton.styleFrom(
                                                                              elevation: 0,
                                                                              primary: HexColor("#DDDDDD"),
                                                                              shape: RoundedRectangleBorder(
                                                                                side: BorderSide(color: Colors.white, width: 0.1, style: BorderStyle.solid),
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              )),
                                                                          onPressed:
                                                                              () {},
                                                                        ))),
                                                            Container(
                                                                width: 90,
                                                                height: 35,
                                                                child: getClockInLembur.toString() !=
                                                                            '00:00:00' &&
                                                                        getClockOutLembur.toString() ==
                                                                            '00:00:00'
                                                                    ? ElevatedButton(
                                                                        child:
                                                                            Text(
                                                                          "Clock Out",
                                                                          style: GoogleFonts.lexendDeca(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: textScale.toString() == '1.17' ? 8.5: 11.5),
                                                                        ),
                                                                        style: ElevatedButton.styleFrom(
                                                                            elevation: 0,
                                                                            //primary: HexColor("#075E54"),
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(color: Colors.white, width: 0.1, style: BorderStyle.solid),
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            )),
                                                                        onPressed:
                                                                            () {
                                                                          EasyLoading.show(
                                                                              status: AppHelper().loading_text);
                                                                          cekPermissionGeolocator(
                                                                              "Lembur",
                                                                              "Clock Out");
                                                                          //cek_datetimesetting("Lembur","Clock Out");
                                                                        },
                                                                      )
                                                                    : Opacity(
                                                                        opacity:
                                                                            0.6,
                                                                        child:
                                                                            ElevatedButton(
                                                                          child:
                                                                              Text(
                                                                            "Clock Out",
                                                                            style: GoogleFonts.lexendDeca(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: textScale.toString() == '1.17' ? 8.5: 11.5),
                                                                          ),
                                                                          style: ElevatedButton.styleFrom(
                                                                              elevation: 0,
                                                                              primary: HexColor("#DDDDDD"),
                                                                              shape: RoundedRectangleBorder(
                                                                                side: BorderSide(color: Colors.white, width: 0.1, style: BorderStyle.solid),
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              )),
                                                                          onPressed:
                                                                              () {},
                                                                        )))
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
                                    : Container(),
                                getCountLembur == "1"
                                    ? SizedBox(
                                        height: 30,
                                      )
                                    : Container(),


                                getPINq == AppHelper().default_pass
                                    ? Container(
                                        padding: EdgeInsets.all(5),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: HexColor("#ffeaef"),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                    context,
                                                    ExitPage(
                                                        page: ChangePIN(widget
                                                            .getKaryawanNo)))
                                                .then(onGoBack);
                                          },
                                          child: ListTile(
                                            leading:
                                                FaIcon(FontAwesomeIcons.lock),
                                            title: Text(
                                              getBahasa.toString() == '1'
                                                  ? "Ayo ganti PIN kamu untuk keamanan lebih sempurna"
                                                  : "Lets change your PIN to more security",
                                              style: GoogleFonts.nunito(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  height: 1.5),
                                            ),
                                            trailing: FaIcon(
                                              FontAwesomeIcons.angleRight,
                                              size: 15,
                                            ),
                                          ),
                                        ))
                                    : Container(),
                                getPINq == AppHelper().default_pass
                                    ? SizedBox(
                                        height: 30,
                                      )
                                    : Container(),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 27),
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 75,
                                                height: 27,
                                                padding:
                                                    EdgeInsets.only(right: 2),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              pressBtnSemua ==
                                                                      "1"
                                                                  ? HexColor(
                                                                      "#f4f4f4")
                                                                  : HexColor(
                                                                      "#ffffff"),
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.1,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          )),
                                                  child: Text("Semua",
                                                      style:
                                                      textScale.toString() == '1.17' ?
                                                       GoogleFonts.lexendDeca(color: HexColor("#075E54"), fontWeight: FontWeight.bold,
                                                              fontSize: 9)
                                                              :
                                                      GoogleFonts.lexendDeca(color: HexColor("#075E54"), fontWeight: FontWeight.bold,
                                                          fontSize: 10.5)

                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      pressBtnSemua = "1";
                                                      pressBtnCuti = "0";
                                                      pressBtnKehadiran = "0";
                                                      pressBtnInformasi = "0";
                                                    });
                                                  },
                                                )),
                                            Container(
                                                width: 60,
                                                height: 27,
                                                padding:
                                                    EdgeInsets.only(right: 2),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              pressBtnCuti ==
                                                                      "1"
                                                                  ? HexColor(
                                                                      "#f4f4f4")
                                                                  : HexColor(
                                                                      "#ffffff"),
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.1,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          )),
                                                  child: Text("Cuti",
                                                      style:
                                                               textScale.toString() == '1.17' ?
                                                      GoogleFonts.lexendDeca(color: HexColor("#075E54"), fontWeight: FontWeight.bold,
                                                          fontSize: 9)
                                                          :
                                                      GoogleFonts.lexendDeca(color: HexColor("#075E54"), fontWeight: FontWeight.bold,
                                                          fontSize: 10.5)),
                                                  onPressed: () {
                                                    setState(() {
                                                      pressBtnSemua = "0";
                                                      pressBtnCuti = "1";
                                                      pressBtnKehadiran = "0";
                                                      pressBtnInformasi = "0";
                                                    });
                                                  },
                                                )),
                                            Container(
                                                width: 95,
                                                height: 27,
                                                padding:
                                                    EdgeInsets.only(right: 2),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              pressBtnKehadiran ==
                                                                      "1"
                                                                  ? HexColor(
                                                                      "#f4f4f4")
                                                                  : HexColor(
                                                                      "#ffffff"),
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.1,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          )),
                                                  child: Text("Kehadiran",
                                                      style:
                                                      textScale.toString() == '1.17' ?
                                                      GoogleFonts.lexendDeca(color: HexColor("#075E54"), fontWeight: FontWeight.bold,
                                                          fontSize: 9)
                                                          :
                                                      GoogleFonts.lexendDeca(color: HexColor("#075E54"), fontWeight: FontWeight.bold,
                                                          fontSize: 10.5)),
                                                  onPressed: () {
                                                    setState(() {
                                                      pressBtnSemua = "0";
                                                      pressBtnCuti = "0";
                                                      pressBtnKehadiran = "1";
                                                      pressBtnInformasi = "0";
                                                    });
                                                  },
                                                )),
                                            Container(
                                                width: 95,
                                                height: 27,
                                                padding:
                                                    EdgeInsets.only(right: 2),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              pressBtnInformasi ==
                                                                      "1"
                                                                  ? HexColor(
                                                                      "#f4f4f4")
                                                                  : HexColor(
                                                                      "#ffffff"),
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.1,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          )),
                                                  child: Text("Informasi",
                                                      style:
                                                      textScale.toString() == '1.17' ?
                                                      GoogleFonts.lexendDeca(color: HexColor("#075E54"), fontWeight: FontWeight.bold,
                                                          fontSize: 9)
                                                          :
                                                      GoogleFonts.lexendDeca(color: HexColor("#075E54"), fontWeight: FontWeight.bold,
                                                          fontSize: 10.5)),
                                                  onPressed: () {
                                                    setState(() {
                                                      pressBtnSemua = "0";
                                                      pressBtnCuti = "0";
                                                      pressBtnKehadiran = "0";
                                                      pressBtnInformasi = "1";
                                                    });
                                                  },
                                                ))
                                          ],
                                        ))),
                                Wrap(
                                  spacing: 20,
                                  runSpacing: pressBtnSemua == "1"
                                      ? 30
                                      : pressBtnInformasi == "1"
                                          ? 1
                                          : 5,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    pressBtnSemua == "1" || pressBtnCuti == "1"
                                        ? Container(
                                            width: 62,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        ExitPage(page: PageTimeOffHome2a(widget.getKaryawanNo, widget.getKaryawanNama.toString(),
                                                                widget.getKaryawanEmail))).then(onGoBack2);
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            HexColor("#e0f5fe"),
                                                        border: Border.all(
                                                          color: HexColor(
                                                              "#DDDDDD"),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          UniconsLine.calendar_alt,
                                                          color: HexColor(
                                                              "#36bbf6"),
                                                          size: 24,
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(
                                                        getBahasa.toString() ==
                                                                "1"
                                                            ? "Cuti"
                                                            : "Time Off",
                                                        style:
                                                            textScale.toString() == '1.17' ?
                                                            GoogleFonts.nunito(fontSize: 11) :
                                                            GoogleFonts.nunito(fontSize: 12.5)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    pressBtnSemua == "1" ||
                                            pressBtnKehadiran == "1"
                                        ? Container(
                                            width: 62,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        ExitPage(
                                                            page: PageAttendanceHome(
                                                                widget
                                                                    .getKaryawanNo,
                                                                widget
                                                                    .getKaryawanNama,
                                                                widget
                                                                    .getKaryawanEmail)))
                                                    .then(onGoBack2);
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            HexColor("#f7faff"),
                                                        border: Border.all(
                                                          //color: HexColor("#1c6bea"),
                                                          color: HexColor(
                                                              "#DDDDDD"),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          UniconsLine.file_copy_alt,
                                                          color: HexColor(
                                                              "#1c6bea"),
                                                          size: 28,
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(
                                                      getBahasa.toString() ==
                                                              '1'
                                                          ? "Kehadiran"
                                                          : "Attendance",
                                                      style:

                                                      textScale.toString() == '1.17' ?
                                                      GoogleFonts.nunito(fontSize: 11) :
                                                      GoogleFonts.nunito(fontSize: 12.5),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                        : Container(),
                                    pressBtnSemua == "1" ||
                                            pressBtnKehadiran == "1"
                                        ? Container(
                                            width: 62,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        ExitPage(
                                                            page: PageRLemburHome(
                                                                widget
                                                                    .getKaryawanNo,
                                                                widget
                                                                    .getKaryawanNama,
                                                                widget
                                                                    .getKaryawanEmail)))
                                                    .then(onGoBack2);
                                                // Navigator.push(context, ExitPage(page: LemburAdd(widget.getKaryawanNo, widget.getKaryawanNama, widget.getKaryawanEmail, "Lembur in Same Day"))).then(onGoBack2);
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            HexColor("#f3fcf9"),
                                                        border: Border.all(
                                                          //color: HexColor("#1c6bea"),
                                                          color: HexColor(
                                                              "#DDDDDD"),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          UniconsLine.clock,
                                                          color: HexColor(
                                                              "#05be61"),
                                                          size: 28,
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(
                                                      getBahasa.toString() ==
                                                              '1'
                                                          ? "Lembur"
                                                          : "Overtime",
                                                      style:
                                                      textScale.toString() == '1.17' ?
                                                      GoogleFonts.nunito(fontSize: 11) :
                                                      GoogleFonts.nunito(fontSize: 12.5),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                        : Container(),


                                    pressBtnSemua == "1" ||
                                        pressBtnKehadiran == "1"
                                        ? Container(
                                        width: 62,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context, ExitPage(page: PageBertugasHome(widget.getKaryawanNo)));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(50),
                                                    color:
                                                    HexColor("#f5f6ff"),
                                                    border: Border.all(
                                                      color: HexColor(
                                                          "#DDDDDD"),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      UniconsLine.suitcase,
                                                      color: HexColor(
                                                          "#121942"),
                                                      size: 29,
                                                    ),
                                                  )),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8),
                                                child: Text(
                                                  getBahasa.toString() ==
                                                      '1'
                                                      ? "Bertugas"
                                                      : "On Duty",
                                                  style:
                                                  textScale.toString() == '1.17' ?
                                                  GoogleFonts.nunito(fontSize: 11) :
                                                  GoogleFonts.nunito(fontSize: 12.5),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                        : Container(),



                                    pressBtnSemua == "1" ||
                                            pressBtnKehadiran == "1"
                                        ? Container(
                                            width: 62,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    ExitPage(
                                                        page: MySchedule2(
                                                            widget
                                                                .getKaryawanNo,
                                                            widget
                                                                .getKaryawanNama,
                                                            widget
                                                                .getKaryawanEmail)));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            HexColor("#fff4f0"),
                                                        border: Border.all(
                                                          color: HexColor(
                                                              "#DDDDDD"),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .calendarCheck,
                                                          color: HexColor(
                                                              "#ff8556"),
                                                          size: 24,
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(
                                                      getBahasa.toString() ==
                                                              '1'
                                                          ? "Jadwal"
                                                          : "Schedule",
                                                      style:
                                                      textScale.toString() == '1.17' ?
                                                      GoogleFonts.nunito(fontSize: 11) :
                                                      GoogleFonts.nunito(fontSize: 12.5),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                        : Container(),



/*
                                    pressBtnSemua == "1" ||
                                            pressBtnInformasi == "1"
                                        ? Container(
                                            width: 62,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        ExitPage(
                                                            page: Report(widget
                                                                .getKaryawanNo)))
                                                    .then(onGoBack2);
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            HexColor("#ffe4ed"),
                                                        border: Border.all(
                                                          color: HexColor(
                                                              "#DDDDDD"),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .fileContract,
                                                          color: HexColor(
                                                              "#e9417e"),
                                                          size: 24,
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(
                                                      getBahasa.toString() ==
                                                              '1'
                                                          ? "Resume"
                                                          : "Resume",
                                                      style:
                                                      textScale.toString() == '1.17' ?
                                                      GoogleFonts.nunito(fontSize: 11) :
                                                      GoogleFonts.nunito(fontSize: 13),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                        : Container(),*/

                                    pressBtnSemua == "1" ||
                                        pressBtnInformasi == "1"
                                        ? Container(
                                        width: 62,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                ExitPage(
                                                    page: PageBerita(
                                                        widget
                                                            .getKaryawanNo)))
                                                .then(onGoBack2);
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(50),
                                                    color:
                                                    HexColor("#ffe4ed"),
                                                    border: Border.all(
                                                      color: HexColor(
                                                          "#DDDDDD"),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      UniconsLine.newspaper,
                                                      color: HexColor(
                                                          "#e9417e"),
                                                      size: 28,
                                                    ),
                                                  )),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8),
                                                child: Text(
                                                  getBahasa.toString() ==
                                                      '1'
                                                      ? "Berita"
                                                      : "Resume",
                                                  style:
                                                  textScale.toString() == '1.17' ?
                                                  GoogleFonts.nunito(fontSize: 11) :
                                                  GoogleFonts.nunito(fontSize: 12.5),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                        : Container(),

                                    pressBtnSemua == "1" ||
                                            pressBtnInformasi == "1"
                                        ? Container(
                                            width: 62,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        ExitPage(
                                                            page: PageReprimand(
                                                                widget
                                                                    .getKaryawanNo)))
                                                    .then(onGoBack2);
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            HexColor("#f3effd"),
                                                        border: Border.all(
                                                          color: HexColor(
                                                              "#DDDDDD"),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .envelopeOpenText,
                                                          color: HexColor(
                                                              "#6338b6"),
                                                          size: 24,
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(
                                                      getBahasa.toString() ==
                                                              '1'
                                                          ? "Teguran"
                                                          : "Reprimand",
                                                      style:
                                                      textScale.toString() == '1.17' ?
                                                      GoogleFonts.nunito(fontSize: 10) :
                                                      GoogleFonts.nunito(fontSize: 12.5),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                        : Container(),

                                    /*  pressBtnSemua == "1" || pressBtnInformasi == "1" ?
                              Container(
                                width: 62,
                                child:
                                InkWell(
                                onTap: (){
                                  Navigator.push(context, ExitPage(page: PageAnnouncement(widget.getKaryawanNo))).then(onGoBack2);
                                },
                                child:Column(
                                  children: [
                                    Container(
                                        height: 45, width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: HexColor("#def8f9"),
                                          border: Border.all(
                                            color : HexColor("#DDDDDD"),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: FaIcon(FontAwesomeIcons.bullhorn, color: HexColor("#00b0b9"), size: 24,),
                                        )
                                    ),
                                    Padding(padding: const EdgeInsets.only(top:8),
                                      child: Text(getBahasa.toString() == '1' ? "Informasi":"Information", style: GoogleFonts.nunito(fontSize: 13),textAlign: TextAlign.center,),)
                                  ],
                                ),
                              )) : Container(),*/



                                  ],
                                ),

                                
                                SizedBox(
                                  height: getSpecialday_name.toString() != '0' ? 30 : 0,
                                ),
                                getSpecialday_name.toString() != '0' ?
                                Container(
                                    padding: EdgeInsets.all(5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      border: Border.all(
                                        color: HexColor(
                                            "#8870e6"),
                                        width: 0.5,
                                      ),
                                      color: HexColor("#ffffff"),
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      child: ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                        dense : true,
                                        leading:
                                        FaIcon(FontAwesomeIcons.calendarDay,color: HexColor("#141b43"),),
                                        title: Text(
                                          "Selamat "+getSpecialday_name.toString(),
                                          style: GoogleFonts.nunito(
                                              color: HexColor("#141b43"),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              height: 1.5),
                                        ),
                                          subtitle: Text(
                                            getSpecialday_tagline.toString(),
                                            style: GoogleFonts.nunito(
                                                color: HexColor("#141b43"),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                height: 1.5),
                                          ),

                                      ),
                                    )) : Container(),

                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      border: Border.all(
                                        color: HexColor(
                                            "#DDDDDD"),
                                        width: 0.5,
                                      ),
                                      color: HexColor("#f5f6ff"),
                                    ),
                                    child: InkWell(
                                      onTap: () {
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
                                                  height: 380,
                                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                    child : Padding(
                                                      padding: EdgeInsets.only(left: 25,right: 25,top: 25),
                                                      child: Column(
                                                        children: [

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("Bulan " + AppHelper()
                                                                  .getNamaBulanToday()
                                                                  .toString(),
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
                                                            padding: EdgeInsets.only(top:15,bottom:10),
                                                            child: Divider(height: 5,),
                                                          ),

                                                          Container(
                                                            height: 300,
                                                            width: double.infinity,
                                                            child : FutureBuilder(
                                                                  future: g_helper().getData_birthday(),
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
                                                                              itemExtent: textScale.toString() == '1.17' ? 95 : 87,
                                                                              itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                                                              itemBuilder: (context, i) {
                                                                                return Column(
                                                                                  children: [
                                                                                    InkWell(
                                                                                      child : ListTile(
                                                                                        leading : Container(
                                                                                          height: 45,
                                                                                          width : 45,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                            color: HexColor("#8870e6"),
                                                                                            border: Border.all(
                                                                                              color: HexColor("#DDDDDD"),
                                                                                              width: 0.5,
                                                                                            ),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child : Text(snapshot.data![i]["a"].toString(),overflow: TextOverflow.ellipsis,
                                                                                              style: GoogleFonts.montserrat(color:HexColor("#ffffff"),fontWeight: FontWeight.bold,fontSize: 18),)
                                                                                          ),
                                                                                        ),
                                                                                        title:Text(snapshot.data![i]["b"].toString(),  style: GoogleFonts.nunitoSans(fontSize: 14.5,color: Colors.black)),
                                                                                        subtitle: Column(
                                                                                          children: [
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(top: 5),
                                                                                              child:  Align(alignment: Alignment.centerLeft,
                                                                                                  child:  Text(snapshot.data![i]["d"].toString() + " - "+snapshot.data![i]["c"].toString(),
                                                                                                      overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                                                                          fontWeight: FontWeight.bold,fontSize: 13.5,color: Colors.black))),
                                                                                            ),
                                                                                          ],
                                                                                        ),

                                                                                      ),
                                                                                    ),
                                                                                    Padding(padding: const EdgeInsets.only(top:4)),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),

                                                                        ],
                                                                      );

                                                                    }
                                                                  },
                                                            ),
                                                          )


                                                        ],
                                                      ),
                                                    )
                                                ),
                                              );
                                            }
                                        );
                                      },
                                      child: ListTile(
                                        leading:
                                        FaIcon(FontAwesomeIcons.birthdayCake,color: HexColor("#141b43"),),
                                        title: Text(
                                              "Let's celebrate birthday party with your team work",
                                          style: GoogleFonts.nunito(
                                              color: HexColor("#141b43"),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              height: 1.5),
                                        ),
                                        trailing: FaIcon(
                                          FontAwesomeIcons.angleRight,
                                          size: 15,color: HexColor("#141b43"),
                                        ),
                                      ),
                                    )),




                                Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Container(
                                        height: 4,
                                        width: double.infinity,
                                        color: HexColor("#DDDDDD"),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                      child: Text(
                                    getBahasa.toString() == '1'
                                        ? "Kehadiran"
                                        : "Attendance",
                                    style: GoogleFonts.varela(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                                ),
                                getCountLembur == "1"
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Table(
                                          border: TableBorder.all(
                                              color: HexColor("#DDDDDD"),
                                              style: BorderStyle.solid,
                                              width: 1),
                                          children: [
                                            TableRow(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5.0))),
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            getBahasa.toString() ==
                                                                    '1'
                                                                ? 'Kehadiran Lembur, (' +
                                                                    AppHelper()
                                                                        .getTanggal_nohari()
                                                                        .toString() +
                                                                    ')'
                                                                : 'Overtime Attendance, (' +
                                                                    AppHelper()
                                                                        .getTanggal_nohariEnglish()
                                                                        .toString() +
                                                                    ')',
                                                            style: GoogleFonts
                                                                .nunitoSans(
                                                                    fontSize:
                                                                    textScale.toString() == '1.17' ? 11: 13,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                      ))
                                                ]),
                                            TableRow(children: [
                                              Column(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          right: 10,
                                                          left: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        height: 70,
                                                        width: 145,
                                                        child: ListTile(
                                                            dense: true,
                                                            leading: FaIcon(
                                                              FontAwesomeIcons
                                                                  .clock,
                                                              color: HexColor(
                                                                  "#2196f3"),
                                                              size: 36,
                                                            ),
                                                            title: Column(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 11,
                                                                        left:
                                                                            2),
                                                                    child:
                                                                        Opacity(
                                                                      opacity:
                                                                          0.5,
                                                                      child: Text(
                                                                          getBahasa.toString() == '1'
                                                                              ? "Jam Masuk"
                                                                              : "Clock In",
                                                                          style: GoogleFonts.lato(
                                                                              fontSize:  textScale.toString() == '1.17' ? 9 : 10,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                    child: Text(
                                                                        getClockInLembur.toString() ==
                                                                                "00:00:00"
                                                                            ? "-"
                                                                            : getClockInLembur.toString().substring(0,
                                                                                5),
                                                                        style: GoogleFonts.lato(
                                                                            fontSize:
                                                                                19,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                      Container(
                                                        height: 70,
                                                        width: 145,
                                                        child: ListTile(
                                                            dense: true,
                                                            leading: FaIcon(
                                                              FontAwesomeIcons
                                                                  .clock,
                                                              color: HexColor(
                                                                  "#2196f3"),
                                                              size: 35,
                                                            ),
                                                            title: Column(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        left:
                                                                            2),
                                                                    child:
                                                                        Opacity(
                                                                      opacity:
                                                                          0.5,
                                                                      child: Text(
                                                                          getBahasa.toString() == '1'
                                                                              ? "Jam Keluar"
                                                                              : "Clock Out",
                                                                          style: GoogleFonts.lato(
                                                                              fontSize: textScale.toString() == '1.17' ? 9 : 10,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                    child: Text(
                                                                        getClockOutLembur.toString() ==
                                                                                "00:00:00"
                                                                            ? "-"
                                                                            : getClockOutLembur.toString().substring(0,
                                                                                5),
                                                                        style: GoogleFonts.lato(
                                                                            fontSize:
                                                                                19,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                            ]),
                                          ],
                                        ))
                                    : Container(),
                                Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Table(
                                      border: TableBorder.all(
                                          color: HexColor("#DDDDDD"),
                                          style: BorderStyle.solid,
                                          width: 1),
                                      children: [
                                        TableRow(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(5.0))),
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        getBahasa.toString() ==
                                                                '1'
                                                            ? 'Hari ini, (' +
                                                                AppHelper()
                                                                    .getTanggal_nohari()
                                                                    .toString() +
                                                                ')'
                                                            : 'Today, (' +
                                                                AppHelper()
                                                                    .getTanggal_nohariEnglish()
                                                                    .toString() +
                                                                ')',
                                                        style:
                                                        textScale.toString() == '1.17' ?
                                                        GoogleFonts.nunitoSans(fontSize: 11, color: Colors.black,
                                                                fontWeight: FontWeight.bold) :
                                                        GoogleFonts.nunitoSans(fontSize: 13, color: Colors.black,
                                                            fontWeight: FontWeight.bold)


                                                            ),
                                                  ))
                                            ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, right: 10, left: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 145,
                                                    child: ListTile(
                                                        dense: true,
                                                        leading: FaIcon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          color: HexColor(
                                                              "#128C7E"),
                                                          size: 36,
                                                        ),
                                                        title: Column(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 11,
                                                                        left:
                                                                            2),
                                                                child: Opacity(
                                                                  opacity: 0.5,
                                                                  child: Text(
                                                                      getBahasa.toString() == '1'
                                                                          ? "Jam Masuk"
                                                                          : "Clock In",
                                                                      style:
                                                                      textScale.toString() == '1.17' ?
                                                                      GoogleFonts.lato(fontSize: 9, color: Colors.black,
                                                                          fontWeight: FontWeight.bold) :
                                                                      GoogleFonts.lato(fontSize: 10, color: Colors.black,
                                                                          fontWeight: FontWeight.bold)


                                                                          ),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                child: Text(
                                                                    getJamMasuk.toString() == "0" ||
                                                                            getJamMasuk.toString() ==
                                                                                "00:00"
                                                                        ? "-"
                                                                        : getJamMasuk
                                                                            .toString(),
                                                                    style:
                                                                    textScale.toString() == '1.17' ?
                                                                    GoogleFonts.lato(fontSize: 17,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold) :
                                                                    GoogleFonts.lato(fontSize: 19,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold)),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                  Container(
                                                    height: 70,
                                                    width: 145,
                                                    child: ListTile(
                                                        dense: true,
                                                        leading: FaIcon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          color: HexColor(
                                                              "#128C7E"),
                                                          size: 35,
                                                        ),
                                                        title: Column(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        left:
                                                                            2),
                                                                child: Opacity(
                                                                  opacity: 0.5,
                                                                  child: Text(
                                                                      getBahasa.toString() == '1'
                                                                          ? "Jam Keluar"
                                                                          : "Clock Out",
                                                                      style:
                                                                              textScale.toString() == '1.17' ?
                                                                      GoogleFonts.lato(fontSize: 9, color: Colors.black,
                                                                          fontWeight: FontWeight.bold) :
                                                                      GoogleFonts.lato(fontSize: 10, color: Colors.black,
                                                                          fontWeight: FontWeight.bold)),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                child: Text(
                                                                    getJamKeluar.toString() == "0" ||
                                                                            getJamKeluar.toString() ==
                                                                                "00:00"
                                                                        ? "-"
                                                                        : getJamKeluar
                                                                            .toString(),
                                                                    style:
                                                                    textScale.toString() == '1.17' ?
                                                                    GoogleFonts.lato(fontSize: 17,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold) :
                                                                    GoogleFonts.lato(fontSize: 19,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold)),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ]),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Table(
                                      border: TableBorder.all(
                                          color: HexColor("#DDDDDD"),
                                          style: BorderStyle.solid,
                                          width: 1),
                                      children: [
                                        TableRow(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(5.0))),
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        getBahasa.toString() ==
                                                                '1'
                                                            ? 'Kemarin, (' +
                                                                AppHelper()
                                                                    .getTanggal_nohari_before()
                                                                    .toString() +
                                                                ')'
                                                            : 'Yesterday, (' +
                                                                AppHelper()
                                                                    .getTanggal_nohari_beforeEnglish()
                                                                    .toString() +
                                                                ')',
                                                        style:
                                                        textScale.toString() == '1.17' ?
                                                        GoogleFonts.nunitoSans(fontSize: 11, color: Colors.black,
                                                            fontWeight: FontWeight.bold) :
                                                        GoogleFonts.nunitoSans(fontSize: 13, color: Colors.black,
                                                            fontWeight: FontWeight.bold)),
                                                  ))
                                            ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, right: 10, left: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 145,
                                                    child: ListTile(
                                                        dense: true,
                                                        leading: FaIcon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          color: HexColor(
                                                              "#128C7E"),
                                                          size: 36,
                                                        ),
                                                        title: Column(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 11,
                                                                        left:
                                                                            2),
                                                                child: Opacity(
                                                                  opacity: 0.5,
                                                                  child: Text(
                                                                      getBahasa.toString() == '1'
                                                                          ? "Jam Masuk"
                                                                          : "Clock In",
                                                                      style:
                                                                      textScale.toString() == '1.17' ?
                                                                      GoogleFonts.lato(fontSize: 9, color: Colors.black,
                                                                          fontWeight: FontWeight.bold) :
                                                                      GoogleFonts.lato(fontSize: 10, color: Colors.black,
                                                                          fontWeight: FontWeight.bold)),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                child: Text(
                                                                    widget.getJamMasukSebelum.toString() == "0" ||
                                                                            widget.getJamMasukSebelum.toString() ==
                                                                                "00:00"
                                                                        ? "-"
                                                                        : widget
                                                                            .getJamMasukSebelum
                                                                            .toString(),
                                                                    style:
                                                                    textScale.toString() == '1.17' ?
                                                                    GoogleFonts.lato(fontSize: 17,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold) :
                                                                    GoogleFonts.lato(fontSize: 19,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold)
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                  Container(
                                                    height: 70,
                                                    width: 145,
                                                    child: ListTile(
                                                        dense: true,
                                                        leading: FaIcon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          color: HexColor(
                                                              "#128C7E"),
                                                          size: 35,
                                                        ),
                                                        title: Column(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        left:
                                                                            2),
                                                                child: Opacity(
                                                                  opacity: 0.5,
                                                                  child: Text(
                                                                      getBahasa.toString() == '1'
                                                                          ? "Jam Keluar"
                                                                          : "Clock Out",
                                                                      style:
                                                                      textScale.toString() == '1.17' ?
                                                                      GoogleFonts.lato(fontSize: 9, color: Colors.black,
                                                                          fontWeight: FontWeight.bold) :
                                                                      GoogleFonts.lato(fontSize: 10, color: Colors.black,
                                                                          fontWeight: FontWeight.bold)),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                child: Text(
                                                                    widget.getJamKeluarSebelum.toString() == "0" ||
                                                                            widget.getJamKeluarSebelum.toString() ==
                                                                                "00:00"
                                                                        ? "-"
                                                                        : widget
                                                                            .getJamKeluarSebelum
                                                                            .toString(),
                                                                    style:
                                                                    textScale.toString() == '1.17' ?
                                                                    GoogleFonts.lato(fontSize: 17,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold) :
                                                                    GoogleFonts.lato(fontSize: 19,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold)),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ]),
                                      ],
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ))),

          /* floatingActionButton: Visibility(
            visible: scroll_visibility,
          child :
            DraggableFab(
              child:
              FloatingActionButton.extended(
                backgroundColor: Colors.transparent,
                hoverElevation: 1.5,
                shape: StadiumBorder(
                    side: BorderSide(
                        color: HexColor("#075E54"), width: 1)),
                elevation: 0,
                onPressed: (){
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
                                    Align(alignment: Alignment.centerLeft,child: Text(getBahasa.toString() =="1" ? "Ulasan Aplikasi":"Application Review",
                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                    Padding(
                                      padding: EdgeInsets.only(top:15),
                                      child: Divider(height: 2,),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(top: 35,bottom: 25),
                                      child: TextFormField(
                                        style: GoogleFonts.nunitoSans(fontSize: 16),
                                        textCapitalization: TextCapitalization
                                            .sentences,
                                        maxLines: 3,
                                        controller: _ulasanController,
                                        decoration: InputDecoration(
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: FaIcon(
                                              FontAwesomeIcons.audioDescription,
                                              //color: clockColor,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                              top: 2),
                                          hintText: getBahasa.toString() == "1"? 'Tulis ulasan':'Write your review',
                                          labelText: getBahasa.toString() == "1"? 'Ulasan': 'Review',
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
                                            child: Text(getBahasa.toString() == "1"? "Kirim Ulasan" : "Send Review",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
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
                icon: FaIcon(FontAwesomeIcons.message,color: HexColor("#075E54"),),
                label: Text(getBahasa.toString() == "1"?  'Ulasan' :  'Review',style: TextStyle  (color: HexColor("#075E54"),)),
              ),
              /*FloatingActionButton(
            backgroundColor: Colors.transparent,
            hoverElevation: 1.5,
            shape: StadiumBorder(
                side: BorderSide(
                    color: Colors.blue, width: 1)),
            elevation: 0,
            onPressed: (){},
            child: FaIcon(FontAwesomeIcons.message,color: Colors.blue,),
          ),*/
            )
        ), */
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
        ),
        onWillPop: onWillPop);
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

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}
