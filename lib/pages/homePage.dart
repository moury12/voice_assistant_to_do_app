import 'dart:developer';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_assistant/Services/openAi_service.dart';
import 'package:voice_assistant/widgets/features.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  stt.SpeechToText speechToText = stt.SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  OpenAiService openAi = OpenAiService();
  bool isPlaying = false;
  bool isListening = false;
  String recognizedWords = '';
  String generatedContent = '';
  String generatedImageUrl = '';

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  Future<void> initSpeech() async {
    bool available = await speechToText.initialize();
    if (available) {
      setState(() {});
    }
  }

  Future<void> _startListening() async {
    if (!isListening) {
      setState(() {
        isListening = true;
      });
      speechToText.listen(
        onResult: (result) {
          setState(() {
            recognizedWords = result.recognizedWords;
          });
        },
      );
    }
  }

  Future<void> _stopListening() async {
    if (isListening) {
      setState(() {
        isListening = false;
      });
      await speechToText.stop();
      if (recognizedWords.isNotEmpty) {
        String response = await openAi.isArtApi(recognizedWords);
        if (response.contains('https')) {
          setState(() {
            generatedImageUrl = response;
            generatedContent = '';
          });
        } else {

            generatedImageUrl = '';
            generatedContent = response;
            await speak(response);
            setState(() {   });
          // Stop the FlutterTts speech voice
        }
      }
    }
  }
  Future<void> speak(String text) async {
    setState(() {
      isPlaying = true;
    });
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
  }
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      recognizedWords = result.recognizedWords;
    });
  }
@override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    speechToText.stop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 40,
        leading: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Icon(IconlyLight.message,size: 20,),
            SizedBox(width: 3,),
            Icon(IconlyLight.notification,size: 20,),

          ],
        ),
      ),
      actions: [InkWell(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.circle , size: 5,
            ),  Padding(
              padding: const EdgeInsets.all(3.0),
              child: Icon(Icons.circle , size: 5,
              ),
            ),  Icon(Icons.circle , size: 5,
            ),
          ],
        ),
      ),)],backgroundColor: Colors.white,),
      body: Container(height: 600,
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Center(child: Image.network('https://cdn-icons-png.flaticon.com/512/201/201634.png',height: 100,width: 100,)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 19).copyWith(bottom: 10),
            child:generatedImageUrl.isEmpty? Container(alignment: Alignment.center,
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 19),
              child: Text(generatedContent.isNotEmpty?
                  '$generatedContent'
               : 'Hey There, what task can I do for you?',style: GoogleFonts.quattrocento(fontSize:generatedContent.isEmpty? 20:15),maxLines: generatedContent== null?2:200,overflow: TextOverflow.ellipsis,),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey,width: 1),borderRadius: BorderRadius.vertical(top: Radius.circular(20),bottom: Radius.circular(20),).copyWith(topLeft: Radius.zero)
            ),):Image.network(generatedImageUrl),
          ),
             Visibility(visible: generatedContent.isEmpty&& generatedImageUrl.isEmpty,
               child: Column(
                 children: [
                   Align(alignment: Alignment.centerLeft,
                     child: Padding(
                       padding: const EdgeInsets.only(left: 18.0),
                       child: Text(
                         'Here are some features',style: GoogleFonts.quattrocento(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.lightBlue.shade900),),
                     ),
                   ),
                   Features(title: 'ChatGPT', text: 'A smarter way to stay organized and informed with ChatGPT', color: Colors.cyan.shade50),
                   Features(title: 'Generate an image ', text: 'Evie can quickly create image and draw them on screen', color: Colors.indigo.shade50),
                   Features(title: 'View task list', text: 'Evie easily manages and organizes all of your', color: Colors.lightBlue.shade50),
                 ],
               ),
             )

            ],),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ recognizedWords.isNotEmpty?  Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10).copyWith(topLeft: Radius.zero)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$recognizedWords',maxLines: 1,overflow: TextOverflow.ellipsis,),
              ),
            ):SizedBox.shrink(),SizedBox(width: 15,),
              FloatingActionButton.small(onPressed: () {

stopTts();
              },heroTag: 12,
              child: Icon(isPlaying==true?IconlyLight.volumeOff:IconlyLight.volumeUp,color: Colors.black,),
              backgroundColor: Colors.grey.shade200,), SizedBox(width: 15,),
              FloatingActionButton.small(
                onPressed: isListening ? _stopListening : _startListening,
                heroTag: 'voiceButton',
                child: Icon(isListening ? Icons.stop : IconlyLight.voice, color: Colors.black),
                backgroundColor:  Colors.red.shade50 ,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> stopTts() async{
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
    });
  }
}
