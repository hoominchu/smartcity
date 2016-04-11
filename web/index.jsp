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
         import="java.lang.Integer"
%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>

<%-- Functions required are defined here --%>


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

            <th style="width: 3%">Ward</th>
            <th style="width: 47%">Work Description</th>
            <th style="width: 5%">Work Order Date</th>
            <th style="width: 5%">Work Completion Date</th>
            <th style="width: 5%">Work Type</th>
            <th style="width: 5%">Source of Income</th>
            <th style="width: 10%">Contractor</th>
            <th style="width: 10%">Amount Sanctioned</th>
            <th style="width: 10%">Status</th>

        </tr>
        </thead>
        <tbody>

        <%
//WorkResults wr = mymethod(request);

            try {

                Mongo mongo = new Mongo();

                DB db = mongo.getDB("smartcitydb");

                DBCollection smartcity = db.getCollection("allworks");

                List filters = new ArrayList();

                String wardNumberParameter = request.getParameter("wardNumber");
                String statusParameter = request.getParameter("status");
                String workTypeIDParameter = request.getParameter("workTypeID");
                String contractorIDParameter = request.getParameter("contractorID");
                String sourceOfIncomeIDParameter = request.getParameter("sourceOfIncomeID");

                BasicDBObject wardQuery = new BasicDBObject();

                if (wardNumberParameter != null) {
                    wardQuery.put("Ward Number", Integer.parseInt(wardNumberParameter));
                    filters.add(wardNumberParameter);
                }

                if (statusParameter != null){
                    wardQuery.put("Status",statusParameter);
                    filters.add(statusParameter);
                }

                if (workTypeIDParameter != null){
                    wardQuery.put("Work Type ID",Integer.parseInt(workTypeIDParameter));
                    filters.add(workTypeIDParameter);
                }

                if (contractorIDParameter != null){
                    wardQuery.put("Contractor ID", Integer.parseInt(contractorIDParameter));
                    filters.add(contractorIDParameter);
                }

                if (sourceOfIncomeIDParameter != null){
                    wardQuery.put("Source of Income ID", Integer.parseInt(sourceOfIncomeIDParameter));
                    filters.add(sourceOfIncomeIDParameter);
                }

                Iterator filtersIter = filters.iterator();

                while (filtersIter.hasNext()){
                    String call = filtersIter.next().toString();
                    System.out.println(call);
                }

                DBCursor cursor = smartcity.find(wardQuery);

                while (cursor.hasNext()) {
                    DBObject workObject = cursor.next();

                    String wardNumber = workObject.get("Ward Number").toString();
                    String workDescriptionEnglish = workObject.get("Work Description English").toString();
                    String workOrderDate = workObject.get("Work Order Date").toString();
                    String workCompletionDate = workObject.get("Work Completion Date").toString();
                    String workType = workObject.get("Work Type").toString();
                    String sourceOfIncome = workObject.get("Source of Income").toString();
                    String contractor = workObject.get("Contractor").toString();
                    String amountSanctioned = workObject.get("Amount Sanctioned").toString();
                    String status = workObject.get("Status").toString();

                    //Values for backend
                    String workID = workObject.get("Work ID").toString();
                    String workTypeID = workObject.get("Work Type ID").toString();
                    String contractorID = workObject.get("Contractor ID").toString();
                    String sourceOfIncomeID = workObject.get("Source of Income ID").toString();

        %>
        <tr>
            <td><a href="index.jsp?wardNumber=<%=wardNumber%>"><%=wardNumber%></a>
            </td>
            <td><a href="index.jsp?workID=<%=workID%>"><%=workDescriptionEnglish%></a>
            </td>
            <td><%=workOrderDate%>
            </td>
            <td><%=workCompletionDate%>
            </td>
            <td><a href="index.jsp?workTypeID=<%=workTypeID%>"><%=workType%></a>
            </td>
            <td><a href="index.jsp?sourceOfIncomeID=<%=sourceOfIncomeID%>"><%=sourceOfIncome%></a>
            </td>
            <td><a href="index.jsp?contractorID=<%=contractorID%>"><%=contractor%></a>
            </td>
            <td><%=amountSanctioned%>
            </td>
            <td><a href="index.jsp?status=<%=status%>"><%=status%></a>
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
