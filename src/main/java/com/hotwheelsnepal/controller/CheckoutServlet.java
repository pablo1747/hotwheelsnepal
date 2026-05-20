package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.dao.CouponDAO;
import com.hotwheelsnepal.dao.OrderDAO;
import com.hotwheelsnepal.model.CartItem;
import com.hotwheelsnepal.model.UserModel;
import com.hotwheelsnepal.service.ProductService;
import com.hotwheelsnepal.util.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(asyncSupported = true, urlPatterns = { "/Checkout" })
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        boolean loggedIn = session != null && session.getAttribute(Constants.SESSION_USERNAME) != null;

        if (!loggedIn) {
            // Save intent so LoginServlet can redirect back here after login
            request.getSession().setAttribute("redirectAfterLogin", "/Checkout");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");

        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Cart");
            return;
        }

        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/WEB-INF/pages/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        boolean loggedIn = session != null && session.getAttribute(Constants.SESSION_USERNAME) != null;

        if (!loggedIn) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String paymentMethod   = request.getParameter("paymentMethod");
        String deliveryName    = request.getParameter("deliveryName");
        String deliveryPhone   = request.getParameter("deliveryPhone");
        String deliveryAddress = request.getParameter("deliveryAddress");
        String deliveryCity    = request.getParameter("deliveryCity");
        String postalCode      = request.getParameter("postalCode");
        String couponCode      = request.getParameter("couponCode");

        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");

        // Compute order total
        double subtotal = 0;
        if (cartItems != null) {
            for (CartItem item : cartItems) subtotal += item.getSubtotal();
        }
        double shipping = subtotal >= 1000 ? 0 : 100;
        double vat      = subtotal * 13.0 / 100.0;

        // Validate promo code server-side (never trust client-only discount)
        double  discountAmount = 0;
        Integer couponId       = null;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            CouponDAO couponDAO = new CouponDAO();
            String[]  coupon    = couponDAO.validateCoupon(couponCode, subtotal);
            if (coupon != null) {
                discountAmount = CouponDAO.computeDiscount(coupon, subtotal);
                couponId       = Integer.parseInt(coupon[0]);
                couponDAO.incrementCouponUse(couponId);
            }
        }

        double grandTotal = subtotal - discountAmount + shipping + vat;

        // Generate a simple order reference
        String orderRef = "HWN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // Expose order details to the thank-you page
        request.setAttribute("orderRef",        orderRef);
        request.setAttribute("paymentMethod",   paymentMethod);
        request.setAttribute("cartItems",       cartItems);
        request.setAttribute("subtotal",        subtotal);
        request.setAttribute("discountAmount",  discountAmount);
        request.setAttribute("couponCode",      couponCode);
        request.setAttribute("shipping",        shipping);
        request.setAttribute("vat",             vat);
        request.setAttribute("grandTotal",      grandTotal);

        // Reduce stock for each purchased item (only for real DB product IDs)
        ProductService productService = new ProductService();
        if (cartItems != null) {
            for (CartItem item : cartItems) {
                try {
                    int productId = Integer.parseInt(item.getId());
                    productService.reduceStock(productId, item.getQuantity());
                } catch (NumberFormatException ignored) {
                    // Non-numeric ID (e.g. featured car "car001") — not a DB product, skip
                }
            }
        }

        // Persist order, line items and payment record to database
        UserModel loggedUser = (UserModel) session.getAttribute(Constants.SESSION_LOGGED_USER);
        if (loggedUser != null) {
            OrderDAO orderDAO = new OrderDAO();
            int orderId = orderDAO.saveOrder(
                    loggedUser.getUserId(), orderRef,
                    subtotal, discountAmount, shipping, vat, grandTotal, paymentMethod,
                    couponId,
                    deliveryName, deliveryPhone, deliveryAddress, deliveryCity, postalCode);
            if (orderId > 0) {
                if (cartItems != null) orderDAO.saveOrderItems(orderId, cartItems);
                orderDAO.savePayment(orderId, paymentMethod, grandTotal);
            }
        }

        // Clear the cart
        session.removeAttribute("cart");

        request.getRequestDispatcher("/WEB-INF/pages/thankyou.jsp").forward(request, response);
    }
}
