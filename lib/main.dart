import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/speech': (context) => const RecordAudio(),
        '/text': (context) => const TextPage(),
        '/image': (context) => const ImageGenerator(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machine Translation'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/siplab.png',
                width: 420,
                height: 120,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/speech',
                      arguments: 'Speech to Text');
                },
                child: const CardWidget(
                  image: 'assets/images/micro.png',
                  text: 'Speech to Text',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/text',
                      arguments: 'Text to Text');
                },
                child: const CardWidget(
                  image: 'assets/images/text.png',
                  text: 'Text to Text',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/image',
                      arguments: 'Text to Image');
                },
                child: const CardWidget(
                  image: 'assets/images/image.png',
                  text: 'Text to Image',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String image;
  final String text;

  const CardWidget({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.2,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            image,
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}


class RecordAudio extends StatefulWidget {
  const RecordAudio({super.key});

  @override
  _RecordAudioState createState() => _RecordAudioState();
}

class _RecordAudioState extends State<RecordAudio> {
  String selectedLanguage1 = 'English'; // Initial value
  String selectedLanguage2 = 'Lambani'; // Initial value
  final _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  late final String _recordedFilePath;

  void swapSelectedLanguages() {
    setState(() {
      String temp = selectedLanguage1;
      selectedLanguage1 = selectedLanguage2;
      selectedLanguage2 = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      await _recorder.openRecorder();
      final appDir = await getApplicationDocumentsDirectory();
      _recordedFilePath = '${appDir.path}/recorded_audio.wav';
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecording) {
      await _recorder.startRecorder(
        toFile: _recordedFilePath,
        codec: Codec.pcm16WAV,
      );
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecording) {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _playRecording() async {
    final file = File(_recordedFilePath);
    final player = AudioPlayer();

    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      final source = BytesSource(bytes);
      await player.play(source);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Language Dropdowns
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedLanguage1,
                      items: ['English', 'Lambani', 'Soliga', 'Kui', 'Mundri']
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedLanguage1 = value!;
                        });
                      },
                      hint: const Text('Select Language 1'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, size: 36),
                    onPressed: swapSelectedLanguages,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedLanguage2,
                      items: ['Lambani', 'English', 'Soliga', 'Kui', 'Mundri']
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedLanguage2 = value!;
                        });
                      },
                      hint: const Text('Select Language 2'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Input Boxes
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Column(
                  children: [
                    TextField(
                      maxLines: 4,
                      readOnly: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Translated Text Appears here',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Your Text Appears Here',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 2),
              // Translate Button
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed:
                          _isRecording ? _stopRecording : _startRecording,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            // Change background color to red when recording, green otherwise
                            if (_isRecording) {
                              return Colors.red;
                            } else {
                              return Colors.green;
                            }
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isRecording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isRecording ? 'Stop Recording' : 'Start Recording',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _playRecording,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Play Recording',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 20),
                    // // Widget to display signal of the audio recording
                    // Container(
                    //   width: double.infinity,
                    //   height: 50, // Adjust height as needed
                    //   color: Colors.grey[300], // Placeholder color
                    //   // Add your widget to display the signal here
                    // ),
                  ],
                ),
              )

              // Other UI elements can be added here
            ],
          ),
        ),
      ),
    );
  }
}


