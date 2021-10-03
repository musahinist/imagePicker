// import 'dart:async';
// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;

// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class TtsApp extends StatefulWidget {
//   const TtsApp({Key? key}) : super(key: key);
//   static const routeName = '/tts_app_page';
//   @override
//   _TtsAppState createState() => _TtsAppState();
// }

// enum TtsState { playing, stopped, paused, continued }

// class _TtsAppState extends State<TtsApp> {
//   late FlutterTts flutterTts;
//   String? language;
//   String? engine;
//   double volume = 0.5;
//   double pitch = 1.0;
//   double rate = 0.5;
//   bool isCurrentLanguageInstalled = false;

//   String? _newVoiceText =
//       'Kibriti bir elinden diğer eline geçirerek parmaklarını ısıtıyormuş. Elleri üşümüyormuş artık. Kendini gürül gürül yanan bir sobanın yanında bulmuş. Gözlerini sobadan çıkan aleve dikmiş. Üstünde kalın yünlü bir hırka ayaklarında kürklü botları ve başında beresi varmış.O kadar sıcakmış ki o da terlemeye bile başlamış Kibritçi kız derken kibrit sönü vermiş. Kibritin sönmesiyle o tatlı düşler sona ermiş. Kızcağızın parmakları yeniden donmaya sızmaya başlamış. Bir kibrit daha yakmış bu sırada küçük kız kibrit sönmesin diye duvara dönmüş diğer eli ile kibrite siper etmiş. Aleve bakarken karşısındaki duvar yok olmuş ve birden açılmış içeride geniş bir oda varmış. Bembeyaz masanın üzerinde tabak tabak yemekler dizilmiş. Kızcağız masanın üzerinde duran tabağa gözlerini dikmiş. Tabakta nar gibi kızarmış kocaman bir parçası duruyormuş. Hemen etten bir parça kopartıp ağzına atmış. O anda bütün açlığı gitmiş. Kibritçi kız bir parça et daha koparmak istemiş. Elini uzatmış ama elinde tuttuğu kibrit yana yana sonuna gelmiş. Kızcağızın eli yanmış. Sönmüş kibrit çöpünü hızla yere atmış. Atmasıyla birlikte yılbaşı sofrası silini vermiş. Oda yok olmuş. Ve önündeki taş duvar yeniden belirlenmiş. Küçük kız bir kibrit daha yakmış artık daha büyük bir düşün içindeymiş. Bir yaz gecesi Kibritçi kız kırda bir ağacın yanında oturmuş yıldızlara bakıyormuş. Gece olduğu halde hava sıcakmış. Küçük kız gözlerini yıldızlardan ayıramıyormuş. Gök yüzünün ve yıldızların hiç bu kadar berrak ve parlak görmemiş daha önce. Derken bir yıldız kaymış gökyüzünde. İşte yer yüzünden biri daha sonsuzluğa uçtu diye geçirmiş içinden bunu ona ninesi söylemiş aslında.';
//   int? _inputLength;

//   TtsState ttsState = TtsState.stopped;

//   get isPlaying => ttsState == TtsState.playing;
//   get isStopped => ttsState == TtsState.stopped;
//   get isPaused => ttsState == TtsState.paused;
//   get isContinued => ttsState == TtsState.continued;

//   bool get isIOS => !kIsWeb && Platform.isIOS;
//   bool get isAndroid => !kIsWeb && Platform.isAndroid;
//   bool get isWeb => kIsWeb;

//   @override
//   initState() {
//     super.initState();
//     initTts();
//   }

//   initTts() {
//     flutterTts = FlutterTts();

//     if (isAndroid) {
//       _getDefaultEngine();
//     }

//     flutterTts.setStartHandler(() {
//       setState(() {
//         print("Playing");
//         ttsState = TtsState.playing;
//       });
//     });

//     flutterTts.setCompletionHandler(() {
//       setState(() {
//         print("Complete");
//         ttsState = TtsState.stopped;
//       });
//     });

//     flutterTts.setCancelHandler(() {
//       setState(() {
//         print("Cancel");
//         ttsState = TtsState.stopped;
//       });
//     });

//     if (isWeb || isIOS) {
//       flutterTts.setPauseHandler(() {
//         setState(() {
//           print("Paused");
//           ttsState = TtsState.paused;
//         });
//       });

//       flutterTts.setContinueHandler(() {
//         setState(() {
//           print("Continued");
//           ttsState = TtsState.continued;
//         });
//       });
//     }

//     flutterTts.setErrorHandler((msg) {
//       setState(() {
//         print("error: $msg");
//         ttsState = TtsState.stopped;
//       });
//     });
//   }

//   Future<dynamic> _getLanguages() => flutterTts.getLanguages;

//   Future<dynamic> _getEngines() => flutterTts.getEngines;

//   Future _getDefaultEngine() async {
//     var engine = await flutterTts.getDefaultEngine;
//     if (engine != null) {
//       print(engine);
//     }
//   }

//   Future _speak() async {
//     await flutterTts.setVolume(volume);
//     await flutterTts.setSpeechRate(rate);
//     await flutterTts.setPitch(pitch);

//     if (_newVoiceText != null) {
//       if (_newVoiceText!.isNotEmpty) {
//         await flutterTts.awaitSpeakCompletion(true);
//         await flutterTts.speak(_newVoiceText!);
//       }
//     }
//   }

//   Future _stop() async {
//     var result = await flutterTts.stop();
//     if (result == 1) setState(() => ttsState = TtsState.stopped);
//   }

//   Future _pause() async {
//     var result = await flutterTts.pause();
//     if (result == 1) setState(() => ttsState = TtsState.paused);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     flutterTts.stop();
//   }

