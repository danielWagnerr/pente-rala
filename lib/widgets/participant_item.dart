import 'package:flutter/material.dart';

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
                onPressed: () {}
              ),
            ),
          ],
        ),
        onTap: (){},
      ),
    );
  }
}
