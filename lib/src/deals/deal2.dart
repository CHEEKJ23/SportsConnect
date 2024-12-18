import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/dashboard.dart';

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
    final int? userIdInt = prefs.getInt('userId');

    if (token == null || userIdInt == null) {
      print('Token or userId is null. Redirecting to login.');
      return;
    }

    final String userId = userIdInt.toString();

    // Upload image first
    String? imagePath;
    if (image != null) {
      imagePath = await _uploadImage(image!);
      if (imagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image.')),
        );
        return;
      }
    }

    final Map<String, dynamic> dealData = {
      'userID': userId,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'image': imagePath,
    };

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
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        print('Failed to create deal. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/api/upload-image'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      var response = await request.send();

      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);
        return data['file_path']; // Assuming the API returns the file path
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
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

