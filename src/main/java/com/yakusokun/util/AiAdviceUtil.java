package com.yakusokun.util;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Properties;

public class AiAdviceUtil {

    public static String generateAdvice(int targetExpense, int totalExpense, int remainingExpense, double achievementRate, Map<String, Integer> categoryExpenses) {
        String apiKey = getApiKey();
        if (apiKey != null && !apiKey.trim().isEmpty()) {
            try {
                return callGeminiApi(apiKey, targetExpense, totalExpense, remainingExpense, achievementRate, categoryExpenses);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return generateFallbackAdvice(targetExpense, totalExpense, remainingExpense, achievementRate, categoryExpenses);
    }

    private static String getApiKey() {
        String key = System.getenv("GEMINI_API_KEY");
        if (key != null && !key.trim().isEmpty()) {
            return key.trim();
        }
        try (InputStream input = AiAdviceUtil.class.getClassLoader().getResourceAsStream("yakusokun.properties")) {
            if (input != null) {
                Properties props = new Properties();
                props.load(input);
                String propKey = props.getProperty("gemini.api.key");
                if (propKey != null && !propKey.trim().isEmpty()) {
                    return propKey.trim();
                }
            }
        } catch (Exception ignored) {
        }
        try (InputStream input = AiAdviceUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                Properties props = new Properties();
                props.load(input);
                String propKey = props.getProperty("gemini.api.key");
                if (propKey != null && !propKey.trim().isEmpty()) {
                    return propKey.trim();
                }
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    private static String callGeminiApi(String apiKey, int targetExpense, int totalExpense, int remainingExpense, double achievementRate, Map<String, Integer> categoryExpenses) throws Exception {
        String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=" + apiKey;
        URL url = URI.create(endpoint).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; utf-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(50000);
        conn.setReadTimeout(50000);

        StringBuilder prompt = new StringBuilder();
        prompt.append("あなたは親切な家計アドバイザーです。以下の支出状況に基づいて、短く前向きなアドバイスを日本語2〜3文で出力してください。\\n");
        prompt.append("目標出費額: ").append(targetExpense).append("円\\n");
        prompt.append("今月の支出合計: ").append(totalExpense).append("円\\n");
        prompt.append("現在の支出残高: ").append(remainingExpense).append("円\\n");
        prompt.append("目標到達比率: ").append(String.format("%.1f", achievementRate)).append("%\\n");
        if (categoryExpenses != null && !categoryExpenses.isEmpty()) {
            prompt.append("カテゴリ別支出: ").append(categoryExpenses.toString()).append("\\n");
        }

        String jsonInputString = "{\"contents\":[{\"parts\":[{\"text\":\"" + escapeJson(prompt.toString()) + "\"}]}]}";

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int code = conn.getResponseCode();
        if (code == 200) {
            try (InputStream is = conn.getInputStream()) {
                String resp = new String(is.readAllBytes(), StandardCharsets.UTF_8);
                int textIdx = resp.indexOf("\"text\": \"");
                if (textIdx != -1) {
                    int start = textIdx + 9;
                    int end = resp.indexOf("\"", start);
                    if (end != -1) {
                        String text = resp.substring(start, end);
                        return unescapeJson(text);
                    }
                }
            }
        }
        return generateFallbackAdvice(targetExpense, totalExpense, remainingExpense, achievementRate, categoryExpenses);
    }

    private static String generateFallbackAdvice(int targetExpense, int totalExpense, int remainingExpense, double achievementRate, Map<String, Integer> categoryExpenses) {
        if (targetExpense <= 0) {
            return "収支目標が設定されていません。まずは目標出費額を設定して、計画的な家計管理を始めましょう！";
        }
        if (achievementRate <= 50.0) {
            return String.format("今月の出費は目標の%.1f%%に抑えられています！非常に素晴らしいペースです。", achievementRate);
        } else if (achievementRate <= 80.0) {
            return String.format("今月の出費は目標の%.1f%%です。順調に管理できています。この調子を維持しましょう！", achievementRate);
        } else if (achievementRate <= 100.0) {
            return String.format("今月の出費は目標の%.1f%%に達しています。残りの日数も節約を意識して過ごしましょう。", achievementRate);
        } else {
            return String.format("今月の出費が目標を%.1f%%超過しています。支出の内訳を見直して調整しましょう。", achievementRate);
        }
    }

    private static String escapeJson(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    private static String unescapeJson(String s) {
        return s.replace("\\n", "\n").replace("\\\"", "\"").replace("\\\\", "\\");
    }
}
