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
         import="smartcity.*"
%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.stream.Collectors" %>

<%-- Functions required are defined here --%>
<%!
    ArrayList filters = new ArrayList();
%>
<%
    DecimalFormat IndianCurrencyFormat = new DecimalFormat("##,##,##,###.0");

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
    //filters = (ArrayList) filters.stream().distinct().collect(Collectors.toList());

    if (wardNumberParameter != null) {
        myQuery.put("Ward Number", Integer.parseInt(wardNumberParameter));

        ClickStack click = new ClickStack("wardNumber", wardNumberParameter, "Ward Number", "Ward Number");
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (statusParameter != null) {
        myQuery.put("Status", statusParameter);

        ClickStack click = new ClickStack("status", statusParameter, "Status", "Status");
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (workTypeIDParameter != null) {
        myQuery.put("Work Type ID", Integer.parseInt(workTypeIDParameter));

        ClickStack click = new ClickStack("workTypeID", workTypeIDParameter, "Work Type", "Work Type ID");
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (contractorIDParameter != null) {
        myQuery.put("Contractor ID", Integer.parseInt(contractorIDParameter));

        ClickStack click = new ClickStack("contractorID", contractorIDParameter, "Contractor", "Contractor ID");
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (sourceOfIncomeIDParameter != null) {
        myQuery.put("Source of Income ID", Integer.parseInt(sourceOfIncomeIDParameter));

        ClickStack click = new ClickStack("sourceOfIncomeID", sourceOfIncomeIDParameter, "Source of Income", "Source of Income ID");
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

    DBCursor cursor = Database.allworks.find(myQuery);
    int numberOfWorksDisplayed = cursor.count();

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
        .fa{
            color: white;
            margin: 2px;
        }
    </style>

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
        <a href="<%=baseLink%><%=newLink%>&jumbotron=map&" class="btn btn-default">Map</a>
        <a href="<%=baseLink%><%=newLink%>&jumbotron=wardExpenses&" class="btn btn-default">Wardwise Dashboard</a>
        <a href="<%=baseLink%><%=newLink%>&jumbotron=topContractors&" class="btn btn-default">Top Contractors</a>
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
                    String statusFirstLetterCapital = functionsGeneral.capitalizeFirstLetter(status);

                    //Values for backend
                    String workID = workObject.get("Work ID").toString();
                    String workTypeID = workObject.get("Work Type ID").toString();
                    String contractorID = workObject.get("Contractor ID").toString();
                    String sourceOfIncomeID = workObject.get("Source of Income ID").toString();
                    String statusColor = null;
                    String kml = workObject.get("kml").toString();

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
                    href="<%=baseLink%><%=newLink%>wardNumber=<%=wardNumber%>"><%=wardNumber%>
            </a>
            </td>
            <td style="padding: 1.5em">
                <a href="workDetails.jsp?<%=newLink%>workID=<%=workID%>&jumbotron=map">
                    <%=workDescriptionFinal%>
                </a>
            </td>
            <td style="text-align: center"><%=workOrderDate%>
            </td>
            <td style="text-align: center"><%=workCompletionDate%>
            </td>
            <td style="text-align: center"><a href="<%=baseLink%><%=newLink%>workTypeID=<%=workTypeID%>"><%=workType%>
            </a>
            </td>
            <td style="text-align: center"><a
                    href="<%=baseLink%><%=newLink%>sourceOfIncomeID=<%=sourceOfIncomeID%>"><%=sourceOfIncome%>
            </a>
            </td>
            <td style="text-align: center"><a
                    href="<%=baseLink%><%=newLink%>contractorID=<%=contractorID%>"><%=contractor%>
            </a>
            </td>
            <td style="text-align: center"><%=amountSanctioned%>
            </td>
            <td style="text-align: center; padding-right: 0.2em; color: <%=statusColor%>; text-decoration: none"><a
                    href="<%=baseLink%><%=newLink%>status=<%=status%>"><%=statusFirstLetterCapital%>
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
        var wardBoundariesLayer = new google.maps.KmlLayer({
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
                text: 'Ward wise dashboard'
            },
            credits: {
                enabled: true
            },
            xAxis: {
                categories: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 81, 82, 83, 85, 86, 90, 91, 93, 96, 97, 98, 100, 102, 103, 104, 106, 108, 109, 110, 111]
            },
            yAxis: {
                title: {
                    text: 'Magnitude'
                }
            },
            series: [{
                name: 'Total works',
                data: [87, 65, 62, 103, 85, 96, 73, 89, 96, 63, 205, 242, 98, 187, 102, 181, 100, 62, 77, 85, 48, 77, 232, 130, 214, 147, 137, 129, 85, 122, 209, 47, 67, 71, 257, 126, 181, 139, 134, 381, 258, 123, 78, 129, 296, 363, 415, 71, 30, 79, 53, 101, 190, 155, 136, 55, 89, 83, 240, 112, 99, 104, 92, 70, 92, 115, 96, 50, 31, 44, 125, 209, 290, 85, 132, 159, 174, 474, 300, 580, 121, 26, 78, 570, 23, 399, 347, 37, 90, 31, 231, 82, 485, 1, 71, 46, 1],
                visible: false
            }, {
                name: 'Completed works',
                data: [61, 50, 40, 81, 65, 68, 58, 71, 79, 40, 141, 199, 80, 139, 81, 135, 76, 37, 50, 53, 27, 56, 164, 92, 187, 110, 110, 74, 64, 98, 170, 38, 39, 29, 180, 109, 141, 113, 103, 318, 209, 89, 60, 106, 245, 259, 338, 46, 25, 46, 36, 80, 145, 115, 98, 39, 73, 56, 173, 84, 74, 80, 66, 54, 48, 79, 77, 37, 25, 27, 96, 176, 214, 71, 102, 152, 145, 395, 266, 484, 99, 26, 57, 462, 17, 318, 295, 33, 78, 22, 182, 60, 384, 1, 62, 42, 0],
                visible: false
            }, {
                name: 'In progress works',
                data: [26, 14, 22, 22, 20, 28, 15, 18, 17, 22, 64, 43, 18, 48, 21, 46, 24, 25, 27, 32, 21, 21, 68, 38, 27, 37, 27, 55, 21, 24, 39, 9, 28, 42, 77, 17, 40, 26, 31, 63, 49, 34, 18, 23, 51, 104, 77, 25, 5, 33, 17, 21, 45, 40, 38, 16, 16, 27, 67, 28, 25, 24, 26, 16, 44, 36, 19, 13, 6, 17, 29, 33, 76, 14, 30, 7, 29, 79, 34, 96, 22, 0, 21, 108, 6, 81, 52, 4, 12, 9, 49, 22, 101, 0, 9, 4, 1],

            }, {
                name: 'Total amount spent',
                data: [27447503, 23598452, 31507589, 29844872, 45911960, 23473336, 16001481, 14627532, 34774866, 23800204, 57972634, 44021554, 14376757, 94766878, 18175824, 66475538, 37978228, 27919665, 28777237, 23492311, 19107361, 31116635, 100386657, 28799327, 38918662, 38798558, 24515975, 28316161, 34926403, 58362187, 45623303, 15152782, 26794532, 35694737, 27278351, 24185930, 51345339, 40001151, 53276796, 233797149, 69682861, 20249635, 25455801, 16975132, 62713604, 115873681, 117760364, 29607128, 8201487, 20068129, 12024290, 29964338, 32547575, 25102739, 15540949, 7330458, 26917768, 23128597, 65444360, 26613737, 18136790, 15303809, 20724393, 22059320, 27356725, 25134147, 49006943, 7690085, 16668056, 9296937, 28647588, 38938317, 80578499, 8577353, 31245261, 186612817, 54356044, 117456003, 844813868, 24932269, 13493075, 10305647, 11620514, 144225361, 5114012, 56735497, 195033032, 9988059, 27243478, 10365902, 138630465, 381522760, 8816745, 31672, 7168432, 22525462, 8628],
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
                categories: ['Commissioner HDMC Hubli (Pension IOB)', 'Asst Ex engineer (Ele) O&M Rural Sub-Division Hescom DWD', 'E E (Ele) West Division Hescom Dharwad', 'Zonal Officer No.7', 'Karnataka Building and other Construction workers welfare board Koushalya Bhavan Banergahtta Road Bangalore-560029', 'Asst. Commissioner Zonal Office 8', 'Asst. Commissioner Zonal Office No 05', 'Ishwaragouda .S. Patil', 'Asst. Commissioner Zonal Office No 04 Navanagar.', 'Executive Engineer, KUWS and DB (Project), Dharwad', 'Meter Section, Hubli', 'Jadhav V.S.', 'Asst. Commissioner Zonal Office No 06', 'Savadi S.K.', 'Asst Ex Engineer (Ele) CSD-I Hubli', 'Raju S.R.', 'Krishna N.', 'Asst. Commissioner Zonal Office No 12 Dharwad', 'Health Dept Hubli', 'Asst Exeutive Eng O & M Sub Division Hescom CSD-II Hubli', 'Asst.Exective Engineer EI (West) CSD-3 Hescom IE Hubli', 'Zonal Officer 10', 'Infotech Computer Education, Hubli', 'Talikoti Ravi G', 'Wali J.B.', 'Asst. Commissioner Zonal Office No 01 Saptapur Dwd', 'Suresh Enterprises Pvt Ltd', 'Zonal Officer Zone No.11', 'Abbyal M.M.', 'Asst. Commissioner Zonal Office No 09', 'Commissioner HDMC and Deputy Project Director KUIDFC Dharwad', 'Asst. Commissioner Zonal Office No 01 Dharwad', 'Hanji C Vinayak', 'Talewad N.H.', 'Ex Engineer Division Hecom Dwd', 'M/s N. S. Nayak and Sons', 'Executive Engineer K.R.I.D.L Dharwad', 'Mali A.M.', 'General Administration Department Hubli', 'Tarlagatti C.Y.', 'Zonal Officer No.03 DWD', 'EE Dwd', 'Gudageri Prakash', 'Chief Accounts Officer', 'Hanchin S.J.', 'Asst Ex Engineer CSD-2 Hescom Dharwad', 'Asst Ex Engineer CSD-1 Hescom Dharwad', 'Sagabal N.C.', 'Kundgol F.A.', 'Deputy Director City Central Library Dharwad', 'Asst. Commissioner Zonal Office No 02', 'Zonal Officer No.2', 'Sureban A.B.', 'Hanchin V B', 'Shibhargatti Z.T', 'Dharwadakar M.S.', 'Canara Solar System Hubli', 'Singh H J', 'Council Secretry HUB', 'Revenue Department', 'Horticulture Dept Hubli', 'Basanagoudar B.Y.', 'Chief Medical Officer Chitaguppi Hospital', 'Deputy Chief Medical Officer, Oldhubli HUB', 'Jain J.D.', 'Akki Prakash Gurubasappa', 'Kam-Avida Enviro Engineers Pvt.ltd', 'Deputy C M O Busstand Hosiptal Dharwad', 'Bharat Ex-Serviceman Detective & Security Service', 'Sadhana Enviro Engineering Services', 'Gurubasava & Co (pro.S S Sankapal)', 'Chief Medical Officer Chitaguppi Hospital Hubli', 'Doddamani R.M.', 'Kulkarani P.R.', 'Sudha Hegde (Sri Sai Equipments and Services)', 'Arakeri P.L.', 'B Tirupati Reddi', 'Dharwadakar S.V.', 'Pantoji Mehmood .Hajrath.', 'Uppar I.G.', 'Channalli V.B.', 'EE South', 'Ujjwala Enterprises Hubli', 'Special Officer', 'Superintend Engineer', 'Deven Agencies Hubli', 'Naik D.C.', 'Araved K.O.', 'Kanamakkal Shridhar S (Shree Cleaning Service)', 'Ballari K.R.', 'Secretary, Central Relief Committee Bangalore', 'Asst Ex engineer (Ele) Sub-Division Hescom Kalgatagi', 'Asst.Executive Engineer Ele C S D II Hubli', 'Araved Venkates O.', 'Om Travels', 'Deputy Commissioner DWD', 'Marketing Consultants & Agencies Ltd', 'G K Ravish', 'Adarsh Enterprises Hubli', 'Rayangoudar Ravindragoudar Takangouda', 'Midmac Infrastrucutre Pvt Ltd. (S.K.S)', 'M/s Araved Services Dharwad', 'DDTP', 'Sambrani .V.B.', 'Gabbur M.S.', 'Raju H M', 'A T Cleaning Services Hubli', 'Executive Engineer Karnatak water board, Hubli', 'Doddamani N.M.', 'Tagargunti Pandurang G', 'Hosmani Rmangouda Gurulingappa', 'Bovi M.L.', 'Deputy Chief Medical Officer, Torvigalli, Hu', 'Madar Suresh K', 'Devagiri Electricals', 'Council Secretary', 'Bagewadi Ishwarappa Mallappa', 'EE SWM', 'Chief Auditor', 'Manjunath Cleaning and Security Agency', 'Kadargunti Anju S', 'Malagimani Ashok M', 'AEE-Electricals Hubli', 'Koppal Shashidhar H', 'Vinayak N Perur', 'Tagargunti N.M.', 'Bilebal Sanjay Gurappa', 'Executive Engineer Karnatak Water Board HDWS Maintenance Division Dharwad', 'Karjagi M.S.', 'Vasudev M Guntapalli', 'Horticulture Dept DWD', 'Teradal B S', 'Kurahatti S.H.', 'EE North', 'Killedar S F', 'Jain M.M.', 'Deputy Chief Medical officer Kamankatti', 'Nanyad S.H.', 'Waddar E.H.', 'Guragunti Oblesh K', 'CMR HDMC A/c (Service Tax)', 'Araved Oblesh Oblesh', 'Patil Ravi .A.', 'EE Water Boad hubli', 'Guntapalli K.M.', 'Samartha Enterprises', 'Sambrani Venkatesh V', 'Morabad V.N.', 'Sri Krishna Cleaning and security Agency', 'Deputy Chief Medical Officer, Ganesh Peth', 'Kolagond R.N.', 'Colour Vibrations, Bangalore', 'Patil Satish R', 'Ex Engineer (IT)', 'Bhojagar Shankar R', 'Shekh M.H.', 'Madar Raju Buddappa', 'Mahalingashetti and Company Ltd', 'Davalnavar M.I.', 'Waddapalli Vishwanath A', 'Channalli M.S.', 'Patil A.B.', 'Beldoni Venkatesh Hanumantappa', 'Duragadevi Cleaning Agency', 'Savadatti Srikanth .S.', 'Byalyal M.A.', 'Bhart Sanitary Agence Hubli', 'Doddamani S.K.', 'Morabad Maltesh Ningappa', 'Ramachandra R Pododdi', 'Sharan Services', 'Deputy Chief Medical Officer Navanagar Hospital', 'Vibhuti A.B.', 'Saleem N Lacchanna', 'Arwed Agencies', 'Commissioner HDMC Hubli 2020', 'Punde Tanajirao Topajirao', 'Annigeri Green Tech', 'Hulkoppa Hidayatull Imamkhan', 'Waddapalli Gurunath O', 'Mote K.S.', 'Patil Subhas B', 'Chinmay Associates', 'Gudadur R.R.', 'I I C I T  Hubli', 'Dayagodi Umesh', 'Hiremath .S.N.', 'Srinivas Rao C H', 'N Gopalkrishna', 'Panchaputra Madan M', 'Green Ivy Prp Manik A Shivakar', 'Electrical  Department Dharwad', 'Sujay Infracon Private Limited', 'Manager S B I Vidyanagar Hubli (DULT)', 'Talikoti G G', 'E E (Ele) C S C  Hescom (CSD-1) Hubli', 'Manjunathgouda Naganagouda Malagoudar', 'Hulamani F.D.', 'TPS Infrastructure Limited', 'Hanchinmani Nagesh R', 'Lokhande S.S.', 'Bhimappa N.F.', 'Asst Ex Engineer (Ele) CSD-I Dharwad', 'Kyarakatti Sunil P', 'Bijapur Manjunath Mallappa', 'Bepari .Aijaz Ahmed', 'Kittur M.M.', 'A H O, Myadar Oni Hospital', 'EE WaterBoard Dharwad', 'Hanumantappa F Koravar', 'Guntapalli Raju S', 'D I Pattar (AEE)', 'Chikkayyanavar Shivappa S', 'Vagesh S.H.', 'Law Department', 'Gangavati S.S.', 'Bijapur Baseer Ahamed', 'Kharadi J J', 'Kallesh S Huliyappanavar', 'Patil Basanagouda S', 'Sunagar .B.J.', 'Zonal Officer No. 5', 'Senior Divisional Finance Manager South Western Railway Hubblli', 'Deputy Conservetor of Forests Social Forestry Division Z.P Dharwad', 'Rashinkar S.L.', 'K.K. Nair and Co.', 'SJSRY', 'Goggi G.D', 'Bhovi Vivekanand  L', 'Bekal Shashidhar Chandrashekar', 'Waddar Maruti G', 'Naikal Manjunath S', 'Kuri Dharamanna F', 'Vijay Shamiyana Supplyers', 'Chalawadi Hulagappa Nagappa', 'Ramayyanavar Halundayya  S', 'Goudar Mohan G', 'S M S Electricals', 'Central Library', 'Konaraddi N V', 'SNN Infrastructure Pvt. Ltd.', 'Image Marketing Hubli', 'Halli S C', 'Naragund M.Y.', 'Commissioner HDMC Hubli (Pension Canara)', 'A D Haladi', 'Terdal Sadanand B', 'Bharath Sanchar Nigam Limited Hubli.', 'Shakeel Ahmed C W (Dy. CMR)', 'Shriram Agencies Hubli', 'Naragund S.M.', 'Doddamani S.M.', 'Prasad Security & Cleaning Services Hubli', 'Shetasandi Saiyad Husen', 'Nayar K K', 'District Commissioner and Chairman  Dwd Utsava-07', 'Chitaguppi Hosipital Honorarium', 'I C India Pvt Ltd', 'Shree Ganesh Electricals & Engineers', 'Kempasannavar .B.S.', 'Animals Righs Fund Bangalore', 'Panchaputra Shekhar M', 'M/s Chaitnya Electricals Bangalore', 'Pursuit Technologies Pvt Ltd Hubli', 'Pastay V.L.', 'Kadam J.M.', 'Bharath Sanchar Nigam Limited, Hubli', 'Kattimani Chidanand Hanumantappa', 'EDCS Directorate HD-1 Project e-Goverance Department Bangalore', 'Maurya Infotech (P) Ltd Bangalore', 'Jaydeep Traders', 'Sureban Manjunath Ashok', 'Durgambika Constructions Hubli', 'Killedar Zaheerudden K', 'Asst Exeutive Eng O & M City Sub Division Hescom CSD-II DWD', 'Bhojagar Dinesh Duragappa', 'Khandekar K.N.', 'Darashaw and Co. Private Ltd.', 'V.S.Associates', 'Mathad I.V.', 'A-1 Arts Hubli', 'Bhajantri Pandurang M', 'HESCOM Hubli (West Sub Division)', 'M/s S N Nayak and Sons', 'Pododdi Agency', 'Araved Services, Jaibheem Nagar, Madarmaddi, Dharwad', 'Benakanahalli Electricals', 'Unique Electricals', 'Khaza Hussain A. K.', 'Mysore Sanjeev Basappa', 'Patil B S', 'Director M D P and Consultancy Cell K I M S,KUD', 'Birajdar Gangadhar G', 'Sabarad M B', 'Joint Commissioner', 'Shri Renuka Shamiyana Suppliers', 'Charantimath Associates', 'EE Karnataka Water Boad hubli', 'Goni James F', 'VDECOR Hubli', 'Devendrappa K Kamdenu', 'Executive Engineer Electrical TL and SSM division KPTCL Hubli', 'Chief Operating Officer, Nirmithi Kendra Dharwad', 'Somindra Marketing Hubli', 'S. S. Soudi. Tours and Travels', 'Patil Aravind S', 'Nagaraj Krishanappa', 'Amar Marketing', 'Commissioner HDMC HUB', 'Panchputra Manjunath', 'Neelannavar V.C.', 'Shree Annapurna  Electrical Works', 'Gadag Kushal C', 'Akkalkot Puja', 'Nayak V.K.', 'Shri Krishna Bhavan', 'Shrinivas N Mane', 'Languti S Manjunath', 'Vinay Electricals', 'Palkar Shivayogi Channappa', 'Dani R.G', 'CMR HDMC A/C (I T)', 'Gouder Muttuswamy R', 'Godi M S Electrical', 'Madhu Enterprises', 'Kyatannavar R.P.', 'Vadakannavar Manjunath A', 'Asst Ex engineer Hescom Hubli (west sub division)', 'Laxmi Enterprises and Services', 'Asha Traders, Hubli', 'Mahesh G Waddar', 'Hirekerur P.Y.', 'Chief Medical Officer Ayurvedic Kamankatti Hospital Dwd', 'Blue Star Communications', 'Talwar Ningappa N.', 'Commissioner HDMC Hubli', 'Nayak T.D.', 'Benni Chandrakanth S', 'Oldhubli Hosipital Honorarium', 'Meter Section Dharwad', 'Marshal Pharmaceuticals', 'Smt S.S.Soudi', 'Hombal D T', 'ZED Detective Agency', 'Asst. Commissioner Zonal Office No 10', 'Syndicate Agencies', 'Walikar Ashok Parasappa', 'Abdul Rasheed Bholabhai', 'A. R. Mannur', 'Ilakal Mahadevappa Y', 'Madhukar H P', 'Davalnavar B.I.', 'Gandolakar S.M.', 'EE Karnataka Water Boad Dharwad', 'Waddar Shankar Hallappa', 'Irfan M U', 'Readi-India Consultancy Services', 'M/s Aamna Contractors', 'Praveen Y Badami', 'Vishnu Trading Corporation, Bangalore', 'Shanmukh Enterprises', 'Houde Subhash Ambaray', 'Narendra Veeranna Siddappa', 'Adarsh Electrical Works', 'Shiraguppi Vijaykumar P', 'Ningappa Nagappa Talawar', 'Navalur General Engineering Service', 'Mahadevappa Erappa', 'Kamati Rajshekhar B', 'Ganapati S Patgar', 'Sunil Jagadeesh Hanchin', 'Sunagar Anand Narayan', 'Birajdar B G', 'Hegde Tours & Travels  Dharwad', 'S B M Attikolla Branch Dharwad', 'Durga Electricals Prop : Parashuram D Pujar', 'Dhongadi Kiran Prabhakar', 'Shaikha Abdul Hameed', 'Kaller Somashekhar Bhimappa', 'Chigaru Constructions Dharwad', 'Pattankari Basha Hajaratsab', 'Aravind R P (A E E)', 'Chatni S A', 'Ravikumar A Gutti', 'National Studio Hubli', 'Council Secretry Hubli', 'Revenue Officer', 'Meti V S', 'Nadaf Allabaksha Hasanasab', 'Laxman .N.', 'Sambrani S.G.', 'Combat Security Force And Allied Service', 'Umesh K M', 'Charantimath Sadanand S', 'Rashinkar S.M.', 'E E (Ele) C S C  Hescom Hubli', 'Tolas Electronics Hubli', 'Biradar P N', 'Savadatti Veerupakshappa Bhaimappa', 'Health Officer Hubli', 'PRO', 'Achchamma H Yaragunti', 'Mallikarjunagouda C Goudati', 'Badami C.B.', 'Abhay Constructions Hubli', 'M/s. All In Box', 'Solaragoppa Gangadhar R', 'The Team Tidy', 'Janata Bazar Traffic Island Hubli', 'Vadavi Basavaraj B', 'UTTARA KARNATAKA ENTERPRISE, BANGALORE', 'N Pralhad', 'Hubli-Dharwad BMW comman treatment facility Tarihal Hubli', 'Namazi Mohammedabrar Madarsab', 'Madalli B. A.', 'Hamppavva Basappa Yaramsal', 'Dinakar Rajendra Yeshwantappa', 'Vinsun Enterprises Hubli', 'Sannagoudar S B', 'Khanapur T L (SDC)', 'Giga Technology', 'Vishwanath S Patil', 'Irakalla Gurunath T', 'Katagi Vijay F', 'Shekhbade Shakeel Ahmed', 'Mahadevappa owalikar', 'M/s Supreet Electrical', 'Nadaf Khajesab Allisab', 'Smt. Ashwini Tippanna Majjagi (Mayor)', 'Kinakeri Manjunath Nagappa', 'Mundasad G.V.', 'Unicom Services H', 'Mulla Ijazahmed Muneerahmed', 'Dr. Leeladevi Somaling Navalgund', 'Penagonda Sunil Venkatesh', 'Shaikh Aslam N', 'Shri Krishana Services', 'Chinchalli Doddamudakappa Y', 'Garag Vinod L', 'Aravind Veerappa Shiggao', 'Nemikal H.F.', 'Dr Ravi S Saligoudar', 'Nathan and Nathan Consultants Pvt. Ltd Bangalore', 'Munavalli Sagar Vithal', 'Hiremath V M', 'VEDANT CONSTUCTIONS', 'Sudeer Saraf', 'Tangayi B S (advocate)', 'Gachinamath I G  (Advocate)', 'Gadag A G', 'Subharaju S Chiluvuri', 'Honnalli Somappa R', 'Kavatekar T M (FDC)', 'Bhadrapur C B', 'Savanur Shrvankumar B', 'Magadum P.A.', 'Kulal Nitesh Ramesh', 'Yandigeri S N', 'United India Insurance Company Limited Divisional Office-1 Hubballi', 'Siddarath Cleaning and security Agency', 'Sudhakar D Golasangi', 'Kamoji A P', 'Daneshwari Offset Printers', 'Koladuru Shivanda V', 'Dr. A.V. Maniyar', 'Murgod G P', 'Ambiger Pamppanna Irappa', 'KEONICS Bangalore', 'Neelavar Bhujang M', 'Attar Shakeelahmad Basheerahmad', 'Venkatesh A Ghodke', 'TATA Motors Limited Mumbai', 'Sadiq Electricals', 'Deputy C M O Busstand Hosiptal DWD', 'Karnataka Cancer Research Centre Navanagar Hubli', 'SDM College of Engineering and Technology, Davalagiri Dharwad', 'Netseva Solutions Bangalore', 'Swetha R Vernekar', 'Dr. Suhasini S. Mote', 'Basavaraj Y Kustagi', 'Nalband A M (Driver)', 'Dakshayani C Nadurmath(Advocate)', 'Dr. Mallikarjun Y. Pujar', 'C V Angadi (Advocate)', 'Mahantesh S Amarshetti', 'Very Good Security and Man Power Agency', 'Malagi B M', 'Goudar Ashok D', 'Janata Book And Stationary', 'Dr. Susheela Patil', 'Nayak Electricals', 'The Oriental Insurance Company Limited', 'Ratna Law Associates', 'Ramandeep Chowdhary', 'Dr Parashuram Revappa Kannur', 'Sai Man Power Agency', 'United India Insurance Company Ltd', 'Battennavar Manjunath Durugappa', 'The Gateway Hotel Lakeside Hubballi', 'Hanchin Deepak Mohan', 'Balachandra I Hulakund', 'President Karnataka Institute of public Auditors', 'G K Hiregoudar (Advocate)', 'Dr. Prakash S Beevanur', 'Dr. Shneha Nadakattin', 'Durgambika Associates, Hu', 'Waddapalli Anand.Oblesh.', 'Kundagol Virendra (J C)', 'Shivu Hiremath (Mayor)', 'Parwatagoudar & Chetty', 'P.I. Angadi and  Co', 'Asst Executive Engineer (Electrical) Dharwad', 'Dr. Basavaraj B Sajjana', 'Dr. Rashmi Datta Nadgir', 'Dandin Girish Rudrappa', 'Vijaya Bank, Bankapur Chowk, Hubli', 'Jyoti S Kanpet', 'Kittur S M', 'Hiremath S.N.', 'Ashwini Electricals', 'Kilarimath Gururaj Irayya', 'Hanumasagar Bhotayya Shivappa', 'Halagi B K (SDC)', 'Classic Traders', 'Shivaji  Ramachandra Suryavanshi', 'Wasim A Sanadi', 'Savanur N G', 'G Meerabai (Advocate)', 'Kotagi D C (CMO)', 'Donur RasulAhmed A', 'Ganjikatti J K (DDTP)', 'Kumbi Akbar Saleem', 'Wali Jagadisha S', 'Sai Prasad Traiders Hubli', 'Panduranga Maruti Bhajantri', 'Tahashildar K M', 'Sankangoudar P V', 'Patil D B', 'Shankar M Nadiger (J Eng)', '4SPL Technologies India Private Limited', 'Shivashimpar B B (Rdt emply)', 'Waddodagi Mahammadhusen H', 'Vithal Enterprises Hubli', 'Chikkayyanavar R.C.', 'Corporation Bank, Aravind Nagar Branch, Karwar Rd, Hubli', 'Shiriyannavar Ashwini', 'Raj Electricles', 'Ultra Systems Hubli', 'Sambrani S.M', 'Arjun Yallappa Athani', 'Ashok A Kashenavar', 'Ron .G.R.', 'Metro Ford', 'Kohinoor Electricals', 'Vagavilas Power Printing Press Hubli', 'Araved A O', 'Durgappa D Veerapur', 'Environmental Engineer Dharwad', 'Yashoda Narayan Naik', 'Asst. Commissioner Zonal Office No 08', 'President Phalapushpa Pradarshan Samati', 'Shivaprasad T.', 'Sunrise Industries', 'Unique Electrical', 'Y.R.Gobbardavar', 'Nayana K S (SWM)', 'Isuf S Mannur', 'Shri.Ramanath Associates Hubli', 'Avinash B Naragund', 'Pavan Associates', 'Ramesh S Kulkarni', 'K V G Bank Keshwapur Hubli', 'Karnatak RajayKrushi Marata Mandali Mudranalaya', 'Geeta Arun Chalawadi', 'Anitakumari A Koujalgi', 'Shri Siddha Sai Medical Distributors', 'Tarlagatti Suresh Shivaputrappa', 'Dayagodi Shridhar Huvappa', 'Sri Balaji Traders', 'Pannakar Michael Rayappa', 'Super Distributors', 'Bharat Enterprises Hubli (Bagi)', 'T A Associates', 'Fateshakhan L Pathan', 'Lohit Neelappa Unkal', 'Asst Ex Engineer (Ele) CSC Hescom Dharwad', 'Dyaniyal Raju', 'Kavita S Abbigeri', 'Mulagundmath G G (F.D.C)', 'CMR HDMC Hubli', 'Hiremath Shadakshari Gurupadayya (Work Inspector)', 'M/s Techno Constructions, Dharwad', 'Asangi M A', 'HDMC refund', 'ACCEL Frontline Limited', 'Durgavva Basappa Benkandoni', 'chintavva K Madar', 'Davaji Rafikahamedkhan G', 'Dr. Prema Basagouda Patil', 'Sanmati Trading Co.', 'Hubli-dharwad Urban Development Authority, Hubli', 'Basappa Channabasappa Kattimani', 'Katti Chidanand  (Advocate)', 'Ramapur Harishankar R', 'Tandel C B', 'Shashikala G Buradikatti', 'Nanjayyanamath V C', 'Yatnalli S Spoorthi', 'Indian Red Cross Society', 'Jodalli Yallappa Basappa', 'Keriyavar S B (Advocate)', 'Vivek S Shail', 'Prasad Palawayi', 'Indargi B H (Driver)', 'Asst. Commissioner Zonal Office No 03 DWD (Imprest)', 'National Insurance Company Ltd', 'K-Three Contsultant', 'Krishna Bhavan Hotel Hub', 'Chief Medical Officer, Homiyopatic Hospital', 'Madhusudhan Raghavendra Kulkarni', 'Joshi J D (E E ele)', 'V U Somanakoppa (SDA)', 'Peddavva Krishnappa Begalmkar', 'Karanandi N.N.', 'Baligar A A', 'Shri Ganesh Electric Decorators Hubli', 'AIRTEL A/C NO 12519700', 'Shrishail M Sondur', 'Dr. Shweta M. Amudapu', 'Kodapur K S (Peon)', 'Dr. Y Samval', 'Dasannavar R.B.', 'Hotel Yatri Darshini', 'Nagaraj A Gabbur', 'Mannangi S S', 'Patil Rajendra S', 'Sheelavantar G.M.', 'Shantala S', 'Mirjanavar B H', 'Hulgeri A A (Advocate)', 'Anilkumar V Negalur', 'Jain Rakesh J', 'Malleshi Shankar Ramaji', 'Padmavati Laxman Bagalkoti', 'Account Department Hubli', 'Kusugal Sandeep K', 'Sanklipur I G', 'Padmanabh V MAhale (Advocate)', 'Aroodha Enterprises, Hubli', 'Basava Motors', 'Basavaraj Heggappa Heggannavar', 'Deputy Chief Medical Officer, Oldhubli Hubli', 'Yaragatti Niyazahmad M', 'Manjula Siddappa Hori', 'Dr Rita V', 'Nalbund A H', 'Bhushan B Kulkarni (Advocate)', 'M B Anchi', 'Savita Mallayya Vaidyamath', 'Vision Solutions', 'Nimans Hospital Bangalore', 'Vision Foundation', 'Mahalasa Markeeting', 'Godi Satish S', 'Rays Enterprises, Belgaum', 'Biradar Sanjaykumar Shankargowda', 'TUV India Pvt Ltd. Banglore', 'Sambhav Associates', 'Varun agencies', 'Devi Industries', 'Asst. Commissioner Zonal Office No 07', 'e Governments Foundation', 'Meharwade Sound System', 'J A Pradeepkumar', 'Sushruta Multispeciality hospital & research centre, Hubli', 'Akkur Manjunath Chandrappa', 'Si tech solutions', 'Byahatti I.M.', 'Samarth Machine Tools', 'Real Value Marketing', 'Mehabubasab Husensab Nadaf', 'Meerabai Veerabhadra Badiger', 'Dhanvantri Distributors', 'Sugur Madan Ravindra', 'Vijaya Bank Keshwapur Branch Hubli', 'Naganur M M', 'Birolli Gurusiddappa N', 'Srushti Info Services Hubli', 'Shekappa F Telagaar', 'Deputy Chief Medical Officer Navanagar Hospital Hubli (Imprest)', 'Bannigidad Somanna Y', 'Honnavva Yaragunti', 'Laxmi Chemical Industries', 'Mulla I A', 'Swemed Biomedicals Pvt Ltd', 'M/s S.C.Naregal', 'Waddar S.N.', 'Umesh S Mandre', 'Joshi V.B.', 'Madlur F A (FDA)', 'S C Guttargi', 'Smt A F Madlur', 'Gurukrupa Agencies', 'Yannechowdi Saraswati Mallappa', 'Gajanan S Kalburgi', 'Kotwal Traders', 'E E C S C  Division Vidyagiri Dharawad', 'Chavan D K (Corporator)', 'Basava Equipments', 'Solaragoppa Basavaraj R', 'Ramesh Sarkar', 'Prakash V. Kammar', 'Mirjanakar  S.M.and Sons (Automobile Engineers)', 'Prakasha R Darekar', 'Goa Power Sales and Services', 'All India Institue of Local Self Govt. Mumbai.', 'Kirti Trades Hubli', 'H.M Shivakumar Swami', 'Naveen Manohar Rachanaikar', 'Dharwad District Kannada Sahitya Parishat', 'Paras Agencies', 'Patil L V (Advocate)', 'Naveenkumar G. Hattibelagal', 'S Kumar', 'Joshi R.M. Motors', 'Zonal Office No. 10 A/C No. 11324(Imprest)', 'Shri A H Adappanavar', 'Morab A N', 'Perur Mohankumar.M.', 'P S N Construction Equipment Pvt Ltd', 'Ambadipudi Mariyadas', 'Ramayyanavar Siddharth Shivanand', 'Fakkiravva H Koleppanavar', 'Pandu Bhimappa Salodagi', 'Gopal S Dubey', 'Prakasha Mahadevappa Ganiger', 'Dr. V B Nitali', 'Shankarappa D Challawadi', 'Hosmani Manjunath M', 'Shridhar V', 'Yallavva P Kundaragi', 'Chakrasali Sangamesh Y', 'Bhandare P K (st)', 'Siddavva R Ramayanvar', 'Ashok R Bhovi', 'Husanappa Vajjannvar', 'Asst. Commissioner Zonal Office No 06 (Imprest)', 'Singoti J.M.', 'Ramesh M Ayatti', 'Pamadi Nallappa D', 'Parnenavar Naveen', 'Mohammed Fazil', 'Jindal Stainless Steel Centre Hubli', 'Annigeri Govind Shetteppa', 'District Throwball Association  Dharwad (R)', 'Adarsh Distributors', 'Shri Sai Prasad Traiders', 'Mahesh M Rayabag', 'Divakar S V', 'Marevva G Annigeri', 'M M Joshi Eye Institute Gokul Road Hubli', 'Ghodke Venkatesh Arjun', 'Jamkhandi Mahesh Ratnakar', 'Amattanavar B D', 'Meti Umesh Virabhadrappa', 'Kinakeri H.N.', 'Amaya Electricals', 'Science & Medical Corporation Hubli', 'Manjunath Motor', 'Suresh S Morbad', 'Dharwad Zilla Kivudar Sangh Hubballi', 'Parande .L.K.', 'Arjunagi Shivappa H', 'Asst. Commissioner Zonal Office No 02 (Imp)', 'Nayak K.S', 'Post Master  Hubli', 'Hiremani Somanna S', 'Pradip M Mehta', 'Mane Santosh Fakirappa', 'M/s Pawar Petroleum', 'Mahesh Konapur (P K)', 'Rayabag K M', 'Gudihal Prakasha B', 'Dhanyanavar M M', 'Vijaya Bank Sarswatpur Kalghatagi Road Dharwad', 'Ramachandra Billapat', 'Yellappa M Aravalad', 'Jadhav Chandrashekhar Ramdas', 'Vinay R Sunkad', 'Khatta Meetha', 'M/s Raj Enterprises Hubli', 'Gollar Gopal', 'Jadhav M.S', 'Harlapur V K', 'Patil C S  (Advocate)', 'ClickHubli .com  Hubli', 'Smt.Nirmala Shivanand Javali', 'Aralihond Mahesh P', 'Panchputra Nagaraj Manjunath', 'Mahammedhaneef Azizsab Sunkad', 'Ramalingam A Salaam', 'Shekhargouda.S.Kalwad', 'Basavaraj K Lamani', 'Shiraguppi Sandeepa R', 'Karalingannavar Parvati Y (Gradener)', 'Hiremath P P Lawyer', 'Anand N Channakoti', 'Gori G A', 'TUV India Pvt Ltd. Mumbai', 'Havalannavar Mahantesh Hanumantappa', 'Umesh Durugappa Madari', 'Shivanand Oblesh Shivapuram (Peon)', 'Umesh C Ainapur (Advocate)', 'Saraf U S', 'Vijaykumar Ningappa Kelur', 'Prabhudas Velluri Urf Yalluri (PK)', 'Shobha V K (Peon)', 'Timmappa Gollar', 'Manickbag Automobiles Pvt Ltd', 'Kalyanmath P C', 'Syndicate Bank Neharu Nagar Gokul Road Hubli', 'Basavva Yallappa (PK)', 'Kariyappa Hanchinamani', 'Balaganur D H', 'Yenagi S A', 'Veeresh Printers', 'Punde D N', 'H Sathyamurthy (Account suptd)', 'Santosh S Savanur', 'Renuka V Markal (Peon)', 'M V Habib', 'Walikar Siddappa Basappa (SDA)', 'Madaras Mohammed Ashfaq', 'Dr.Shaila M Nekar', 'B.D. Kurakuri', 'The New India Assurance Company Limited Dharwad', 'Aaratti Prakash Ramappa', 'Harijan Narasappa D (PK)', 'Shodha Toyota Rayapur H', 'Alfred F Peter', 'Utakuri C.J', 'Patil Sanjeevgoudra Basanagoudra', 'Anita V Megharaj', 'Madnoor M.P.', 'Karnataka Bank Ltd Vidyanagar Branch Hubballi', 'N.V.Pattihal', 'Hiremath C.B.', 'Chikkayyanavar Shivanad S', 'Manjunath B Savadatti', 'Anigol Padmavathi R (FDC)', 'Santosha S Benasamatti (PK)', 'Patil I C  (Advocate)', 'Ramesh U Ramayyanavar', 'Sheelvant A.N.', 'Kamlesh Electical Hubli', 'Karevva K Sambapur', 'Hubballi G M (FDA)', 'H V Sanshimath', 'The Printors (Mysore) Pvt. Ltd.', 'Smt S F Killedar', 'Hiremath  Jaidev J', 'Yaramasal Udayakumar M (SDA)', 'Mammada Jafar  Mammad Usman Markar', 'Tirumal Teleworld Hubli', 'Manjula Nagaraj Araved', 'Sabitaraj  (FDC)', 'Ron D Y (SDA)', 'Ratnavv Bhimappa Halagi (PK)', 'Mahesh Agali', 'Sogalad Glass Centre', 'Desai Pramila', 'Oddodagi M H', 'Jayashree C Pujar (SDA)', 'Manjavva. Siddappa. Sannamani', 'Laxmavva Sannaramappa  Kondapalli(PK)', 'Veeresh T Madari', 'Rati V G (SDA)', 'Abdulrajak S Gadavale', 'Prakash Arkeri', 'Spandana Enterprises', 'Pagalapur S B (P K)', 'Sheth P.D', 'J and V Industries', 'Laxmavva Budedu', 'Renuka M Balgavi', 'Govind M Madar', 'Manager M I', 'Balaraddi Bhagyashree D', 'Basappa H Yarihanchinal  (P.K)', 'Bhagyamma N Devayya', 'Hi Byte Graphics', 'Airtel Mobile No.9731837006', 'Asst.Commissioner Zonal Office No 04 Navanagar (Imprest)', 'Darladas Devadas Josheph Darla', 'Ratna Y Waddar', 'Sali S P', 'N. V. Hebsur', 'Jambaladinni C Y (SDA)', 'Patil Virupaxagouda G', 'Telaginmani Siddappa', 'Vagarnal Siddappa H (SDC)', 'Chandrashekharayya Gurubasayya Betasurmath', 'Hubballi M U', 'Jayasheela S Gudasalmani', 'Bevoor S C', 'P.D.Ambi.', 'Maralihalli A.K.', 'Suresh C Yareshimi', 'Parashuram K Hiremani (Driver)', 'Mallapur Prakash S (F I)', 'Noolvi R B', 'Siddiq D I (Supdt.)', 'Yugandhar S Satyanarayana', 'Vasant K Kulkarni', 'Smt. Smita Ashok Jadhav (Dy.Mayor)', 'Laxman N Guragunti ( P K)', 'Madar Anjaneya N', 'M/s Shrinidhi Creations', 'AIRTEL Mobile No. 7899809511', 'Siddavva G Gudihal', 'AIRTEL Mobile No. 7022388056', 'Kiresur D.H', 'Asst. Commissioner Zonal Office No 12 Dharwad (Imp)', 'Asst Ex Engineer (Ele) HDMC Dharwad', 'MTS Account Number : 1906421461', 'Zonal Office no.1 to 12', 'Satish Dattaraya Govindrao Donsal', 'Pujar M M (SDA)', 'Kattimani B L', 'SBI Siddarudhamatha Old Hubli', 'Chikkayyanavar M.S.', 'Davalnavar Mohmadaslam I', 'Prakash Laxman Garag (S E)', 'Sanjay Talekhan (SDA)', 'Malligwad M B', 'Marigoudar C K', 'Reshma M Shanwad', 'Pullamma D Madar', 'Kokate S M', 'Balappa Lakshman Madar', 'Talikoti Gurunath (SDA)', 'D.M. Soudegar (SDC)', 'Sudarshan Printing Press', 'Girija Charantayya Hiremath', 'Siddappa D Morabad', 'Satappa D Nagnur', 'Dharni M V (A O)', 'Premier Generaters', 'Basavantappa Bharmappa Nichalad Rtd', 'Salimath Prabhuraj C', 'Vinayak Electricals', 'Knowlarity Communications Pvt Ltd', 'Jannu Praveen K', 'Bhimappa H Ingalagi', 'Vijayakumar Ningappa Kelur', 'Bendigeri Indian Gas Distributors Hubballi', 'Kodaddi S H (Driver)', 'Shivaram Shankar Suryawanshi', 'Vivekanand General Hospital, Hubli', 'Universal Xerox Court Circle Hubli', 'Kollappa H Narayanapur', 'Shivamurthy I I', 'Gangal Deepak V', 'Belagatti Lingaraj J', 'Gouri S Desai', 'Karnataka State Pollution Control Board, Dharwad', 'Chalawadi Yallappa R', 'S P Mayakar', 'Yallappa F Hosamani', 'Madar Siddappa B', 'Ratnavva H Shikkilagar (PK)', 'Sunita V Uppar', 'Nagaraj Basappa Chalawadi', 'Aminbi madharkhandi dresser', 'Neelagiri Basavaraj N (peon)', 'Math S R', 'M/s.Shri Laxmi Enterprises and  Services Hubli', 'Basappa M Chalwadi', 'A B Mahishi', 'Shaikh Abudul Khadar N.', 'Bhandari P K', 'Koladur .S.V.', 'Jalahalli Hanumavva S', 'Savadatti D K (SDC)', 'Ramanjaneya Madar', 'Shivalinga B Jalhalli  (P K)', 'Secound additional seniour  civil Judge Court  Dharwad', 'Manjula D Jadhav', 'Donsal S G', 'Padesur Manjula (Advocate)', 'S.R.Rasaler', 'Bammigatti Manjunath S', 'Law Officer', 'Smt Bharti Patil (Dy. Mayor)', 'Samyukta Karnataka', 'Vinod H Kayrakatti', 'M/s Navarang Arts', 'Malappanavar N F', 'Kadagad S P (SDA)', 'Karalingannavar Girija', 'Tejasvini M Kalyani', 'Galemmanavar P D', 'Naragund R B', 'Pragati Micro Controls', 'P A to Commissioner (G M Hubballi)', 'Ashish Traders Hubli', 'Pamadi Parushuram M (PK)', 'M M Joshi Eye Institute Haliyal Road, Dharwad', 'Navalur Mohammd Iqbal M', 'Ghodake Parshuram V (Peon)', 'Durgavva Vasant Gollar', 'Aravalad .Y.M.', 'Gudihal Siddavva G (PK)', 'Ranganath Mallappa Helavar (peon)', 'Chalawadi Shekhappa S/o Chennavva', 'Laxmi Electrical Works, Hubli', 'Geeta K Pujar', 'Renuka S Bennuramath', 'Ingalhalli Basappa L', 'C A Padmavati', 'Raikar Manjunath R', 'Baddi Dattu R', 'Shri Basava Automobiles Hubli', 'Muniswami I (Suptd)', 'Dadapeer B Nalband (PK)', 'Jayaram M S (CAO)', 'N.H.Shikkalgar', 'Shri Shashikapoor V Kadagad', 'Farzanabanu M Mulla', 'Hanmantappa Naganur', 'Ramesh H Soloni', 'Gujarathi Samaj', 'Oriental Bank of Commerce Club Road  Hubblli', 'Alagundagi C G Shamiyana', 'Bebinanda B', 'Ashok Holappa Navalgund', 'Mariyavva M Baglad', 'Chavan S S', 'Sutaria Auto Centre', 'Books and  Books Koppikar Road', 'Hanchinmani A B', 'M/s Revankar Gas Agency', 'Parashuram Mandkall', 'Yallavva B Chalavadi (PK)', 'Renuka S. Patil', 'Parimala .S. Desai', 'M P Anita ((Chief Account Officer)', 'Karnatak Gas Distributors', 'Rokhade P. N.', 'Jadava M D (Typist)', 'Jagadisha S A', 'Khode C G (Driver)', 'Ganji S S (L C H)', 'Jogadandekar Yallamma', 'Ankalagi Vijayalaxmi (SDA)', 'Nichrome Testing Laboratory and Research Private Limited', 'Ingalahalli Basappa V', 'Kattimani Suresh Y', 'Farooq Ganjigatti', 'Satish Ullikashi, Chandrakanth Mageri', 'Shakuntala Memorial Hospital & Research Center Hubli', 'Raju M Gadagin', 'Asst Commissioner(GA)', 'Salagatti Y Y (L A)', 'Benagi M P', 'Fakkirappa Y Kelageri (PK)', 'Punde Deepak N', 'Principal SDM College Of Engineering and Technology Dharwad', 'Bellad Engineers Pvt Ltd Hubli', 'Senior Post Master, Head post Hubli', 'Ayyappa Bairamaddi (PK)', 'Manjula Basavaraj Beleri', 'Bharath Sanchar Nigam Ltd.Hubli', 'Smt. Manjula Ravi Akkur(Dy.Mayor)', 'A R Desai', 'Pujar Kollappa P', 'Medleri M J', 'R. K Palankar', 'Hiremath B.M', 'Pawar Shrinath R', 'Betapalli S N (SDA)', 'Hanumata G Naganur', 'Kundaragi D S (Peon)', 'Hadimani Nandish G (SDA)', 'Wagarnal Krishna Chandappa (PK)', 'Hanamantappa G K (SDA)', 'Saithsanadi Sayyadasif S', 'Manjunath Vagarnal (SDC)', 'Dr P R Hiremath', 'S G Kaddevarmath', 'Wilson Papatoti (SDA)', 'MTS Account No: 213000055573', 'Sangappa G Navalgund', 'Smt Ynagi S A', 'Sreedevi G. Patil FDA', 'Nandini (FDA)', 'Patil Vidya F (SDA)', 'Kalpana Patil', 'Salimath D. A.(N N)']
            },
            yAxis: {
                title: {
                    text: 'Magnitude'
                }
            },
            series: [{
                name: 'Total contract amount',
                data: [{y:624197513,contractor:['Minchu']}, 180091022, 178307438, 153011951, 134586003, 83979001, 83031613, 83025637, 79303738, 71000000, 70264941, 70120595, 64403738, 62642758, 61423680, 60324168, 55923789, 48166603, 48165952, 45887340, 45387874, 42830870, 39446338, 39417223, 39128766, 38286832, 37685327, 36800709, 33787553, 33334231, 33281000, 33125002, 30933279, 30337130, 29855066, 29728187, 29426000, 28877191, 27906898, 27838258, 26622934, 25515329, 25151343, 22968817, 22668989, 21491218, 21173939, 21143181, 20861053, 20600000],
                visible: true

            }]
        });
    });
</script>
<div class="panel-footer" style="text-align: center">All the data presented here has been provided by Hubli-Dharwad Municipal Corporation</div>
</body>
</html>
