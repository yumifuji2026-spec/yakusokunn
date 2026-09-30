package com.yakusokun.servlet;

import com.yakusokun.dao.ExpenseCategoryDAO;
import com.yakusokun.dao.TransactionDAO;
import com.yakusokun.model.ExpenseCategory;
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

@WebServlet({"/transaction", "/transaction/detail"})
public class TransactionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private transient ExpenseCategoryDAO categoryDAO = new ExpenseCategoryDAO();
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

        List<ExpenseCategory> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        String idStr = request.getParameter("id");
        Transaction t = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                t = transactionDAO.findById(id, userId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (t == null) {
            t = new Transaction();
            String transactionDate = (String) session.getAttribute("transactionDate");
            if (transactionDate == null || transactionDate.trim().isEmpty()) {
                transactionDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
            try {
                t.setDate(Date.valueOf(transactionDate.replace('/', '-')));
            } catch (Exception e) {
                t.setDate(Date.valueOf(LocalDate.now()));
            }
            t.setType("02"); // default 出費
            t.setCategoryId(10); // default 食費
            t.setAmount(0);
            t.setMemo("");
        }

        request.setAttribute("transaction", t);
        request.getRequestDispatcher("/WEB-INF/jsp/transaction.jsp").forward(request, response);
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

        String idStr = request.getParameter("id");
        String type = request.getParameter("type");
        String dateStr = request.getParameter("date");
        String categoryIdStr = request.getParameter("category_id");
        String amountStr = request.getParameter("amount");
        String memo = request.getParameter("memo");

        if (type == null || type.trim().isEmpty() ||
            dateStr == null || dateStr.trim().isEmpty() ||
            categoryIdStr == null || categoryIdStr.trim().isEmpty() ||
            amountStr == null || amountStr.trim().isEmpty()) {

            request.setAttribute("error", "必須項目を入力してください。");
            doGet(request, response);
            return;
        }

        try {
            Date date = Date.valueOf(dateStr.trim().replace('/', '-'));
            int categoryId = Integer.parseInt(categoryIdStr.trim());
            String cleanAmount = amountStr.replaceAll("[^0-9]", "");
            int amount = Integer.parseInt(cleanAmount);

            Transaction t = new Transaction();
            t.setUserId(userId);
            t.setType(type.trim());
            t.setDate(date);
            t.setCategoryId(categoryId);
            t.setAmount(amount);
            t.setMemo((memo != null && !memo.trim().isEmpty()) ? memo.trim() : null);

            boolean success;
            if (idStr != null && !idStr.trim().isEmpty()) {
                t.setId(Integer.parseInt(idStr.trim()));
                success = transactionDAO.update(t);
            } else {
                success = transactionDAO.insert(t);
            }

            if (success) {
                // Update transactionDate in session to match the registered/updated date
                session.setAttribute("transactionDate", date.toString());
                response.sendRedirect(request.getContextPath() + "/household/detail");
            } else {
                request.setAttribute("error", "登録処理に失敗しました。");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "入力内容を確認してください。");
            doGet(request, response);
        }
    }
}
