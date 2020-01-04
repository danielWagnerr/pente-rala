import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  static Future getEventos() {
    return http.get(
        "https://7ccaa60l36.execute-api.us-east-1.amazonaws.com/teste/eventos",
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }

  static Future getEventoEspecifico(String participanteId) {
    return http.get(
        "https://7ccaa60l36.execute-api.us-east-1.amazonaws.com/"
        "teste/eventos/participante/$participanteId",
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }

  static void registraLike(
      String participanteId, String participanteDestinadoId) {
    http.post(
        "https://ue6t8qmmsg.execute-api.us-east-1.amazonaws.com/teste/likes",
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ParticipanteId': participanteId,
          'ParticipanteDestinadoId': participanteDestinadoId,
          'DataHora': new DateTime.now().microsecondsSinceEpoch~/1000000
        }));
  }

  static Future cadastraParticipante(
      String participanteId,
      String email,
      String nome,
      int idade,
      String genero,
      String descricao,
      String base64Image,
      String deviceToken) {
    return http.post(
        "https://ge367evqcf.execute-api.us-east-1.amazonaws.com/teste",
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "ParticipanteId": participanteId,
          "Email": email,
          "Nome": nome,
          "Idade": idade,
          "Genero": genero,
          "Descricao": descricao,
          "Base64Imagem": base64Image,
          "DeviceToken": deviceToken
        }));
  }

  static Future cadastrarEvento(
      String nome,
      String organizador,
      int dataHoraInicio,
      int dataHoraFim,
      String local,
      String descricao,
      String base64Image) {
    return http.post(
        "https://7ccaa60l36.execute-api.us-east-1.amazonaws.com/teste/eventos",
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Nome": nome,
          "Organizador": organizador,
          "DataHoraInicio": dataHoraInicio,
          "DataHoraFim": dataHoraFim,
          "Local": local,
          "Descricao": descricao,
          "Base64Imagem": base64Image
        }));
  }

  static Future insereParticipanteEvento(
      String eventoId, String participanteId) {
    return http.post(
        "https://7ccaa60l36.exe"
        "cute-api.us-east-1.amazonaws.com/teste/eventos/"
        "$eventoId/participar",
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"ParticipanteId": participanteId}));
  }

  static Future enviarMensagem(String myId, String participanteDestinadoId, String mensagem1, String mensagem2) {
    return http.post(
        "https://ge367evqcf.execute-api.us-east-1.amazonaws.com/teste/mensagem",
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "ParticipanteId": myId,
          "ParticipanteDestinadoId": participanteDestinadoId,
          "mensagem1": mensagem1,
          "mensagem2": mensagem2
        })
    );
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
        dataHoraInicio = json['DataHoraIncio'],
        dataHoraFim = json['DataHoraFim'],
        local = json['Local'],
        nome = json['Nome'],
        organizador = json['Organizador'],
        urlImagem = json['LinkImagem'],
        descricao = json['Descricao'];

  Map toJson() {
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
  String email;
  String nome;
  int idade;
  String genero;
  String descricao;
  String deviceToken;
  String urlFoto;

  Participante(String participanteId, String email, String nome, int idade,
      String genero, String descricao, String deviceToken, String urlFoto) {
    this.participanteId = participanteId;
    this.email = email;
    this.nome = nome;
    this.idade = idade;
    this.genero = genero;
    this.descricao = descricao;
    this.deviceToken = deviceToken;
    this.urlFoto = urlFoto;
  }

  Participante.fromJson(Map json)
      : participanteId = json['ParticipanteId'],
        email = json['Email'],
        nome = json['Nome'],
        idade = json['Idade'],
        genero = json['Genero'],
        descricao = json['Descricao'],
        deviceToken = json['DeviceToken'],
        urlFoto = json['UrlFoto'];

  Map toJson() {
    return {
      'participanteId': participanteId,
      'email': email,
      'nome': nome,
      'idade': idade,
      'genero': genero,
      'descricao': descricao,
      'deviceToken': deviceToken,
      'urlFoto': urlFoto
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

List notifications = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/cm${random.nextInt(10)}.jpeg",
          "time": "${random.nextInt(50)} min atrás",
          "notif": notifs[random.nextInt(10)]
        });

List posts = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/cm${random.nextInt(10)}.jpeg",
          "time": "${random.nextInt(50)} min atrás",
          "img": "assets/cm${random.nextInt(10)}.jpeg"
        });

List chats = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/cm${random.nextInt(10)}.jpeg",
          "msg": messages[random.nextInt(10)],
          "counter": random.nextInt(20),
          "time": "${random.nextInt(50)} min atrás",
          "isOnline": random.nextBool(),
        });

List groups = List.generate(
    13,
    (index) => {
          "name": "Teste ${random.nextInt(20)}",
          "dp": "assets/cm${random.nextInt(10)}.jpeg",
          "msg": messages[random.nextInt(10)],
          "counter": random.nextInt(20),
          "time": "${random.nextInt(50)} min ago",
          "isOnline": random.nextBool(),
        });

List types = ["text", "image"];
List conversation = List.generate(
    10,
    (index) => {
          "username": "Teste ${random.nextInt(20)}",
          "time": "${random.nextInt(50)} min atrás",
          "type": types[random.nextInt(2)],
          "replyText": messages[random.nextInt(10)],
          "isMe": random.nextBool(),
          "isGroup": false,
          "isReply": random.nextBool(),
        });

List friends = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/cm${random.nextInt(10)}.jpeg",
          "status": "Teste",
          "isAccept": random.nextBool(),
        });
