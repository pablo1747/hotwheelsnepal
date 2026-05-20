package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.dao.CouponDAO;
import com.hotwheelsnepal.util.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(asyncSupported = true, urlPatterns = { "/ApplyCoupon" })
public class ApplyCouponServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");
        PrintWriter out = response.getWriter();

        if (request.getSession(false) == null
                || request.getSession(false).getAttribute(Constants.SESSION_USERNAME) == null) {
            out.print("{\"valid\":false,\"message\":\"Not logged in\"}");
            return;
        }

        String code         = request.getParameter("code");
        String subtotalParam = request.getParameter("subtotal");

        if (code == null || code.trim().isEmpty() || subtotalParam == null) {
            out.print("{\"valid\":false,\"message\":\"Missing parameters\"}");
            return;
        }

        double subtotal;
        try { subtotal = Double.parseDouble(subtotalParam); }
        catch (NumberFormatException e) {
            out.print("{\"valid\":false,\"message\":\"Invalid subtotal\"}");
            return;
        }

        CouponDAO dao    = new CouponDAO();
        String[]  coupon = dao.validateCoupon(code, subtotal);

        if (coupon == null) {
            out.print("{\"valid\":false,\"message\":\"Invalid, expired, or inapplicable promo code\"}");
            return;
        }

        double discountAmount = CouponDAO.computeDiscount(coupon, subtotal);
        double value          = Double.parseDouble(coupon[2]);
        String msg = "percentage".equals(coupon[1])
                ? String.format("%.0f%% off applied — you save Rs. %.0f!", value, discountAmount)
                : String.format("Rs. %.0f discount applied!", discountAmount);

        out.printf("{\"valid\":true,\"couponId\":%s,\"discountAmount\":%.2f,\"message\":\"%s\"}",
                coupon[0], discountAmount, msg.replace("\"", "\\\""));
    }
}
