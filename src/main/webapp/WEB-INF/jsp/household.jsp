<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>家計簿</title>

  <style>
    :root {
      --bg-color: #ffffff;
      --text-main: #333333;
      --sunday-color: #a94442;
      --saturday-color: #31708f;
      --gray-out: #999999;
      --border-color: #e5e5e5;
      --primary-blue: #0076ff;
      --income-blue: #0056b3;
      --expense-red: #d9534f;
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      padding: 0;
      background-color: #f7f7f7;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      color: var(--text-main);
      display: flex;
      justify-content: center;
      min-height: 100vh;
    }

    .app-container {
      width: 100%;
      max-width: 480px;
      background-color: var(--bg-color);
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    /* ヘッダー */
    .header {
      position: relative;
      display: flex;
      align-items: center;
      height: 56px;
      padding: 0 16px;
      border-bottom: 1px solid var(--border-color);
    }

    /* 年月表示 */
    .current-month {
      position: absolute;
      left: 50%;
      transform: translateX(-50%);
      font-size: 18px;
      font-weight: bold;
      white-space: nowrap;
    }

    /* 前月・次月ボタン */
    .nav-btn {
      position: absolute;
      background: none;
      border: none;
      font-size: 20px;
      cursor: pointer;
      color: var(--text-main);
      text-decoration: none;
      padding: 4px 8px;
    }

    /* 前月ボタン */
    .nav-prev {
      left: 110px;
    }

    /* 次月ボタン */
    .nav-next {
      right: 110px;
    }

    /* 収支目標ボタン */
    .target-btn {
      position: absolute;
      right: 8px;
      background-color: #f0f5fc;
      border: 1px solid var(--primary-blue);
      color: var(--primary-blue);
      border-radius: 6px;
      padding: 4px 8px;
      font-size: 10px;
      font-weight: bold;
      text-decoration: none;
    }

    /* メインコンテンツ */
    .content {
      flex: 1;
      padding-bottom: 16px;
    }

    /* カレンダー */
    .weekdays {
      display: grid;
      grid-template-columns: repeat(7, 1fr);
      text-align: center;
      font-weight: bold;
      padding: 8px 0;
      border-bottom: 1px solid var(--border-color);
      background-color: #fafafa;
      font-size: 14px;
    }

    .weekdays div:nth-child(1) {
      color: var(--sunday-color);
    }

    .weekdays div:nth-child(7) {
      color: var(--saturday-color);
    }

    .days-grid {
      display: grid;
      grid-template-columns: repeat(7, 1fr);
      grid-auto-rows: minmax(68px, 1fr);
      border-bottom: 1px solid var(--border-color);
    }

    .day-cell {
      border-right: 1px solid var(--border-color);
      border-bottom: 1px solid var(--border-color);
      padding: 4px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      cursor: pointer;
      background-color: #fff;
      text-decoration: none;
      color: inherit;
    }

    .day-cell:nth-child(7n) {
      border-right: none;
    }

    .day-num {
      font-size: 13px;
      font-weight: 500;
    }

    .sun .day-num {
      color: var(--sunday-color);
    }

    .sat .day-num {
      color: var(--saturday-color);
    }

    .other-month {
      background-color: #f2f2f2;
      color: var(--gray-out) !important;
    }

    .other-month .day-num {
      color: var(--gray-out) !important;
    }

    .balance-tag {
      font-size: 10px;
      font-weight: bold;
      text-align: center;
      margin-top: auto;
    }

    .balance-positive {
      color: var(--income-blue);
    }

    .balance-negative {
      color: var(--expense-red);
    }

    .balance-zero {
      color: #333;
    }

    /* 収支サマリーカード */
    .summary-card {
      margin: 10px 16px;
      padding: 12px;
      background: #fafafa;
      border: 1px solid var(--border-color);
      border-radius: 12px;
    }

    .card-title {
      font-size: 15px;
      font-weight: bold;
      margin-bottom: 5px;
      color: #15375f;
    }

    .summary-row {
      display: flex;
      justify-content: space-between;
      font-size: 14px;
      margin-bottom: 8px;
    }

    .summary-val {
      font-weight: bold;
    }

    /* AIアドバイスカード */
    .ai-card {
      margin: 0 16px 10px;
      padding: 12px;
      background: #eef7ff;
      border: 1px solid #b8daff;
      border-radius: 12px;
    }

    .ai-title {
      font-size: 14px;
      font-weight: bold;
      color: #004085;
      display: flex;
      align-items: center;
      gap: 6px;
      margin-bottom: 8px;
    }

    .ai-text {
      font-size: 13px;
      color: #004085;
      line-height: 1.5;
    }

    /* 下部ナビゲーション */
    .footer-nav {
      display: flex;
      justify-content: space-around;
      align-items: center;
      height: 60px;
      border-top: 1px solid var(--border-color);
      background-color: #ffffff;
    }

    .nav-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      font-size: 11px;
      color: #666666;
      text-decoration: none;
    }

    .nav-item.active {
      color: var(--primary-blue);
      font-weight: bold;
      pointer-events: none;
    }

    .nav-icon {
      font-size: 20px;
      margin-bottom: 2px;
    }
  </style>
