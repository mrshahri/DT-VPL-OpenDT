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
    <title>UARM Digital-Twin</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <style>
        body {
            font-family: Monospace;
            background-color: #000000;
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
<script src="<c:url value="/resources/js/DDSLoader.js"/>"></script>
<script src="<c:url value="/resources/js/MTLLoader.js"/>"></script>
<script src="<c:url value="/resources/js/OBJLoader.js"/>"></script>

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
    var initBonesStates = {};
    var mesh;
    var isBusy = 0;

    // bukito objects
    var bedObject = {}, headObject = {}, craneArmObject = {}, machineAssemblyObject = {};

    init();
    animate();

    //render();

    function init() {

        container = document.createElement('div');
        document.body.appendChild(container);

        // camera
        camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 1, 200);
        camera.position.x = 100;
        camera.position.y = 0;
        camera.position.z = 0;

        // scene
        scene = new THREE.Scene();
        scene.background = new THREE.Color(0xcccccc);
        // scene.fog = new THREE.FogExp2( 0xcccccc, 0.002 );

        // lights
        var light = new THREE.DirectionalLight(0xffffff);
        light.position.set(1, 1, 1);
        scene.add(light);
        var light = new THREE.DirectionalLight(0xffffff);
        light.position.set(-1, -1, -1);
        scene.add(light);
        var light = new THREE.AmbientLight(0x222222);
        scene.add(light);

        // loading UARM model
        var loader = new THREE.GLTFLoader();
        loader.load('<c:url value="/resources/models/uarm/uarm-single-assembly.gltf"/>', function (uarmgltf) {
            uarmgltf.scene.traverse(function (child) {
                if (child.isBone) {
                    switch (child.name) {
                        case "Armature_rotator":
                            bones.rotator = child;
                            break;
                        case "Armature_humerus":
                            bones.humerus = child;
                            break;
                        case "Armature_radius":
                            bones.radius = child;
                            break;
                        default:
                            break;
                    }
                } else if (child.isSkinnedMesh) {
                    mesh = child;
                }
            });

            // store init state of bones
            initBonesStates = Object.assign({}, bones);
            console.log(initBonesStates);

            scene.add(uarmgltf.scene);

            // loading Bukito model
            loader.load('<c:url value="/resources/models/bukito/machine-assembly.gltf"/>', function (mgltf) {
                machineAssemblyObject = mgltf;
                scene.add(mgltf.scene);

                loader.load('<c:url value="/resources/models/bukito/bed-assembly.gltf"/>', function (bgltf) {
                    bedObject = bgltf;
                    scene.add(bgltf.scene);

                    loader.load('<c:url value="/resources/models/bukito/crane-arm-assembly.gltf"/>', function (cagltf) {
                        craneArmObject = cagltf;
                        scene.add(cagltf.scene);

                        loader.load('<c:url value="/resources/models/bukito/hotend-carriage-assembly.gltf"/>', function (hegltf) {
                            headObject = hegltf;
                            scene.add(hegltf.scene);
                        });
                    });
                });
            });
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
        setInterval(getPrinterState, 100);
        // setInterval(forwardAnim, 20000);

        document.addEventListener('mousemove', onDocumentMouseMove, false);
        window.addEventListener('resize', onWindowResize, false);
    }

    // FIXME: Object co-ordinates and movements scale
    function getPrinterState() {
        $.getJSON("${monitorUrl}", {deviceId: "bukito"})
            .done(function (data) {
                // bed co ordinate on x axes (+/-)
                var x = -data.yPosition / 600;
                // crane
                var y = data.xPosition / 400;
                // nozzle - along with crane
                var z = data.zPosition / 300;
                console.log("x=" + x + ", y=" + y + ", z=" + z);
                moveBed(x);
                moveCrane(y);
                moveHead(z);
            });
    }

    function moveBed(x) {
        new TWEEN.Tween(bedObject.position).to({x: x, y:0.0, z:0.0}, 500).start();
    }

    function moveCrane(y) {
        new TWEEN.Tween(craneArmObject.position).to({x:0.0, y:y, z:0.0}, 500).start();
    }

    function moveHead(z) {
        new TWEEN.Tween(activeHeadObject.position).to({x:0.0, y:0.0, z:z}, 500).start();
    }

    function getRobotState() {
        $.getJSON("${monitorUrl}", {deviceId: "Uarm"}, function () {
            console.log("success");
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
                .to({y: -Math.PI / 2}, 1000)
                .onComplete(function () {
                    new TWEEN.Tween(bones.radius.rotation)
                        .to({y: Math.PI / 12}, 1000)
                        .onComplete(function () {
                            new TWEEN.Tween(bones.humerus.rotation)
                                .to({z: 1.25 * Math.PI}, 1000)
                                .onComplete(function () {
                                    new TWEEN.Tween(bones.radius.rotation)
                                        .to({y: Math.PI / 6}, 1000)
                                        .onComplete(function () {
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
            .to({y: Math.PI / 2}, 1000)
            .onComplete(function () {
                new TWEEN.Tween(bones.radius.rotation)
                    .to({y: Math.PI / 12}, 1000)
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