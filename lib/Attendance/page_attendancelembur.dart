


import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:abzeno/Attendance/page_doattendancelembur.dart';
import 'package:abzeno/attendance/page_doattendance.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geolocator; // you can change this to what you want
import 'package:intl/intl.dart';
import 'package:location/location.dart' as locator;
import '../helper/app_helper.dart';
import '../helper/app_link.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helper/page_route.dart';
import '../page_login.dart';


class PageClockInLembur extends StatefulWidget{
  final String getKaryawanNo;
  final String getJam;
  final String getLocationId;
  final String getNamaHari;
  final String getLocationLat;
  final String getLocationLong;
  final String getAttendanceType;
  final String getKaryawanNama;
  final String getKaryawanJabatan;
  final String getStartTime;
  final String getEndTime;
  final String getScheduleName;
  final String getWorkLocation;
  const PageClockInLembur(
      this.getKaryawanNo,
      this.getJam,
      this.getLocationId,
      this.getNamaHari,
      this.getLocationLat,
      this.getLocationLong,
      this.getAttendanceType,
      this.getKaryawanNama,
      this.getKaryawanJabatan,
      this.getStartTime,
      this.getEndTime,
      this.getScheduleName,
      this.getWorkLocation);
  @override
  _PageClockInLembur createState() => _PageClockInLembur();
}



class _PageClockInLembur extends State<PageClockInLembur> {
  late double _distanceInMeters;
  bool _isvisibleBtn = false;
  bool isPressed = false;
  var jarak = 0;
  String BtnAttend = "0";
  //LatLng _initialcameraposition = LatLng(-7.281798579483975, 112.73688279669264);
  late LatLng currentPostion = LatLng(-2.317671039583578, 115.67280345960125);
  late LatLng _locationCabang;
  late LatLng _locationCabang2 = LatLng(-2.317671039583578, 115.67280345960125);
  late String locationLat;
  late String locationLong;




  late GoogleMapController _controller;
  locator.Location _location = locator.Location();
  bool servicestatus = false;
  bool haspermission = false;
  late geolocator.Position position;
  String long = "", lat = "";
  final _noteclockin = TextEditingController();
  final Set<Marker> markers = new Set();
  var getJam2 = '';


  String gpsOff = "0";




