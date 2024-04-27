import 'package:SecurePass/imports.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text("SecurePass",style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w800,
          fontSize: 15
        ),),
      ),
    body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              overlay: QrScannerOverlayShape(
                overlayColor: Colors.black38,
                borderWidth: 10,
                borderRadius: 10,
                borderColor: (Colors.red.shade500),
              ),
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 2,
            // child: Center(
            //   child: (result != null)
            //       ? isValidWebLink(result!.code!) ?
            //        AnyLinkPreview(link: result!.code!,
            //        )
            //        : Text('${result!.code}')
            //       : Text('Scan a code'),
            // ),
            child: Center(
                    child: () {
                      if (result != null) {
                        if (isValidWebLink(result!.code!)) {
                          // return AnyLinkPreview(link: result!.code!,backgroundColor: Colors.red,);
                          // return Text("valid link");
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: AnyLinkPreview(
                                        link: result!.code!,
                                        displayDirection: UIDirection.uiDirectionHorizontal, 
                                        cache: const Duration(seconds: 3),
                                        boxShadow: const [],
                                        removeElevation: false,
                                        backgroundColor: Colors.grey[100], 
                                        errorWidget: Container(
                                        color: Colors.grey[300], 
                                        child:  Text('${result!.code}'), 
                                        ),
                                        ),
                          );
                        } else {
                          return Text('${result!.code}');
                          // return Text("texrt");
                        }
                      } else {
                        return Text('Scan a code');
                      }
                    }(),
                  ),

          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 50,),
            FloatingActionButton(onPressed: ()async {
              await controller?.flipCamera();
            },child: Icon(Icons.cameraswitch_rounded,color: Colors.white,),
            mini: true,
            backgroundColor: Colors.grey,),
            FloatingActionButton(onPressed: ()async {
              await controller?.toggleFlash();
            },child: Icon(Icons.flashlight_on_outlined,color: Colors.white,),
            mini: true,
            backgroundColor: Colors.grey,),
            SizedBox(height: 50,),
            // FloatingActionButton(onPressed: () async{
            //   await controller?.pauseCamera();
            // },),
            // FloatingActionButton(onPressed: () async{
            //   await controller?.resumeCamera();
            // },),
          ],
        ),
      ),
    );
  }

  bool isValidWebLink(String url) {
 final uri = Uri.tryParse(url);
//  return uri != null && uri.hasAbsolutePath;
return true;
}
// bool isValidWebLink(String url) {
//   final uri = Uri.tryParse(url);
//   return uri != null && (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
// }
// bool isValidLink(String url) {
//  // Check if the URL is a valid URI with an absolute path
//  bool isValidUri = Uri.tryParse(url)?.hasAbsolutePath ?? false;

//  // Check if the URL starts with "www"
//  bool startsWithWww = url.startsWith('www.');

//  // Return true if either condition is met
//  return isValidUri || startsWithWww;
// }

final style = TextStyle(
  color: Colors.red,
  fontSize: 16,
  fontWeight: FontWeight.w500,
  height: 1.375,
);


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
