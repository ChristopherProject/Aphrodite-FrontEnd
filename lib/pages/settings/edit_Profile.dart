// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:aphrodite/utilitities/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatefulWidget {
  final Map<String, dynamic> userInformations;

  const ProfileEditPage({Key? key, required this.userInformations})
      : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController, _biographyController;
  late String avatarUrl;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userInformations['username']);
    if (widget.userInformations['biography'] == null ||
        widget.userInformations['biography'] == 'null') {
      _biographyController = TextEditingController(text: '');
    } else {
      _biographyController =
          TextEditingController(text: widget.userInformations['biography']);
    }
    avatarUrl = widget.userInformations['profile_pic'] ?? '';
  }

  ImageProvider _getAvatarImage() {
    if (avatarUrl.isNotEmpty) {
      if (avatarUrl.startsWith('http')) {
        return NetworkImage(avatarUrl);
      } else {
        return FileImage(File(avatarUrl));
      }
    } else {
      return const AssetImage(
          'assets/avatar.png'); // Provide a default avatar image
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      bool imageInstNull = await imageFile.exists();
      if (imageInstNull) {
        try {
          List<int> imageBytes = await imageFile.readAsBytes();
          setState(() {
            avatarUrl = pickedFile.path;
            print('Contenuto dell\'immagine in byte:\n$imageBytes');
          });
        } catch (e) {
          print('Errore durante la lettura del file: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundImage: _getAvatarImage(),
                    radius: 100,
                  ),
                  CupertinoButton(
                    onPressed: _pickImage,
                    padding: const EdgeInsets.all(12),
                    borderRadius: BorderRadius.circular(100.0),
                    color: Provider.of<AppTheme>(context)
                        .currentTheme
                        .appBarTheme
                        .backgroundColor,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.camera,
                          size: 32.0,
                          color: Color.fromARGB(255, 15, 5, 5),
                        ),
                        SizedBox(width: 0.6),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _biographyController,
                decoration: InputDecoration(
                  labelText: 'Biography',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final String newUsername = _nameController.text;
                  final String newBiography = _biographyController.text;

                  //success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile was updated'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200.0, 40.0),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
