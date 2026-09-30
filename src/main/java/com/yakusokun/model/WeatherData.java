package com.yakusokun.model;

import java.io.Serializable;

public class WeatherData implements Serializable {
    private static final long serialVersionUID = 1L;

    private String targetDate;
    private int wmoCode;
    private int precipitationProbability;
    private double precipitationSum;
    private double temperatureMax;
    private double temperatureMin;
    private String weatherState;
    private String iconName;

    public WeatherData() {
    }

    public WeatherData(String targetDate, int wmoCode, int precipitationProbability, double precipitationSum, double temperatureMax, double temperatureMin, String weatherState, String iconName) {
        this.targetDate = targetDate;
        this.wmoCode = wmoCode;
        this.precipitationProbability = precipitationProbability;
        this.precipitationSum = precipitationSum;
        this.temperatureMax = temperatureMax;
        this.temperatureMin = temperatureMin;
        this.weatherState = weatherState;
        this.iconName = iconName;
    }

    public String getTargetDate() {
        return targetDate;
    }

    public void setTargetDate(String targetDate) {
        this.targetDate = targetDate;
    }

    public int getWmoCode() {
        return wmoCode;
    }

    public void setWmoCode(int wmoCode) {
        this.wmoCode = wmoCode;
    }

    public int getPrecipitationProbability() {
        return precipitationProbability;
    }

    public void setPrecipitationProbability(int precipitationProbability) {
        this.precipitationProbability = precipitationProbability;
    }

    public double getPrecipitationSum() {
        return precipitationSum;
    }

    public void setPrecipitationSum(double precipitationSum) {
        this.precipitationSum = precipitationSum;
    }

    public double getTemperatureMax() {
        return temperatureMax;
    }

    public void setTemperatureMax(double temperatureMax) {
        this.temperatureMax = temperatureMax;
    }

    public double getTemperatureMin() {
        return temperatureMin;
    }

    public void setTemperatureMin(double temperatureMin) {
        this.temperatureMin = temperatureMin;
    }

    public String getWeatherState() {
        return weatherState;
    }

    public void setWeatherState(String weatherState) {
        this.weatherState = weatherState;
    }

    public String getIconName() {
        return iconName;
    }

    public void setIconName(String iconName) {
        this.iconName = iconName;
    }
}
