// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart'; // Untuk mengambil gambar
import 'dart:io'; // Import untuk menggunakan File
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/provider/profileimgprovider.dart';
import 'package:smart_shop_app/service/auth/auth.dart';

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = AuthService().getCurrentUser();
    final profileImageAsyncValue = ref.watch(userProfileImageProvider);
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    XFile? _imageFile; // Menyimpan gambar profil

    // Fungsi untuk memilih gambar
    Future<void> _pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery); // Ambil gambar dari galeri
      if (pickedFile != null) {
        _imageFile = pickedFile; // Simpan gambar yang dipilih
      }
    }

    // Menampilkan popup untuk edit profile
    void _showEditProfileDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Profile'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Avatar Image Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      child: profileImageAsyncValue.when(
                        loading: () =>
                            const CircularProgressIndicator(), // Show a loading spinner
                        error: (error, stackTrace) => const Icon(
                          // Show an error icon if the image fetch fails
                          Icons.error,
                          size: 30,
                          color: Colors.grey,
                        ),
                        data: (profileImageUrl) {
                          // Show the profile image if available, otherwise fallback to default icon
                          return profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(profileImageUrl),
                                )
                              : const Icon(
                                  // Fallback to default icon if no image URL is found
                                  Icons.person_add_alt_1,
                                  size: 30,
                                  color: Colors.grey,
                                );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Name TextField
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 10),
                  // Email TextField
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                ],
              ),
            ),
            actions: [
              // Tombol Batal
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              // Tombol Simpan
              TextButton(
                onPressed: () {
                  // Simpan perubahan dan tutup dialog
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  color: AppColors.darkBackground,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Satoshi",
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bagian Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      child: profileImageAsyncValue.when(
                        loading: () =>
                            const CircularProgressIndicator(), // Show a loading spinner
                        error: (error, stackTrace) => const Icon(
                          // Show an error icon if the image fetch fails
                          Icons.error,
                          size: 30,
                          color: Colors.grey,
                        ),
                        data: (profileImageUrl) {
                          // Show the profile image if available, otherwise fallback to default icon
                          return profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(profileImageUrl),
                                )
                              : const Icon(
                                  // Fallback to default icon if no image URL is found
                                  Icons.person_add_alt_1,
                                  size: 30,
                                  color: Colors.grey,
                                );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // Nama Pengguna dari userMetadata
                    Text(
                      currentUser?.userMetadata?["display_name"] ?? '-',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Bagian Detail dan Tombol Edit dalam Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    // Hanya menampilkan InfoRow untuk nama
                    _buildInfoRow(Icons.person, 'Name',
                        currentUser?.userMetadata?["display_name"] ?? '-'),
                    SizedBox(height: 20),
                    _buildInfoRow(Icons.person, 'Email',
                        currentUser?.userMetadata?["email"] ?? '-'),
                    SizedBox(height: 20),
                    // Tombol Edit
                    ElevatedButton.icon(
                      onPressed: _showEditProfileDialog,
                      icon: Icon(Icons.edit),
                      label: Text(
                        'Edit Profile',
                        style: TextStyle(
                            color: AppColors.background, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          backgroundColor: AppColors.primary,
                          iconColor: AppColors.background),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.darkBackground),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBackground,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkBackground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
