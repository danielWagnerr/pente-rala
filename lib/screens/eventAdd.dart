import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pente_rala_app/util/data.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class EventAdd extends StatefulWidget {
  @override
  _EventAddState createState() => _EventAddState();
}

class _EventAddState extends State<EventAdd> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final format = DateFormat("dd-MM-yyy HH:mm");

  File file;
  String base64Image;
  String nomeEvento;
  String localEvento;
  String descricaoEvento;
  String organizadorEvento;
  DateTime dataInicio;
  DateTime dataFim;
  DateTime dateTeste;

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.base64Image = base64Encode(file.readAsBytesSync());

    Fluttertoast.showToast(
        msg: "Foto do evento escolhida!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _upload() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); //

      if (file == null) {
        Fluttertoast.showToast(
            msg: "Escolha uma foto para o evento!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 3,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }


      var resposta = await API.cadastrarEvento(
          this.nomeEvento,
          this.organizadorEvento,
          this.dataInicio.toLocal().microsecondsSinceEpoch~/1000000,
          this.dataFim.toLocal().microsecondsSinceEpoch~/1000000,
          this.localEvento,
          this.descricaoEvento,
          this.base64Image
      );

      if (resposta.statusCode == 200){
        Fluttertoast.showToast(
            msg: "Evento cadastrado!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.pop(context);
      }

      else
        Fluttertoast.showToast(
            msg: "Tivemos problemas ao realizar o cadastro do evento!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar um novo evento!"),
        centerTitle: true,
      ),
      body: Container(
        padding: new EdgeInsets.all(20.0),
        child: Form(
          key: this._formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      hintText: "Pente Rala", labelText: "Nome do evento"),
                  validator: Validators.required("Nome é obrigatório"),
                  onSaved: (value) {
                    this.nomeEvento = value;
                  }),
              TextFormField(
                  decoration:
                  InputDecoration(hintText: "Rua Pente Rala 117", labelText: "Local"),
                  validator: Validators.required('Local é obrigatório!'),
                  onSaved: (value) {
                    this.localEvento = value;
                  }),
              TextFormField(
                  decoration: InputDecoration(
                      hintText: "Conte sobre o evento",
                      labelText: "Descrição"),
                  validator: Validators.required('Descrição é obrigatório!'),
                  onSaved: (value) {
                    this.descricaoEvento = value;
                  }),
              DateTimeField(
                format: format,
                decoration: InputDecoration(
                    hintText: "Hora de início do evento",
                    labelText: "Hora de início do evento"),
                onShowPicker: (context, currentValue) async{
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null){
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  }
                  else
                    return currentValue;
                },
                validator: (date) => date == null ? 'Específicar o início é obrigatório!' : null,
                onSaved: (value) {
                  this.dataInicio = value;
                },
              ),
              DateTimeField(
                format: format,
                decoration: InputDecoration(
                    hintText: "Hora de término do evento",
                    labelText: "Hora de término do evento"),
                onShowPicker: (context, currentValue) async{
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null){
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  }
                  else
                    return currentValue;
                },
                validator: (date) => date == null ? 'Específicar o término é obrigatório!' : null,
                onSaved: (value) {
                  this.dataFim = value;
                },
              ),
              SizedBox(width: 20.0),
              SizedBox(width: 20.0),
              TextFormField(
                  decoration:
                  InputDecoration(hintText: "Senhor Pente Rala", labelText: "Organizador"),
                  validator: Validators.required('Organizador é obrigatório!'),
                  onSaved: (value) {
                    this.organizadorEvento = value;
                  }),
              Container(
                width: screenSize.width,
                child: RaisedButton(
                  child: Text(
                    "Escolher foto do evento",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => setState(() {
                    _choose();
                  }),
                  color: Colors.blue,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                width: screenSize.width,
                child: RaisedButton(
                  child: Text(
                    "Cadastrar Evento",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => setState(() {
                    _upload();
                  }),
                  color: Colors.blue,
                ),
                margin: EdgeInsets.only(top: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
