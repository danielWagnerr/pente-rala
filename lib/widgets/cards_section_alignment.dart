import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pente_rala_app/util/data.dart';
import 'profile_card_alignment.dart';
import 'dart:math';

List<Alignment> cardsAlign = [
  new Alignment(0.0, 1.0),
  new Alignment(0.0, 0.8),
  new Alignment(0.0, 0.0)
];
List<Size> cardsSize = new List(3);

class CardsSectionAlignment extends StatefulWidget {
  CardsSectionAlignment(BuildContext context) {
    cardsSize[0] = new Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.6);
    cardsSize[1] = new Size(MediaQuery.of(context).size.width * 0.85,
        MediaQuery.of(context).size.height * 0.55);
    cardsSize[2] = new Size(MediaQuery.of(context).size.width * 0.8,
        MediaQuery.of(context).size.height * 0.5);
  }

  @override
  _CardsSectionState createState() => new _CardsSectionState();
}

class _CardsSectionState extends State<CardsSectionAlignment>
    with SingleTickerProviderStateMixin {
  int cardsCounter = 0;

  List<ProfileCardAlignment> cards = new List();
  AnimationController _controller;

  final Alignment defaultFrontCardAlign = new Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  Future _getEvento() async {
    var resposta = await API.getEventoEspecifico("234");

    var respostaJson = jsonDecode(resposta.body);

    var evento = respostaJson;

    Iterable list = evento['Participantes'];
    var participantes =
        list.map((model) => Participante.fromJson(model)).toList();

    participantes.forEach((participante) {
      cards.add(new ProfileCardAlignment(cardsCounter, participante.urlFoto,
          "ESSE É O CARTAO " + participante.nome));
    });
    cards.add(new ProfileCardAlignment(
        cardsCounter,
        "https://fotos-eventos-app.s3.amazonaws.com/58debcbe-81c5-47cc-9f0b-1f3852e35348.jpg?AWSAccessKeyId=ASIA3JA65PGXIFTSBPJD&Signature=abCG%2FcsdTKZEkKPV55647AbrFsg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEPr%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQCrcQ59JO1CWyiu7yRgUOIbm05zgjwb1GXR%2BMFy0QS%2FeAIhAOpCHHJZMlszUZz%2BZzIdZD8KXAylRVn%2BtTwJawa7NZtJKtgBCCIQABoMNzc1MzA2NDQzMTgyIgxk9nKP5zrSoStAy0kqtQGZhtaNXQwrhXtW6Cs1ect7HfeSK5W2wUE1Bs%2B49nzb5nANAGQbt8oDySaiWmq%2FNHqXOWPQzVYzSc6Y7hAv0qeckxjuPj%2F2dPHu0YF2CIZM4WV1bIJ0A34rFDfrY5Mhbpd318p0mMz17ZLCXkYsD5ggQS2uckWf7jG70BbZPHdAR8%2Bjq1XD1fOq3x3%2FNBOv5zAWdaEmKxmYQrZU5n8zOX1AwPoBK4lmXtehu8w388EIn2yc8BCIMLuwre4FOt8BFPer%2BxtJnQ57HSOOx%2FTZCKQj5NaY8o26w5sgivbihsy46fRsBR3ESXCkXgeg1s5Q%2BwsUDMSPdR4whWQNYGFNBiwZ8vCYRYEX3zB5foThpWrPe7sz9TW%2FB9KouUB3Tp84UswKAk0CYv775wXMmllll2juCsGwZ1KnSVhF0BfW9pxINTe4w4USMS1qaAAuIhnulFRR%2FFnWC6Zzj021cl9hQPdm29OBPWpWzJkdXUR804zMT%2F9aSZGHxSKwCqdTydJAzgSBMdjXBfyYxIN4Rg6rVOkZToJA0UyYnNSRr60irg%3D%3D&Expires=1573612934",
        "ESSE É O CARTAO terceiro"));

    return participantes;
  }

  Future _participantes;

  @override
  void initState() {
    super.initState();

    _participantes = _getEvento();

    frontCardAlign = cardsAlign[2];

    // Init the animation controller
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: FutureBuilder(
      future: _participantes,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return cartoes();
          case ConnectionState.waiting:
            return new Text('Carregando...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return new Text('Result: ${snapshot.data}');
        }
      },
    ));
  }

  Widget cartoes() {
    return new Expanded(
        child: Stack(
      children: <Widget>[
        backCard(),
        middleCard(),
        frontCard(),
        // Prevent swiping if the cards are animating
        _controller.status != AnimationStatus.forward
            ? new SizedBox.expand(
                child: new GestureDetector(
                // While dragging the first card
                onPanUpdate: (DragUpdateDetails details) {
                  // Add what the user swiped in the last frame to the alignment of the card
                  setState(() {
                    // 20 is the "speed" at which moves the card
                    frontCardAlign = new Alignment(
                        frontCardAlign.x +
                            20 *
                                details.delta.dx /
                                MediaQuery.of(context).size.width,
                        frontCardAlign.y +
                            40 *
                                details.delta.dy /
                                MediaQuery.of(context).size.height);

                    frontCardRot = frontCardAlign.x; // * rotation speed;
                  });
                },
                // When releasing the first card
                onPanEnd: (_) {
                  if (frontCardAlign.x > 3.0) {
                    //API.registraLike("PEGA O ID DO PARTICIPANTE LOGADO",
                    //    "PEGA O ID DO CARTAO, QUE NO CASO É O PARTICIPANTE DESEJADO ex: cards[0].participanteId");

                    print("DIREITA");
                  }
                  if (frontCardAlign.x < -3.0) {
                    print("ESQUERDA");
                  }

                  // If the front card was swiped far enough to count as swiped
                  if (frontCardAlign.x > 3.0 || frontCardAlign.x < -3.0) {
                    animateCards();
                  } else {
                    // Return to the initial rotation and alignment
                    setState(() {
                      frontCardAlign = defaultFrontCardAlign;
                      frontCardRot = 0.0;
                    });
                  }
                },
              ))
            : new Container(),
      ],
    ));
  }

  Widget backCard() {
    return new Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: new SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: cards[2]),
    );
  }

  Widget middleCard() {
    return new Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: new SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: cards[1]),
    );
  }

  Widget frontCard() {
    return new Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: new Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: new SizedBox.fromSize(size: cardsSize[0], child: cards[0]),
        ));
  }

  void changeCardsOrder() {
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a new bottom card)
      var temp;
      int ultimo = cards.length - 1;

      for (int i = 0; i < cards.length; i++) {
        if (i == 0) {
          temp = cards[i];
        } else {
          cards[i - 1] = cards[i];

          if (i == ultimo) {
            cards[ultimo] = temp;
          }
        }
      }

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return new AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return new SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return new AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return new SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return new AlignmentTween(
            begin: beginAlign,
            end: new Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
