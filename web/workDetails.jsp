<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 12/04/16
  Time: 10:20 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.mongodb.BasicDBObject"
         import="com.mongodb.DBCursor"
         import="com.mongodb.DBObject"
%>
<%@ page import="smartcity.Bill" %>
<%@ page import="smartcity.Database" %>
<%@ page import="smartcity.General" %>
<%@ page import="smartcity.Work" %>
<%@ page import="java.io.File" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.ArrayList" %>

<%
    String workIDParameter = request.getParameter("workID");
    String jumbotronParameter = request.getParameter("jumbotron");

    String baseLink = "workDetails.jsp?";
    String worksPage = "works.jsp?";

    String imagePath = "images/works/71108";

    BasicDBObject workIDQuery = new BasicDBObject();
    //BasicDBObject workDetailsObject = new BasicDBObject();

    workIDQuery.put("Work ID", Integer.parseInt(workIDParameter));

    ArrayList<Work> work = Work.createWorkObjects(workIDQuery);

    BasicDBObject billPaidQuery = new BasicDBObject();
    billPaidQuery.put("Recid", Integer.parseInt(workIDParameter));
    ArrayList<Bill> bills = Bill.createBills(billPaidQuery);

    int totalBillPaid = 0;

    String statusColorParameter;
    if (work.get(0).statusFirstLetterSmall.equals("inprogress")) {
        statusColorParameter = "danger";
    } else {
        statusColorParameter = "success";
    }
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

    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

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
<script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

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
    </div>

    <div class="panel panel-default round-corner" style="text-align: center">
        <div class="panel-heading round-corner-top">Description</div>
        <div class="panel-body round-corner">
            <%=General.cleanText(work.get(0).workDescriptionEnglish)%>
        </div>
    </div>

    <div class="btn-group btn-group-justified">
        <a href="<%=baseLink%>workID=<%=workIDParameter%>&jumbotron=billDetails"
           class="btn btn-default round-corner-top-left">Billing Details</a>
        <a href="<%=baseLink%>workID=<%=workIDParameter%>&jumbotron=map" class="btn btn-default round-corner-top-left">Map</a>
        <a href="<%=baseLink%>workID=<%=workIDParameter%>&jumbotron=info"
           class="btn btn-default round-corner-top-right">Work Info</a>
    </div>

    <div class="jumbotron round-corner-bottom" style="padding: 0px; margin-bottom: 2em">
        <%
            if (jumbotronParameter == null || jumbotronParameter.equals("billDetails")) {

                if (bills.size() > 0) {
        %>

        <table class="table table-striped table-hover" style="font-size: 10pt; text-align: center">
            <thead>

            </thead>
            <tbody style="width: 100%;">
            <tr>
                <td> Main Category : <b><%=bills.get(0).mainCategory%>
                </b>
                </td>
            </tr>

            <tr>
                <td> Passed Category : <b><%=bills.get(0).passedCategory%>
                </b>
                </td>
            </tr>

            <tr>
                <td> Contractor : <b><%=bills.get(0).contractor%>
                </b>
                </td>
            </tr>
            </tbody>
        </table>
        <hr>
        <table class="table table-striped table-hover" style="font-size: 10pt; text-align: center">
            <thead>
            <tr>
                <th style="text-align: center"> Sl No.</th>
                <th style="text-align: center"> Description</th>
                <th style="text-align: center"> Pass Date</th>
                <th style="text-align: center"> Pass Amount</th>
                <th style="text-align: center"> Paid Date</th>
                <th style="text-align: center"> Paid Amount</th>
            </tr>
            </thead>
            <tbody>
            <%
                int slno = 0;

                for (Bill bill : bills) {
                    slno++;
                    totalBillPaid = totalBillPaid + Integer.parseInt(bill.paidAmount);
            %>
            <tr>
                <td><%=slno%>
                </td>
                <td><%=bill.descriptionEnglish%>
                </td>

                <td><%=bill.billPassDate%>
                </td>

                <td>&#8377 <%=General.rupeeFormat(bill.billPassAmount)%>
                </td>

                <td><%=bill.paidDate%>
                </td>

                <td>&#8377 <%=General.rupeeFormat(bill.paidAmount)%>
                </td>
            </tr>

            <%
                }
            %>
            </tbody>
        </table>
        <hr>
        <table>
            <tbody>
            <tr style="padding-bottom: 10px; text-align: center">
                Total bill paid : <b>&#8377 <%=General.rupeeFormat(new Integer(totalBillPaid).toString())%>
            </b>
            </tr>
            </tbody>
        </table>
        <%
        } else {
        %>
        <h4 style="text-align: center; padding: 15%;"><u><b>Bill not yet paid</b></u></h4>
        <%
            }
        } else if (jumbotronParameter == null || jumbotronParameter.equals("map")) {
        %>
        <div id="map" class="round-corner-bottom" style="width:100%; height: 26em; position: relative"></div>
        <%
        } else if (jumbotronParameter.equals("info")) {
            for (Bill bill : bills) {
                totalBillPaid = totalBillPaid + Integer.parseInt(bill.paidAmount);
            }
        %>
        <div id="workInfo" style="width: 100%; position: relative;">
            <div class="panel panel-default">
                <div class="panel-body">

                    <table class="table table-striped table-hover" style="font-size: 10pt;">
                        <thead>

                        </thead>
                        <tbody>
                        <tr>
                            <td style="text-align: right; width: 50%"> Ward :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>wardNumber=<%=work.get(0).wardNumber%>"><%=work.get(0).wardNumber%>
                            </a>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Work Type :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>workTypeID=<%=work.get(0).workTypeID%>"><%=work.get(0).workType%>
                            </a>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Source of Income :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>sourceOfIncomeID=<%=work.get(0).sourceOfIncomeID%>"><%=work.get(0).sourceOfIncome%>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Year :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>year=<%=work.get(0).year%>"><%=work.get(0).year%>
                            </a>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Work Order Date :</td>
                            <td style="text-align: left"><b><%=work.get(0).workOrderDate%>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Work Completion Date :</td>
                            <td style="text-align: left"><b><%=work.get(0).workCompletionDate%>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Contractor :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>contractorID=<%=work.get(0).contractorID%>"><%=work.get(0).contractor%>
                            </a>
                            </b>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right; width: 50%"> Contractor's contact :</td>
                            <td style="text-align: left"><b>+91 93 22 323213</b>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right; width: 50%"> Amount Sanctioned :</td>
                            <td style="text-align: left"><b>
                                &#8377 <%=General.rupeeFormat(work.get(0).amountSanctionedString)%>
                            </b>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right; width: 50%"> Amount Paid :</td>
                            <td style="text-align: left"><b><%
                                if (totalBillPaid != 0) { %>
                                &#8377 <%=General.rupeeFormat(new Integer(totalBillPaid).toString())%>
                                <%
                                } else {
                                %>
                                Bill not yet paid
                                <%
                                    }
                                %>
                            </b>
                            </td>
                        </tr>

                        <tr class="<%=statusColorParameter%>">
                            <td style="text-align: right; width: 50%"> Status :</td>
                            <td style="text-align: left"><b
                                    style="color: <%=work.get(0).statusColor%>"><%=work.get(0).statusfirstLetterCapital%>
                            </b>
                            </td>
                        </tr>
                        <%
                            if (work.get(0).statusfirstLetterCapital.equals("Completed")) {
                        %>
                        <tr>
                            <td style="padding-top: 12px; height: 2em; text-align: center; font-size: 10pt">If you are
                                unsatisfied with the quality of this work or have any other complaints, <a
                                        href="http://www.mrc.gov.in/janahita/LoadGrievanceForm"> click here.</a></td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <%
        if (Database.workDetails.find(workIDQuery).size() > 0) {
    %>
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
            DBCursor workDetailsCursor = Database.workDetails.find(workIDQuery);

            try {
                while (workDetailsCursor.hasNext()) {
                    DBObject workDetailsObject = workDetailsCursor.next();

                    String stepNumber = workDetailsObject.get("Step").toString();
                    String workStep = workDetailsObject.get("Work Details").toString();
                    String measurement = workDetailsObject.get("Measurement").toString();
                    String unit = workDetailsObject.get("Measurement Unit").toString();
                    String rate = workDetailsObject.get("Rate").toString();

                    Double totalAmount = (Double.parseDouble(measurement)) * (Double.parseDouble(rate));
                    Double truncatedTotal = new BigDecimal(totalAmount).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
                    String totalAmountString = truncatedTotal.toString();
                    //String kmlString = workDetailsObject.get("kml").toString();

                    totalSpent = totalSpent + truncatedTotal;
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
            <td style="text-align: center"><%=General.rupeeFormat(totalAmountString)%>
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

    <h4>Total amount spent is &#8377 <%=General.rupeeFormat(new Long(totalSpent.longValue()).toString())%>
    </h4>

    <%
        }
        File imageDir = new File(imagePath).getCanonicalFile();
        //System.out.println(imageDir.getAbsolutePath());
        File[] imageFiles = imageDir.listFiles();

        //if (imageFiles != null) {
    %>
    <hr>
    <h4><b>Photos submitted by the contractor</b></h4>
    <p class="text-warning">Photos yet to be uploaded</p>
    <div class="work-images" style="height: 18em; margin-top: 1.5em; margin-bottom: 1.5em">

        <%
            for (int i = 0; i < 4; i++) {
        %>
        <div class="slick-slide"><img src="images/works/71108/<%=i%>.jpg" style="height: 18em; opacity: 0.4"><h4>Add
            photos here</h4></div>
        <%
            }
        %>

    </div>

    <div id="disqus_thread"></div>

    <script>
        /**
         * RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
         * LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables
         */

        var disqus_config = function () {
            //this.page.url = URL; // Replace PAGE_URL with your page's canonical URL variable
            this.page.identifier = <%=workIDParameter%>; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
        };

        (function () { // DON'T EDIT BELOW THIS LINE
            var d = document, s = d.createElement('script');

            s.src = '//hdmc.disqus.com/embed.js';

            s.setAttribute('data-timestamp', +new Date());
            (d.head || d.body).appendChild(s);
        })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments
        powered by Disqus.</a></noscript>

</div>

<script>
    function initMap() {
        var mapDiv = document.getElementById('map');
        var map = new google.maps.Map(mapDiv, {
            center: new google.maps.LatLng(15.3935685, 75.08009570000002),
            zoom: 15,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            scrollwheel: false
        });
        var workKML = new google.maps.KmlLayer({
            url: 'http://hack4hd.org/workIDkmls/<%=workIDParameter%>.kml',
            map: map
        });
    }
</script>
<script src="https://maps.googleapis.com/maps/api/js?callback=initMap"
        async defer></script>

<script type="text/javascript">
    $(document).ready(function () {
        $('.work-images').slick({
            slidesToShow: 3,
            slidesToScroll: 1,
            dots: true,
            arrows: true,
            variableWidth: true,

        });
    });
</script>

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