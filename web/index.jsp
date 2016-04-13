<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.mongodb.*"
         import="java.lang.Integer"
%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.stream.Collectors" %>

<%-- Functions required are defined here --%>
<%!
    public static String capitalizeFirstLetter(String input) {
        String output = input.substring(0, 1).toUpperCase() + input.substring(1);
        return output;
    }

    public class ClickStack {
        String parameter;
        String parameterValue;
        //String parameterPresentable;
        //String parameterValuePresentable;

        ClickStack(String p, String pV) {
            this.parameter = p;
            this.parameterValue = pV;
            //this.parameterPresentable = pP;
            //this.parameterValuePresentable = pVP;
        }
    }

    ArrayList filters = new ArrayList();
%>
<%
    DecimalFormat IndianCurrencyFormat = new DecimalFormat("##,##,##,###.0");

    Mongo mongo = new Mongo();

    DB db = mongo.getDB("smartcitydb");

    DBCollection allworks = db.getCollection("allworks");
    DBCollection corporatorsCollection = db.getCollection("corporatorsC");
    DBCollection workDetailsCollection = db.getCollection("workdetails");

    String wardNumberParameter = request.getParameter("wardNumber");
    String statusParameter = request.getParameter("status");
    String workTypeIDParameter = request.getParameter("workTypeID");
    String contractorIDParameter = request.getParameter("contractorID");
    String sourceOfIncomeIDParameter = request.getParameter("sourceOfIncomeID");
    String languageParameter = request.getParameter("language");

    String jumbotronParameter = request.getParameter("jumbotron");

    BasicDBObject myQuery = new BasicDBObject();

    String baseLink = "index.jsp?";

    filters.clear();
    filters = (ArrayList) filters.stream().distinct().collect(Collectors.toList());

    if (wardNumberParameter != null) {
        myQuery.put("Ward Number", Integer.parseInt(wardNumberParameter));

        ClickStack click = new ClickStack("wardNumber", wardNumberParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (statusParameter != null) {
        myQuery.put("Status", statusParameter);

        ClickStack click = new ClickStack("status", statusParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (workTypeIDParameter != null) {
        myQuery.put("Work Type ID", Integer.parseInt(workTypeIDParameter));

        ClickStack click = new ClickStack("workTypeID", workTypeIDParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (contractorIDParameter != null) {
        myQuery.put("Contractor ID", Integer.parseInt(contractorIDParameter));

        ClickStack click = new ClickStack("contractorID", contractorIDParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (sourceOfIncomeIDParameter != null) {
        myQuery.put("Source of Income ID", Integer.parseInt(sourceOfIncomeIDParameter));

        ClickStack click = new ClickStack("sourceOfIncomeID", sourceOfIncomeIDParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    Iterator filtersIter = filters.iterator();
    String newLink = "";

    while (filtersIter.hasNext()) {
        ClickStack call = (ClickStack) filtersIter.next();

        newLink = newLink + call.parameter + "=" + call.parameterValue + "&";
    }

    DBCursor cursor = allworks.find(myQuery);
    int numberOfWorksDisplayed = cursor.count();

%>

<%!

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
    <script src="commonfiles/maps.js"></script>
    <script src="http://maps.googleapis.com/maps/api/js"></script>
    <script>
        var src = 'http://hack4hd.org/data/HD-ward-boundaries.kml';
    </script>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>

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

    <div class="btn-group btn-group-justified">
        <a href="<%=baseLink%><%=newLink%>&jumbotron=map&" class="btn btn-default">Map</a>
        <a href="<%=baseLink%><%=newLink%>&jumbotron=wardExpenses&" class="btn btn-default">Ward expenditure</a>
        <a href="<%=baseLink%><%=newLink%>&jumbotron=topcontractors&" class="btn btn-default">Top Contractors</a>
    </div>

    <div class="jumbotron" style="height: 26em; padding: 0px; margin: 0px">
        <% if (jumbotronParameter == null || jumbotronParameter.equals("map")) {
            System.out.println(jumbotronParameter);
        %>
        <div id="map" style="width:100%; height: 100%; position: relative"></div>
        <%
        } else if (jumbotronParameter != null && jumbotronParameter.equals("wardExpenses")) { %>
        <div id="wardExpensesChart" style="width:100%; height:100%;"></div>
        <%
        } else if (jumbotronParameter != null && jumbotronParameter.equals("topContractors")) { %>
        <div id="topContractorsChart" style="width:100%; height:100%;"></div>
        <%
            }
        %>
    </div>

    <h4>Number of works : <%=numberOfWorksDisplayed%>
    </h4>

    <% if (languageParameter != null) {
        newLink = newLink + "&language=kannada&";
    }
        newLink = newLink.replaceAll("&&", "&");
    %>
    <%
        Iterator filtersApplied = filters.iterator();

        while (filtersApplied.hasNext()) {
            ClickStack click = (ClickStack) filtersApplied.next();
            String dismissalLink = "index.jsp?" + newLink.replace(click.parameter + "=" + click.parameterValue, "");
            dismissalLink = dismissalLink.substring(0, dismissalLink.lastIndexOf("&"));
    %>
    <span class="label label-default"
          style="font-size: 1em; color: inherit"><%=click.parameter%> : <%=click.parameterValue%> <a
            href=<%=dismissalLink%>> <i class="fa fa-trash-o" aria-hidden="true"></i></a></span>
    <%
        }

    %>


    <table class="table-striped table-responsive sortable" id="myTable"
           style="margin-top:2em; width: 100%; table-layout: fixed">

        <thead>

        <tr>

            <th style="width: 3%; padding: 2px; text-align: center">Ward</th>
            <th style="width: 40%; padding: 2px; text-align: center">Work Description</th>
            <th style="width: 6%; padding: 2px; text-align: center">Work Order Date</th>
            <th style="width: 6%; padding: 2px; text-align: center">Work Completion Date</th>
            <th style="width: 10%; padding: 2px; text-align: center">Work Type</th>
            <th style="width: 10%; padding: 2px; text-align: center">Source of Income</th>
            <th style="width: 13%; padding: 2px; text-align: center">Contractor</th>
            <th style="width: 7%; padding: 2px; text-align: center">Amount Sanctioned</th>
            <th style="width: 5%; padding: 2px; text-align: center">Status</th>

        </tr>
        </thead>
        <tbody>

        <%
            //WorkResults wr = mymethod(request);

            try {

                while (cursor.hasNext()) {
                    DBObject workObject = cursor.next();

                    String wardNumber = workObject.get("Ward Number").toString();
                    String workDescriptionEnglish = workObject.get("Work Description English").toString();
                    String workDescriptionKannada = workObject.get("Work Description Kannada").toString();

                    String workDescriptionFinal = null;

                    String workOrderDate = workObject.get("Work Order Date").toString();
                    String workCompletionDate = workObject.get("Work Completion Date").toString();
                    String workType = workObject.get("Work Type").toString();
                    String sourceOfIncome = workObject.get("Source of Income").toString();
                    String contractor = workObject.get("Contractor").toString();
                    String amountSanctionedString = workObject.get("Amount Sanctioned").toString();
                    //Converting string to integer with commas
                    String amountSanctioned = IndianCurrencyFormat.format(Double.parseDouble(amountSanctionedString));

                    String status = workObject.get("Status").toString();
                    String statusFirstLetterCapital = capitalizeFirstLetter(status);

                    //Values for backend
                    String workID = workObject.get("Work ID").toString();
                    String workTypeID = workObject.get("Work Type ID").toString();
                    String contractorID = workObject.get("Contractor ID").toString();
                    String sourceOfIncomeID = workObject.get("Source of Income ID").toString();
                    String statusColor = null;

                    if (status.equals("completed")) {
                        statusColor = "#43ac6a";
                    } else if (status.equals("inprogress")) {
                        statusColor = "#f04124";
                    }

                    if (languageParameter == null || languageParameter.equals("english")) {
                        if (workDescriptionEnglish.length() > 2) {
                            workDescriptionFinal = workDescriptionEnglish;
                        } else {
                            workDescriptionFinal = workDescriptionKannada;
                        }
                    } else if (languageParameter.equals("kannada")) {
                        workDescriptionFinal = workDescriptionKannada;
                    }
        %>
        <tr>
            <td style="text-align: center; padding-left: 0.2em"><a
                    href="index.jsp?wardNumber=<%=wardNumber%>"><%=wardNumber%>
            </a>
            </td>
            <td style="padding: 1.5em">
                <%
                    BasicDBObject doWorkDetailsExist = new BasicDBObject();
                    doWorkDetailsExist.put("Work ID", Integer.parseInt(workID));
                    int numOfWorkDetails = workDetailsCollection.find(doWorkDetailsExist).count();

                    if (numOfWorkDetails>0){
                %>
                <a href="workDetails.jsp?<%=newLink%>workID=<%=workID%>">
                    <%}%>
                    <%=workDescriptionFinal%>
                    <% if (numOfWorkDetails>0){%>
                </a>
                <%}%>
            </td>
            <td style="text-align: center"><%=workOrderDate%>
            </td>
            <td style="text-align: center"><%=workCompletionDate%>
            </td>
            <td style="text-align: center"><a href="index.jsp?<%=newLink%>workTypeID=<%=workTypeID%>"><%=workType%>
            </a>
            </td>
            <td style="text-align: center"><a
                    href="index.jsp?<%=newLink%>sourceOfIncomeID=<%=sourceOfIncomeID%>"><%=sourceOfIncome%>
            </a>
            </td>
            <td style="text-align: center"><a
                    href="index.jsp?<%=newLink%>contractorID=<%=contractorID%>"><%=contractor%>
            </a>
            </td>
            <td style="text-align: center"><%=amountSanctioned%>
            </td>
            <td style="text-align: center; padding-right: 0.2em; color: <%=statusColor%>;"><a
                    href="index.jsp?<%=newLink%>status=<%=status%>"><%=statusFirstLetterCapital%>
            </a>
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
    <a href="#" class="scrollup">Go to top</a>
</div>

<script>
    function initMap() {
        var mapDiv = document.getElementById('map');
        var map = new google.maps.Map(mapDiv, {
            center: new google.maps.LatLng(15.3935685, 75.08009570000002),
            zoom: 15,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        var ctaLayer = new google.maps.KmlLayer({
            url: 'http://hack4hd.org/data/HD-ward-boundaries.kml',
            map: map
        });
    }
</script>
<script src="https://maps.googleapis.com/maps/api/js?callback=initMap"
        async defer></script>

<script>
    $(function () {
        $('#wardExpensesChart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Monthly Average Rainfall'
            },
            subtitle: {
                text: 'Source: WorldClimate.com'
            },
            xAxis: {
                categories: [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec'
                ],
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Rainfall (mm)'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                name: 'Tokyo',
                data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]

            }, {
                name: 'New York',
                data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]

            }, {
                name: 'London',
                data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]

            }, {
                name: 'Berlin',
                data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]

            }]
        });
    });
</script>
</body>
</html>
