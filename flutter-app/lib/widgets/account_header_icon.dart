import 'dart:io';
import 'dart:typed_data';

import 'package:commute_mate/models/user.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/services/user_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';

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

  Future<void> pickImageWithPhotoManager() async {
    if (kIsWeb) {
      await pickImage();
      return;
    }

    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    // 권한 상태에 따른 처리
    if (ps.isAuth) {
      // 권한이 있는 경우 - 갤러리 열기
      await _openGallery();
    } else if (ps.hasAccess) {
      // 제한된 접근 권한 (iOS 14+에서 일부 사진만 선택한 경우)
      await _openGallery();
    } else {
      // 권한이 거부된 경우
      await _handlePermissionDenied(ps);
    }
  }

  Future<void> _openGallery() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: false, // 모든 앨범 표시
    );

    if (albums.isEmpty) {
      _showSnackBar('사진이 없습니다.');
      return;
    }

    // limited 권한일 때 안내 표시
    final ps = await PhotoManager.requestPermissionExtend();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAlbumPicker(albums, ps),
    );
  }

  Widget _buildAlbumPicker(List<AssetPathEntity> albums, PermissionState ps) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '앨범 선택',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // limited 권한 안내
          if (ps == PermissionState.limited)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '일부 사진만 접근 가능합니다',
                      style: TextStyle(fontSize: 13, color: Colors.orange[900]),
                    ),
                  ),
                  TextButton(
                    onPressed: () => PhotoManager.presentLimited(),
                    child: Text('더 선택', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),

          Divider(height: 1),

          Expanded(
            child: ListView.builder(
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return FutureBuilder<int>(
                  future: album.assetCountAsync,
                  builder: (context, countSnapshot) {
                    final count = countSnapshot.data ?? 0;

                    return FutureBuilder<List<AssetEntity>>(
                      future: album.getAssetListRange(start: 0, end: 1),
                      builder: (context, assetSnapshot) {
                        final thumbnail = assetSnapshot.data?.firstOrNull;

                        return ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[300],
                            ),
                            child: thumbnail != null
                                ? FutureBuilder<Uint8List?>(
                                    future: thumbnail.thumbnailDataWithSize(
                                      ThumbnailSize(200, 200),
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                      return Icon(
                                        Icons.photo,
                                        color: Colors.grey,
                                      );
                                    },
                                  )
                                : Icon(Icons.photo, color: Colors.grey),
                          ),
                          title: Text(
                            album.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text('$count장'),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () async {
                            Navigator.pop(context);
                            await _openAlbumPhotos(album);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAlbumPhotos(AssetPathEntity album) async {
    final assets = await album.getAssetListPaged(page: 0, size: 1000);

    if (assets.isEmpty) {
      _showSnackBar('사진이 없습니다.');
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildGalleryPicker(assets, album.name),
    );
  }

  // 제한된 접근 안내 다이얼로그
  void _showLimitedAccessDialog(List<AssetEntity> assets) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('제한된 갤러리 접근'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재 ${assets.length}장의 사진만 접근 가능합니다.'),
            SizedBox(height: 12),
            Text(
              '모든 사진을 보려면 "모든 사진 접근 허용"을 선택해주세요.',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 현재 제한된 사진들로 갤러리 열기
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    _buildGalleryPicker(assets, "Recently Photo's"),
              );
            },
            child: Text('현재 사진만 보기'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // ✅ 추가 사진 선택 요청 (iOS)
              await PhotoManager.presentLimited();
            },
            child: Text(
              '더 많은 사진 선택',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePermissionDenied(PermissionState ps) async {
    if (ps == PermissionState.denied) {
      // 권한이 거부되었지만 다시 요청 가능
      _showSnackBar('갤러리 접근 권한이 필요합니다.');
    } else if (ps == PermissionState.limited) {
      // iOS에서 제한된 접근 (일부 사진만 선택)
      await _openGallery();
    } else {
      // 권한이 영구적으로 거부됨 - 설정으로 이동 안내
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('갤러리 권한 필요'),
          content: Text('프로필 사진을 변경하려면 갤러리 접근 권한이 필요합니다.\n설정에서 권한을 허용해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('설정으로 이동'),
            ),
          ],
        ),
      );

      if (result == true) {
        // 앱 설정 화면으로 이동
        await PhotoManager.openSetting();
      }
    }
  }

  Widget _buildGalleryPicker(List<AssetEntity> assets, String albumName) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        _openGallery(); // 앨범 목록으로 돌아가기
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          albumName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${assets.length}장',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(4),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                return GestureDetector(
                  onTap: () async {
                    // 선택한 이미지 처리
                    final file = await asset.file;
                    if (file != null) {
                      setState(() {
                        _selectedImage = XFile(file.path);
                      });
                      Navigator.pop(context);
                      await uploadImage();
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FutureBuilder<Uint8List?>(
                      future: asset.thumbnailDataWithSize(
                        ThumbnailSize(200, 200),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      }

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
    setState(() => _isLoading = true);

    if (_isDev) {
      _user = await _userService.getUserById(18);
    } else {
      _user = context.read<UserProvider>().user;
    }

    setState(() => _isLoading = false);
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
                    InkWell(
                      onTap: _isUploading ? null : pickImageWithPhotoManager,
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

                if (_user?.email != null)
                  Text(
                    _user!.email!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
    );
  }

  Widget _getImageWidget(user) {
    if (_selectedImage != null) {
      if (kIsWeb) {
        if (_webImage != null) {
          return Image.memory(
            _webImage!,
            fit: BoxFit.cover,
            width: 80,
            height: 80,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      } else {
        return Image.file(
          File(_selectedImage!.path),
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        );
      }
    }

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

    return Icon(Icons.person, size: 40, color: Colors.grey[400]);
  }
}
