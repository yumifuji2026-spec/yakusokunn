<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>やくそくんカレンダー｜新規登録</title>

<style>
  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  body {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 30px 16px;
    background: #eef3f9;
    font-family: "Hiragino Sans", "Hiragino Kaku Gothic ProN", "Yu Gothic", Meiryo, sans-serif;
    color: #2b2b2b;
  }

  .page {
    width: 100%;
    max-width: 440px;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .logo-area {
    margin-bottom: 24px;
    text-align: center;
  }

  .logo {
    max-width: 290px;
    width: 100%;
    height: auto;
    display: block;
    margin: 0 auto;
  }

  .register-card {
    width: 100%;
    background: #ffffff;
    border-radius: 20px;
    padding: 32px 28px 36px;
    box-shadow: 0 10px 30px rgba(0,0,0,.06);
    border: 1px solid #e3e8ee;
  }

  .heading {
    text-align: center;
    margin-bottom: 26px;
  }

  .heading h1 {
    font-size: 26px;
    font-weight: 700;
    color: #222;
    margin-bottom: 8px;
    letter-spacing: .02em;
  }

  .heading p {
    font-size: 14px;
    color: #666;
    line-height: 1.5;
  }

  .form-group {
    margin-bottom: 18px;
  }

  .form-label {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 15px;
    font-weight: 700;
    color: #333;
    margin-bottom: 8px;
  }

  .required {
    color: #e85b5b;
    border: 1px solid #e85b5b;
    border-radius: 4px;
    font-size: 12px;
    line-height: 1;
    padding: 3px 5px;
    background: #fff;
  }

  .input-wrap {
    position: relative;
  }

  .input-icon {
    position: absolute;
    left: 15px;
    top: 50%;
    transform: translateY(-50%);
    color: #8f9398;
    font-size: 22px;
    pointer-events: none;
  }

  input {
    width: 100%;
    height: 54px;
    border: 2px solid #e0e0e0;
    border-radius: 9px;
    padding: 0 48px 0 50px;
    font-size: 16px;
    color: #333;
    outline: none;
    background: #fff;
    transition: border-color .2s, box-shadow .2s;
  }

  input::placeholder {
    color: #aaa;
  }

  input:focus {
    border-color: #3388dc;
    box-shadow: 0 0 0 3px rgba(51,136,220,.12);
  }

  .toggle-password {
    position: absolute;
    right: 13px;
    top: 50%;
    transform: translateY(-50%);
    width: 34px;
    height: 34px;
    border: 0;
    background: transparent;
    color: #8f9398;
    cursor: pointer;
    font-size: 20px;
    padding: 0;
  }

  .toggle-password:hover {
    color: #4f5963;
  }

  .error {
    min-height: 18px;
    margin-top: 5px;
    color: #d84b4b;
    font-size: 13px;
  }

  .register-button {
    width: 100%;
    height: 55px;
    margin-top: 2px;
    border: none;
    border-radius: 8px;
    background: #3186dc;
    color: white;
    font-size: 18px;
    font-weight: 700;
    cursor: pointer;
    box-shadow: 0 2px 4px rgba(0,0,0,.10);
  }

  .register-button:hover {
    background: #2678cb;
  }

  .register-button:active {
    transform: translateY(1px);
  }

  .login-divider {
    display: flex;
    align-items: center;
    gap: 14px;
    margin: 20px 0 9px;
    color: #555;
    font-size: 14px;
  }

  .login-divider::before,
  .login-divider::after {
    content: "";
    height: 1px;
    background: #d7d7d7;
    flex: 1;
  }

  .login-link {
    display: block;
    text-align: center;
    color: #347ed2;
    font-size: 15px;
    font-weight: 600;
    text-decoration: none;
  }

  .login-link:hover {
    text-decoration: underline;
  }

  @media (max-width: 600px) {
    body {
      align-items: flex-start;
      padding: 20px 14px;
    }

    .logo-area {
      margin-bottom: 15px;
    }

    .register-card {
      padding: 24px 20px 30px;
      border-radius: 16px;
    }

    .heading {
      margin-bottom: 30px;
    }

    .heading h1 {
      font-size: 24px;
    }

    .heading p {
      font-size: 14px;
    }

    .form-label {
      font-size: 16px;
    }
  }
</style>
</head>

<body>
  <main class="page">
    <div class="logo-area">
      <img
        class="logo"
        src="${pageContext.request.contextPath}/images/yaku-schedule-logo.png"
        alt="やくそくんカレンダー ゆびきりで守る、毎日の約束"
      >
    </div>

    <section class="register-card">
      <div class="heading">
        <h1>新規登録</h1>
        <p>アカウントを作成して、予定と収支を管理しましょう</p>
      </div>

      <c:if test="${not empty error}">
        <div class="error" style="margin-bottom:15px; font-size:14px; text-align:center;"><c:out value="${error}"/></div>
      </c:if>

      <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post" novalidate>
        <div class="form-group">
          <label class="form-label" for="email">
            メールアドレス
            <span class="required">必須</span>
          </label>

          <div class="input-wrap">
            <span class="input-icon" aria-hidden="true">✉</span>
            <input
              id="email"
              name="email"
              type="email"
              autocomplete="email"
              placeholder="メールアドレスを入力してください"
              value="${param.email}"
              required
            >
          </div>
          <div class="error" id="emailError"></div>
        </div>

        <div class="form-group">
          <label class="form-label" for="password">
            パスワード
            <span class="required">必須</span>
          </label>

          <div class="input-wrap">
            <span class="input-icon" aria-hidden="true">🔒</span>
            <input
              id="password"
              name="password"
              type="password"
              autocomplete="new-password"
              placeholder="パスワードを入力してください"
              required
            >
            <button
              class="toggle-password"
              type="button"
              data-target="password"
              aria-label="パスワードを表示"
              aria-pressed="false"
            >◉</button>
          </div>
          <div class="error" id="passwordError"></div>
        </div>

        <div class="form-group">
          <label class="form-label" for="passwordConfirm">
            パスワード（確認用）
            <span class="required">必須</span>
          </label>

          <div class="input-wrap">
            <span class="input-icon" aria-hidden="true">🔒</span>
            <input
              id="passwordConfirm"
              name="passwordConfirm"
              type="password"
              autocomplete="new-password"
              placeholder="パスワードを再入力してください"
              required
            >
            <button
              class="toggle-password"
              type="button"
              data-target="passwordConfirm"
              aria-label="パスワードを表示"
              aria-pressed="false"
            >◉</button>
          </div>
          <div class="error" id="passwordConfirmError"></div>
        </div>

        <button class="register-button" type="submit">登録する</button>

        <div class="login-divider">すでにアカウントをお持ちの方</div>

        <a class="login-link" href="${pageContext.request.contextPath}/login">ログインはこちら</a>
      </form>
    </section>
  </main>

<script>
  // パスワード表示／非表示
  document.querySelectorAll(".toggle-password").forEach(button => {
    button.addEventListener("click", () => {
      const input = document.getElementById(button.dataset.target);
      const visible = input.type === "text";

      input.type = visible ? "password" : "text";
      button.textContent = visible ? "◉" : "○";
      button.setAttribute("aria-pressed", String(!visible));
      button.setAttribute(
        "aria-label",
        visible ? "パスワードを表示" : "パスワードを非表示"
      );
    });
  });

  // 入力チェック
  document.getElementById("registerForm").addEventListener("submit", event => {
    const email = document.getElementById("email");
    const password = document.getElementById("password");
    const passwordConfirm = document.getElementById("passwordConfirm");

    const errors = {
      email: document.getElementById("emailError"),
      password: document.getElementById("passwordError"),
      passwordConfirm: document.getElementById("passwordConfirmError")
    };

    Object.values(errors).forEach(error => error.textContent = "");

    let valid = true;

    if (!email.value.trim()) {
      errors.email.textContent = "メールアドレスを入力してください。";
      valid = false;
    } else if (!email.validity.valid) {
      errors.email.textContent = "正しいメールアドレスを入力してください。";
      valid = false;
    }

    if (!password.value) {
      errors.password.textContent = "パスワードを入力してください。";
      valid = false;
    }

    if (!passwordConfirm.value) {
      errors.passwordConfirm.textContent = "パスワード（確認用）を入力してください。";
      valid = false;
    } else if (password.value !== passwordConfirm.value) {
      errors.passwordConfirm.textContent = "パスワードが一致していません。";
      valid = false;
    }

    if (!valid) {
      event.preventDefault();
    }
  });
</script>
</body>
</html>
