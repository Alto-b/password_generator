import 'package:SecurePass/imports.dart';


class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("SecurePass",style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w800,
            fontSize: 15
          ),),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ScannerPage(),));
              Navigator.of(context).push(_routeToScanner());
            }, icon: Icon(Icons.qr_code_scanner_outlined)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight / 12),
                  Screenshot(
                    controller: screenshotController,
                    child: Column(
                      children: [
                        textController.text.trim().length == 0 ?
                        Lottie.asset('lib/assets/pg.json',height: screenHeight/3) :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            QrImageView(
                                data: textController.text.trim(),
                                version: QrVersions.auto,
                                size: screenHeight/4,
                              ), 
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textController.text.isEmpty
                                ? Text(
                                    "Enter something!",
                                    style: textStyle1(),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        generatePasswordFromText(
                                          textController.text,
                                          textController.text.length,
                                        ),
                                        style: passwordStyle(
                                            textController.text.length),
                                      ),
                                    ),
                                  ),
                            textController.text.isEmpty
                                ? SizedBox()
                                : Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await Clipboard.setData(
                                            ClipboardData(
                                              text: generatePasswordFromText(
                                                      textController.text,
                                                      textController.text.length)
                                                  .trim(),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.copy),
                                        color: Colors.blueAccent,
                                      ),

                                      IconButton(onPressed: () async {
                                Uint8List? imageBytes =
                          await screenshotController.capture();
                      await saveQrCodeImage(imageBytes!);
                              }, icon: Icon(Icons.save_alt_outlined,color: Colors.cyan))
                                  ],
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _key,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            color: Colors.grey.shade100,
                            elevation: 2,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: textController,
                              decoration: InputDecoration(
                                prefix: Text(
                                  textController.text.length.toString(),
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                                suffix: textController.text.length != 0 ? IconButton(onPressed: () {
                                  textController.clear();
                                  setState(() {});
                                }, icon: Icon(Icons.clear,color: Colors.grey,)) : SizedBox(),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none),
                              ),
                              onChanged: (value) {
                                generatePasswordFromText(
                                  textController.text,
                                  textController.text.length,
                                );
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle passwordStyle(int length) {
    Color textColor;
    if (length <= 2) {
      textColor = Colors.red;
    } else if (length >= 5 && length <= 7) {
      textColor = Colors.amber;
    } else if (length >= 2 && length <= 4) {
      textColor = Colors.orange;
    } else if (length >= 8) {
      textColor = Colors.green;
    } else {
      textColor = Colors.grey;
    }

    return TextStyle(
      fontSize: 25,
      color: textColor,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle textStyle1() => TextStyle(
      fontSize: 25, color: Colors.grey[500], fontWeight: FontWeight.w700);

  String generatePasswordFromText(String text, int length) {
    final bytes = utf8.encode(text);
    final hash = sha256.convert(bytes).toString();

    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const symbols = '!@#%^&*';
    const numbers = '0123456789';

    final random = Random(hash.hashCode);

    String password = String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));

    if (text.length >= 8) {
      final symbol = symbols[random.nextInt(symbols.length)];
      final number = numbers[random.nextInt(numbers.length)];

      final index = random.nextInt(password.length + 1);
      password =
          password.substring(0, index) + symbol + password.substring(index);

      final index2 = random.nextInt(password.length + 1);
      password = password.substring(0, index2) +
          number +
          password.substring(index2);
    }

    return password;
  }

  Future<void> saveQrCodeImage(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes);
    print(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR Code saved to gallery.'),
      ),
    );
  }

//   Future<void> _captureAndSharePng() async {
//   screenshotController.capture().then((File image1) async {
//     //Capture Done
//     List<int> bytes1 = await image1.readAsBytes();

//     await Share.file("Code",
//       'title' + ".jpg", bytes1, 'image/jpg',
//       text: "Join Group by scanning this code"
//     );
//   } as FutureOr Function(Uint8List? value)).catchError((onError) {
//     print(onError);
//   });
// }
}

Route _routeToScanner() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const ScannerPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  final tween = Tween(begin: begin, end: end);
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: curve,
  );

  return SlideTransition(
    position: tween.animate(curvedAnimation),
    child: child,
  );

},
  );
}
