import 'dart:io';
import 'dart:typed_data';

import 'package:commute_mate/provider/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountHeaderIcon extends StatefulWidget {
  const AccountHeaderIcon({super.key});

  @override
  State<AccountHeaderIcon> createState() => _AccountHeaderIconState();
}

class _AccountHeaderIconState extends State<AccountHeaderIcon> {
  XFile? _selectedImage;
  Uint8List? _webImage;
  bool _isUploading = false;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });

      // 웹인 경우 미리보기용 바이트 데이터 저장
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      }

      // 이미지 선택 후 자동 업로드
      await uploadImage();
    }
  }

  Future<void> uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이미지를 먼저 선택해주세요.')));
      return;
    }

    setState(() => _isUploading = true);

    try {
      final user = context.read<UserProvider>().user;

      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인이 필요합니다.')));
        return;
      }

      final dio = Dio();
      FormData formData;

      if (kIsWeb) {
        // WEB
        final bytes = await _selectedImage!.readAsBytes();
        formData = FormData.fromMap({
          'image': MultipartFile.fromBytes(
            bytes,
            filename: _selectedImage!.name,
          ),
        });
      } else {
        // Mobile
        formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            _selectedImage!.path,
            filename: 'profile.jpg',
          ),
        });
      }

      Response response = await dio.post(
        'http://localhost:8080/api/users/${user.id}/profile-image',
        data: formData,
        onSendProgress: (sent, total) {
          print('업로드 진행률: ${(sent / total * 100).toStringAsFixed(0)}%');
        },
      );

      if (response.statusCode == 200) {
        String imageUrl = response.data['fileUrl'];

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('프로필 이미지 업데이트 완료!')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('업로드 실패: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Container(
      // ✅ 최대 높이 제한
      constraints: BoxConstraints(
        maxHeight: 200, // 최대 높이 설정
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ 중요: 필요한 만큼만 공간 차지
        children: [
          Stack(
            children: [
              // 프로필 이미지
              InkWell(
                onTap: _isUploading ? null : pickImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: ClipOval(child: _getImageWidget(user)),
                ),
              ),

              // 업로드 중 표시
              if (_isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),

              // 카메라 아이콘
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // 사용자 이름
          Text(
            user?.name ?? '사용자',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // 이메일
          if (user?.email != null)
            Text(
              user!.email!,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  Widget _getImageWidget(user) {
    // 1. 로컬에서 선택한 이미지가 있으면 그것을 표시
    if (_selectedImage != null) {
      if (kIsWeb && _webImage != null) {
        return Image.memory(
          _webImage!,
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        );
      } else {
        return Image.file(
          File(_selectedImage!.path),
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        );
      }
    }

    // 2. 서버에 저장된 이미지가 있으면 표시
    if (user?.profileImageUrl != null) {
      return Image.network(
        user.profileImageUrl,
        fit: BoxFit.cover,
        width: 80,
        height: 80,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: 40, color: Colors.grey[400]);
        },
      );
    }

    // 3. 기본 아이콘
    return Icon(Icons.person, size: 40, color: Colors.grey[400]);
  }
}
