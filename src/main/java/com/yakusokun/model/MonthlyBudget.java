package com.yakusokun.model;

import java.io.Serializable;

public class MonthlyBudget implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer userId;
    private String targetMonth; // yyyy-MM
    private Integer incomeAmount;
    private Integer targetExpense;

    public MonthlyBudget() {
    }

    public MonthlyBudget(Integer id, Integer userId, String targetMonth, Integer incomeAmount, Integer targetExpense) {
        this.id = id;
        this.userId = userId;
        this.targetMonth = targetMonth;
        this.incomeAmount = incomeAmount;
        this.targetExpense = targetExpense;
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

    public String getTargetMonth() {
        return targetMonth;
    }

    public void setTargetMonth(String targetMonth) {
        this.targetMonth = targetMonth;
    }

    public Integer getIncomeAmount() {
        return incomeAmount;
    }

    public void setIncomeAmount(Integer incomeAmount) {
        this.incomeAmount = incomeAmount;
    }

    public Integer getTargetExpense() {
        return targetExpense;
    }

    public void setTargetExpense(Integer targetExpense) {
        this.targetExpense = targetExpense;
    }
}
