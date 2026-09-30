<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>収支目標設定</title>
<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        padding: 0;
        background: #f5f5f5;
        font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue",
                     "Hiragino Kaku Gothic ProN", "Yu Gothic", Meiryo, sans-serif;
        color: #333;
    }

    .screen {
        width: 100%;
        max-width: 480px;
        min-height: 50vh;
        margin: 0 auto;
        background: #fff;
    }

    /* ヘッダー */
    .header {
        height: 42px;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
        border-bottom: 1px solid #ddd;
        background: #fff;
    }

    .back-button {
        position: absolute;
        left: 8px;
        top: 7px;
        display: flex;
        align-items: center;
        border: none;
        background: none;
        color: #777;
        font-size: 15px;
        padding: 0;
        cursor: pointer;
    }

    .back-arrow {
        width: 14px;
        height: 14px;
        border-left: 3px solid #777;
        border-bottom: 3px solid #777;
        transform: rotate(45deg);
        margin-right: 5px;
    }

    .header-title {
        font-size: 19px;
        font-weight: bold;
        color: #444;
    }

    /* 収支区分 */
    .section-title {
        height: 27px;
        display: flex;
        align-items: center;
        padding-left: 30px;
        background: #f1f3f5;
        border-bottom: 1px solid #ddd;
        font-size: 14px;
        color: #777;
    }

    /* 入力エリア */
    .form-area {
        padding: 15px 12px 20px 30px;
    }

    .form-group {
        margin-bottom: 6px;
    }

    .label {
        display: block;
        margin-bottom: 5px;
        font-size: 16px;
        font-weight: bold;
        color: #333;
    }

    .input {
        width: calc(100% - 8px);
        height: 36px;
        padding: 5px 10px;
        border: 1px solid #cfcfcf;
        border-radius: 9px;
        background: #e9e9e9;
        box-shadow: inset 0 1px 2px rgba(0,0,0,0.12);
        font-size: 16px;
        color: #333;
        outline: none;
    }

    .input::placeholder {
        color: #888;
        opacity: 1;
    }

    .input:focus {
        background: #fff;
        border-color: #888;
    }

    .separator {
        height: 1px;
        margin: 7px 0 11px;
        background: #e5e5e5;
    }

    /* 登録ボタン */
    .register-button {
        width: calc(100% - 8px);
        height: 39px;
        margin-top: 30px;
        border: none;
        border-radius: 8px;
        background: #0757a6;
        color: #fff;
        font-size: 17px;
        font-weight: bold;
        box-shadow: 0 2px 4px rgba(0,0,0,0.25);
        cursor: pointer;
    }

    .register-button:active {
        transform: translateY(1px);
        box-shadow: 0 1px 2px rgba(0,0,0,0.2);
    }

    .error-msg {
        color: #d9534f;
        padding: 10px 30px;
        font-size: 14px;
    }
</style>
</head>

<body>
<div class="screen">

    <header class="header">
        <button class="back-button" type="button" onclick="cancelBudget()">
            <span class="back-arrow"></span>
            <span>戻る</span>
        </button>

        <div class="header-title"><c:out value="${headerTitle}"/></div>
    </header>

    <div class="section-title"></div>

    <c:if test="${not empty error}">
        <div class="error-msg"><c:out value="${error}"/></div>
    </c:if>

    <form id="budgetForm" action="${pageContext.request.contextPath}/budget" method="post" class="form-area">

        <div class="form-group">
            <label class="label" for="income">［収入金額］</label>
            <input
                id="income"
                name="income"
                class="input"
                type="text"
                inputmode="numeric"
                placeholder="例：250,000円"
                value="${budget.incomeAmount != null ? budget.incomeAmount : 0}">
        </div>

        <div class="separator"></div>

        <div class="form-group">
            <label class="label" for="expense">［目標 出費額］</label>
            <input
                id="expense"
                name="expense"
                class="input"
                type="text"
                inputmode="numeric"
                placeholder="例：180,000円"
                value="${budget.targetExpense != null ? budget.targetExpense : 0}">
        </div>

        <button class="register-button" type="submit">
            登録
        </button>

    </form>
</div>

<script>
var initialIncome = "${budget.incomeAmount != null ? budget.incomeAmount : 0}";
var initialExpense = "${budget.targetExpense != null ? budget.targetExpense : 0}";

function cancelBudget() {
    var curIncome = document.getElementById("income").value;
    var curExpense = document.getElementById("expense").value;
    if (curIncome !== initialIncome || curExpense !== initialExpense) {
        if (confirm("設定が保存されていません。終了しますか？")) {
            location.href = "${pageContext.request.contextPath}/household";
        }
    } else {
        location.href = "${pageContext.request.contextPath}/household";
    }
}
</script>

</body>
</html>
