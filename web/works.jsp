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
<%@ page import="smartcity.Filter" %>
<%@ page import="smartcity.General" %>
<%@ page import="smartcity.Ward" %>
<%@ page import="smartcity.Work" %>
<%@ page import="java.util.*" %>

<%
    Calendar today = Calendar.getInstance();

    String languageParameter = request.getParameter("language");

    String showRecentParameter = request.getParameter("recent");

    String wardNumberParameter = request.getParameter("wardNumber");

    String searchPlaceholder = "Enter your search query here...";

    String queryString = request.getParameter("queryString");
    System.out.println(queryString);

    if (queryString != null) {
        searchPlaceholder = queryString;
    }

    BasicDBObject myQuery = smartcity.Filter.generateFiltersHashset(request);

    //System.out.println("Requests processed and query object generated");

    String baseLink = "works.jsp?";
    String dynamicLink = General.genLink();

    //System.out.println("New link generated");

    //DBCursor cursor = Database.allworks.find(myQuery);

    ArrayList<Work> works = new ArrayList<Work>();
    System.out.println("Work objects created");

    if (showRecentParameter != null && showRecentParameter.equals("true")) {
        works = Work.getRecentWorks();
    } else {
        works = Work.createWorkObjects(myQuery);
    }
    Set<Work> worksTODisplay = new HashSet<>();

    Set<String> searchResults = new HashSet<>();
    if (queryString != null) {
        searchResults = smartcity.Filter.searchResults(queryString);
    }

    if (queryString == null) {
        queryString = "";
    }

    //System.out.println(searchResults.size());

    if (searchResults.size() != 0) {
        String[] results = searchResults.toArray(new String[searchResults.size()]);
        int[] resultsInt = General.convertToIntArray(results);
        myQuery.put("Work ID", new BasicDBObject("$in", resultsInt));
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

    Integer numberOfWorksDisplayed = new Integer(works.size());
    Long amountSpent = new Long(0);
    int completedWorks = 0;
    int inprogressWorks = 0;

    // Finds the totals of the works displayed.
    for (int i = 0; i < numberOfWorksDisplayed; i++) {
        Work tempWork = works.get(i);
        amountSpent = amountSpent + Long.valueOf(tempWork.amountSanctioned);
        if (tempWork.statusfirstLetterCapital.equals("Completed")) {
            completedWorks++;
        } else {
            inprogressWorks++;
        }
    }

    String amountSpentString = General.rupeeFormat(amountSpent.toString());
    String numberOfWorksDisplayedString = General.rupeeFormat(numberOfWorksDisplayed.toString());

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
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">
    <script type="text/javascript" src="commonfiles/tableExport/tableExport.js"></script>
    <script type="text/javascript" src="commonfiles/tableExport/jquery.base64.js"></script>
    <script type="text/javascript" src="commonfiles/tableExport/jspdf/libs/sprintf.js"></script>
    <script type="text/javascript" src="commonfiles/tableExport/jspdf/jspdf.js"></script>
    <script type="text/javascript" src="commonfiles/tableExport/jspdf/libs/base64.js"></script>

</head>
<body>
<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="about.jsp">Brand</a>
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
    <span>
    <img src="images/hdmc-logo.png" width="140em" height="140em"
         style="display:inline-block; margin-right:1em; margin-left:7em;">

    <div id="title-subtitle" style=" display:inline-block;">
        <h2 style="text-align:center;"><a href="index.jsp">Hubballi Dharwad Smart
            Cities Project</a></h2>
        <h6 style="text-align: right">BETA</h6>
    </div>

    <img src="images/smartcitylogo.jpg" width="150em" height="150em"
         style="display:inline-block; margin-left:1em; margin-top:1.2em;">
    <div class="pull-right" style="margin-top:40px; text-align: right"><a href="<%=baseLink%><%=dynamicLink%>language=kannada">ಕನ್ನಡ</a>
        | <a href="<%=baseLink%><%=dynamicLink%>">English</a><br><br>

    </div>

        </span>
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
        <%
            if (((numberOfWorksDisplayed > 0) && (searchResults.size() > 0)) || (queryString.equals(""))) {
        %>
        <%
            if (wardNumberParameter != null) {

                String[] wardinfo = Ward.getWardInfo(Integer.parseInt(wardNumberParameter));
                String corporatorEnglish = wardinfo[1];
                String corporatorKannada = wardinfo[2];
                String wardMeaning = wardinfo[3];
                String population2011 = wardinfo[4];
        %>

            <div class="panel panel-default round-corner" style="text-align: center">
                <div class="panel-heading">Ward Info</div>
                <div class="panel-body"><h4>
                    Ward Number : <%=wardNumberParameter%>
                    <%
                        if (Integer.parseInt(wardNumberParameter)>67) {
                    %>| Ward meaning : <%=wardMeaning%>
                    <%
                        }
                        else {
                    %>
                    | Population <small>(2011)</small> : <%=General.rupeeFormat(population2011)%>
                    <br>
                    <hr>
                    Corporator : <%=corporatorKannada%> | <%=corporatorEnglish%>
                    <%
                        }
                    %>

                </h4>
                </div>
            </div>

        <%
            }
        %>
        <div class="row">
            <div class="panel panel-default round-corner"
                 style="text-align: center; width: 20%; display: inline-block; margin-right: -5em; margin-left: 1em">
                <div class="panel-heading round-corner-top">Overview</div>
                <div class="panel-body round-corner" style="height: 25em">
                    Number of Works <h4><b><%=numberOfWorksDisplayedString%>
                </b></h4>
                    <hr>
                    In progress <h4><b><%=General.rupeeFormat(inprogressWorks)%>
                </b></h4>
                    <hr>
                    Completed <h4><b><%=General.rupeeFormat(completedWorks)%>
                </b></h4>
                    <hr>
                    Amount Spent <h4><b><%=amountSpentString%>
                </b></h4>
                </div>
            </div>

            <div class="panel panel-default round-corner pull-right"
                 style="text-align: center; width: 75%; display: inline-block; margin-left: -4em; margin-right: 1em">
                <div class="panel-heading round-corner-top">Dashboard</div>
                <div class="panel-body round-corner">
                    <div id="loading-chart-gif" style="height: 10em; width: 100%;">
                        <small>Please wait while the chart loads...</small>
                    </div>
                    <div id="dashboard" style="width:100%; height:23em; z-index: 100; margin-top: -10em"></div>
                </div>
            </div>
        </div>
        <!--
        <div class="row" style="">
            <div class="btn-group btn-group-justified round-corner">
                <a href="works.jsp?workTypeID=1" class="btn btn-default">Capital</a>
                <a href="works.jsp?workTypeID=2" class="btn btn-default">Maintenance</a>
                <a href="works.jsp?workTypeID=5" class="btn btn-default">Contingency</a>
                <a href="works.jsp?workTypeID=3" class="btn btn-default">Emergency</a>
                <a href="works.jsp?workTypeID=4" class="btn btn-default">Hired Vehicle Rent</a>
            </div>
        </div>
        -->
        <%
            Ward.createAllWardObjects(works);

            String[] wardDetails = Ward.getWardDetails();

            String allWardsString = wardDetails[0];
            String allWardsAmountSpent = wardDetails[1];
            String allWardsWorks = wardDetails[2];
            String allWardsCompletedWorks = wardDetails[3];
            String allWardsInprogressWorks = wardDetails[4];

        %>
        <script>
            $(function () {
                $('#dashboard').highcharts({
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: '<%=smartcity.Filter.getFiltersApplied()%>'
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
                    credits: {
                        enabled: false
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
                    }]
                });
            });
        </script>

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
    <span class="label label-primary round-corner"
          style="font-size: 1.1em;"><%=click.parameterPresentable%> : <%=click.parameterValuePresentable%> <a
            href=<%=dismissalLink%>> <i class="fa fa-times-circle white-icon" style="color: white"
                                        aria-hidden="true"></i></a></span>
        <%
            }
        %>

        <div class="btn-group pull-right round-corner-top">
            <a href="#" class="btn btn-default dropdown-toggle round-corner-top" data-toggle="dropdown"
               aria-expanded="false">
                Download Results
                <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
                <li><a href="#"
                       onClick="$('#myTable').tableExport({type:'pdf',pdfFontSize:'7',escape:'false'});">PDF</a>
                </li>
                <li><a href="#" onClick="$('#myTable').tableExport({type:'csv',escape:'false'});">CSV</a></li>
            </ul>
        </div>

        <table class="table table-striped table-responsive sortable" id="myTable"
               style="margin-top:2em; width: 100%; table-layout: fixed">

            <thead>
            <tr>
                <th style="width: 3%; padding: 2px; text-align: center">Ward</th>
                <th style="width: 25%; padding: 2px; text-align: left">Work Description</th>
                <th style="width: 8%; padding: 2px; text-align: center">Work Order Date</th>
                <th style="width: 8%; padding: 2px; text-align: center">Work Completion Date</th>
                <th style="width: 7%; padding: 2px; text-align: center">Work Type</th>
                <th style="width: 3%; padding: 2px; text-align: center">Year</th>
                <th style="width: 10%; padding: 2px; text-align: center">Source Of Income</th>
                <th style="width: 8%; padding: 2px; text-align: center">Contractor</th>
                <th style="width: 7%; padding: 2px; text-align: center">Amount Sanctioned</th>
                <th style="width: 7%; padding: 2px; text-align: center">Bill Paid</th>
                <th style="width: 7%; padding: 2px; text-align: center">Difference</th>
                <th style="width: 7%; padding: 2px; text-align: center">Status</th>
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

                        Calendar completionDate = General.createDate(workCompletionDate);
                        String dateColor = "";

                        String sourceOfIncome = works.get(i).sourceOfIncome;

                        String contractor = works.get(i).contractor;
                        String amountSanctionedString = works.get(i).amountSanctionedString;
                        int amountSanctioned = (int) works.get(i).amountSanctioned;
                        Integer billPaid = new Integer(works.get(i).billPaid);

                        int difference = amountSanctioned - billPaid;

                        String year = works.get(i).year;

                        String status = works.get(i).statusfirstLetterCapital;
                        String statusFirstLetterSmall = works.get(i).statusFirstLetterSmall;

                        //Values for backend
                        String workID = works.get(i).workID;
                        String workTypeID = works.get(i).workTypeID;
                        String contractorID = works.get(i).contractorID;
                        String sourceOfIncomeID = works.get(i).sourceOfIncomeID;
                        String statusColor = works.get(i).statusColor;
                        //String tenderApprovalDate = works.get(i).tenderApprovalDate;
                        //String customSortKeyTenderDate = General.customSortKeySortTableJS(tenderApprovalDate);

                        String billPaidColor = General.setBillPaidColor(amountSanctioned, billPaid);

                        boolean highlight;
                        if (today.after(completionDate) && status.equals("Inprogress")) {
                            dateColor = "red";
                            highlight = true;
                        }

                        workDescriptionFinal = General.setWorkDescriptionFinal(languageParameter, workDescriptionEnglish, workDescriptionKannada);
            %>
            <tr>
                <td style="text-align: center; padding-left: 0.2em"><a
                        href="<%=baseLink%><%=dynamicLink%>wardNumber=<%=wardNumber%>"><%=wardNumber%><br>
                </a>

                </td>

                <td>
                    <a href="workDetails.jsp?<%=dynamicLink%>workID=<%=workID%>&jumbotron=billDetails">
                        <%=workDescriptionFinal%>
                    </a>
                    <br>
                    <% if (works.get(i).doWorkDetailsExist) { %>
                    <i class="fa fa-list-ul"
                       style="font-size: 10pt; margin-top: 2px"
                       aria-hidden="true" title="This work has more details"></i>
                    <% }
                        if (billPaid > 0) {
                    %>
                    <i class="fa fa-money"
                       style="font-size: 10pt; margin-top: 2px; margin-left: 5px"
                       aria-hidden="true" title="This work has details of bills paid"></i>
                    <%
                        }
                    %>
                </td>
                <td sorttable_customkey="<%=General.customSortKeySortTableJS(workOrderDate)%>"
                    style="text-align: center"><%=workOrderDate%>
                </td>
                <td sorttable_customkey="<%=General.customSortKeySortTableJS(workCompletionDate)%>"
                    style="text-align: center; color: <%=dateColor%>"><%=workCompletionDate%>
                </td>
                <td style="text-align: center"><a
                        href="<%=baseLink%><%=dynamicLink%>workTypeID=<%=workTypeID%>"><%=workType%>
                </a>
                </td>
                <td style="text-align: center"><a
                        href="<%=baseLink%><%=dynamicLink%>year=<%=year%>"><%=year%>
                </a>
                </td>
                <td style="text-align: center; overflow: hidden"><a
                        href="<%=baseLink%><%=dynamicLink%>sourceOfIncomeID=<%=sourceOfIncomeID%>"><%=sourceOfIncome%>
                </a>
                </td>
                <td style="text-align: center"><a
                        href="<%=baseLink%><%=dynamicLink%>contractorID=<%=contractorID%>"><%=contractor%>
                </a>
                </td>
                <td style="text-align: center"><%=General.rupeeFormat(amountSanctionedString)%>
                </td>
                <td style="text-align: center; color: <%=billPaidColor%>">
                    <%
                        if (billPaid > 0) {
                    %><%=General.rupeeFormat(billPaid.toString())%>
                    <%
                    } else {
                    %>
                    Not paid
                    <%
                        }
                    %>
                </td>
                <td style="text-align: center; color: <%=billPaidColor%>">
                    <%
                        if (difference != 0 && billPaid > 0) {
                    %><%=General.rupeeFormat(difference)%>
                    <%
                    } else if (difference == 0) {
                    %>
                    Exact amount has been paid
                    <%
                    } else if (billPaid == 0) {
                    %>
                    NA
                    <%
                        }
                    %>
                </td>
                <td style="text-align: left; padding-right: 0.2em; color: <%=statusColor%>; text-decoration: none"><a
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
        <a href="#" class="scrollup round-corner">Go to top</a>
        <%
        } else {
        %>
        <div style="text-align: center; margin-bottom: 5%; margin-top: 5%">
            <h4><p class="text-danger">No results found for the query </p><a href="#"><h3><%=queryString%>
            </h3></a><br> Please try searching for something else. <br>
                <br>
                <br>
                Here are some examples :
                <br>
                <br>

                "Emergency works in ward 41"<br><br>
                "Inprogress road works in Kalyan Nagar"<br><br>
                "Completed works by S.K. Savadi in ward 13"<br><br>

            </h4>
        </div>
        <%
            }
        %>
    </div>
</div>
<div class="panel-footer" style="text-align: center; color: grey">
    <small> Data last refreshed on 10th June 2016<br>
        &#169 Hubballi-Dharwad Municipal Corporation 2016</small>
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
</html>