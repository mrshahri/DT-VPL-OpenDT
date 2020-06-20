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
    <%--<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/image-picker.css"/>">--%>
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<%--
    <script src="<c:url value="/resources/js/image-picker.js"/>"></script>
    <script src="<c:url value="/resources/js/image-picker.min.js"/>"></script>
--%>

    <script type="text/javascript">
        var subtasks;
        var mashupConfig = [];
        var vff = {vId:'', name:'', dts:mashupConfig, url:''};
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
                var dtId = 'dtId' + (i+1);
                var svcId = "svcId" + (i+1);
                var subtask = {id: subtaskTitleId, idValue:'', typeId:subtaskTypeId, typeIdValue: '', dtId: dtId, dtIdValue: ''};
                subtasks.push(subtask);

                innerHTML += "        <div class=\"form-group\">\n" +
                    "                <label for=\"" + subtaskTitleId + "\">Subtask # " + (i+1) +"</label>\n" +
                    "            <input type=\"text\" class=\"form-control\" id=\""+ subtaskTitleId + "\" " +
                    "               placeholder=\"Subtask Title\">\n" +
                    "                </div>\n" +
                    "                <div class=\"form-group\">\n" +
                    "                <label for=\"" + subtaskTypeId + "\">Select Subtask Type</label>\n" +
                    "            <select class=\"form-control\" id=\"" + subtaskTypeId + "\" " +
                    "            onchange=\'populateDTSelectComboBox(\"" + dtId + "\", \"" + subtaskTypeId + "\", \"" + svcId + "\")\'>\n" +
                    "                <option selected>Additive</option>\n" +
                    "                <option>Subtractive</option>\n" +
                    "                <option>Moving</option>\n" +
                    "                </select>\n" +
                    "                </div>\n" +
                    "                <div class=\"form-group\">\n" +
                    "                <label for=\"" + dtId + "\">Select DT</label>\n" +
                    "            <select class=\"form-control\" id=\"" + dtId + "\"" +
                    "            onchange=\'populateSvcSelectCombobox(\"" + svcId + "\", \"" + dtId + "\")\'>\n" +
                    "                <option selected>Bukito</option>\n" +
                    "                <option>Ultimaker2</option>\n" +
                    "                </select>\n" +
                    "                </div>\n" +
                    "                <div class=\"form-group\">\n" +
                    "                <label for=\"" + svcId + "\">Select DT Service</label>\n" +
                    "            <select class=\"form-control\" id=\"" + svcId + "\">\n" +
                    "                <option selected>Bukito.temperature</option>\n" +
                    "                <option>Bukito.coordinates</option>\n" +
                    "                <option>Bukito.monitoring</option>\n" +
                    "                <option selected>Bukito.print</option>\n" +
                    "                <option>Bukito.stop</option>\n" +
                    "                </select>\n" +
                    "                </div>\n";
            }
            innerHTML += "        <div class=\"form-group\">\n" +
                    "<button type=\"submit\" class=\"btn btn-primary\" " +
                    "onclick=\'configureDTMashup()\'>Create DT Mashup</button>\n" +
                    "</div>\n";
            node.innerHTML = innerHTML;
        }
        
        function populateDTSelectComboBox(dtId, subtaskTypeId, svcId) {
            var node = document.getElementById(dtId);
            var typeIdValue = $("#" + subtaskTypeId).val();
            var tempString = "";
            if (typeIdValue === 'Additive') {
                tempString += "<option selected>Bukito</option>" +
                    "<option>Ultimaker2</option>";
            } else if (typeIdValue === 'Subtractive') {
                tempString += "<option>XCarve</option>";
            } else if (typeIdValue === 'Moving') {
                tempString += "<option>UARM</option>";
            }
            node.innerHTML = tempString;
            populateSvcSelectCombobox(svcId, dtId);
        }
        
        function populateSvcSelectCombobox(svcId, dtId) {
            var node = document.getElementById(svcId);
            var dtIdValue = $("#" + dtId).val();
            var tempString = "";
            if (dtIdValue === 'Bukito') {
                tempString += "                <option>Bukito.temperature</option>\n" +
                    "                <option>Bukito.coordinates</option>\n" +
                    "                <option>Bukito.monitoring</option>\n" +
                    "                <option selected>Bukito.print</option>\n" +
                    "                <option>Bukito.stop</option>\n";

            } else if (dtIdValue === 'Ultimaker2') {
                tempString += "                <option selected>Ultimaker2.temperature</option>\n" +
                    "                <option>Ultimaker2.coordinates</option>\n" +
                    "                <option>Ultimaker2.monitoring</option>\n" +
                    "                <option selected>Ultimaker2.print</option>\n" +
                    "                <option>Ultimaker2.stop</option>\n";

            } else if (dtIdValue === 'XCarve') {
                tempString += "                <option selected>XCarve.spindle-speed</option>\n" +
                    "                <option>XCarve.coordinates</option>\n" +
                    "                <option>XCarve.monitoring</option>\n" +
                    "                <option selected>XCarve.drill</option>\n" +
                    "                <option>XCarve.stop</option>\n";

            } else if (dtIdValue === 'UARM') {
                tempString += "                <option>UARM.coordinates</option>\n" +
                    "                <option selected>UARM.move</option>\n";

            }
            node.innerHTML = tempString;
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
                    "                <label for=\"" + dtId + "\">Digital Twin Service for Sub-task: " + idValue +"</label>\n" +
                    "                <select class=\"form-control\" id=\"" + dtId + "\" style=\"display: block\">";

                if (typeIdValue === 'Additive') {
                    // Bukito or Ultimaker
                    tempString += "<option selected>bukito.services.print</option>" +
                        "<option>ultimaker.services.print</option>";
                } else if (typeIdValue === 'Subtractive') {
                    // Xcarve
                    tempString += "<option>xcarve.services.drill</option>";
                } else if (typeIdValue === 'Moving') {
                    // UARM 1 & 2
                    tempString += "<option>uarm.services.move</option>";
                }
                tempString += "</select></div>\n";
                node.innerHTML += tempString

                subtask['idValue'] = idValue;
                subtask['typeIdValue'] = typeIdValue;
            }
            node.innerHTML += "<button type=\"submit\" class=\"btn btn-primary\" " +
                "onclick=\"configureDTMashup()\">Configure Virtual Assembly Line</button>\n";
        }

        function configureDTMashup() {
            mashupConfig = [];
            var processTitle = document.getElementById('processTitle').value;
            var mashup = "";
            for (var i=0; i<subtasks.length; i++) {
                var svcId = "svcId" + (i+1);
                var svcIdValue = document.getElementById(svcId).value;
                mashupConfig.push(svcIdValue);
                if (i<subtasks.length-1) {
                    mashup += svcIdValue + '->';
                } else {
                    mashup += svcIdValue;
                }
            }
            vff['vId'] = ++vfIdCounter;
            vff['mashup'] = mashup;
            console.log('VFF: \n' + JSON.stringify(vff));
            var node = document.getElementById('vffs');
            node.innerHTML += "            <tr>\n" +
                "                <th scope=\"row\">" + vff['vId'] + "</th>\n" +
                "                <td>" + vff['mashup'] + "</td>\n" +
                "<td><button type=\"submit\" class=\"btn btn-primary\" onclick=\"startOperation()\">Start</button></td>" +
                "            </tr>\n";
        }

        function startOperation() {
            alert('TBD: Machine Integration');
        }
    </script>

    <title>DT Mashup</title>


</head>
<body>
<h3 align="center">Create a Manufacturing Mashup</h3>
<div class="card-group">
    <br>
    <div class="card">
        <div class="card-header">
            <h5><span class="badge badge-secondary">Create a Process</span></h5>
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
            <h5><span class="badge badge-secondary">Specify Process Subtasks</span></h5>
        </div>
        <div class="card-body" id="input-subtask">
        </div>
    </div>
    <div class="card">
        <div class="card-header">
            <h5><span class="badge badge-secondary">List of Published DT Mashups</span></h5>
        </div>
        <div class="card-body" id="choose-dt">
            <table class="table">
                <thead class="thead-dark">
                <tr>
                    <th scope="col">Id</th>
                    <th scope="col">DT Mashup Config</th>
                    <th scope="col">Execute</th>
                </tr>
                </thead>
                <tbody id="vffs">
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>