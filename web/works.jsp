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

    String searchPlaceholder = "Enter your search query here...";

    String queryString = request.getParameter("queryString");
    System.out.println(queryString);

    if (queryString != null){
        searchPlaceholder = queryString;
    }

    BasicDBObject myQuery = smartcity.Filter.generateFiltersHashset(request);

    System.out.println("Requests processed and query object generated");

    String baseLink = "works.jsp?";
    String dynamicLink = General.genLink();

    System.out.println("New link generated");

    //DBCursor cursor = Database.allworks.find(myQuery);

    ArrayList<Work> works = Work.createWorkObjects(myQuery);
    System.out.println("Work objects created");

    Set<Work> worksTODisplay = new HashSet<>();

    Set<String> searchResults = new HashSet<>();
    if (queryString != null) {
        searchResults = smartcity.Filter.searchResults(queryString);
    }

    if (queryString == null){
        queryString="";
    }

    //System.out.println(searchResults.size());

    if (searchResults.size() != 0) {
        for (Work work : works) {
            //System.out.println(work.workID);
            for (String workID : searchResults) {
                //System.out.println(workID);
                if (work.workID.toString().equals(workID)) {
                    worksTODisplay.add(work);
                    //break;
                }
            }
        }

        works.clear();

        works.addAll(worksTODisplay);
    }

    int numberOfWorksDisplayed = works.size();

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
    <div class="pull-right" style="margin-top:40px;"><a href="<%=baseLink%><%=dynamicLink%>language=kannada">ಕನ್ನಡ</a> | <a
            href="<%=baseLink%><%=dynamicLink%>">English</a></div>

    <form method="post" action="works.jsp">
        <div class="form-group" style="margin-left: auto; margin-right: auto; width: 100%">
            <input name="queryString" class="form-control" id="focusedInput" type="text" placeholder="<%=searchPlaceholder%>"
                   style="display: inline-block; width: 75%">
            <button type="submit" class="btn btn-primary" style="display: inline-block; margin-top: -4px; margin-left: -4px; height: 39px"><i class="fa fa-search" aria-hidden="true"></i> Search</button>
            <button type="submit" class="btn btn-primary" style="display: inline-block; margin-top: -4px; margin-left: 45px; height: 39px"><i class="fa fa-search" aria-hidden="true"></i> See all works</button>
        </div>
    </form>

    <%
        System.out.println(numberOfWorksDisplayed);
        System.out.println("Q " + queryString);

        if (((numberOfWorksDisplayed > 0) && (searchResults.size() > 0)) || (queryString.equals(""))){
    %>
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
            String dismissalLink = baseLink + dynamicLink.replace(click.parameter + "=" + click.parameterValue, "");
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
            int numberOfWorksQueried = works.size();

            try {
                for (int i = 0; i < numberOfWorksQueried; i++) {

                    int wardNumber = works.get(i).wardNumber;
                    String workDescriptionEnglish = works.get(i).workDescriptionEnglish;
                    String workDescriptionKannada = works.get(i).workDescriptionKannada;
                    String workDescriptionFinal = null;
                    String workOrderDate = works.get(i).workOrderDate;
                    String workCompletionDate = works.get(i).workCompletionDate;
                    String workType = works.get(i).workType;
                    String sourceOfIncome = works.get(i).sourceOfIncome;
                    String contractor = works.get(i).contractor;
                    String amountSanctionedString = works.get(i).amountSanctionedString;

                    //Converting string to integer with commas
                    int amountSanctioned = works.get(i).amountSanctioned;
                    String status = works.get(i).statusfirstLetterCapital;
                    String statusFirstLetterSmall = works.get(i).statusFirstLetterSmall;

                    //Values for backend
                    String workID = works.get(i).workID;
                    String workTypeID = works.get(i).workTypeID;
                    String contractorID = works.get(i).contractorID;
                    String sourceOfIncomeID = works.get(i).sourceOfIncomeID;
                    String statusColor = works.get(i).statusColor;

                    workDescriptionFinal = General.setWorkDescriptionFinal(languageParameter, workDescriptionEnglish, workDescriptionKannada);
        %>
        <tr>
            <td style="text-align: center; padding-left: 0.2em"><a
                    href="<%=baseLink%><%=dynamicLink%>wardNumber=<%=wardNumber%>"><%=wardNumber%>
            </a>
            </td>
            <td style="padding: 1.5em">
                <% if (works.get(i).doWorkDetailsExist) { %>
                <a href="workDetails.jsp?<%=dynamicLink%>workID=<%=workID%>&jumbotron=map">
                    <%=workDescriptionFinal%>
                </a>
                <% } else if (!works.get(i).doWorkDetailsExist) { %>
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
    <%
        }
        else {
            %>
    <div style="text-align: center; margin-bottom: 5%; margin-top: 5%"><h4><p class="text-danger">No results found  for the query </p><a href="#"><h3><%=queryString%></h3></a><br> Please try searching for something else. <br>
        <br>
        <br>
        Here are some examples :
        <br>
        <br>

        "Emergency works in ward 41"<br><br>
        "Inprogress road works in Kalyan Nagar"<br><br>
        "Completed works by S.K. Savadi in ward 13"<br><br>

    </h4></div>
    <%
        }
    %>
</div>

<%
    String allWardsString = Ward.getAllWardNumbersString();
    String allWardsAmountSpent = Ward.getAllWardsAmountSpent();
    String allWardsTotalWorks = Ward.getAllWardsTotalWorks();
    String allWardsCompletedWorks = Ward.getAllWardsCompletedWorks();
    String allWardsInprogressWorks = Ward.getAllWardsInprogressWorks();

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

            }, {name: 'Total works',
                data: [<%=top50contractorsTotalWorks%>],
                visible: false
            }, {
                name: 'Completed works',
                data: [<%=top50contractorsCompletedWorks%>],
                visible: false
            }, {
                name: 'In progress works',
                data: [<%=top50contractorsInprogressWorks%>],

            }]
        });
    });
</script>
<div class="panel-footer" style="text-align: center">All the data presented here has been provided by Hubli-Dharwad
    Municipal Corporation
</div>
</body>
</html>
