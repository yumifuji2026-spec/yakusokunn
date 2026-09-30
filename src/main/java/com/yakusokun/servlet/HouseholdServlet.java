package com.yakusokun.servlet;

import com.yakusokun.dao.MonthlyBudgetDAO;
import com.yakusokun.dao.TransactionDAO;
import com.yakusokun.model.CalendarCell;
import com.yakusokun.model.MonthlyBudget;
import com.yakusokun.model.Transaction;
import com.yakusokun.util.AiAdviceUtil;

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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/household", "/kakeibo"})
public class HouseholdServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private transient MonthlyBudgetDAO budgetDAO = new MonthlyBudgetDAO();
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

        String targetDay = (String) session.getAttribute("targetDay");
        if (targetDay == null || targetDay.trim().isEmpty()) {
            targetDay = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            session.setAttribute("targetDay", targetDay);
        }

        String action = request.getParameter("action");
        if ("prev".equals(action)) {
            YearMonth ym = YearMonth.parse(targetDay, DateTimeFormatter.ofPattern("yyyy-MM"));
            targetDay = ym.minusMonths(1).format(DateTimeFormatter.ofPattern("yyyy-MM"));
            session.setAttribute("targetDay", targetDay);
        } else if ("next".equals(action)) {
            YearMonth ym = YearMonth.parse(targetDay, DateTimeFormatter.ofPattern("yyyy-MM"));
            targetDay = ym.plusMonths(1).format(DateTimeFormatter.ofPattern("yyyy-MM"));
            session.setAttribute("targetDay", targetDay);
        }

        YearMonth targetYm = YearMonth.parse(targetDay, DateTimeFormatter.ofPattern("yyyy-MM"));
        String displayYearMonth = targetYm.getYear() + "年" + targetYm.getMonthValue() + "月";

        MonthlyBudget budget = budgetDAO.findByUserIdAndMonth(userId, targetDay);
        int targetIncome = (budget != null && budget.getIncomeAmount() != null) ? budget.getIncomeAmount() : 0;
        int targetExpense = (budget != null && budget.getTargetExpense() != null) ? budget.getTargetExpense() : 0;

        List<Transaction> transactions = transactionDAO.findByUserIdAndMonth(userId, targetDay);

        Map<String, Integer> dailyIncomeMap = new HashMap<>();
        Map<String, Integer> dailyExpenseMap = new HashMap<>();
        Map<String, Integer> categoryExpenseMap = new HashMap<>();

        int totalIncome = 0;
        int totalExpense = 0;

        for (Transaction t : transactions) {
            String dStr = t.getDate().toString();
            int amt = t.getAmount() != null ? t.getAmount() : 0;
            if ("01".equals(t.getType())) {
                totalIncome += amt;
                dailyIncomeMap.put(dStr, dailyIncomeMap.getOrDefault(dStr, 0) + amt);
            } else if ("02".equals(t.getType())) {
                totalExpense += amt;
                dailyExpenseMap.put(dStr, dailyExpenseMap.getOrDefault(dStr, 0) + amt);
                String catName = t.getCategoryName() != null ? t.getCategoryName() : "その他";
                categoryExpenseMap.put(catName, categoryExpenseMap.getOrDefault(catName, 0) + amt);
            }
        }

        int remainingExpense = targetExpense - totalExpense;
        double achievementRate = (targetExpense > 0) ? ((double) totalExpense / targetExpense * 100.0) : 0.0;

        // Generate calendar grid
        LocalDate firstOfMonth = targetYm.atDay(1);
        int firstDayOfWeek = firstOfMonth.getDayOfWeek().getValue() % 7; // Sunday = 0
        LocalDate gridStart = firstOfMonth.minusDays(firstDayOfWeek);
        int totalCells = (firstDayOfWeek + targetYm.lengthOfMonth() > 35) ? 42 : 35;

        LocalDate today = LocalDate.now();
        String todayStr = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        List<CalendarCell> cells = new ArrayList<>();
        for (int i = 0; i < totalCells; i++) {
            LocalDate currDate = gridStart.plusDays(i);
            String currDateStr = currDate.format(dateFmt);
            boolean isOther = (currDate.getMonthValue() != targetYm.getMonthValue());
            boolean isToday = currDateStr.equals(todayStr);

            CalendarCell cell = new CalendarCell(currDateStr, currDate.getDayOfMonth(), isOther, isToday);

            boolean hasInc = dailyIncomeMap.containsKey(currDateStr);
            boolean hasExp = dailyExpenseMap.containsKey(currDateStr);

            if (hasInc || hasExp) {
                cell.setHasTransaction(true);
                int inc = dailyIncomeMap.getOrDefault(currDateStr, 0);
                int exp = dailyExpenseMap.getOrDefault(currDateStr, 0);
                int balance = inc - exp;
                cell.setDailyBalance(balance);

                if (balance > 0) {
                    cell.setFormattedDailyBalance("+￥" + String.format("%,d", balance));
                    cell.setBalanceCssClass("balance-positive");
                } else if (balance < 0) {
                    cell.setFormattedDailyBalance("-￥" + String.format("%,d", Math.abs(balance)));
                    cell.setBalanceCssClass("balance-negative");
                } else {
                    cell.setFormattedDailyBalance("￥0");
                    cell.setBalanceCssClass("balance-zero");
                }
            } else {
                cell.setHasTransaction(false);
            }

            cells.add(cell);
        }

        String aiAdviceText = AiAdviceUtil.generateAdvice(targetExpense, totalExpense, remainingExpense, achievementRate, categoryExpenseMap);

        request.setAttribute("displayYearMonth", displayYearMonth);
        request.setAttribute("calendarCells", cells);
        request.setAttribute("targetIncome", targetIncome);
        request.setAttribute("targetExpense", targetExpense);
        request.setAttribute("formattedTargetIncome", "￥" + String.format("%,d", targetIncome));
        request.setAttribute("formattedTargetExpense", "￥" + String.format("%,d", targetExpense));
        request.setAttribute("totalIncome", totalIncome);
        request.setAttribute("totalExpense", totalExpense);
        request.setAttribute("formattedTotalExpense", "￥" + String.format("%,d", totalExpense));
        request.setAttribute("remainingExpense", remainingExpense);
        request.setAttribute("formattedRemainingExpense", "￥" + String.format("%,d", remainingExpense));
        request.setAttribute("achievementRate", String.format("%.1f%%", achievementRate));
        request.setAttribute("aiAdviceText", aiAdviceText);

        request.getRequestDispatcher("/WEB-INF/jsp/household.jsp").forward(request, response);
    }
}
