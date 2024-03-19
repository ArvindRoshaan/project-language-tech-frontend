import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> machineTranslateText(String source_lang, String target_lang, String source_sentence) async {
  try {
    var jsonData = {
      'text': source_sentence,
      'src': source_lang,
      'tgt': target_lang
    };
    var response = await http.post(
      Uri.parse('https://731d-103-232-241-226.ngrok-free.app/machine_translation/'),
      body: jsonEncode(jsonData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Text sent successfully!');
      print(source_sentence);
      print(source_lang);
      print(target_lang);
      final decodedResponse = jsonDecode(response.body);
      final generatedText = decodedResponse['generated_text'];

      // Convert ANSI-encoded text to a list of bytes and then decode bytes from ANSI to UTF-8
      final bytes = latin1.encode(generatedText);
      final utf8EncodedText = utf8.decode(bytes);

      print('Generated text (UTF-8): $utf8EncodedText');
      return utf8EncodedText; // Return the UTF-8 encoded text
    } else {
      print('Failed to send text. Status code: ${response.statusCode}');
      return null; // Return null if the response status code is not 200
    }
  } catch (error) {
    print('Error sending text: $error');
    return null; // Return null if an exception occurs
  }
}
