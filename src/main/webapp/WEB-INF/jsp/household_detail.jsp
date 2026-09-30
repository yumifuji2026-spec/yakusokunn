<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>収支管理一覧</title>
<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        padding: 0;
        background: #f7f7f7;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        color: #222222;

        display: flex;
        justify-content: center;
        align-items: flex-start;
        min-height: 100vh;
    }

    .screen {
        width: 100%;
        max-width: 480px;
        min-height: 100vh;
        background: #ffffff;
        padding: 20px 20px 30px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;

        position: relative;
    }

    /* =========================
       ヘッダー
       ========================= */

    .header {
        position: relative;
        height: 48px;
        display: flex;
        align-items: center;
        justify-content: center;

        margin-bottom: 20px;
    }

    /* 戻るボタン */

    .back-button {
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);

        display: flex;
        align-items: center;

        border: none;
        background: transparent;
        padding: 0;

        color: #0878d8;
        cursor: pointer;
    }

    .back-button:hover {
        opacity: 0.8;
    }

    .back-arrow {
        font-size: 38px;
        font-weight: 300;
        line-height: 1;
        margin-right: 6px;
    }

    .back-text {
        font-size: 18px;
        font-weight: 700;

        letter-spacing: -0.5px;
    }

    /* 日付 */

    .date {
        font-size: 22px;
        font-weight: 800;
        color: #222222;

        letter-spacing: -0.5px;
    }

    /* =========================
       画面タイトル
       ========================= */

    .page-title {
        text-align: center;

        font-size: 15px;
        font-weight: 700;
        color: #555555;

        margin-top: 5px;
        margin-bottom: 16px;
    }

    /* =========================
       収支一覧
       ========================= */

    .transaction-list {
        display: flex;
        flex-direction: column;
        gap: 12px;

        width: 400px;
        margin-left: 20px;
    }

    /* 各収支項目カード */

    .transaction {
        position: relative;
        width: 400px;
        height: 75px;

        display: flex;
        align-items: center;

        padding: 10px 12px 10px 14px;

        border-width: 3px;
        border-style: solid;
        border-radius: 15px;

        background: #ffffff;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);

        box-sizing: border-box;
    }

    .transaction::before {
        content: "";

        position: absolute;

        left: 0;
        top: 0;
        bottom: 0;

        width: 10px;

        border-top-left-radius: 12px;
        border-bottom-left-radius: 12px;
    }

    /* 収入 */

    .income {
        border-color: #A0C4FF;
    }

    .income::before {
        background: #A0C4FF;
    }

    /* 食費 */

    .food {
        border-color: #FFADAD;
    }

    .food::before {
        background: #FFADAD;
    }

    /* 光熱費 */

    .utility {
        border-color: #FDFFB6;
    }

    .utility::before {
        background: #FDFFB6;
    }

    /* 雑費 */

    .misc {
        border-color: #CAFFBF;
    }

    .misc::before {
        background: #CAFFBF;
    }

    /* =========================
       収支内容
       ========================= */

    .transaction-info {
        flex: 1;
        min-width: 0;
    }

    /* タイトル */

    .transaction-title {
        font-size: 17px;
        font-weight: 700;
        line-height: 1.3;

        min-height: 22px;
        margin-bottom: 4px;

        white-space: nowrap;
        overflow: visible;
    }

    /* =========================
       カテゴリ表示
       ========================= */

    .category {
        display: inline-flex;
        align-items: center;
        justify-content: center;

        min-width: 60px;
        height: 24px;

        padding: 0 9px;

        border-radius: 15px;

        font-size: 13px;
        font-weight: 700;

        color: #000000;
    }

    /* 収入 */

    .category-income {
        background: #A0C4FF;
        color: #000000;
    }

    /* 食費 */

    .category-food {
        background: #FFADAD;
        color: #000000;
    }

    /* 光熱費 */

    .category-utility {
        background: #FDFFB6;
        color: #000000;
    }

    /* 雑費 */

    .category-misc {
        background: #CAFFBF;
        color: #000000;
    }

    /* =========================
       金額
       ========================= */

    .amount {
        width: 95px;
        flex: 0 0 95px;

        text-align: right;

        font-size: 17px;
        font-weight: 500;

        white-space: nowrap;
    }

    /* =========================
       ・・・ボタン
       ========================= */

    .delete-button {
        width: 30px;
        height: 30px;

        flex: 0 0 30px;

        margin-left: 8px;

        display: flex;
        align-items: center;
        justify-content: center;

        border: none;
        background: transparent;
        padding: 0;

        color: #222222;

        font-size: 20px;
        font-weight: 700;
        line-height: 1;
        letter-spacing: 1px;

        cursor: pointer;
    }

    .delete-button:hover {
        background: transparent;
    }

    .delete-button:active {
        transform: scale(0.95);
    }

    /* =========================
       ＋ボタン
       ========================= */

    .add-button {
        display: block;

        width: 55px;
        height: 55px;

        margin-top: 20px;
        margin-left: auto;
        margin-right: 5px;

        border: none;
        border-radius: 50%;

        background: #3565a5;
        color: #ffffff;

        font-size: 32px;
        font-weight: 300;
        line-height: 1;

        cursor: pointer;

        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.25);
    }

    .add-button:hover {
        background: #28568f;
    }

    .add-button:active {
        transform: scale(0.97);
    }

    @media (max-width: 480px) {

        .screen {
            width: 100%;
            padding: 15px 14px 25px;
        }

        .header {
            height: 40px;
            margin-bottom: 15px;
        }

        .back-arrow {
            font-size: 30px;
            margin-right: 5px;
        }

        .back-text {
            font-size: 16px;
        }

        .date {
            font-size: 18px;
        }

        .page-title {
            font-size: 14px;
            margin: 5px 0 12px;
        }

        .transaction-list {
            width: 100%;
            margin-left: 0;
        }

        .transaction {
            width: 100%;
            height: 70px;

            padding: 8px 8px 8px 10px;

            border-width: 2px;
            border-radius: 12px;
        }

        .transaction-title {
            font-size: 17px;
            line-height: 1.3;
            min-height: 22px;
            margin-bottom: 4px;
        }

        .category {
            min-width: 60px;
            height: 24px;
            padding: 0 9px;
            font-size: 13px;
        }

        .amount {
            width: 88px;
            flex-basis: 88px;
            font-size: 16px;
        }

        .delete-button {
            width: 28px;
            height: 28px;

            flex-basis: 28px;

            margin-left: 6px;

            font-size: 20px;
            letter-spacing: 1px;
        }

        .add-button {
            width: 55px;
            height: 55px;

            margin-top: 20px;
            margin-right: 5px;

            font-size: 32px;
        }
    }
