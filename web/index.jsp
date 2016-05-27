<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="smartcity.*"
%>
<%
    long initialTime = System.currentTimeMillis();
    String languageParameter = request.getParameter("language");
    String jumbotronParameter = request.getParameter("jumbotron");
    String workTypeParameter = request.getParameter("workType");

    System.out.println("Requests processed and query object generated");

    String baseLink = "index.jsp?";

    System.out.println("New link generated");

    System.out.println((int) Database.wardmaster.count());

    Ward.createAllWardObjects();
    System.out.println("Ward objects created");

    Contractor.createContractors();
    System.out.println("Contractor objects created");

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
    <script src="commonfiles/maps.js"></script>
    <script src="http://maps.googleapis.com/maps/api/js"></script>
    <script>
        var src = 'http://hack4hd.org/data/HD-ward-boundaries.kml';
    </script>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>

    <script>
        window.x = document.getElementById("demo");
        function getLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(showPosition);
            } else {
                window.x.innerHTML = "Geolocation is not supported by this browser.";
            }
        }
        function showPosition(position) {
            window.x.innerHTML = "Latitude: " + position.coords.latitude +
                    "<br>Longitude: " + position.coords.longitude;
        }
    </script>

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

    <form method="post" action="works.jsp">
        <div class="form-group" style="margin-left: auto; margin-right: auto; width: 100%;">
            <input name="queryString" class="form-control round-corner-left" id="focusedInput" type="text"
                   placeholder="Enter your search query here..."
                   style="display: inline-block; width: 75%">
            <button type="submit" class="btn btn-primary round-corner-right"
                    style="display: inline-block; margin-top: -4px; margin-left: -4px; height: 39px"><i
                    class="fa fa-search" aria-hidden="true"></i> Search
            </button>
            <button type="submit" class="btn btn-primary round-corner"
                    style="display: inline-block; margin-top: -4px; margin-left: 45px; height: 39px"><i
                    class="fa fa-search" aria-hidden="true"></i> See all works
            </button>
        </div>
    </form>

    <div class="btn-group btn-group-justified">
        <a href="<%=baseLink%>&jumbotron=map&" class="btn btn-default round-corner-top-left">Map</a>
        <a href="<%=baseLink%>&jumbotron=wardExpenses&" class="btn btn-default">Wardwise Dashboard</a>
        <a href="<%=baseLink%>&jumbotron=topContractors&" class="btn btn-default round-corner-top-right">Top Contractors</a>
    </div>

    <div class="jumbotron round-corner-bottom" style="height: 26em; padding: 0px; margin: 0px">

        <%
            if (jumbotronParameter != null && jumbotronParameter.equals("wardExpenses")) {
                if (workTypeParameter != null && workTypeParameter.equals("capital")) {
        %>
        <div id="capitalChart"></div>
        <%
        } else if (workTypeParameter != null && workTypeParameter.equals("maintenance")) {
        %>
        <div id="maintenanceChart"></div>
        <%
        } else if (workTypeParameter != null && workTypeParameter.equals("emergency")) {
        %>
        <div id="emergencyChart"></div>
        <%
                }
            }
            if ((jumbotronParameter == null && workTypeParameter == null) || jumbotronParameter != null && jumbotronParameter.equals("map")) {
        %>
        <div id="map" class="round-corner-bottom" style="width:100%; height: 100%; position: relative"></div>
        <%
        } else if ((jumbotronParameter != null && workTypeParameter == null) && jumbotronParameter.equals("wardExpenses")) { %>
        <div id="wardExpensesChart" style="width:100%; height:100%;"></div>
        <%
        } else if ((jumbotronParameter != null && workTypeParameter == null) && jumbotronParameter.equals("topContractors")) { %>
        <div id="topContractorsChart" style="width:100%; height:100%;"></div>
        <%
            }

            if (jumbotronParameter != null && jumbotronParameter.equals("wardExpenses")) {
        %>
        <div class="btn-group btn-group-justified">
            <a href="<%=baseLink%>&jumbotron=wardExpenses" class="btn btn-default round-corner-bottom-left">All works</a>
            <a href="<%=baseLink%>&jumbotron=wardExpenses&workType=capital&" class="btn btn-default">Capital works</a>
            <a href="<%=baseLink%>&jumbotron=wardExpenses&workType=maintenance&" class="btn btn-default">Maintenance works</a>
            <a href="<%=baseLink%>&jumbotron=wardExpenses&workType=emergency&" class="btn btn-default round-corner-bottom-right">Emergency works</a>
        </div>
        <%
            }
        %>

    </div>
