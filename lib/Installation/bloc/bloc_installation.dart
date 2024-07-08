import 'dart:async';

import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:sai_track/Installation/model/installation.dart';
import 'package:sai_track/Installation/repository/installation_repository.dart';

class InstallationBloc implements Bloc {
  final installationRepository = InstallationRepository();

  Future<Installation> findInstallation(String numeroOrte, int? userId) {
    return installationRepository.getInstallation(numeroOrte, userId);
  }

  Future<Installation> findInstallationByChasisTY(String chasis, int? userId){
    return installationRepository.getInstallationByChasisTY(chasis, userId);
  }

  Future<List<Installation>> listInstallation(String numeroOrte) {
    return installationRepository.listInstallation(numeroOrte);
  }

  //* List installation for Toyota
  Future<List<Installation>> listInstallationTY(String value){
    return installationRepository.listInstallationTY(value);
  }

  Future<String> getInfoIfExistsVinculacion(String chasis){
    return installationRepository.getInfoIfExistsVinculacion(chasis);
  }

  Future<Installation> saveInstallation(Installation data) {
    return installationRepository.saveInstallation(data);
  }

  Future<String> getAlert(String? unitId, String alertType) {
    return installationRepository.getGprsAlert(unitId, alertType);
  }

  Future<String> sendCommand(String? unitId, String commandType, String odometro) {
    return installationRepository.sendPollComand(unitId, commandType, odometro);
  }

  Future<String> getUnitId(String imei) {
    return installationRepository.getSim(imei);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}