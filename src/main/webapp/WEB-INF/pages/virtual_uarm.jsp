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
            display:block;
        }
        a { color: skyblue }
        .button { background:#999; color:#eee; padding:0.2em 0.5em; cursor:pointer }
        .highlight { background:orange; color:#fff; }
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

    var bones = {};
    var initBonesStates = {};
    var mesh;
    var flag = 1;

    init();
    animate();
    //render();

    function init() {

        container = document.createElement( 'div' );
        document.body.appendChild( container );

        // camera
        camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 1, 200);
        camera.position.x = 30;
        camera.position.y = 0;
        camera.position.z = 0;

        // scene
        scene = new THREE.Scene();
        scene.background = new THREE.Color( 0xcccccc );
        // scene.fog = new THREE.FogExp2( 0xcccccc, 0.002 );

        // lights
        var light = new THREE.DirectionalLight( 0xffffff );
        light.position.set( 1, 1, 1 );
        scene.add( light );
        var light = new THREE.DirectionalLight( 0xffffff );
        light.position.set( -1, -1, -1 );
        scene.add( light );
        var light = new THREE.AmbientLight( 0x222222 );
        scene.add( light );

        // model
        var loader = new THREE.GLTFLoader();
        loader.load( '<c:url value="/resources/models/uarm/uarm-single-assembly.gltf"/>', function ( gltf ) {
            gltf.scene.traverse( function ( child ) {
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
            } );

            // store init state of bones
            initBonesStates = Object.assign({}, bones);
            console.log(initBonesStates);

            scene.add( gltf.scene );
        } );


        // render all
        renderer = new THREE.WebGLRenderer();
        renderer.setClearColor(0xd3e3e1, 1);
        renderer.setPixelRatio(window.devicePixelRatio);
        renderer.setSize(window.innerWidth, window.innerHeight);
        container.appendChild(renderer.domElement);

        // controls
        controls = new THREE.OrbitControls( camera, renderer.domElement );
        //controls.addEventListener( 'change', render ); // call this only in static scenes (i.e., if there is no animation loop)
        controls.enableDamping = true; // an animation loop is required when either damping or auto-rotation are enabled
        controls.dampingFactor = 0.25;
        controls.screenSpacePanning = false;
        controls.minDistance = 1;
        controls.maxDistance = 20;
        // controls.maxPolarAngle = Math.PI / 2;

        setInterval(forwardAnim, 30000);

        document.addEventListener('mousemove', onDocumentMouseMove, false);
        window.addEventListener('resize', onWindowResize, false);
    }
    
    function forwardAnim() {

        if (typeof bones.rotator !== 'undefined') {
            new TWEEN.Tween(bones.rotator.rotation)
                .to({ y: -Math.PI/2}, 1500)
                .onComplete(function() {
                    new TWEEN.Tween(bones.radius.rotation)
                        .to({ y: Math.PI/12}, 1500)
                        .onComplete(function () {
                            new TWEEN.Tween(bones.humerus.rotation)
                                .to({ z:  1.25*Math.PI}, 1500)
                                .onComplete(function () {
                                    new TWEEN.Tween(bones.radius.rotation)
                                        .to({ y: Math.PI/6}, 1500)
                                        .onComplete(function () {
                                            setTimeout(backwardAnim, 1500);
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
            .to({ y: Math.PI/2}, 1500)
            .onComplete(function () {
                new TWEEN.Tween(bones.radius.rotation)
                    .to({ y: Math.PI/12}, 1500)
                    .onComplete(function () {
                        new TWEEN.Tween(bones.radius.rotation)
                            .to({ y: Math.PI/6}, 1500)
                            .onComplete(function () {
                                setTimeout(resetAnim, 1500);
                            })
                            .start();
                    })
                    .start();
            })
            .start();
    }

    function resetAnim() {
        new TWEEN.Tween(bones.rotator.rotation)
            .to({ y: Math.PI/45}, 1500)
            .onComplete(function () {
                new TWEEN.Tween(bones.humerus.rotation)
                    .to({ z: Math.PI}, 1500)
                    .onComplete(function () {
                        new TWEEN.Tween(bones.radius.rotation)
                            .to({ y: -Math.PI/9}, 1500)
                            .onComplete(function () {
                                // alert('Cycle complete');
                                // location.reload();
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
        mouseX = ( event.clientX - windowHalfX ) / 2;
        mouseY = ( event.clientY - windowHalfY ) / 2;
    }

    function animate() {
        requestAnimationFrame(animate);
        render();
        controls.update();
        TWEEN.update();
    }

    function render() {
        // camera.position.x = 1;
        // camera.position.y = 25;

        camera.lookAt(scene.position);
        renderer.render(scene, camera);
    }
</script>

</body>
</html>