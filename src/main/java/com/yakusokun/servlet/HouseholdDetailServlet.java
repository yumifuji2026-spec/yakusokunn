package com.yakusokun.servlet;

import com.yakusokun.dao.TransactionDAO;
import com.yakusokun.model.Transaction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet({"/household/detail", "/household_detail", "/transaction/manage"})
public class HouseholdDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private transient TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String dateParam = request.getParameter("date");
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            session.setAttribute("transactionDate", dateParam.trim());
        }

        String transactionDate = (String) session.getAttribute("transactionDate");
        if (transactionDate == null || transactionDate.trim().isEmpty()) {
            transactionDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            session.setAttribute("transactionDate", transactionDate);
        }

        Date sqlDate;
        try {
            sqlDate = Date.valueOf(transactionDate.replace('/', '-'));
        } catch (Exception e) {
            sqlDate = Date.valueOf(LocalDate.now());
            transactionDate = sqlDate.toString();
            session.setAttribute("transactionDate", transactionDate);
        }

        LocalDate ld = sqlDate.toLocalDate();
        String displayDate = ld.getYear() + "年 " + ld.getMonthValue() + "月" + ld.getDayOfMonth() + "日";

        List<Transaction> transactions = transactionDAO.findByUserIdAndDate(userId, sqlDate);

        request.setAttribute("displayDate", displayDate);
        request.setAttribute("transactionDate", transactionDate);
        request.setAttribute("transactions", transactions);

        request.getRequestDispatcher("/WEB-INF/jsp/household_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    transactionDAO.delete(id, userId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/household/detail");
    }
}
