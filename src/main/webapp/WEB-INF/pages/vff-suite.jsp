<%--
  Created by IntelliJ IDEA.
  User: mrshahri
  Date: 4/28/2019
  Time: 2:48 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/image-picker.css"/>">
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="<c:url value="/resources/js/image-picker.js"/>"></script>
    <script src="<c:url value="/resources/js/image-picker.min.js"/>"></script>

    <script type="text/javascript">
        var subtasks;
        var maLine = [];
        var vff = {vId:'', name:'', dts:maLine, url:''};
        var vfIdCounter = 0;

        function spreadSubtasks(subtaskCount) {

            subtasks = [];
            var subtaskTitleId = 'subtaskTitle';
            var subtaskTypeId = 'subtaskType';

            var node = document.getElementById('input-subtask');
            var innerHTML = "";

            for (var i=0; i<subtaskCount; ++i) {
                subtaskTitleId += (i+1);
                subtaskTypeId += (i+1);
                var subtask = {id: subtaskTitleId, idValue:'', typeId:subtaskTypeId, typeIdValue: '', dtId: '', dtIdValue: ''};
                subtasks.push(subtask);

                innerHTML += "        <div class=\"form-group\">\n" +
                    "                <label for=\"" + subtaskTitleId + "\">Subtask # " + (i+1) +"</label>\n" +
                    "            <input type=\"text\" class=\"form-control\" id=\""+ subtaskTitleId + "\" " +
                    "               placeholder=\"Subtask Title\">\n" +
                    "                </div>\n" +
                    "                <div class=\"form-group\">\n" +
                    "                <label for=\"" + subtaskTypeId + "\">Select Type</label>\n" +
                    "            <select class=\"form-control\" id=\"" + subtaskTypeId + "\">\n" +
                    "                <option>Additive</option>\n" +
                    "                <option>Subtractive</option>\n" +
                    "                <option>Movement</option>\n" +
                    "                </select>\n" +
                    "                </div>\n";
            }
            innerHTML += "<button type=\"submit\" class=\"btn btn-primary\" " +
                "                                       onclick=\'prepareDigitalTwinSelectionView()\'>Proceed to DT Selection</button>";
            node.innerHTML = innerHTML;
        }

        function prepareDigitalTwinSelectionView() {
            console.log(JSON.stringify(subtasks));
            var node = document.getElementById('choose-dt');
            node.innerHTML = "";
            for (var i = 0; i < subtasks.length; i++) {
                var dtId = 'dtId' + (i+1);
                var subtask = subtasks[i];

                var idValue = document.getElementById(subtask['id']).value;
                var typeIdValue = document.getElementById(subtask['typeId']).value;

                var tempString = "            <div class=\"form-group\">\n" +
                    "                <label for=\"" + dtId + "\">Digital Twin for Sub-task: " + idValue +"</label>\n" +
                    "                <select class=\"form-control image-picker  show-labels show-html\" id=\"" + dtId + "\">";

                if (typeIdValue === 'Additive') {
                    // Bukito or Ultimaker
                    tempString += "<option data-img-src=\"<c:url value="/resources/images/bukito.jpg"/>" +
                            "\" data-img-class=\"first\" data-img-alt=\"Bukito\" value=\"bukito\">bukito</option>" +
                        "<option data-img-src=\"<c:url value="/resources/images/ultimaker.jpg"/>" +
                            "\" data-img-alt=\"Ultimaker\" value=\"ultimaker\">ultimaker</option>";
                } else if (typeIdValue === 'Subtractive') {
                    // Xcarve
                    tempString += "<option data-img-src=\"<c:url value="/resources/images/xc-750.png"/>\"" +
                        " data-img-alt=\"XCarve\" data-img-class=\"first\" value=\"xcarve\"> xcarve </option>";
                } else if (typeIdValue === 'Movement') {
                    // UARM 1 & 2
                    tempString += "<option data-img-src=\"<c:url value="/resources/images/uarm.jpg"/>\"" +
                            "\data-img-alt=\"Uarm 1\" data-img-class=\"first\" value=\"uarm1\">Uarm 1</option>" +
                        "<option data-img-src=\"<c:url value="/resources/images/uarm.jpg"/>\"" +
                            "\data-img-alt=\"Uarm 2\" value=\"uarm2\">Uarm 2</option>";
                }
                tempString += "</select></div>\n";
                node.innerHTML += tempString

                subtask['idValue'] = idValue;
                subtask['typeIdValue'] = typeIdValue;
            }
            node.innerHTML += "<button type=\"submit\" class=\"btn btn-primary\" " +
                "onclick=\"configureManufacturingAssemblyLine()\">Configure Virtual Assembly Line</button>\n";
            for (i = 1; i <= subtasks.length; i++) {
                dtId = 'dtId' + i;
                $("#" + dtId).imagepicker({show_label: true});
            }
        }

        function configureManufacturingAssemblyLine() {
            console.log('Subtasks: \n' + JSON.stringify(subtasks));

            maLine = [];
            var processTitle = document.getElementById('processTitle').value;
            var url = "";
            for (var i=0; i<subtasks.length; i++) {
                var dtId = "dtId" + (i+1);
                var dtIdValue = document.getElementById(dtId).value;
                maLine.push(dtIdValue);
                if (i<subtasks.length-1) {
                    url += dtIdValue + '-';
                } else {
                    url += dtIdValue;
                }
            }
            vff['vId'] = ++vfIdCounter;
            vff['name'] = processTitle;
            vff['dts'] = maLine;
            vff['url'] = url;
            console.log('VFF: \n' + JSON.stringify(vff));
            var node = document.getElementById('vffs');
            // HACK
            var hackUrl = '';
            if (subtasks.length === 2) {
                hackUrl = 'bukito-uarm'
            } else if (subtasks.length === 3) {
                hackUrl = 'ultimaker-uarm-xcarve';
            }
            node.innerHTML += "            <tr>\n" +
                "                <th scope=\"row\">" + vff['vId'] + "</th>\n" +
                "                <td>" + vff['name'] + "</td>\n" +
                "                <td>" + vff['dts'] + "</td>\n" +
                "                <td><a class=\"btn btn-primary\" target=\'_blank\' href=\"" + hackUrl + "\" " +
                "                role=\"button\">" + vff['url'] + "</a>" + "</td>\n" +
                "<td><button type=\"submit\" class=\"btn btn-primary\" onclick=\"startOperation()\">Start</button></td>" +
                "            </tr>\n";
        }

        function startOperation() {
            alert('operation started');
        }
    </script>

    <title>Virtual Factory</title>


