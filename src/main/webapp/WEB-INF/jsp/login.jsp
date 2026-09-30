<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>やくそくんカレンダー ログイン</title>
<style>
/* =========================================================
   基本設定
========================================================= */
* {
  box-sizing: border-box;
}

html {
  width: 100%;
  height: 100%;
}

body {
  margin: 0;
  width: 100%;
  height: 100%;
  min-height: 100vh;
  min-height: 100dvh;

  background: #fff;
  color: #15375f;

  font-family:
    -apple-system,
    BlinkMacSystemFont,
    "Hiragino Kaku Gothic ProN",
    "Yu Gothic",
    Meiryo,
    sans-serif;

  /*
    ウィンドウが小さい（PC）場合はここでスクロールできるようにする。
    フルスクリーン等、画面に十分な高さがある場合は
    .page 側の中央寄せでちょうど収まりスクロールは発生しない。
  */
  overflow-x: hidden;
  overflow-y: auto;
}

/* =========================================================
   ページ全体
========================================================= */
.page {
  width: min(calc(100% - 32px), 620px);
  min-height: 100vh;
  min-height: 100dvh;
  margin: 0 auto;
  padding: clamp(8px, 2vh, 30px) 0 clamp(12px, 2vh, 30px);

  display: flex;
  flex-direction: column;
  justify-content: center;
}

/* =========================================================
   ロゴ
========================================================= */
.logo {
  display: block;
  width: clamp(260px, 82vw, 900px);
  max-width: 100%;
  max-height: 24vh;
  height: auto;
  margin: 0 auto clamp(8px, 2vh, 45px);
  object-fit: contain;
  flex-shrink: 0;
}

/* =========================================================
   ログインカード
========================================================= */
.card {
  width: 100%;
  max-width: 620px;
  margin: 0 auto;
  background: #fff;
  border: 1px solid #e9e9e9;
  border-radius: clamp(18px, 2vw, 25px);
  box-shadow: 0 4px 18px rgba(0, 0, 0, .08);
  padding:
    clamp(20px, 3.5vh, 62px)
    clamp(20px, 4vw, 42px)
    clamp(20px, 3vh, 45px);
}

/* =========================================================
   見出し
========================================================= */
h1 {
  margin: 0;
  text-align: center;
  font-size: clamp(24px, 2.8vw, 35px);
  line-height: 1.4;
  font-weight: 900;
  white-space: nowrap;
}

/* =========================================================
   説明文
========================================================= */
.lead {
  margin: clamp(10px, 2vh, 20px) 0 clamp(20px, 3vh, 52px);
  text-align: center;
  color: #555;
  font-size: clamp(15px, 1.8vw, 23px);
  line-height: 1.6;
  white-space: nowrap;
}

/* =========================================================
   エラーメッセージ
========================================================= */
.error-message {
  background-color: #fef2f2;
  color: #dc2626;
  border: 1px solid #fecaca;
  padding: 12px 16px;
  border-radius: 10px;
  font-size: 14px;
  margin-bottom: 20px;
  text-align: center;
  line-height: 1.5;
}

/* =========================================================
   入力項目
========================================================= */
.field {
  margin-bottom: clamp(12px, 2.2vh, 38px);
}

label {
  display: block;
  margin-bottom: 13px;
  font-size: clamp(17px, 1.8vw, 23px);
  font-weight: 900;
  line-height: 1.4;
}

.input-wrap {
  position: relative;
  width: 100%;
}

input {
  width: 100%;
  height: clamp(52px, 6vh, 78px);
  border: 2px solid #d9d9d9;
  border-radius: 14px;
  padding: 0 clamp(50px, 5vw, 65px);
  font-size: clamp(16px, 1.6vw, 21px);
  outline: none;
  color: #333;
  background: #fff;
  transition: border-color .2s ease, box-shadow .2s ease;
}

input:focus {
  border-color: #4285e8;
  box-shadow: 0 0 0 3px rgba(66, 133, 232, .12);
}

input::placeholder {
  color: #aaa;
}

.icon {
  position: absolute;
  left: clamp(18px, 2.3vw, 24px);
  top: 50%;
  transform: translateY(-50%);
  color: #888;
  z-index: 1;
}

.mail {
  width: clamp(24px, 2.8vw, 29px);
  height: clamp(21px, 2.5vw, 25px);
  border: 3px solid #888;
  border-radius: 4px;
}

.mail:before,
.mail:after {
  content: "";
  position: absolute;
  width: clamp(15px, 1.8vw, 18px);
  height: 3px;
  background: #888;
  top: 8px;
}

