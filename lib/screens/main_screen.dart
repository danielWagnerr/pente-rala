import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pente_rala_app/screens/chats.dart';
import 'package:pente_rala_app/screens/home.dart';
import 'package:pente_rala_app/screens/notifications.dart';
import 'package:pente_rala_app/screens/swipe_feed_page.dart';
import 'package:pente_rala_app/util/data.dart';
import 'package:pente_rala_app/widgets/icon_badge.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class Match extends StatefulWidget {
  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {
  @override
  Widget build(BuildContext context) {}
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 2;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String myId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          Chats(),
          SwipeFeedPage(),
          Home(),
          Notifications(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Theme.of(context).primaryColor,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.grey[500]),
              ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: IconBadge(
                icon: Icons.notifications,
              ),
              title: Container(height: 0.0),
            )
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void retornaIdUsuario() async{
    var user = await FirebaseAuth.instance.currentUser();
    myId = user.uid;
  }

  @override
  void initState() {
    super.initState();
    retornaIdUsuario();

    _pageController = PageController(initialPage: 2);

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Settings registered');
    });

    firebaseMessaging.configure(onLaunch: (Map<String, dynamic> msg) {
      print("onLaunch called");
    }, onResume: (Map<String, dynamic> msg) {
      print("onResume called");

      var participanteId = msg['data']['participanteId'];
      var nome = msg['data']['nome'];
      var urlFoto = msg['data']['urlFoto'];
      var mensagem1 = msg['data']['mensagem1'];
      var mensagem2 = msg['data']['mensagem2'];

      match(participanteId, nome, urlFoto, mensagem1, mensagem2);
    }, onMessage: (Map<String, dynamic> msg) async {
      print("onMessage called!");

      var participanteId = msg['data']['participanteId'];
      var nome = msg['data']['nome'];
      var urlFoto = msg['data']['urlFoto'];
      var mensagem1 = msg['data']['mensagem1'];
      var mensagem2 = msg['data']['mensagem2'];

      match(participanteId, nome, urlFoto, mensagem1, mensagem2);
    });
  }

  void match(
      String participanteId, String nome, String urlFoto, String mensagem1, String mensagem2) {
    if (mensagem1.length != 0) {

      if (mensagem1.length != 0 && mensagem2.length == 0) {
        Widget segundaMsg = Container();
        bool inputVisivel = true;
        String mensagem;

        showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: new Text("Você deu uma pentada!"),
                  content: new SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(
                            "${urlFoto}",
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 20),
                          Bubble(
                            margin: BubbleEdges.only(top: 10),
                            alignment: Alignment.topLeft,
                            nipWidth: 8,
                            nipHeight: 24,
                            nip: BubbleNip.leftTop,
                            child: Text(mensagem1,
                                textAlign: TextAlign.right),
                          ),
                          SizedBox(height: 20),
                          segundaMsg,
                          Visibility(
                              visible: inputVisivel,
                              child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                      'Pode enviar apenas uma mensagem!',
                                      isDense: true),
                                  onChanged: (value) {
                                    mensagem = value;
                                  }))
                        ]),
                  ),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text(
                        "Cancelar",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text(
                        "Enviar",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () async {
                        var resposta = await API.enviarMensagem(myId, participanteId, mensagem1, mensagem);

                        if (resposta.statusCode == 200) {
                          inputVisivel = false;
                          setState(() {
                            segundaMsg = Bubble(
                              margin: BubbleEdges.only(top: 10),
                              alignment: Alignment.topRight,
                              nipWidth: 8,
                              nipHeight: 24,
                              nip: BubbleNip.rightTop,
                              color: Color.fromRGBO(225, 255, 199, 1.0),
                              child: Text(mensagem, textAlign: TextAlign.right),
                            );
                          });
                        }
                        else {
                          Fluttertoast.showToast(
                              msg: "Ocorreu algum problema ao enviar a mensagem!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 2,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0)),
                );
              },
            ));
      } else {
        showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: new Text("Você deu uma pentada!"),
                  content: new SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(
                            "${urlFoto}",
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 20),
                          Bubble(
                            margin: BubbleEdges.only(top: 10),
                            alignment: Alignment.topRight,
                            nipWidth: 8,
                            nipHeight: 24,
                            nip: BubbleNip.rightTop,
                            color: Color.fromRGBO(225, 255, 199, 1.0),
                            child: Text(mensagem1,
                                textAlign: TextAlign.right),
                          ),
                          SizedBox(height: 20),
                          Bubble(
                            margin: BubbleEdges.only(top: 10),
                            alignment: Alignment.topLeft,
                            nipWidth: 8,
                            nipHeight: 24,
                            nip: BubbleNip.leftTop,
                            child: Text(mensagem2,
                                textAlign: TextAlign.right),
                          ),
                          SizedBox(height: 20),
                        ]),
                  ),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text(
                        "Sair",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0)),
                );
              },
            ));
      }
    }

    else {
      String mensagem;
      Widget primeiraMsg = Container();
      Widget segundaMsg = Container();
      bool inputVisivel = true;

      showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: new Text("Você deu uma pentada!"),
                content: new SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                          "${urlFoto}",
                          height: 170,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        primeiraMsg,
                        SizedBox(height: 20),
                        segundaMsg,
                        Visibility(
                            visible: inputVisivel,
                            child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                    'Pode enviar apenas uma mensagem!',
                                    isDense: true),
                                onChanged: (value) {
                                  mensagem = value;
                                }))
                      ]),
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text(
                      "Cancelar",
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text(
                      "Enviar",
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      var resposta = await API.enviarMensagem(myId, participanteId, mensagem, mensagem2);

                      if (resposta.statusCode == 200) {
                        inputVisivel = false;
                        setState(() {
                          primeiraMsg = Bubble(
                            margin: BubbleEdges.only(top: 10),
                            alignment: Alignment.topRight,
                            nipWidth: 8,
                            nipHeight: 24,
                            nip: BubbleNip.rightTop,
                            color: Color.fromRGBO(225, 255, 199, 1.0),
                            child: Text(mensagem, textAlign: TextAlign.right),
                          );
                        });
                      }
                      else {
                        Fluttertoast.showToast(
                            msg: "Ocorreu algum problema ao enviar a mensagem!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 2,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0)),
              );
            },
          ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
