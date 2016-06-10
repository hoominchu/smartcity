<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/06/16
  Time: 2:06 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>

</head>
<body>
<script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>
<div class="container">
    <span>
    <img src="images/hdmc-logo.png" width="140em" height="140em"
         style="display:inline-block; margin-right:1em; margin-left:7em;">

    <h2 style="text-align:center; display:inline-block;"><a href="index.jsp">Hubballi Dharwad Smart
        Cities Project</a></h2>

    <img src="images/smartcitylogo.jpg" width="150em" height="150em"
         style="display:inline-block; margin-left:1em; margin-top:1.2em;">

        </span>

    <hr>
    <h2>About the project</h2>
    <div id="about-project">
        <p>This project aims at creating software that helps make sense of the data being collected by Hubli-Dharwad
            Municipal Corporation. It will help bring transparency in the system by making all the information available
            to
            public in an easily understandable format. This will also help smoothen processes in the offices by letting
            people access information easily.</p>

        <p>This project has two main components. The first component of the project is to build tools for administrators
            and local political leaders which help in making better decisions. For example, the commissioner of HDMC
            will be
            able to look at the dashboard to get information about ward wise expenditure, number of works in progress,
            total
            amount of funds, funds already used up and so on. With the help of maps he/she can get a clear picture of
            where
            the work is being done. The commissioner can also monitor the works by checking the images submitted by the
            contractors and see if the citizens are satisfied by looking at their comments on the works.</p>

        <p>Second component aims at making this a portal for Hubli-Dharwad citizens to track what is happening around
            them
            in them in the city. This will help people in becoming more responsible and participate actively in the
            development of their city. The contact information of the corporators/concerned persons will also be made
            public
            and easily accessible. It will be of great help if any citizen, who experiences inconvenience due to some
            civic
            work going on in his/her area, can get to know the details of the work such as who is the contractor, when
            should it be completed, how much is the amount sanctioned for the project and so on. People can also comment
            on
            any work and discuss about it with fellow citizens thus creating a productive social network space.
        </p>

        <p>If you are interested in working with us please email us at <b>inspection.hdmc@gmail.com</b>.</p>
    </div>
    <hr>
    <h2>Features</h2>
    <div class="about-images" style="height: 37em">
        <div class="about-slide slick-slide"><img src="images/about/maps.png" style="height: 33em" class="round-corner">
            <div class="about-description"><h3>Maps to show the location of the work</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/chart.png" style="height: 33em"
                                                  class="round-corner">
            <div class="about-description"><h3>Dashboards</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/photos_and_comments.png" style="height: 33em"
                                                  class="round-corner">
            <div class="about-description"><h3>Photos and comments</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/overview_and_works.png" style="height: 33em"
                                                  class="round-corner">
            <div class="about-description"><h3>Overview and description of works</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/work_info.png" style="height: 33em"
                                                  class="round-corner">
            <div class="about-description"><h3>Information about works</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/bill_and_work_details.png" style="height: 33em"
                                                  class="round-corner">
            <div class="about-description"><h3>Details of the work and bills paid</h3></div>
        </div>
    </div>

    <hr style="margin-top: 3em">

    <h2>People</h2>
    <div style="margin-top: 3em">
        <div class="row">
            <div class="col-sm-4">
                <img src="images/about/minchu.jpg" class="img-circle" height="160px" width="160px"
                     style="margin-left: 25%">
                <div class="name">Minchu Kulkarni</div>
                <div class="designation">Designer and Developer</div>
                <div class="about-person text-muted">
                    <small>
                        We gathered data relating to all the works going on under the municipal corporation and their
                        details
                        such as stages of completion, source of funding and expenditures etc. from the municipality.
                        This data
                        was put on a website in an understandable manner.
                    </small>
                </div>
            </div>
            <div class="col-sm-4">
                <img src="images/about/hangal.jpg" class="img-circle" height="160px" width="160px"
                     style="margin-left: 25%">
                <div class="name">Sudheendra Hangal</div>
                <div class="designation">Advisor</div>
                <div class="about-person text-muted">
                    <small>
                        Prof. Hangal got his Ph.D. in Computer Science at Stanford University, where he worked on social
                        computing and human-computer interaction in the Mobisocial and HCI Labs.His thesis explored
                        novel
                        applications for the digital life-logs that millions of consumers are collecting. Prof. Hangal
                        has also
                        worked on multiprocessor computer architecture, virtual machine compilers, software engineering
                        and
                        debugging tools. During his tenure in the microprocessor division of Sun Microsystems, he led a
                        team
                        that was recognized with the Chairman’s Award for Innovation, the highest recognition for
                        technical
                        leadership.
                    </small>
                </div>
            </div>
            <div class="col-sm-4">
                <img src="images/about/mrinalini.jpg" class="img-circle" height="160px" width="160px"
                     style="margin-left: 25%">
                <div class="name">Mrinalini Kalkeri</div>
                <div class="designation">Project Head</div>
                <div class="about-person text-muted">
                    <small>
                        Prof. Hangal got his Ph.D. in Computer Science at Stanford University, where he worked on social
                        computing and human-computer interaction in the Mobisocial and HCI Labs.His thesis explored
                        novel
                        applications for the digital life-logs that millions of consumers are collecting. Prof. Hangal
                        has also
                        worked on multiprocessor computer architecture, virtual machine compilers, software engineering
                        and
                        debugging tools.
                    </small>
                </div>
            </div>
        </div>
    </div>

    <hr>

    <h2>In collaboration with</h2>
    <div style="margin: 2em">
        <div class="row>">
            <div class="col-sm-5">
                <img src="images/about/TCPD-Logo.png" height="80px" style="margin-bottom: 3em;">
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $('.about-images').slick({
            slidesToShow: 1,
            slidesToScroll: 1,
            dots: true,
            arrows: true,
            autoplay: true,
            centerMode: true,
            variableWidth: true,
            zindex: -100,
            adaptiveHeight: true,
            autoplaySpeed: 6500,
            centerPadding: '80px'
        });
    });
</script>

<div class="panel-footer" style="text-align: center; color: grey">
    <small>&#169 Hubballi-Dharwad Municipal Corporation 2016</small>
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
                Email us at &mdash; <b>inspection.hdmc@gmail.com</b><br>
                Call us on &mdash; <b>+91 0836 2213888</b></p>
                <hr>
                <p><h5><b>Our Address</b></h5></p>
                <p>MIS Cell, <br>
                    Hubli-Dharwad Municipal Corporation, <br>
                    Sir Siddappa Kambli Road, <br>
                    Hubballi - 580028
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
