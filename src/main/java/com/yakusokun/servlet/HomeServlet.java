package com.yakusokun.servlet;

import com.yakusokun.dao.ScheduleDAO;
import com.yakusokun.model.CalendarCell;
import com.yakusokun.model.Schedule;
import com.yakusokun.model.WeatherData;
import com.yakusokun.util.WeatherUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private transient ScheduleDAO scheduleDAO = new ScheduleDAO();

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

        // Weather forecast in session
        @SuppressWarnings("unchecked")
        List<WeatherData> weatherList = (List<WeatherData>) session.getAttribute("weather");
        if (weatherList == null) {
            weatherList = WeatherUtil.fetch7DayForecast();
            session.setAttribute("weather", weatherList);
        }

        Map<String, WeatherData> weatherMap = new HashMap<>();
        if (weatherList != null) {
            for (WeatherData w : weatherList) {
                if (w.getTargetDate() != null) {
                    weatherMap.put(w.getTargetDate(), w);
                }
            }
        }

        // Generate calendar grid
        YearMonth targetYm = YearMonth.parse(targetDay, DateTimeFormatter.ofPattern("yyyy-MM"));
        LocalDate firstOfMonth = targetYm.atDay(1);
        int firstDayOfWeek = firstOfMonth.getDayOfWeek().getValue() % 7; // Sunday = 0

        LocalDate today = LocalDate.now();
        String todayStr = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String timestamp = (String) session.getAttribute("timestamp");
        if (timestamp == null) {
            timestamp = todayStr + " 00:00:00";
        }

        // Fetch schedules for user and target month
        List<Schedule> monthSchedules = scheduleDAO.findByUserIdAndMonth(userId, targetDay);
        Map<String, List<Schedule>> scheduleMapByDate = new HashMap<>();
        for (Schedule s : monthSchedules) {
            String dateKey = s.getDayTime().toString();
            scheduleMapByDate.computeIfAbsent(dateKey, k -> new ArrayList<>()).add(s);
        }

        List<CalendarCell> cells = new ArrayList<>();
        LocalDate gridStart = firstOfMonth.minusDays(firstDayOfWeek);
        int totalCells = (firstDayOfWeek + targetYm.lengthOfMonth() > 35) ? 42 : 35;

        DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for (int i = 0; i < totalCells; i++) {
            LocalDate currDate = gridStart.plusDays(i);
            String currDateStr = currDate.format(dateFmt);
            boolean isOther = (currDate.getMonthValue() != targetYm.getMonthValue());
            boolean isToday = currDateStr.equals(todayStr);

            CalendarCell cell = new CalendarCell(currDateStr, currDate.getDayOfMonth(), isOther, isToday);

            if (weatherMap.containsKey(currDateStr)) {
                cell.setWeather(weatherMap.get(currDateStr));
            }

            List<Schedule> dateScheds = scheduleMapByDate.get(currDateStr);
            if (dateScheds != null && !dateScheds.isEmpty()) {
                cell.setSchedules(dateScheds);
                // Filter: day_time != today OR start_time > timestamp
                // Smallest start_time
                Schedule selected = null;
                for (Schedule s : dateScheds) {
                    if (!currDateStr.equals(todayStr) || (s.getFormattedStartTime() != null && (currDateStr + " " + s.getFormattedStartTime() + ":00").compareTo(timestamp) > 0)) {
                        if (selected == null || s.getStartTime().before(selected.getStartTime())) {
                            selected = s;
                        }
                    }
                }
                if (selected == null) {
                    selected = dateScheds.get(0);
                }
                cell.setSchedule(selected);
            }

            cells.add(cell);
        }

        request.setAttribute("calendarCells", cells);
        request.setAttribute("displayYearMonth", targetYm.getYear() + "年" + targetYm.getMonthValue() + "月");

        // Alarm info
        Schedule alarmSchedule = scheduleDAO.findAlarmSchedule(userId, timestamp);
        if (alarmSchedule != null) {
            request.setAttribute("alarmTitle", alarmSchedule.getTitle());
            request.setAttribute("alarmStartTime", alarmSchedule.getFormattedStartTime());
            request.setAttribute("alarmEndTime", alarmSchedule.getFormattedEndTime());
            request.setAttribute("alarmMinutesBefore", alarmSchedule.getAlarmMinutesBefore());
            request.setAttribute("alarmMemo", alarmSchedule.getMemo() != null ? alarmSchedule.getMemo() : "");

            // 「アラーム通知を一度限りにする」：通知対象となった予定のアラームフラグ(has_alarm)をOFF(false)に更新
            scheduleDAO.turnOffAlarm(alarmSchedule.getId(), userId);

            // Update timestamp to current system time
            String updatedTimestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            session.setAttribute("timestamp", updatedTimestamp);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/home.jsp").forward(request, response);
    }
}
