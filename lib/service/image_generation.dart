import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getImage() async {
  // Append a unique query parameter to the URL to force fetching a new image
  final newImageUrl = 'https://731d-103-232-241-226.ngrok-free.app/generated_image?timestamp=${DateTime.now().millisecondsSinceEpoch}';
  return newImageUrl;
}

Future<String?> generateImage(String text) async {
  try {
    var jsonData = {'text': text, 'src': text, 'tgt': text};
    var response = await http.post(
      Uri.parse('https://731d-103-232-241-226.ngrok-free.app/process_text/'),
      body: jsonEncode(jsonData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Text sent successfully!');
      print('Response: ${response.body}');
      // You can handle the response here
      String? newImageUrl = await getImage(); // Call getImage() after successful response
      return newImageUrl;
    } else {
      print('Failed to send text. Status code: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error sending text: $error');
    return null;
  }
}