</style>
</head>

<body>

<div class="screen">

    <!-- ヘッダー -->
    <header class="header">
        <button class="back-button" type="button" onclick="location.href='${pageContext.request.contextPath}/household'">
            <span class="back-arrow">‹</span>
            <span class="back-text">戻る</span>
        </button>

        <div class="date">
            <c:out value="${displayDate}"/>
        </div>
    </header>

    <!-- 画面タイトル -->
    <h1 class="page-title">
        収支管理一覧
    </h1>

    <!-- 収支一覧 -->
    <main class="transaction-list">
        <c:if test="${not empty transactions}">
            <c:forEach var="t" items="${transactions}">
                <div class="transaction ${t.transactionCssClass}" onclick="location.href='${pageContext.request.contextPath}/transaction?id=${t.id}'" style="cursor:pointer;">
                    <div class="transaction-info">
                        <div class="transaction-title">
                            <c:choose>
                                <c:when test="${not empty t.memo}">
                                    <c:out value="${t.memo}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${t.categoryName}"/>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="category ${t.categoryCssClass}">
                            <c:out value="${t.categoryName}"/>
                        </div>
                    </div>

                    <div class="amount">
                        <c:out value="${t.formattedAmount}"/>
                    </div>

                    <!-- ・・・ボタン -->
                    <button class="delete-button" type="button" onclick="event.stopPropagation(); deleteTransaction(${t.id});">
                        •••
                    </button>
                </div>
            </c:forEach>
        </c:if>
    </main>

    <!-- 新規登録ボタン -->
    <button class="add-button" type="button" onclick="location.href='${pageContext.request.contextPath}/transaction'">
        ＋
    </button>

</div>

<form id="deleteForm" action="${pageContext.request.contextPath}/household/detail" method="post" style="display:none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="id" id="deleteId" value="">
</form>

<script>
function deleteTransaction(id) {
    if (confirm("収支情報を削除してよろしいですか？")) {
        document.getElementById("deleteId").value = id;
        document.getElementById("deleteForm").submit();
    }
}
</script>

</body>
</html>
