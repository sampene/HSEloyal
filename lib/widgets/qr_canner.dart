import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyal/blocs/restaurants/restaurants_bloc.dart';
import 'package:loyal/models/qr_data.dart';
import 'package:loyal/models/restaurant_data.dart';
import 'package:loyal/network/api.dart';
import 'package:loyal/resources/my_colors.dart';
import 'package:loyal/widgets/CustomBottomSheets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:styled_text/styled_text.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:http/http.dart' as http;

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class QRScanner extends StatefulWidget {
  const QRScanner({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  var qrText = '';
  var flashState = flashOn;
  var showingPopup = false;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AppAPI api;
  Restaurant_Data restaurantData;

  @override
  void initState() {
    gettheRestaurants();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 350,
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0),child: Text('$qrText',style: TextStyle(backgroundColor: Colors.green, color: Colors.white, fontSize: 12),)),
          Positioned(
            bottom: 60,
            left: width - 75,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: MyColors.heavyblueblack,
                        child: IconButton(
                          icon: (cameraState == frontCamera)
                              ? Icon(Icons.camera_rear, color: Colors.white,)
                              : Icon(Icons.camera_front, color: Colors.white,),
                          onPressed: () {
                            if (controller != null) {
                              controller.flipCamera();
                              if (_isBackCamera(cameraState)) {
                                setState(() {
                                  cameraState = frontCamera;
                                });
                              } else {
                                setState(() {
                                  cameraState = backCamera;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 30,),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: MyColors.heavyblueblack,
                        child: IconButton(
                          icon: (flashState == flashOn)
                              ? Icon(Icons.flash_off,color: Colors.white,)
                              : Icon(Icons.flash_on, color: Colors.white,),
                          onPressed: () {
                            if (controller != null) {
                              controller.toggleFlash();
                              if (_isFlashOn(flashState)) {
                                setState(() {
                                  flashState = flashOff;
                                });
                              } else {
                                setState(() {
                                  flashState = flashOn;
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  // Text('$qrText',style: TextStyle(backgroundColor: Colors.white),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        if(!showingPopup){
          loadpopup(qrText);
        }
      });
    });
  }

  QR_Data parseQRData(String text) {
    final parsed = jsonDecode(text);
    QR_Data rr = QR_Data.fromJson(parsed);
    return rr;
  }
  Restaurants getRestaurantNameByAddress(String address){
    for(var restaurant in restaurantData.restaurants){
      if(restaurant.ethAddress == address){
        return restaurant;
      }
    }
  }

  loadpopup(String qrtext) async{
    QR_Data data = parseQRData(qrtext);

    Restaurants rr = getRestaurantNameByAddress(data.address);

    showingPopup = true;
    final CustomSweetSheet _sweetSheet = CustomSweetSheet();
    _sweetSheet.show(
      context: context,
      description: StyledText(
        text: '<boldgrey>Total Sum: ${data.sum} Rubles</boldgrey> '
            '<br/><boldgrey>Points to gain: ${data.cashBack} points,</boldgrey>'
            '<br/> Click continue to make purchase or cancel to cancel purchase.'
        ,
        styles: {
          'boldgrey': TextStyle(
              // fontFamily: "Fatface",
              fontSize: 18,
              color: MyColors.primaryColor),
          'heavyblueblack': TextStyle(
              // fontFamily: "Bebas",
              fontSize: 20,
              color: MyColors.heavyblueblack),
        },
      ),
      title: Text('${rr.name} (${rr.neighborhood})', style: TextStyle(color: MyColors.heavyblueblack),),
      color: CustomBottomSheetColor(
        main: Colors.white,
        accent: MyColors.green,
        icon: MyColors.green,
      ),
      icon: Icons.local_cafe,
      positive: CustomSweetSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
          showingPopup = false;
        },
        title: 'CONTINUE',
      ),
      negative: CustomSweetSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
          showingPopup = false;
        },
        title: 'CANCEL',
      ),
    );
  }


  gettheRestaurants() async {
    api = new AppAPI();
    restaurantData = await api.getRestaurants(http.Client());
}


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}