import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> translateText(String sourceLang, String targetLang, String sourceSentence) async {
  try {
    var jsonData = {
      'text': sourceSentence,
      'src': sourceLang,
      'tgt': targetLang
    };
    var response = await http.post(
      Uri.parse('https://b95b-103-232-241-226.ngrok-free.app/translate_text/'), //dgx1 system
      //Uri.parse('https://c023-223-186-69-228.ngrok-free.app/translate_text/'), //wsl2 laptop
      body: jsonEncode(jsonData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Successfully got a response!');
      print('Source sentence: $sourceSentence');
      print('Source language: $sourceLang');
      print('Source language: $targetLang');
      final decodedResponse = jsonDecode(response.body);
      final translatedText = decodedResponse['translated_text'];

      // Convert ANSI-encoded text to a list of bytes and then decode bytes from ANSI to UTF-8
      final bytes = latin1.encode(translatedText);
      final utf8EncodedText = utf8.decode(bytes);

      print('Translated text (UTF-8): $utf8EncodedText');
      return utf8EncodedText; // Return the UTF-8 encoded text
    } else {
      print('Failed. Status code: ${response.statusCode}');
      return null; // Return null if the response status code is not 200
    }
  } catch (error) {
    print('Error sending text: $error');
    return null; // Return null if an exception occurs
  }
}
