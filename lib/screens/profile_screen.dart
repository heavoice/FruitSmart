import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart'; // Untuk mengambil gambar
import 'dart:io'; // Import untuk menggunakan File

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController _emailController =
      TextEditingController(text: 'johndoe@example.com');
  XFile? _imageFile; // Menyimpan gambar profil

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // Ambil gambar dari galeri
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
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
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : AssetImage('assets/profile_picture.jpg')
                            as ImageProvider,
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
                setState(() {
                  // Simpan nama, email, dan gambar jika diperlukan
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(File(_imageFile!.path))
                          : AssetImage('assets/profile_picture.jpg')
                              as ImageProvider,
                    ),
                    SizedBox(height: 20),
                    // Nama Pengguna
                    Text(
                      _nameController.text,
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
                    // Bagian Detail
                    _buildInfoRow(Icons.person, 'Name', _nameController.text),
                    SizedBox(height: 15),
                    _buildInfoRow(Icons.email, 'Email', _emailController.text),
                    SizedBox(height: 15),
                    _buildInfoRow(
                        Icons.location_on, 'Location', 'Jakarta, Indonesia'),
                    SizedBox(height: 15),
                    _buildInfoRow(Icons.cake, 'Birthday', 'January 1, 1990'),
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
