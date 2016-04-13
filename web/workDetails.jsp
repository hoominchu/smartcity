<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 12/04/16
  Time: 10:20 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.mongodb.*"
         import="java.lang.Integer"
%>

<%
    Mongo mongo = new Mongo();

    DB db = mongo.getDB("smartcitydb");

    DBCollection workDetailsCollection = db.getCollection("workdetails");

    String workIDParameter = request.getParameter("workID");
    System.out.println(workIDParameter);

    BasicDBObject workIDQuery = new BasicDBObject();

    workIDQuery.put("Work ID", Integer.parseInt(workIDParameter));

    DBCursor cursor = workDetailsCollection.find(workIDQuery);

    System.out.println(cursor.count());
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

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">
</head>
<body>

<div class="container">
    <img src="images/hdmc-logo.png" width="140em" height="140em"
         style="display:inline-block; margin-right:1em; margin-left:7em;">

    <h2 style="text-align:center; display:inline-block;"><a href="index.jsp">Hubballi Dharwad Smart
        Cities Project</a></h2>

    <img src="images/smartcitylogo.jpg" width="150em" height="150em"
         style="display:inline-block; margin-left:1em; margin-top:1.2em;">
    <div class="pull-right" style="margin-top:40px;"><a href="index.jsp?language=kannada">ಕನ್ನಡ</a> | <a
            href="index.jsp">English</a></div>

    <table class="table-striped table-responsive sortable" id="myTable"
           style="margin-top:2em; width: 100%; table-layout: fixed">

        <thead>

        <tr>

            <th style="width: 3%; padding: 2px; text-align: center">Sl No.</th>
            <th style="width: 40%; padding: 2px; text-align: center">Work Details</th>
            <th style="width: 6%; padding: 2px; text-align: center">Measurement</th>
            <th style="width: 6%; padding: 2px; text-align: center">Unit</th>
            <th style="width: 10%; padding: 2px; text-align: center">Rate</th>
            <th style="width: 7%; padding: 2px; text-align: center">Amount</th>

        </tr>
        </thead>
        <tbody>

        <%
            //WorkResults wr = mymethod(request);

            try {

                while (cursor.hasNext()) {
                    DBObject workObject = cursor.next();


                    String workStep = workObject.get("Work Details").toString();
                    String measurement = workObject.get("Measurement").toString();
                    String unit = workObject.get("Measurement Unit").toString();
                    String rate = workObject.get("Rate").toString();

                    //Double totalAmount = (Double.parseDouble(workObject.get("Measurement"))) * (Double.parseDouble(workObject.get("Rate")));
                    //String totalAmountString = totalAmount.toString();

        %>
        <tr>
            <td><%=workStep%>
            </td>
            <td><%=measurement%>
            </td>
            <td><%=unit%>
            </td>
            <td><%=rate%>
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
