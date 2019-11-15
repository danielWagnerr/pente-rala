import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pente_rala_app/screens/main_screen.dart';
import 'package:pente_rala_app/util/const.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      print(user.uid);
    });

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isDark ? Constants.darkPrimary : Constants.lightPrimary,
      statusBarIconBrightness: isDark?Brightness.light:Brightness.dark,
    ));

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg){
        print("onLaunch called");
      },
      onResume: (Map<String, dynamic> msg){
        print("onResume called");
      },
      onMessage: (Map<String, dynamic> msg){
        print("onMessage called");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true,
            alert: true,
            badge: true
        )
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings setting){
      print('IOS Settings registered');
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: isDark ? Constants.darkTheme : Constants.lightTheme,
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phoneNumber;
  String smsCode;
  String verificationId;

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verifyId) {
      this.verificationId = verifyId;
    };

    final PhoneCodeSent smsCodeSent = (String verifyId, [int forceCodeResend]){
      this.verificationId = verifyId;
      smsCodeDialog(context).then((value){
        print("Autenticado!");
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential credential){
      print("Verificado");
    };

    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiedFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve
    );
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Digite o código'),
          content: TextField(
            onChanged: (value) {
              this.smsCode= value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            new FlatButton(
              child: Text('Entrar'),
              onPressed: () {
                FirebaseAuth.instance.currentUser().then((user){
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreen()),
                    );
                  }
                  else {
                    Navigator.of(context).pop();
                    signIn();
                  }
                });
              },
            )
          ],
        );
      }
    );
  }

  signIn() {
    final AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);

    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen()),
      );
    });
  }

  bool isDark = false;

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isDark ? Constants.darkPrimary : Constants.lightPrimary,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print("onLaunch called");
      },
      onResume: (Map<String, dynamic> msg) {
        print("onResume called");
      },
      onMessage: (Map<String, dynamic> msg) {
        print("onMessage called");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Settings registered');
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Autenticação"),
          centerTitle: true,
        ),
        body: new Center(
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Número do telefone'),
                  onChanged: (value) {
                    this.phoneNumber = value;
                  },
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  onPressed: verifyPhone,
                  child: Text('Verificar'),
                  textColor: Colors.white,
                  elevation: 7.0,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ));
  }
}
