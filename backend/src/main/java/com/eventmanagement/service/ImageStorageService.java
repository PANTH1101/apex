package com.eventmanagement.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Set;
import java.util.UUID;

/**
 * Handles local-filesystem image storage for event images.
 *
 * Files are saved to  <upload.dir>/events/<uuid>.<ext>
 * and served statically at  /uploads/events/<uuid>.<ext>
 *
 * The storage location is intentionally isolated here so a future
 * production deployment can swap in S3/Cloudinary without touching
 * EventService or EventController.
 */
@Service
public class ImageStorageService {

    /** Root directory for all uploads (configured in application.properties). */
    private final Path uploadRoot;

    /** Sub-directory for event images. */
    private final Path eventsDir;

    /** Maximum allowed file size in bytes (5 MB). */
    private static final long MAX_SIZE_BYTES = 5 * 1024 * 1024;

    /** MIME types accepted for event images. */
    private static final Set<String> ALLOWED_TYPES = Set.of(
            "image/jpeg",
            "image/jpg",
            "image/png",
            "image/webp"
    );

    public ImageStorageService(@Value("${app.upload.dir:uploads}") String uploadDir) {
        this.uploadRoot = Paths.get(uploadDir).toAbsolutePath().normalize();
        this.eventsDir  = uploadRoot.resolve("events");
        createDirectories();
    }

    private void createDirectories() {
        try {
            Files.createDirectories(eventsDir);
        } catch (IOException e) {
            throw new RuntimeException("Could not create upload directory: " + eventsDir, e);
        }
    }

    /**
     * Validate and store an uploaded image.
     *
     * @param file the multipart file
     * @return the relative URL path: /uploads/events/<uuid>.<ext>
     * @throws IllegalArgumentException if the file is empty, too large, or not an allowed type
     * @throws IOException              if storage fails
     */
    public String store(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Image file must not be empty");
        }

        // Size check
        if (file.getSize() > MAX_SIZE_BYTES) {
            throw new IllegalArgumentException(
                    "Image must not exceed 5 MB (received "
                    + (file.getSize() / (1024 * 1024)) + " MB)");
        }

        // Content-type check — validate declared MIME type
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_TYPES.contains(contentType.toLowerCase())) {
            throw new IllegalArgumentException(
                    "Unsupported image type '" + contentType
                    + "'. Allowed: JPEG, PNG, WEBP");
        }

        // Derive a safe extension from the content type (ignore client filename)
        String extension = switch (contentType.toLowerCase()) {
            case "image/png"  -> ".png";
            case "image/webp" -> ".webp";
            default           -> ".jpg"; // jpeg / jpg
        };

        String filename   = UUID.randomUUID() + extension;
        Path   targetPath = eventsDir.resolve(filename).normalize();

        // Path-traversal guard: ensure the resolved path is inside eventsDir
        if (!targetPath.startsWith(eventsDir)) {
            throw new IllegalArgumentException("Invalid file path");
        }

        try (InputStream in = file.getInputStream()) {
            Files.copy(in, targetPath, StandardCopyOption.REPLACE_EXISTING);
        }

        // Return the URL path that Spring will serve statically
        return "/uploads/events/" + filename;
    }

    /**
     * Delete a stored image given its URL path.
     * Silently succeeds if the file does not exist.
     * Never throws — a failed deletion must not abort an otherwise successful update.
     *
     * @param imageUrl the relative URL path returned by {@link #store}
     */
    public void delete(String imageUrl) {
        if (imageUrl == null || imageUrl.isBlank()) return;
        try {
            // Strip the leading "/uploads/" prefix to get the relative path
            String relative = imageUrl.startsWith("/uploads/")
                    ? imageUrl.substring("/uploads/".length())
                    : imageUrl;

            Path target = uploadRoot.resolve(relative).normalize();

            // Safety: only delete files inside the upload root
            if (!target.startsWith(uploadRoot)) return;

            Files.deleteIfExists(target);
        } catch (IOException e) {
            // Log but do not propagate — a failed cleanup must not fail the request
            System.err.println("[ImageStorageService] Could not delete image: " + imageUrl + " — " + e.getMessage());
        }
    }
}
