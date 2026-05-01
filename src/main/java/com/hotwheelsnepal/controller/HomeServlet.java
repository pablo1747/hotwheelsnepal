package com.hotwheelsnepal.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.hotwheelsnepal.model.ProductModel;
import com.hotwheelsnepal.service.ProductService;

@WebServlet(asyncSupported = true, urlPatterns = { "/Home" })
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ProductService productService = new ProductService();

    public HomeServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ProductModel> all = productService.getAllProducts();
        List<ProductModel> featured = all.size() > 5 ? all.subList(0, 5) : all;
        request.setAttribute("featuredProducts", featured);
        request.getRequestDispatcher("WEB-INF/pages/home.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
