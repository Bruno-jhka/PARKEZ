import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationManager {
  static Future<bool> hasActiveReservation(String uid) async {
    var now = DateTime.now();
    var firestore = FirebaseFirestore.instance;
    var userReservations = await firestore
        .collection('Usuarios')
        .doc(uid)
        .collection('vagas')
        .where('expirationTime', isGreaterThan: now.toIso8601String())
        .get();
    return userReservations.docs.isNotEmpty;
  }

  static Future<void> reserveSpot({
    required String uid,
    required String estabelecimentoId,
    required int vagasDisponiveis,
    required String preco,
    required String duration,
    required String expirationTime,
  }) async {
    double duracao = double.parse(duration);

    if (await hasActiveReservation(uid)) {
      print('Usuário já possui uma reserva ativa.');
      return;
    }

    if (vagasDisponiveis > 0) {
      var expirationTime;
      if (duracao == 5) {
        expirationTime = DateTime.now().add(Duration(seconds: 30));
      } else {
        expirationTime = DateTime.now().add(Duration(hours: duracao.toInt()));
      }
      var formattedExpirationTime =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(expirationTime);

      var firestore = FirebaseFirestore.instance;

      await firestore
          .collection('estabelecimentos')
          .doc(estabelecimentoId)
          .update({
        'vagas': vagasDisponiveis - 1,
      });

      await firestore.collection('Usuarios').doc(uid).collection('vagas').add({
        'estabelecimentoId': estabelecimentoId,
        'preco': preco,
        'expirationTime': formattedExpirationTime,
      });

      print('Reserva criada com sucesso.');
    }
  }

  static Future<void> returnSpotToEstabelecimento(
      String estabelecimentoId) async {
    var firestore = FirebaseFirestore.instance;

    var estabelecimentoRef =
        firestore.collection('estabelecimentos').doc(estabelecimentoId);
    var estabelecimentoDoc = await estabelecimentoRef.get();

    if (estabelecimentoDoc.exists) {
      var currentVagas = estabelecimentoDoc['vagas'];
      await estabelecimentoRef.update({
        'vagas': currentVagas + 1,
      });
    }
  }
}
