package com.yakusokun.model;

import java.io.Serializable;

public class ExpenseCategory implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String name;
    private String type; // '01': 収入, '02': 出費
    private String colorCode;

    public ExpenseCategory() {
    }

    public ExpenseCategory(Integer id, String name, String type, String colorCode) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.colorCode = colorCode;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getColorCode() {
        return colorCode;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }
}
