import 'package:flutter/material.dart';

class ProfileCardAlignment extends StatelessWidget
{
  final int cardNum;
  final String imagem;
  final String nome;
  final String descricao;
  final String participanteId;
  ProfileCardAlignment(this.cardNum, this.participanteId, this.nome, this.descricao, this.imagem);

  @override
  Widget build(BuildContext context)
  {
    return new Card
    (
      child: new Stack
      (
        children: <Widget>
        [
          new SizedBox.expand
          (
            child: new Material
            (
              borderRadius: new BorderRadius.circular(12.0),
              child: new Image.network(this.imagem, fit: BoxFit.cover),
            ),
          ),
          new SizedBox.expand
          (
            child: new Container
            (
              decoration: new BoxDecoration
              (
                gradient: new LinearGradient
                (
                  colors: [ Colors.transparent, Colors.black54 ],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter
                )
              ),
            ),
          ),
          new Align
          (
            alignment: Alignment.bottomLeft,
            child: new Container
            (
              padding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: new Column
              (
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                [
                  new Text(nome, style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w700)),
                  new Padding(padding: new EdgeInsets.only(bottom: 8.0)),
                  new Text(descricao, textAlign: TextAlign.start, style: new TextStyle(color: Colors.white)),
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}