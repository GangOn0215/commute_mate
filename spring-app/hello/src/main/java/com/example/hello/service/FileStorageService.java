package com.example.hello.service;

import net.coobird.thumbnailator.Thumbnails;
import jakarta.servlet.http.HttpServletRequest;
import net.coobird.thumbnailator.geometry.Positions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Objects;
import java.util.UUID;

@Service
public class FileStorageService {
    private final Path fileStorageLocation;

    @Autowired
    private HttpServletRequest request;

    // 원본 압축
    private static final int ORIGINAL_MAX_WIDTH = 1920;
    private static final int ORIGINAL_MAX_HEIGHT = 1920;
    private static final double ORIGINAL_QUALITY = 0.85;

    // 프로필 이미지
    private static final int PROFILE_THUMB_SIZE = 200;
    private static final int PROFILE_SMALL_SIZE = 100;
    private static final double PROFILE_QUALITY = 0.8;

    // 게시물 이미지
    private static final int POST_THUMB_WIDTH = 400;
    private static final int POST_THUMB_HEIGHT = 400;
    private static final double POST_SMALL_SIZE = 0.8;

    public FileStorageService() {
        this.fileStorageLocation = Paths.get("uploads").
                toAbsolutePath().normalize();

        try {
            Files.createDirectories(this.fileStorageLocation);
        } catch (Exception e) {
            throw new RuntimeException("파일 저장 디렉토리 생성 실패", e);
        }
    }

    public String storeFile(MultipartFile file, String subDirectory) {
        try {
            BufferedImage bufferImage = ImageIO.read(file.getInputStream());

            String originalFilename = file.getOriginalFilename();
            String fileExtension = Objects.requireNonNull(originalFilename).substring(
                    originalFilename.lastIndexOf(".")
            );

            String newFilename = UUID.randomUUID().toString() + fileExtension;

            // 서브 디렉토리 생성
            Path targetLocation = this.fileStorageLocation.
                    resolve(subDirectory).
                    resolve(newFilename);

            Path targetThumbLocation = this.fileStorageLocation.
                    resolve(subDirectory).
                    resolve("thumb").
                    resolve(newFilename);

            try {
                Files.createDirectories(targetLocation.getParent());
                Files.createDirectories(targetThumbLocation.getParent());
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            String baseUrl = getBaseUrl();

            String defaultPath = targetLocation.toAbsolutePath().toString();
            String outputPath = targetThumbLocation.toAbsolutePath().toString();

            System.out.println(defaultPath);

            createThumbnail(bufferImage, outputPath, PROFILE_THUMB_SIZE, PROFILE_THUMB_SIZE, PROFILE_QUALITY);
            createThumbnail(bufferImage, defaultPath, ORIGINAL_MAX_WIDTH, ORIGINAL_MAX_HEIGHT, ORIGINAL_QUALITY);

            // 반환할 URL 경로
            return baseUrl + "/uploads/" + subDirectory + "/thumb/" + newFilename;

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private String getBaseUrl() {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();

        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);

        // 기본 포트가 아닌 경우만 포트 추가
        if ((scheme.equals("http") && serverPort != 80) ||
                (scheme.equals("https") && serverPort != 443)) {
            url.append(":").append(serverPort);
        }

        return url.toString();
    }

    public void deleteFile(String fileUrl) {
        try {
            // URL에서 파일 경로 추출
            String filename = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
            Path filePath = this.fileStorageLocation.resolve(filename).normalize();

            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            throw new RuntimeException("파일 삭제 실패", e);
        }
    }

    private void createThumbnail(BufferedImage image, String outputPath,
                                 int width, int height, double quality) throws IOException {

        File outputFile = new File(outputPath);
        outputFile.getParentFile().mkdirs();

        // 정사각형으로 크롭하려면
        Thumbnails.of(image)
                .size(width, height)
                .crop(Positions.CENTER)  // 중앙 크롭
                .outputQuality(quality)
                .toFile(outputFile);
    }
}
