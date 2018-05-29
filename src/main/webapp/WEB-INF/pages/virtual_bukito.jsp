<%--
  Created by IntelliJ IDEA.
  User: Rakib
  Date: 7/13/2017
  Time: 5:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Virtual Copy of Bukito</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css"
          integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
    <link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">


    <script src="<c:url value="/resources/js/three.js"/>"></script>

    <script src="<c:url value="/resources/js/DDSLoader.js"/>"></script>
    <script src="<c:url value="/resources/js/MTLLoader.js"/>"></script>
    <script src="<c:url value="/resources/js/OBJLoader.js"/>"></script>

    <script src="<c:url value="/resources/js/DragControls.js"/>"></script>
    <%--<script src="<c:url value="/resources/js/TrackballControls.js"/>"></script>--%>
    <script src="<c:url value="/resources/js/Detector.js"/>"></script>
    <script src="<c:url value="/resources/js/stats.min.js"/>"></script>
    <script src="<c:url value="/resources/js/tween.min.js"/>"></script>
    <script src="<c:url value="/resources/js/jquery-3.2.1.min.js"/>"></script>

    <style>

        .slidecontainer {
            width: 100%;
        }

        .slider {
            -webkit-appearance: none;
            width: 100%;
            height: 25px;
            background: #d3d3d3;
            outline: none;
            opacity: 0.7;
            -webkit-transition: .2s;
            transition: opacity .2s;
        }

        .slider:hover {
            opacity: 1;
        }

        .slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 25px;
            height: 25px;
            background: #4CAF50;
            cursor: pointer;
        }

        .slider::-moz-range-thumb {
            width: 25px;
            height: 25px;
            background: #4CAF50;
            cursor: pointer;
        }

        #rcorners1 {
            border-radius: 25px;
            border: 2px solid darkblue;
            /*background: wheat;*/
            padding: 20px;
            width: auto;
            height: 250px;
        }

        #rcorners2 {
            border-radius: 25px;
            border: 2px solid darkblue;
            padding: 20px;
            width: auto;
            height: 320px;
        }

        .flex-container {
            display: -webkit-flex;
            display: flex;
            -webkit-flex-flow: row wrap;
            flex-flow: row wrap;
            text-align: center;
        }

        .flex-container > * {
            padding: 15px;
            -webkit-flex: 1 100%;
            flex: 1 100%;
        }

        .article {
            text-align: left;
            height: inherit;
            /*border-radius: 25px;*/
            /*border: 2px solid darkblue;*/
        }

        .aside {
            position: relative;
            float: left;
            width: 195px;
            top: 0px;
            bottom: 0px;
            background-color: #ebddca;
            height: 100vh;
        }

        header {
            background: black;
            color: white;
        }

        footer {
            background: #aaa;
            color: white;
        }

        .nav {
            background: #eee;
        }

        .nav ul {
            list-style-type: none;
            padding: 0;
        }

        .nav ul a {
            text-decoration: none;
        }

        @media all and (min-width: 768px) {
            .nav {
                text-align: left;
                -webkit-flex: 1 auto;
                flex: 1 auto;
                -webkit-order: 1;
                order: 1;
            }

            .article {
                -webkit-flex: 5 0px;
                flex: 5 0px;
                -webkit-order: 2;
                order: 2;
            }

            footer {
                -webkit-order: 3;
                order: 3;
            }
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            padding: 8px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background-color: #f5f5f5
        }
    </style>

    <script>

        function diagnosNetwork() {
            var code = document.getElementById("code");
            var level = document.getElementById("level");
            var cause = document.getElementById("cause");
            $.ajax({
                url: "http://uaf132943.ddns.uark.edu:10090/ping",
                dataType: "text",
                success: function (data) {
                },
                complete: function (data) {
                    console.log(data.responseText);
                    if (data.responseText === "C1") {
                        code.innerHTML = data.responseText;
                        level.innerHTML = "WARNING";
                        cause.innerHTML = "Agent-Adapter connection may not working";
                    } else if (data.responseText === "C2") {
                        code.innerHTML = data.responseText;
                        level.innerHTML = "ERROR";
                        cause.innerHTML = "Machine not found";
                    } else if (data.responseText === "NONE") {
                        code.innerHTML = "";
                        level.innerHTML = "";
                        cause.innerHTML = "";
                    }
                },
                timeout: 12000  // two minutes
            });
        }

        function startPrinting(name) {
            var parametersObj = {deviceId: "bukito", operationId: "startJob", parameters: []};
            var parameters = [];
            parameters.push({id: "material", name: "", type: "value", value: "PLA"})
            parameters.push({id: "quantity", name: "", type: "value", value: "1"})
            parameters.push({id: "objName", name: "", type: "value", value: name})
            parametersObj.parameters = parameters;
            var requestBody = JSON.stringify(parametersObj);
            $.ajax({
                type: 'POST',
                url: "${postDeviceUrl}",
                data: requestBody,
                success: function (data) {
                    alert('data: ' + data);
                },
                contentType: "application/json",
                dataType: 'json'
            });
        }

        function operatePrinting(operationId) {
            var parametersObj = {deviceId: "bukito", operationId: operationId, parameters: []};
            var requestBody = JSON.stringify(parametersObj);
            $.ajax({
                type: 'POST',
                url: "${postDeviceUrl}",
                data: requestBody,
                success: function (data) {
                    alert('data: ' + data);
                },
                contentType: "application/json",
                dataType: 'json'
            });
            if (operationId === 'reset') {
                document.getElementById("myRangeX").value = "0";
                document.getElementById("xVal").innerHTML = "0";
                document.getElementById("myRangeY").value = "0";
                document.getElementById("yVal").innerHTML = "0";
                document.getElementById("myRangeZ").value = "0";
                document.getElementById("zVal").innerHTML = "0";
            }
        }

        var prevX = 0;
        var prevY = 0;
        var prevZ = 0;

        function moveAxis(axis_name, value) {
            // common value vars
            var deviceId = 'bukito';
            var uuid = 'Bukito01';
            var parentComponentId = 'axes';
            var component = 'Linear';
            var category = 'ACTION';
            var type = 'POSITION';

            var operationId = '';
            var operationName = '';
            var componentId = '';
            var componentName = '';

            if (axis_name === 'x') {
                var temp = value;
                value = value - prevX;
                prevX = temp;

                operationId = 'moveX';
                operationName = 'Move X Axis';
                componentId = 'x';
                componentName = 'X';
                sendParameters(deviceId, uuid, operationId, parentComponentId, componentId, component, componentName, value, category, type, operationName);
            } else if (axis_name === 'y') {
                var temp = value;
                value = value - prevY;
                prevY = temp;

                operationId = 'moveY';
                operationName = 'Move Y Axis';
                componentId = 'y';
                componentName = 'Y';
                sendParameters(deviceId, uuid, operationId, parentComponentId, componentId, component, componentName, value, category, type, operationName);
            } else if (axis_name === 'z') {
                var temp = value;
                value = value - prevZ;
                prevZ = temp;

                operationId = 'moveZ';
                operationName = 'Move Z Axis';
                componentId = 'z';
                componentName = 'Z';
                sendParameters(deviceId, uuid, operationId, parentComponentId, componentId, component, componentName, value, category, type, operationName);
            }
        }

        function sendParameters(deviceId, uuid, operationId, parentComponentId, componentId,
                                component, componentName, value, category, type, name) {
            var componentOpObj = {
                deviceId: deviceId,
                uuid: uuid,
                parentComponentId: parentComponentId,
                componentId: componentId,
                componentName: componentName,
                component: component,
                operationId: operationId,
                componentValue: value,
                category: category,
                type: type,
                name: name,
                parameters: {}
            };
            var requestBody = JSON.stringify(componentOpObj);
            $.ajax({
                type: 'POST',
                url: "${postComponentUrl}",
                data: requestBody,
                success: function (data) {
                    alert('data: ' + data);
                },
                contentType: "application/json",
                dataType: 'json'
            });
        }

        function clearTable() {
            var code = document.getElementById("code");
            var level = document.getElementById("level");
            var cause = document.getElementById("cause");
            code.innerHTML = "";
            level.innerHTML = "";
            cause.innerHTML = "";
        }
    </script>
