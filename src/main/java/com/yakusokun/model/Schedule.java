package com.yakusokun.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Schedule implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer userId;
    private Date dayTime;
    private String title;
    private Integer categoryId;
    private Time startTime;
    private Time endTime;
    private String memo;
    private Boolean hasAlarm;
    private Integer alarmMinutesBefore;
    private Timestamp createdAt;

    // Joined category properties
    private String categoryName;
    private String categoryColorCode;

    public Schedule() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Date getDayTime() {
        return dayTime;
    }

    public void setDayTime(Date dayTime) {
        this.dayTime = dayTime;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public Boolean getHasAlarm() {
        return hasAlarm;
    }

    public void setHasAlarm(Boolean hasAlarm) {
        this.hasAlarm = hasAlarm;
    }

    public Integer getAlarmMinutesBefore() {
        return alarmMinutesBefore;
    }

    public void setAlarmMinutesBefore(Integer alarmMinutesBefore) {
        this.alarmMinutesBefore = alarmMinutesBefore;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getCategoryColorCode() {
        return categoryColorCode;
    }

    public void setCategoryColorCode(String categoryColorCode) {
        this.categoryColorCode = categoryColorCode;
    }

    // Helper getters for JSP EL formatting
    public String getFormattedStartTime() {
        if (startTime == null) return "";
        String s = startTime.toString();
        if (s.length() >= 5) {
            return s.substring(0, 5);
        }
        return s;
    }

    public String getFormattedEndTime() {
        if (endTime == null) return "";
        String s = endTime.toString();
        if (s.length() >= 5) {
            return s.substring(0, 5);
        }
        return s;
    }

    public String getFormattedDate() {
        if (dayTime == null) return "";
        return dayTime.toString();
    }

    public String getCategoryClass() {
        if (categoryId == null || categoryId <= 0) return "category-08";
        int num = categoryId;
        if (num > 8) num = 8;
        return String.format("category-%02d", num);
    }
}
