import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParticipantItem extends StatefulWidget {
  final String participanteId;
  final String nome;
  final String urlFoto;
  final String numero;
  final int idade;

  ParticipantItem({
    Key key,
    @required this.participanteId,
    @required this.nome,
    @required this.urlFoto,
    @required this.numero,
    @required this.idade
  }) : super(key: key);

  @override
  _ParticipantItemState createState() => _ParticipantItemState();
}

class _ParticipantItemState extends State<ParticipantItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "${widget.urlFoto}",
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text(
                "${widget.nome}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: FlatButton(
                child: Text(
                  "Pente",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () async{
                  var resposta = await http.post("https://ue6t8qmmsg.execute-api"
                      ".us-east-1.amazonaws.com/teste/likes",
                      headers: {
                        'Content-Type': 'application/json'
                      },
                      body: jsonEncode({
                        'ParticipanteId': '234',
                        'ParticipanteDestinadoId': '787687'
                      }));
                },
              ),
            ),
          ],
        ),
        onTap: (){},
      ),
    );
  }
}
