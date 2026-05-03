package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(asyncSupported = true, urlPatterns = { "/Cart" })
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        List<CartItem> cartList = (List<CartItem>) session.getAttribute("cart");
        if (cartList == null) {
            cartList = new ArrayList<>();
        }

        String removeId = request.getParameter("removeId");
        if (removeId != null) {
            final String idToRemove = removeId;
            cartList.removeIf(p -> p.getId().equals(idToRemove));
            session.setAttribute("cart", cartList);
        }

        request.setAttribute("cartItems", cartList);
        request.getRequestDispatcher("/WEB-INF/pages/cart.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        List<CartItem> cartList = (List<CartItem>) session.getAttribute("cart");
        if (cartList == null) {
            cartList = new ArrayList<>();
        }

        String id       = request.getParameter("id");
        String name     = request.getParameter("name");
        String priceStr = request.getParameter("price");

        if (id != null && name != null && priceStr != null) {
            double price = Double.parseDouble(priceStr);
            boolean found = false;
            for (CartItem existing : cartList) {
                if (existing.getId().equals(id)) {
                    existing.incrementQuantity();
                    found = true;
                    break;
                }
            }
            if (!found) {
                cartList.add(new CartItem(id, name, price));
            }
        }

        session.setAttribute("cart", cartList);
        response.sendRedirect(request.getContextPath() + "/Cart");
    }
}