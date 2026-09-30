package com.yakusokun.servlet;

import com.yakusokun.dao.UserDAO;
import com.yakusokun.model.User;
import com.yakusokun.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private transient UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "メールアドレスとパスワードを入力してください。");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByEmail(email.trim());
        if (user != null) {
            String hash = PasswordUtil.hashPassword(password);
            if (hash != null && hash.equalsIgnoreCase(user.getPasswordDigest())) {
                HttpSession session = request.getSession(true);
                LocalDateTime now = LocalDateTime.now();
                DateTimeFormatter tsFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                DateTimeFormatter tdFormatter = DateTimeFormatter.ofPattern("yyyy-MM");

                session.setAttribute("user", user);
                session.setAttribute("id", user.getId());
                session.setAttribute("timestamp", now.format(tsFormatter));
                session.setAttribute("targetDay", now.format(tdFormatter));

                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
        }

        request.setAttribute("error", "メールアドレスまたはパスワードが正しくありません。");
        request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
    }
}
