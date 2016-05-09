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
         import="smartcity.*"
%>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.PrintWriter" %>

<%
    String workIDParameter = request.getParameter("workID");
    String jumbotronParameter = request.getParameter("jumbotron");

    BasicDBObject workIDQuery = new BasicDBObject();
    //BasicDBObject workDetailsObject = new BasicDBObject();

    workIDQuery.put("Work ID", Integer.parseInt(workIDParameter));

%>
<html>
<head>
    <title>HDMC Smart City Project</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="images/hdmc-logo.ico" type="image/x-icon"/>
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

    <div class="jumbotron" style="height: 26em; padding: 0px; margin: 0px">
        <% if (jumbotronParameter == null || jumbotronParameter.equals("map")) {
        %>
        <div id="map" style="width:100%; height: 100%; position: relative"></div>
        <%
        }
        %>
    </div>

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
            Double totalSpent = 0.0;
            DBCursor workDetailsCursor = Database.workDetailsCollection.find(workIDQuery);

            try {
                while (workDetailsCursor.hasNext()) {
                    DBObject workDetailsObject = workDetailsCursor.next();

                    String stepNumber = workDetailsObject.get("Step").toString();
                    String workStep = workDetailsObject.get("Work Details").toString();
                    String measurement = workDetailsObject.get("Measurement").toString();
                    String unit = workDetailsObject.get("Measurement Unit").toString();
                    String rate = workDetailsObject.get("Rate").toString();

                    Double totalAmount = (Double.parseDouble(measurement)) * (Double.parseDouble(rate));
                    Double truncatedTotal = new BigDecimal(totalAmount).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
                    String totalAmountString = truncatedTotal.toString();
                    String kmlString = workDetailsObject.get("kml").toString();

                    totalSpent = totalSpent + truncatedTotal;

                    PrintWriter kmlFile = new PrintWriter("workKML.kml", "UTF-8");
                    kmlFile.print(kmlString);
        %>
        <tr>
            <td style="text-align: center"><%=stepNumber%>
            </td>
            <td style="padding: 1.2em"><%=workStep%>
            </td>
            <td style="text-align: center"><%=measurement%>
            </td>
            <td style="text-align: center"><%=unit%>
            </td>
            <td style="text-align: center"><%=rate%>
            </td>
            <td style="text-align: center"><%=totalAmountString%>
            </td>

        </tr>
        <%
                }

            } catch (Exception e) {
                System.err.println(e.getClass().getName() + ": " + e.getMessage());
            }
        %>
        <tr>Total amount for this work : <%=totalSpent%></tr>
        </tbody>
    </table>
</div>
<script>
    function initMap() {
        var mapDiv = document.getElementById('map');
        var map = new google.maps.Map(mapDiv, {
            center: new google.maps.LatLng(15.3935685, 75.08009570000002),
            zoom: 15,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        var workKML = new google.maps.KmlLayer({
            url: 'http://hack4hd.org/workIDkmls/<%=workIDParameter%>.kml',
            map: map
        });
    }
</script>
<script src="https://maps.googleapis.com/maps/api/js?callback=initMap"
        async defer></script>
<div class="panel-footer" style="text-align: center">All the data presented here has been provided by Hubli-Dharwad Municipal Corporation</div>
</body>
</html>
