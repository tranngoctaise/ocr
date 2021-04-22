import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocr_demo/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:ocr_demo/model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomeScreen extends StatefulWidget {
  final String recognizedText;
  HomeScreen(this.recognizedText);
  @override
  _HomeScreenState createState() => _HomeScreenState(recognizedText);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.recognizedText);
  final String recognizedText;
  List<CameraDescription> cameras = [];
  // String _scanBarcode = 'Unknown';
  List<BaoHanh> listData = [];

  var data = '''[
    {
      "serial": "00001",
      "sanPham": "iphone",
      "thuongHieu": "apple"
    },
    {
      "serial": "00002",
      "sanPham": "samsung",
      "thuongHieu": "samsung"
    },
    {
      "serial": "00003",
      "sanPham": "sony",
      "thuongHieu": "sony"
    },
    {
      "serial": "00004",
      "sanPham": "xiaomi",
      "thuongHieu": "xiaomi"
    }
  ]''';

  Future<List<BaoHanh>> fetchData() async {
    return baoHanhFromJson(data);
  }

  scanText() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CameraScreen(cameras)));
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _serialController.text = barcodeScanRes;
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _serialController.text = barcodeScanRes;
    });
  }

  TextEditingController _serialController = TextEditingController();
  TextEditingController _sanphamController = TextEditingController();
  TextEditingController _thuonghieuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (recognizedText != null) {
      fetchData().then((value) {
        var index;
        index = value.map((e) => e.serial).toList().indexOf(recognizedText);
        if (index != -1) {
          setState(() {
            _serialController.text = value[index].serial;
            _sanphamController.text = value[index].sanPham;
            _thuonghieuController.text = value[index].thuongHieu;
          });
        }
      });
    }
  }

  String dropdownValue = 'Text';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kích hoạt bảo hành'),
      ),
      // body: Center(
      //   child: TextButton(
      //     child: Text('Click'),
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => CameraScreen(this.cameras)));
      //     },
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _serialController,
                        decoration: InputDecoration(
                          labelText: 'Số bảo hành/ Số seri',
                        ),
                        // decoration: InputDecoration(
                        //     labelText: 'Số bảo hành/ Số seri',
                        //     suffixIcon: IconButton(
                        //       icon: Icon(Icons.camera_alt),
                        //       onPressed: () async {
                        //         try {
                        //           WidgetsFlutterBinding.ensureInitialized();
                        //           // Retrieve the device cameras
                        //           cameras = await availableCameras();
                        //         } on CameraException catch (e) {
                        //           print(e);
                        //         }
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => CameraScreen(cameras)));
                        //       },
                        //     )),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                          value: dropdownValue,
                          items: <String>['Text', 'Barcode', 'QR']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value;
                            });
                          }),
                    ),
                    TextButton(
                      child: Icon(Icons.camera_alt),
                      onPressed: () async {
                        try {
                          WidgetsFlutterBinding.ensureInitialized();
                          // Retrieve the device cameras
                          cameras = await availableCameras();
                        } on CameraException catch (e) {
                          print(e);
                        }
                        switch (dropdownValue) {
                          case 'Barcode':
                            return scanBarcodeNormal();
                            break;
                          case 'QR':
                            return scanQR();
                            break;
                          default:
                            return scanText();
                        }
                      },
                    )
                  ],
                ),
                TextFormField(
                  readOnly: true,
                  controller: _sanphamController,
                  decoration: InputDecoration(labelText: 'Sản phẩm'),
                ),
                TextFormField(
                  readOnly: true,
                  controller: _thuonghieuController,
                  decoration: InputDecoration(labelText: 'Thương hiệu'),
                ),
                TextFormField(
                  controller: TextEditingController(text: ''),
                  decoration: InputDecoration(labelText: 'Tên khách hàng'),
                ),
                TextFormField(
                  controller: TextEditingController(text: ''),
                  decoration: InputDecoration(labelText: 'Số điện thoại'),
                ),
                TextFormField(
                  controller: TextEditingController(text: ''),
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
