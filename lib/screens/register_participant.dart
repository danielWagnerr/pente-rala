import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pente_rala_app/screens/main_screen.dart';
import 'package:pente_rala_app/util/data.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class RegisterParticipant extends StatefulWidget {
  @override
  _RegisterParticipantState createState() => _RegisterParticipantState();
}

class Genero {
  int id;
  String genero;

  Genero(this.id, this.genero);

  static List<Genero> getGeneros() {
    return <Genero>[Genero(1, "Masculino"), Genero(2, "Feminino")];
  }
}

class _RegisterParticipantState extends State<RegisterParticipant> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final format = DateFormat("dd-MM-yyy");
  List<Genero> _generos = Genero.getGeneros();
  List<DropdownMenuItem<Genero>> _dropdownMenuItems;
  Genero _generoSelecionado;
  String _foto = "";

  File file;
  String base64Image;
  String nome;
  String email;
  DateTime idade;
  String genero;
  String descricao;
  String senha;

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);

    this.base64Image = base64Encode(file.readAsBytesSync());
  }

  void _upload() async {
    if (file == null) return;

    var user = await FirebaseAuth.instance.currentUser();
    var deviceToken = await new FirebaseMessaging().getToken();

    var resposta = await API.cadastraParticipante(
        user.uid,
        this.email,
        this.nome,
        this.idade.toUtc().millisecondsSinceEpoch,
        genero,
        descricao,
        base64Image,
        deviceToken);

    if (resposta.statusCode == 200)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );

    else
      Fluttertoast.showToast(
          msg: "Tivemos problemas ao realizar o cadastro",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          textColor: Colors.white,
          fontSize: 16.0);
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_generos);
    _generoSelecionado = _dropdownMenuItems[0].value;
    this.genero = _generoSelecionado.genero;
    super.initState();
  }

  List<DropdownMenuItem<Genero>> buildDropdownMenuItems(List generos) {
    List<DropdownMenuItem<Genero>> items = List();
    for (Genero genero in generos) {
      items.add(DropdownMenuItem(
        value: genero,
        child: Text(genero.genero),
      ));
    }
    return items;
  }

  onChangeDropdownItem(Genero generoSelecionado) {
    this.genero = generoSelecionado.genero;
    setState(() {
      _generoSelecionado = generoSelecionado;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        centerTitle: true,
        leading: Container(),
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
                      hintText: "pente@rala.com", labelText: "E-mail"),
                  validator: Validators.compose([
                    Validators.required("E-mail é obrigatório"),
                    Validators.email("E-mail inválido")
                  ]),
                  onChanged: (value) {
                    this.email = value;
                  }),
              TextFormField(
                  decoration:
                      InputDecoration(hintText: "Nome", labelText: "Nome"),
                  validator: Validators.required('Nome é obrigatório'),
                  onChanged: (value) {
                    this.nome = value;
                  }),
              TextFormField(
                  decoration: InputDecoration(
                      hintText: "Conte um pouco sobre você",
                      labelText: "Descrição"),
                  validator: Validators.required('Nome é obrigatório'),
                  onChanged: (value) {
                    this.descricao = value;
                  }),
              DateTimeField(
                format: format,
                decoration: InputDecoration(
                    hintText: "Data de Nascimento",
                    labelText: "Data de nascimento"),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                onChanged: (value) {
                  this.idade = value;
                },
              ),
              SizedBox(width: 20.0),
              DropdownButton(
                value: _generoSelecionado,
                items: _dropdownMenuItems,
                onChanged: onChangeDropdownItem,
              ),
              SizedBox(width: 20.0),
              TextFormField(
                  obscureText: true,
                  decoration:
                      InputDecoration(hintText: "Senha", labelText: "Senha"),
                  validator: Validators.required('Senha é obrigatória'),
                  onChanged: (value) {
                    this.senha = value;
                  }),
              Container(
                width: screenSize.width,
                child: RaisedButton(
                  child: Text(
                    "Escolher uma foto",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => setState(() {
                    _choose();
                    _foto =
                        "Foto Selecionada, caso mude de idéia, apenas selecione outra!";
                  }),
                  color: Colors.blue,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Text(
                _foto,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              Container(
                width: screenSize.width,
                child: RaisedButton(
                  child: Text(
                    "Cadastrar",
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
