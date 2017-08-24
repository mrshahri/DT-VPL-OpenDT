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
    <title>Monitor Ultimaker 3D</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
    <style>
        #rcorners1 {
            border-radius: 25px;
            border: 2px solid darkblue;
            background: wheat;
            padding: 20px;
            width: auto;
            height: 400px;
        }

        #rcorners2 {
            border-radius: 25px;
            border: 2px solid darkblue;
            padding: 20px;
            width: auto;
            height: 200px;
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
            border-radius: 25px;
            border: 2px solid darkblue;
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

        tr:hover{background-color:#f5f5f5}
    </style>

    <script>
        function diagnosNetwork() {
            var code = document.getElementById("code");
            var level = document.getElementById("level");
            var cause = document.getElementById("cause");
            $.ajax({
                url: "http://10.5.55.7:10090/ping",
                dataType: "text",
                success: function (data) {
                },
                complete: function (data) {
                    console.log(data.responseText);
                    if (data.responseText === "C1") {
                        code.innerHTML = data.responseText;
                        level.innerHTML = "WARNING";
                        cause.innerHTML = "Adapter may not responding";
                    } else if (data.responseText === "C2") {
                        code.innerHTML = data.responseText;
                        level.innerHTML = "ERROR";
                        cause.innerHTML = "Machine not available";
                    } else if (data.responseText === "NONE") {
                        code.innerHTML = "N/A";
                        level.innerHTML = "N/A";
                        cause.innerHTML = "N/A";
                    }
                },
                timeout: 12000  // two minutes
            });
        }
    </script>
</head>

<body>
<div class="flex-container">
    <header>
        <h1>Ultimaker 3D Monitor and Diagnosis</h1>
    </header>

    <%--
        <nav class="nav">
        </nav>
    --%>

    <article class="article" id="article"></article>

    <aside class="article">
        <div id="rcorners2">
            <table>
                <tr>
                    <th>Operations</th>
                </tr>
                <tr>
                    <td>
                        <input type="button" class="btn btn-success" value="Print Clip Model File" onclick="startPrinting('Clip')">
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" class="btn btn-success" value="Print Platform Model File" onclick="startPrinting('platform')">
                    </td>
                </tr>
            </table>
            <br/>
        </div>
        <br>
        <div id="rcorners1">
            <h4 style="text-align: center">Diagnostics</h4>
            <p style="text-align: center">[GREEN = OK, YELLOW = WARNING, and RED = ERROR]</p>
            <div id="diagnosticCheckLight" style="text-align: center; width: auto; height: 75px;
                        background-color: green; border: 3px; border-color: black;
                                                border-radius: 25px"></div>
            <br/>
            <br/>
            <div style="text-align: center">
                <input type="button" class="btn btn-warning" value="Diagnose Network" onclick="diagnosNetwork()">
            </div>
            <br>
            <br>
            <div>
                <table>
                    <tr>
                        <th>Code</th>
                        <th>Level</th>
                        <th>Cause</th>
                    </tr>
                    <tr>
                        <td><p id="code"></p></td>
                        <td><p id="level"></p></td>
                        <td><p id="cause"></p></td>
                    </tr>
                </table>
            </div>
        </div>
    </aside>

    <footer>Copyright &copy; University of Arkansas</footer>
</div>


<script src="<c:url value="/resources/js/three.js"/>"></script>

<script src="<c:url value="/resources/js/DDSLoader.js"/>"></script>
<script src="<c:url value="/resources/js/MTLLoader.js"/>"></script>
<script src="<c:url value="/resources/js/OBJLoader.js"/>"></script>

<script src="<c:url value="/resources/js/Detector.js"/>"></script>
<script src="<c:url value="/resources/js/stats.min.js"/>"></script>
<script src="<c:url value="/resources/js/tween.min.js"/>"></script>

<script src="<c:url value="/resources/js/jquery-3.2.1.min.js"/>"></script>

<script>

    var container, stats;
    var bedObject, headObject, craneArmObject, machineAssemblyObject;
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

//        container = document.createElement('div');
//        document.body.appendChild(container);
        container = document.getElementById('article');

        camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 0.1, 2000);
        camera.position.z = 0.5;

        // scene
        scene = new THREE.Scene();

        var ambient = new THREE.AmbientLight(0x444444);
        //var ambient = new THREE.AmbientLight( 0xffffff );
        scene.add(ambient);

        var directionalLight = new THREE.DirectionalLight(0xffeedd);
        //var directionalLight = new THREE.DirectionalLight( 0xffffff );
        directionalLight.position.set(0, 0, 1).normalize();
        scene.add(directionalLight);

        // model
        var onProgress = function (xhr) {
            if (xhr.lengthComputable) {
                var percentComplete = xhr.loaded / xhr.total * 100;
                //console.log(Math.round(percentComplete, 2) + '% downloaded');
            }
        };

        var onError = function (xhr) {
        };

        THREE.Loader.Handlers.add(/\.dds$/i, new THREE.DDSLoader());

        var mtlLoader = new THREE.MTLLoader();

        // loading machine assmbly
        mtlLoader.load('<c:url value="/resources/models/machine_assembly.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            //objLoader.setPath( 'obj/male02/' );
            objLoader.load('<c:url value="/resources/models/machine_assembly.obj"/>', function (object) {
                object.position.x = 0.1;
                object.position.z = -0.1;
                machineAssemblyObject = object;

                scene.add(object);
            }, onProgress, onError);
        });

        // loading bed
        mtlLoader.load('<c:url value="/resources/models/bed_assembly.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            //objLoader.setPath( 'obj/male02/' );
            objLoader.load('<c:url value="/resources/models/bed_assembly.obj"/>', function (object) {
//                object.position.y = 0.1;
                object.position.y = 0.1;
                object.position.z = 0.1;
                bedObject = object;

                scene.add(object);
            }, onProgress, onError);
        });

        // loading crane arm assmbly
        mtlLoader.load('<c:url value="/resources/models/crane_arm_assembly.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            //objLoader.setPath( 'obj/male02/' );
            objLoader.load('<c:url value="/resources/models/crane_arm_assembly.obj"/>', function (object) {
                object.position.x = 0.15;
                object.position.y = 0.2;
                object.position.z = -0.15;

                var quaternion = new THREE.Quaternion();
                quaternion.setFromAxisAngle(new THREE.Vector3(-1, 0, 0), Math.PI / 2);
                object.applyQuaternion(quaternion);
                craneArmObject = object;

                scene.add(object);
            }, onProgress, onError);
        });


        // loading crane arm assmbly
        mtlLoader.load('<c:url value="/resources/models/hotend_carriage.mtl"/>', function (materials) {

            materials.preload();

            var objLoader = new THREE.OBJLoader();
            objLoader.setMaterials(materials);
            //objLoader.setPath( 'obj/male02/' );
            objLoader.load('<c:url value="/resources/models/hotend_carriage.obj"/>', function (object) {
                object.position.x = 0.1;
                object.position.y = 0.2;
                object.position.z = -0.15;

                var quaternion = new THREE.Quaternion();
                quaternion.setFromAxisAngle(new THREE.Vector3(0, 1, 0), Math.PI / 2);
                object.applyQuaternion(quaternion);
                headObject = object;

                scene.add(object);
            }, onProgress, onError);
        });

        // render all
        renderer = new THREE.WebGLRenderer();
        renderer.setClearColor(0xd3e3e1, 1);
        renderer.setPixelRatio(window.devicePixelRatio);
        renderer.setSize(window.innerWidth / 1.75, window.innerHeight / 1.75);
        container.appendChild(renderer.domElement);

        document.addEventListener('mousemove', onDocumentMouseMove, false);

        //
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

    //
    function animate() {
        requestAnimationFrame(animate);
        render();
        TWEEN.update();
    }

    function render() {
        //camera.position.x += ( mouseX - camera.position.x ) * .1;
        //camera.position.y += ( - mouseY - camera.position.y ) * .1;
        camera.position.x = -1;
        camera.position.y = 1;

        camera.lookAt(scene.position);

        renderer.render(scene, camera);
    }

    function moveHead(xv) {
        var x = 0.05 + 0.0015 * xv;
        var y = 0.2 - 0.0006 * xv;
        var z = -0.15 - 0.004 * xv;
        new TWEEN.Tween(headObject.position)
            .to({x: x, y: y, z: z}, 100).start();
    }

    function moveCrane(y) {
        var x = 0.15 - 0.0018 * y;
        new TWEEN.Tween(craneArmObject.position)
            .to({x: x}, 100).start();
    }

    function moveBed(z) {
        var y = 0.13 + 0.001 * z;
        if (bedObject.position.y !== y) {
            new TWEEN.Tween(bedObject.position)
                .to({y: y}, 100).start();
        }
    }

    function reset() {
//        headObject.position.x = 0.1;
//        headObject.position.y = 0.2;
//        headObject.position.z = -0.15;
        new TWEEN.Tween(headObject.position)
            .to({x: 0.1, y: 0.2, z: -0.15}, 2000).start();

//        craneArmObject.position.x = 0.15;
        new TWEEN.Tween(craneArmObject.position)
            .to({x: 0.12}, 1000).start();

//        bedObject.position.y = 0.1;
        new TWEEN.Tween(bedObject.position)
            .to({y: 0.1}, 1000).start();
    }

    function getHeadPosition() {
        $.getJSON("${monitorUrl}", {deviceId: "Ultimaker01"})
            .done(function (data) {
                var x = -data.yPosition / 2;
                var y = data.xPosition / 2;
                var z = -data.zPosition * 70;
                console.log("x=" + x + " | y=" + y + " | z=" + z);

                if (x === 0 && y === 0 && z === 0) {
                    reset();
                } else {
                    // HACK
                    if (x === 50) {
//                        headObject.position.x = 0.1;
//                        headObject.position.y = 0.15;
//                        headObject.position.z = -0.15;
                        new TWEEN.Tween(headObject.position)
                            .to({x: 0.025, y: 0.2, z: 0.05}, 1000).start();
                    } else {
                        moveHead(x);
                    }

                    moveCrane(y);
                    moveBed(z);
                }
            });
    }

    // code for timer
    window.setInterval(getHeadPosition, 25);

    function startPrinting(name) {
        var parametersObj = {deviceId: "Ultimaker01", operationId: "startJob", parameters: []};
        var parameters = [];
        parameters.push({id: "material", name: "", type: "value", value: "PLA"})
        parameters.push({id: "quantity", name: "", type: "value", value: "1"})
        parameters.push({id: "objName", name: "", type: "value", value: name})
        parametersObj.parameters = parameters;
        var requestBody = JSON.stringify(parametersObj);
        $.ajax({
            type: 'POST',
            url: "${postUrl}",
            data: requestBody,
            success: function (data) {
                alert('data: ' + data);
            },
            contentType: "application/json",
            dataType: 'json'
        });
    }

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
                machineAssemblyObject.quaternion.multiplyQuaternions(deltaRotationQuaternion, machineAssemblyObject.quaternion);
                craneArmObject.quaternion.multiplyQuaternions(deltaRotationQuaternion, craneArmObject.quaternion);
                headObject.quaternion.multiplyQuaternions(deltaRotationQuaternion, headObject.quaternion);
            }

            previousMousePosition = {
                x: e.offsetX,
                y: e.offsetY
            };
        });
    /* */

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
        //console.log(dt, t);

        //camera.position.z += 1 * dt;
        //wireframe.rotation.x += 1 * dt;
        //wireframe.rotation.y += 1 * dt;

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

    function diagnosisCheck() {
        var div = document.getElementById("diagnosticCheckLight");
        $.ajax({
            url: "http://10.5.54.23:8100/app-diagnostics-center/",
            dataType: "text",
            success: function (data) {
            },
            complete: function (data) {
                if (data.responseText === 'WARNING') {
                    div.style.backgroundColor = "yellow";
                } else if (data.responseText === 'ERROR') {
                    div.style.backgroundColor = "red";
                } else {
                    div.style.backgroundColor = "green";
                }
            }
        });
    }
    window.setInterval(diagnosisCheck, 1000);

</script>

</body>
</html>