</head>

<body>
<div class="flex-container">
    <header>
        <h1>Digital-Twin of Bukito 3D Printer</h1>
    </header>

    <article class="article" id="article"></article>

    <aside class="article">
        <div id="rcorners1">
            <table>
                <tr>
                    <th>Device Operations</th>
                </tr>
                <tr>
                    <td>
                        <input type="button" class="btn btn-success" value="Print Triangle"
                               onclick="startPrinting('Triangle')">
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" class="btn btn-success" value="Stop"
                               onclick="operatePrinting('stopJob')">
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" class="btn btn-success" value="Reset"
                               onclick="operatePrinting('reset')">
                    </td>
                </tr>
            </table>
        </div>

        <br>
        <div id="rcorners2">
            <table>
                <%--Sliders--%>
                <tr>
                    <th>Component Operations</th>
                </tr>
                <tr>
                    <td>
                        <div class="slidecontainer">
                            <p style="color: darkblue">Move Nozzle (X=<span id="xVal"></span>) </p>
                            <input type="range" min="0" max="130" value="0" class="slider" id="myRangeX" onchange="moveAxis('x', this.value)">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="slidecontainer">
                            <p style="color: darkblue">Move Bed (Y=<span id="yVal"></span>) </p>
                            <input type="range" min="0" max="160" value="0" class="slider" id="myRangeY" onchange="moveAxis('y', this.value)">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="slidecontainer">
                            <p style="color: darkblue">Move Crane Arm (Z=<span id="zVal"></span>) </p>
                            <input type="range" min="0" max="120" value="0" class="slider" id="myRangeZ" onchange="moveAxis('z', this.value)">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </aside>
    <script>

        var sliderX = document.getElementById("myRangeX");
        var sliderY = document.getElementById("myRangeY");
        var sliderZ = document.getElementById("myRangeZ");
        var outputX = document.getElementById("xVal");
        var outputY = document.getElementById("yVal");
        var outputZ = document.getElementById("zVal");
        outputX.innerHTML = sliderX.value;
        outputY.innerHTML = sliderY.value;
        outputZ.innerHTML = sliderZ.value;

        sliderX.oninput = function() {
            outputX.innerHTML = this.value;
        }
        sliderY.oninput = function() {
            outputY.innerHTML = this.value;
        }
        sliderZ.oninput = function() {
            outputZ.innerHTML = this.value;
        }
    </script>
    <footer>Copyright &copy; University of Arkansas</footer>
