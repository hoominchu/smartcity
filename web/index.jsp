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
    public static String capitalizeFirstLetter (String input){
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

    DBCollection smartcity = db.getCollection("allworks");

    String wardNumberParameter = request.getParameter("wardNumber");
    String statusParameter = request.getParameter("status");
    String workTypeIDParameter = request.getParameter("workTypeID");
    String contractorIDParameter = request.getParameter("contractorID");
    String sourceOfIncomeIDParameter = request.getParameter("sourceOfIncomeID");

    BasicDBObject wardQuery = new BasicDBObject();

    filters.clear();
    filters = (ArrayList) filters.stream().distinct().collect(Collectors.toList());

    if (wardNumberParameter != null) {
        wardQuery.put("Ward Number", Integer.parseInt(wardNumberParameter));

        ClickStack click = new ClickStack("wardNumber",wardNumberParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (statusParameter != null){
        wardQuery.put("Status",statusParameter);

        ClickStack click = new ClickStack("status",statusParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (workTypeIDParameter != null){
        wardQuery.put("Work Type ID",Integer.parseInt(workTypeIDParameter));

        ClickStack click = new ClickStack("workTypeID",workTypeIDParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (contractorIDParameter != null){
        wardQuery.put("Contractor ID", Integer.parseInt(contractorIDParameter));

        ClickStack click = new ClickStack("contractorID",contractorIDParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    if (sourceOfIncomeIDParameter != null){
        wardQuery.put("Source of Income ID", Integer.parseInt(sourceOfIncomeIDParameter));

        ClickStack click = new ClickStack("sourceOfIncomeID",sourceOfIncomeIDParameter);
        if (!(filters.contains(click))) {
            filters.add(click);
        }
    }

    Iterator filtersIter = filters.iterator();
    String newLink = "";

    while (filtersIter.hasNext()){
        ClickStack call = (ClickStack) filtersIter.next();

        newLink = newLink + call.parameter + "=" + call.parameterValue + "&";
    }

    DBCursor cursor = smartcity.find(wardQuery);
    int numberOfWorksDisplayed = cursor.count();


    //String baseLink = linkGen(filters);
    //System.out.println(baseLink);
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
    <div class="pull-right" style="margin-top:40px;"><a href="allworks_k.html" target="_blank">ಕನ್ನಡ</a> | <a
            href="allworks.html" target="_blank">English</a></div>

    <h4>Number of works : <%=numberOfWorksDisplayed%></h4>

    <%Iterator filtersApplied = filters.iterator();

        while (filtersApplied.hasNext()){
            ClickStack click = (ClickStack) filtersApplied.next();
            String dismissalLink = "index.jsp?"+newLink.replace(click.parameter+"="+click.parameterValue,"");
            dismissalLink = dismissalLink.substring(0,dismissalLink.lastIndexOf("&"));
            System.out.println(dismissalLink);
            System.out.println(newLink);
            %>
        <span class="label label-default" style="font-size: 1em; color: inherit"><%=click.parameter%> : <%=click.parameterValue%> <a href=<%=dismissalLink%>> <i class="fa fa-trash-o" aria-hidden="true"></i></a></span>
            <%
        }

        %>


    <table class="table-striped table-responsive sortable" id="myTable" style="margin-top:2em; width: 100%; table-layout: fixed">

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

                    if (status.equals("completed")){
                        statusColor = "#43ac6a";
                    }
                    else if (status.equals("inprogress")){
                        statusColor = "#f04124";
                    }

        %>
        <tr>
            <td style="text-align: center; padding-left: 0.2em"><a href="index.jsp?wardNumber=<%=wardNumber%>"><%=wardNumber%></a>
            </td>
            <td style="padding: 1.5em"><a href="index.jsp?<%=newLink%>workID=<%=workID%>"><%=workDescriptionEnglish%></a>
            </td>
            <td style="text-align: center"><%=workOrderDate%>
            </td>
            <td style="text-align: center"><%=workCompletionDate%>
            </td>
            <td style="text-align: center"><a href="index.jsp?<%=newLink%>workTypeID=<%=workTypeID%>"><%=workType%></a>
            </td>
            <td style="text-align: center"><a href="index.jsp?<%=newLink%>sourceOfIncomeID=<%=sourceOfIncomeID%>"><%=sourceOfIncome%></a>
            </td>
            <td style="text-align: center"><a href="index.jsp?<%=newLink%>contractorID=<%=contractorID%>"><%=contractor%></a>
            </td>
            <td style="text-align: center"><%=amountSanctioned%>
            </td>
            <td style="text-align: center; padding-right: 0.2em; color: <%=statusColor%>;"><a href="index.jsp?<%=newLink%>status=<%=status%>"><%=statusFirstLetterCapital%></a>
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
