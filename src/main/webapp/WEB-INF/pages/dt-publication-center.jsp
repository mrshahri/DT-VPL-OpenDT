<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: mrshahri
  Date: 1/23/2020
  Time: 12:36 PM
  To change this template use File | Settings | File Templates.
--%>
<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
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

    <title>DT Publication Center</title>

    <script type="text/javascript">
        function publishDigitalTwin() {
            var jsonObj = {
                dtId: '', dtName: '', dtType: '', dtEndpoint: '', dtDescription: '', dtPrimaryCategory: '',
                dtSecondaryCategory: '', scope: ''
            };
            jsonObj.dtId = '';
            jsonObj.dtName = $("#machineName").val();
            jsonObj.dtType = $("#machineType").val();
            jsonObj.dtEndpoint = $("#inputEndpoint").val();
            jsonObj.dtDescription = $("#inputDescription").val();
            jsonObj.dtPrimaryCategory = $("#inputPrimaryCategory").val();
            jsonObj.dtSecondaryCategory = $("#inputSecondaryCategory").val();
            jsonObj.scope = $("#inputScope").val();
            // alert(JSON.stringify(jsonObj));
            $.ajax({
                type: "POST",
                contentType: "application/json",
                url: "http://localhost:8101/cpmc-virtual/mashup/publish",
                data: JSON.stringify(jsonObj),
                dataType: 'json',
                success: function (data) {
                    // Code to display the response.
                    alert(data);
                    window.location.reload();
                }
            });
        }

        $("#dtPublishForm").submit(function (e) {
            e.preventDefault();
        });


    </script>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <h3 align="center">Digital Twin Publishing Center</h3>
    </div>
    <div class="row justify-content-center">
        <div class="col col-12">
            <div class="card">
                <div class="card-header">
                    <h5><span class="badge badge-secondary">Publish a Digital Twin</span></h5>
                </div>
                <div class="card-body" id="publishing">
                    <form id="dtPublishForm" <%--onsubmit="publishDigitalTwin()"--%> <%--onsubmit="return false"--%>>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="machineName">Machine Name</label>
                                <input type="text" class="form-control" id="machineName" placeholder="">
                            </div>
                            <div class="form-group col-md-6">
                                <label for="machineType">Machine Type</label>
                                <input type="text" class="form-control" id="machineType" placeholder="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputEndpoint">Endpoint URL</label>
                            <input type="text" class="form-control" id="inputEndpoint" placeholder="http://...">
                        </div>
                        <div class="form-group">
                            <label for="inputDescription">DT Description</label>
                            <input type="text" class="form-control" id="inputDescription" placeholder="">
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="inputPrimaryCategory">Primary Category</label>
                                <input type="text" class="form-control" id="inputPrimaryCategory"
                                       placeholder="manufacturing, ...">
                            </div>
                            <div class="form-group col-md-4">
                                <label for="inputSecondaryCategory">Secondary Category</label>
                                <input type="text" class="form-control" id="inputSecondaryCategory"
                                       placeholder="additive, plastic, ...">
                            </div>
                            <div class="form-group col-md-2">
                                <label for="inputScope">Scope</label>
                                <select id="inputScope" class="form-control">
                                    <option selected>Choose...</option>
                                    <option>Single Purpose API</option>
                                    <option>Aggregate API</option>
                                    <option>Microservice API</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary" onclick="publishDigitalTwin()">Publish</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="row justify-content-center">
        <h3 align="center">Published Digital Twins</h3>
    </div>
    <c:forEach items="${publishedDTs}" var="dt">
        <div class="row justify-content-center">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><span class="badge badge-secondary">Digital Twin Name: ${dt.dtName}</span></h5>
                    </div>
                    <div class="card-body">
                        <p>${dt.dtDescription}</p>
                        <a href="${dt.dtEndpoint}}" class="btn btn-primary">Go ${dt.dtName} Home Page</a>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<%--
    // this needs to loop - will come back here after forming the json
    <div class="card" id="PublishedTwin">
        <div class="card-header">
            <h5><span class="badge badge-secondary">Published Digital Twins</span></h5>
        </div>
        <div class="card-body" id="input-subtask">
        </div>
    </div>
--%>

</body>
</html>