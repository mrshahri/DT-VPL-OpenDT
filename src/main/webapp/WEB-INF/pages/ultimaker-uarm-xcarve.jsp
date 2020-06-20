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
    <title>VPL: Ultimaker-UARM-XCarve</title>
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

    // uarm objects
    var bones = {};
    var isBusy = 0;

    // bukito objects
    var bedObject = [], headObject = [], craneArmObject = [], surfaceMesh = [], uarmMesh = [];

    init();
    animate();

    //render();

    function init() {

        container = document.createElement('div');
        container.setAttribute('background-color', '#FFFFFF')
        document.body.appendChild(container);

        // camera
        camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 1, 300);
        camera.position.x = 500;
        camera.position.y = 0;
        camera.position.z = 0;

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
        loader.load('<c:url value="/resources/models/ultimaker-uarm-xcarve/composite-ultimaker-uarm-xcarve.gltf"/>', function (compgltf) {
            compgltf.scene.traverse(function (child) {
                console.log(child.name);
                if (child.isBone) {
                    switch (child.name) {
                        case "rotator":
                            bones.rotator = child;
                            break;
                        case "humerus":
                            bones.humerus = child;
                            break;
                        case "radius":
                            bones.radius = child;
                            break;
                        default:
                            break;
                    }
                } else {
                    switch (child.name) {
                        case "Bed":
                            if (child.isMesh) {
                                bedObject[0] = child;
                            } else {
                                bedObject = child.children;
                            }
                            break;
                        case "Extruder":
                            if (child.isMesh) {
                                headObject[0] = child;
                            } else {
                                headObject = child.children;
                            }
                            break;
                        case "Elevator":
                            if (child.isMesh) {
                                craneArmObject[0] = child;
                            } else {
                                craneArmObject = child.children;
                            }
                            break;
                        case "Plane":
                            if (child.isMesh) {
                                surfaceMesh[0] = child;
                            } else {
                                surfaceMesh = child.children;
                            }
                            break;
                        case "UARMAssembly":
                            if (child.isMesh) {
                                uarmMesh[0] = child;
                            } else {
                                uarmMesh = child.children;
                            }
                            break;
                        default:
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
        controls.maxDistance = 20;
        // controls.maxPolarAngle = Math.PI / 2;

        setInterval(getRobotState, 100);
        setInterval(getPrinterState, 200);

        // for test purpose
        // setInterval(forwardAnim, 20000);
        // setInterval(testMovement, 5000);

        document.addEventListener('mousemove', onDocumentMouseMove, false);
        window.addEventListener('resize', onWindowResize, false);
    }

    // FIXME: Object co-ordinates and movements scale
    function getPrinterState() {
        $.getJSON("${monitorUrl}", {deviceId: "bukito"})
            .done(function (data) {

                // Info: Bukito build volume = 125 (bed) * 150 (crane) * 125 (head or extruder)
                // bed co ordinate on x axes (+/-)
                var x = data.xPosition / 1250;
                // crane
                var y = data.zPosition / 1500;
                // head - along with crane
                var z = - data.yPosition / 1250;
                console.log("x=" + z + ", y=" + y + ", z=" + z);

                // animate objects
                moveBed(x);
                moveCrane(y);
                moveHead(y, z);
            });
    }

    // test
    var testBool = false;
    var testMinOffset = 0;
    var testMaxOffset = -0.1;
    var testCounter = testMinOffset;

    function testMovement() {
        moveHead(0, testCounter);
        if (testCounter === testMinOffset) {
            testCounter = testMaxOffset;
        } else {
            testCounter = testMinOffset;
        }
    }

    function moveBed(x) {
        for (var i = 0; i < bedObject.length; i++) {
            new TWEEN.Tween(bedObject[i].position).to({x: x}, 500).start();
        }
    }

    function moveCrane(y) {
        for (var i = 0; i < craneArmObject.length; i++) {
            new TWEEN.Tween(craneArmObject[i].position).to({y: y}, 500).start();
        }
    }

    function moveHead(y, z) {
        for (var i = 0; i < headObject.length; i++) {
            new TWEEN.Tween(headObject[i].position).to({y: y, z: z}, 500).start();
        }
    }

    function getRobotState() {
        $.getJSON("${monitorUrl}", {deviceId: "Uarm"}, function () {
        })
            .done(function (data) {
                var status = data.availability;
                if (status === 'BUSY' && 0 === isBusy) {
                    forwardAnim();
                    isBusy = 1;
                } else if (status === 'AVAILABLE' && 1 === isBusy) {
                    isBusy = 0;
                }
            }).fail(function () {
        }).always(function () {
        });
    }

    function forwardAnim() {

        if (typeof bones.rotator !== 'undefined') {
            new TWEEN.Tween(bones.rotator.rotation)
                .to({y: Math.PI / 2}, 1000)
                .onComplete(function () {
                    new TWEEN.Tween(bones.radius.rotation)
                        .to({y: Math.PI / 15}, 1000)
                        .onComplete(function () {
                            new TWEEN.Tween(bones.humerus.rotation)
                                .to({z: 1.2 * Math.PI}, 1000)
                                // State: Object picked up
                                .onComplete(function () {
                                    new TWEEN.Tween(bones.radius.rotation)
                                        .to({y: Math.PI / 6}, 1000)
                                        .onComplete(function () {
                                            // State: Start moving the object
                                            setTimeout(backwardAnim, 1000);
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

    function backwardAnim() {
        new TWEEN.Tween(bones.rotator.rotation)
            .to({y: 0}, 1000)
            .onComplete(function () {
                new TWEEN.Tween(bones.radius.rotation)
                    .to({y: Math.PI / 180}, 1000)
                    .onComplete(function () {
                        new TWEEN.Tween(bones.radius.rotation)
                            .to({y: Math.PI / 6}, 1000)
                            .onComplete(function () {
                                setTimeout(resetAnim, 1000);
                            })
                            .start();
                    })
                    .start();
            })
            .start();
    }

    function resetAnim() {
        new TWEEN.Tween(bones.rotator.rotation)
            .to({y: Math.PI / 45}, 1000)
            .onComplete(function () {
                new TWEEN.Tween(bones.humerus.rotation)
                    .to({z: Math.PI}, 200)
                    .onComplete(function () {
                        new TWEEN.Tween(bones.radius.rotation)
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