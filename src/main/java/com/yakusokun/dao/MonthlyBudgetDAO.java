package com.yakusokun.dao;

import com.yakusokun.model.MonthlyBudget;
import com.yakusokun.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

public class MonthlyBudgetDAO {

    public MonthlyBudget findByUserIdAndMonth(int userId, String targetMonth) {
        String sql = "SELECT id, user_id, target_month, income_amount, target_expense FROM monthly_budgets WHERE user_id = ? AND target_month = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, targetMonth);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MonthlyBudget mb = new MonthlyBudget();
                    mb.setId(rs.getInt("id"));
                    mb.setUserId(rs.getInt("user_id"));
                    mb.setTargetMonth(rs.getString("target_month"));
                    mb.setIncomeAmount(rs.getInt("income_amount"));
                    mb.setTargetExpense(rs.getInt("target_expense"));
                    return mb;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public MonthlyBudget findPreviousMonthBudget(int userId, String targetMonth) {
        try {
            YearMonth ym = YearMonth.parse(targetMonth, DateTimeFormatter.ofPattern("yyyy-MM"));
            String prevMonth = ym.minusMonths(1).format(DateTimeFormatter.ofPattern("yyyy-MM"));
            return findByUserIdAndMonth(userId, prevMonth);
        } catch (Exception e) {
            return null;
        }
    }

    public boolean saveOrUpdate(MonthlyBudget budget) {
        MonthlyBudget existing = findByUserIdAndMonth(budget.getUserId(), budget.getTargetMonth());
        if (existing == null) {
            String sql = "INSERT INTO monthly_budgets (user_id, target_month, income_amount, target_expense) VALUES (?, ?, ?, ?)";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, budget.getUserId());
                ps.setString(2, budget.getTargetMonth());
                ps.setInt(3, budget.getIncomeAmount() != null ? budget.getIncomeAmount() : 0);
                ps.setInt(4, budget.getTargetExpense() != null ? budget.getTargetExpense() : 0);
                int affected = ps.executeUpdate();
                if (affected > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            budget.setId(rs.getInt(1));
                        }
                    }
                    return true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            String sql = "UPDATE monthly_budgets SET income_amount = ?, target_expense = ? WHERE id = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, budget.getIncomeAmount() != null ? budget.getIncomeAmount() : 0);
                ps.setInt(2, budget.getTargetExpense() != null ? budget.getTargetExpense() : 0);
                ps.setInt(3, existing.getId());
                budget.setId(existing.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
