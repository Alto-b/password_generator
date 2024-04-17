import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _key = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[300],
      // ),
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
                  SizedBox(height: screenHeight/9,),
                  textController.text.trim().length == 0 ?
                  Lottie.asset('lib/assets/pg.json',height: screenHeight/3) :
                  QrImageView(
                      data: textController.text.trim(),
                      version: QrVersions.auto,
                      size: screenHeight/3,
                    ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     textController.text.isEmpty?Text("Enter something!",style: textStyle1(),) :
                     Expanded(
                       child: Center(
                         child: Text(generatePasswordFromText(textController.text, textController.text.length),
                          // style: textController.text.length>=8? passwordStyle().copyWith(color: Colors.green) : passwordStyle(),
                          style: passwordStyle(textController.text.length),
                          ),
                       ),
                     ),
                      textController.text.isEmpty?SizedBox() : 
                      PlatformIconButton(
                    onPressed: () async{
                      await Clipboard.setData(ClipboardData(text: generatePasswordFromText(textController.text, textController.text.length).trim()));
                    },
                    icon: Icon(Icons.copy),
                    material: (context, platform) => MaterialIconButtonData(
                      autofocus: true,
                      color: Colors.blueAccent
                    ),
                    cupertino: (context, platform) => CupertinoIconButtonData(
                      
                    ),
                  ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  // Spacer(),
                  Form(
                    key: _key,
                    child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          color: Colors.grey.shade100,
                          elevation:2,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: textController,
                            decoration: InputDecoration(
                              suffix: Text(textController.text.length.toString(),style: TextStyle(
                                color: Colors.grey[500]
                              ),),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none
                              )
                            ),
                            onChanged: (value) {
                              generatePasswordFromText(textController.text, textController.text.length);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      
                      
                    ],
                  )),
                  SizedBox(height: 30,),
          
                  // PlatformIconButton(
                  //   onPressed: () {
                      
                  //   },
                  //   icon: Icon(Icons.qr_code),
                  //   material: (context, platform) => MaterialIconButtonData(
                  //     autofocus: true
                  //   ),
                  //   cupertino: (context, platform) => CupertinoIconButtonData(
                      
                  //   ),
                  // ),
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
  if (length <=2) {
    textColor = Colors.red;
  }
  else if (length>=5 && length<=7){
    textColor = Colors.amber;
  }
  else if (length>=2 && length<=4){
    textColor = Colors.orange;
  }
  else if (length >= 8) {
    textColor = Colors.green;
  }
   else {
    textColor = Colors.grey;
  }

  return TextStyle(
    fontSize: 25,
    color: textColor,
    fontWeight: FontWeight.w700,
  );
}


  TextStyle textStyle1() =>TextStyle(
    fontSize: 25,
    color: Colors.grey[500],
    fontWeight: FontWeight.w700
  );

  String generatePasswordFromText(String text, int length) {
  // Convert the input text to bytes and hash it
  final bytes = utf8.encode(text);
  final hash = sha256.convert(bytes).toString();

  // Characters for the password generation
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const symbols = '!@#%^&*'; // Symbols to include when text length >= 8
  const numbers = '0123456789'; // Numbers to include when text length >= 8

  // Use the hash as a seed for the random number generator
  final random = Random(hash.hashCode);

  // Generate the password based on the hash
  String password = String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));

  // Include a symbol if the text length is greater than or equal to 8
  if (text.length >= 8) {
    final symbol = symbols[random.nextInt(symbols.length)];
    final number = numbers[random.nextInt(numbers.length)];

    // Insert the symbol at a random position in the password
    final index = random.nextInt(password.length + 1);
    password = password.substring(0, index) + symbol + password.substring(index);

    // Insert the number at a random position in the password
    final index2 = random.nextInt(password.length + 1);
    password = password.substring(0, index2) + number + password.substring(index2);
  }

  return password;
}


//   String generatePasswordFromText(String text, int length) {
//   // Convert the input text to bytes and hash it
//   final bytes = utf8.encode(text);
//   final hash = sha256.convert(bytes).toString();

//   // Characters for the password generation
//   const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//   const symbols = '!@#%^&*'; // Symbols to include when text length >= 8

//   // Use the hash as a seed for the random number generator
//   final random = Random(hash.hashCode);

//   // Generate the password based on the hash
//   String password = String.fromCharCodes(Iterable.generate(
//       length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));

//   // Include a symbol if the text length is greater than or equal to 8
//   if (text.length >= 8) {
//     final symbol = symbols[random.nextInt(symbols.length)];
//     // Insert the symbol at a random position in the password
//     final index = random.nextInt(password.length + 1);
//     password = password.substring(0, index) + symbol + password.substring(index);
//   }

//   return password;
// }


// String generatePasswordFromText(String text, int length) {
//   // If the text is empty, generate a completely random password
//   if (text.length ==0) {
//     return generateRandomPassword(length);
//   } else {
//     // Convert the input text to bytes and hash it
//     final bytes = utf8.encode(text);
//     final hash = sha256.convert(bytes).toString();

//     // Characters for the password generation
//     const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*';

//     // Use the hash as a seed for the random number generator
//     final random = Random(hash.hashCode);

//     // Generate the password based on the hash
//     return String.fromCharCodes(Iterable.generate(
//         length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
//   }
// }

// String generateRandomPassword(int length) {
//   // Characters for the password generation
//   const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*';

//   // Use a random number generator
//   final random = Random();

//   // Generate a completely random password
//   return String.fromCharCodes(Iterable.generate(
//       length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
// }

}