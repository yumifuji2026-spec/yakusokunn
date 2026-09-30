<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>スケジュール管理</title>

<style>
    * {
        box-sizing: border-box;
    }

    html,
    body {
        margin: 0;
        padding: 0;
        width: 100%;
        min-height: 100%;
        overflow-x: hidden;
    }

    body {
        background: #f2f2f2;
        font-family:
            -apple-system,
            BlinkMacSystemFont,
            "Helvetica Neue",
            "Noto Sans JP",
            Arial,
            sans-serif;
        color: #222;
        display: flex;
        justify-content: center;
    }

    /* スマートフォン画面 */
    .phone {
        width: 100%;
        max-width: 480px;
        min-height: 100vh;
        margin: 0 auto;
        background: #ffffff;
        border-radius: 28px;
        overflow: hidden;
        box-shadow: 0 2px 15px rgba(0, 0, 0, 0.12);
        position: relative;
    }

    .container {
        width: 100%;
        padding: 20px 18px 10px;
    }

    /* ヘッダー */
    .header {
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        min-height: 40px;
        margin-bottom: 18px;
    }

    .back {
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        font-size: 16px;
        font-weight: 600;
        color: #222;
        text-decoration: none;
        white-space: nowrap;
    }

    .date-title {
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        margin: 0;
        padding: 4px 0;
        font-size: 18px;
        font-weight: 700;
        line-height: 1.5;
        white-space: nowrap;
    }

    /* 天気 */
    .weather-box {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
        height: 78px;
        padding: 10px 20px;
        background: #ffffff;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        margin-bottom: 10px;
    }

    .weather-left {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .weather-icon {
        font-size: 42px;
        display: flex;
        align-items: center;
    }

    .temperature {
        font-size: 31px;
        font-weight: 700;
    }

    .weather-label {
        display: inline-block;
        margin-top: 2px;
        padding: 3px 14px;
        background: #2f80ed;
        color: #fff;
        border-radius: 15px;
        font-size: 12px;
        font-weight: 600;
    }

    .weather-right {
        text-align: right;
        font-size: 12px;
        line-height: 1.7;
        color: #555;
    }

    .high {
        color: #e74c3c;
        font-weight: 700;
    }

    .low {
        color: #3498db;
        font-weight: 700;
    }

    /* スケジュール */
    .schedule-title {
        margin: 15px 0 8px;
        padding: 3px 0;
        height: 24px;
        font-size: 13px;
        font-weight: 700;
        line-height: 18px;
        color: #555;
    } 

    .schedule-list {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .schedule-row {
        display: flex;
        align-items: center;
        width: 100%;
        height: 70px;
    }

    .time {
        width: 68px;
        flex-shrink: 0;
        font-size: 17px;
        font-weight: 600;
        color: #555;
        white-space: nowrap;
    }

    .time.current {
        color: #e53935;
    }

    /* 予定カード */
    .schedule-card {
        position: relative;
        flex: 1;
        min-width: 0;
        height: 64px;
        padding: 5px 12px 5px 18px;
        border-radius: 14px;
        border-left: 4px solid;
        display: flex;
        align-items: center;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.04);
        overflow: hidden;
    }

    /* カテゴリカラー */
    .category-01 { background: #FFADAD; border-left-color: #FF6B6B; }
    .category-02 { background: #A0C4FF; border-left-color: #4D96FF; }
    .category-03 { background: #FDFFB6; border-left-color: #D9D900; }
    .category-04 { background: #CAFFBF; border-left-color: #63C132; }
    .category-05 { background: #FFC6FF; border-left-color: #FF69B4; }
    .category-06 { background: #9BF6FF; border-left-color: #00B8D4; }
    .category-07 { background: #FFD6A5; border-left-color: #FF9F43; }
    .category-08 { background: #D9D9D9; border-left-color: #777777; }

    .schedule-info {
        flex: 1;
        min-width: 0;
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: center;
        overflow: hidden;
        cursor: pointer;
    }

    .schedule-name {
        font-size: 14px;
        font-weight: 700;
        line-height: 20px;
        min-height: 20px;
        padding: 2px 0;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .schedule-time {
        font-size: 11px;
        color: #666;
        margin-bottom: 3px;
    }

    .schedule-time::before {
        content: "";
        font-size: 12px;
    }

    /* カテゴリ名 */
    .category-name {
        display: inline-block;
        width: 42px;
        height: 16px;
        padding: 1px 0;
        line-height: 14px;
        text-align: center;
        border-radius: 10px;
        font-size: 9px;
        font-weight: 700;
        background: rgba(255, 255, 255, 0.65);
        white-space: nowrap;
    }

    /* カテゴリ名の文字色 */
    .category-01 .category-name { color: #c0392b; }
    .category-02 .category-name { color: #2365b5; }
    .category-03 .category-name { color: #777700; }
    .category-04 .category-name { color: #32801b; }
    .category-05 .category-name { color: #d63384; }
    .category-06 .category-name { color: #007c91; }
    .category-07 .category-name { color: #b45f06; }
    .category-08 .category-name { color: #555; }

    /* 右側 */
    .schedule-right {
        width: 58px;
        flex-shrink: 0;
        text-align: right;
        align-self: stretch;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        align-items: flex-end;
        padding: 1px 0;
    }

    .menu {
        font-size: 20px;
        font-weight: 700;
        line-height: 1;
        letter-spacing: 1px;
        cursor: pointer;
        user-select: none;
    }

    .alarm {
        display: flex;
        align-items: center;
        gap: 4px;
        cursor: pointer;
        user-select: none;
    }

    .alarm-text {
        font-size: 9px;
        color: #777;
    }

    /* アラームON/OFF */
    .switch {
        width: 44px;
        height: 25px;
        background: #ccc;
        border-radius: 15px;
        position: relative;
        transition: background 0.2s ease;
    }

    .switch::after {
        content: "";
        position: absolute;
        width: 21px;
        height: 21px;
        top: 2px;
        left: 2px;
        background: #fff;
        border-radius: 50%;
        box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        transition: left 0.2s ease;
    }

    .switch.on {
        background: #1683e8;
    }

    .switch.on::after {
        left: 21px;
    }

    /* 追加ボタン */
    .add-button {
        position: fixed;
        right: max(
            18px,
            calc((100vw - 480px) / 2 + 18px)
        );
        bottom: 8px;
        width: 46px;
        height: 46px;
        border-radius: 50%;
        border: none;
        background: #1683e8;
        color: #fff;
        font-size: 29px;
        font-weight: 300;
        line-height: 46px;
        box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        cursor: pointer;
        padding: 0;
    }

    .add-button:hover {
        opacity: 0.9;
    }

    /* スマートフォン */
    @media (max-width: 480px) {
        .phone {
            width: 100%;
            max-width: 480px;
            border-radius: 0;
            box-shadow: none;
        }

        .container {
            width: 100%;
            padding-left: 14px;
            padding-right: 14px;
        }

        .weather-box {
            padding-left: 15px;
            padding-right: 15px;
        }

        .time {
            width: 65px;
        }

        .schedule-card {
            padding-left: 12px;
        }
    }
</style>
</head>

<body>

<div class="phone">
    <div class="container">

        <!-- ヘッダー -->
        <div class="header">
            <a href="${pageContext.request.contextPath}/home" class="back">
                &lt; 戻る
            </a>
            <div class="date-title">
                <c:out value="${displayDate}"/>
            </div>
        </div>

        <!-- 天気 -->
        <div class="weather-box">
            <c:choose>
                <c:when test="${not empty weatherDetail}">
                    <div class="weather-left">
                        <div class="weather-icon">
                            <img src="${pageContext.request.contextPath}/images/weather/${weatherDetail.iconName}" alt="${weatherDetail.weatherState}" style="width:36px; height:36px; object-fit:contain;">
                        </div>
                        <div>
                            <div class="temperature">
                                ${weatherDetail.temperatureMax}℃
                            </div>
                            <div class="weather-label">
                                ${weatherDetail.weatherState}
                            </div>
                        </div>
                    </div>
                    <div class="weather-right">
                        最高
                        <span class="high">
                            ${weatherDetail.temperatureMax}℃
                        </span>
                        /
                        最低
                        <span class="low">
                            ${weatherDetail.temperatureMin}℃
                        </span>
                        <br>
                        降水確率 ${weatherDetail.precipitationProbability}%
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="width:100%; text-align:center; color:#64748b; font-size:14px;">
                        天気情報: 予報対象外
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- スケジュール -->
        <div class="schedule-title">
            スケジュール
        </div>

        <div class="schedule-list">
            <c:choose>
                <c:when test="${not empty schedules}">
                    <c:forEach var="s" items="${schedules}">
                        <div class="schedule-row">
                            <div class="time">
                                ${s.formattedStartTime}
                            </div>

                            <div class="schedule-card ${s.categoryClass}">
                                <div class="schedule-info" onclick="selectSchedule(${s.id})">
                                    <div class="schedule-name">
                                        <c:out value="${s.title}"/>
                                    </div>
                                    <div class="schedule-time">
                                        ${s.formattedStartTime} - ${s.formattedEndTime}
                                    </div>
                                    <span class="category-name">
                                        <c:out value="${s.categoryName}"/>
                                    </span>
                                </div>

                                <div class="schedule-right">
                                    <div class="menu" onclick="confirmDelete(event, ${s.id})" title="削除">
                                        •••
                                    </div>

                                    <div class="alarm" onclick="toggleAlarm(event, ${s.id})">
                                        <div class="switch ${s.hasAlarm ? 'on' : ''}"></div>
                                        <span class="alarm-text">
                                            ${s.hasAlarm ? 'ON' : 'OFF'}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center; color:#94a3b8; padding:40px 0; font-size:14px;">
                        予定はありません
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</div>

<!-- 予定追加ボタン -->
<form action="${pageContext.request.contextPath}/schedule" method="post">
    <input type="hidden" name="action" value="new">
    <button type="submit" class="add-button">＋</button>
</form>

<!-- 非表示フォーム -->
<form id="selectForm" action="${pageContext.request.contextPath}/schedule" method="post" style="display:none;">
    <input type="hidden" name="action" value="select">
    <input type="hidden" name="id" id="selectedScheduleId">
</form>

<form id="deleteForm" action="${pageContext.request.contextPath}/schedule" method="post" style="display:none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="id" id="deleteScheduleId">
</form>

<form id="toggleAlarmForm" action="${pageContext.request.contextPath}/schedule" method="post" style="display:none;">
    <input type="hidden" name="action" value="toggleAlarm">
    <input type="hidden" name="id" id="toggleAlarmId">
</form>

<script>
    function selectSchedule(id) {
        document.getElementById('selectedScheduleId').value = id;
        document.getElementById('selectForm').submit();
    }

    function confirmDelete(event, id) {
        event.stopPropagation();
        if (confirm('予定を削除してよろしいですか？')) {
            document.getElementById('deleteScheduleId').value = id;
            document.getElementById('deleteForm').submit();
        }
    }

    function toggleAlarm(event, id) {
        event.stopPropagation();
        document.getElementById('toggleAlarmId').value = id;
        document.getElementById('toggleAlarmForm').submit();
    }
</script>

</body>
</html>
