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
    <title>three.js webgl - OBJLoader + MTLLoader</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <style>
        body {
            font-family: Monospace;
            background-color: #000;
            color: #fff;
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

        #info a, .button {
            color: #f00;
            font-weight: bold;
            text-decoration: underline;
            cursor: pointer
        }
    </style>
</head>

<body>
<div id="info">
    Virtual 3D Printer
</div>

<script src="<c:url value="/resources/js/three.js"/>"></script>

<script src="<c:url value="/resources/js/DDSLoader.js"/>"></script>
<script src="<c:url value="/resources/js/MTLLoader.js"/>"></script>
<script src="<c:url value="/resources/js/OBJLoader.js"/>"></script>

<script src="<c:url value="/resources/js/Detector.js"/>"></script>
<script src="<c:url value="/resources/js/stats.min.js"/>"></script>

<script>

    var container, stats;
    var camera, scene, renderer;
    var mouseX = 0, mouseY = 0;

    var windowHalfX = window.innerWidth / 2;
    var windowHalfY = window.innerHeight / 2;

    init();
    animate();
    //render();

    function init() {

        container = document.createElement('div');
        document.body.appendChild(container);

        camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 0.1, 2000);
        camera.position.z = 1;

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
                console.log(Math.round(percentComplete, 2) + '% downloaded');
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
                //object.position.y = -0.5;
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
                //object.position.y = 0.5;
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
                object.position.x = 0.1;
                object.position.y = 0.15;
                object.position.z = -0.15;

                var quaternion = new THREE.Quaternion();
                quaternion.setFromAxisAngle( new THREE.Vector3( -1, 0, 0 ), Math.PI / 2 );
                object.applyQuaternion(quaternion);

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
                object.position.y = 0.15;
                object.position.z = -0.15;

                var quaternion = new THREE.Quaternion();
                quaternion.setFromAxisAngle( new THREE.Vector3( 0, 1, 0 ), Math.PI / 2 );
                object.applyQuaternion(quaternion);

                scene.add(object);
            }, onProgress, onError);
        });

        // render all
        renderer = new THREE.WebGLRenderer();
        renderer.setClearColor(0xd3e3e1, 1);
        renderer.setPixelRatio(window.devicePixelRatio);
        renderer.setSize(window.innerWidth, window.innerHeight);
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
    }

    function render() {
        //camera.position.x += ( mouseX - camera.position.x ) * .1;
        //camera.position.y += ( - mouseY - camera.position.y ) * .1;
        camera.position.x = -1;
        camera.position.y = 1;

        camera.lookAt(scene.position);

        renderer.render(scene, camera);
    }

</script>

</body>
</html>
