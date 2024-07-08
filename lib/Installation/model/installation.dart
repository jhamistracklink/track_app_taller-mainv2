import 'dart:convert' show utf8;
import 'package:flutter/material.dart';

class Installation {
  final String idoperacion;
  final String lugarInstalacion;
  String numeroOrte;
  final String fecha;
  final String plan;
  final String clienteNombres;
  final String placa;
  final String chasis;
  final String tecnicoInstalador;
  final String servicio;

  late String? unitid;
  late int? idoperealizadas;
  late String? fechaInstalacion;
  late String? sistema;
  late String? deviceImei;
  late String? deviceId;
  late String? odometro;
  late String? ubicacionSistema;
  late String? serviciosAdicionales;
  late String? ubicacionBotonPanico;
  late String? medidaCombustible;
  late String? observacion;
  late String? tipoInstalacion;
  late String? testUbicacion;
  late String? testBloquearMotor;
  late String? testDesbloquearMotor;
  late String? testAbrirPestillos;
  late String? testReiniciarGps;
  late String? testBotonPanico;
  late String? testBateria;
  late String? testEncenderMotor;
  late String? testApagarMotor;
  late String? configOdometro;
  late String? habitosManejo;
  late String? estado;
  late int? creadoPor;
  late int? actualizadoPor;
  late String? fechaCreacion;
  late String? fechaActualizacion;
  
  //* New Data Client
  late String? clienteNumDoc;
  late String? clienteDocType;
  late String? clienteEmail;
  late String? clienteDireccion;
  late String? telPri;
  late String? telSec;

