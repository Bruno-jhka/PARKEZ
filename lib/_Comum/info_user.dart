class InfoUser {
  String? id;
  String nome;
  String telefone;
  String cep; // Adicionado campo CEP
  String rua;
  String numCasa;
  String bairro;
  String cidade;
  String estado;
  String? notificacao;
  String? tema;
  String temInfo = 'não';

  InfoUser({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.cep,
    required this.rua,
    required this.numCasa,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  // Construtor fromMap para inicializar o objeto a partir de um Map
  InfoUser.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        nome = map['nome'],
        telefone = map['telefone'],
        cep = map['cep'],
        rua = map['rua'],
        numCasa = map['numCasa'],
        bairro = map['bairro'],
        cidade = map['cidade'],
        estado = map['estado'],
        notificacao = map['notificacao'],
        tema = map['tema'],
        temInfo = map['tem_info'];

  // Método toMap para converter o objeto em um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'cep': cep,
      'rua': rua,
      'numCasa': numCasa,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'notificacao': notificacao,
      'tema': tema,
      'tem_info': temInfo,
    };
  }

  // Método toMap para converter o objeto em um Map
  Map<String, dynamic> nomeToMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  void setTemInfo() {
    temInfo = "s";
  }
}
