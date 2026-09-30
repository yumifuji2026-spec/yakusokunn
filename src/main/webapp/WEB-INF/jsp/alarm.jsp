<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>予定アラーム</title>

<style>
  /* ========================================
     Base
  ======================================== */

  * {
    box-sizing: border-box;
  }

  html,
  body {
    margin: 0;
    padding: 0;
    width: 100%;
    min-height: 100%;

    font-family:
      -apple-system,
      BlinkMacSystemFont,
      "Segoe UI",
      "Noto Sans JP",
      "Hiragino Kaku Gothic ProN",
      "Hiragino Sans",
      Meiryo,
      sans-serif;

    background: #f4f6f8;
    color: #17191c;

    -webkit-font-smoothing: antialiased;
  }

  body {
    display: flex;
    justify-content: center;
    align-items: center;

    min-height: 100vh;
  }


  /* ========================================
     Phone
     ※ 元のclass名を維持
  ======================================== */

  .phone {
    width: min(100vw, 467px);
    min-height: auto;

    display: flex;
    flex-direction: column;

    background: #f7f8fa;

    overflow: hidden;
    position: relative;

    border-radius: 0;
  }


  /* ========================================
     Top Bar
  ======================================== */

  .top-bar {
    height: 68px;
    flex: 0 0 68px;

    position: relative;

    display: flex;
    align-items: center;
    justify-content: center;

    background: rgba(247, 248, 250, 0.94);

    border-bottom: 1px solid rgba(0, 0, 0, 0.045);

    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
  }


  /* 元HTMLのhandleは残すが表示しない */

  .handle {
    display: none;
  }


  /* ========================================
     Back button
  ======================================== */

  .back {
    position: absolute;

    left: 20px;
    top: 50%;

    transform: translateY(-50%);

    display: flex;
    align-items: center;

    height: 40px;

    padding: 0 8px 0 0;

    border: 0;
    background: transparent;

    color: #1677ff;

    font-size: 15px;
    font-weight: 600;

    cursor: pointer;

    -webkit-tap-highlight-color: transparent;
  }

  .back .arrow {
    color: #1677ff;

    font-size: 34px;
    font-weight: 300;

    line-height: 1;

    margin-right: 3px;

    transform: translateY(-1px);
  }


  /* ========================================
     Page title
  ======================================== */

  .page-title {
    font-size: 18px;
    font-weight: 750;

    letter-spacing: -0.02em;
  }


  /* ========================================
     Card
  ======================================== */

  .card {
    margin: 22px 16px 0;
    padding: 0;

    border-radius: 18px;

    background: #ffffff;

    border: 1px solid #e5e7eb;

    box-shadow:
      0 2px 8px rgba(0, 0, 0, 0.025),
      0 8px 24px rgba(0, 0, 0, 0.035);

    overflow: hidden;
  }


  /* ========================================
     Rows
  ======================================== */

  .row {
    display: flex;
    align-items: center;

    min-height: 68px;

    margin: 0;
    padding: 11px 16px;

    border-bottom: 1px solid #edf0f2;
  }

  .row:last-child {
    border-bottom: 0;
  }


  /* ========================================
     Labels
  ======================================== */

  .label {
    width: 88px;
    flex: 0 0 88px;

    color: #555a62;

    font-size: 13px;
    font-weight: 650;

    letter-spacing: 0.01em;

    white-space: nowrap;
  }


  /* ========================================
     Common fields
  ======================================== */

  .field {
    height: 43px;

    border: 1px solid #dfe3e8;
    border-radius: 11px;

    background: #f9fafb;

    color: #17191c;

    font-size: 16px;
    font-weight: 500;

    padding: 5px 12px;

    outline: none;

    transition:
      border-color 0.18s ease,
      background-color 0.18s ease,
      box-shadow 0.18s ease;
  }

  .field::placeholder {
    color: #a3a8af;
  }

  .field:focus {
    border-color: #1677ff;

    background: #ffffff;

    box-shadow:
      0 0 0 3px rgba(22, 119, 255, 0.10);
  }


  /* ========================================
     Date
  ======================================== */

  .date-wrap {
    flex: 1;

    position: relative;

    min-width: 0;
  }

  .date-wrap input {
    width: 100%;

    padding-right: 42px;
  }


  /* ========================================
     Title
  ======================================== */

  .title-input {
    flex: 1;

    width: 0;
  }


  /* ========================================
     Category
  ======================================== */

  .category-wrap,
  .alarm-wrap {
    position: relative;

    flex: 1;

    min-width: 0;
  }

  .category-select,
  .alarm-select {
    width: 100%;
    height: 43px;

    border: 1px solid #dfe3e8;
    border-radius: 11px;

    background: #f9fafb;

    color: #202328;

    font-size: 15px;
    font-weight: 600;

    padding: 0 40px 0 43px;

    appearance: none;
    -webkit-appearance: none;

    outline: none;

    cursor: pointer;
  }

  .category-select:focus,
  .alarm-select:focus {
    border-color: #1677ff;

    background: #ffffff;

    box-shadow:
      0 0 0 3px rgba(22, 119, 255, 0.10);
  }

  .category-dot {
    position: absolute;

    z-index: 2;
    left: 12px;
    top: 50%;

    width: 21px;
    height: 21px;

    transform: translateY(-50%);

    border-radius: 50%;

    background: #ef879b;

    box-shadow:
      inset 0 0 0 3px rgba(255, 255, 255, 0.35);

    pointer-events: none;
  }


  /* ========================================
     Select arrows
  ======================================== */

  .select-arrows {
    display: none;
  }


  /* ========================================
     Time
  ======================================== */

  .time-row {
    align-items: center;

    min-height: 88px;
  }

  .time-label {
    align-self: center;
  }

  .time-group {
    display: flex;
    align-items: center;

    flex: 1;

    min-width: 0;
  }

  .time-box {
    width: 50%;

    height: 61px;

    position: relative;
    padding-top: 15px;
  }

  .time-box input {
    width: 100%;
    height: 43px;

    padding-right: 29px;

    text-align: center;

    font-variant-numeric: tabular-nums;
  }

  .time-caption {
    position: absolute;

    top: 0;
    left: 4px;

    color: #858a92;

    font-size: 10px;
    font-weight: 650;

    line-height: 14px;

    white-space: nowrap;
  }

  .time-spinner {
    display: none;
  }

  .dash {
    width: 20px;

    color: #9a9fa6;

    text-align: center;

    font-size: 15px;
    font-weight: 600;
  }


  /* ========================================
     Memo
  ======================================== */

  .memo-input {
    flex: 1;

    width: 0;
  }


  /* ========================================
     Alarm
  ======================================== */

  .alarm-select {
    padding-left: 42px;
  }


  /* ========================================
     Register button
  ======================================== */

  .register {
    display: block;

    width: calc(100% - 32px);
    height: 54px;

    margin: 20px 16px 24px;

    border: 0;
    border-radius: 15px;

    background:
      linear-gradient(
        180deg,
        #2182ff 0%,
        #1677ee 100%
      );

    color: #ffffff;

    font-size: 16px;
    font-weight: 700;

    letter-spacing: 0.01em;

    cursor: pointer;

    box-shadow:
      0 6px 16px rgba(22, 119, 255, 0.22);

    transition:
      transform 0.12s ease,
      box-shadow 0.18s ease,
      filter 0.18s ease;
  }

  .register:hover {
    filter: brightness(0.98);

    box-shadow:
      0 8px 20px rgba(22, 119, 255, 0.27);
  }

  .register:active {
    transform: translateY(1px);

    box-shadow:
      0 3px 10px rgba(22, 119, 255, 0.20);
  }


  /* ========================================
     元HTMLのsparkleは残すが非表示
  ======================================== */

  .sparkle {
    display: none;
  }


  /* ========================================
     縦長画面
     画面が高い場合だけ余白を自然に増やす
  ======================================== */

  @media (min-height: 760px) {

    .card {
      margin-top: 28px;
    }

    .register {
      margin-top: 26px;
    }
  }


  @media (min-height: 850px) {

    .card {
      margin-top: 36px;
    }

    .register {
      margin-top: 32px;
    }
  }


  @media (min-height: 950px) {

    .card {
      margin-top: 44px;
    }

    .register {
      margin-top: 38px;
    }
  }


  /* ========================================
     Mobile
  ======================================== */

  @media (max-width: 390px) {

    .back {
      left: 14px;
    }

    .card {
      margin-left: 12px;
      margin-right: 12px;

      border-radius: 16px;
    }

    .register {
      width: calc(100% - 24px);

      margin-left: 12px;
      margin-right: 12px;
    }

    .row {
      padding-left: 13px;
      padding-right: 13px;
    }

    .label {
      width: 76px;
      flex-basis: 76px;

      font-size: 12px;
    }

    .field,
    .category-select,
    .alarm-select {
      font-size: 14px;
    }

    .time-box {
      width: 50%;
    }
  }


  /* ========================================
     Very small screen
  ======================================== */

  @media (max-width: 340px) {

    .label {
      width: 70px;
      flex-basis: 70px;
    }

    .time-group {
      gap: 2px;
    }

    .dash {
      width: 14px;
    }
  }


  /* ========================================
     縦長 + スマホ
  ======================================== */

  @media (max-width: 480px) and (min-height: 760px) {

    .card {
      margin-top: 26px;
    }

    .register {
      margin-top: 28px;
    }
  }


  @media (max-width: 480px) and (min-height: 850px) {

    .card {
      margin-top: 34px;
    }

    .register {
      margin-top: 34px;
    }
  }

  .error-message {
    margin: 10px 16px;
    color: #d9534f;
    font-weight: bold;
    font-size: 14px;
  }
