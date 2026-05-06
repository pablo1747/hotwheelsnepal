package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.service.ProductService;
import com.hotwheelsnepal.util.FileUploadUtil;
import com.hotwheelsnepal.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(asyncSupported = true, urlPatterns = { "/AddProduct" })
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 1024 * 1024 * 5,
    maxRequestSize    = 1024 * 1024 * 20
)
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AddProductServlet.class.getName());

    private static final String UPLOAD_SUBDIR = "images" + File.separator + "products";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/addproduct.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name        = ValidationUtil.param(request, "name");
        String description = ValidationUtil.param(request, "description");
        String priceStr    = ValidationUtil.param(request, "price");
        String stockStr    = ValidationUtil.param(request, "stock");
        String series      = ValidationUtil.param(request, "series");

        String imageName = null;
        try {
            Part imagePart = request.getPart("productImage");
            if (imagePart != null && imagePart.getSize() > 0) {
                if (!FileUploadUtil.isImage(imagePart)) {
                    request.setAttribute("error", "Product image must be a valid image file (jpg, png, etc.).");
                    repopulate(request, name, description, priceStr, stockStr, series);
                    request.getRequestDispatcher("/WEB-INF/pages/addproduct.jsp").forward(request, response);
                    return;
                }
                String ext      = FileUploadUtil.getFileExtension(imagePart.getSubmittedFileName());
                String fileName = System.currentTimeMillis() + ext;
                String uploadDir = getServletContext().getRealPath("/") + UPLOAD_SUBDIR;
                FileUploadUtil.saveFile(imagePart, uploadDir, fileName);
                imageName = fileName;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }

        try {
            new ProductService().addProduct(name, description, priceStr, stockStr, imageName, series);
            response.sendRedirect(request.getContextPath() + "/AdminProducts?success=added");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            repopulate(request, name, description, priceStr, stockStr, series);
            request.getRequestDispatcher("/WEB-INF/pages/addproduct.jsp").forward(request, response);
        }
    }

    private void repopulate(HttpServletRequest request, String name, String description,
                            String priceStr, String stockStr, String series) {
        request.setAttribute("valName",        name);
        request.setAttribute("valDescription", description);
        request.setAttribute("valPrice",       priceStr);
        request.setAttribute("valStock",       stockStr);
        request.setAttribute("valSeries",      series);
    }
}
