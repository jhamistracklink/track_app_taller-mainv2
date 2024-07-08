import 'dart:async';
import 'dart:convert';

import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:sai_track/Installation/model/liquidacion.dart';
import 'package:sai_track/Installation/repository/liquidacion_repository.dart';

class LiquidacionBloc implements Bloc {
  final liquidacionRepository = LiquidacionRepository();

  Future<String> saveLiquidacion(Liquidacion payload) async {
    return liquidacionRepository.saveLiquidacion(payload);
  }

  Future<String> getGpsCodeByImei(String imei) async {
    return liquidacionRepository.getGpsCodeByImei(imei);
  }

  @override
  void dispose() {
  }
}