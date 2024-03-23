import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getImage() async {
  // Append a unique query parameter to the URL to force fetching a new image
  final newImageUrl = 'https://b95b-103-232-241-226.ngrok-free.app/show_generated_image?timestamp=${DateTime.now().millisecondsSinceEpoch}'; //dgx1 system
  //final newImageUrl = 'https://c023-223-186-69-228.ngrok-free.app/show_generated_image?timestamp=${DateTime.now().millisecondsSinceEpoch}'; //wsl2 laptop
  return newImageUrl;
}

Future<String?> generateImage(String text, String lang) async {
  try {
    var jsonData = {'text': text, 'lang': lang};
    var response = await http.post(
      Uri.parse('https://b95b-103-232-241-226.ngrok-free.app/generate_image/'), //dgx1 system
      //Uri.parse('https://c023-223-186-69-228.ngrok-free.app/generate_image/'), //wsl2 laptop
      body: jsonEncode(jsonData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Successfully got a response!');
      //return response.body;
      String? newImageUrl = await getImage(); // Call getImage() after successful response
      return newImageUrl;
    } else {
      print('Failed. Status code: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error sending text: $error');
    return null;
  }
}
