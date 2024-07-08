import 'dart:convert' show utf8;
import 'package:flutter/material.dart';

class Liquidacion {
  late String? empresa;
  late String? tAnexo;
  late String? anexo;
  late String? descripcion;
  late String? apePat;
  late String? apeMat;
  late String? nombres;
  late String? direccion;//FIXME: String? descripcion;  // Modificado para permitir nulos sin `late`
  late String? ubicacion;
  late String? telFijo;
  late String? telMovilPri;
  late String? telMovilSec;
  late String? email;
  late String? tipoPersona;
  late String? tipoDocumento;
  late int? activo;
  late String? tipoDoc;
  late String? serieDoc;
  late String? numeroDoc;
  late String? periodo;
  late String? fecha;
  late String? tipoTransaccion;
  late String? transaccion;
  late String? moneda;
  late String? oc;
  late String? ocTipoDoc;
  late String? ocSerieDoc;
  late String? ocNumeroDoc;
  late String? opTipoDoc;
  late String? opSerieDoc;
  late String? opNumeroDoc;
  late String? facturacion;
  late String? localidad;
  late String? sucursal;
  late String? zona;
  late String? usuario;
  late String? fechaCreacion;
  late String? tipoInventario;
  late String? observacion;
  late String? requerimiento;
  late String? aplicarNC;
  late String? producto;
  late int? cantidad;
  late String? unidadMedida;
  late String? almacen;
  late String? destino;
  late String? usuarioModificacion;
  late String? fechaModificacion;
  late String? tipoRegistro;
  late String? productoDetalle;
  late int? saldoAlmacen;

  Liquidacion({
    Key? key,
    this.empresa,
    this.tAnexo,
    this.anexo,
    this.descripcion,
    this.apePat,
    this.apeMat,
    this.nombres,
    this.direccion,
    this.ubicacion,
    this.telFijo,
    this.telMovilPri,
    this.telMovilSec,
    this.email,
    this.tipoPersona,
    this.tipoDocumento,
    this.activo,
    this.tipoDoc,
    this.serieDoc,
    this.numeroDoc,
    this.periodo,
    this.fecha,
    this.tipoTransaccion,
    this.transaccion,
    this.moneda,
    this.oc,
    this.ocTipoDoc,
    this.ocSerieDoc,
    this.ocNumeroDoc,
    this.opTipoDoc,
    this.opSerieDoc,
    this.opNumeroDoc,
    this.facturacion,
    this.localidad,
    this.sucursal,
    this.zona,
    this.usuario,
    this.fechaCreacion,
    this.tipoInventario,
    this.observacion,
    this.requerimiento,
    this.aplicarNC,
    this.producto,
    this.cantidad,
    this.unidadMedida,
    this.almacen,
    this.destino,
    this.usuarioModificacion,
    this.fechaModificacion,
    this.tipoRegistro,
    this.productoDetalle,
    this.saldoAlmacen
  });

  Map<String, dynamic> toJson() => {
    'empresa': empresa,
    'tAnexo': tAnexo, 
    'anexo': anexo,
    'descripcion': descripcion,
    'apePat': apePat,
    'apeMat': apeMat,
    'nombres': nombres,
    'direccion': direccion,
    'ubicacion': ubicacion,
    'telFijo': telFijo,
    'telMovilPri': telMovilPri,
    'telMovilSec': telMovilSec,
    'email': email,
    'tipoPersona': tipoPersona,
    'tipoDocumento': tipoDocumento,
    'activo': activo,
    'tipoDoc': tipoDoc,
    'serieDoc': serieDoc,
    'numeroDoc': numeroDoc,
    'periodo': periodo,
    'fecha': fecha,
    'tipoTransaccion': tipoTransaccion,
    'transaccion': transaccion,
    'moneda': moneda,
    'oc': oc,
    'ocTipoDoc': ocTipoDoc,
    'ocSerieDoc': ocSerieDoc,
    'ocNumeroDoc': ocNumeroDoc,
    'opTipoDoc': opTipoDoc,
    'opSerieDoc': opSerieDoc,
    'opNumeroDoc': opNumeroDoc,
    'facturacion': facturacion,
    'localidad': localidad,
    'sucursal': sucursal,
    'zona': zona,
    'usuario': usuario,
    'fechaCreacion': fechaCreacion,
    'tipoInventario': tipoInventario,
    'observacion': observacion,
    'requerimiento': requerimiento,
    'aplicarNC': aplicarNC,
    'producto': producto,
    'cantidad': cantidad,
    'unidadMedida': unidadMedida,
    'almacen': almacen,
    'destino': destino,
    'usuarioModificacion': usuarioModificacion,
    'fechaModificacion': fechaModificacion,
    'tipoRegistro': tipoRegistro,
    'productoDetalle': productoDetalle,
    'saldoAlmacen': saldoAlmacen
  };

