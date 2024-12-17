import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/dashboard.dart';
 // Update with the correct path

class CreateDealPage extends StatefulWidget {
  @override
  _CreateDealPageState createState() => _CreateDealPageState();
}

class _CreateDealPageState extends State<CreateDealPage> {
  final ImagePicker _picker = ImagePicker();
  String title = '';
  String description = '';
  double price = 0.0;
  String location = '';
  File? image;

  Future<void> createDeal() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final int? userIdInt = prefs.getInt('userId'); // Retrieve userId as an int

    if (token == null || userIdInt == null) {
      print('Token or userId is null. Redirecting to login.');
      return;
    }

    final String userId = userIdInt.toString(); // Convert userId to String

    final Map<String, dynamic> dealData = {
      'userID': userId,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
    };

    if (image != null) {
      Uint8List bytes = await image!.readAsBytes();
      var uploadResponse = await UploadApiImage().uploadImage(bytes, image!.path.split('/').last);
      if (uploadResponse != null) {
        dealData['image_path'] = uploadResponse['location'];
      } else {
        print('Failed to upload image');
        return;
      }
    }

    print('Token: $token');
    print('Deal Data: ${jsonEncode(dealData)}');

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/create/deals'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dealData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deal created successfully.')),
        );
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()), // Navigate to DashboardPage
        );
      } else {
        print('Failed to create deal. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Deal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) => description = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) => price = double.tryParse(value) ?? 0.0,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Location'),
              onChanged: (value) => location = value,
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    image = File(pickedFile.path);
                  });
                }
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createDeal,
              child: Text('Create Deal'),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadApiImage {
  Future<dynamic> uploadImage(Uint8List bytes, String fileName) async {
    Uri url = Uri.parse("https://api.escuelajs.co/api/v1/files/upload");
    var request = http.MultipartRequest("POST", url);
    var myFile = http.MultipartFile(
      "file",
      http.ByteStream.fromBytes(bytes),
      bytes.length,
      filename: fileName,
    );
    request.files.add(myFile);
    final response = await request.send();
    if (response.statusCode == 201) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      return null;
    }
  }
}









// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../screens/dashboard.dart';

// class CreateDealPage extends StatefulWidget {
//   @override
//   _CreateDealPageState createState() => _CreateDealPageState();
// }

// class _CreateDealPageState extends State<CreateDealPage> {
//   final ImagePicker _picker = ImagePicker();
//   String title = '';
//   String description = '';
//   double price = 0.0;
//   String location = '';
//   List<File> images = [];

//   Future<void> createDeal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('authToken');
//     final int? userIdInt = prefs.getInt('userId');

//     if (token == null || userIdInt == null) {
//       print('Token or userId is null. Redirecting to login.');
//       return;
//     }

//     final String userId = userIdInt.toString();

//     final Map<String, dynamic> dealData = {
//       'userID': userId,
//       'title': title,
//       'description': description,
//       'price': price,
//       'location': location,
//     };

//     List<http.MultipartFile> imageFiles = [];
//     for (var image in images) {
//       var stream = http.ByteStream(image.openRead());
//       var length = await image.length();
//       var multipartFile = http.MultipartFile(
//         'image_path', // Ensure this matches the Laravel request field
//         stream,
//         length,
//         filename: image.path.split('/').last,
//       );
//       imageFiles.add(multipartFile);
//     }

//     var uri = Uri.parse('http://10.0.2.2:8000/api/create/deals');
//     var request = http.MultipartRequest('POST', uri)
//       ..fields.addAll(dealData.map((key, value) => MapEntry(key, value.toString())))
//       ..files.addAll(imageFiles)
//       ..headers['Authorization'] = 'Bearer $token';

//     try {
//       var response = await request.send();

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Deal created successfully.')),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Dashboard()),
//         );
//       } else {
//         print('Failed to create deal. Status code: ${response.statusCode}');
//         response.stream.transform(utf8.decoder).listen((value) {
//           print('Response body: $value');
//         });
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Deal'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(labelText: 'Title'),
//               onChanged: (value) => title = value,
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Description'),
//               onChanged: (value) => description = value,
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Price'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) => price = double.tryParse(value) ?? 0.0,
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Location'),
//               onChanged: (value) => location = value,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final pickedFiles = await _picker.pickMultiImage();
//                 if (pickedFiles != null) {
//                   setState(() {
//                     images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
//                   });
//                 }
//               },
//               child: Text('Select Images'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: createDeal,
//               child: Text('Create Deal'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