</style>
</head>


<body>

  <main class="phone">

    <header class="top-bar">

      <!-- 元の要素を維持 -->
      <div class="handle"></div>

      <button
        class="back"
        type="button"
        id="backBtn"
      >
        <span class="arrow">‹</span>戻る
      </button>

      <div class="page-title">
        予定アラーム
      </div>

    </header>

    <c:if test="${not empty error}">
      <div class="error-message"><c:out value="${error}"/></div>
    </c:if>

    <form id="alarmForm" action="${pageContext.request.contextPath}/alarm" method="post">
      <input type="hidden" name="id" value="${schedule.id}">

      <section class="card">

        <!-- 日付 -->
        <div class="row">

          <label
            class="label"
            for="date"
          >
            日付:
          </label>

          <div class="date-wrap">

            <input
              class="field"
              id="date"
              name="day_time"
              type="date"
              value="${schedule.formattedDate}"
              required
            >

          </div>

        </div>


        <!-- タイトル -->
        <div class="row">

          <label
            class="label"
            for="title"
          >
            タイトル:
          </label>

          <input
            class="field title-input"
            id="title"
            name="title"
            type="text"
            value="${schedule.title}"
            required
          >

        </div>


        <!-- カテゴリー -->
        <div class="row">

          <label
            class="label"
            for="category"
          >
            カテゴリー:
          </label>

          <div class="category-wrap">

            <span class="category-dot"></span>

            <select
              class="category-select"
              id="category"
              name="category_id"
              required
            >
              <c:forEach var="cat" items="${categories}">
                <option value="${cat.id}" ${cat.id == schedule.categoryId ? 'selected' : ''}>${cat.name}</option>
              </c:forEach>
            </select>

            <span class="select-arrows"></span>

          </div>

        </div>


        <!-- 時間設定 -->
        <div class="row time-row">

          <label class="label time-label">
            時間設定:
          </label>

          <div class="time-group">

            <div class="time-box">

              <span class="time-caption">
                開始時間
              </span>

              <input
                class="field"
                name="start_time"
                type="time"
                value="${schedule.formattedStartTime}"
                required
              >

              <span class="time-spinner"></span>

            </div>


            <div class="dash">
              -
            </div>


            <div class="time-box">

              <span class="time-caption">
                終了時間
              </span>

              <input
                class="field"
                name="end_time"
                type="time"
                value="${schedule.formattedEndTime}"
                required
              >

              <span class="time-spinner"></span>

            </div>

          </div>

        </div>


        <!-- 内容 -->
        <div class="row">

          <label
            class="label"
            for="memo"
          >
            内容:
          </label>

          <input
            class="field memo-input"
            id="memo"
            name="memo"
            type="text"
            value="${schedule.memo}"
          >

        </div>


        <!-- アラーム -->
        <div class="row">

          <label
            class="label"
            for="alarm"
          >
            アラーム:
          </label>

          <div class="alarm-wrap">

            <input type="hidden" name="has_alarm" id="hasAlarmInput" value="true">

            <select
              class="alarm-select"
              id="alarm"
              name="alarm_minutes_before"
              onchange="updateAlarmState()"
            >
              <option value="60" ${schedule.alarmMinutesBefore == 60 ? 'selected' : ''}>1時間前</option>
              <option value="30" ${schedule.alarmMinutesBefore == 30 ? 'selected' : ''}>30分前</option>
              <option value="15" ${schedule.alarmMinutesBefore == 15 ? 'selected' : ''}>15分前</option>
              <option value="0" ${!schedule.hasAlarm || schedule.alarmMinutesBefore == 0 ? 'selected' : ''}>なし</option>
            </select>

            <span class="select-arrows"></span>

          </div>

        </div>

      </section>


      <!-- 登録ボタン -->
      <button
        class="register"
        type="submit"
      >
        登録 <span class="sparkle">✦</span>
      </button>

    </form>

  </main>


<script>
function updateAlarmState() {
  var alarmVal = document.getElementById("alarm").value;
  var hasAlarmInput = document.getElementById("hasAlarmInput");
  if (alarmVal === "0") {
    hasAlarmInput.value = "false";
  } else {
    hasAlarmInput.value = "true";
  }
}

document.addEventListener("DOMContentLoaded", function() {
  updateAlarmState();
  const form = document.getElementById("alarmForm");
  const backBtn = document.getElementById("backBtn");
  if (!form || !backBtn) return;

  const initialData = new FormData(form);
  function isFormModified() {
    const currentData = new FormData(form);
    for (let [key, val] of currentData.entries()) {
      if (initialData.get(key) !== val) return true;
    }
    return false;
  }

  backBtn.addEventListener("click", function(e) {
    e.preventDefault();
    if (isFormModified()) {
      if (confirm("予定の変更を破棄してもよろしいですか")) {
        window.location.href = "${pageContext.request.contextPath}/schedule";
      }
    } else {
      window.location.href = "${pageContext.request.contextPath}/schedule";
    }
  });
});
</script>

</body>
</html>
