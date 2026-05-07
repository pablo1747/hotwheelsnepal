package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(asyncSupported = true, urlPatterns = { "/DeleteProduct" })
public class DeleteProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            try {
                new ProductService().deleteProduct(productId);
                response.sendRedirect(request.getContextPath() + "/AdminProducts?success=deleted");
            } catch (IllegalArgumentException e) {
                response.sendRedirect(request.getContextPath() + "/AdminProducts?error=" + e.getMessage());
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/AdminProducts?error=Invalid+product+ID");
        }
    }
}
