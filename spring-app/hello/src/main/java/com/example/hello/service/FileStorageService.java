package com.example.hello.service;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Objects;
import java.util.UUID;

@Service
public class FileStorageService {
    private final Path fileStorageLocation;
    @Autowired
    private HttpServletRequest request;

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
            String originalFilename = file.getOriginalFilename();
            String fileExtension = Objects.requireNonNull(originalFilename).substring(
                    originalFilename.lastIndexOf(".")
            );

            String newFilename = UUID.randomUUID().toString() + fileExtension;

            // 서브 디렉토리 생성
            Path targetLocation = this.fileStorageLocation.
                    resolve(subDirectory).
                    resolve(newFilename);

            try {
                Files.createDirectories(targetLocation.getParent());
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            Files.copy(file.getInputStream(), targetLocation,
                    StandardCopyOption.REPLACE_EXISTING);

            String baseUrl = getBaseUrl();
            // 반환할 URL 경로
            return  baseUrl + "/uploads/" + subDirectory + "/" + newFilename;

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
}
