package com.yakusokun.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class CalendarCell implements Serializable {
    private static final long serialVersionUID = 1L;

    private String dateStr;
    private int dayNumber;
    private boolean otherMonth;
    private boolean today;
    private WeatherData weather;
    private Schedule schedule;
    private ArrayList<Schedule> schedules = new ArrayList<>();

    // Household calendar fields
    private boolean hasTransaction;
    private int dailyBalance;
    private String formattedDailyBalance;
    private String balanceCssClass;

    public CalendarCell() {
    }

    public CalendarCell(String dateStr, int dayNumber, boolean otherMonth, boolean today) {
        this.dateStr = dateStr;
        this.dayNumber = dayNumber;
        this.otherMonth = otherMonth;
        this.today = today;
    }

    public String getDateStr() {
        return dateStr;
    }

    public void setDateStr(String dateStr) {
        this.dateStr = dateStr;
    }

    public int getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }

    public boolean isOtherMonth() {
        return otherMonth;
    }

    public void setOtherMonth(boolean otherMonth) {
        this.otherMonth = otherMonth;
    }

    public boolean isToday() {
        return today;
    }

    public void setToday(boolean today) {
        this.today = today;
    }

    public WeatherData getWeather() {
        return weather;
    }

    public void setWeather(WeatherData weather) {
        this.weather = weather;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }

    public List<Schedule> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<Schedule> schedules) {
        if (schedules instanceof ArrayList) {
            this.schedules = (ArrayList<Schedule>) schedules;
        } else if (schedules != null) {
            this.schedules = new ArrayList<>(schedules);
        } else {
            this.schedules = new ArrayList<>();
        }
    }

    public boolean isHasTransaction() {
        return hasTransaction;
    }

    public void setHasTransaction(boolean hasTransaction) {
        this.hasTransaction = hasTransaction;
    }

    public int getDailyBalance() {
        return dailyBalance;
    }

    public void setDailyBalance(int dailyBalance) {
        this.dailyBalance = dailyBalance;
    }

    public String getFormattedDailyBalance() {
        return formattedDailyBalance;
    }

    public void setFormattedDailyBalance(String formattedDailyBalance) {
        this.formattedDailyBalance = formattedDailyBalance;
    }

    public String getBalanceCssClass() {
        return balanceCssClass;
    }

    public void setBalanceCssClass(String balanceCssClass) {
        this.balanceCssClass = balanceCssClass;
    }
}
