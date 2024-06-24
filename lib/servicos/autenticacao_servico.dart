import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkez/servicos/informacoes_user_servicos.dart';

class AutenticacaoServicos {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserInformationService _userInformationService =
      UserInformationService();

  Future<String?> cadastrarUsuario({
    required String email,
    required String senha,
    //required String nome,
  }) async {
    print(
        "--------------------------------------------------------------------");
    print("entrou cadastrar");
    print(
        "--------------------------------------------------------------------");
    if (email == '' || senha == '' /*|| nome == ''*/) {
      return "Preencha tudo!";
    }
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      //_userInformationService.atualizarNomeUser(nome);
      //await userCredential.user!.updateDisplayName(nome);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "Endereço de email em uso";
      } else if (e.message == "Password should be at least 6 characters") {
        return "Senha fraca [senha deve ter no mínimo 6 caracteres]";
      } else if (e.code == "invalid-email") {
        return "Email inválido";
      }
      return e.message;
      //return "Erro desconhecido";
    }
  }

  Future<String?> logarUsuario({
    required String email,
    required String senha,
  }) async {
    if (senha == '' && email == '') {
      return "O campo email e senha não podem ficar em branco";
    } else if (email == '') {
      return "O campo email não pode ficar em branco";
    } else if (senha == '') {
      return "O campo senha não pode ficar em branco";
    }
    print(
        "--------------------------------------------------------------------");
    print("entrou logar");
    print(email);
    print(
        "--------------------------------------------------------------------");
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          "The password is invalid or the user does not have a password.") {
        return "A senha fornecida está incorreta";
      } else if (e.message ==
          "The supplied auth credential is incorrect, malformed or has expired.") {
        return "Email ou senha estão incorretos";
      } else if (e.message == "The email address is badly formatted.") {
        return "O endereço de e-mail está mal formatado";
      } else if (e.message ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        return "Usuario não existe";
      }
      return e.message;
    }
  }

  Future<String?> redefinirSenha(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Usuário não encontrado";
      } else if (e.code == 'invalid-email') {
        return "Email inválido";
      }
      return e.message;
    }
  }

  String? getUserId() {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      return user?.uid;
    } on FirebaseAuthException catch (e) {
      print('Erro ao obter o UID: ${e.message}');
      return null;
    }
  }

  Future<void> deslogar() {
    return _firebaseAuth.signOut();
  }
}
