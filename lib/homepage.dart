import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as st ;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _speechToText = st.SpeechToText();
  bool isListeing = false;
  String text = "Please Press the button for Speaking...";
  void listen()async{
    if(!isListeing){
      bool available =await _speechToText.initialize(
        onStatus: (status) => print(status),
        onError: (errorNotification)=> print("$errorNotification"),
      );
      if(available){
        setState(() {
          isListeing = true;
          _speechToText.listen(
            onResult: (result) => setState(() {
              text = result.recognizedWords;
            }),
          );
        });
      }
    }else{
      setState(() {
        isListeing =false;
      });
      _speechToText.stop();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speechToText = st.SpeechToText();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Speech To Text",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            text,
            style:
            TextStyle(color: Colors.grey.shade600, fontSize: 30),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:AvatarGlow(
        animate: isListeing,
        repeat: true,
        endRadius: 80,
        glowColor: Colors.red,
        duration: const Duration(microseconds: 1000),
        child: FloatingActionButton(
          onPressed: () {
            listen();
          },
          child:  Icon(isListeing? Icons.mic: Icons.mic_none),
        ),
      ),
    );
  }
}

