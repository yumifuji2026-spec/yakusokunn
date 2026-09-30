<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>カレンダーアプリ</title>

  <style>
    :root {
      --bg-color: #ffffff;
      --text-main: #333333;
      --sunday-color: #a94442;
      --saturday-color: #31708f;
      --gray-out: #999999;
      --border-color: #e5e5e5;
      --primary-blue: #0076ff;
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      padding: 0;
      background-color: #f7f7f7;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
        "Helvetica Neue", Arial, sans-serif;
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
      height: 100vh;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      position: relative;
    }

    .header {
      position: relative;
      height: 56px;
      display: flex;
      align-items: center;
      border-bottom: 1px solid var(--border-color);
    }

    .current-month {
      position: absolute;
      left: 50%;
      transform: translateX(-50%);
      font-size: 18px;
      font-weight: bold;
      white-space: nowrap;
    }

    .nav-btn {
      position: absolute;
      background: none;
      border: none;
      font-size: 20px;
      cursor: pointer;
      color: var(--text-main);
      padding: 4px 8px;
      text-decoration: none;
    }

    .nav-prev {
      left: 110px;
    }

    .nav-next {
      right: 110px;
    }

    .calendar-container {
      flex: 1;
      display: flex;
      flex-direction: column;
      overflow-y: auto;
    }

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
      grid-auto-rows: minmax(112px, 1fr);
      flex: 1;
    }

    .day-cell {
      border-right: 1px solid var(--border-color);
      border-bottom: 1px solid var(--border-color);
      padding: 4px;
      display: flex;
      flex-direction: column;
      cursor: pointer;
      position: relative;
      background-color: #fff;
      text-decoration: none;
      color: inherit;
      overflow: hidden;
    }

    .day-cell:nth-child(7n) {
      border-right: none;
    }

    .day-top {
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-shrink: 0;
    }

    .day-num {
      font-size: 13px;
      font-weight: 500;
      line-height: 1;
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

    /* 天気表示 */
    .weather-info {
      display: flex;
      align-items: center;
      gap: 2px;
      line-height: 1;
    }

    .weather-icon {
      width: 14px;
      height: 14px;
      object-fit: contain;
    }

    .weather-pop {
      color: var(--primary-blue);
      font-weight: bold;
      font-size: 9px;
      white-space: nowrap;
    }

    /* スケジュール表示エリア */
    .schedule-list {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: center;   /* 上下中央 */
      align-items: center;       /* 左右中央 */
      gap: 3px;
      margin-top: 4px;
      overflow: hidden;
    }

    .schedule-tag {
      width: 90%;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;       /* 文字を左右中央 */
      text-align: center;        /* 文字を中央揃え */
      font-size: 13px;
      font-weight: 500;
      line-height: 1.3;
      padding: 4px 3px;
      color: #000;
      border-radius: 6px;
      overflow: hidden;
      min-height: 45px;
    }

    .schedule-tag > * {
      max-width: 100%;
    }

    .schedule-time {
      display: block;
      font-size: 12px;
      font-weight: 700;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .schedule-label {
      display: block;
      font-size: 12px;
      white-space: nowrap;
      overflow: hidden;
    }

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
      background: none;
      border: none;
      cursor: pointer;
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
      <a href="${pageContext.request.contextPath}/home?action=prev" class="nav-btn nav-prev">&lt;</a>
      <span class="current-month">${displayYearMonth}</span>
      <a href="${pageContext.request.contextPath}/home?action=next" class="nav-btn nav-next">&gt;</a>
    </header>

    <!-- カレンダー -->
    <main class="calendar-container">

      <!-- 曜日 -->
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
        <c:forEach var="c" items="${calendarCells}" varStatus="status">
          <a class="day-cell ${c.otherMonth ? 'other-month' : ''} ${status.index % 7 == 0 ? 'sun' : (status.index % 7 == 6 ? 'sat' : '')}"
             href="${pageContext.request.contextPath}/schedule?date=${c.dateStr}">
            <div class="day-top">
              <span class="day-num">${c.dayNumber}</span>
              <c:if test="${not empty c.weather}">
                <div class="weather-info">
                  <img src="${pageContext.request.contextPath}/images/weather/${c.weather.iconName}" alt="${c.weather.weatherState}" class="weather-icon">
                  <span class="weather-pop">【${c.weather.precipitationProbability}%】</span>
                </div>
              </c:if>
            </div>

            <div class="schedule-list">
              <c:if test="${not empty c.schedule}">
                <div class="schedule-tag" style="background-color:${c.schedule.categoryColorCode};">
                  <span class="schedule-time">${c.schedule.formattedStartTime}</span>
                  <span class="schedule-label">${c.schedule.categoryName}</span>
                </div>
              </c:if>
            </div>
          </a>
        </c:forEach>
      </div>

    </main>

    <!-- 下部ナビゲーション -->
    <footer class="footer-nav">
      <button class="nav-item active" type="button">
        <span class="nav-icon">📅</span>
        <span>カレンダー</span>
      </button>

      <a href="${pageContext.request.contextPath}/household" class="nav-item">
        <span class="nav-icon">💰</span>
        <span>家計簿</span>
      </a>

      <a href="${pageContext.request.contextPath}/logout" class="nav-item">
        <span class="nav-icon">🚪</span>
        <span>ログアウト</span>
      </a>
    </footer>

  </div>

<c:if test="${not empty alarmTitle}">
<script>
  (function() {
    const title = "${alarmTitle}";
    const startTime = "${alarmStartTime}";
    const endTime = "${alarmEndTime}";
    const memo = "${alarmMemo}";
    const alarmMinutes = parseInt("${alarmMinutesBefore}") || 0;

    const now = new Date();
    const todayStr = new Date().toISOString().split('T')[0];
    const targetStart = new Date(todayStr + "T" + startTime + ":00");
    const alarmTime = new Date(targetStart.getTime() - alarmMinutes * 60000);

    const diff = alarmTime.getTime() - now.getTime();
    if (diff > 0 && diff < 86400000) {
      setTimeout(function() {
        alert("【予定アラーム通知】\nタイトル: " + title + "\n開始: " + startTime + "\n終了: " + endTime + (memo ? "\n内容: " + memo : ""));
      }, diff);
    } else if (now >= alarmTime && now <= targetStart) {
      alert("【予定アラーム通知】\nタイトル: " + title + "\n開始: " + startTime + "\n終了: " + endTime + (memo ? "\n内容: " + memo : ""));
    }
  })();
</script>
</c:if>

</body>
</html>
