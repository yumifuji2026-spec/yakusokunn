package com.yakusokun.servlet;

import com.yakusokun.dao.MonthlyBudgetDAO;
import com.yakusokun.model.MonthlyBudget;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

@WebServlet({"/budget", "/budget/target"})
public class BudgetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private transient MonthlyBudgetDAO budgetDAO = new MonthlyBudgetDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String targetDay = (String) session.getAttribute("targetDay");
        if (targetDay == null || targetDay.trim().isEmpty()) {
            targetDay = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            session.setAttribute("targetDay", targetDay);
        }

        YearMonth targetYm = YearMonth.parse(targetDay, DateTimeFormatter.ofPattern("yyyy-MM"));
        String headerTitle = targetYm.getYear() + "年" + targetYm.getMonthValue() + "月 収支目標設定";

        MonthlyBudget budget = budgetDAO.findByUserIdAndMonth(userId, targetDay);
        if (budget == null) {
            MonthlyBudget prevBudget = budgetDAO.findPreviousMonthBudget(userId, targetDay);
            if (prevBudget != null) {
                budget = new MonthlyBudget(null, userId, targetDay, prevBudget.getIncomeAmount(), prevBudget.getTargetExpense());
            } else {
                budget = new MonthlyBudget(null, userId, targetDay, 0, 0);
            }
        }

        request.setAttribute("headerTitle", headerTitle);
        request.setAttribute("budget", budget);
        request.getRequestDispatcher("/WEB-INF/jsp/budget.jsp").forward(request, response);
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

        String targetDay = (String) session.getAttribute("targetDay");
        if (targetDay == null || targetDay.trim().isEmpty()) {
            targetDay = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        }

        String incomeStr = request.getParameter("income");
        String expenseStr = request.getParameter("expense");

        try {
            int income = (incomeStr != null && !incomeStr.trim().isEmpty()) ? Integer.parseInt(incomeStr.replaceAll("[^0-9]", "")) : 0;
            int expense = (expenseStr != null && !expenseStr.trim().isEmpty()) ? Integer.parseInt(expenseStr.replaceAll("[^0-9]", "")) : 0;

            MonthlyBudget budget = new MonthlyBudget();
            budget.setUserId(userId);
            budget.setTargetMonth(targetDay);
            budget.setIncomeAmount(income);
            budget.setTargetExpense(expense);

            budgetDAO.saveOrUpdate(budget);
            response.sendRedirect(request.getContextPath() + "/household");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "金額を正しい形式で入力してください。");
            doGet(request, response);
        }
    }
}
