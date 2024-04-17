import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: GestureDetector(
            onTap: () {
               FocusScope.of(context).unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('lib/assets/pg.json',height: screenHeight/3),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   textController.text.isEmpty?Text("Enter a text",style: textStyle1(),) :Text(generatePasswordFromText(textController.text, textController.text.length)),
                    textController.text.isEmpty?SizedBox() :IconButton(onPressed: (){}, icon: Icon(Icons.copy)),
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
                          controller: textController,
                          decoration: InputDecoration(
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
                SizedBox(height: 30,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyle1() => GoogleFonts.orbitron();

  String generatePasswordFromText(String text, int length) {
  // Convert the input text to bytes and hash it
  final bytes = utf8.encode(text);
  final hash = sha256.convert(bytes).toString();

  // Characters for the password generation
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*';

  // Use the hash as a seed for the random number generator
  final random = Random(hash.hashCode);

  // Generate the password based on the hash
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

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