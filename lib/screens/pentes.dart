import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pente_rala_app/util/data.dart';
import 'dart:convert';
import 'package:pente_rala_app/widgets/participant_item.dart';


class Pentes extends StatefulWidget {
  @override
  _PentesState createState() => _PentesState();
}

class _PentesState extends State<Pentes> {

  Map evento;
  var participantes = new List<Participante>();

  _getEvento() async{
    var resposta = await API.getEventoEspecifico("234");

    var respostaJson = jsonDecode(resposta.body);

    setState(() {
      evento = respostaJson;

      Iterable list = evento['Participantes'];
      participantes = list.map((model) => Participante.fromJson(model)).toList();

    });
  }

  @override
  void initState() {
    super.initState();
    _getEvento();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Seu próximo evento está chegando..."),
        centerTitle: true
      ),

      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: participantes.length,
        itemBuilder: (BuildContext context, int index) {

          return ParticipantItem(
              participanteId: participantes[index].participanteId,
              nome: participantes[index].nome,
              urlFoto: participantes[index].urlFoto,
              numero: participantes[index].numero,
              idade: participantes[index].idade,
          );
        },
      )
    );
  }
}