import 'package:flutter/material.dart';

void mostrarSnackBar({
  required BuildContext context,
  required String texto,
  bool isErro = true,
}) {
  // Mostra o SnackBar
  final snackBar = SnackBar(
    content: Text(texto),
    backgroundColor: isErro ? Colors.red : Colors.green,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    duration: const Duration(seconds: 4),
    behavior: SnackBarBehavior
        .floating, // Ajuda a garantir que ele desapareça automaticamente
    action: SnackBarAction(
      label: "Ok",
      textColor: Colors.white,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  // Esconde o SnackBar automaticamente após a duração especificada
  Future.delayed(const Duration(seconds: 4), () {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  });
}
