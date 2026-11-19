<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sushruta Pharmacy | Inventory Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%231d4ed8'><path d='M19 10.5h-5.5V5c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v5.5H5c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5h5.5V19c0 .83.67 1.5 1.5 1.5s1.5-.67 1.5-1.5v-5.5H19c.83 0 1.5-.67 1.5-1.5s-.67-1.5-1.5-1.5z'/></svg>">
</head>
<body class="login-page">

    <div class="login-card-container">
        <!-- Logo and Brand Header -->
        <div class="login-header">
            <div class="pharmacy-logo-badge">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 2v20M2 12h20M7 7l10 10M17 7L7 17" opacity="0.15" stroke-width="3"/>
                    <rect x="3" y="3" width="18" height="18" rx="5" stroke-width="2"/>
                    <path d="M12 7v10M7 12h10" stroke-width="2.5" stroke="currentColor"/>
                </svg>
            </div>
            <h1 class="login-title">Sushruta Pharmacy</h1>
            <p class="login-subtitle">Pharmacy Inventory Management System</p>
        </div>

        <!-- Alert Notification (if error or logout) -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="10" stroke-width="2"/>
                    <line x1="12" y1="8" x2="12" y2="12" stroke-width="2"/>
                    <circle cx="12" cy="16" r="1" fill="currentColor"/>
                </svg>
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <c:if test="${param.error eq 'unauthorized'}">
            <div class="alert alert-danger" role="alert">
                <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="10" stroke-width="2"/>
                    <line x1="12" y1="8" x2="12" y2="12" stroke-width="2"/>
                    <circle cx="12" cy="16" r="1" fill="currentColor"/>
                </svg>
                <span>Please sign in with valid credentials to access pharmacy records.</span>
            </div>
        </c:if>

        <c:if test="${param.error eq 'forbidden'}">
            <div class="alert alert-danger" role="alert">
                <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="10" stroke-width="2"/>
                    <line x1="12" y1="8" x2="12" y2="12" stroke-width="2"/>
                    <circle cx="12" cy="16" r="1" fill="currentColor"/>
                </svg>
                <span>Access Denied: You do not have the required administrative role.</span>
            </div>
        </c:if>

        <c:if test="${param.loggedOut eq 'true'}">
            <div class="alert alert-success" role="alert">
                <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
                <span>You have been successfully logged out.</span>
            </div>
        </c:if>

        <!-- Login Form -->
<form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
            <!-- Username Input -->
            <div class="form-group">
                <label for="username" class="form-label">Username <span class="required">*</span></label>
                <div class="input-icon-wrapper">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    <input type="text" id="username" name="username" class="form-control" 
                           placeholder="Enter your username" required 
                           value="${enteredUsername != null ? enteredUsername : ''}" autocomplete="username">
                </div>
            </div>

            <!-- Password Input -->
            <div class="form-group">
                <label for="password" class="form-label">Password <span class="required">*</span></label>
                <div class="input-icon-wrapper">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter your password" required autocomplete="current-password">
                </div>
            </div>

            <!-- Role Dropdown -->
            <div class="form-group">
                <label for="role" class="form-label">User Role <span class="required">*</span></label>
                <div class="input-icon-wrapper">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                        <circle cx="8.5" cy="7" r="4"/>
                        <polyline points="17 11 19 13 23 9"/>
                    </svg>
                    <select id="role" name="role" class="form-control select-control" required>
                        <option value="" disabled ${empty selectedRole ? 'selected' : ''}>-- Select Your Role --</option>
                        <option value="Pharmacist" ${selectedRole eq 'Pharmacist' ? 'selected' : ''}>Pharmacist</option>
                        <option value="Inventory Manager" ${selectedRole eq 'Inventory Manager' ? 'selected' : ''}>Inventory Manager</option>
                    </select>
                </div>
            </div>

            <!-- Forgot Password & Helper links -->
            <div style="display: flex; justify-content: flex-end; margin-bottom: 22px;">
                <a href="javascript:void(0)" onclick="showForgotPasswordModal()" style="font-size: 13px; font-weight: 500;">
                    Forgot Password?
                </a>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary btn-block" style="padding: 12px;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4M10 17l5-5-5-5M15 12H3"/>
                </svg>
                Sign In to System
            </button>
        </form>

    </div>

    <!-- Forgot Password Modal -->
    <dialog id="forgotPasswordModal" class="modal-dialog">
        <div class="modal-header">
            <h3>Password Assistance</h3>
            <button type="button" class="modal-close-btn" onclick="document.getElementById('forgotPasswordModal').close()">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <div class="modal-body">
            <p style="font-size: 14px; color: var(--dark-muted); line-height: 1.6; margin-bottom: 12px;">
                For security reasons in <strong>Sushruta Pharmacy System</strong>, password resets are handled directly by the Pharmacy System Administrator.
            </p>
            <p style="font-size: 13.5px; color: var(--text-muted); background: #f8fafc; padding: 12px; border-radius: 8px; border: 1px solid var(--border);">
                Please contact the pharmacy IT administrator at <strong>admin@sushrutapharmacy.com</strong> for password assistance.
            </p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-outline btn-sm" onclick="document.getElementById('forgotPasswordModal').close()">Close</button>
        </div>
    </dialog>

    <script src="${pageContext.request.contextPath}/js/script.js"></script>
    <script>
        function showForgotPasswordModal() {
            document.getElementById('forgotPasswordModal').showModal();
        }

    </script>
</body>
</html>