.mail:before {
  left: 0;
  transform: rotate(31deg);
  transform-origin: left;
}

.mail:after {
  right: 0;
  transform: rotate(-31deg);
  transform-origin: right;
}

.lock {
  width: clamp(23px, 2.6vw, 27px);
  height: clamp(22px, 2.5vw, 25px);
  border: 3px solid #888;
  border-radius: 4px;
}

.lock:before {
  content: "";
  position: absolute;
  width: clamp(11px, 1.3vw, 13px);
  height: clamp(11px, 1.3vw, 13px);
  left: 4px;
  top: -14px;
  border: 3px solid #888;
  border-bottom: 0;
  border-radius: 10px 10px 0 0;
}

.eye {
  position: absolute;
  right: clamp(18px, 2.4vw, 25px);
  top: 50%;
  transform: translateY(-50%);
  width: clamp(30px, 3.2vw, 35px);
  height: clamp(21px, 2.4vw, 24px);
  cursor: pointer;
  z-index: 2;
}

.eye:before {
  content: "";
  position: absolute;
  inset: 0;
  border: 3px solid #888;
  border-radius: 50%;
  transform: scaleY(.72);
}

.eye:after {
  content: "";
  position: absolute;
  width: clamp(8px, 1vw, 9px);
  height: clamp(8px, 1vw, 9px);
  background: #888;
  border-radius: 50%;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}

