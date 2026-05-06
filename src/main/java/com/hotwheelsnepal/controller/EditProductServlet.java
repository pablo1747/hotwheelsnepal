package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.model.ProductModel;
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

@WebServlet(asyncSupported = true, urlPatterns = { "/EditProduct" })
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 1024 * 1024 * 5,
    maxRequestSize    = 1024 * 1024 * 20
)
public class EditProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(EditProductServlet.class.getName());

    private static final String UPLOAD_SUBDIR = "images" + File.separator + "products";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ProductService service = new ProductService();
            ProductModel product = service.getProductById(id);
            if (product == null) {
                request.setAttribute("error", "Product not found.");
            } else {
                request.setAttribute("product", product);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid product ID.");
        }
        request.getRequestDispatcher("/WEB-INF/pages/editproduct.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = -1;
        try {
            id = Integer.parseInt(request.getParameter("productId"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid product ID.");
            request.getRequestDispatcher("/WEB-INF/pages/editproduct.jsp").forward(request, response);
            return;
        }

        String name        = ValidationUtil.param(request, "name");
        String description = ValidationUtil.param(request, "description");
        String priceStr    = ValidationUtil.param(request, "price");
        String stockStr    = ValidationUtil.param(request, "stock");
        String series      = ValidationUtil.param(request, "series");

        // Handle optional image upload
        String imageName = null;
        try {
            Part imagePart = request.getPart("productImage");
            if (imagePart != null && imagePart.getSize() > 0) {
                if (!FileUploadUtil.isImage(imagePart)) {
                    ProductService svc = new ProductService();
                    request.setAttribute("product", svc.getProductById(id));
                    request.setAttribute("errImage", "Product image must be a valid image file (jpg, png, etc.).");
                    request.getRequestDispatcher("/WEB-INF/pages/editproduct.jsp").forward(request, response);
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
            new ProductService().updateProduct(id, name, description, priceStr, stockStr, series, imageName);
            response.sendRedirect(request.getContextPath() + "/AdminProducts?success=updated");
        } catch (IllegalArgumentException e) {
            ProductModel product = new ProductService().getProductById(id);
            request.setAttribute("product", product);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/editproduct.jsp").forward(request, response);
        }
    }
}
