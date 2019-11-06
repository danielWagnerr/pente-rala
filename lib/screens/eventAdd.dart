import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pente_rala_app/util/data.dart';
import 'package:pente_rala_app/widgets/chat_item.dart';
import 'dart:async';

class EventAdd extends StatefulWidget {
  @override
  _EventAddState createState() => _EventAddState();
}

class _EventAddState extends State<EventAdd> {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Cadastro de evento';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextField(
      decoration: InputDecoration(
          border: InputBorder.none, hintText: 'Enter a search term'),
    );

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          // Label Nome
          TextFormField(
            decoration: InputDecoration(labelText: 'Nome do Evento'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Favor preencher o campo';
              }
              return null;
            },
          ),

          // Label Descricao
          TextFormField(
            decoration: InputDecoration(labelText: 'Descrição'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Favor preencher o campo';
              }
              return null;
            },
          ),

          // Label Local
          TextFormField(
            decoration: InputDecoration(labelText: 'Local'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Favor preencher o campo';
              }
              return null;
            },
          ),

          // Label Organizador
          TextFormField(
            decoration: InputDecoration(labelText: 'Organizador'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Favor preencher o campo';
              }
              return null;
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processando dados...')));
                }
              },
              child: Text('Cadastrar'),
            ),
          ),
        ],
      ),
    );
  }
}