  Liquidacion.fromMap(Map<dynamic, dynamic> map)
      : empresa = map['empresa'] ?? "",
      tAnexo = map['tAnexo'] ?? "",
      anexo = map['anexo'] ?? "",
      descripcion = map['descripcion'] ?? "",
      apePat = map['apePat'] ?? "",
      apeMat = map['apeMat'] ?? "",
      nombres = map['nombres'] ?? "",
      direccion = map['direccion'] ?? "",
      ubicacion = map['ubicacion'] ?? "",
      telFijo = map['telFijo'] ?? "",
      telMovilPri = map['telMovilPri'] ?? "",
      telMovilSec = map['telMovilSec'] ?? "",
      email = map['email'] ?? "",
      tipoPersona = map['tipoPersona'] ?? "",
      tipoDocumento = map['tipoDocumento'] ?? "",
      activo = map['activo'] ?? 1,
      tipoDoc = map['tipoDoc'] ?? "",
      serieDoc = map['serieDoc'] ?? "",
      numeroDoc = map['numeroDoc'] ?? "",
      periodo = map['periodo'] ?? "",
      fecha = map['fecha'] ?? "",
      tipoTransaccion = map['tipoTransaccion'] ?? "",
      transaccion = map['transaccion'] ?? "",
      moneda = map['moneda'] ?? "",
      oc = map['oc'] ?? "",
      ocTipoDoc = map['ocTipoDoc'] ?? "",
      ocSerieDoc = map['ocSerieDoc'] ?? "",
      ocNumeroDoc = map['ocNumeroDoc'] ?? "",
      opTipoDoc = map['opTipoDoc'] ?? "",
      opSerieDoc = map['opSerieDoc'] ?? "",
      opNumeroDoc = map['opNumeroDoc'] ?? "",
      facturacion = map['facturacion'] ?? "",
      localidad = map['localidad'] ?? "",
      sucursal = map['sucursal'] ?? "",
      zona = map['zona'] ?? "",
      usuario = map['usuario'] ?? "",
      fechaCreacion = map['fechaCreacion'] ?? "",
      tipoInventario = map['tipoInventario'] ?? "",
      observacion = map['observacion'] ?? "",
      requerimiento = map['requerimiento'] ?? "",
      aplicarNC = map['aplicarNC'] ?? "",
      producto = map['producto'] ?? "",
      cantidad = map['cantidad'] ?? 0,
      unidadMedida = map['unidadMedida'] ?? "",
      almacen = map['almacen'] ?? "",
      destino = map['destino'] ?? "",
      usuarioModificacion = map['usuarioModificacion'] ?? "",
      fechaModificacion = map['fechaModificacion'] ?? "",
      tipoRegistro = map['tipoRegistro'] ?? "",
      productoDetalle = map['productoDetalle'] ?? "",
      saldoAlmacen = map['saldoAlmacen'] ?? 0;
        

  String toString() => toJson().toString();
}