<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.mongodb.*"
         import="java.util.Arrays"
%>

<%-- Functions required are defined here --%>
<%!
    public BasicDBObject setQuery(String s, int n){
        BasicDBObject query = new BasicDBObject();
        query.put(s,n);
        return query;
    }
%>

<html>
<head>
    <title>HDMC Smart City Project</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="commonfiles/sorttable.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap.css">
    <script src="commonfiles/jquery.min.js"></script>
    <script src="commonfiles/bootstrap.min.js"></script>
    <script src="commonfiles/addons.js"></script>
</head>
<body>

<div class="container">
    <img src="images/hdmc-logo.png" width="140em" height="140em"
         style="display:inline-block; margin-right:1em; margin-left:7em;">

    <h2 style="text-align:center; display:inline-block;"><a href="../allworks/allworks.html">Hubballi Dharwad Smart
        Cities Project</a></h2>

    <img src="images/smartcitylogo.jpg" width="150em" height="150em"
         style="display:inline-block; margin-left:1em; margin-top:1.2em;">
    <div class="pull-right" style="margin-top:40px;"><a href="allworks_k.html" target="_blank">ಕನ್ನಡ</a> | <a
            href="allworks.html" target="_blank">English</a></div>

    <table class="table-striped table-responsive sortable" id="myTable" style="margin-top:2em">

        <thead>

        <tr>

            <th>Ward</th>
            <th>Work Description</th>
            <th>Work Order Date</th>
            <th>Work Completion Date</th>
            <th>Work Type</th>
            <th>Source of Income</th>
            <th>Contractor</th>
            <th>Amount Sanctioned</th>
            <th>Status</th>

        </tr>
        </thead>
        <tbody>

        <%

            try {

                Mongo mongo = new Mongo();

                DB db = mongo.getDB("mydb");

                DBCollection smartcity = db.getCollection("smartcity");

                //BasicDBObject wardQuery = setQuery("Ward Number", 3);

                String parameter = request.getParameter("wardNumber");

                System.out.println(parameter);

                DBCursor cursor = smartcity.find();

                while (cursor.hasNext()) {
                    DBObject workObject = cursor.next();

                    String wardNumber = workObject.get("Ward Number").toString();
                    String workDescriptionEnglish = (String) workObject.get("Work Description English");
                    String workOrderDate = (String) workObject.get("Work Order Date");
                    String workCompletionDate = (String) workObject.get("Work Completion Date");
                    String workType = (String) workObject.get("Capital");
                    String sourceOfIncome = (String) workObject.get("Source of Income");
                    String contractor = (String) workObject.get("Contractor");
                    String amountSanctioned = workObject.get("Amount Sanctioned").toString();
                    String status = (String) workObject.get("Status");

                    //System.out.println(workObject.get("Amount Sanctioned"));
        %>
        <tr>
            <td><a href="index.jsp?wardNumber=<%=wardNumber%>"><%=wardNumber%></a>
            </td>
            <td><%=workDescriptionEnglish%>
            </td>
            <td><%=workOrderDate%>
            </td>
            <td><%=workCompletionDate%>
            </td>
            <td><%=workType%>
            </td>
            <td><%=sourceOfIncome%>
            </td>
            <td><%=contractor%>
            </td>
            <td><%=amountSanctioned%>
            </td>
            <td><%=status%>
            </td>
        </tr>

        <%
                }
            } catch (Exception e) {
                System.err.println(e.getClass().getName() + ": " + e.getMessage());
            }
        %>

        </tbody>
    </table>
</div>

</body>
</html>
