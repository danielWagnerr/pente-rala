import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pente_rala_app/screens/event.dart';

class PostItem extends StatefulWidget {
  final String eventoId;
  final int dataHoraInicio;
  final int dataHoraFim;
  final String local;
  final String nome;
  final String organizador;
  final String urlImagem;
  final String descricao;


  PostItem({
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
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  var participanteId;

  void _retornaIdUsuario() async{
    var user = await FirebaseAuth.instance.currentUser();
    participanteId =  user.uid;
  }

  @override
  void initState() {
    _retornaIdUsuario();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(
                "${widget.nome}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "${widget.local}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),
            Image.network(
              "${widget.urlImagem}",
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),

          ],
        ),
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventoRoute(
                eventoId: widget.eventoId,
                nome: widget.nome,
                dataHoraInicio: widget.dataHoraInicio,
                dataHoraFim: widget.dataHoraFim,
                local: widget.local,
                organizador: widget.organizador,
                urlImagem: widget.urlImagem,
                descricao: widget.descricao,
                participanteId: participanteId,
              ))
          );
        },
      ),
    );
  }
}