//   List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
//     var items = <DropdownMenuItem<String>>[];
//     for (dynamic type in engines) {
//       items.add(DropdownMenuItem(
//           value: type as String?, child: Text(type as String)));
//     }
//     return items;
//   }

//   void changedEnginesDropDownItem(String? selectedEngine) {
//     flutterTts.setEngine(selectedEngine!);
//     language = null;
//     setState(() {
//       engine = selectedEngine;
//     });
//   }

//   List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
//       dynamic languages) {
//     var items = <DropdownMenuItem<String>>[];
//     for (dynamic type in languages) {
//       items.add(DropdownMenuItem(
//           value: type as String?, child: Text(type as String)));
//     }
//     return items;
//   }

//   void changedLanguageDropDownItem(String? selectedType) {
//     setState(() {
//       language = selectedType;
//       flutterTts.setLanguage(language!);
//       if (isAndroid) {
//         flutterTts
//             .isLanguageInstalled(language!)
//             .then((value) => isCurrentLanguageInstalled = (value as bool));
//       }
//     });
//   }

//   void _onChange(String text) {
//     setState(() {
//       _newVoiceText = text;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter TTS'),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           children: [
//             _inputSection(),
//             _btnSection(),
//             _engineSection(),
//             _futureBuilder(),
//             _buildSliders(),
//             if (isAndroid) _getMaxSpeechInputLengthSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _engineSection() {
//     if (isAndroid) {
//       return FutureBuilder<dynamic>(
//           future: _getEngines(),
//           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//             if (snapshot.hasData) {
//               return _enginesDropDownSection(snapshot.data);
//             } else if (snapshot.hasError) {
//               return Text('Error loading engines...');
//             } else
//               return Text('Loading engines...');
//           });
//     } else
//       return Container(width: 0, height: 0);
//   }

//   Widget _futureBuilder() => FutureBuilder<dynamic>(
//       future: _getLanguages(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (snapshot.hasData) {
//           return _languageDropDownSection(snapshot.data);
//         } else if (snapshot.hasError) {
//           return Text('Error loading languages...');
//         } else
//           return Text('Loading Languages...');
//       });

//   Widget _inputSection() => Container(
//       alignment: Alignment.topCenter,
//       padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
//       child: TextField(
//         onChanged: (String value) {
//           _onChange(value);
//         },
//       ));

//   Widget _btnSection() {
//     if (isAndroid) {
//       return Container(
//           padding: EdgeInsets.only(top: 50.0),
//           child:
//               Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//             _buildButtonColumn(Colors.green, Colors.greenAccent,
//                 Icons.play_arrow, 'PLAY', _speak),
//             _buildButtonColumn(
//                 Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
//           ]));
//     } else {
//       return Container(
//           padding: EdgeInsets.only(top: 50.0),
//           child:
//               Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//             _buildButtonColumn(Colors.green, Colors.greenAccent,
//                 Icons.play_arrow, 'PLAY', _speak),
//             _buildButtonColumn(
//                 Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
//             _buildButtonColumn(
//                 Colors.blue, Colors.blueAccent, Icons.pause, 'PAUSE', _pause),
//           ]));
//     }
//   }

//   Widget _enginesDropDownSection(dynamic engines) => Container(
//         padding: EdgeInsets.only(top: 50.0),
//         child: DropdownButton(
//           value: engine,
//           items: getEnginesDropDownMenuItems(engines),
//           onChanged: changedEnginesDropDownItem,
//         ),
//       );

//   Widget _languageDropDownSection(dynamic languages) => Container(
//       padding: EdgeInsets.only(top: 10.0),
//       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         DropdownButton(
//           value: language,
//           items: getLanguageDropDownMenuItems(languages),
//           onChanged: changedLanguageDropDownItem,
//         ),
//         Visibility(
//           visible: isAndroid,
//           child: Text("Is installed: $isCurrentLanguageInstalled"),
//         ),
//       ]));

//   Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
//       String label, Function func) {
//     return Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//               icon: Icon(icon),
//               color: color,
//               splashColor: splashColor,
//               onPressed: () => func()),
//           Container(
//               margin: const EdgeInsets.only(top: 8.0),
//               child: Text(label,
//                   style: TextStyle(
//                       fontSize: 12.0,
//                       fontWeight: FontWeight.w400,
//                       color: color)))
//         ]);
//   }

//   Widget _getMaxSpeechInputLengthSection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           child: Text('Get max speech input length'),
//           onPressed: () async {
//             _inputLength = await flutterTts.getMaxSpeechInputLength;
//             setState(() {});
//           },
//         ),
//         Text("$_inputLength characters"),
//       ],
//     );
//   }

//   Widget _buildSliders() {
//     return Column(
//       children: [_volume(), _pitch(), _rate()],
//     );
//   }

//   Widget _volume() {
//     return Slider(
//         value: volume,
//         onChanged: (newVolume) {
//           setState(() => volume = newVolume);
//         },
//         min: 0.0,
//         max: 1.0,
//         divisions: 10,
//         label: "Volume: $volume");
//   }

//   Widget _pitch() {
//     return Slider(
//       value: pitch,
//       onChanged: (newPitch) {
//         setState(() => pitch = newPitch);
//       },
//       min: 0.5,
//       max: 2.0,
//       divisions: 15,
//       label: "Pitch: $pitch",
//       activeColor: Colors.red,
//     );
//   }

//   Widget _rate() {
//     return Slider(
//       value: rate,
//       onChanged: (newRate) {
//         setState(() => rate = newRate);
//       },
//       min: 0.0,
//       max: 1.0,
//       divisions: 10,
//       label: "Rate: $rate",
//       activeColor: Colors.green,
//     );
//   }
// }
