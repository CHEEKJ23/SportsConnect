// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class EditDealPage extends StatefulWidget {
//   final int dealID;
//   final Map<String, dynamic> initialData;

//   EditDealPage({required this.dealID, required this.initialData});

//   @override
//   _EditDealPageState createState() => _EditDealPageState();
// }

// class _EditDealPageState extends State<EditDealPage> {
//   final _formKey = GlobalKey<FormState>();
//   late String title;
//   late String description;
//   late double price;
//   late String location;
//   String? imagePath;
// @override
// void initState() {
//   super.initState();
//   title = widget.initialData['title'] ?? '';
//   description = widget.initialData['description'] ?? '';
//   price = double.tryParse(widget.initialData['price'].toString()) ?? 0.0; // Convert to double
//   location = widget.initialData['location'] ?? '';
//   imagePath = widget.initialData['image_path'];
// }

//   Future<void> editDeal() async {
//     if (!_formKey.currentState!.validate()) return;

//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('authToken');

//     if (token == null) {
//       print('Token is null. Redirecting to login.');
//       return;
//     }

//     final Map<String, dynamic> dealData = {
//       'title': title,
//       'description': description,
//       'price': price,
//       'location': location,
//       // 'image_path': imagePath, // Handle image upload separately if needed
//     };

//     try {
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:8000/api/edit/deals/${widget.dealID}'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(dealData),
//       );

//       if (response.statusCode == 200) {
//         print('Deal updated successfully.');
//         Navigator.pop(context, true); // Return to previous screen with success
//       } else {
//         print('Failed to update deal. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Deal'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 initialValue: title,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 onChanged: (value) => title = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 initialValue: description,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 onChanged: (value) => description = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 initialValue: price.toString(),
//                 decoration: InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => price = double.tryParse(value) ?? 0.0,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a price';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 initialValue: location,
//                 decoration: InputDecoration(labelText: 'Location'),
//                 onChanged: (value) => location = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a location';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: editDeal,
//                 child: Text('Update Deal'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class EditDealPage extends StatefulWidget {
  final int dealID;
  final Map<String, dynamic> initialData;

  EditDealPage({required this.dealID, required this.initialData});

  @override
  _EditDealPageState createState() => _EditDealPageState();
}

class _EditDealPageState extends State<EditDealPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late double price;
  late String location;
  String? imagePath;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    title = widget.initialData['title'] ?? '';
    description = widget.initialData['description'] ?? '';
    price = double.tryParse(widget.initialData['price'].toString()) ?? 0.0;
    location = widget.initialData['location'] ?? '';
    imagePath = widget.initialData['image_path'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> editDeal() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    // final int? userIdInt = prefs.getInt('userId'); // Retrieve userId as an int
    // final String userId = userIdInt.toString(); // Convert userId to String

    if (token == null) {
      print('Token is null. Redirecting to login.');
      return;
    }

    final Map<String, dynamic> dealData = {
      // 'userID': userId,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
    };

    if (_imageFile != null) {
      // Convert the image file to bytes
      Uint8List bytes = await _imageFile!.readAsBytes();
      // Upload the image and get the URL
      final imageUrl = await UploadApiImage().uploadImage(bytes, _imageFile!.path.split('/').last);
      if (imageUrl != null) {
        dealData['image_path'] = imageUrl['location']; // Assuming 'location' is the key for the URL
      }
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/edit/deals/${widget.dealID}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dealData),
      );

      if (response.statusCode == 200) {
        print('Deal updated successfully.');
        Navigator.pop(context, true); // Return to previous screen with success
      } else {
        print('Failed to update deal. Status code: ${response.statusCode}');
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
        title: Text('Edit Deal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: location,
                decoration: InputDecoration(labelText: 'Location'),
                onChanged: (value) => location = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(_imageFile!)
                  : imagePath != null
                      ? Image.network(imagePath!)
                      : Container(),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Edit Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: editDeal,
                child: Text('Update Deal'),
              ),
            ],
          ),
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