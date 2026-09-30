package com.yakusokun.servlet;

import com.yakusokun.dao.CategoryDAO;
import com.yakusokun.dao.ScheduleDAO;
import com.yakusokun.model.Category;
import com.yakusokun.model.Schedule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/alarm")
public class AlarmServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private transient ScheduleDAO scheduleDAO = new ScheduleDAO();
    private transient CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        Integer scheduleId = (Integer) session.getAttribute("scheduleId");
        Schedule schedule = null;
        if (scheduleId != null) {
            schedule = scheduleDAO.findById(scheduleId);
        }

        if (schedule == null) {
            schedule = new Schedule();
            String scheduleDate = (String) session.getAttribute("scheduleDate");
            if (scheduleDate == null || scheduleDate.trim().isEmpty()) {
                scheduleDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
            schedule.setDayTime(Date.valueOf(scheduleDate));
            schedule.setHasAlarm(false);
        }

        request.setAttribute("schedule", schedule);
        request.getRequestDispatcher("/WEB-INF/jsp/alarm.jsp").forward(request, response);
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

        String dayTimeStr = request.getParameter("day_time");
        String title = request.getParameter("title");
        String categoryIdStr = request.getParameter("category_id");
        String startTimeStr = request.getParameter("start_time");
        String endTimeStr = request.getParameter("end_time");
        String memo = request.getParameter("memo");
        String hasAlarmStr = request.getParameter("has_alarm");
        String alarmMinutesBeforeStr = request.getParameter("alarm_minutes_before");

        if (dayTimeStr == null || dayTimeStr.trim().isEmpty() ||
            title == null || title.trim().isEmpty() ||
            categoryIdStr == null || categoryIdStr.trim().isEmpty() ||
            startTimeStr == null || startTimeStr.trim().isEmpty() ||
            endTimeStr == null || endTimeStr.trim().isEmpty()) {

            request.setAttribute("error", "必須項目（日付、タイトル、カテゴリー、開始時間、終了時間）を入力してください。");
            doGet(request, response);
            return;
        }

        try {
            Date dayTime = Date.valueOf(dayTimeStr.trim().replace('/', '-'));
            int categoryId = Integer.parseInt(categoryIdStr.trim());

            String formattedStartTime = startTimeStr.trim().length() == 5 ? startTimeStr.trim() + ":00" : startTimeStr.trim();
            String formattedEndTime = endTimeStr.trim().length() == 5 ? endTimeStr.trim() + ":00" : endTimeStr.trim();

            Time startTime = Time.valueOf(formattedStartTime);
            Time endTime = Time.valueOf(formattedEndTime);

            if (!startTime.before(endTime)) {
                request.setAttribute("error", "開始時間は終了時間より前の時間を設定してください。");
                doGet(request, response);
                return;
            }

            boolean hasAlarm = "true".equalsIgnoreCase(hasAlarmStr) || "on".equalsIgnoreCase(hasAlarmStr) || "1".equals(hasAlarmStr);
            Integer alarmMinutesBefore = null;
            if (hasAlarm) {
                if (alarmMinutesBeforeStr == null || alarmMinutesBeforeStr.trim().isEmpty()) {
                    request.setAttribute("error", "アラーム通知時間を選択してください。");
                    doGet(request, response);
                    return;
                }
                alarmMinutesBefore = Integer.parseInt(alarmMinutesBeforeStr.trim());
            }

            Integer scheduleId = (Integer) session.getAttribute("scheduleId");
            Schedule schedule = new Schedule();
            schedule.setUserId(userId);
            schedule.setDayTime(dayTime);
            schedule.setTitle(title.trim());
            schedule.setCategoryId(categoryId);
            schedule.setStartTime(startTime);
            schedule.setEndTime(endTime);
            schedule.setMemo(memo != null ? memo.trim() : null);
            schedule.setHasAlarm(hasAlarm);
            schedule.setAlarmMinutesBefore(alarmMinutesBefore);

            if (scheduleId != null) {
                schedule.setId(scheduleId);
                scheduleDAO.update(schedule);
            } else {
                scheduleDAO.insert(schedule);
            }

            session.removeAttribute("scheduleId");
            response.sendRedirect(request.getContextPath() + "/schedule");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "入力内容に誤りがあります。確認してください。");
            doGet(request, response);
        }
    }
}