</head>

<body>

  <div class="app-container">

    <!-- ヘッダー -->
    <header class="header">
      <!-- 前月 -->
      <a href="${pageContext.request.contextPath}/household?action=prev" class="nav-btn nav-prev">&lt;</a>

      <!-- 年月表示 -->
      <span class="current-month">${displayYearMonth}</span>

      <!-- 次月 -->
      <a href="${pageContext.request.contextPath}/household?action=next" class="nav-btn nav-next">&gt;</a>

      <!-- 収支目標 -->
      <a href="${pageContext.request.contextPath}/budget" class="target-btn">収支目標</a>
    </header>

    <div class="content">

      <!-- カレンダー -->
      <div class="weekdays">
        <div>日</div>
        <div>月</div>
        <div>火</div>
        <div>水</div>
        <div>木</div>
        <div>金</div>
        <div>土</div>
      </div>

      <div class="days-grid">
        <c:forEach var="cell" items="${calendarCells}" varStatus="status">
          <a class="day-cell ${cell.otherMonth ? 'other-month' : ''} ${status.index % 7 == 0 ? 'sun' : (status.index % 7 == 6 ? 'sat' : '')}"
             href="${pageContext.request.contextPath}/household/detail?date=${cell.dateStr}">
            <span class="day-num">${cell.dayNumber}</span>
            <c:if test="${cell.hasTransaction}">
              <span class="balance-tag ${cell.balanceCssClass}">${cell.formattedDailyBalance}</span>
            </c:if>
          </a>
        </c:forEach>
      </div>

      <!-- 今月の支出残高サマリー -->
      <div class="summary-card">
        <div class="card-title">今月の収支状況</div>
        <div class="summary-row">
          <span>収入予定額:</span>
          <span class="summary-val">${formattedTargetIncome}</span>
        </div>
        <div class="summary-row">
          <span>目標支出額:</span>
          <span class="summary-val">${formattedTargetExpense}</span>
        </div>
        <div class="summary-row">
          <span>今月の合計出費:</span>
          <span class="summary-val" style="color: var(--expense-red);">${formattedTotalExpense}</span>
        </div>
        <div class="summary-row">
          <span>現在の支出残額:</span>
          <span class="summary-val" style="color: var(--income-blue);">${formattedRemainingExpense}</span>
        </div>
        <div class="summary-row">
          <span>目標到達率:</span>
          <span class="summary-val">${achievementRate}</span>
        </div>
      </div>

      <!-- AIによるアドバイス -->
      <div class="ai-card">
        <div class="ai-title">🤖 AIによるアドバイス</div>
        <div class="ai-text"><c:out value="${aiAdviceText}"/></div>
      </div>

    </div>

    <!-- 下部ナビゲーション -->
    <nav class="footer-nav">
      <a class="nav-item" href="${pageContext.request.contextPath}/home">
        <span class="nav-icon">📅</span>
        <span>カレンダー</span>
      </a>

      <a class="nav-item active" href="${pageContext.request.contextPath}/household">
        <span class="nav-icon">💰</span>
        <span>家計簿</span>
      </a>

      <a class="nav-item" href="${pageContext.request.contextPath}/logout">
        <span class="nav-icon">🚪</span>
        <span>ログアウト</span>
      </a>
    </nav>

  </div>

</body>
</html>
