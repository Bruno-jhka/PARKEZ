import 'package:parkez/servicos/informacoes_user_servicos.dart';

class CompletarContaController {
  final UserInformationService _userInformationService;

  CompletarContaController(this._userInformationService);

  Future<bool> isUserInformationComplete() async {
    try {
      final userInfo = await _userInformationService.getUserInformation();
      return userInfo != null &&
          userInfo
              .isComplete(); // Supondo que existe um método isComplete() no modelo de informações do usuário
    } catch (e) {
      return false;
    }
  }
}
