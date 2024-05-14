import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:users/main.dart';

import '../data_handler/app_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _avatarImage;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;
  bool _isFetchingData = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final useRrefone = useRref.child(widget.userId);
    final snapshot = await useRrefone.get();

    if (snapshot.exists) {
      final userData = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _isFetchingData = false;
      });
    } else {
      print('Error fetching user data');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _avatarImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_avatarImage == null) return;

    final storage = firebase_storage.FirebaseStorage.instance;
    final reference =
    storage.ref().child('profile_images').child(widget.userId);

    try {
      await reference.putFile(_avatarImage!);
      final imageUrl = await reference.getDownloadURL();

      final useRrefone = useRref.child(widget.userId);
      await useRrefone.update({'profileImageUrl': imageUrl});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile image uploaded successfully!'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading profile image: $error'),
        ),
      );
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    final useRrefone = useRref.child(widget.userId);

    final updates = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    };

    try {
      await useRrefone.update(updates);
      await _uploadImageToFirebase();
      _toggleEditMode();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppData languageProvider = Provider.of<AppData>(context);
    var language = languageProvider.isEnglishSelected ;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: Text(language?'Profile':"መገለጫ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEditMode,
            color: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child:
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: _avatarImage != null
                      ? _avatarImage!.path.endsWith('.png') ||
                      _avatarImage!.path.endsWith('.jpg') ||
                      _avatarImage!.path.endsWith('.jpeg')
                      ? FileImage(_avatarImage!) as ImageProvider<Object> // Cast to ImageProvider<Object>
                      : NetworkImage(_avatarImage!.path) as ImageProvider<Object> // Cast to ImageProvider<Object>
                      : AssetImage('images/user_icon.png') as ImageProvider<Object>, // Cast to ImageProvider<Object>
                ),
              ),
            ),
            SizedBox(height: 20.0),
            buildTextFormField(
              controller: _nameController,
              label: language?'Name':"ስም",
              icon: Icons.person,
            ),
            SizedBox(height: 10.0),
            buildTextFormField(
              controller: _emailController,
              label: language?'Email':"ኢሜይል",
              icon: Icons.email,
            ),
            SizedBox(height: 10.0),
            buildTextFormField(
              controller: _phoneController,
              label: language?'Phone Number':"ስልክ ቁጥር",
              icon: Icons.phone,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isEditing ? _saveProfile : null,
              child: Text(language?'Save Profile':"መገለጫ አስቀምጥ"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.tealAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16.0),
        prefixIcon: _isEditing ? Icon(icon, color: Colors.black) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black!),
        ),
      ),
      style: TextStyle(fontSize: 16.0),
    );
  }
}


// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:users/main.dart';
//
// class ProfilePageH extends StatefulWidget {
//   const ProfilePageH({super.key,required this.userId});
//   final String userId; // User ID for Firebase access
//
//
//   @override
//   State<ProfilePageH> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePageH> {
//
//   File? _avatarImage; // Stores the picked image file
//   final _nameController = TextEditingController(); // Controller for name
//   final _emailController = TextEditingController(); // Controller for phone number
//   final _phoneController = TextEditingController(); // Controller for phone number
//   bool _isEditing = false; // Flag to indicate edit mode
//   bool _isfetchingData = true; // Flag to track data fetching status
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchUserData() async {
//     //final database = FirebaseDatabase.instance.reference();
//     //final userRef = database.child('users').child(widget.userId);
//
// final useRrefone=useRref.child(widget.userId);
//
//     final snapshot = await useRrefone.get();
// if (snapshot.exists) {
//   //final userData = snapshot.value;
//   final userData = snapshot.value as Map<dynamic, dynamic>?;
//
//   if (userData != null) {
//     // Now, you can access the data using dynamic keys
//     final name = userData['name'];
//     final email = userData['email'];
//     final phone = userData['phone'];
//
//     // Now you can proceed with your logic
//     setState(() {
//       _nameController.text = name ?? '';
//       _emailController.text = email ?? '';
//       _phoneController.text = phone ?? '';
//       _isfetchingData = false; // Data fetched, update state
//     });
//   } else {
//     // Handle potential errors (e.g., user not found)
//     print('Error fetching user data');
//   }
//   }}
//
//   Future<void> _pickImage() async {
//     final imagePicker = ImagePicker();
//     final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _avatarImage = File(pickedFile.path);
//       }
//     });
//   }
//
//   void _toggleEditMode() {
//     setState(() {
//       _isEditing = !_isEditing;
//     });
//   }
//
//   Future<void> _saveProfile() async {
//     //final database = FirebaseDatabase.instance.reference();
//    // final userRef = database.child('users').child(widget.userId);
//     final useRrefone=useRref.child(widget.userId);
//
//
//     final updates = {
//       'name': _nameController.text,
//       'email': _emailController.text,
//       'phone': _phoneController.text,
//     };
//
//     try {
//       await useRrefone.update(updates); // Update user data in Firebase
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Profile saved successfully!'),
//         ),
//       );
//
//       _toggleEditMode(); // Exit edit mode after saving
//     } catch (error) {
//       // Handle errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error saving profile: $error'),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Profile'),
//           actions: [
//             // Edit button that toggles edit mode
//             IconButton(
//               icon: Icon(_isEditing ? Icons.save : Icons.edit),
//               onPressed: _toggleEditMode,
//             ),
//           ],
//         ),
//         body: Center(
//         child: _isfetchingData
//         ? CircularProgressIndicator() // Show loading indicator
//         : Column(
//     children: <Widget>[
//     // Profile picture section
//       // ... previous code ...
//
//       // Profile picture section
//       GestureDetector(
//         onTap: _pickImage,
//         child: CircleAvatar(
//           radius: 50.0,
//           backgroundImage: _avatarImage != null
//               ? _avatarImage!.path.endsWith('.png') ||
//               _avatarImage!.path.endsWith('.jpg') ||
//               _avatarImage!.path.endsWith('.jpeg')
//               ? FileImage(_avatarImage!) as ImageProvider<Object> // Cast to ImageProvider<Object>
//               : NetworkImage(_avatarImage!.path) as ImageProvider<Object> // Cast to ImageProvider<Object>
//               : AssetImage('assets/images/default_avatar.png') as ImageProvider<Object>, // Cast to ImageProvider<Object>
//         ),
//       ),
//
//
//
//
//
//       SizedBox(height: 20.0),
//
//     // Name text field
//     TextField(
//     controller: _nameController,
//     enabled: _isEditing,
//       decoration: InputDecoration(
//         labelText: 'Name',
//       ),
//     ),
//       SizedBox(height: 10.0),
//
//       // Email text field
//       TextField(
//         controller: _emailController,
//         keyboardType: TextInputType.emailAddress,
//         enabled: _isEditing,
//         decoration: InputDecoration(
//           labelText: 'Email',
//         ),
//       ),
//       SizedBox(height: 10.0),
//
//       // Phone number text field
//       TextField(
//         controller: _phoneController,
//         keyboardType: TextInputType.phone,
//         enabled: _isEditing,
//         decoration: InputDecoration(
//           labelText: 'Phone Number',
//         ),
//       ),
//       SizedBox(height: 20.0),
//
//       // Save button (optional)
//       ElevatedButton(
//         onPressed: _isEditing
//             ? _saveProfile
//             : null, // Disable button when not in edit mode
//         child: Text('Save Profile'),
//       ),
//     ],
//         ),
//         ),
//     );
//   }
// }