class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  String selectedLanguage1 = 'English';
  String selectedLanguage2 = 'Lambani';
  TextEditingController translatedTextController = TextEditingController();
  TextEditingController userTextController = TextEditingController();

  final apiUrl = Uri.parse('https://d3b8-103-232-241-226.ngrok-free.app/machine_translation/');
  String generated_text_output = 'Your default value here'; // Set default value here

  // Create a TextEditingController instance
  TextEditingController controller = TextEditingController();

  Future<void> getText() async {
    // Append a unique query parameter to the URL to force fetching a new image
    final newGeneratedTextOutput = 'https://d3b8-103-232-241-226.ngrok-free.app/generated_text?timestamp=${DateTime.now().millisecondsSinceEpoch}';
  

  } 

 Future<void> sendDataToServer(String text1, String text2, String userText) async {
  try {
    var jsonData = {
      'text': userText,
      'src': text1,
      'tgt': text2
    };
    var response = await http.post(
      apiUrl,
      body: jsonEncode(jsonData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Text sent successfully!');
      final decodedResponse = jsonDecode(response.body);
      final generatedText = decodedResponse['generated_text'];
      // final utf8EncodedText = utf8.encode(generatedText);
      // final decodedText = utf8.decode(utf8EncodedText); // Decode UTF-8 bytes to string
      final ansiEncodedText = generatedText;

      // Convert ANSI-encoded text to a list of bytes
      final bytes = latin1.encode(ansiEncodedText);

      // Decode bytes from ANSI to UTF-8
      final utf8EncodedText = utf8.decode(bytes);
      print('Generated text (UTF-8): $utf8EncodedText');
      setState(() {
        controller.text = utf8EncodedText; // Update the text in the TextField
      });
      // You can handle the response here
      getText(); // Call getText() after successful response
    } else {
      print('Failed to send text. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error sending text: $error');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Text'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedLanguage1,
                      items: ['English', 'Lambani', 'Soliga', 'Kui', 'Mundri']
                          .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedLanguage1 = value!;
                        });
                      },
                      hint: const Text('Select Language 1'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, size: 36),
                    onPressed: () {
                      setState(() {
                        final temp = selectedLanguage1;
                        selectedLanguage1 = selectedLanguage2;
                        selectedLanguage2 = temp;
                      });
                    },
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedLanguage2,
                      items: ['Lambani', 'English', 'Soliga', 'Kui', 'Mundri']
                          .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedLanguage2 = value!;
                        });
                      },
                      hint: const Text('Select Language 2'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: TextField(
                        controller: controller,
                        maxLines: 4,
                        readOnly: true,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'Translated Text Appears here',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextField(
                        controller: userTextController,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'Your Text Appears Here',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final text1 = selectedLanguage1;
                    final text2 = selectedLanguage2;
                    final userText = userTextController.text;
                    sendDataToServer(text1, text2, userText);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Translate',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ImageGenerator extends StatefulWidget {
  const ImageGenerator({super.key});

  @override
  _ImageGeneratorState createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  final TextEditingController promptController = TextEditingController();
  String imageUrl = '';
  final apiUrl = Uri.parse('https://d3b8-103-232-241-226.ngrok-free.app/process_text/');

  void getImage() async {
    // Append a unique query parameter to the URL to force fetching a new image
    final newImageUrl = 'https://d3b8-103-232-241-226.ngrok-free.app/generated_image?timestamp=${DateTime.now().millisecondsSinceEpoch}';
    
    setState(() {
      imageUrl = newImageUrl;
    });
  }  

  Future<void> sendTextToServer(String text) async {
    try {
      var jsonData = {'text': text};
      var response = await http.post(
        apiUrl,
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('Text sent successfully!');
        print('Response: ${response.body}');
        // You can handle the response here
        getImage(); // Call getImage() after successful response
      } else {
        print('Failed to send text. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending text: $error');
    }
  }

  void generateImage(BuildContext context) {
    String promptText = promptController.text;
    // Call sendTextToServer to send the prompt text to the server
    sendTextToServer(promptText);
    // Add your logic to handle the response and update the UI accordingly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Generator'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Generated Image
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400, // Adjust the height based on your needs
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Placeholder color
                  borderRadius: BorderRadius.circular(10),
                ),
                // You can replace the child with the actual generated image widget
                child: Center(
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 400, // Set the width as per your requirement
                          height: 400, // Set the height as per your requirement
                        )
                      : Container(), // Placeholder widget when image URL is empty
                ),
              ),

              const SizedBox(height: 16),
              // Text Field for Prompt
              TextField(
                controller: promptController,
                maxLines: 2,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Enter Prompt',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Generate Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Call generateImage function when the button is pressed
                    generateImage(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Generate',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