</head>
<body>
<h3 align="center">Construct Virtual Assembly Line</h3>
<div class="card-group">
    <br>
    <div class="card">
        <div class="card-header">
            <h5><span class="badge badge-secondary">Create an Assembly Line</span></h5>
        </div>
        <div class="card-body" id="process">
                <div class="form-group">
                    <label for="processTitle">Title</label>
                    <input type="text" class="form-control" id="processTitle" placeholder="Process Title">
                </div>
                <div class="form-group">
                    <label for="subtasksNumber"># of Subtasks</label>
                    <select class="form-control" id="subtasksNumber">
                        <option>1</option>
                        <option>2</option>
                        <option>3</option>
                        <option>4</option>
                        <option>5</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary"
                        onclick="spreadSubtasks(subtasksNumber.value)">Decompose Process</button>
        </div>
    </div>
    <div class="card">
        <div class="card-header">
            <h5><span class="badge badge-secondary">Breakdown Process into Subtasks</span></h5>
        </div>
        <div class="card-body" id="input-subtask">
        </div>
    </div>
    <div class="card">
        <div class="card-header">
            <h5><span class="badge badge-secondary">Select Operable Digital Twins</span></h5>
        </div>
        <div class="card-body" id="choose-dt">
        </div>
    </div>
</div>

<h3 align="center">Virtual Assembly Lines</h3>
<table class="table">
    <thead class="thead-dark">
    <tr>
        <th scope="col">Id</th>
        <th scope="col">Production Line</th>
        <th scope="col">Virtual Assembly Line</th>
        <th scope="col">3D Monitoring of Composite Digital Twin</th>
        <th scope="col">Operation</th>
    </tr>
    </thead>
    <tbody id="vffs">
    </tbody>
</table>

</body>
</html>