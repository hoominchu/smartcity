<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.mongodb.BasicDBObject"
%>
<%@ page import="smartcity.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<jsp:include page="trial"/>
<%
    long initialTime = System.currentTimeMillis();

    String baseLink = "dashboard.jsp?";
    String dynamicLink = General.genLink();

    String jumbotronParameter = request.getParameter("jumbotron");
    String workTypeParameter = request.getParameter("workType");

    String[] yearParameter = request.getParameterValues("year");

    Map<Integer, String> yearChecked = new HashMap<>();

    BasicDBObject query = new BasicDBObject();

    if (yearParameter == null) {
        query.put("Year", new BasicDBObject("$in", new int[]{2014, 2015, 2016}));
        for (int i = 2014; i < 2017; i++) {
            yearChecked.put(i, "checked");
        }
    }

    if (yearParameter != null) {
        int[] years = new int[yearParameter.length];
        for (int i = 0; i < yearParameter.length; i++) {
            years[i] = Integer.parseInt(yearParameter[i]);

            for (int j = 2014; j < 2017; j++) {
                if (years[i] == j) {
                    yearChecked.put(j, "checked");
                }
            }
        }
        query.put("Year", new BasicDBObject("$in", years));
    }

    if (workTypeParameter != null && workTypeParameter.equals("capital")) {
        query.put("Work Type ID", 1);
    }
    if (workTypeParameter != null && workTypeParameter.equals("maintenance")) {
        query.put("Work Type ID", 2);
    }
    if (workTypeParameter != null && workTypeParameter.equals("emergency")) {
        query.put("Work Type ID", 3);
    }

    Contractor.createContractors();
    //System.out.println("Requests processed and query object generated");

    //System.out.println("New link generated");

    ArrayList<Work> works = Work.createWorkObjects(query);

    Ward.createAllWardObjects(works);
    //System.out.println("Ward objects created");


    try {
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
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

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
    <script>
        function initMap() {
            var mapDiv = document.getElementById('map');
            var map = new google.maps.Map(mapDiv, {
                center: new google.maps.LatLng(15.3935685, 75.08009570000002),
                zoom: 15,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                scrollwheel: false
            });
            var wardBoundariesLayer = new google.maps.KmlLayer({
                url: 'http://hack4hd.org/data/HD-ward-boundaries.kml',
                map: map
            });
            var landmarks = new google.maps.KmlLayer({
                url: 'http://hack4hd.org/data/HD-landmarks.kml',
                map: map
            })
            var hoardings = new google.maps.KmlLayer({
                url: 'http://hack4hd.org/data/HD-hoardings.kml',
                map: map
            })
        }
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?callback=initMap"
            async defer></script>

</head>
<body>
<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="about.jsp">CityForum HD</a>
        </div>

        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="works.jsp?recent=true">Recent Works</a></li>
                <li><a href="works.jsp">All Works</a></li>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="about.jsp">About</a></li>
                <li><a data-toggle="modal" data-target=".modal">Contact</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <img src="images/hdmc-logo.png" width="140em" height="140em"
         style="display:inline-block; margin-right:1em; margin-left:7em;">

    <div id="title-subtitle" style=" display:inline-block;">
        <h2 style="text-align:center;"><a href="index.jsp">Hubballi Dharwad Smart
            Cities Project</a></h2>
        <h6 style="text-align: right">BETA</h6>
    </div>

    <img src="images/smartcitylogo.jpg" width="150em" height="150em"
         style="display:inline-block; margin-left:1em; margin-top:1.2em;">
    <!--
    <div class="pull-right" style="margin-top:40px; text-align: right"><a href="<%=baseLink%>language=kannada">ಕನ್ನಡ</a>
        | <a
                href="">English</a><br><br>
        <a href="about.jsp"> About </a> <br><br>
        <a data-toggle="modal" data-target=".modal"> Contact</a>
    </div>
    -->
    <div style="margin-bottom: 2em">
        <!--
        <form method="post" action="works.jsp">
            <div class="form-group" style="margin-left: auto; margin-right: auto; width: 100%;">

                <input name="queryString" class="form-control round-corner-left" id="focusedInput" type="text"
                       placeholder="Enter your search query here..."
                       style="display: inline-block; width: 65%">
                <button type="submit" class="btn btn-primary round-corner-right"
                        style="display: inline-block; margin-top: -4px; margin-left: -4px; margin-right: 0px; height: 39px"><i
                        class="fa fa-search white-icon" aria-hidden="true"></i> Search
                </button>

                <button type="submit" class="btn btn-primary round-corner-right pull-right"
                        style="display: inline-block; height: 39px"> See all works
                </button>
                <a href="works.jsp?recent=true" class="btn btn-primary round-corner-left pull-right"
                        style="display: inline-block; height: 39px; margin-bottom: 2em"> See recent works
                </a>

            </div>
        </form>


        <div class="btn-group btn-group-justified round-corner" style="margin-bottom: 2em; margin-top: 1em">
            <a href="works.jsp?recent=true" class="btn btn-primary round-corner-left">See recent works</a>
            <a href="works.jsp" class="btn btn-primary round-corner-right">See all works</a>
        </div>
        -->

        <div class="btn-group btn-group-justified">
            <a href="<%=baseLink%>&jumbotron=map&" class="btn btn-default round-corner-top-left">Map</a>
            <a href="<%=baseLink%>&jumbotron=wardsDashboard&" class="btn btn-default">Wardwise Dashboard</a>
            <a href="<%=baseLink%>&jumbotron=topContractors&" class="btn btn-default round-corner-top-right">Top
                Contractors</a>
        </div>

        <div class="jumbotron round-corner-bottom" style="padding: 0px; margin: 0px">

            <%
                if (jumbotronParameter != null && jumbotronParameter.equals("map")) {
            %>
            <div id="map" class="round-corner-bottom" style="width:100%; height: 26em; position: relative"></div>
            <%
            } else if ((jumbotronParameter == null && workTypeParameter == null) || jumbotronParameter != null && jumbotronParameter.equals("wardsDashboard")) { %>
            <div id="wardsDashboardChart" style="width:100%; height:26em;"></div>
            <%
            } else if ((jumbotronParameter != null && workTypeParameter == null) && jumbotronParameter.equals("topContractors")) { %>
            <div id="topContractorsChart" style="width:100%; height:26em;"></div>
            <%
                }

                if ((jumbotronParameter == null && workTypeParameter == null) || jumbotronParameter != null && jumbotronParameter.equals("wardsDashboard")) {
            %>
            <form method="post" action="">
                <div class="checkbox">
                    <label class="margin-left big-checkbox" style="margin-left: 22%; font-size: 10pt">
                        <input type="checkbox" name="year" value="2014"
                               onchange="this.form.submit()" <%=yearChecked.get(2014)%>> 2014
                    </label>

                    <label class="margin-left big-checkbox" style="margin-left: 22%; font-size: 10pt">
                        <input type="checkbox" name="year" value="2015"
                               onchange="this.form.submit()" <%=yearChecked.get(2015)%>> 2015
                    </label>

                    <label class="margin-left big-checkbox" style="margin-left: 22%; font-size: 10pt">
                        <input type="checkbox" name="year" value="2016"
                               onchange="this.form.submit()" <%=yearChecked.get(2016)%>> 2016
                    </label>
                </div>
            </form>

            <div class="btn-group btn-group-justified">
                <a href="<%=baseLink%>&jumbotron=wardsDashboard" class="btn btn-default round-corner-bottom-left">All
                    works</a>
                <a href="<%=baseLink%>&jumbotron=wardsDashboard&workType=capital" class="btn btn-default">Capital
                    works</a>
                <a href="<%=baseLink%>&jumbotron=wardsDashboard&workType=maintenance" class="btn btn-default">Maintenance
                    works</a>
                <a href="<%=baseLink%>&jumbotron=wardsDashboard&workType=emergency&"
                   class="btn btn-default round-corner-bottom-right">Emergency works</a>
            </div>
            <%
                }
            %>

        </div>
    </div>

    <div class="panel panel-default round-corner">
        <div class="panel-heading round-corner-top" style="text-align: center">Category-wise Dashboard</div>
        <div class="panel-body round-corner-bottom">
            <div id="minorWorkTypeChart" style="width: 100%; height: 40em"></div>
        </div>
    </div>

    <hr>
    <h3>13th Finance Summary</h3>
    <div class="row" style="height: 20em">
        <%
            for (int year = 2013; year < 2017; year++) {
        %>
        <div class="col-sm-3">
            <div id="13thfinance<%=year%>" class="piechart"></div>
        </div>
        <%
            }
        %>
    </div>
    <hr>
    <h3>14th Finance Summary</h3>
    <div class="row" style="height: 20em">
        <%
            for (int year = 2016; year < 2017; year++) {
        %>
        <div class="col-sm-3">
            <div id="14thfinance<%=year%>" class="piechart"></div>
        </div>
        <%
            }
        %>
    </div>
</div>

<%
    String[] wardDetails = Ward.getWardDetails();

    String allWardsString = wardDetails[0];
    String allWardsAmountSpent = wardDetails[1];
    String allWardsWorks = wardDetails[2];
    String allWardsCompletedWorks = wardDetails[3];
    String allWardsInprogressWorks = wardDetails[4];
    String allWardsPopulation = wardDetails[5];
    String allWardsPerCapitaExpenditure = wardDetails[6];

    String top50contractors = Contractor.getTop50ContractorsNames();
    String top50contractorsAmount = Contractor.getTop50ContractorsAmount();
    String top50contractorsTotalWorks = Contractor.getTop50ContractorsTotalWorks();
    String top50contractorsInprogressWorks = Contractor.getTop50ContractorsInprogressWorks();
    String top50contractorsCompletedWorks = Contractor.getTop50ContractorsCompletedWorks();

    String[] minorWorkTypeDetails = MinorWorkType.getMinorWorkTypeDetails(MinorWorkType.createMinorWorkTypes());
    String minorWorkTypeMeanings = minorWorkTypeDetails[0];
    String minorWorkTypeCompletedWorks = minorWorkTypeDetails[1];
    String minorWorkTypeInprogressWorks = minorWorkTypeDetails[2];
    String minorWorkTypeTotalWorks = minorWorkTypeDetails[3];
    String minorWorkTypeAmountSpent = minorWorkTypeDetails[4];

    System.out.println(minorWorkTypeAmountSpent.replaceAll(",","\n"));

%>
<script>
    $(function () {
        $('#wardsDashboardChart').highcharts({
            chart: {
                type: 'column'
            },
            tooltip: {
                borderRadius: 12,
                animation: true,
            },
            plotOptions: {
                column: {
                    borderRadius: 0
                },
                series: {
                    cursor: 'pointer',
                    point: {
                        events: {
                            click: function () {
                                location.href = "works.jsp?wardNumber=" + this.category;
                            }
                        }
                    }
                }
            },
            title: {
                text: '<%=smartcity.Filter.getFiltersApplied()%>'
            },
            credits: {
                enabled: true
            },
            xAxis: {
                categories: [<%=allWardsString%>],
                text: 'Wards'
            },
            yAxis: {
                title: {
                    text: 'Magnitude'
                }
            },
            series: [{
                name: 'Total works',
                data: [<%=allWardsWorks%>],
                visible: true
            }, {
                name: 'Completed works',
                data: [<%=allWardsCompletedWorks%>],
                visible: true
            }, {
                name: 'In progress works',
                data: [<%=allWardsInprogressWorks%>],
                visible: true

            }, {
                name: 'Total amount spent',
                data: [<%=allWardsAmountSpent%>],
                visible: false
            }
                <%
                if (workTypeParameter == null & yearParameter == null || (yearParameter != null && yearParameter.length == 3)){
                %>
                , {
                    name: 'Population',
                    data: [<%=allWardsPopulation%>],
                    visible: false
                }, {
                    name: 'Per Capita Expenditure',
                    data: [<%=allWardsPerCapitaExpenditure%>],
                    visible: false
                }
                <%
                }
                %>
            ]
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

        $('#minorWorkTypeChart').highcharts({
            chart: {
                type: 'column'
            },
            tooltip: {
                borderRadius: 12,
                animation: true,
            },
            credits: {
                enabled: true
            },
            title: {
                text: ''
            },
            xAxis: {
                categories: [<%=minorWorkTypeMeanings%>],
                text: 'Wards'
            },
            yAxis: {
                title: {
                    text: 'Magnitude'
                }
            },
            series: [{
                name: 'Total works',
                data: [<%=minorWorkTypeTotalWorks%>],
                visible: true
            }, {
                name: 'Completed works',
                data: [<%=minorWorkTypeCompletedWorks%>],
                visible: true
            }, {
                name: 'In progress works',
                data: [<%=minorWorkTypeInprogressWorks%>],
                visible: true

            }, {
                name: 'Total amount spent',
                data: [<%=minorWorkTypeAmountSpent%>],
                visible: false
            }]
        });

    });
</script>

<script>
    <%
    for (int year = 2013; year < 2017; year++) {
    BasicDBObject finance13 = new BasicDBObject("Source of Income ID", 43);
    finance13.append("Year",year);
    String[] finance13Details = Dashboard.workStatusPieChart(finance13);
    %>
    $(function () {

        $(document).ready(function () {

            // Build the chart
            $('#13thfinance<%=year%>').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text: '13th Finance (General Basic) <%=year%>'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true
                    }
                },
                series: [{
                    name: 'Number of works',
                    colorByPoint: true,
                    data: [{
                        name: 'Completed',
                        y: <%=finance13Details[0]%>
                    }, {
                        name: 'In progress',
                        y: <%=finance13Details[1]%>
                    }]
                }]
            });
        });
    });
    <%
    }
    %>
