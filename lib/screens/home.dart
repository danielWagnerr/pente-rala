import 'package:flutter/material.dart';
import 'package:pente_rala_app/screens/eventAdd.dart';
import 'package:pente_rala_app/util/data.dart';
import 'package:pente_rala_app/widgets/post_item.dart';
import 'dart:convert';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var eventos = new List<Evento>();

  _getEventos(){
    API.getEventos().then((resposta){

      var respostaJson = jsonDecode(resposta.body);

      if (respostaJson is Iterable<dynamic>) {
        setState(() {
          Iterable list = respostaJson;
          eventos = list.map((model) => Evento.fromJson(model)).toList();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getEventos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: (){},
          ),
        ],
      ),

      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: eventos.length,
        itemBuilder: (BuildContext context, int index) {

          return PostItem(
            eventoId: eventos[index].eventoId,
            nome: eventos[index].nome,
            dataHoraInicio: eventos[index].dataHoraInicio,
            dataHoraFim: eventos[index].dataHoraFim,
            local: eventos[index].local,
            organizador: eventos[index].organizador,
            urlImagem: eventos[index].urlImagem,
            descricao: eventos[index].descricao
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        child: Icon(
          Icons.add,
        ),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventAdd())
          );
        },
        mini: true,
      ),
    );
  }
}