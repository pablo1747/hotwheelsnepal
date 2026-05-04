package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.dao.ProductDAO;
import com.hotwheelsnepal.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(asyncSupported = true, urlPatterns = { "/AdminDashboard" })
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();

        int    totalUsers    = new UserDAO().getTotalUsers();
        int    totalProducts = productDAO.getTotalProducts();
        int    inStock       = productDAO.getInStockCount();
        int    outOfStock    = productDAO.getOutOfStockCount();
        double stockValue    = productDAO.getTotalStockValue();
        double avgPrice      = productDAO.getAveragePrice();
        int    maxStock      = productDAO.getMaxStock();

        request.setAttribute("totalUsers",         totalUsers);
        request.setAttribute("totalProducts",      totalProducts);
        request.setAttribute("inStock",            inStock);
        request.setAttribute("outOfStock",         outOfStock);
        request.setAttribute("totalStockValueFmt", String.format("Rs. %.0f", stockValue));
        request.setAttribute("avgPriceFmt",        String.format("Rs. %.0f", avgPrice));
        request.setAttribute("maxStock",           maxStock);

        try {
            request.setAttribute("allProducts", productDAO.getAllProducts());
        } catch (Exception e) {
            request.setAttribute("allProducts", java.util.Collections.emptyList());
        }

        request.getRequestDispatcher("/WEB-INF/pages/admindashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}