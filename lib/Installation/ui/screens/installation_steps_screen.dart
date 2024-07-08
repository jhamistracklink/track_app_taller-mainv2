import 'dart:convert' as convert;
// import 'dart:html';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sai_track/Installation/bloc/bloc_liquidacion.dart';
import 'package:sai_track/Installation/model/liquidacion.dart';
import 'package:sai_track/User/model/user.dart';
import 'package:sai_track/User/ui/screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sai_track/Installation/bloc/bloc_installation.dart';
import 'package:sai_track/Installation/model/installation.dart';
import 'package:sai_track/User/bloc/bloc_user.dart';
import 'package:sai_track/widgets/button_blue.dart';
import 'package:sai_track/widgets/custom_alert_dialog.dart';
import 'package:sai_track/widgets/custom_loader.dart';
class InstallationScreen extends StatefulWidget {
  @override
  _InstallationScreen createState() => new _InstallationScreen();
}

class _InstallationScreen extends State<InstallationScreen> {

  bool isLoading = false;
  UserBloc userBloc = UserBloc();
  InstallationBloc installationBloc = InstallationBloc();
  LiquidacionBloc liquidacionBloc = LiquidacionBloc();
  // String validateIfExistsChasis = "";

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  final _formKeyStep4 = GlobalKey<FormState>();
  final _formKeyStep5 = GlobalKey<FormState>();

  int currentStep = 0;
  bool complete = false;
  StepperType stepperType = StepperType.vertical;

  Installation currInstallation = new Installation(idoperacion: "", lugarInstalacion: "", numeroOrte: "", fecha: "", plan: "", clienteNombres: "", placa: "", chasis: "", tecnicoInstalador: "", servicio: "", company: "TRACKLINK");
  TextEditingController orteController = new TextEditingController();
  TextEditingController clienteController = new TextEditingController();
  TextEditingController servicioController = new TextEditingController();
  TextEditingController fechaController = new TextEditingController();
  TextEditingController placaController = new TextEditingController();
  TextEditingController chasisController = new TextEditingController();
  TextEditingController planController = new TextEditingController();
  TextEditingController tecnicoController = new TextEditingController();

  TextEditingController imeiControoler = new TextEditingController();
  TextEditingController idControoler = new TextEditingController();
  TextEditingController unitIdControoler = new TextEditingController();
  TextEditingController odometroControoler = new TextEditingController();
  TextEditingController ubicacionSistemaControoler = new TextEditingController();

  TextEditingController ubicacionBotonController = new TextEditingController();
  TextEditingController medidaCombustibleController = new TextEditingController();
  TextEditingController observacionController = new TextEditingController();

  bool cambioGps = false;
  bool bloqueoMotor = false;
  bool aperturaPestillos = false;
  bool botonPanico = false;
  bool sensorCombustible = false;

  String sistema = "OCTO";
  String lugarInstalacion = "DOMICILIO CLIENTE";
  String modoInstalacion = "MODO 1";


  String gpsCode = "";
  String servicio = "";
  String testUbicacion = "";
  String testUbicacionLnLt = "";
  String testBloquearMotor = "";
  String testDesbloquearMotor = "";
  String testAbrirPestillos = "";
  String testReiniciarGps = "";
  String testBotonPanico = "";
  String testBateria = "";
  String testEncenderMotor = "";
  String testApagarMotor = "";
  String configOdometro = "";
  String habitosManejo = "";
  String idoperealizadas = "";

  dynamic base64Images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//  void _getInfoIfExistsVinculacion(String? chasis){
//     if(chasis != null){
//       setState(() {
//         validateIfExistsChasis = installationBloc.getInfoIfExistsVinculacion(chasis).toString();
//       });
//     }
//  }

  Future<void> _takePicture(String typePhoto, String typeState) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Convertir la imagen en base64
      List<int> imageBytes = await pickedFile.readAsBytes();
      String base64Image = convert.base64Encode(Uint8List.fromList(imageBytes));
      bool validateIfExists = false;

      base64Images.forEach((element) => {
        if(convert.json.decode(element)['type'] == typePhoto){
          validateIfExists = true
        }
      });
      
