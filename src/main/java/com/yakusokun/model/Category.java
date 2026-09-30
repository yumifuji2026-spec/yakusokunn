package com.yakusokun.model;

import java.io.Serializable;

public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String name;
    private String colorCode;

    public Category() {
    }

    public Category(Integer id, String name, String colorCode) {
        this.id = id;
        this.name = name;
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

    public String getColorCode() {
        return colorCode;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }
}