</div>

<script>

    var container, stats, controls;
    var bedObject = {}, activeHeadObject = {}, normalHeadObject = {}, redHeadObject = {};
    var craneArmObject = {}, machineAssemblyObject = {};
    var filamentAssemblyObject = {}, redFilamentAssemblyObject = {}, activeFilamentAssemblyObject = {};
    var draggableObjects = [];
    var camera, scene, renderer;
    var mouseX = 0, mouseY = 0;

    // hack
    var craneOffset = 0;

    var windowHalfX = window.innerWidth / 2;
    var windowHalfY = window.innerHeight / 2;

    init();
    animate();
    //render();

    function init() {

        container = document.getElementById('article');
        camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 0.1, 2000);
        camera.position.z = 0.25;

        // scene
        scene = new THREE.Scene();

        var ambient = new THREE.AmbientLight(0x444444);
        scene.add(ambient);

        var directionalLight = new THREE.DirectionalLight( 0xffffff, 1.0, 1000 );
        scene.add(directionalLight);

        // model
        var onProgress = function (xhr) {
            if (xhr.lengthComputable) {
                var percentComplete = xhr.loaded / xhr.total * 100;
            }
        };

        var onError = function (xhr) {
        };

        THREE.Loader.Handlers.add(/\.dds$/i, new THREE.DDSLoader());

        var mtlLoader = new THREE.MTLLoader();

        // loading machine assmbly
        mtlLoader.load('<c:url value="/resources/models/machine-assembly.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            objLoader.load('<c:url value="/resources/models/machine-assembly.obj"/>', function (object) {
                machineAssemblyObject = object;

                scene.add(object);
            }, onProgress, onError);
        });

        // loading filament assembly
        mtlLoader.load('<c:url value="/resources/models/filament-reel.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            objLoader.load('<c:url value="/resources/models/filament-reel.obj"/>', function (object) {
                filamentAssemblyObject = object;
                activeFilamentAssemblyObject = filamentAssemblyObject;

                scene.add(object);
            }, onProgress, onError);
        });

        // loading red (low) filament assembly
        mtlLoader.load('<c:url value="/resources/models/filament-reel-red.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            objLoader.load('<c:url value="/resources/models/filament-reel-red.obj"/>', function (object) {
                redFilamentAssemblyObject = object;
//                activeFilamentAssemblyObject = redFilamentAssemblyObject;
//
//                scene.add(object);
            }, onProgress, onError);
        });

        // loading bed
        mtlLoader.load('<c:url value="/resources/models/bed_assembly.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            objLoader.load('<c:url value="/resources/models/bed-assembly.obj"/>', function (object) {
                bedObject = object;
                scene.add(object);
                draggableObjects.push(bedObject);
            }, onProgress, onError);
        });

        // loading crane arm assmbly
        mtlLoader.load('<c:url value="/resources/models/crane_arm_assembly.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            objLoader.load('<c:url value="/resources/models/crane-assembly.obj"/>', function (object) {
                craneArmObject = object;
                scene.add(object);
            }, onProgress, onError);
        });

        // loading hotend carriage
        mtlLoader.load('<c:url value="/resources/models/hotend_carriage.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            objLoader.load('<c:url value="/resources/models/hotend-carriage.obj"/>', function (object) {
                normalHeadObject = object;
                activeHeadObject = normalHeadObject;
                scene.add(object);
            }, onProgress, onError);
        });

        // loading red-hotend carriage
        mtlLoader.load('<c:url value="/resources/models/hotend-carriage-red.mtl"/>', function (materials) {

            materials.preload();
            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            objLoader.load('<c:url value="/resources/models/hotend-carriage-red.obj"/>', function (object) {
                redHeadObject = object;
            }, onProgress, onError);
        });

        // render all
        renderer = new THREE.WebGLRenderer();
        renderer.setClearColor(0xd3e3e1, 1);
        renderer.setPixelRatio(window.devicePixelRatio);
        renderer.setSize(window.innerWidth / 1.75, window.innerHeight / 1.75);
        container.appendChild(renderer.domElement);

        //code for dragging objects
        var dragControls = new THREE.DragControls( draggableObjects, camera, renderer.domElement );
        dragControls.addEventListener( 'dragstart', function ( event ) {
            controls.enabled = false;
            alert("Drag Started");
        }
        );
        dragControls.addEventListener( 'dragend', function ( event ) {
            controls.enabled = true;
                alert("Drag Stopped");
        }
        );

        //set events
        document.addEventListener('mousemove', onDocumentMouseMove, false);
        window.addEventListener('resize', onWindowResize, false);
    }

    function onWindowResize() {
        windowHalfX = window.innerWidth / 2;
        windowHalfY = window.innerHeight / 2;

        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    }

    function onDocumentMouseMove(event) {
        mouseX = ( event.clientX - windowHalfX ) / 2;
        mouseY = ( event.clientY - windowHalfY ) / 2;
    }

    function animate() {
        requestAnimationFrame(animate);
        render();
        TWEEN.update();
    }

    function render() {
        camera.position.x = -1;
        camera.position.y = 1;

        camera.lookAt(scene.position);

        renderer.render(scene, camera);
    }

    function reset() {
        scene.remove(redHeadObject);
        scene.add(normalHeadObject);
        activeHeadObject = normalHeadObject;
        new TWEEN.Tween(activeHeadObject.position).to({x: 0.0, y: 0.0, z: 0.0}, 5000).start();
        new TWEEN.Tween(craneArmObject.position).to({x: 0.0, y: 0.0, z: 0.0}, 5000).start();
        new TWEEN.Tween(bedObject.position).to({x: 0.0, y: 0.0, z: 0.0}, 5000).start();
    }

    function moveBed(x) {
        new TWEEN.Tween(bedObject.position).to({x: x, y:0.0, z:0.0}, 500).start();
    }

    function moveHead(y, z) {
        new TWEEN.Tween(activeHeadObject.position).to({x:0.0, y:z, z:y}, 500).start();
    }

    function moveCrane(z) {
        new TWEEN.Tween(craneArmObject.position).to({x:0.0, y:z, z:0.0}, 500).start();
    }

    function convertDate(date) {
        // format: "2018-02-17T23:30:27.644"
        var yyyy = date.getUTCFullYear().toString();
        var mm = (date.getUTCMonth()+1).toString();
        var dd  = date.getUTCDate().toString();
        var HH = date.getUTCHours().toString();
        var MM = date.getUTCMinutes().toString();
        var SS = date.getUTCSeconds().toString();
        var SSS = date.getUTCMilliseconds().toString();

        var mmChars = mm.split('');
        var ddChars = dd.split('');
        var HHChars = HH.split('');
        var MMChars = MM.split('');
        var SSChars = SS.split('');

        return yyyy + '-' + (mmChars[1]?mm:"0"+mmChars[0]) + '-' + (ddChars[1]?dd:"0"+ddChars[0]) +
            'T' + (HHChars[1]?HH:"0"+HHChars[0]) + ':' + (MMChars[1]?MM:"0"+MMChars[0]) + ':'
            + (SSChars[1]?SS:"0"+SSChars[0]) + '.' + SSS;
    }

    function getPrinterState() {
        $.getJSON("${monitorUrl}", {deviceId: "bukito"})
            .done(function (data) {
                // bed co ordinate on x axes (+/-)
                var x = -data.yPosition / 600;
                // nozzle co ordinate on y axes
                var y = data.xPosition / 400;
                // crane arm co ordinate on z axes
                var z = data.zPosition / 300;
                console.log("x=" + x + ", y=" + y + ", z=" + z);
                moveBed(x);
                moveHead(y, z);
                moveCrane(z);

                // send to dataUrl
                var parametersObj = {status: data.availability, readingTime:data.xTimeStamp, renderTime:convertDate(new Date())};
                var requestBody = JSON.stringify(parametersObj);
                $.ajax({
                    type: 'POST',
                    url: "${dataUrl}",
                    data: requestBody,
                    success: function (data) {
                        alert('data: ' + data);
                    },
                    contentType: "application/json",
                    dataType: 'json'
                });

                var nozzleTemperature = data.nozzleTemperature;
/*
                if (nozzleTemperature > 200.0) {
                    scene.remove(normalHeadObject);
                    scene.add(redHeadObject);
                    activeHeadObject = redHeadObject;
                } else {
//                    scene.remove(redHeadObject);
//                    scene.add(normalHeadObject);
//                    activeHeadObject = normalHeadObject;
                }
*/
            });
    }

    // code for timer
    window.setInterval(getPrinterState, 100);

    /* Mouse rotation Code */
    var isDragging = false;
    var previousMousePosition = {
        x: 0,
        y: 0
    };
    $(renderer.domElement).on('mousedown', function (e) {
        isDragging = true;
    })
        .on('mousemove', function (e) {
            //console.log(e);
            var deltaMove = {
                x: e.offsetX - previousMousePosition.x,
                y: e.offsetY - previousMousePosition.y
            };

            if (isDragging) {

                var deltaRotationQuaternion = new THREE.Quaternion()
                    .setFromEuler(new THREE.Euler(
                        toRadians(deltaMove.y * 1),
                        toRadians(deltaMove.x * 1),
                        0,
                        'XYZ'
                    ));

                bedObject.quaternion.multiplyQuaternions(deltaRotationQuaternion, bedObject.quaternion);
                activeFilamentAssemblyObject.quaternion.multiplyQuaternions(deltaRotationQuaternion,
                    activeFilamentAssemblyObject.quaternion);
                machineAssemblyObject.quaternion.multiplyQuaternions(deltaRotationQuaternion,
                    machineAssemblyObject.quaternion);
                craneArmObject.quaternion.multiplyQuaternions(deltaRotationQuaternion, craneArmObject.quaternion);
                activeHeadObject.quaternion.multiplyQuaternions(deltaRotationQuaternion, activeHeadObject.quaternion);
            }

            previousMousePosition = {
                x: e.offsetX,
                y: e.offsetY
            };
        });

    $(document).on('mouseup', function (e) {
        isDragging = false;
    });

    // shim layer with setTimeout fallback
    window.requestAnimFrame = (function () {
        return window.requestAnimationFrame ||
            window.webkitRequestAnimationFrame ||
            window.mozRequestAnimationFrame ||
            function (callback) {
                window.setTimeout(callback, 1000 / 60);
            };
    })();

    var lastFrameTime = new Date().getTime() / 1000;
    var totalGameTime = 0;
    function update(dt, t) {
        setTimeout(function () {
            var currTime = new Date().getTime() / 1000;
            var dt = currTime - (lastFrameTime || currTime);
            totalGameTime += dt;

            update(dt, totalGameTime);

            lastFrameTime = currTime;
        }, 0);
    }

    update(0, totalGameTime);

    function toRadians(angle) {
        return angle * (Math.PI / 180);
    }

    function toDegrees(angle) {
        return angle * (180 / Math.PI);
    }

</script>

</body>
</html>
