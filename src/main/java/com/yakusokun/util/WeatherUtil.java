package com.yakusokun.util;

import com.yakusokun.model.WeatherData;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class WeatherUtil {

    private static final String API_URL = "https://api.open-meteo.com/v1/forecast?latitude=34.38628&longitude=132.45503&daily=weather_code,precipitation_probability_max,precipitation_sum,temperature_2m_max,temperature_2m_min&timezone=Asia/Tokyo&forecast_days=7";

    public static List<WeatherData> fetch7DayForecast() {
        List<WeatherData> list = new ArrayList<>();
        try {
            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(5))
                    .build();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .GET()
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                String json = response.body();
                list = parseDailyJson(json);
            }
        } catch (Exception e) {
            // Fallback or empty list on connection error
            e.printStackTrace();
        }
        return list;
    }

    public static List<WeatherData> parseDailyJson(String json) {
        List<WeatherData> result = new ArrayList<>();

        List<String> times = parseJsonArrayString(json, "time");
        List<Integer> weatherCodes = parseJsonArrayInt(json, "weather_code");
        List<Integer> precipProbs = parseJsonArrayInt(json, "precipitation_probability_max");
        List<Double> precipSums = parseJsonArrayDouble(json, "precipitation_sum");
        List<Double> tempMaxs = parseJsonArrayDouble(json, "temperature_2m_max");
        List<Double> tempMins = parseJsonArrayDouble(json, "temperature_2m_min");

        int count = times.size();
        for (int i = 0; i < count; i++) {
            String date = times.get(i);
            int code = i < weatherCodes.size() ? weatherCodes.get(i) : 0;
            int prob = i < precipProbs.size() ? precipProbs.get(i) : 0;
            double sum = i < precipSums.size() ? precipSums.get(i) : 0.0;
            double maxTemp = i < tempMaxs.size() ? tempMaxs.get(i) : 0.0;
            double minTemp = i < tempMins.size() ? tempMins.get(i) : 0.0;

            String state = mapWmoToState(code);
            String icon = mapWmoToIcon(code);

            WeatherData data = new WeatherData(date, code, prob, sum, maxTemp, minTemp, state, icon);
            result.add(data);
        }

        return result;
    }

    public static String mapWmoToState(int code) {
        if (code >= 0 && code <= 3) {
            return "晴れ";
        }
        if ((code >= 20 && code <= 21) || code == 24 || code == 25 || (code >= 50 && code <= 67) || (code >= 80 && code <= 84) || code == 91 || code == 92) {
            return "雨";
        }
        if (code == 22 || code == 23 || code == 26 || (code >= 36 && code <= 39) || (code >= 70 && code <= 79) || (code >= 85 && code <= 88) || code == 93 || code == 94) {
            return "雪";
        }
        if (code == 13 || code == 17 || code == 29 || (code >= 89 && code <= 100)) {
            return "雷";
        }
        return "晴れ";
    }

    public static String mapWmoToIcon(int code) {
        String state = mapWmoToState(code);
        switch (state) {
            case "晴れ":
                return "晴れ.png";
            case "雨":
                return "雨.png";
            case "雪":
                return "雪.png";
            case "雷":
                return "雷.png";
            default:
                return "晴れ.png";
        }
    }

    private static List<String> parseJsonArrayString(String json, String key) {
        List<String> list = new ArrayList<>();
        Pattern pattern = Pattern.compile("\"" + key + "\":\\s*\\[(.*?)\\]", Pattern.DOTALL);
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            String content = matcher.group(1);
            Matcher strMatcher = Pattern.compile("\"([^\"]+)\"").matcher(content);
            while (strMatcher.find()) {
                list.add(strMatcher.group(1));
            }
        }
        return list;
    }

    private static List<Integer> parseJsonArrayInt(String json, String key) {
        List<Integer> list = new ArrayList<>();
        Pattern pattern = Pattern.compile("\"" + key + "\":\\s*\\[(.*?)\\]", Pattern.DOTALL);
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            String content = matcher.group(1);
            String[] tokens = content.split(",");
            for (String t : tokens) {
                t = t.trim();
                if (!t.isEmpty() && !t.equals("null")) {
                    try {
                        list.add((int) Math.round(Double.parseDouble(t)));
                    } catch (NumberFormatException e) {
                        list.add(0);
                    }
                }
            }
        }
        return list;
    }

    private static List<Double> parseJsonArrayDouble(String json, String key) {
        List<Double> list = new ArrayList<>();
        Pattern pattern = Pattern.compile("\"" + key + "\":\\s*\\[(.*?)\\]", Pattern.DOTALL);
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            String content = matcher.group(1);
            String[] tokens = content.split(",");
            for (String t : tokens) {
                t = t.trim();
                if (!t.isEmpty() && !t.equals("null")) {
                    try {
                        list.add(Double.parseDouble(t));
                    } catch (NumberFormatException e) {
                        list.add(0.0);
                    }
                }
            }
        }
        return list;
    }
}
