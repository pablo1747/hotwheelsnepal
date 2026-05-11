package com.hotwheelsnepal.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = { "/Error" })
public class ErrorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handle(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handle(request, response);
    }

    private void handle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Jakarta EE sets these attributes when routing through <error-page>
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        String  message    = (String)  request.getAttribute("jakarta.servlet.error.message");
        Throwable throwable = (Throwable) request.getAttribute("jakarta.servlet.error.exception");

        request.setAttribute("errorStatusCode", statusCode != null ? statusCode : 500);
        request.setAttribute("errorMessage",    message);
        request.setAttribute("errorException",  throwable);

        request.getRequestDispatcher("/WEB-INF/pages/error.jsp").forward(request, response);
    }
}
