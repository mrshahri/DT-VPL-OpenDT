<%@ page import="com.cpmc.utils.DTPlatform" %><%--
  Created by IntelliJ IDEA.
  User: mrshahri
  Date: 2/13/2020
  Time: 4:03 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Ultimaker DT Mashup App</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
            integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
            integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
            integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
            crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

    <script>

        <%
                DTPlatform platform = DTPlatform.getPlatform();
                String temperature = platform.getPlatformManager().getDT("Ultimaker01").getData("bedTemperature");
//                String resetStatus = platform.getPlatformManager().getDT("Ultimaker01").invokeService("reset");
        %>

        console.log("<%=temperature%>");
        <%--console.log("<%=resetStatus%>");--%>

        function getData() {
        }

        function execute() {
            var jsonObj = {dtId: 'Ultimaker01', operationId: 'reset'};
            $.ajax({
                type: "POST",
                contentType: "application/json",
                url: "http://localhost:8101/cpmc-virtual/mashup/execute",
                data: JSON.stringify(jsonObj),
                dataType: 'json',
                success: function (data) {
                    // Code to display the response.
                    alert(data);
                },
                error: function (err) {
                    alert(err.responseText)
                }
            });
        }

        // window.setInterval(getData, 500);


        window.onload = function () {

            var dps = []; // dataPoints
            var chart = new CanvasJS.Chart("chartContainer", {
                title: {
                    text: "Ultimaker Bed Temperature"
                },
                axisY: {
                    includeZero: false
                },
                data: [{
                    type: "line",
                    dataPoints: dps
                }]
            });

            var xVal = 0;
            var yVal = 100;
            var updateInterval = 1000;
            var dataLength = 20; // number of dataPoints visible at any point

            var updateChart = function () {

                var jsonObj = {dtId: 'Ultimaker01', operationId: 'bedTemperature'};
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    url: "http://localhost:8101/cpmc-virtual/mashup/getData",
                    data: JSON.stringify(jsonObj),
                    dataType: 'json',
                    success: function (data) {
                        // Code to display the response.
                        // document.getElementById('datalabel').innerHTML = data;
                        dps.push({
                            x: xVal,
                            y: data
                        });
                        chart.render();
                        if (dps.length > dataLength) {
                            dps.shift();
                        }
                        xVal++;
                    },
                    error: function (err) {
                        console.log(err.responseText)
                    }
                });

            };

            updateChart(dataLength);
            setInterval(function () {
                updateChart()
            }, updateInterval);

        }

    </script>


</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <h2>Ultimaker2 DT Mashup Application</h2>
    </div>
    <div class="row justify-content-center">

        <table class="table">
            <tr>
                <th style="text-align: center; width: 75%">Monitoring</th>
                <th style="text-align: center">Operation Execution</th>
            </tr>
            <tr>
                <td id="datalabel">
                    <%--<%=temperature%>--%>
                    <div class="arrow-button" id="chartContainer" style="height: 350px; width:100%;"></div>
                </td>
                <td style="text-align: center">
                    <button onclick="execute()" class="btn btn-primary">Reset Ultimaker</button>
                </td>
            </tr>
        </table>
    </div>
</div>
</body>
</html>
