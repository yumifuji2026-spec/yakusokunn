<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>収支詳細登録</title>

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
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;

            min-height: 100vh;

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


        /* ========================================
           Main Container
           予定アラームと同じ幅感
        ======================================== */

        .container {
            width: min(100vw, 467px);

            display: flex;
            flex-direction: column;

            background: #f7f8fa;

            overflow: hidden;
            position: relative;

            border-radius: 20px;

            box-shadow:
                0 8px 30px rgba(0, 0, 0, 0.06);
        }


        /* ========================================
           Header
        ======================================== */

        .header {
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


        /* ========================================
           Back button
        ======================================== */

        .back-btn {
            position: absolute;

            left: 20px;
            top: 50%;

            transform: translateY(-50%);

            display: flex;
            align-items: center;

            height: 40px;

            padding: 0 8px 0 0;

            color: #1677ff;

            text-decoration: none;

            font-size: 15px;
            font-weight: 600;

            cursor: pointer;

            -webkit-tap-highlight-color: transparent;
        }

        .back-btn::before {
            content: "‹";

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

        .title {
            font-size: 18px;
            font-weight: 750;

            letter-spacing: -0.02em;
        }


        /* ========================================
           Form Area
        ======================================== */

        .form-container {
            padding: 22px 16px 24px;

            background: #f7f8fa;
        }


        /* ========================================
           Card
        ======================================== */

        .form-card {
            margin: 0;
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

        .form-group {
            display: flex;
            align-items: center;

            min-height: 68px;

            margin: 0;
            padding: 11px 16px;

            border-bottom: 1px solid #edf0f2;
        }

        .form-group:last-of-type {
            border-bottom: 0;
        }


        /* ========================================
           Labels
        ======================================== */

        label {
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

        .input-control {
            flex: 1;

            width: 0;
            min-width: 0;

            height: 43px;

            border: 1px solid #dfe3e8;
            border-radius: 11px;

            background: #f9fafb;

            color: #17191c;

            font-family: inherit;

            font-size: 16px;
            font-weight: 500;

            padding: 5px 12px;

            outline: none;

            transition:
                border-color 0.18s ease,
                background-color 0.18s ease,
                box-shadow 0.18s ease;
        }

        .input-control:focus {
            border-color: #1677ff;

            background: #ffffff;

            box-shadow:
                0 0 0 3px rgba(22, 119, 255, 0.10);
        }


        /* ========================================
           Select
        ======================================== */

        select.input-control {
            appearance: none;
            -webkit-appearance: none;

            cursor: pointer;

            background-image:
                url("data:image/svg+xml;charset=UTF-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%238a9098' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E");

            background-repeat: no-repeat;

            background-position: right 13px center;

            background-size: 16px;

            padding-right: 40px;
        }


        /* ========================================
           Category
        ======================================== */

        .category-wrapper {
            position: relative;

            display: flex;
            align-items: center;

            flex: 1;

            min-width: 0;
        }

        .color-badge {
            position: absolute;

            z-index: 2;

            left: 12px;
            top: 50%;

            width: 21px;
            height: 21px;

            transform: translateY(-50%);

            border-radius: 50%;

            background: #ffb3ba;

            box-shadow:
                inset 0 0 0 3px rgba(255, 255, 255, 0.35);

            pointer-events: none;
        }

        .category-select {
            padding-left: 43px !important;
        }


        /* ========================================
           Register button
        ======================================== */

        .submit-btn {
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

            font-family: inherit;

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

        .submit-btn:hover {
            filter: brightness(0.98);

            box-shadow:
                0 8px 20px rgba(22, 119, 255, 0.27);
        }

        .submit-btn:active {
            transform: translateY(1px);

            box-shadow:
                0 3px 10px rgba(22, 119, 255, 0.20);
        }


        /* ========================================
           大画面
           フォーム全体を中央配置した上で少し拡大
        ======================================== */

        @media (min-width: 600px) {

            .container {
                width: 520px;

                transform: scale(1.08);
                transform-origin: center center;
            }

            .header {
                height: 74px;
                flex-basis: 74px;
            }

            .title {
                font-size: 20px;
            }

            .back-btn {
                left: 22px;

                font-size: 16px;
            }

            .form-container {
                padding: 28px 20px 30px;
            }

            .form-card {
                border-radius: 20px;
            }

            .form-group {
                min-height: 72px;

                padding: 12px 18px;
            }

            label {
                width: 100px;
                flex-basis: 100px;

                font-size: 14px;
            }

            .input-control {
                height: 46px;

                font-size: 17px;

                border-radius: 12px;
            }

            .category-select {
                padding-left: 46px !important;
            }

            .color-badge {
                left: 13px;

                width: 22px;
                height: 22px;
            }

            .submit-btn {
                height: 58px;

                margin-top: 22px;

                font-size: 17px;

                border-radius: 15px;
            }
        }


        /* ========================================
           スマホ
        ======================================== */

        @media (max-width: 599px) {

            .container {
                min-height: 100vh;

                border-radius: 0;

                box-shadow: none;
            }
        }


        @media (max-width: 390px) {

            .back-btn {
                left: 14px;
            }

            .form-container {
                padding-left: 12px;
                padding-right: 12px;
            }

            .form-card {
                border-radius: 16px;
            }

            .submit-btn {
                width: calc(100% - 24px);

                margin-left: 12px;
                margin-right: 12px;
            }

            .form-group {
                padding-left: 13px;
                padding-right: 13px;
            }

            label {
                width: 76px;
                flex-basis: 76px;

                font-size: 12px;
            }

            .input-control {
                font-size: 14px;
            }

            .color-badge {
                left: 11px;
            }

            .category-select {
                padding-left: 40px !important;
            }
        }


        /* ========================================
           Very small screen
        ======================================== */

        @media (max-width: 340px) {

            label {
                width: 70px;
                flex-basis: 70px;
            }
        }

        .error-msg {
            color: #d9534f;
            margin-bottom: 10px;
            font-size: 14px;
            text-align: center;
        }

    </style>
</head>

<body>

<div class="container">

    <!-- ヘッダー -->
    <div class="header">

        <a class="back-btn" href="${pageContext.request.contextPath}/household/detail">戻る</a>

        <div class="title">
            収支詳細登録
        </div>

    </div>


    <!-- フォームエリア -->
    <div class="form-container">

        <c:if test="${not empty error}">
            <div class="error-msg"><c:out value="${error}"/></div>
        </c:if>

        <form class="form-card" id="transactionForm" action="${pageContext.request.contextPath}/transaction" method="post">
            <input type="hidden" name="id" value="${transaction.id}">

            <!-- 日付 -->
            <div class="form-group">

                <label for="date">
                    日付：
                </label>

                <input
                    type="date"
                    id="date"
                    name="date"
                    class="input-control"
                    value="${transaction.formattedDate}"
                    required
                >

            </div>


            <!-- タイプ -->
            <div class="form-group">

                <label for="type">
                    タイプ：
                </label>

                <select
                    id="type"
                    name="type"
                    class="input-control"
                    onchange="updateCategories()"
                >
                    <option value="02" ${transaction.type == '02' || empty transaction.type ? 'selected' : ''}>出費</option>
                    <option value="01" ${transaction.type == '01' ? 'selected' : ''}>収入</option>
                </select>

            </div>


            <!-- カテゴリー -->
            <div class="form-group">

                <label for="category">
                    カテゴリー：
                </label>

                <div class="category-wrapper">

                    <div class="color-badge" id="colorBadge"></div>

                    <select
                        id="category"
                        name="category_id"
                        class="input-control category-select"
                        onchange="updateColorBadge()"
                    >
                        <!-- JSで動的生成 -->
                    </select>

                </div>

            </div>


            <!-- 金額 -->
            <div class="form-group">

                <label for="amount">
                    金額：
                </label>

                <input
                    type="text"
                    id="amount"
                    name="amount"
                    class="input-control"
                    value="${transaction.amount != null && transaction.amount > 0 ? transaction.amount : ''}"
                    placeholder="金額を入力"
                    required
                >

            </div>


            <!-- メモ -->
            <div class="form-group">

                <label for="memo">
                    メモ：
                </label>

                <input
                    type="text"
                    id="memo"
                    name="memo"
                    class="input-control"
                    value="${transaction.memo}"
                    placeholder="メモを入力"
                >

            </div>


            <!-- 登録ボタン -->
            <button
                type="submit"
                class="submit-btn"
            >
                登録
            </button>

        </form>

    </div>

</div>

<script>
var allCategories = [
    <c:forEach var="cat" items="${categories}" varStatus="loop">
        { id: ${cat.id}, name: "${cat.name}", type: "${cat.type}", colorCode: "${cat.colorCode}" }${!loop.last ? ',' : ''}
    </c:forEach>
];

var selectedCatId = ${transaction.categoryId != null ? transaction.categoryId : 10};

function updateCategories() {
    var typeVal = document.getElementById("type").value;
    var catSelect = document.getElementById("category");
    catSelect.innerHTML = "";

    var filtered = allCategories.filter(function(c) {
        return c.type === typeVal;
    });

    if (filtered.length === 0) {
        if (typeVal === "01") {
            filtered = [{ id: 1, name: "収入", type: "01", colorCode: "#A0C4FF" }];
        } else {
            filtered = [
                { id: 10, name: "食費", type: "02", colorCode: "#FFADAD" },
                { id: 11, name: "光熱費", type: "02", colorCode: "#FDFFB6" },
                { id: 12, name: "雑費", type: "02", colorCode: "#CAFFBF" }
            ];
        }
    }

    filtered.forEach(function(c) {
        var opt = document.createElement("option");
        opt.value = c.id;
        opt.textContent = c.name;
        opt.dataset.color = c.colorCode || "#ffb3ba";
        if (c.id === selectedCatId) {
            opt.selected = true;
        }
        catSelect.appendChild(opt);
    });

    if (!catSelect.value && filtered.length > 0) {
        catSelect.selectedIndex = 0;
    }
    updateColorBadge();
}

function updateColorBadge() {
    var catSelect = document.getElementById("category");
    var badge = document.getElementById("colorBadge");
    if (catSelect.selectedOptions.length > 0) {
        var opt = catSelect.selectedOptions[0];
        badge.style.backgroundColor = opt.dataset.color || "#ffb3ba";
    }
}

document.addEventListener("DOMContentLoaded", function() {
    // Existing category update processing
    updateCategories();
    // Store initial form state
    window.initialFormState = {};
    var form = document.getElementById("transactionForm");
    Array.from(form.elements).forEach(function(el) {
        if (el.name) {
            window.initialFormState[el.name] = el.value;
        }
    });
    // Back button handling
    var backBtn = document.querySelector('.back-btn');
    if (backBtn) {
        function isFormModified() {
            var currentData = new FormData(form);
            for (let [key, val] of currentData.entries()) {
                if (window.initialFormState[key] !== val) return true;
            }
            return false;
        }
        backBtn.addEventListener('click', function(e) {
            e.preventDefault();
            if (isFormModified()) {
                if (confirm('変更内容を破棄してもよろしいですか？')) {
                    window.location.href = backBtn.getAttribute('href');
                }
            } else {
                window.location.href = backBtn.getAttribute('href');
            }
        });
    }
});
</script>

</body>
</html>


