import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pente_rala_app/util/data.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class EventoRoute extends StatelessWidget {
  final String eventoId;
  final int dataHoraInicio;
  final int dataHoraFim;
  final String local;
  final String nome;
  final String organizador;
  final String urlImagem;
  final String descricao;


  EventoRoute({
    Key key,
    @required this.eventoId,
    @required this.dataHoraInicio,
    @required this.dataHoraFim,
    @required this.local,
    @required this.nome,
    @required this.organizador,
    @required this.urlImagem,
    @required this.descricao
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    initializeDateFormatting("pt_BR", null);
    String dataInicio = DateFormat.MMMMEEEEd("pt_BR")
        .format(new DateTime.fromMicrosecondsSinceEpoch(dataHoraInicio));

    String horaInicio = DateFormat.Hms("pt_BR")
        .format(new DateTime.fromMicrosecondsSinceEpoch(dataHoraInicio));


    String dataFim =  DateFormat.MMMMEEEEd("pt_BR")
        .format(new DateTime.fromMicrosecondsSinceEpoch(dataHoraFim))
        .toUpperCase();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            nome,
            style: TextStyle(
                color: Colors.black54
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          icon: const Icon(Icons.local_activity),
          label: const Text('Participar'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Preparado(a) para o evento?"),
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
                          "Pentada",
                          style: TextStyle(fontSize: 15),
                          ),
                      onPressed: () async {
                        var resposta = await http.post("https://7ccaa60l36.exe"
                            "cute-api.us-east-1.amazonaws.com/teste/eventos/"
                            "${eventoId}/participar",
                            headers: {
                                    'Content-Type': 'application/json'
                            },
                            body: jsonEncode({
                                    'ParticipanteId': '234'
                            }));

                        print(resposta.statusCode);
                        if(resposta.statusCode == 200){
                          Navigator.of(context).pop();

                          Fluttertoast.showToast(
                              msg: "Agora é só esperar a pentada!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 2,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }

                      },
                    ),
                  ],

                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0)
                  ),
                );
              },
            );
          },
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.map, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.grey,),
              onPressed: () {},
            )
          ],
        ),
      ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                    child:
                    Image.network(
                        urlImagem,
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover
                    )
                ),
                SizedBox(height: 15),
                Text(
                    local,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54
                    )
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.home,
                        size: 14,
                        color: Colors.grey),
                    Text(
                        " Rua Ana Paula 117, Bairro Santa Cruz",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey
                        )
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.access_time,
                        size: 14,
                        color: Colors.grey),
                    Text(
                        " "+ dataFim.toString() + " - " + horaInicio,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey
                        )
                    )
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                Text(
                  descricao,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300
                  ),
                ),
                Divider(),
                SizedBox(height: 20),
                Text(
                    "Alguns dos participantes...",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54
                    )
                ),
                SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  padding: EdgeInsets.all(5),
                  itemCount: 15,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 200 / 200,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CircleAvatar(
                          backgroundImage: AssetImage(
                          "assets/cm${random.nextInt(10)}.jpeg",
                        ),
                        radius: 50,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
    );
  }
}