      if(!validateIfExists){
        print("No existe inserta");
        setState(() {
          base64Images?.add(convert.json.encode({
            "typeState": typeState,
            "type": typePhoto,
            "data": base64Image
          }));
        });
      }else{
        print("Ya existe");
      }
    }
  }

  Future<http.Response> createAlbum(element, String nOrte, String idope){
    final arr = convert.json.decode(element);
    return http.post(
      Uri.parse('http://inspeccion-taller.tracklink.pe:8080/process'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode(<String,String>{
        'idoperacion': idope,
        'nOrte': nOrte,
        'type': arr['typeState'],
        'typePhoto': arr['type'],
        'data': arr['data'],
      }),
    );
  }


  next() {
    if (currentStep == 0 && !_formKeyStep1.currentState!.validate()) {
      return;
    }

    if (currentStep == 1 && !_formKeyStep2.currentState!.validate()) {
      return;
    }

    if (currentStep == 2 && !_formKeyStep3.currentState!.validate()) {
      return;
    }

    if (currentStep == 3 && !_formKeyStep4.currentState!.validate()) {
      return;
    }

    if (currentStep == 4 && !_formKeyStep5.currentState!.validate()) {
      return;
    }

    currentStep + 1 != 5
        ? goTo(currentStep + 1)
        : installationCompleted();
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  switchStepType() {
    setState(() => stepperType == StepperType.horizontal
        ? stepperType = StepperType.vertical
        : stepperType = StepperType.horizontal);
  }

  installationCompleted() {
    setState(() => isLoading = true);
    currInstallation.sistema = sistema;
    currInstallation.deviceImei = imeiControoler.text;
    currInstallation.deviceId = idControoler.text;
    currInstallation.odometro = odometroControoler.text == '' ? '0' : odometroControoler.text;
    currInstallation.ubicacionSistema = ubicacionSistemaControoler.text;

    var srvadd = '';
    if (bloqueoMotor) {
      srvadd = srvadd + '|Bloqueo Motor';
    }

    if (aperturaPestillos) {
      srvadd = srvadd + '|Apertura Pestillos';
    }

    if (botonPanico) {
      srvadd = srvadd + '|Boton Panico';
    }

    if (sensorCombustible) {
      srvadd = srvadd + '|Sensor Combustible';
    }
    currInstallation.serviciosAdicionales = srvadd;
    currInstallation.ubicacionBotonPanico = ubicacionBotonController.text;
    currInstallation.medidaCombustible = medidaCombustibleController.text;
    currInstallation.observacion = observacionController.text;
    currInstallation.tipoInstalacion = modoInstalacion;

    currInstallation.testUbicacion = testUbicacionLnLt;
    currInstallation.testBloquearMotor = testBloquearMotor;
    currInstallation.testDesbloquearMotor = testDesbloquearMotor;
    currInstallation.testAbrirPestillos = testAbrirPestillos;
    currInstallation.testReiniciarGps = testReiniciarGps;
    currInstallation.testBotonPanico = testBotonPanico;
    currInstallation.testBateria = testBateria;
    currInstallation.testEncenderMotor = testEncenderMotor;
    currInstallation.testApagarMotor = testApagarMotor;
    currInstallation.configOdometro = configOdometro;
    currInstallation.habitosManejo = habitosManejo;
    currInstallation.company = "TRACKLINK";

    installationBloc.saveInstallation(currInstallation).then((installationSaved) {
      setState(() {
        complete = true;
        isLoading = false;
      });
      sendImages(installationSaved.idoperealizadas!.toInt().toString());
      resetFormInstallation();
      orteController.text = '';
    }, onError: (e) {
      setState(() => isLoading = false);
      var errMessage = e.toString().replaceAll('Exception: ', '');
      CustomAlertDialog.showAlertDialog(context, 'Instalacion', errMessage);
    });
    
    liquidacionBloc.getGpsCodeByImei(imeiControoler.text).then((response) => {
      setState(() {
        gpsCode = response ?? "";
      })
    });


    DateTime now = DateTime.now();
    print(now);
    String onlyDate = DateTime(now.year, now.month, now.day).toString();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');//yyyy-MM-dd HH:mm:ss.SSS
    final String formatted = formatter.format(now);
    print(formatted);
    var splittedEmail = currInstallation.clienteEmail?.split(',');
    var cliente = currInstallation.clienteNombres?.split(' ');
    if (cliente != null && cliente.length == 3) {
      cliente.insert(3, '');
    }
    if(currInstallation.clienteDocType=='RUC'){
      cliente?[0] = currInstallation.clienteNombres;
      cliente?[1] = '';
      cliente?[2] = '';
      cliente?[3] = '';
    }
    print('---------------------------------');
    print(cliente?[0]);
    print(cliente);
     print(currInstallation.clienteDocType);
    print('---------------------------------');
    Liquidacion curLiq = new Liquidacion(
      empresa: "20525107915", 
      tAnexo: "10",//NOTE: string o number??
      anexo: currInstallation.clienteNumDoc,
      descripcion: currInstallation.clienteNombres,
      apePat: "${cliente?[0] ?? ''}",//FIXME: CORREGIR apellido
      apeMat: "${cliente?[1] ?? ''}",//FIXME: CORREGIR apellido
      nombres:"${cliente?[2] ?? ''} ${cliente?[3] ?? ''}",//FIXME: CORREGIR NOMBRE
      direccion: currInstallation.clienteDireccion, //FIXME: DIRECCION
      ubicacion: null,//"Ubicacion",
      telFijo: currInstallation.telPri,//"",//FIXME: VERIFICAR
      telMovilPri: currInstallation.telPri,//FIXME: VERIFICAR
      telMovilSec: currInstallation.telSec,//FIXME: VERIFICAR
      email: splittedEmail?[0] ?? "",
      tipoPersona: (currInstallation.clienteDocType == "RUC") ? "02" : "01",//FIXME: VALIDAR
      tipoDocumento: currInstallation.clienteDocType,//FIXME: VALIDAR
      activo: 1,
      tipoDoc: "201",
      serieDoc: "001",
      numeroDoc: "", //FIXME: tabla de donde se validara// actual se suma en el servicio
      periodo: "202405",
      fecha: formatted,
      tipoTransaccion: "2",
      transaccion: "01",
      moneda: "01",
      oc: null,
      ocTipoDoc: null,
      ocSerieDoc: "ORTE",
      ocNumeroDoc: currInstallation.numeroOrte,//FIXME: Debe ir nro orte   ✓
      opTipoDoc: "401",//NOTE: STRING O NUMBER
      opSerieDoc: null,
      opNumeroDoc: currInstallation.deviceImei, //FIXME: Debe ir IMEI   ✓
      facturacion: "0",
      localidad: "01",
      sucursal: null,
      zona: null,
      usuario: "LLAZARO",
      //NOTE: AGREGAR CAMPO `AREA`??????
      fechaCreacion: onlyDate,
      tipoInventario: "2", //NOTE: STRING O NUMBER
      observacion: "Liquidacion Automatica",
      requerimiento: "",
      aplicarNC: "",
      producto: gpsCode,//FIXME: Debe ir el código dependiendo del GPS
      cantidad: 1,
      unidadMedida: "07",
      almacen: "001",
      destino: null,
      usuarioModificacion: null,
      fechaModificacion: null,
      tipoRegistro: "M",
      productoDetalle: currInstallation.deviceImei, //FIXME: Debe ir IMEI
      saldoAlmacen: 0
    );
    
    liquidacionBloc.saveLiquidacion(curLiq).then((liquidacionSaved) => {
      print(liquidacionSaved)
    });

  }

  Future<void> sendImages(String idop) async{
    await base64Images.forEach((element) {
      createAlbum(element, orteController.text, idop);
    });

    base64Images = [];
  }

  showErrorTestDialog(title, e) {
    setState(() => isLoading = false);
    var errMessage = e.toString().replaceAll('Exception: ', '');
    CustomAlertDialog.showAlertDialog(context, title, errMessage);
  }

  getTestAlert(String alertType) {
    switch (alertType) {
      case 'ALERT_PA': {
        setState(() => isLoading = true);
        installationBloc.getAlert(currInstallation.unitid, alertType).then((value) {
          setState(() {
            testBotonPanico = value;
            isLoading = false;
          });
        }, onError: (e) => showErrorTestDialog('Prueba Alerta de Panico', e));
      } break;
      case 'DESC_BT': {
        setState(() => isLoading = true);
        installationBloc.getAlert(currInstallation.unitid, alertType).then((value) {
          setState(() {
            testBateria = value;
            isLoading = false;
          });
        }, onError: (e) => showErrorTestDialog('Prueba Desconexion de Bateria', e));
      } break;
      case 'ING_OFF': {
        setState(() => isLoading = true);
        installationBloc.getAlert(currInstallation.unitid, alertType).then((value) {
          setState(() {
            testApagarMotor = value;
            isLoading = false;
          });
        }, onError: (e) => showErrorTestDialog('Prueba Apagar Motor', e));
      } break;
      case 'IGN_ON': {
        setState(() => isLoading = true);
        installationBloc.getAlert(currInstallation.unitid, alertType).then((value) {
          setState(() {
            testEncenderMotor = value;
            isLoading = false;
          });
        }, onError: (e) => showErrorTestDialog('Prueba Encender Motor', e));
      } break;
      case 'DISP_LOC': {
        setState(() => isLoading = true);

        installationBloc.getAlert(currInstallation.unitid, alertType).then((value) {
          var split = value.split(",");
          setState(() {
            testUbicacion = value == "SIN DATA" ? value : split[2];
            testUbicacionLnLt = value;
            isLoading = false;
          });

          if (value != "SIN DATA") {
            _launchMapsUrl(split[0] + ',' + split[1]);
          }
        }, onError: (e) => showErrorTestDialog('Prueba Ubicacion', e));
      } break;
    }
  }

  sendTestCommand(String commandType, String odometer) {
    switch(commandType) {
      case 'IGN_BLOQ': {
        setState(() => isLoading = true);
        installationBloc.sendCommand(currInstallation.unitid, commandType, odometer).then((value) {
          setState(() {
            testBloquearMotor = value;
            isLoading = false;
          });
        }, onError: (e) => showErrorTestDialog('Prueba Bloquear Motor', e));
      } break;
      case 'IGN_DBLOQ': {
        setState(() => isLoading = true);
        installationBloc.sendCommand(currInstallation.unitid, commandType, odometer).then((value) {
          setState(() {
            testDesbloquearMotor = value;
            isLoading = false;
          });
        }, onError: (e) => showErrorTestDialog('Prueba Desbloquear Motor', e));
      } break;
      case 'OPEN_PEST': {
        setState(() => isLoading = true);
        installationBloc.sendCommand(currInstallation.unitid, commandType, odometer).then((value) {
          setState(() {
            testAbrirPestillos = value;
            isLoading = false;
          });
        }, onError: (e) => showErrorTestDialog('Prueba Abrir Pestillos', e));
      } break;
      case 'RESET_GPS': {
        setState(() => isLoading = true);
        installationBloc.sendCommand(currInstallation.unitid, commandType, odometer).then((value) {
          setState(() {
            testReiniciarGps = value;
            isLoading = false;
          });
        }, onError: (e) => showErrorTestDialog('Prueba Resetear Dispositivo GPS', e));
      } break;
      case 'SETT_ODO': {
        setState(() => isLoading = true);
        installationBloc.sendCommand(currInstallation.unitid, commandType, odometer).then((value) {
          setState(() {
            configOdometro = value;
            isLoading = false;
          });
        }, onError: (e) => showErrorTestDialog('Prueba Configurar Odomometro', e));
      } break;
    }
  }

  void _launchMapsUrl(String latLon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latLon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  resetFormInstallation() {
    _formKeyStep1.currentState?.reset();
    _formKeyStep2.currentState?.reset();
    _formKeyStep3.currentState?.reset();
    _formKeyStep4.currentState?.reset();
    _formKeyStep5.currentState?.reset();

    bloqueoMotor = false;
    aperturaPestillos = false;
    botonPanico = false;
    sensorCombustible = false;

    sistema = "OCTO";
    lugarInstalacion = "DOMICILIO CLIENTE";
    modoInstalacion = "MODO 1";

    clienteController.text = "";
    servicioController.text = "";
    fechaController.text = "";
    placaController.text = "";
    chasisController.text = "";
    planController.text = "";
    tecnicoController.text = "";
    imeiControoler.text = "";
    idControoler.text = "";
    odometroControoler.text = "";
    ubicacionSistemaControoler.text = "";
    ubicacionBotonController.text = "";
    medidaCombustibleController.text = "";
    observacionController.text = "";
    currInstallation.numeroOrte = "";

    testUbicacion = "";
    testBloquearMotor = "";
    testDesbloquearMotor = "";
    testAbrirPestillos = "";
    testReiniciarGps = "";
    testBotonPanico = "";
    testBateria = "";
    testEncenderMotor = "";
    testApagarMotor = "";
    configOdometro = "";
    habitosManejo = "";
  }

  emptyValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }

  Widget showTestResult(String testField) {
    if (testField == '') {
      return Row();
    } else {
      return RichText(
        text: TextSpan(
          text: '',
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(text: 'Resultado: '),
            TextSpan(text: testField, style: TextStyle(color: testField != 'SIN DATA' ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
  }

  Future _getImeiBarcodeScanner() async {
    imeiControoler.text = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancelar", true, ScanMode.BARCODE);
    getSimImei(imeiControoler.text);
  }

  Future _getDeviceIdBarcodeScanner() async {
    idControoler.text = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancelar", true, ScanMode.BARCODE);
  }

  getSimImei(String imei) {
    setState(() => isLoading = true);
    if(sistema == "TRACK"){
      installationBloc.getUnitId(imei).then((String unitId) {
      currInstallation.unitid = unitId;
        setState((){
          isLoading = false;
          idControoler.text = unitId;
        });
      }, onError: (e) {
        setState(() => isLoading = false);
        var errMessage = e.toString().replaceAll('Exception: ', '');
        // CustomAlertDialog.showAlertDialog(context, 'Consulta IMEI', errMessage);
        CustomAlertDialog.showAlertDialog(context, 'Consulta IMEI', imeiControoler.text);
      });
    }

    if(sistema == "OCTO"){
      var params = imei.split(" ");
      imeiControoler.text = params[0];
      idControoler.text = params[1];
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);

    return new Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: <Widget>[
              complete
                  ? Expanded(
                child: Center(
                  child: AlertDialog(
                    // title: new Text("Instalacion Finalizada"),
                    title: Row(children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      Text('  Instalacion Finalizada')
                    ]),
                    content: new Text(
                      "- Registro realizado \n- Pruebas realizadas con exito",
                    ),
                    actions: <Widget>[
                      new TextButton(
                        child: new Text("Aceptar"),
                        onPressed: () {
                          setState(() {
                            complete = false;
                            currentStep = 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )
                  : Expanded(
                child: Stepper(
                  type: stepperType,
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepTapped: (step) => goTo(step),
                  onStepCancel: cancel,
                  controlsBuilder: (BuildContext context, ControlsDetails details){
                    return Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: <Widget>[
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.blue),
                                padding: MaterialStateProperty.all<
                                    EdgeInsets>(
                                    EdgeInsets.symmetric(horizontal: 15.0)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0),
                                    ))),
                            onPressed: details.onStepContinue,
                            child: const Text('CONTINUAR',
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsets>(
                                    EdgeInsets.symmetric(horizontal: 20.0))),
                            onPressed: details.onStepCancel,
                            child: const Text('CANCELAR',
                                style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      )
                    );
                  },
                  steps: [
                    Step(
                      title: const Text('Datos Operacion'),
                      isActive: currentStep >= 0,
                      state: currentStep >= 0
                          ? (currentStep == 0
                          ? StepState.indexed
                          : StepState.complete)
                          : StepState.disabled,
                      content: Form(
                        key: _formKeyStep1,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(child: TextFormField(
                                  controller: orteController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Campo requerido';
                                    }

                                    if (currInstallation.numeroOrte.isEmpty || currInstallation.numeroOrte == '') {
                                      CustomAlertDialog.showAlertDialog(context, 'Instalacion', 'Número de orte no existe o no está habilitado para su usuario.');
                                      return 'Número de orte inválido';
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(labelText: 'Nº Orte'),
                                )),
                                ButtonBlue(height: 30.0, width: 70.0, text: 'Buscar', onPressed: () async {
                                  print("Installation find start: ");
                                  setState(() => isLoading = true);
                                  final prefs = await SharedPreferences.getInstance();
                                  final user = convert.json.decode(prefs.getString('currUser').toString());
                                  final currUser = User.fromMap(user);

                                  installationBloc.findInstallation(orteController.text, currUser.userId).then((Installation installation) {
                                    print("Installation: ");
                                    setState(() {
                                      isLoading = false;
                                      currInstallation = installation;
                                      clienteController.text = installation.clienteNombres;
                                      servicioController.text = installation.servicio;
                                      fechaController.text = installation.fecha;
                                      placaController.text = installation.placa;
                                      chasisController.text = installation.chasis;
                                      planController.text = installation.plan;
                                      tecnicoController.text = installation.tecnicoInstalador;

                                      if (installation.servicio.contains("DESINSTALACION")) {
                                        servicio = "DESINSTALACION";
                                      } else if (installation.servicio.contains("REINSTALACION")) {
                                        servicio = "REINSTALACION";
                                      } else if (installation.servicio.contains("INSTALACION")) {
                                        servicio = "INSTALACION";
                                      } else if (installation.servicio.contains("CHEQUEO")) {
                                        servicio = "CHEQUEO";
                                        cambioGps = true;
                                      } else {
                                        servicio = installation.servicio;
                                      }

                                    });
                                    // _getInfoIfExistsVinculacion(chasisController.text);
                                    print(installation);
                                  }, onError: (e) {
                                    setState(() => isLoading = false);
                                    var errMessage = e.toString().replaceAll('Exception: ', '');
                                    CustomAlertDialog.showAlertDialog(context, 'Instalacion', "Numero de Orte no encontrada, ¡Por favor contactarse con el área encargada!");
                                    resetFormInstallation();
                                  });
                                })
                              ],
                            ),
                            TextFormField(
                              controller: clienteController,
                              enabled: false,
                              maxLines: null,
                              enableInteractiveSelection: false,
                              decoration: InputDecoration(labelText: 'Cliente'),
                            ),
                            TextFormField(
                              controller: servicioController,
                              enabled: false,
                              maxLines: null,
                              enableInteractiveSelection: false,
                              decoration: InputDecoration(labelText: 'Servicio'),
                            ),
                            TextFormField(
                              enabled: false,
                              enableInteractiveSelection: false,
                              controller: fechaController,
                              decoration: InputDecoration(labelText: 'Fecha'),
                            ),
                            TextFormField(
                              enabled: false,
                              enableInteractiveSelection: false,
                              controller: placaController,
                              decoration: InputDecoration(labelText: 'Placa'),
                            ),
                            TextFormField(
                              enabled: false,
                              enableInteractiveSelection: false,
                              controller: chasisController,
                              decoration: InputDecoration(labelText: 'Chasis'),
                            ),
                            TextFormField(
                              enabled: false,
                              enableInteractiveSelection: false,
                              controller: planController,
                              decoration: InputDecoration(labelText: 'Plan'),
                            ),
                          ],
                        ),
                      )
                    ),
                    Step(
                      isActive: currentStep >= 1,
                      state: currentStep >= 1
                          ? (currentStep == 1
                          ? StepState.indexed
                          : StepState.complete)
                          : StepState.disabled,
                      title: const Text('Inspección Inicial'),
                      content: Form(
                        key: _formKeyStep2,
                        child: Column(
                          children: [
                            Text("Porfavor asegurarse de tener una conexión estable a internet (Datos, Wifi, etc) para no tener ningun inconveniente"),
                            ButtonBlue(
                                text: 'Foto de la Orte',
                                height: 30.0,
                                onPressed: () => _takePicture('Orte', 'Inspeccion Inicial')
                            ),
                            ButtonBlue(
                                text: 'Foto del chasis',
                                height: 30.0,
                                onPressed: () => _takePicture('Chasis', 'Inspeccion Inicial')
                            ),
                            ButtonBlue(
                                text: 'V. FRONTAL',
                                height: 30.0,
                                onPressed: () => _takePicture('Frontal', 'Inspeccion Inicial')
                            ),
                            ButtonBlue(
                                text: 'V. POSTERIOR',
                                height: 30.0,
                                onPressed: () => _takePicture('Posterior', 'Inspeccion Inicial')
                            ),
                            ButtonBlue(
                                text: 'V. LADO DERECHO',
                                height: 30.0,
                                onPressed: () => _takePicture('LadoDerecho', 'Inspeccion Inicial')
                            ),
                            ButtonBlue(
                                text: 'V. LADO IZQUIERDO',
                                height: 30.0,
                                onPressed: () => _takePicture('LadoIzquierdo', 'Inspeccion Inicial')
                            ),
                            ButtonBlue(
                                text: 'Area de Trabajo',
                                height: 30.0,
                                onPressed: () => _takePicture('AreaDeTrabajo', 'Inspeccion Inicial')
                            ),
                            ButtonBlue(
                                text: 'Tablero de Instrumentos',
                                height: 30.0,
                                onPressed: () => _takePicture('TblInstrumentos', 'Inspeccion Inicial')
                            ),
                            ButtonBlue(
                                text: 'Protectores',
                                height: 30.0,
                                onPressed: () => _takePicture('Protectores', 'Inspeccion Inicial')
                            ),
                          ])
                        ),
                    ),
                    Step(
                      isActive: currentStep >= 2,
                      state: currentStep >= 2
                          ? (currentStep == 2
                          ? StepState.indexed
                          : StepState.complete)
                          : StepState.disabled,
                      title: const Text('Información GPS'),
                      content: Form(
                        key: _formKeyStep3,
                        child: Column(
                          children: <Widget>[

                            Container(
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text('Sistema', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text("Octo"),
                              // title: Text("Octo - Deshabilitado para Pruebas GPS (Temporalmente)"),
                              leading: Radio(
                                value: "OCTO",
                                groupValue: sistema,
                                onChanged: (value) {
                                  setState(() {
                                    sistema = value.toString();
                                  });
                                },
                                // onChanged: null
                              ),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text("Track"),
                              leading: Radio(
                                value: "TRACK",
                                groupValue: sistema,
                                onChanged: (value) {
                                  setState(() {
                                    sistema = value.toString();
                                  });
                                },
                              ),
                            ),

                            // if (servicio == 'CHEQUEO')
                            // CheckboxListTile(
                            //   dense: true,
                            //   contentPadding: EdgeInsets.zero,
                            //   title: Text("¿Se ha cambiado de Equipo GPS?"),
                            //   value: cambioGps,
                            //   onChanged: (newValue) {
                            //     setState(() {
                            //       cambioGps = newValue!;
                            //     });
                            //   },
                            //   controlAffinity: ListTileControlAffinity.trailing,
                            // ),

                            if (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || servicio == 'DESINSTALACION' || cambioGps)
                            Row(
                              children: [
                                Expanded(child: TextFormField(
                                  controller: imeiControoler,
                                  validator: (value) => emptyValidator(value),
                                  decoration: InputDecoration(labelText: 'IMEI'),
                                  onChanged: (String value) {
                                    if (value.length < 15) {
                                      return;
                                    }

                                    if (sistema == 'TRACK') {
                                      getSimImei(value);
                                    }
                                  },
                                )),
                                InkWell(
                                    onTap: () {
                                      _getImeiBarcodeScanner();
                                    },
                                    child: Container(
                                        height: 35.0,
                                        width: 40.0,
                                        child: Icon(Icons.settings_overscan, color: Colors.white,),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.elliptical(5.0, 5.0)),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF2362f5), //Arriba
                                                  Color(0xFF2362f5) //bajo
                                                ],
                                                begin: FractionalOffset(0.2, 0.0),
                                                end: FractionalOffset(1.0, 0.6),
                                                stops: [0.0, 0.6],
                                                tileMode: TileMode.clamp
                                            )
                                        )
                                    )
                                )
                              ],
                            ),

                            if (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || servicio == 'DESINSTALACION' || cambioGps)
                            TextFormField(
                              controller: idControoler,
                              enabled: sistema != 'TRACK',
                              maxLines: null,
                              enableInteractiveSelection: sistema != 'TRACK',
                              decoration: InputDecoration(labelText: 'ID'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  CustomAlertDialog.showAlertDialog(context, 'Consulta IMEI', 'Numero IMEI no se encuentra registrado, ingrese otro numero de IMEI');
                                  return 'Campo requerido';
                                }

                                return null;
                              },
                              onChanged: (String value) {
                                if (sistema != 'TRACK') {
                                  currInstallation.unitid = idControoler.text;
                                }
                              },
                            ),

                            if (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || cambioGps)
                            TextFormField(
                              controller: odometroControoler,
                              keyboardType: TextInputType.number,
                              validator: (value) => emptyValidator(value),
                              decoration: InputDecoration(labelText: 'Odometro'),
                            ),


                            if (servicio != 'DESINSTALACION')
                            TextFormField(
                              controller: ubicacionSistemaControoler,
                              validator: (value) => emptyValidator(value),
                              decoration: InputDecoration(labelText: 'Ubicacion de Sistema'),
                            ),

                            if (servicio != 'DESINSTALACION')
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Lugar de Instalacion',
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("Concesionario"),
                                  leading: Radio(
                                    value: "CONCESIONARIO",
                                    groupValue: lugarInstalacion,
                                    onChanged: (value) {
                                      setState(() {
                                        lugarInstalacion = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("Domicilio Cliente"),
                                  leading: Radio(
                                    value: "DOMICILIO CLIENTE",
                                    groupValue: lugarInstalacion,
                                    onChanged: (value) {
                                      setState(() {
                                        lugarInstalacion = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("Taller San Isidro"),
                                  leading: Radio(
                                    value: "TALLER SAN ISIDRO",
                                    groupValue: lugarInstalacion,
                                    onChanged: (value) {
                                      setState(() {
                                        lugarInstalacion = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            TextFormField(
                              controller: tecnicoController,
                              enabled: false,
                              maxLines: null,
                              enableInteractiveSelection: false,
                              decoration: InputDecoration(labelText: 'Tecnico Instalador'),
                            ),

                            if (sistema == 'TRACK' && servicio != 'DESINSTALACION' && servicio != 'CHEQUEO')
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Servicios Adicionales',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                CheckboxListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("Bloqueo de Motor"),
                                  value: bloqueoMotor,
                                  onChanged: (newValue) {
                                    setState(() {
                                      bloqueoMotor = newValue!;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.trailing,
                                ),
                                CheckboxListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("Apertura de Pestillos"),
                                  value: aperturaPestillos,
                                  onChanged: (newValue) {
                                    setState(() {
                                      aperturaPestillos = newValue!;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.trailing,
                                ),
                                CheckboxListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("Boton de Panico"),
                                  value: botonPanico,
                                  onChanged: (newValue) {
                                    setState(() {
                                      botonPanico = newValue!;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.trailing,
                                ),
                                CheckboxListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("Sensor de Combustible"),
                                  value: sensorCombustible,
                                  onChanged: (newValue) {
                                    setState(() {
                                      sensorCombustible = newValue!;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.trailing,
                                ),
                              ],
                            ),

                            botonPanico ?
                            TextFormField(
                              controller: ubicacionBotonController,
                              validator: (value) => emptyValidator(value),
                              decoration: InputDecoration(labelText: 'Ubicacion Boton de Panico'),
                            ) : Row(),

                            sensorCombustible ?
                            TextFormField(
                              controller: medidaCombustibleController,
                              validator: (value) => emptyValidator(value),
                              decoration: InputDecoration(labelText: 'Medida Combustible'),
                            ) : Row(),

                            TextFormField(
                              controller: observacionController,
                              maxLines: 2,
                              decoration: InputDecoration(labelText: 'Observacion'),
                            ),
                          ]
                        ),
                      )
                    ),
                    Step(
                      isActive: currentStep >= 3,
                      state: currentStep >= 3
                          ? (currentStep == 3
                          ? StepState.indexed
                          : StepState.complete)
                          : StepState.disabled,
                      title: const Text('Pruebas GPS'),
                      content: Form(
                        key: _formKeyStep4,
                        child: Column(
                          children: <Widget>[
                            if (servicio == 'DESINSTALACION' || (servicio == 'CHEQUEO' && !cambioGps))
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text('Para finalizar presione el boton CONTINUAR',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),

                            if (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || cambioGps)
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text('Tipo de Instalacion',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            if (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || cambioGps)
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text("Modo 1"),
                              leading: Radio(
                                value: "MODO 1",
                                groupValue: modoInstalacion,
                                onChanged: (value) {
                                  setState(() {
                                    modoInstalacion = value.toString();
                                  });
                                },
                              ),
                            ),
                            if (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || cambioGps)
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text("Modo 2"),
                              leading: Radio(
                                value: "MODO 2",
                                groupValue: modoInstalacion,
                                onChanged: (value) {
                                  setState(() {
                                    modoInstalacion = value.toString();
                                  });
                                },
                              ),
                            ),

                            if (sistema == 'TRACK' && (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || cambioGps))
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text('Pruebas:',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            if (sistema == 'TRACK' && (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || cambioGps))
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text('- OBTENER ULTIMA UBICACION DEL GPS',
                                  style: TextStyle(fontSize: 12.0)),
                            ),

                            if (sistema == 'TRACK' && (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || cambioGps))
                            ButtonBlue(
                                text: 'Prueba Ubicacion',
                                height: 30.0,
                                onPressed: () => getTestAlert('DISP_LOC')),
                            showTestResult(testUbicacion),

                            if (sistema == 'TRACK' && (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || cambioGps))
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 50),
                                    alignment: Alignment.centerLeft,
                                    child: Text('- CONSULTAR RESPUESTA DE PRUEBAS ENVIADOS',
                                        style: TextStyle(fontSize: 12.0)),
                                  ),
                                  ButtonBlue(
                                      text: 'Alerta de Panico',
                                      height: 30.0,
                                      onPressed: () => getTestAlert('ALERT_PA')),
                                  showTestResult(testBotonPanico),
                                  ButtonBlue(
                                      text: 'Desconexion de Bateria',
                                      height: 30.0,
                                      onPressed: () => getTestAlert('DESC_BT')),
                                  showTestResult(testBateria),
                                  ButtonBlue(
                                      text: 'Motor Apagado',
                                      height: 30.0,
                                      onPressed: () => getTestAlert('ING_OFF')),
                                  showTestResult(testApagarMotor),
                                  ButtonBlue(
                                      text: 'Motor Encendido',
                                      height: 30.0,
                                      onPressed: () => getTestAlert('IGN_ON')),
                                  showTestResult(testEncenderMotor),

                                  Container(
                                    padding: EdgeInsets.only(top: 50),
                                    alignment: Alignment.centerLeft,
                                    child: Text('- ENVIAR COMANDOS DE PRUEBA',
                                        style: TextStyle(fontSize: 12.0)),
                                  ),
                                  ButtonBlue(
                                      text: 'Bloquear motor',
                                      height: 30.0,
                                      onPressed: () => sendTestCommand('IGN_BLOQ', odometroControoler.text)),
                                  showTestResult(testBloquearMotor),
                                  ButtonBlue(
                                      text: 'Desbloquear motor',
                                      height: 30.0,
                                      onPressed: () => sendTestCommand('IGN_DBLOQ', odometroControoler.text)),
                                  showTestResult(testDesbloquearMotor),
                                  ButtonBlue(
                                      text: 'Abrir pestillos',
                                      height: 30.0,
                                      onPressed: () => sendTestCommand('OPEN_PEST', odometroControoler.text)),
                                  showTestResult(testAbrirPestillos),
                                  ButtonBlue(
                                      text: 'Configurar Odometro',
                                      height: 30.0,
                                      onPressed: () => sendTestCommand('SETT_ODO', odometroControoler.text)),
                                  showTestResult(configOdometro),
                                  ButtonBlue(
                                      text: 'Reiniciar despositivo GPS',
                                      height: 30.0,
                                      onPressed: () => sendTestCommand('RESET_GPS', odometroControoler.text)),
                                ],
                              ),
                            if(sistema == 'OCTO' && (servicio == 'INSTALACION' || servicio == 'REINSTALACION' || cambioGps))
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text('¡Los dispositivos OCTO no cuentan con pruebas de ubicación por el momento, contactarse con el área encargada!',
                                  style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: showTestResult(testReiniciarGps),
                            )
                          ],
                        ),
                      )
                    ),
                    Step(
                      isActive: currentStep >= 4,
                      state: currentStep >= 4
                          ? (currentStep == 4
                          ? StepState.indexed
                          : StepState.complete)
                          : StepState.disabled,
                      title: const Text('Inspeccion final'),
                      content: Form(
                        key: _formKeyStep5,
                        child: Column(
                          children: [
                            Text("Porfavor asegurarse de tener una conexión estable a internet (Datos, Wifi, etc) para no tener ningun inconveniente"),
                            if(sistema == "OCTO" || sistema == "TRACK")
                            ButtonBlue(
                                text: 'Conexion de toma positiva',
                                height: 30.0,
                                onPressed: () => _takePicture("Conexion de toma positiva", 'Inspeccion final')
                            ),
                            if(sistema == "OCTO" || sistema == "TRACK")
                            ButtonBlue(
                                text: 'Conexion de toma negativa',
                                height: 30.0,
                                onPressed: () => _takePicture('Conexion de toma negativa', 'Inspeccion final')
                            ),
                            if(sistema == "OCTO" || sistema == "TRACK")
                            ButtonBlue(
                                text: 'Adherir y ubicacion del GPS',
                                height: 30.0,
                                onPressed: () => _takePicture('Adherir y ubicacion del GPS', 'Inspeccion final')
                            ),
                            if(sistema == "TRACK")
                            ButtonBlue(
                                text: 'Conexion de toma IGN',
                                height: 30.0,
                                onPressed: () => _takePicture('Conexion de toma IGN', 'Inspeccion final')
                            ),
                            if(sistema == "TRACK")
                            ButtonBlue(
                                text: 'Cable de bloqueo de Motor',
                                height: 30.0,
                                onPressed: () => _takePicture('Cable de bloqueo de Motor', 'Inspeccion final')
                            ),
                            if(sistema == "TRACK")
                            ButtonBlue(
                                text: 'Conexion de la toma Apertura Pestillas',
                                height: 30.0,
                                onPressed: () => _takePicture('Conexion de la toma Apertura Pestillas', 'Inspeccion final')
                            ),
                            if(sistema == "TRACK")
                            ButtonBlue(
                                text: 'Camuflaje del cableado',
                                height: 30.0,
                                onPressed: () => _takePicture('Camuflaje del cableado', 'Inspeccion final')
                            ),
                            if(sistema == "TRACK")
                            ButtonBlue(
                                text: 'Camuflaje del relé',
                                height: 30.0,
                                onPressed: () => _takePicture('Camuflaje del relé', 'Inspeccion final')
                            ),
                            if(sistema == "TRACK")
                            ButtonBlue(
                                text: 'Ubicacion del boton de Panico',
                                height: 30.0,
                                onPressed: () => _takePicture('Ubicacion del boton de Panico', 'Inspeccion final')
                            ),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),

          isLoading ? CustomLoader.circleLoader() : Text("")
        ],
      )
    );
  }
}
