// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart'; // Untuk mengambil gambar
import 'dart:io'; // Import untuk menggunakan File
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/provider/profileimgprovider.dart';
import 'package:smart_shop_app/screens/category_screen.dart';
import 'package:smart_shop_app/service/auth/auth.dart';

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = AuthService().getCurrentUser();
    final profileImageAsyncValue = ref.watch(userProfileImageProvider);
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    XFile? _imageFile; // Menyimpan gambar profil


    // Menampilkan popup untuk edit profile
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        title: CustomAppBar(
          title: 'User Profile',
          onTap: () {
            Navigator.pop(context);
          },
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
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
                              backgroundImage: NetworkImage(profileImageUrl),
                            )
                          : HugeIcon(
                              icon: HugeIcons.strokeRoundedUser,
                              color: AppColors.grayText,
                              size: 30);
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height - 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      // Hanya menampilkan InfoRow untuk nama
                      _buildInfoRow(Icons.person, 'Name',
                          currentUser?.userMetadata?["display_name"] ?? '-'),
                      SizedBox(height: 20),
                      _buildInfoRow(Icons.person, 'Email',
                          currentUser?.userMetadata?["email"] ?? '-'),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: TextButton.icon(
                //     onPressed: _showEditProfileDialog,
                //     icon: HugeIcon(
                //       icon: HugeIcons.strokeRoundedPencilEdit02,
                //       color: AppColors.background,
                //     ),
                //     label: Text(
                //       'Edit Profile',
                //       style:
                //           TextStyle(color: AppColors.background, fontSize: 14),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //         padding: EdgeInsets.all(20),
                //         backgroundColor: AppColors.primary,
                //         iconColor: AppColors.background),
                //   ),
                // ),
              ],
            ),
          ),
        ],
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
