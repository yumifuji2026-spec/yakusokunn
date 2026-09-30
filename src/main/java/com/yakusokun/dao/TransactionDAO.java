package com.yakusokun.dao;

import com.yakusokun.model.Transaction;
import com.yakusokun.util.DBUtil;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    public List<Transaction> findByUserIdAndMonth(int userId, String targetMonth) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.id, t.user_id, t.type, t.date, t.category_id, t.amount, t.memo, t.created_at, "
                   + "ec.name AS category_name, ec.color_code AS category_color_code "
                   + "FROM transactions t "
                   + "LEFT JOIN expense_categories ec ON t.category_id = ec.id "
                   + "WHERE t.user_id = ? AND TO_CHAR(t.date, 'YYYY-MM') = ? "
                   + "ORDER BY t.date DESC, t.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, targetMonth);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTransaction(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> findByUserIdAndDate(int userId, Date date) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.id, t.user_id, t.type, t.date, t.category_id, t.amount, t.memo, t.created_at, "
                   + "ec.name AS category_name, ec.color_code AS category_color_code "
                   + "FROM transactions t "
                   + "LEFT JOIN expense_categories ec ON t.category_id = ec.id "
                   + "WHERE t.user_id = ? AND t.date = ? "
                   + "ORDER BY t.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTransaction(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Transaction findById(int id, int userId) {
        String sql = "SELECT t.id, t.user_id, t.type, t.date, t.category_id, t.amount, t.memo, t.created_at, "
                   + "ec.name AS category_name, ec.color_code AS category_color_code "
                   + "FROM transactions t "
                   + "LEFT JOIN expense_categories ec ON t.category_id = ec.id "
                   + "WHERE t.id = ? AND t.user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTransaction(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Transaction transaction) {
        String sql = "INSERT INTO transactions (user_id, type, date, category_id, amount, memo) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, transaction.getUserId());
            ps.setString(2, transaction.getType());
            ps.setDate(3, transaction.getDate());
            ps.setInt(4, transaction.getCategoryId());
            ps.setInt(5, transaction.getAmount());
            if (transaction.getMemo() != null && !transaction.getMemo().isEmpty()) {
                ps.setString(6, transaction.getMemo());
            } else {
                ps.setNull(6, Types.VARCHAR);
            }
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        transaction.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Transaction transaction) {
        String sql = "UPDATE transactions SET type = ?, date = ?, category_id = ?, amount = ?, memo = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, transaction.getType());
            ps.setDate(2, transaction.getDate());
            ps.setInt(3, transaction.getCategoryId());
            ps.setInt(4, transaction.getAmount());
            if (transaction.getMemo() != null && !transaction.getMemo().isEmpty()) {
                ps.setString(5, transaction.getMemo());
            } else {
                ps.setNull(5, Types.VARCHAR);
            }
            ps.setInt(6, transaction.getId());
            ps.setInt(7, transaction.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id, int userId) {
        String sql = "DELETE FROM transactions WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Transaction mapTransaction(ResultSet rs) throws SQLException {
        Transaction t = new Transaction();
        t.setId(rs.getInt("id"));
        t.setUserId(rs.getInt("user_id"));
        t.setType(rs.getString("type"));
        t.setDate(rs.getDate("date"));
        t.setCategoryId(rs.getInt("category_id"));
        t.setAmount(rs.getInt("amount"));
        t.setMemo(rs.getString("memo"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setCategoryName(rs.getString("category_name"));
        t.setCategoryColorCode(rs.getString("category_color_code"));
        return t;
    }
}
