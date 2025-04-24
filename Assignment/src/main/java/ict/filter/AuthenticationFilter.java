/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.filter;

/**
 *
 * @author AlexS
 */
import ict.bean.UserBean;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/shop/*", "/warehouse/*", "/management/*"})
public class AuthenticationFilter implements Filter {

    public AuthenticationFilter() {
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("userInfo") != null);

        if (isLoggedIn) {
            // User is logged in, check role access
            UserBean user = (UserBean) session.getAttribute("userInfo");
            String url = httpRequest.getRequestURI();

            if (url.contains("/shop/") && !user.getRole().equals("shop_staff")) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/error401.jsp");
                return;
            } else if (url.contains("/warehouse/") && !user.getRole().equals("warehouse_staff")) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/error401.jsp");
                return;
            } else if (url.contains("/management/") && !user.getRole().equals("senior_management")) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/error401.jsp");
                return;
            }

            // If role is correct, continue with the request
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        }
    }

    @Override
    public void destroy() {
    }
}
