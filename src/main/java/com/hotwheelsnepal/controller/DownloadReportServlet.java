package com.hotwheelsnepal.controller;

import com.hotwheelsnepal.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.List;
import java.util.Locale;

@WebServlet(asyncSupported = true, urlPatterns = { "/DownloadReport" })
public class DownloadReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate today     = LocalDate.now();
        int    year         = today.getYear();
        int    month        = today.getMonthValue();
        String monthName    = today.getMonth().getDisplayName(TextStyle.FULL, Locale.ENGLISH);
        String adminName    = (String) request.getSession().getAttribute("username");
        String generatedOn  = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("dd MMMM yyyy, hh:mm a"));

        OrderDAO dao = new OrderDAO();
        int            orderCount  = dao.getMonthlyOrderCount(year, month);
        double[]       summary     = dao.getMonthlySummary(year, month);
        int            itemsSold   = dao.getMonthlyItemsSold(year, month);
        List<String[]> statuses    = dao.getMonthlyStatusBreakdown(year, month);
        List<String[]> payments    = dao.getMonthlyPaymentBreakdown(year, month);
        List<String[]> products    = dao.getMonthlyTopProducts(year, month);
        List<String[]> orders      = dao.getMonthlyOrders(year, month);
        List<String[]> coupons     = dao.getMonthlyCouponUsage(year, month);

        double revenue   = summary[0];
        double subtotal  = summary[1];
        double discounts = summary[2];
        double shipping  = summary[3];
        double vat       = summary[4];
        double netSales  = subtotal - discounts;
        double avgOrder  = orderCount > 0 ? revenue / orderCount : 0;

        String fileName = "HotWheelsNepal_Sales_Report_" + monthName + "_" + year + ".html";
        response.setContentType("text/html; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        PrintWriter out = response.getWriter();
        out.println(buildReport(year, monthName, generatedOn, adminName,
                orderCount, revenue, subtotal, netSales, discounts, shipping, vat, avgOrder, itemsSold,
                statuses, payments, products, orders, coupons));
        out.flush();
    }

    private String buildReport(
            int year, String monthName, String generatedOn, String adminName,
            int orderCount, double revenue, double subtotal, double netSales,
            double discounts, double shipping, double vat, double avgOrder, int itemsSold,
            List<String[]> statuses, List<String[]> payments,
            List<String[]> products, List<String[]> orders, List<String[]> coupons) {

        StringBuilder sb = new StringBuilder(16384);

        // ── HTML head + styles ────────────────────────────────────────────────
        sb.append("<!DOCTYPE html><html lang=\"en\"><head>")
          .append("<meta charset=\"UTF-8\">")
          .append("<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">")
          .append("<title>HotWheels Nepal – Sales Report ").append(monthName).append(" ").append(year).append("</title>")
          .append("<style>")
          .append("*{box-sizing:border-box;margin:0;padding:0}")
          .append("body{font-family:Arial,sans-serif;background:#f0f0f0;color:#1a1a1a;padding:30px;font-size:14px}")
          .append(".page{max-width:1200px;margin:0 auto;background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,.13)}")

          // header
          .append(".rpt-header{background:linear-gradient(135deg,#7a0000,#cc0000);color:#fff;padding:36px 44px}")
          .append(".rpt-header h1{font-size:28px;letter-spacing:3px;text-transform:uppercase;margin-bottom:4px}")
          .append(".rpt-header .sub{font-size:16px;opacity:.88;margin-top:8px}")
          .append(".rpt-header .meta{display:flex;flex-wrap:wrap;gap:28px;margin-top:20px;font-size:12px;opacity:.82}")
          .append(".rpt-header .meta b{opacity:1}")

          // tip bar
          .append(".tip{background:#fff8e1;border-bottom:1px solid #ffe082;color:#7a5c00;font-size:12px;padding:9px 44px;text-align:center}")

          // body
          .append(".body{padding:32px 44px}")
          .append(".section{margin-bottom:38px}")
          .append(".sec-title{font-size:12px;font-weight:bold;text-transform:uppercase;letter-spacing:1.4px;"
                + "color:#8b0000;border-bottom:2px solid #cc0000;padding-bottom:8px;margin-bottom:18px}")

          // summary cards
          .append(".cards{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:12px}")
          .append(".cards-3{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}")
          .append(".card{background:#fafafa;border:1px solid #e4e4e4;border-radius:8px;padding:16px 12px;text-align:center}")
          .append(".card .lbl{font-size:10px;text-transform:uppercase;letter-spacing:.8px;color:#999;margin-bottom:7px}")
          .append(".card .val{font-size:20px;font-weight:bold;color:#8b0000;word-break:break-all}")
          .append(".card .val.green{color:#2e7d32}")
          .append(".card .val.blue{color:#1565c0}")
          .append(".card .val.orange{color:#e65100}")
          .append(".card .val.purple{color:#6a1b9a}")

          // revenue breakdown
          .append(".rev-table{width:100%;border-collapse:collapse;margin-top:4px}")
          .append(".rev-table td{padding:9px 14px;font-size:13px;border-bottom:1px solid #f0f0f0}")
          .append(".rev-table tr:last-child td{border-bottom:none}")
          .append(".rev-table .label{color:#555;width:60%}")
          .append(".rev-table .amount{text-align:right;font-weight:bold}")
          .append(".rev-table .total-row td{background:#8b0000;color:#fff;font-size:15px;font-weight:bold;border-radius:0}")
          .append(".rev-table .total-row .amount{text-align:right}")
          .append(".rev-table .minus{color:#c62828}")
          .append(".rev-table .plus{color:#2e7d32}")

          // tables
          .append("table{width:100%;border-collapse:collapse}")
          .append("th{background:#f5f5f5;padding:10px 12px;text-align:left;font-size:10px;"
                + "text-transform:uppercase;letter-spacing:.6px;color:#666;border-bottom:2px solid #ddd;white-space:nowrap}")
          .append("td{padding:9px 12px;font-size:12.5px;border-bottom:1px solid #f0f0f0;vertical-align:middle}")
          .append("tbody tr:last-child td{border-bottom:none}")
          .append("tbody tr:hover{background:#fafafa}")
          .append(".amt{color:#8b0000;font-weight:bold;white-space:nowrap}")
          .append(".dim{color:#aaa;font-size:11px}")
          .append(".rank{font-weight:bold;color:#ccc;font-size:12px;width:30px}")

          // status badges
          .append(".badge{display:inline-block;padding:2px 9px;border-radius:10px;font-size:10px;font-weight:bold;text-transform:uppercase;white-space:nowrap}")
          .append(".s-pending{background:#fff8e1;color:#e65100;border:1px solid #ffe082}")
          .append(".s-confirmed{background:#e3f2fd;color:#1565c0;border:1px solid #90caf9}")
          .append(".s-shipped{background:#f3e5f5;color:#6a1b9a;border:1px solid #ce93d8}")
          .append(".s-delivered{background:#e8f5e9;color:#2e7d32;border:1px solid #a5d6a7}")
          .append(".s-cancelled{background:#ffebee;color:#c62828;border:1px solid #ef9a9a}")

          .append(".empty{text-align:center;padding:28px;color:#bbb;font-style:italic;font-size:13px}")

          // footer
          .append(".footer{text-align:center;padding:18px 44px;background:#fafafa;border-top:1px solid #ebebeb;"
                + "color:#bbb;font-size:11px}")

          .append("@media print{body{background:#fff;padding:0}.page{box-shadow:none;border-radius:0}.tip{display:none}}")
          .append("</style></head><body><div class=\"page\">");

        // ── Report header ──────────────────────────────────────────────────────
        sb.append("<div class=\"rpt-header\">")
          .append("<h1>HotWheels Nepal</h1>")
          .append("<div class=\"sub\">Monthly Sales Report &mdash; ").append(monthName).append(" ").append(year).append("</div>")
          .append("<div class=\"meta\">")
          .append("<span><b>Generated On:</b> ").append(esc(generatedOn)).append("</span>")
          .append("<span><b>Prepared By:</b> ").append(esc(adminName != null ? adminName : "Admin")).append("</span>")
          .append("<span><b>Report Period:</b> 1 ").append(monthName).append(" &ndash; 31 ").append(monthName).append(" ").append(year).append("</span>")
          .append("<span><b>Total Orders:</b> ").append(orderCount).append("</span>")
          .append("</div></div>");

        sb.append("<div class=\"tip\">To save as PDF: open this file in your browser &rarr; press <b>Ctrl+P</b> &rarr; choose <b>Save as PDF</b></div>");
        sb.append("<div class=\"body\">");

        // ── 1. Key Performance Summary ─────────────────────────────────────────
        sb.append("<div class=\"section\">")
          .append("<div class=\"sec-title\">Key Performance Summary</div>")
          .append("<div class=\"cards\">")
          .append(card("Total Orders",     String.valueOf(orderCount), ""))
          .append(card("Total Revenue",    "Rs. " + fmt(revenue),     ""))
          .append(card("Items Sold",       String.valueOf(itemsSold),  "green"))
          .append(card("Avg Order Value",  "Rs. " + fmt(avgOrder),    "blue"))
          .append("</div>")
          .append("<div class=\"cards-3\" style=\"margin-top:12px\">")
          .append(card("Discounts Given",     "Rs. " + fmt(discounts), "orange"))
          .append(card("Shipping Collected",  "Rs. " + fmt(shipping),  "purple"))
          .append(card("VAT Collected",       "Rs. " + fmt(vat),       "blue"))
          .append("</div>")
          .append("</div>");

        // ── 2. Revenue Breakdown ───────────────────────────────────────────────
        sb.append("<div class=\"section\">")
          .append("<div class=\"sec-title\">Revenue Breakdown</div>")
          .append("<table class=\"rev-table\"><tbody>")
          .append(revRow("Gross Sales (product subtotals)",     "Rs. " + fmt(subtotal),  "plus"))
          .append(revRow("Promo / Coupon Discounts Applied",    "&minus; Rs. " + fmt(discounts), "minus"))
          .append(revRow("Net Product Sales",                   "Rs. " + fmt(netSales),  ""))
          .append(revRow("Shipping Charges Collected",          "+ Rs. " + fmt(shipping), "plus"))
          .append(revRow("VAT Collected",                       "+ Rs. " + fmt(vat),      "plus"))
          .append("<tr class=\"total-row\"><td class=\"label\">TOTAL REVENUE COLLECTED</td>")
          .append("<td class=\"amount\">Rs. ").append(fmt(revenue)).append("</td></tr>")
          .append("</tbody></table>")
          .append("</div>");

        // ── 3. Order Status Breakdown ─────────────────────────────────────────
        sb.append("<div class=\"section\">")
          .append("<div class=\"sec-title\">Order Status Breakdown</div>");
        if (statuses.isEmpty()) {
            sb.append("<p class=\"empty\">No orders this month.</p>");
        } else {
            sb.append("<table><thead><tr>")
              .append("<th>Status</th><th>Orders</th><th>Share %</th>")
              .append("</tr></thead><tbody>");
            for (String[] r : statuses) {
                int cnt = Integer.parseInt(r[1]);
                double pct = orderCount > 0 ? cnt * 100.0 / orderCount : 0;
                sb.append("<tr>")
                  .append("<td><span class=\"badge ").append(sClass(r[0])).append("\">").append(esc(r[0])).append("</span></td>")
                  .append("<td>").append(cnt).append("</td>")
                  .append("<td>").append(String.format("%.1f", pct)).append("%</td>")
                  .append("</tr>");
            }
            sb.append("</tbody></table>");
        }
        sb.append("</div>");

        // ── 4. Payment Methods ────────────────────────────────────────────────
        sb.append("<div class=\"section\">")
          .append("<div class=\"sec-title\">Payment Methods</div>");
        if (payments.isEmpty()) {
            sb.append("<p class=\"empty\">No payment data this month.</p>");
        } else {
            sb.append("<table><thead><tr>")
              .append("<th>Payment Method</th><th>Orders</th><th>Revenue Collected</th><th>Share %</th>")
              .append("</tr></thead><tbody>");
            for (String[] r : payments) {
                int cnt = Integer.parseInt(r[1]);
                double pct = orderCount > 0 ? cnt * 100.0 / orderCount : 0;
                sb.append("<tr>")
                  .append("<td>").append(esc(r[0])).append("</td>")
                  .append("<td>").append(cnt).append("</td>")
                  .append("<td class=\"amt\">Rs. ").append(esc(r[2])).append("</td>")
                  .append("<td>").append(String.format("%.1f", pct)).append("%</td>")
                  .append("</tr>");
            }
            sb.append("</tbody></table>");
        }
        sb.append("</div>");

        // ── 5. Promo Code / Coupon Usage ──────────────────────────────────────
        sb.append("<div class=\"section\">")
          .append("<div class=\"sec-title\">Promo Code Usage This Month</div>");
        if (coupons.isEmpty()) {
            sb.append("<p class=\"empty\">No promo codes were used this month.</p>");
        } else {
            sb.append("<table><thead><tr>")
              .append("<th>Promo Code</th><th>Times Used</th><th>Total Discount Given</th>")
              .append("</tr></thead><tbody>");
            for (String[] r : coupons) {
                sb.append("<tr>")
                  .append("<td><b>").append(esc(r[0])).append("</b></td>")
                  .append("<td>").append(esc(r[1])).append(" orders</td>")
                  .append("<td class=\"amt\" style=\"color:#e65100\">- Rs. ").append(esc(r[2])).append("</td>")
                  .append("</tr>");
            }
            sb.append("</tbody></table>");
        }
        sb.append("</div>");

        // ── 6. Top Selling Products ───────────────────────────────────────────
        sb.append("<div class=\"section\">")
          .append("<div class=\"sec-title\">Top Selling Products</div>");
        if (products.isEmpty()) {
            sb.append("<p class=\"empty\">No product sales this month.</p>");
        } else {
            sb.append("<table><thead><tr>")
              .append("<th>#</th><th>Product Name</th><th>Units Sold</th><th>Revenue Generated</th>")
              .append("</tr></thead><tbody>");
            int rank = 1;
            for (String[] r : products) {
                sb.append("<tr>")
                  .append("<td class=\"rank\">").append(rank++).append("</td>")
                  .append("<td>").append(esc(r[0])).append("</td>")
                  .append("<td>").append(esc(r[1])).append(" units</td>")
                  .append("<td class=\"amt\">Rs. ").append(esc(r[2])).append("</td>")
                  .append("</tr>");
            }
            sb.append("</tbody></table>");
        }
        sb.append("</div>");

        // ── 7. Full Order Details ─────────────────────────────────────────────
        // row: [ref(0), date(1), name(2), email(3), city(4), method(5), status(6),
        //       subtotal(7), discount(8), shipping(9), vat(10), grand_total(11)]
        sb.append("<div class=\"section\">")
          .append("<div class=\"sec-title\">Full Order Details — ").append(orderCount).append(" Order(s)</div>");
        if (orders.isEmpty()) {
            sb.append("<p class=\"empty\">No orders placed this month.</p>");
        } else {
            sb.append("<table><thead><tr>")
              .append("<th>Order Ref</th>")
              .append("<th>Date &amp; Time</th>")
              .append("<th>Customer</th>")
              .append("<th>Email</th>")
              .append("<th>City</th>")
              .append("<th>Payment</th>")
              .append("<th>Subtotal</th>")
              .append("<th>Discount</th>")
              .append("<th>Shipping</th>")
              .append("<th>VAT</th>")
              .append("<th>Grand Total</th>")
              .append("<th>Status</th>")
              .append("</tr></thead><tbody>");
            for (String[] r : orders) {
                String discount = r[8];
                sb.append("<tr>")
                  .append("<td><b>").append(esc(r[0])).append("</b></td>")
                  .append("<td class=\"dim\" style=\"white-space:nowrap\">").append(esc(nvl(r[1]))).append("</td>")
                  .append("<td>").append(esc(nvl(r[2]))).append("</td>")
                  .append("<td class=\"dim\">").append(esc(nvl(r[3]))).append("</td>")
                  .append("<td>").append(esc(nvl(r[4]))).append("</td>")
                  .append("<td>").append(esc(nvl(r[5]))).append("</td>")
                  .append("<td class=\"amt\">Rs. ").append(esc(r[7])).append("</td>")
                  .append("<td style=\"color:#c62828;font-weight:bold\">")
                  .append("0".equals(discount) ? "<span class=\"dim\">&mdash;</span>" : "- Rs. " + esc(discount))
                  .append("</td>")
                  .append("<td class=\"amt\" style=\"color:#1565c0\">Rs. ").append(esc(r[9])).append("</td>")
                  .append("<td class=\"amt\" style=\"color:#6a1b9a\">Rs. ").append(esc(r[10])).append("</td>")
                  .append("<td class=\"amt\">Rs. ").append(esc(r[11])).append("</td>")
                  .append("<td><span class=\"badge ").append(sClass(r[6])).append("\">").append(esc(r[6])).append("</span></td>")
                  .append("</tr>");
            }
            sb.append("</tbody></table>");
        }
        sb.append("</div>");

        // ── Footer ────────────────────────────────────────────────────────────
        sb.append("</div>") // end .body
          .append("<div class=\"footer\">")
          .append("HotWheels Nepal &mdash; Confidential Admin Report &mdash; ")
          .append(monthName).append(" ").append(year)
          .append(" &mdash; Generated by <b>").append(esc(adminName != null ? adminName : "Admin")).append("</b>")
          .append("</div>")
          .append("</div></body></html>");

        return sb.toString();
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private String card(String label, String value, String colorClass) {
        return "<div class=\"card\"><div class=\"lbl\">" + esc(label) + "</div>"
             + "<div class=\"val " + colorClass + "\">" + value + "</div></div>";
    }

    private String revRow(String label, String amount, String amtClass) {
        return "<tr><td class=\"label\">" + label + "</td>"
             + "<td class=\"amount " + amtClass + "\">" + amount + "</td></tr>";
    }

    private String sClass(String status) {
        if (status == null) return "";
        switch (status.toLowerCase()) {
            case "pending":   return "s-pending";
            case "confirmed": return "s-confirmed";
            case "shipped":   return "s-shipped";
            case "delivered": return "s-delivered";
            case "cancelled": return "s-cancelled";
            default:          return "";
        }
    }

    private String fmt(double v)  { return String.format("%,.0f", v); }
    private String nvl(String s)  { return s != null ? s : "—"; }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#x27;");
    }
}
