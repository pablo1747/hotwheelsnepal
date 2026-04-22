package com.hotwheelsnepal.util;

import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * FileUploadUtil provides helper methods for handling profile image file
 * uploads in the HotWheels Nepal application.
 */
public class FileUploadUtil {

    /**
     * Extracts the file extension from a filename (e.g., "photo.jpg" -> ".jpg").
     *
     * @param fileName the original file name
     * @return the file extension including the dot, or empty string if none
     */
    public static String getFileExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) return "";
        return fileName.substring(fileName.lastIndexOf("."));
    }

    /**
     * Validates whether the uploaded part is an image by checking its MIME type.
     *
     * @param part the uploaded file part
     * @return true if the content type starts with "image/", false otherwise
     */
    public static boolean isImage(Part part) {
        String contentType = part.getContentType();
        return contentType != null && contentType.startsWith("image/");
    }

    /**
     * Builds a safe file name using a unique identifier plus the file extension.
     *
     * @param identifier the unique name (e.g., username)
     * @param extension  the file extension (e.g., ".jpg")
     * @return the combined file name
     */
    public static String buildFileName(String identifier, String extension) {
        return identifier + extension;
    }

    /**
     * Saves the uploaded file to the specified directory on disk.
     * Creates the directory if it does not already exist.
     *
     * @param part      the uploaded file part
     * @param uploadDir the target directory path (absolute)
     * @param fileName  the name to save the file as
     * @throws IOException if the file save fails
     */
    public static void saveFile(Part part, String uploadDir, String fileName) throws IOException {
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        Path filePath = uploadPath.resolve(fileName);
        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
    }
}
