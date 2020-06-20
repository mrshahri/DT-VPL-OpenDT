<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 7/24/2018
  Time: 12:48 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Virtual Factory of CPMC</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <style>
        body {
            font-family: Monospace;
            background-color: #f3ffaa;
            margin: 0px;
            overflow: hidden;
        }

        #info {
            color: #fff;
            position: absolute;
            top: 10px;
            width: 100%;
            text-align: center;
            z-index: 100;
            display: block;
        }

        a {
            color: skyblue
        }

        .button {
            background: #999;
            color: #eee;
            padding: 0.2em 0.5em;
            cursor: pointer
        }

        .highlight {
            background: orange;
            color: #fff;
        }

        span {
            display: inline-block;
            width: 60px;
            float: left;
            text-align: center;
        }
    </style>
</head>
<body>

<script src="<c:url value="/resources/js/three.js"/>"></script>
<script src="<c:url value="/resources/js/GLTFLoader.js"/>"></script>
<script src="<c:url value="/resources/js/Detector.js"/>"></script>
<script src="<c:url value="/resources/js/tween.min.js"/>"></script>
<script src="<c:url value="/resources/js/OrbitControls.js"/>"></script>
<script src="<c:url value="/resources/js/jquery-3.2.1.min.js"/>"></script>

<script>

    var container;
    var camera, controls, scene, renderer;
    var mouseX = 0, mouseY = 0;

    var windowHalfX = window.innerWidth / 2;
    var windowHalfY = window.innerHeight / 2;

    // uarm1 objects
    var bonesUarm1 = {}, uarmMesh1 = [], isUarm1Busy = 0;
    // uarm2 objects
    var bonesUarm2 = {}, uarmMesh2 = [], isUarm2Busy = 0;
    // VF Plane Mesh
    var surfaceMesh = [];
    // Bukito objects
    var bedObject = [], headObject = [], craneArmObject = [];
    // Ultimaker objects
    var ultimakerBed = [], ultimakerExtruder = [], ultimakerX = [], ultimakerY = [], ultimakerBody = [];
    // XCarve objects
    var xcarveBody = [], xcarveArmY = [], xcarveRouterX = [], xcarveRouter = [], xcarveSpindle = [];
    // Rest objects
    var others = [];

    init();
    animate();

    //render();

    function init() {

        container = document.createElement('div');
        container.setAttribute('background-color', '#FFFFFF')
        document.body.appendChild(container);

        // camera
        camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 1, 1000);
        camera.position.x = 100;
        camera.position.y = 100;
        camera.position.z = 100;

        // scene
        scene = new THREE.Scene();
        scene.background = new THREE.Color(0xffffff);
        // scene.fog = new THREE.FogExp2( 0xcccccc, 0.002 );

        // lights
        var light1 = new THREE.DirectionalLight(0xffffff);
        light1.position.set(3, 3, 3);
        var light2 = new THREE.DirectionalLight(0xffffff);
        light2.position.set(-3, 3, 3);
        var light3 = new THREE.DirectionalLight(0xffffff);
        light3.position.set(-3, -3, 3);
        var light4 = new THREE.DirectionalLight(0xffffff);
        light4.position.set(-3, -3, -3);
        var amLight = new THREE.AmbientLight(0xffffff);
        scene.add(light1);
        scene.add(light2);
        scene.add(light3);
        scene.add(light4);
        scene.add(amLight);

        // loading UARM model
        var loader = new THREE.GLTFLoader();
        loader.load('<c:url value="/resources/models/ultimaker/ultimaker.gltf"/>', function (compgltf) {
            compgltf.scene.traverse(function (child) {
                console.log(child.name);
                if (child.isBone) {
                    // setup UARM meshes
                    switch (child.name) {
                        case "uarm1-rotator":
                            bonesUarm1.rotator = child;
                            break;
                        case "uarm1-humerus":
                            bonesUarm1.humerus = child;
                            break;
                        case "uarm1-radius":
                            bonesUarm1.radius = child;
                            break;
                        case "uarm2-rotator":
                            bonesUarm2.rotator = child;
                            break;
                        case "uarm2-humerus":
                            bonesUarm2.humerus = child;
                            break;
                        case "uarm2-radius":
                            bonesUarm2.radius = child;
                            break;
                        default:
                            break;
                    }
                } else {
                    switch (child.name) {
                        // setup UARM meshes
                        // uarm 1
                        case "Uarm metal Assembly.000":
                            if (child.isMesh) {
                                uarmMesh1[0] = child;
                            } else {
                                uarmMesh1 = child.children;
                            }
                            break;
                        // uarm 2
                        case "Uarm metal Assembly.001":
                            if (child.isMesh) {
                                uarmMesh2[0] = child;
                            } else {
                                uarmMesh2 = child.children;
                            }
                            break;
                        // Setup active meshes on Bukito
                        case "bukito-Bed":
                            if (child.isMesh) {
                                bedObject[0] = child;
                            } else {
                                bedObject = child.children;
                            }
                            break;
                        case "bukito-Extruder":
                            if (child.isMesh) {
                                headObject[0] = child;
                            } else {
                                headObject = child.children;
                            }
                            break;
                        case "bukito-Elevator":
                            if (child.isMesh) {
                                craneArmObject[0] = child;
                            } else {
                                craneArmObject = child.children;
                            }
                            break;

                        // Setup active meshes on Ultimaker
                        case "ultimaker-Bed":
                            if (child.isMesh) {
                                ultimakerBed[0] = child;
                            } else {
                                ultimakerBed = child.children;
                            }
                            break;
                        case "ultimaker-Extruder":
                            if (child.isMesh) {
                                ultimakerExtruder[0] = child;
                            } else {
                                ultimakerExtruder = child.children;
                            }
                            break;
                        case "ultimaker-X-axis":
                            if (child.isMesh) {
                                ultimakerX[0] = child;
                            } else {
                                ultimakerX = child.children;
                            }
                            break;
                        case "ultimaker-Y-axis":
                            if (child.isMesh) {
                                ultimakerY[0] = child;
                            } else {
                                ultimakerY = child.children;
                            }
                            break;

                        // Setup active meshes on XCarve
                        case "xcarve-router-Y-Axis":
                            if (child.isMesh) {
                                xcarveArmY[0] = child;
                            } else {
                                xcarveArmY = child.children;
                            }
                            break;
                        case "xcarve-router-X-Axis":
                            if (child.isMesh) {
                                xcarveRouterX[0] = child;
                            } else {
                                xcarveRouterX = child.children;
                            }
                            break;
                        // moves along router-Y-axis
                        case "xcarve-spindle-router":
                            if (child.isMesh) {
                                xcarveRouter[0] = child;
                            } else {
                                xcarveRouter = child.children;
                            }
                            break;
                        // moves along router-Y-axis
                        case "xcarve-spindle":
                            if (child.isMesh) {
                                xcarveSpindle[0] = child;
                            } else {
                                xcarveSpindle = child.children;
                            }
                            break;
                        default:
                            if (child.isMesh) {
                                others.push(child);
                            } else {
                                others.push(child.children);
                            }
                            break;
                    }
                }
            });
            scene.add(compgltf.scene);
        });

        // render all
        renderer = new THREE.WebGLRenderer();
        renderer.setClearColor(0xd3e3e1, 1);
        renderer.setPixelRatio(window.devicePixelRatio);
        renderer.setSize(window.innerWidth, window.innerHeight);
        container.appendChild(renderer.domElement);

        // controls
        controls = new THREE.OrbitControls(camera, renderer.domElement);
        //controls.addEventListener( 'change', render ); // call this only in static scenes (i.e., if there is no animation loop)
        controls.enableDamping = true; // an animation loop is required when either damping or auto-rotation are enabled
        controls.dampingFactor = 0.25;
        controls.screenSpacePanning = false;
        controls.minDistance = 1;
        controls.maxDistance = 100;
        // controls.maxPolarAngle = Math.PI / 2;

        // setInterval(getUarm1Status, 100);
        // setInterval(getUarm2Status, 100);
        // setInterval(getBukitoState, 200);
        setInterval(getUltimaker2State, 200);
        // setInterval(getXCarveState, 200);

        // TEST
        // setInterval(function () {
        //     forwardAnim(bonesUarm1);
        // }, 20000);
        // setInterval(testMovement, 5000);

        document.addEventListener('mousemove', onDocumentMouseMove, false);
        window.addEventListener('resize', onWindowResize, false);
    }


    /*
        // test
        var testBool = false;
        var testMinOffset = 0;
        var testMaxOffset = -0.075;
        var testObj = null;
        var testCounter = testMinOffset;

        function testMovement() {
            moveHead(0, testCounter);
            if (testCounter === testMinOffset) {
                testCounter = testMaxOffset;
            } else {
                testCounter = testMinOffset;
            }
        }

        function testMovement() {
            if (testBool === false) {
                animateXCarve(650, 450, 10);
                testBool = true;
            } else {
                animateXCarve(0, 0, 0);
                testBool = false;
            }
            /!*
            if (testObj != null) {
                if (testBool === true) {
                    for (var i = 0; i < testObj.length; i++) {
                        new TWEEN.Tween(testObj[i].position).to({y: testMaxOffset}, 500).start();
                    }
                    testBool = false;
                } else {
                    for (var i = 0; i < testObj.length; i++) {
                        new TWEEN.Tween(testObj[i].position).to({y: testMinOffset}, 500).start();
                    }
                    testBool = true;
                }
            }*!/
        }
    */

    function getBukitoState() {
        getMachineAxisCoordinateState("bukito");
    }

    function getUltimaker2State() {
        getMachineAxisCoordinateState("Ultimaker01");
    }

    function getXCarveState() {
        getMachineAxisCoordinateState("CNC");
    }

    // FIXME: Object co-ordinates and movements scale
    function getMachineAxisCoordinateState(machineId) {
        $.getJSON("${monitorUrl}", {deviceId: machineId})
            .done(function (data) {
                switch (machineId) {
                    case "bukito":
                        animateBukito(data.xPosition, data.yPosition, data.zPosition);
                        break;
                    case "Ultimaker01":
                        animateUltimaker2(data.xPosition, data.yPosition, data.zPosition);
                        break;
                    case "CNC":
                        animateXCarve(data.xPosition, data.yPosition, data.zPosition);
                        break;
                    default:
                        break;
                }
            });
    }

    // Animating Bukito
    function animateBukito(dataX, dataY, dataZ) {
        // Info: Bukito build volume = 125 (bed) * 150 (crane) * 125 (head or extruder)
        // bed co ordinate on x axes (+/-)
        var x = dataX / 1250;
        // crane
        var y = dataZ / 1500;
        // head - along with crane
        var z = -dataZ / 1250;
        console.log("Bukito: " + "x=" + z + ", y=" + y + ", z=" + z);
        if (isNaN(x) || isNaN(y) || isNaN(z)) {
            x = 0;
            y = 0;
            z = 0;
            // alert("Garbage Value Returned from Machines")
        }

        // animate objects
        moveBed(x);
        moveCraneArm(y);
        moveExtruder(y, z);
    }

    function moveBed(x) {
        for (var i = 0; i < bedObject.length; i++) {
            new TWEEN.Tween(bedObject[i].position).to({x: x}, 500).start();
        }
    }

    function moveCraneArm(y) {
        for (var i = 0; i < craneArmObject.length; i++) {
            new TWEEN.Tween(craneArmObject[i].position).to({y: y}, 500).start();
        }
    }

    function moveExtruder(y, z) {
        for (var i = 0; i < headObject.length; i++) {
            new TWEEN.Tween(headObject[i].position).to({y: y, z: z}, 500).start();
        }
    }

    /**
     * Animating Ultimaker
     * Measurements:
     * ultimaker x (X Rod in JS Code):
     *      min = 0;
     *      max = -0.22
     * ultimaker y (Y Rod in JS code):
     *      min = 0;
     *      max = 0.22
     * ultimaker z (bed):
     *      min = 0;
     *      max = 0.22;
     * Note from Sunny: Ultimaker : x - 230, y - 225, z - 205; y and z normal values are -ve
     */
    function animateUltimaker2(dataX, dataY, dataZ) {
        // xArm
        var x = -Math.abs(dataX / 1000);
        // yArm
        var y = Math.abs(dataY / 1000);
        // bed
        var z;
        if (dataZ <= 0.00) {
            z = 0;
        } else {
            z = 0.22 - dataZ / 50;
        }
        console.log("Ultimaker: " + "x=" + x + ", y=" + y + ", z=" + z);
        if (isNaN(x) || isNaN(y) || isNaN(z)) {
            x = 0;
            y = 0;
            z = 0;
            // alert("Garbage Value Returned from Machines")
        }

        moveUltimaker2Bed(z);
        moveUltimaker2Extruder(x, y);
        moveUltimaker2X(x);
        moveUltimaker2Y(y);
    }

    function moveUltimaker2Bed(z) {
        for (var i = 0; i < ultimakerBed.length; i++) {
            new TWEEN.Tween(ultimakerBed[i].position).to({z: z}, 1000).start();
        }
    }

    function moveUltimaker2X(x) {
        for (var i = 0; i < ultimakerX.length; i++) {
            new TWEEN.Tween(ultimakerX[i].position).to({x: x}, 500).start();
        }
    }

    function moveUltimaker2Y(y) {
        for (var i = 0; i < ultimakerY.length; i++) {
            new TWEEN.Tween(ultimakerY[i].position).to({y: y}, 500).start();
        }
    }

    function moveUltimaker2Extruder(x, y) {
        for (var i = 0; i < ultimakerExtruder.length; i++) {
            new TWEEN.Tween(ultimakerExtruder[i].position).to({x: x, y: y}, 500).start();
        }
    }

    /**
     * Animating XCarve
     * Xcarve x(Arm X):
     *      min = 0;
     *      max = 0.3;
     * Xcarve y (Router + Spindle):
     *      min = 0;
     *      min = -0.075;
     * Xcarve z (Arm Y):
     *      min = 0;
     *      max = -0.3;
     * Note from Sunny: X-carve: x - 750, y - 750, z - 70;
     * z-axis normal value is -ve, niche namle -ve, upore uthle +ve
     * @param dataX
     * @param dataY
     * @param dataZ
     */
    function animateXCarve(dataX, dataY, dataZ) {
        // X + Router + Spindle = Physical XCarve X
        var x = dataX / 2500;
        // Arm = Physical XCarve Y
        var y = -dataY / 2500;
        // Router + Spindle (While operating) = Physical XCarve Z
        var z = -Math.abs(dataZ / 200);
        console.log("XCarve: " + "x=" + x + ", y=" + y + ", z=" + z);
        if (isNaN(x) || isNaN(y) || isNaN(z)) {
            x = 0;
            y = 0;
            z = 0;
            // alert("Garbage Value Returned from Machines")
            return;
        }

        moveXCarveYArm(y);
        moveXCarveRouterX(x);
        moveXCarveSpindle(z);
    }

    function moveXCarveYArm(y) {
        // Moving Y-arm
        for (var i = 0; i < xcarveArmY.length; i++) {
            new TWEEN.Tween(xcarveArmY[i].position).to({z: y}, 250).start();
        }
        // Move router X attached to Y-arm
        for (var i = 0; i < xcarveRouterX.length; i++) {
            new TWEEN.Tween(xcarveRouterX[i].position).to({z: y}, 250).start();
        }
        // move Router attached to the Y Axis
        for (var i = 0; i < xcarveRouter.length; i++) {
            new TWEEN.Tween(xcarveRouter[i].position).to({z: y}, 250).start();
        }

        // move Spindle attached to the Router
        // for (var i = 0; i < xcarveSpindle.length; i++) {
        //     new TWEEN.Tween(xcarveSpindle[i].position).to({z: y}, 500).start();
        // }
    }

    function moveXCarveRouterX(x) {
        // Move router Y
        for (var i = 0; i < xcarveRouterX.length; i++) {
            new TWEEN.Tween(xcarveRouterX[i].position).to({x: x}, 500).start();
        }

        // move Router attached to the Y Axis
        for (var i = 0; i < xcarveRouter.length; i++) {
            new TWEEN.Tween(xcarveRouter[i].position).to({x: x}, 500).start();
        }

        // move Spindle attached to the Router
        // for (var i = 0; i < xcarveSpindle.length; i++) {
        //     new TWEEN.Tween(xcarveSpindle[i].position).to({x: x}, 500).start();
        // }
    }

    function moveXCarveSpindle(z) {
        // first move the Router
        for (var i = 0; i < xcarveRouter.length; i++) {
            new TWEEN.Tween(xcarveRouter[i].position).to({y: z}, 500).start();
        }
        // Then move the Spindle attached to the Router
        // for (var i = 0; i < xcarveSpindle.length; i++) {
        //     new TWEEN.Tween(xcarveSpindle[i].position).to({y: z}, 500).start();
        // }
        // FIXME: Also needs to rotate when needed
    }

    function getUarm1Status() {
        getRobotState("Uarm");
    }

    function getUarm2Status() {
        getRobotState("Uarm1");
    }

    function getRobotState(robotId) {
        $.getJSON("${monitorUrl}", {deviceId: robotId}, function () {
        })
            .done(function (data) {
                var status = data.availability;
                if (robotId === 'Uarm') {
                    if (status === 'BUSY' && 0 === isUarm1Busy) {
                        forwardAnim(bonesUarm1);
                        isUarm1Busy = 1;
                    } else if (status === 'AVAILABLE' && 1 === isUarm1Busy) {
                        isUarm1Busy = 0;
                    }
                } else if (robotId === 'Uarm1') {
                    if (status.toUpperCase() === 'BUSY' && 0 === isUarm2Busy) {
                        forwardAnim(bonesUarm2);
                        isUarm2Busy = 1;
                    } else if (status.toUpperCase() === 'AVAILABLE' && 1 === isUarm2Busy) {
                        isUarm2Busy = 0;
                    }
                } else {

                }
            }).fail(function () {
        }).always(function () {
        });
    }

    function forwardAnim(armature) {

        if (typeof armature.rotator !== 'undefined') {
            new TWEEN.Tween(armature.rotator.rotation)
                .to({y: Math.PI / 2}, 1000)
                .onComplete(function () {
                    new TWEEN.Tween(armature.radius.rotation)
                        .to({y: Math.PI / 12}, 1000)
                        .onComplete(function () {
                            new TWEEN.Tween(armature.humerus.rotation)
                                .to({z: 1.25 * Math.PI}, 1000)
                                // State: Object picked up
                                .onComplete(function () {
                                    new TWEEN.Tween(armature.radius.rotation)
                                        .to({y: Math.PI / 6}, 1000)
                                        .onComplete(function () {
                                            // State: Start moving the object
                                            setTimeout(function () {
                                                backwardAnim(armature);
                                            }, 1000);
                                        })
                                        .start();
                                })
                                .start();
                        })
                        .start();
                })
                .start();
        }
    }

    function backwardAnim(armature) {
        new TWEEN.Tween(armature.rotator.rotation)
            .to({y: -Math.PI/2}, 1000)
            .onComplete(function () {
                new TWEEN.Tween(armature.radius.rotation)
                    .to({y: Math.PI/12}, 1000)
                    .onComplete(function () {
                        new TWEEN.Tween(armature.radius.rotation)
                            .to({y: Math.PI/6}, 1000)
                            .onComplete(function () {
                                setTimeout(function () {
                                    resetAnim(armature);
                                }, 1000);
                            })
                            .start();
                    })
                    .start();
            })
            .start();
    }
    /*
        function backwardAnim(armature) {
            new TWEEN.Tween(armature.rotator.rotation)
                .to({y: 0}, 1000)
                .onComplete(function () {
                    new TWEEN.Tween(armature.radius.rotation)
                        .to({y: Math.PI / 180}, 1000)
                        .onComplete(function () {
                            new TWEEN.Tween(armature.radius.rotation)
                                .to({y: Math.PI / 6}, 1000)
                                .onComplete(function () {
                                    setTimeout(function () {
                                        resetAnim(armature);
                                    }, 1000);
                                })
                                .start();
                        })
                        .start();
                })
                .start();
        }
    */

    function resetAnim(armature) {
        new TWEEN.Tween(armature.rotator.rotation)
            .to({y: Math.PI / 45}, 1000)
            .onComplete(function () {
                new TWEEN.Tween(armature.humerus.rotation)
                    .to({z: Math.PI}, 200)
                    .onComplete(function () {
                        new TWEEN.Tween(armature.radius.rotation)
                            .to({y: -Math.PI / 3}, 1000)
                            .onComplete(function () {
                            })
                            .start();
                    })
                    .start();
            })
            .start();
    }

    function onWindowResize() {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    }

    function onDocumentMouseMove(event) {
        mouseX = (event.clientX - windowHalfX) / 2;
        mouseY = (event.clientY - windowHalfY) / 2;
    }

    function animate() {
        requestAnimationFrame(animate);
        render();
        controls.update();
        TWEEN.update();
    }

    function render() {
        camera.lookAt(scene.position);
        renderer.render(scene, camera);
    }
</script>

</body>
</html>