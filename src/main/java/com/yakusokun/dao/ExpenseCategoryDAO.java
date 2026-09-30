package com.yakusokun.dao;

import com.yakusokun.model.ExpenseCategory;
import com.yakusokun.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ExpenseCategoryDAO {

    public List<ExpenseCategory> findAll() {
        List<ExpenseCategory> list = new ArrayList<>();
        String sql = "SELECT id, name, type, color_code FROM expense_categories ORDER BY id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ExpenseCategory ec = new ExpenseCategory();
                ec.setId(rs.getInt("id"));
                ec.setName(rs.getString("name"));
                ec.setType(rs.getString("type"));
                ec.setColorCode(rs.getString("color_code"));
                list.add(ec);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ExpenseCategory> findByType(String type) {
        List<ExpenseCategory> list = new ArrayList<>();
        String sql = "SELECT id, name, type, color_code FROM expense_categories WHERE type = ? ORDER BY id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ExpenseCategory ec = new ExpenseCategory();
                    ec.setId(rs.getInt("id"));
                    ec.setName(rs.getString("name"));
                    ec.setType(rs.getString("type"));
                    ec.setColorCode(rs.getString("color_code"));
                    list.add(ec);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ExpenseCategory findById(int id) {
        String sql = "SELECT id, name, type, color_code FROM expense_categories WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ExpenseCategory ec = new ExpenseCategory();
                    ec.setId(rs.getInt("id"));
                    ec.setName(rs.getString("name"));
                    ec.setType(rs.getString("type"));
                    ec.setColorCode(rs.getString("color_code"));
                    return ec;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
