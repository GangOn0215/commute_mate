import 'dart:io';
import 'dart:typed_data';

import 'package:commute_mate/models/user.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/services/user_service.dart';
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
  final UserService _userService = UserService();
  final bool _isDev = false;
  XFile? _selectedImage;
  Uint8List? _webImage;
  bool _isUploading = false;
  bool _isLoading = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    setUser();
  }

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
      _showSnackBar('이미지를 먼저 선택해주세요.');
      return;
    }

    User? user;

    if (_isDev) {
      user = await _userService.getUserById(18);
    } else {
      user = context.read<UserProvider>().user;
    }

    if (user == null) {
      _showSnackBar('로그인이 필요합니다.');
      return;
    }

    setState(() => _isUploading = true);

    try {
      final result = await _userService.uploadProfileImage(
        user.id!,
        _selectedImage!,
      );

      if (result['success'] == true && mounted) {
        final updatedUser = User(
          id: user.id,
          userId: user.userId,
          name: user.name,
          contact: user.contact,
          email: user.email,
          password: user.password,
          profileImageUrl: result['imageUrl'],
          createdAt: user.createdAt,
        );

        context.read<UserProvider>().setUser(updatedUser);
        _showSnackBar('프로필 이미지 업데이트 완료!');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('업로드 실패: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: 2)),
      );
    }
  }

  void setUser() async {
    _isLoading = true;
    if (_isDev) {
      _user = await _userService.getUserById(18);
    } else {
      _user = context.read<UserProvider>().user;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
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
                        child: ClipOval(child: _getImageWidget(_user)),
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
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
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
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // 이메일
                if (_user?.email != null)
                  Text(
                    _user!.email!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1, // 추가
                    overflow: TextOverflow.ellipsis, // 추가
                  ),
              ],
            ),
    );
  }

  Widget _getImageWidget(user) {
    // 1. 로컬에서 선택한 이미지가 있으면 그것을 표시
    if (_selectedImage != null) {
      if (kIsWeb) {
        // 웹: _webImage 사용 (반드시 체크)
        if (_webImage != null) {
          return Image.memory(
            _webImage!,
            fit: BoxFit.cover,
            width: 80,
            height: 80,
          );
        } else {
          // 웹인데 _webImage가 없으면 로딩 표시
          return Center(child: CircularProgressIndicator());
        }
      } else {
        // 모바일: Image.file 사용
        return Image.file(
          File(_selectedImage!.path),
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        );
      }
    }

    // 2. 서버에 저장된 이미지가 있으면 표시
    if (user?.profileImageUrl != null && user.profileImageUrl!.isNotEmpty) {
      return Image.network(
        user.profileImageUrl!,
        fit: BoxFit.cover,
        width: 80,
        height: 80,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('이미지 로드 에러: $error');
          return Icon(Icons.person, size: 40, color: Colors.grey[400]);
        },
      );
    }

    // 3. 기본 아이콘
    return Icon(Icons.person, size: 40, color: Colors.grey[400]);
  }
}
