<%@ page import="java.util.List,model.Medicine" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% List<Medicine> medicineList=(List<Medicine>)request.getAttribute("medicineList"); List<java.util.Map<String,Object>> recentSales=(List<java.util.Map<String,Object>>)request.getAttribute("recentSales"); %>
<!DOCTYPE html><html><head><title>Sales & Billing</title><link rel="stylesheet" href="css/style.css"></head><body>
<main class="page-content"><h1>Sales & Billing</h1>
<% if(request.getParameter("invoice")!=null){ %><div class="alert alert-success">Invoice created: <strong><%=security.HtmlUtil.escape(request.getParameter("invoice"))%></strong></div><% } %>
<% if(request.getParameter("error")!=null){ %><div class="alert alert-danger">Sale failed: <%=security.HtmlUtil.escape(request.getParameter("error"))%></div><% } %>
<form method="post" action="${pageContext.request.contextPath}/sales"><input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
<table class="data-table"><thead><tr><th>Medicine</th><th>Quantity</th></tr></thead><tbody id="saleRows"><tr><td><select name="medicineId" required><% for(Medicine m:medicineList){ if(!m.isExpired() && m.getQuantity()>0){ %><option value="<%=m.getMedicineId()%>"><%=security.HtmlUtil.escape(m.getMedicineName())%> - ₹<%=m.getSellingPrice()%> (stock <%=m.getQuantity()%>)</option><% }} %></select></td><td><input type="number" name="quantity" min="1" required></td></tr></tbody></table>
<label>Discount <input type="number" name="discount" min="0" step="0.01" value="0"></label><button type="submit" class="btn btn-primary">Create Invoice</button></form>
<h2>Recent invoices</h2><table class="data-table"><thead><tr><th>Invoice</th><th>Subtotal</th><th>Discount</th><th>Total</th><th>Date</th></tr></thead><tbody><% if(recentSales!=null){ for(java.util.Map<String,Object> sale:recentSales){ %><tr><td><%=security.HtmlUtil.escape(String.valueOf(sale.get("invoice")))%></td><td>₹<%=sale.get("subtotal")%></td><td>₹<%=sale.get("discount")%></td><td>₹<%=sale.get("total")%></td><td><%=sale.get("createdAt")%></td></tr><% }} %></tbody></table>
</main></body></html>
