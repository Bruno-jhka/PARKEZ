import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkez/_Comum/info_user.dart';

class UserInformationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para adicionar ou atualizar informações do usuário na subcoleção 'infoUsers'
  Future<void> adicionarUserInfo(InfoUser infoUser) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    infoUser.setTemInfo();
    if (uid != null) {
      // Adiciona os dados do usuário na subcoleção 'infoUsers'
      await _firestore
          .collection('Usuarios')
          .doc(uid)
          .collection('infoUsers')
          .doc(
              'infoUserDoc') // Opcional: especificar um ID para o documento da subcoleção
          .set(infoUser.toMap());
    } else {
      throw Exception('Usuário não logado');
    }
  }

  // Método para conectar o stream de informações do usuário da subcoleção 'infoUsers'
  Stream<InfoUser?> conectarStreamInfoUser() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      return _firestore
          .collection('Usuarios')
          .doc(uid)
          .collection('infoUsers')
          .doc(
              'infoUserDoc') // Opcional: especificar um ID para o documento da subcoleção
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return InfoUser.fromMap(snapshot.data()!);
        } else {
          return null;
        }
      });
    } else {
      throw Exception('Usuário não logado');
    }
  }

  getUserInformation() {
    // Implementação para obter informações do usuário, se necessário
  }
}
