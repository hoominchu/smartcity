<%@ page import="smartcity.GeoJSON" %>
<%@ page import="smartcity.EveryNightScripts" %><%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    //EveryNightScripts.writeMinorWorkTypeInDB();
    String redirectURL = "works.jsp?recent=true";
    response.sendRedirect(redirectURL);
%>

