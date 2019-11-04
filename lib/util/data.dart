import 'dart:math';
import 'package:http/http.dart' as http;

class API {
  static Future getEventos() {
    return http.get(
        "https://7ccaa60l36.execute-api.us-east-1.amazonaws.com/teste/eventos",
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }
  
  static Future getEventoEspecifico(String participanteId){
    return http.get("https://7ccaa60l36.execute-api.us-east-1.amazonaws.com/"
        "teste/eventos/participante/${participanteId}",
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }
  
}

class Evento {
  String eventoId;
  String nome;
  String local;
  String organizador;
  String urlImagem;
  String descricao;
  int dataHoraInicio;
  int dataHoraFim;

  Evento(String eventoId, int dataHoraInicio, int dataHoraFim, String local,
      String nome, String organizador, String urlImagem, String descricao) {
    this.eventoId = eventoId;
    this.dataHoraInicio = dataHoraInicio;
    this.dataHoraFim = dataHoraFim;
    this.local = local;
    this.nome = nome;
    this.organizador = organizador;
    this.urlImagem = urlImagem;
    this.descricao = descricao;
  }

  Evento.fromJson(Map json)
      : eventoId = json['EventoId'],
        dataHoraInicio =  json['DataHoraIncio'],
        dataHoraFim = json['DataHoraFim'],
        local = json['Local'],
        nome = json['Nome'],
        organizador = json['Organizador'],
        urlImagem = json['LinkImagem'],
        descricao = json['Descricao'];

  Map toJson(){
    return {
      'eventoId': eventoId,
      'dataHoraInicio': dataHoraInicio.toString(),
      'dataHoraFim': dataHoraFim.toString(),
      'local': local,
      'nome': nome,
      'organizador': organizador,
      'urlImagem': urlImagem,
      'descricao': descricao
    };
  }
}


class Participante {

  String participanteId;
  String nome;
  String urlFoto;
  String numero;
  int idade;

  Participante(String participanteId, String nome, String urlFoto,
      String numero, int idade){
    this.participanteId = participanteId;
    this.nome = nome;
    this.urlFoto = urlFoto;
    this.numero = numero;
    this.idade = idade;
  }

  Participante.fromJson(Map json)
      : participanteId = json['ParticipanteId'],
        nome = json['Nome'],
        urlFoto = json['UrlFoto'],
        numero = json['Numero'],
        idade = json['Idade'];


  Map toJson(){
    return {
      'participanteId': participanteId,
      'nome': nome,
      'urlFoto': urlFoto,
      'numero': numero,
      'idade': idade
    };
  }


}




Random random = Random();
List names = [
  "Teste Teste",
  "Teste Teste",
  "Teste Teste",
  "Teste Teste",
  "Teste Teste",
  "Teste Teste",
  "Teste Teste",
  "Teste Teste",
  "Teste Teste",
  "Teste Teste",
  "Teste Teste",
];

List messages = [
  "Testando isso",
  "Testando isso",
  "Testando isso",
  "Testando isso",
  "Testando isso",
  "Testando isso",
  "Testando isso",
  "Testando isso",
  "Testando isso",
  "Testando isso",
  "Testando isso",
];

List notifs = [
  "${names[random.nextInt(10)]} está testando",
  "${names[random.nextInt(10)]} está testando",
  "${names[random.nextInt(10)]} está testando",
  "${names[random.nextInt(10)]} está testando",
  "${names[random.nextInt(10)]} está testando",
  "${names[random.nextInt(10)]} está testando",
  "${names[random.nextInt(10)]} está testando",
  "${names[random.nextInt(10)]} está testando",
  "está testando",
  "${names[random.nextInt(10)]} está testando",
  "${names[random.nextInt(10)]} está testando"
];

List notifications = List.generate(13, (index)=>{
  "name": names[random.nextInt(10)],
  "dp": "assets/cm${random.nextInt(10)}.jpeg",
  "time": "${random.nextInt(50)} min atrás",
  "notif": notifs[random.nextInt(10)]
});

List posts = List.generate(13, (index)=>{
    "name": names[random.nextInt(10)],
    "dp": "assets/cm${random.nextInt(10)}.jpeg",
    "time": "${random.nextInt(50)} min atrás",
    "img": "assets/cm${random.nextInt(10)}.jpeg"
});

List chats = List.generate(13, (index)=>{
  "name": names[random.nextInt(10)],
  "dp": "assets/cm${random.nextInt(10)}.jpeg",
  "msg": messages[random.nextInt(10)],
  "counter": random.nextInt(20),
  "time": "${random.nextInt(50)} min atrás",
  "isOnline": random.nextBool(),
});

List groups = List.generate(13, (index)=>{
  "name": "Teste ${random.nextInt(20)}",
  "dp": "assets/cm${random.nextInt(10)}.jpeg",
  "msg": messages[random.nextInt(10)],
  "counter": random.nextInt(20),
  "time": "${random.nextInt(50)} min ago",
  "isOnline": random.nextBool(),
});

List types = ["text", "image"];
List conversation = List.generate(10, (index)=>{
  "username": "Teste ${random.nextInt(20)}",
  "time": "${random.nextInt(50)} min atrás",
  "type": types[random.nextInt(2)],
  "replyText": messages[random.nextInt(10)],
  "isMe": random.nextBool(),
  "isGroup": false,
  "isReply": random.nextBool(),
});

List friends = List.generate(13, (index)=>{
  "name": names[random.nextInt(10)],
  "dp": "assets/cm${random.nextInt(10)}.jpeg",
  "status": "Teste",
  "isAccept": random.nextBool(),
});