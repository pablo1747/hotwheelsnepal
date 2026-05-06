package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.dao.ProductDAO;
import com.hotwheelsnepal.model.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(asyncSupported = true, urlPatterns = { "/AdminProducts" })
public class AdminProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ProductDAO dao = new ProductDAO();
            List<ProductModel> products = dao.getAllProducts();
            request.setAttribute("products", products);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to load products.");
        }
        request.getRequestDispatcher("/WEB-INF/pages/adminproducts.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}