  /** Toyota */
  late String? company = "";
  late String cbu;
  late String? kmBorn;
  Installation({
    Key? key,
    required this.idoperacion,
    required this.lugarInstalacion,
    required this.numeroOrte,
    required this.fecha,
    required this.plan,
    required this.clienteNombres,
    required this.placa,
    required this.chasis,
    required this.tecnicoInstalador,
    required this.servicio,
    this.company = "",
    this.clienteNumDoc,
    this.clienteDocType,
    this.clienteEmail,
    this.clienteDireccion,
    this.telPri,
    this.telSec,
    this.cbu = "",
    this.unitid,
    this.idoperealizadas,
    this.fechaInstalacion,
    this.sistema,
    this.deviceImei,
    this.deviceId,
    this.odometro,
    this.ubicacionSistema,
    this.serviciosAdicionales,
    this.ubicacionBotonPanico,
    this.medidaCombustible,
    this.observacion,
    this.tipoInstalacion,
    this.testUbicacion,
    this.testBloquearMotor,
    this.testDesbloquearMotor,
    this.testAbrirPestillos,
    this.testReiniciarGps,
    this.testBotonPanico,
    this.testBateria,
    this.testEncenderMotor,
    this.testApagarMotor,
    this.configOdometro,
    this.habitosManejo,
    this.estado,
    this.creadoPor,
    this.actualizadoPor,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  Map<String, dynamic> toJson() => {
        'idoperacion': idoperacion,
        'lugarInstalacion': lugarInstalacion,
        'numeroOrte': numeroOrte,
        'fecha': fecha,
        'plan': plan,
        'clienteNombres': clienteNombres,
        'placa': placa,
        'chasis': chasis,
        'tecnicoInstalador': tecnicoInstalador,
        'servicio': servicio,
        'cuenta': company,
        'cbu': cbu,
        'clienteNumDoc': clienteNumDoc,
        'clienteDocType': clienteDocType,
        'clienteEmail': clienteEmail,
        'clienteDireccion': clienteDireccion,
        'telPri': telPri,
        'telSec': telSec,

        'unitid': unitid,
        'idoperealizadas': idoperealizadas,
        'fechaInstalacion': fechaInstalacion,
        'sistema': sistema,
        'deviceImei': deviceImei,
        'deviceId': deviceId,
        'odometro': odometro,
        'ubicacionSistema': ubicacionSistema,
        'serviciosAdicionales': serviciosAdicionales,
        'ubicacionBotonPanico': ubicacionBotonPanico,
        'medidaCombustible': medidaCombustible,
        'observacion': observacion,
        'tipoInstalacion': tipoInstalacion,
        'testUbicacion': testUbicacion,
        'testBloquearMotor': testBloquearMotor,
        'testDesbloquearMotor': testDesbloquearMotor,
        'testAbrirPestillos': testAbrirPestillos,
        'testReiniciarGps': testReiniciarGps,
        'testBotonPanico': testBotonPanico,
        'testBateria': testBateria,
        'testEncenderMotor': testEncenderMotor,
        'testApagarMotor': testApagarMotor,
        'configOdometro': configOdometro,
        'habitosManejo': habitosManejo,
        'estado': estado,
        'creadoPor': creadoPor,
        'actualizadoPor': actualizadoPor,
        'fechaCreacion': fechaCreacion,
        'fechaActualizacion': fechaActualizacion
      };

  Installation.fromMap(Map<dynamic, dynamic> map)
      : idoperacion = map['idoperacion'] ?? "",
        lugarInstalacion = map['lugarInstalacion'] ?? "",
        numeroOrte = map['numeroOrte'] ?? "",
        fecha = map['fecha'] ?? "",
        plan = map['plan'] ?? "",
        clienteNombres = map['clienteNombres'] ?? "",
        placa = map['placa'] ?? "",
        chasis = map['chasis'] ?? "",
        tecnicoInstalador = map['tecnicoInstalador'] ?? "",
        servicio = map['servicio'] ?? "",
        cbu = map['cbu'] ?? "",

        clienteNumDoc = map['clienteNumDoc'] ?? "",
        clienteDocType = map['clienteDocType'] ?? "",
        clienteEmail = map['clienteEmail'] ?? "",
        clienteDireccion = map['clienteDireccion'] ?? "",
        telPri = map['telPri'] ?? "",
        telSec = map['telSec'] ?? "",

        unitid = map['unitid'] ?? "",
        idoperealizadas = map['idoperealizadas'] ?? 0,
        fechaInstalacion = map['fechaInstalacion'] ?? "",
        sistema = map['sistema'] ?? "",
        deviceImei = map['deviceImei'] ?? "",
        deviceId = map['deviceId'] ?? "",
        odometro = map['odometro'] ?? "",
        ubicacionSistema = map['ubicacionSistema'] ?? "",
        serviciosAdicionales = map['serviciosAdicionales'] ?? "",
        ubicacionBotonPanico = map['ubicacionBotonPanico'] ?? "",
        medidaCombustible = map['medidaCombustible'] ?? "",
        observacion = map['observacion'] ?? "",
        tipoInstalacion = map['tipoInstalacion'] ?? "",
        testUbicacion = map['testUbicacion'] ?? "",
        testBloquearMotor = map['testBloquearMotor'] ?? "",
        testDesbloquearMotor = map['testDesbloquearMotor'] ?? "",
        testAbrirPestillos = map['testAbrirPestillos'] ?? "",
        testReiniciarGps = map['testReiniciarGps'] ?? "",
        testBotonPanico = map['testBotonPanico'] ?? "",
        testBateria = map['testBateria'] ?? "",
        testEncenderMotor = map['testEncenderMotor'] ?? "",
        testApagarMotor = map['testApagarMotor'] ?? "",
        configOdometro = map['configOdometro'] ?? "",
        habitosManejo = map['habitosManejo'] ?? "",
        estado = map['estado'] ?? "",
        creadoPor = map['creadoPor'] ?? 0,
        actualizadoPor = map['actualizadoPor'] != null ? int.parse(map['actualizadoPor']) : 0,
        fechaCreacion = map['fechaCreacion'] ?? "",
        fechaActualizacion = map['fechaActualizacion'] ?? "";

  String toString() => toJson().toString();
}
