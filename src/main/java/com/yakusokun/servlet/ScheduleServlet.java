package com.yakusokun.servlet;

import com.yakusokun.dao.ScheduleDAO;
import com.yakusokun.model.Schedule;
import com.yakusokun.model.WeatherData;
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
import java.util.Locale;

@WebServlet("/schedule")
public class ScheduleServlet extends HttpServlet {
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

        String paramDate = request.getParameter("date");
        if (paramDate != null && !paramDate.trim().isEmpty()) {
            session.setAttribute("scheduleDate", paramDate.trim());
        }

        String scheduleDate = (String) session.getAttribute("scheduleDate");
        if (scheduleDate == null || scheduleDate.trim().isEmpty()) {
            scheduleDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            session.setAttribute("scheduleDate", scheduleDate);
        }

        LocalDate localDate = LocalDate.parse(scheduleDate, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        DateTimeFormatter displayFmt = DateTimeFormatter.ofPattern("yyyy年M月d日(E)", Locale.JAPANESE);
        request.setAttribute("displayDate", localDate.format(displayFmt));
        request.setAttribute("scheduleDate", scheduleDate);

        // Fetch schedules for date
        List<Schedule> schedules = scheduleDAO.findByUserIdAndDate(userId, Date.valueOf(localDate));
        request.setAttribute("schedules", schedules);

        // Fetch weather detail for date from session weather list
        @SuppressWarnings("unchecked")
        List<WeatherData> weatherList = (List<WeatherData>) session.getAttribute("weather");
        WeatherData weatherDetail = null;
        if (weatherList != null) {
            for (WeatherData w : weatherList) {
                if (scheduleDate.equals(w.getTargetDate())) {
                    weatherDetail = w;
                    break;
                }
            }
        }
        request.setAttribute("weatherDetail", weatherDetail);

        request.getRequestDispatcher("/WEB-INF/jsp/schedule.jsp").forward(request, response);
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
        if ("toggleAlarm".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    scheduleDAO.toggleAlarm(id, userId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    scheduleDAO.delete(id, userId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("select".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    session.setAttribute("scheduleId", id);
                    response.sendRedirect(request.getContextPath() + "/alarm");
                    return;
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("new".equals(action)) {
            session.removeAttribute("scheduleId");
            response.sendRedirect(request.getContextPath() + "/alarm");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/schedule");
    }
}
