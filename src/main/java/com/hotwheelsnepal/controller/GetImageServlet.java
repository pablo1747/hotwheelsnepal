package com.hotwheelsnepal.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

/**
 * Serves user profile images stored outside the web root.
 * Images are saved to ~/hotwheels_uploads/<username>.<ext> by the
 * profile-upload flow. This servlet reads the file from the filesystem
 * and writes it directly to the response output stream.
 *
 * Ported from workshop (java_web_app / GetImageServlet) and adapted
 * for HotWheels Nepal's upload directory and URL pattern.
 *
 * Usage: <img src="${pageContext.request.contextPath}/getimage?name=johndoe">
 */
@WebServlet("/getimage")
public class GetImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR =
            System.getProperty("user.home") + File.separator + "hotwheels_uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");

        if (name == null || name.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing name parameter");
            return;
        }

        File folder = new File(UPLOAD_DIR);
        if (!folder.exists() || !folder.isDirectory()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Upload directory not found");
            return;
        }

        String safeName = name.trim().replaceAll("[^a-zA-Z0-9_\\-]", "");
        File[] matches = folder.listFiles((dir, fileName) -> fileName.startsWith(safeName + "."));

        if (matches != null && matches.length > 0) {
            File imageFile = matches[0];
            String contentType = getServletContext().getMimeType(imageFile.getName());
            if (contentType == null) contentType = "image/jpeg";

            response.setContentType(contentType);
            response.setContentLength((int) imageFile.length());
            Files.copy(imageFile.toPath(), response.getOutputStream());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found for: " + name);
        }
    }
}
