package com.yakusokun.dao;

import com.yakusokun.model.Schedule;
import com.yakusokun.util.DBUtil;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {

    public List<Schedule> findByUserIdAndMonth(int userId, String targetMonth) {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.id, s.user_id, s.day_time, s.title, s.category_id, s.start_time, s.end_time, s.memo, s.has_alarm, s.alarm_minutes_before, s.created_at, "
                   + "c.name AS category_name, c.color_code AS category_color_code "
                   + "FROM schedules s "
                   + "LEFT JOIN categories c ON s.category_id = c.id "
                   + "WHERE s.user_id = ? AND TO_CHAR(s.day_time, 'YYYY-MM') = ? "
                   + "ORDER BY s.day_time ASC, s.start_time ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, targetMonth);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSchedule(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Schedule> findByUserIdAndDate(int userId, Date date) {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.id, s.user_id, s.day_time, s.title, s.category_id, s.start_time, s.end_time, s.memo, s.has_alarm, s.alarm_minutes_before, s.created_at, "
                   + "c.name AS category_name, c.color_code AS category_color_code "
                   + "FROM schedules s "
                   + "LEFT JOIN categories c ON s.category_id = c.id "
                   + "WHERE s.user_id = ? AND s.day_time = ? "
                   + "ORDER BY s.start_time ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSchedule(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Schedule findAlarmSchedule(int userId, String currentTimestamp) {
        // currentTimestamp format: "yyyy-MM-dd HH:mm:ss"
        // Find smallest start_time schedule for user where has_alarm=true and start_time >= today
        String sql = "SELECT s.id, s.user_id, s.day_time, s.title, s.category_id, s.start_time, s.end_time, s.memo, s.has_alarm, s.alarm_minutes_before, s.created_at, "
                   + "c.name AS category_name, c.color_code AS category_color_code "
                   + "FROM schedules s "
                   + "LEFT JOIN categories c ON s.category_id = c.id "
                   + "WHERE s.user_id = ? AND s.has_alarm = true AND (s.day_time + s.start_time) >= TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS') "
                   + "ORDER BY (s.day_time + s.start_time) ASC LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, currentTimestamp);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSchedule(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Schedule findById(int id) {
        String sql = "SELECT s.id, s.user_id, s.day_time, s.title, s.category_id, s.start_time, s.end_time, s.memo, s.has_alarm, s.alarm_minutes_before, s.created_at, "
                   + "c.name AS category_name, c.color_code AS category_color_code "
                   + "FROM schedules s "
                   + "LEFT JOIN categories c ON s.category_id = c.id "
                   + "WHERE s.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSchedule(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Schedule schedule) {
        String sql = "INSERT INTO schedules (user_id, day_time, title, category_id, start_time, end_time, memo, has_alarm, alarm_minutes_before) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, schedule.getUserId());
            ps.setDate(2, schedule.getDayTime());
            ps.setString(3, schedule.getTitle());
            ps.setInt(4, schedule.getCategoryId());
            ps.setTime(5, schedule.getStartTime());
            ps.setTime(6, schedule.getEndTime());
            if (schedule.getMemo() != null && !schedule.getMemo().isEmpty()) {
                ps.setString(7, schedule.getMemo());
            } else {
                ps.setNull(7, Types.VARCHAR);
            }
            ps.setBoolean(8, schedule.getHasAlarm() != null ? schedule.getHasAlarm() : false);
            if (schedule.getHasAlarm() != null && schedule.getHasAlarm() && schedule.getAlarmMinutesBefore() != null) {
                ps.setInt(9, schedule.getAlarmMinutesBefore());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        schedule.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Schedule schedule) {
        String sql = "UPDATE schedules SET day_time = ?, title = ?, category_id = ?, start_time = ?, end_time = ?, memo = ?, has_alarm = ?, alarm_minutes_before = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, schedule.getDayTime());
            ps.setString(2, schedule.getTitle());
            ps.setInt(3, schedule.getCategoryId());
            ps.setTime(4, schedule.getStartTime());
            ps.setTime(5, schedule.getEndTime());
            if (schedule.getMemo() != null && !schedule.getMemo().isEmpty()) {
                ps.setString(6, schedule.getMemo());
            } else {
                ps.setNull(6, Types.VARCHAR);
            }
            ps.setBoolean(7, schedule.getHasAlarm() != null ? schedule.getHasAlarm() : false);
            if (schedule.getHasAlarm() != null && schedule.getHasAlarm() && schedule.getAlarmMinutesBefore() != null) {
                ps.setInt(8, schedule.getAlarmMinutesBefore());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            ps.setInt(9, schedule.getId());
            ps.setInt(10, schedule.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id, int userId) {
        String sql = "DELETE FROM schedules WHERE id = ? AND user_id = ?";
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

    public boolean turnOffAlarm(int id, int userId) {
        String sql = "UPDATE schedules SET has_alarm = false WHERE id = ? AND user_id = ?";
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

    public boolean toggleAlarm(int id, int userId) {
        Schedule schedule = findByIdAndUserId(id, userId);
        if (schedule == null) {
            return false;
        }

        boolean currentHasAlarm = schedule.getHasAlarm() != null && schedule.getHasAlarm();
        boolean newHasAlarm = !currentHasAlarm;

        if (newHasAlarm) {
            Integer currentMinutes = schedule.getAlarmMinutesBefore();
            int newMinutes = (currentMinutes != null && currentMinutes > 0) ? currentMinutes : 15;
            String sql = "UPDATE schedules SET has_alarm = true, alarm_minutes_before = ? WHERE id = ? AND user_id = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, newMinutes);
                ps.setInt(2, id);
                ps.setInt(3, userId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            String sql = "UPDATE schedules SET has_alarm = false WHERE id = ? AND user_id = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                ps.setInt(2, userId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public Schedule findByIdAndUserId(int id, int userId) {
        String sql = "SELECT s.id, s.user_id, s.day_time, s.title, s.category_id, s.start_time, s.end_time, s.memo, s.has_alarm, s.alarm_minutes_before, s.created_at, "
                   + "c.name AS category_name, c.color_code AS category_color_code "
                   + "FROM schedules s "
                   + "LEFT JOIN categories c ON s.category_id = c.id "
                   + "WHERE s.id = ? AND s.user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSchedule(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Schedule mapSchedule(ResultSet rs) throws SQLException {
        Schedule s = new Schedule();
        s.setId(rs.getInt("id"));
        s.setUserId(rs.getInt("user_id"));
        s.setDayTime(rs.getDate("day_time"));
        s.setTitle(rs.getString("title"));
        s.setCategoryId(rs.getInt("category_id"));
        s.setStartTime(rs.getTime("start_time"));
        s.setEndTime(rs.getTime("end_time"));
        s.setMemo(rs.getString("memo"));
        s.setHasAlarm(rs.getBoolean("has_alarm"));
        int alarm = rs.getInt("alarm_minutes_before");
        if (!rs.wasNull()) {
            s.setAlarmMinutesBefore(alarm);
        }
        s.setCreatedAt(rs.getTimestamp("created_at"));
        s.setCategoryName(rs.getString("category_name"));
        s.setCategoryColorCode(rs.getString("category_color_code"));
        return s;
    }
}
