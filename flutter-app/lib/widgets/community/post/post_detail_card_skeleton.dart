import 'package:flutter/material.dart';

class PostDetailSkeleton extends StatelessWidget {
  const PostDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 작성자 정보 Row
          Row(
            children: [
              // 프로필 이미지 스켈레톤
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // 작성자 정보 텍스트
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 닉네임
                  Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 시간 + 카테고리
                  Container(
                    width: 160,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          const SizedBox(height: 20),
          // 제목
          Container(
            width: double.infinity,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 12),

          // 본문 첫 줄
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 10),

          // 본문 첫 줄
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
