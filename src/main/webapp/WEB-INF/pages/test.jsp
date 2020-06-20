<%--
  Created by IntelliJ IDEA.
  User: Rakib
  Date: 6/21/2017
  Time: 7:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="com.cpmc.utils.DTPlatform" %>
<%@ page import="org.junit.Test" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>three.js canvas - geometry - wireframe</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <style>
        body {
            font-family: Monospace;
            background-color: #f0f0f0;
            margin: 0px;
            overflow: hidden;
        }
    </style>
</head>
<body>

<%--
<script src="<c:url value="/resources/js/three.js"/>"></script>
<script src="<c:url value="/resources/js/jquery-3.2.1.min.js"/>"></script>
--%>

<script>

    /*
        var three = THREE;

        var scene = new three.Scene();
        var camera = new three.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);

        var renderer = new three.WebGLRenderer();
        renderer.setSize(window.innerWidth, window.innerHeight);
        document.body.appendChild(renderer.domElement);

        // first add the container in the scene
        var geometry = new THREE.BoxGeometry(3, 3, 3);
        var material = new THREE.MeshBasicMaterial( {color: 0x00ff00} );
        var container = new THREE.Mesh(geometry, material);
        scene.add(container);

        // then add objects as the child of container
        var geometry_obj = new THREE.BoxGeometry(1, 1, 1);
        var material_obj = new THREE.MeshBasicMaterial( {color: 0x00ff00} );
        var object = new THREE.Mesh(geometry_obj, material_obj);
        // you can set the object's position in the container
        object.position.set(0.1, 0.1, 0.1);
        container.add(object);

        camera.position.z = 5;
    */

    <%
            DTPlatform platform = DTPlatform.getPlatform();
    %>

    function test() {
        console.log("<%=platform.getPlatformManager().getDT("Ultimaker01").getData("nozzleTemperature")%>");
    }

    window.setInterval(test, 5000);
</script>

</body>
</html>