</div>

<%
    String[] wardDetails = Ward.getWardDetails();
    String[] capitalDetails = Ward.getCapitalWorksDetails();
    String[] maintenanceDetails = Ward.getMaintenanceDetails();
    String[] emergencyDetails = Ward.getEmergencyDetails();

    String allWardsString = wardDetails[0];
    String allWardsAmountSpent = wardDetails[1];
    String allWardsTotalWorks = wardDetails[2];
    String allWardsCompletedWorks = wardDetails[3];
    String allWardsInprogressWorks = wardDetails[4];
    String allWardsPopulation = wardDetails[5];
    String allWardsPerCapitaExpenditure = wardDetails[6];

    String capitalAmountSpent = capitalDetails[1];
    String capitalWorks = capitalDetails[2];
    String capitalCompletedWorks = capitalDetails[3];
    String capitalInprogressWorks = capitalDetails[4];

    String maintenanceAmountSpent = maintenanceDetails[1];
    String maintenanceWorks = maintenanceDetails[2];
    String maintenanceCompletedWorks = maintenanceDetails[3];
    String maintenanceInprogressWorks = maintenanceDetails[4];

    String emergencyAmountSpent = emergencyDetails[1];
    String emergencyWorks = emergencyDetails[2];
    String emergencyCompletedWorks = emergencyDetails[3];
    String emergencyInprogressWorks = emergencyDetails[4];

    String top50contractors = Contractor.getTop50ContractorsNames();
    String top50contractorsAmount = Contractor.getTop50ContractorsAmount();
    String top50contractorsTotalWorks = Contractor.getTop50ContractorsTotalWorks();
    String top50contractorsInprogressWorks = Contractor.getTop50ContractorsInprogressWorks();
    String top50contractorsCompletedWorks = Contractor.getTop50ContractorsCompletedWorks();

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
            }, {
                name: 'Population',
                data: [<%=allWardsPopulation%>],
                visible: false
            }, {
                name: 'Per Capita Expenditure',
                data: [<%=allWardsPerCapitaExpenditure%>],
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

            }, {
                name: 'Total works',
                data: [<%=top50contractorsTotalWorks%>],
                visible: false
            }, {
                name: 'Completed works',
                data: [<%=top50contractorsCompletedWorks%>],
                visible: false
            }, {
                name: 'In progress works',
                data: [<%=top50contractorsInprogressWorks%>],
                visible: false
            }]
        });

        $('#capitalChart').highcharts({
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
                name: 'Capital works',
                data: [<%=capitalWorks%>],
                visible: false
            }, {
                name: 'Completed capital works',
                data: [<%=capitalCompletedWorks%>],
                visible: false
            }, {
                name: 'In progress capital works',
                data: [<%=capitalInprogressWorks%>],

            }, {
                name: 'Amount spent on capital works',
                data: [<%=capitalAmountSpent%>],
                visible: false
            }]
        });

        $('#maintenanceChart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Maintenance works dashboard'
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
                name: 'Maintenance works',
                data: [<%=maintenanceWorks%>],
                visible: false
            }, {
                name: 'Completed maintenance works',
                data: [<%=maintenanceCompletedWorks%>],
                visible: false
            }, {
                name: 'In progress maintenance works',
                data: [<%=maintenanceCompletedWorks%>],

            }, {
                name: 'Amount spent on maintenance works',
                data: [<%=maintenanceCompletedWorks%>],
                visible: false
            }]
        });

        $('#emergencyChart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Emergency works dashboard'
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
                name: 'Emergency works',
                data: [<%=emergencyWorks%>],
                visible: false
            }, {
                name: 'Completed emergency works',
                data: [<%=emergencyCompletedWorks%>],
                visible: false
            }, {
                name: 'In progress emergency works',
                data: [<%=emergencyInprogressWorks%>],

            }, {
                name: 'Amount spent on emergency ',
                data: [<%=emergencyAmountSpent%>],
                visible: false
            }]
        });


    });
</script>
<div class="panel-footer" style="text-align: center; margin-top: 5em"> &#169 Hubballi-Dharwad Municipal Corporation 2016
</div>
</body>
<%
    System.out.println(System.currentTimeMillis() - initialTime);
%>
</html>
