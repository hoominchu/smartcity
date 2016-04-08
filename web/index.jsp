<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"

         import = "com.mongodb.*"

        import = "java.util.Arrays"
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
  </head>
  <body>

  <div class="container">
    <img src="images/hdmc-logo.png" width="140em" height="140em" style="display:inline-block; margin-right:1em; margin-left:7em;">

    <h2 style="text-align:center; display:inline-block;"><a href="../allworks/allworks.html">Hubballi Dharwad Smart Cities Project</a></h2>

    <img src="images/smartcitylogo.jpg" width="150em" height="150em" style="display:inline-block; margin-left:1em; margin-top:1.2em;"><div class="pull-right" style="margin-top:40px;"><a href="allworks_k.html" target="_blank">ಕನ್ನಡ</a> | <a href="allworks.html" target="_blank">English</a></div>

  <%


    try{

    Mongo mongo = new Mongo();

    DB db = mongo.getDB("mydb");

    DBCollection smartcity = db.getCollection("smartcity");

    BasicDBObject wardQuery = new BasicDBObject();

    wardQuery.put("Ward Number",14);

    DBCursor cursor = smartcity.find(wardQuery);

    while (cursor.hasNext()){
    DBObject object = cursor.next();
    %>
    <p><%=object%></p>

    <%
    }
      }catch(Exception e){
      System.err.println( e.getClass().getName() + ": " + e.getMessage() );
      }
  %>

  </div>

  </body>
</html>
