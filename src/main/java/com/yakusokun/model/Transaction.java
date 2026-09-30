package com.yakusokun.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class Transaction implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer userId;
    private String type; // '01': 収入, '02': 出費
    private Date date;
    private Integer categoryId;
    private Integer amount;
    private String memo;
    private Timestamp createdAt;

    // Joined category properties
    private String categoryName;
    private String categoryColorCode;

    public Transaction() {
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
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

    public String getFormattedDate() {
        if (date == null) return "";
        return date.toString();
    }

    public String getFormattedAmount() {
        int amt = amount != null ? amount : 0;
        String amtStr = String.format("%,d", amt);
        if ("01".equals(type)) {
            return "￥" + amtStr;
        } else {
            return "-￥" + amtStr;
        }
    }

    public String getCategoryCssClass() {
        if ("01".equals(type)) {
            return "category-income";
        }
        if (categoryId != null) {
            switch (categoryId) {
                case 10: return "category-food";
                case 11: return "category-utility";
                case 12: return "category-misc";
                default: return "category-misc";
            }
        }
        return "category-misc";
    }

    public String getTransactionCssClass() {
        if ("01".equals(type)) {
            return "income";
        }
        if (categoryId != null) {
            switch (categoryId) {
                case 10: return "food";
                case 11: return "utility";
                case 12: return "misc";
                default: return "misc";
            }
        }
        return "misc";
    }
}
