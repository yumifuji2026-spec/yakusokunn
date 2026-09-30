package com.yakusokun.servlet;

import com.yakusokun.dao.UserDAO;
import com.yakusokun.model.User;
import com.yakusokun.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private transient UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String passwordConfirm = request.getParameter("passwordConfirm");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "メールアドレスを入力してください。");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty() || passwordConfirm == null || passwordConfirm.trim().isEmpty()) {
            request.setAttribute("error", "パスワードおよび確認用パスワードを入力してください。");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(passwordConfirm)) {
            request.setAttribute("error", "パスワードと確認用パスワードが一致しません。");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.findByEmail(email.trim()) != null) {
            request.setAttribute("error", "指定されたメールアドレスは既に登録されています。");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            return;
        }

        String hash = PasswordUtil.hashPassword(password);
        User newUser = new User(null, email.trim(), hash);

        if (userDAO.create(newUser)) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "ユーザー登録に失敗しました。時間をおいて再試行してください。");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
        }
    }
}
