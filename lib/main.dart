

import 'dart:convert';
import 'dart:io';

import 'package:abzeno/page_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:overlay_support/overlay_support.dart';
import 'NotificationBadge.dart';
import 'package:http/http.dart' as http;

/*Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //print("Handling a background message: ${message.messageId}");
}*/

class PostHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void sendPushMessage(String body, String title, String token) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
        'key=AAAAVP5vBq4:APA91bGvVTStKA9iLBPDYm7JIBM6mjtaFibpc6QT3S4lJo4eAVYe6hO29_KeV_VLFTf_FfMFeyelwgAb2PB9acRxO1x_zfMnaQGu1BBbZPW-qNPVkGB9x3xhXIHrKWDt1HDBblgIUY1e',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Halo',
            'title': 'misHR',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "to": 'cwHx7KCCRv2dpqCYLKgB-t:APA91bFvilwLQq0K5Wzni6XWozmBOcBmznxsLyy_HwHvvFKBiKVVNMGryWINTNhwkVnjdfllWpwmtrGJh1GWVCIoAR8MQcvDElRP88ahzrVtXTanHTOp_mNofK8efpmuFbW7JDE6G9MM',
        },
      ),
    );
    //print('done');
  } catch (e) {
   // print("error push notification");
  }
}

late final FirebaseMessaging _messaging = FirebaseMessaging.instance;
String? getTokenMe;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = new PostHttpOverrides();
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    //..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = true
    ..dismissOnTap = false;

  _messaging.getToken().then((value) {
    getTokenMe = value;
  });

  _messaging.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showSimpleNotification(
      Text('${message.notification?.title}', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
      leading: NotificationBadge(totalNotifications: 1),
      subtitle: Text('${message.notification?.body}', style: GoogleFonts.nunitoSans(),),
      background: HexColor("#66000000"),
      duration: Duration(seconds: 5),
    );

  });


/*

  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          //FirebaseMessaging.onBackgroundMessage(RemoteMessage message);
          _messaging.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
                showSimpleNotification(
                    Text('${message.notification?.title}', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
                    leading: NotificationBadge(totalNotifications: 1),
                    subtitle: Text('${message.notification?.body}', style: GoogleFonts.nunitoSans(),),
                    background: HexColor("#66000000"),
                    duration: Duration(seconds: 5),
                  );

          });
  } else {
    print('User declined or has not accepted permission');
  }*/


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MIS HR',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PageCheck("", getTokenMe?? ""),
        builder: EasyLoading.init(),
      ),
    );
  }



}