/* =========================================================
   ログインボタン
========================================================= */
.login {
  width: 100%;
  height: clamp(52px, 6vh, 79px);
  border: 0;
  border-radius: 13px;
  background: linear-gradient(180deg, #3887e5, #2169ce);
  color: #fff;
  font-size: clamp(20px, 2vw, 27px);
  font-weight: 900;
  cursor: pointer;
  transition: opacity .2s ease, transform .1s ease;
}

.login:hover {
  opacity: .9;
}

.login:active {
  transform: translateY(1px);
}

/* =========================================================
   区切り
========================================================= */
.divider {
  display: flex;
  align-items: center;
  gap: clamp(10px, 2vw, 22px);
  margin: clamp(14px, 2vh, 34px) 0 clamp(10px, 1.5vh, 22px);
  color: #555;
  font-size: clamp(14px, 1.6vw, 21px);
  font-weight: 700;
  line-height: 1.4;
  white-space: nowrap;
}

.divider:before,
.divider:after {
  content: "";
  flex: 1;
  height: 2px;
  background: #ddd;
}

/* =========================================================
   新規登録ボタン
========================================================= */
.register {
  display: flex;
  align-items: center;
  justify-content: center;
  height: clamp(48px, 5vh, 66px);
  border: 2px solid #4c8ee7;
  border-radius: 12px;
  color: #176dd1;
  text-decoration: none;
  font-size: clamp(17px, 1.8vw, 24px);
  font-weight: 900;
  background: #fff;
  transition: background-color .2s ease, color .2s ease;
}

.register:hover {
  background: #f4f8ff;
}

/* =========================================================
   PC・大画面（ウィンドウ表示 / フルスクリーン共通）

   通常のウィンドウで高さが不足する場合は body の
   overflow-y:auto によりページ全体がスクロールする。
   フルスクリーンなど十分な高さがある場合は
   .page の justify-content:center によって
   縦横ともにぴったり中央に収まる。
========================================================= */
@media (min-width: 801px) {
  .page {
    padding-top: clamp(6px, 1.4vh, 22px);
    padding-bottom: clamp(6px, 1.4vh, 22px);
  }

  .logo {
    max-height: 21vh;
    margin-bottom: clamp(6px, 1.2vh, 30px);
  }

  .card {
    padding-top: clamp(12px, 2.2vh, 46px);
    padding-bottom: clamp(14px, 2vh, 34px);
  }

  .lead {
    margin-bottom: clamp(14px, 2.2vh, 38px);
  }

  .field {
    margin-bottom: clamp(8px, 1.4vh, 28px);
  }

  input {
    height: clamp(44px, 5.4vh, 70px);
  }

  .login {
    height: clamp(44px, 5.4vh, 71px);
  }
}

/* =========================================================
   縦が低いPCウィンドウ
   （横幅はPCだが高さが足りないウィンドウ表示）
========================================================= */
@media (min-width: 601px) and (max-height: 700px) {
  .page {
    justify-content: flex-start;
    padding-top: 8px;
    padding-bottom: 20px;
  }

  .logo {
    max-height: 16vh;
    margin-bottom: 8px;
  }

  .card {
    padding-top: 16px;
    padding-bottom: 18px;
  }

  h1 {
    font-size: clamp(23px, 2.8vw, 30px);
  }

  .lead {
    margin-top: 8px;
    margin-bottom: 16px;
  }

  label {
    margin-bottom: 8px;
  }

  .field {
    margin-bottom: 12px;
  }

  input {
    height: 48px;
  }

  .login {
    height: 48px;
  }

  .divider {
    margin-top: 12px;
    margin-bottom: 8px;
  }

  .register {
    height: 46px;
  }
}

/* =========================================================
   タブレット・スマートフォン

   小さい画面では 100dvh 内に必ず収まるよう、
   .page 自体の高さを固定して overflow:hidden にし、
   ロゴ・カード内の余白やフォントサイズもすべて
   vh（画面の高さ）基準の clamp() で決めることで
   端末の高さに応じて自動的に縮小させ、
   スクロールなしで1画面に収める。
   万一収まりきらない極端に小さい端末のための
   保険として body の overflow-y:auto は残す。
========================================================= */
@media (max-width: 600px) {
  html, body {
    height: 100%;
  }

  .page {
    width: calc(100% - 24px);
    height: 100vh;
    height: 100dvh;
    min-height: 100vh;
    min-height: 100dvh;
    padding: clamp(6px, 1.5vh, 14px) 0 clamp(8px, 2vh, 18px);
    justify-content: center;
    overflow: hidden;
  }

  .logo {
    width: min(92%, 460px);
    max-height: clamp(70px, 19vh, 160px);
    margin-bottom: clamp(6px, 1.5vh, 14px);
  }

  .card {
    padding:
      clamp(14px, 3vh, 28px)
      clamp(14px, 4vw, 20px)
      clamp(16px, 3vh, 30px);
    border-radius: clamp(14px, 3vw, 18px);
  }

  h1 {
    font-size: clamp(18px, 5vw, 24px);
  }

  .lead {
    font-size: clamp(12px, 3.2vw, 15px);
    margin: clamp(6px, 1.5vh, 12px) 0 clamp(12px, 2.5vh, 24px);
  }

  .error-message {
    padding: clamp(8px, 1.5vh, 10px) 12px;
    font-size: 13px;
    margin-bottom: clamp(8px, 1.5vh, 14px);
  }

  .field {
    margin-bottom: clamp(8px, 1.8vh, 18px);
  }

  label {
    font-size: clamp(14px, 3.6vw, 17px);
    margin-bottom: clamp(4px, 1vh, 8px);
  }

  input {
    height: clamp(40px, 6.5vh, 58px);
    padding: 0 clamp(40px, 12vw, 50px);
    font-size: 16px;
    border-radius: 12px;
  }

  .icon {
    left: clamp(12px, 4vw, 18px);
  }

  .eye {
    right: clamp(12px, 4vw, 18px);
  }

  .login {
    height: clamp(40px, 6.5vh, 58px);
    font-size: clamp(16px, 4.5vw, 20px);
    border-radius: 12px;
  }

  .divider {
    font-size: clamp(12px, 3vw, 14px);
    gap: clamp(6px, 2vw, 9px);
    margin: clamp(8px, 2vh, 18px) 0 clamp(6px, 1.2vh, 10px);
  }

  .register {
    height: clamp(38px, 6vh, 52px);
    font-size: clamp(14px, 3.6vw, 17px);
    border-radius: 11px;
  }
}

/* =========================================================
   非常に小さいスマートフォン
========================================================= */
@media (max-width: 380px) {
  .page {
    width: calc(100% - 18px);
  }

  .card {
    padding:
      clamp(12px, 3vh, 20px)
      clamp(10px, 4vw, 14px)
      clamp(14px, 3vh, 24px);
    border-radius: clamp(12px, 3vw, 16px);
  }

  h1 {
    font-size: clamp(17px, 5vw, 21px);
  }

  .lead {
    font-size: clamp(11px, 3vw, 14px);
  }

  label {
    font-size: clamp(13px, 3.4vw, 16px);
  }

  input {
    font-size: 15px;
    padding: 0 clamp(36px, 11vw, 48px);
  }

  .icon {
    left: clamp(10px, 3.5vw, 16px);
  }

  .eye {
    right: clamp(10px, 3.5vw, 16px);
  }

  .login {
    font-size: clamp(15px, 4vw, 19px);
  }

  .divider {
    font-size: clamp(11px, 2.8vw, 13px);
    gap: clamp(5px, 1.8vw, 7px);
  }

  .register {
    font-size: clamp(13px, 3.4vw, 16px);
  }
}

/* =========================================================
   スマートフォン横向き
========================================================= */
@media (max-width: 800px) and (orientation: landscape) {
  .page {
    height: 100vh;
    height: 100dvh;
    justify-content: center;
    padding: clamp(4px, 1.5vh, 8px) 0 clamp(6px, 2vh, 14px);
    overflow: hidden;
  }

  .logo {
    width: min(52vw, 440px);
    max-height: clamp(46px, 17vh, 100px);
    margin-bottom: clamp(4px, 1vh, 8px);
  }

  .card {
    padding:
      clamp(10px, 2.5vh, 16px)
      clamp(14px, 3vw, 18px)
      clamp(12px, 2.5vh, 18px);
  }

  h1 {
    font-size: clamp(16px, 3.5vw, 20px);
  }

  .lead {
    margin: clamp(4px, 1vh, 6px) 0 clamp(8px, 2vh, 12px);
    font-size: clamp(11px, 2.2vw, 13px);
  }

  .field {
    margin-bottom: clamp(6px, 1.5vh, 10px);
  }

  label {
    margin-bottom: clamp(3px, 1vh, 6px);
    font-size: clamp(12px, 2.5vw, 14px);
  }

  input {
    height: clamp(34px, 8vh, 44px);
  }

  .login {
    height: clamp(34px, 8vh, 44px);
  }

  .divider {
    margin: clamp(6px, 1.5vh, 10px) 0 clamp(4px, 1vh, 6px);
  }

  .register {
    height: clamp(30px, 7vh, 40px);
  }
}
</style>
</head>
<body>
<!-- ======================================================= ページ全体 ======================================================== -->
<main class="page">
  <!-- ===================================================== ロゴ ====================================================== -->
  <img
    class="logo"
    src="${pageContext.request.contextPath}/images/yaku-schedule-logo.png"
    alt="やくそくんカレンダー ロゴ"
  >
  <!-- ===================================================== ログインカード ====================================================== -->
  <section class="card">
    <!-- ===================================================
         見出し
    ==================================================== -->
    <h1>
      ようこそ！やくそくんカレンダーへ
    </h1>
    <!-- ===================================================
         説明文
    ==================================================== -->
    <p class="lead">
      ログインして、あなたの予定と収支を管理しましょう
    </p>
    <!-- ===================================================
         エラーメッセージ
    ==================================================== -->
    <c:if test="${not empty error}">
      <div class="error-message">
        ${error}
      </div>
    </c:if>
    <!-- ===================================================
         ログインフォーム
    ==================================================== -->
    <form
      id="loginForm"
      action="${pageContext.request.contextPath}/login"
      method="post"
    >
      <!-- =================================================
           メールアドレス
      ================================================== -->
      <div class="field">
        <label for="email">
          メールアドレス
        </label>
        <div class="input-wrap">
          <span class="icon mail" aria-hidden="true"></span>
          <input
            id="email"
            name="email"
            type="email"
            placeholder="メールアドレスを入力してください"
            autocomplete="email"
            required
          >
        </div>
      </div>
      <!-- =================================================
           パスワード
      ================================================== -->
      <div class="field">
        <label for="password">
          パスワード
        </label>
        <div class="input-wrap">
          <span class="icon lock" aria-hidden="true"></span>
          <input
            id="password"
            name="password"
            type="password"
            placeholder="パスワードを入力してください"
            autocomplete="current-password"
            required
          >
          <span
            class="eye"
            id="togglePassword"
            aria-label="パスワードを表示"
            role="button"
            tabindex="0"
          ></span>
        </div>
      </div>
      <!-- =================================================
           ログインボタン
      ================================================== -->
      <button class="login" type="submit">
        ログイン
      </button>
      <!-- =================================================
           区切り
      ================================================== -->
      <div class="divider">
        アカウントをお持ちでない方
      </div>
      <!-- =================================================
           新規登録
      ================================================== -->
      <a
        href="${pageContext.request.contextPath}/register"
        class="register"
        id="register"
      >
        新規登録はこちら
      </a>
    </form>
  </section>
</main>
<script>
/* =========================================================
   パスワード表示 / 非表示
========================================================= */
const password = document.getElementById("password");
const toggle = document.getElementById("togglePassword");

function togglePassword() {
  password.type = password.type === "password" ? "text" : "password";
}

toggle.addEventListener("click", togglePassword);

toggle.addEventListener("keydown", (e) => {
  if (e.key === "Enter" || e.key === " ") {
    e.preventDefault();
    togglePassword();
  }
});
</script>
</body>
</html>
