<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.mongodb.*"
         import="smartcity.*"
         import="java.util.*"
         import="smartcity.Filter"
%>
<%
    String languageParameter = request.getParameter("language");
    String jumbotronParameter = request.getParameter("jumbotron");

    BasicDBObject myQuery = smartcity.Filter.generateFiltersHashset(request);

    String baseLink = "index.jsp?";
    String dynamicLink = General.genLink();

    DBCursor cursor = Database.allworks.find(myQuery);
    int numberOfWorksDisplayed = cursor.count();

    Work[] works = Work.createWorkObjects(myQuery);

    Ward.createAllWardObjects();

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

    <style>
        .fa {
            color: white;
            margin: 2px;
        }
    </style>

    <script>
        function initMap() {
            var mapDiv = document.getElementById('map');
            var map = new google.maps.Map(mapDiv, {
                center: new google.maps.LatLng(15.3935685, 75.08009570000002),
                zoom: 15,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });
            var wardBoundariesLayer = new google.maps.KmlLayer({
                url: 'http://hack4hd.org/data/HD-ward-boundaries.kml',
                map: map
            });
        }
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?callback=initMap"
            async defer></script>

</head>
<body>

<div class="container">
    <img src="images/hdmc-logo.png" width="140em" height="140em"
         style="display:inline-block; margin-right:1em; margin-left:7em;">

    <h2 style="text-align:center; display:inline-block;"><a href="index.jsp">Hubballi Dharwad Smart
        Cities Project</a></h2>

    <img src="images/smartcitylogo.jpg" width="150em" height="150em"
         style="display:inline-block; margin-left:1em; margin-top:1.2em;">
    <div class="pull-right" style="margin-top:40px;"><a href="<%=baseLink%>language=kannada">ಕನ್ನಡ</a> | <a
            href="<%=baseLink%>">English</a></div>

    <div class="btn-group btn-group-justified">
        <a href="<%=baseLink%><%=dynamicLink%>&jumbotron=map&" class="btn btn-default">Map</a>
        <a href="<%=baseLink%><%=dynamicLink%>&jumbotron=wardExpenses&" class="btn btn-default">Wardwise Dashboard</a>
        <a href="<%=baseLink%><%=dynamicLink%>&jumbotron=topContractors&" class="btn btn-default">Top Contractors</a>
    </div>

    <div class="jumbotron" style="height: 26em; padding: 0px; margin: 0px">
        <% if (jumbotronParameter == null || jumbotronParameter.equals("map")) {
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
        dynamicLink = dynamicLink + "&language=kannada&";
    }
        dynamicLink = dynamicLink.replaceAll("&&", "&");
    %>
    <%
        Iterator filtersApplied = smartcity.Filter.FILTERS.iterator();

        while (filtersApplied.hasNext()) {
            Filter click = (Filter) filtersApplied.next();
            String dismissalLink = "index.jsp?" + dynamicLink.replace(click.parameter + "=" + click.parameterValue, "");
            dismissalLink = dismissalLink.substring(0, dismissalLink.lastIndexOf("&"));
    %>
    <span class="label label-primary"
          style="font-size: 1.1em;"><%=click.parameterPresentable%> : <%=click.parameterValuePresentable%> <a
            href=<%=dismissalLink%>> <i class="fa fa-times-circle" aria-hidden="true"></i></a></span>
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
            int numberOfWorksQueried = works.length;
            try {
                for (int i = 0; i < numberOfWorksQueried; i++) {

                    int wardNumber = works[i].wardNumber;
                    String workDescriptionEnglish = works[i].workDescriptionEnglish;
                    String workDescriptionKannada = works[i].workDescriptionKannada;
                    String workDescriptionFinal = null;
                    String workOrderDate = works[i].workOrderDate;
                    String workCompletionDate = works[i].workCompletionDate;
                    String workType = works[i].workType;
                    String sourceOfIncome = works[i].sourceOfIncome;
                    String contractor = works[i].contractor;
                    String amountSanctionedString = works[i].amountSanctionedString;

                    //Converting string to integer with commas
                    int amountSanctioned = works[i].amountSanctioned;
                    String status = works[i].statusfirstLetterCapital;
                    String statusFirstLetterSmall = works[i].statusFirstLetterSmall;

                    //Values for backend
                    String workID = works[i].workID;
                    String workTypeID = works[i].workTypeID;
                    String contractorID = works[i].contractorID;
                    String sourceOfIncomeID = works[i].sourceOfIncomeID;
                    String statusColor = works[i].statusColor;

                    workDescriptionFinal = General.setWorkDescriptionFinal(languageParameter, workDescriptionEnglish, workDescriptionKannada);
        %>
        <tr>
            <td style="text-align: center; padding-left: 0.2em"><a
                    href="<%=baseLink%><%=dynamicLink%>wardNumber=<%=wardNumber%>"><%=wardNumber%>
            </a>
            </td>
            <td style="padding: 1.5em">
                <% if (works[i].doWorkDetailsExist) { %>
                <a href="workDetails.jsp?<%=dynamicLink%>workID=<%=workID%>&jumbotron=map">
                    <%=workDescriptionFinal%>
                </a>
                <% } else if (!works[i].doWorkDetailsExist) { %>
                <%=workDescriptionFinal%>
                <% } %>
            </td>
            <td style="text-align: center"><%=workOrderDate%>
            </td>
            <td style="text-align: center"><%=workCompletionDate%>
            </td>
            <td style="text-align: center"><a
                    href="<%=baseLink%><%=dynamicLink%>workTypeID=<%=workTypeID%>"><%=workType%>
            </a>
            </td>
            <td style="text-align: center"><a
                    href="<%=baseLink%><%=dynamicLink%>sourceOfIncomeID=<%=sourceOfIncomeID%>"><%=sourceOfIncome%>
            </a>
            </td>
            <td style="text-align: center"><a
                    href="<%=baseLink%><%=dynamicLink%>contractorID=<%=contractorID%>"><%=contractor%>
            </a>
            </td>
            <td style="text-align: center"><%=amountSanctioned%>
            </td>
            <td style="text-align: center; padding-right: 0.2em; color: <%=statusColor%>; text-decoration: none"><a
                    href="<%=baseLink%><%=dynamicLink%>status=<%=statusFirstLetterSmall%>"><%=status%>
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

<%
    String allWardsString = Ward.getAllWardNumbersString();
    String allWardsAmountSpent = Ward.getAllWardsAmountSpent();
    String allWardsTotalWorks = Ward.getAllWardsTotalWorks();
    String allWardsCompletedWorks = Ward.getAllWardsCompletedWorks();
    String allWardsInprogressWorks = Ward.getAllWardsInprogressWorks();

    Contractor.createContractors();
    String top50contractors = Contractor.getTop50ContractorsNames();
    String top50contractorsAmount = Contractor.getTop50ContractorsAmount();
    System.out.println(top50contractorsAmount);
%>
<script>
    $(function () {
        $('#wardExpensesChart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Ward wise dashboard'
            },
            credits: {
                enabled: true
            },
            xAxis: {
                categories: [<%=allWardsString%>]
            },
            yAxis: {
                title: {
                    text: 'Magnitude'
                }
            },
            series: [{
                name: 'Total works',
                data: [<%=allWardsTotalWorks%>],
                visible: false
            }, {
                name: 'Completed works',
                data: [<%=allWardsCompletedWorks%>],
                visible: false
            }, {
                name: 'In progress works',
                data: [<%=allWardsInprogressWorks%>],

            }, {
                name: 'Total amount spent',
                data: [<%=allWardsAmountSpent%>],
                visible: false
            }]
        });

        $('#topContractorsChart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Top 50 Contractors by Amount'
            },
            credits: {
                enabled: true
            },
            xAxis: {
                categories: [<%=top50contractors%>]
            },
            yAxis: {
                title: {
                    text: 'Magnitude'
                }
            },
            series: [{
                name: 'Total contract amount',
                data: [<%=top50contractorsAmount%>],
                visible: true

            }]
        });
    });
</script>
<div class="panel-footer" style="text-align: center">All the data presented here has been provided by Hubli-Dharwad
    Municipal Corporation
</div>
</body>
</html>