</script>

<script>
    <%
    for (int year = 2016; year < 2017; year++) {
    BasicDBObject finance14 = new BasicDBObject("Source of Income ID", 51);
    finance14.append("Year",year);
    String[] finance14Details = Dashboard.workStatusPieChart(finance14);
    %>
    $(function () {

        $(document).ready(function () {

            // Build the chart
            $('#14thfinance<%=year%>').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text: '14th Finance (General Basic) <%=year%>'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true
                    }
                },
                series: [{
                    name: 'Number of works',
                    colorByPoint: true,
                    data: [{
                        name: 'Completed',
                        y: <%=finance14Details[0]%>
                    }, {
                        name: 'In progress',
                        y: <%=finance14Details[1]%>
                    }]
                }]
            });
        });
    });
    <%
    }
    %>
</script>

<div class="panel-footer" style="text-align: center; color: grey">
    <small> Data last refreshed on 10th June 2016<br>
        &#169 Hubballi-Dharwad Municipal Corporation 2016
    </small>
    <br>
    <small><a href="about.jsp"> About </a> | <a data-toggle="modal" data-target=".modal"> Contact</a></small>
</div>

<div class="modal">
    <div class="modal-dialog">
        <div class="modal-content round-corner">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Contact Us</h4>
            </div>
            <div class="modal-body">
                <p><h5><b>For any queries or suggestions </b></h5></p>
                <b>Email us</b> <br>
                Mrinalini Kalkeri &mdash; <b>inspection.hdmc@gmail.com</b><br>
                Minchu Kulkarni &mdash; <b>chaitanyashareef.kulkarni@ashoka.edu.in</b><br><br>
                <b>Call us</b> <br>
                HDMC Control Room &mdash; <b>+91 0836 2213888</b></p>
                <hr>
                <p><h5><b>Our Address</b></h5></p>
                <p>MIS Cell, <br>
                    Hubli-Dharwad Municipal Corporation, <br>
                    Sir Siddappa Kambli Road, <br>
                    Hubballi - 580028,
                    Karnataka,
                    India
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default round-corner" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

</body>
<%
        System.out.println("Time taken to load : " + (System.currentTimeMillis() - initialTime));
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
</html>