  late LocationSettings locationSettings;

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      long = position.longitude.toString();
      lat = position.latitude.toString();
      getme(long,lat);
    });

  }


  void _onMapCreated(GoogleMapController _cntlr) async
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          //CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
          CameraPosition(target: currentPostion,zoom: 17),
        ),
      );
    });
  }





  void getme(String LongVal, String LatVal) async {
    _distanceInMeters = await GeolocatorPlatform.instance.distanceBetween(double.parse(locationLat)
        , double.parse(locationLong), double.parse(LatVal), double.parse(LongVal));
    jarak = _distanceInMeters.ceil();
    setState(() {
      _isvisibleBtn = true;
    });
  }

  String getBahasa = "1";
  String getToken = "0";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
        getToken = value[23];
      });});
  }


  String rangemaxstr = "0";
  getRangeMax() async {
    await AppHelper().getRangeMax().then((value){
      setState(() {
        rangemaxstr = value[0];
      });});
  }



  getNewWorkLocation2(getLokasi) async {
    await AppHelper().getNewWorkLocation(getLokasi).then((value){
      setState(() {
        locationLat = value[0];
        locationLong = value[1];
        _locationCabang = LatLng(double.parse(value[0]), double.parse(value[1]));
        // print(value[0]+" ------ "+value[1]);
        _loaddata();
      });});
  }



  _startingVariable() async {
    EasyLoading.show(status: AppHelper().loading_text);
    _noteclockin.clear();
    await getSettings();
    await getRangeMax();
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        setState(() {
          isPressed = false;
        });
        return false;
      } else {
        setState(() {
          isPressed = true;
        });
      }
    });
    await AppHelper().getSession().then((value){
      setState(() {
        if(value[0] == "" || value[0] == null) {
          Navigator.pushReplacement(context, ExitPage(page: PageLogin(getBahasa, getToken)));
          EasyLoading.dismiss();
        }
      });});
    await getLocation();
    EasyLoading.dismiss();
  }

  var data;
  int lengthme = 0;
  List scheduleList = [];
  var selectedscheduleList;
  Future getAllCabang() async {
    var response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getCabangAll&getKaryawanNo="+widget.getKaryawanNo));
    data = json.decode(response.body);
    setState(() {
      lengthme = data.length;
      scheduleList = data;
    });
  }




  _loaddata() async {
    await getAllCabang();
    await _startingVariable();
  }


  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(currentPostion.toString()),
        position: currentPostion, //position of marker
        infoWindow: InfoWindow( //popup info
          title: getBahasa.toString() == "1"? 'Lokasi Saya' : 'My Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), //Icon for Marker
      ));

      for (int i = 0; i < lengthme; i++) {
        if(data[i]['cabang_lat'] != '' && data[i]['cabang_long'] != '') {
          _locationCabang2 = LatLng(double.parse(data[i]['cabang_lat']), double.parse(data[i]['cabang_long']));
          markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: _locationCabang2,
            infoWindow: InfoWindow(
              title: data[i]['cabang_nama'],
              snippet: data[i]['cabang_kota'],
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        }
      }
    });
    return markers;
  }


  var _timeString = DateFormat('HH:mm').format(DateTime.now());
  void _getCurrentTime()  {
    setState(() {
      _timeString = "${DateFormat('HH').format(DateTime.now())}:${DateFormat('mm').format(DateTime.now())}";
    });
  }


  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds:1), (Timer t)=> _getCurrentTime());
    setState(() {
      locationLat = widget.getLocationLat;
      locationLong = widget.getLocationLong;
      _locationCabang = LatLng(double.parse(locationLat), double.parse(locationLong));
      selectedscheduleList = widget.getWorkLocation;
    });
    _loaddata();

  }



  showInvalidDateTimeSettingDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(getBahasa.toString() == "1"? "Tutup" : "Close",style: GoogleFonts.lexendDeca(color: Colors.black),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        style: ElevatedButton.styleFrom(
            primary: HexColor("#1a76d2"),
            elevation: 0,
            shape: RoundedRectangleBorder(side: BorderSide(
                color: Colors.white,
                width: 0.1,
                style: BorderStyle.solid
            ),
              borderRadius: BorderRadius.circular(5.0),
            )),
        child: Text(getBahasa.toString() == "1"?  "Pengaturan":"Setting",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold),),
        onPressed:  () {
          DatetimeSetting.openSetting();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Kesalahan Ditemukan" :"Error Found", style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),textAlign:
      TextAlign.center,),
      content: Text(getBahasa.toString() == "1"?  "Kami menemukan pengaturan waktu anda tidak standart, silahkan nyalakan pengaturan waktu dan tanggal otomatis di perangkat anda,"
          " atau tap button pengaturan di bawah ini"
          : "We found your time settings are not standard, please turn on automatic time and date settings on your device, or tap the settings button below", style: GoogleFonts.nunitoSans(),textAlign:
      TextAlign.center,),
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



  _goattendanceiOS() async {
    widget.getAttendanceType.toString() == 'CLOCK IN' ?
    Navigator.push(context, ExitPage(page: ClockOutLembur(
        widget.getKaryawanNo,
        _timeString,
        AppHelper().getNamaHari().toString(),
        _noteclockin.text,
        "Clock In",
        widget.getKaryawanNama,
        widget.getKaryawanJabatan,
        widget.getStartTime,widget.getEndTime,widget.getScheduleName,
        selectedscheduleList,
        locationLat,
        locationLong)))
        :
    Navigator.push(context, ExitPage(page: ClockOutLembur(
        widget.getKaryawanNo,
        _timeString,
        AppHelper().getNamaHari().toString(),
        _noteclockin.text,
        "Clock Out",
        widget.getKaryawanNama,
        widget.getKaryawanJabatan,
        widget.getStartTime,widget.getEndTime,widget.getScheduleName,
        selectedscheduleList,
        locationLat,
        locationLong)));
  }




  _goattendance() async {
    bool timeAuto = await DatetimeSetting.timeIsAuto();
    bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();

    if (!timezoneAuto || !timeAuto) {
      EasyLoading.dismiss();
      showInvalidDateTimeSettingDialog(context);
      return false;
    } else {
      widget.getAttendanceType.toString() == 'CLOCK IN' ?
      Navigator.push(context, ExitPage(page: ClockOutLembur(
          widget.getKaryawanNo,
          _timeString,
          AppHelper().getNamaHari().toString(),
          _noteclockin.text,
          "Clock In",
          widget.getKaryawanNama,
          widget.getKaryawanJabatan,
          widget.getStartTime,widget.getEndTime,widget.getScheduleName,
          selectedscheduleList,
          locationLat,
          locationLong)))
          :
      Navigator.push(context, ExitPage(page: ClockOutLembur(
          widget.getKaryawanNo,
          _timeString,
          AppHelper().getNamaHari().toString(),
          _noteclockin.text,
          "Clock Out",
          widget.getKaryawanNama,
          widget.getKaryawanJabatan,
          widget.getStartTime,widget.getEndTime,widget.getScheduleName,
          selectedscheduleList,
          locationLat,
          locationLong)));

    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        //backgroundColor: HexColor("#3a5664"),
        backgroundColor: Colors.white,
        title: Text(_timeString, style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        centerTitle: true,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 20,color: HexColor("#525a67")),
              color: Colors.white,
              onPressed: ()  {
                Navigator.pop(context);
              }),
        ),
        actions: [
          Padding(padding: EdgeInsets.only(top:19,bottom: 19,right: 10),
            child: InkWell(
              onTap: (){
                _loaddata();
              },
              child: FaIcon(FontAwesomeIcons.refresh,color: HexColor("#525a67"),size: 19,),
            ),),

          Padding(padding: EdgeInsets.all(19),
            child: InkWell(
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
                                      Text("Information",
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
                                      ListTile(
                                        visualDensity: VisualDensity(horizontal: -2),
                                        dense : true,
                                        leading : FaIcon(FontAwesomeIcons.locationDot,color: Colors.red,),
                                        title: Text("Lokasi Absen",style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,fontSize: 15),),
                                        subtitle: Text("Adalah tanda lokasi absen anda",
                                            style: GoogleFonts.workSans(
                                                fontSize: 12)),
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),),

                                      ListTile(
                                        leading : FaIcon(FontAwesomeIcons.locationDot,color: HexColor("#3590e9"),),
                                        visualDensity: VisualDensity(horizontal: -2),
                                        dense : true,
                                        title: Text("Lokasi Saya",style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,fontSize: 15),),
                                        subtitle: Text("Adalah tanda dimana anda berada",
                                            style: GoogleFonts.workSans(
                                                fontSize: 12)),
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1,bottom: 5),),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      );
                    });
              },
              child: FaIcon(FontAwesomeIcons.circleInfo,color: HexColor("#525a67"),size: 20,),
            ),)


        ],

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            child : Column(
              children: <Widget>[
                currentPostion == null ?
                Container(
                    height: 180,
                    child : Center(
                      child: CircularProgressIndicator(),
                    )
                )
                    :
                Container(
                  height: 185,
                  child : GoogleMap(
                    initialCameraPosition: CameraPosition(target: currentPostion),
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: false,
                    markers: getmarkers(),
                    zoomGesturesEnabled : false,
                    scrollGesturesEnabled : false,
                    rotateGesturesEnabled : false,
                    circles: Set.from([Circle( circleId: CircleId('currentCircle'),
                      center: _locationCabang,
                      radius: 60,
                      fillColor: Colors.blue.shade100.withOpacity(0.5),
                      strokeColor:  Colors.blue.shade100.withOpacity(0.1),
                    ),],),
                  ),
                ),
                Divider(height: 1,),

                Padding(padding: const EdgeInsets.only(left: 25,top: 5,right: 25),
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 0,top: 25)),
                        widget.getAttendanceType == 'CLOCK IN' ?
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            style: GoogleFonts.workSans(fontSize: 16),
                            textCapitalization: TextCapitalization.sentences,
                            controller: _noteclockin,
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
                              hintText: getBahasa.toString() == "1" ? 'Tuliskan Catatan Kehadiran':'Input Attendance Note',
                              labelText: getBahasa.toString() == "1" ? 'Catatan Kehadiran':'Attendance Note',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4"), fontSize: 13),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD")),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#8c8989")),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD")),
                              ),
                            ),
                          ),
                        ),): Container()
                      ],
                    )
                ),


                Padding(padding: const EdgeInsets.only(top: 40,left: 25,right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child:     Text("Lokasi absen :",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.varelaRound(fontSize: 12),
                        ),
                      ),
                    ],
                  ),),

                Padding(padding: const EdgeInsets.only(left: 25,right: 25),
                  child: Align(alignment: Alignment.centerLeft, child :  Container(
                    child: DropdownButton(
                      isExpanded: false,
                      hint: Text(getBahasa.toString() == "1"? "Pilih Lokasi Absen": "Choose new schedule",
                        style: GoogleFonts.workSans(
                            fontSize: 15, color: Colors.black),),
                      value: selectedscheduleList,
                      items:
                      scheduleList.map((item) {
                        return DropdownMenuItem(
                          value: item['cabang_nama'].toString(),
                          child: Text(item['cabang_nama'].toString(),
                              style: GoogleFonts.workSans(
                                  fontSize: 15, color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          selectedscheduleList = value.toString();
                          //print(selectedscheduleList);
                          getNewWorkLocation2(selectedscheduleList);
                        });
                      },
                    ),
                  )),
                ),

                Padding(padding: const EdgeInsets.only(top: 20,left: 25,right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child:     Text(
                          getBahasa.toString() == "1" ? "Jarak anda dari lokasi absen":"Your distance from current location",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.varelaRound(fontSize: 12),
                        ),
                      ),
                      Text(jarak.toString()+" meters",
                          style: GoogleFonts.varelaRound(fontSize: 13,fontWeight: FontWeight.bold)),
                    ],
                  ),),
                Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                  child: Align(alignment: Alignment.centerLeft, child : Text(
                      getBahasa.toString() == "1" ? "(jarak tidak boleh lebih dari "+rangemaxstr.toString()+" meter)":
                      "(Not Allowed in more than "+AppHelper().range_max.toString()+" meters)",
                      style: GoogleFonts.varelaRound(fontSize: 10))),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                  child: Divider(),
                ),
              ],
            )
        ),
      ),
      bottomSheet: Container(
          height: 125,
          width: double.infinity,
          child : Column(
            children: [

              gpsOff == "0" ?
              Opacity(
                opacity: 0.8,
                child :    Container(
                  width: double.infinity,
                  color: HexColor("#DDDDDD"),
                  padding : const EdgeInsets.only(left: 25,right: 25),
                  child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.infoCircle,size: 25,),
                      title: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          getBahasa.toString() == "1" ?
                          "Pastikan GPS anda menyala saat melakukan absensi. Jika map loading terus maka tap icon refresh yang ada di pojok kanan atas"
                              : "Make sure your GPS is on when making attendance"
                          ,style: GoogleFonts.nunitoSans(fontSize: 12),),
                      )
                  ),
                ),
              ) :
              Opacity(
                opacity: 0.8,
                child :    Container(
                  width: double.infinity,
                  color: HexColor("#ffeaef"),
                  padding : const EdgeInsets.only(left: 25,right: 25),
                  child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.infoCircle,size: 25,),
                      title: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          getBahasa.toString() == "1" ?
                          "Mohon maaf, Layanan GPS anda tidak aktif, aktifkan lokasi GPS dan silahkan coba lagi"
                              : "Sorry, your GPS service is not active, please activate GPS location and please try again"
                          ,style: GoogleFonts.nunitoSans(fontSize: 12),),
                      )
                  ),
                ),
              ),


              Container(
                  width: double.infinity,
                  height: 62,
                  padding : const EdgeInsets.only(left: 25,right: 25,bottom: 10,top: 5),
                  child :
                  Visibility(
                      visible: _isvisibleBtn,
                      child:

                      isPressed == true ?
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            //primary: HexColor("#075E54"),
                            primary: HexColor("#00aa5b"),
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.white,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        child : Text(widget.getAttendanceType.toString()+" LEMBUR",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                            fontSize: 14),),
                        onPressed: (){
                          setState(() {
                            //isPressed = true;
                          });
                          //_addattendance();
                          if(int.parse(jarak.toString()) > int.parse(rangemaxstr) ) {
                            getBahasa.toString() == "1" ?
                            AppHelper().showFlushBarerror(context, "Maaf anda tidak bisa absen karena berada diluar area yang ditentukan")
                                : AppHelper().showFlushBarerror(context, "Sorry you can't do attendance because you are outside the designated area");
                            setState(() {
                              //isPressed = false;
                            });
                            return;
                          } else {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (Platform.isIOS) {
                              _goattendanceiOS();
                            }else {
                              _goattendance();
                            }
                          }
                          //EasyLoading.show(status: "Loading...");
                        },
                      )
                          :
                      Opacity(
                          opacity : 0.5,
                          child : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: HexColor("#DDDDDD"),
                                shape: RoundedRectangleBorder(side: BorderSide(
                                    color: Colors.white,
                                    width: 0.1,
                                    style: BorderStyle.solid
                                ),
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                            child : Text("CLOCK IN",style: GoogleFonts.lexendDeca(color:Colors.white,fontWeight: FontWeight.bold,
                                fontSize: 14),),
                            onPressed: (){
                            },
                          )
                      )
                  )
              ),
            ],
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

