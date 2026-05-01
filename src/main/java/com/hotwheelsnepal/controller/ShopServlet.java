package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.model.ProductModel;
import com.hotwheelsnepal.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;

@WebServlet(asyncSupported = true, urlPatterns = { "/Shop" })
public class ShopServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductService productService = new ProductService();
        String q    = request.getParameter("q");
        String sort = request.getParameter("sort");

        List<ProductModel> products;
        if (q != null && !q.trim().isEmpty()) {
            products = productService.searchProducts(q.trim());
            request.setAttribute("searchQuery", q.trim());
        } else {
            products = productService.getAllProducts();
        }

        if ("price_asc".equals(sort)) {
            products = products.stream()
                    .sorted(Comparator.comparingDouble(ProductModel::getPrice))
                    .collect(java.util.stream.Collectors.toList());
        } else if ("price_desc".equals(sort)) {
            products = products.stream()
                    .sorted(Comparator.comparingDouble(ProductModel::getPrice).reversed())
                    .collect(java.util.stream.Collectors.toList());
        }

        request.setAttribute("products", products);
        request.setAttribute("sortOrder", sort != null ? sort : "");
        request.getRequestDispatcher("/WEB-INF/pages/shop.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
