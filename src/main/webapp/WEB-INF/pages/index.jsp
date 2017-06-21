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

<script src="<c:url value="/resources/js/three.js"/>"></script>
<script src="<c:url value="/resources/js/jquery-3.2.1.min.js"/>"></script>

<script>
    var three = THREE;

    var scene = new three.Scene();
    var camera = new three.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000);

    var renderer = new three.WebGLRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);

    document.body.appendChild(renderer.domElement);

     var geometry = new THREE.BoxBufferGeometry( 3, 3, 3 );
     var edges = new THREE.EdgesGeometry( geometry );
     var wireframe = new THREE.LineSegments( edges, new THREE.LineBasicMaterial( { color: 0xffffff } ) );
    wireframe.rotation.x = Math.PI/4;
    wireframe.rotation.y = Math.PI/4;
     scene.add( wireframe );

/*
    var geometry = new three.CubeGeometry(2, 2, 2);
    var geo = new THREE.WireframeGeometry( geometry );
    var mat = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } );
    var wireframe = new three.Mesh(geo, mat);
    wireframe.rotation.x = Math.PI/4;
    wireframe.rotation.y = Math.PI/4;
    scene.add(wireframe);
*/

    camera.position.z = 5;

    /* */
    var isDragging = false;
    var previousMousePosition = {
        x: 0,
        y: 0
    };
    $(renderer.domElement).on('mousedown', function(e) {
        isDragging = true;
    })
        .on('mousemove', function(e) {
            //console.log(e);
            var deltaMove = {
                x: e.offsetX-previousMousePosition.x,
                y: e.offsetY-previousMousePosition.y
            };

            if(isDragging) {

                var deltaRotationQuaternion = new three.Quaternion()
                    .setFromEuler(new three.Euler(
                        toRadians(deltaMove.y * 1),
                        toRadians(deltaMove.x * 1),
                        0,
                        'XYZ'
                    ));

                wireframe.quaternion.multiplyQuaternions(deltaRotationQuaternion, wireframe.quaternion);
            }

            previousMousePosition = {
                x: e.offsetX,
                y: e.offsetY
            };
        });
    /* */

    $(document).on('mouseup', function(e) {
        isDragging = false;
    });

    // shim layer with setTimeout fallback
    window.requestAnimFrame = (function(){
        return  window.requestAnimationFrame ||
            window.webkitRequestAnimationFrame ||
            window.mozRequestAnimationFrame ||
            function(callback) {
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

        setTimeout(function() {
            var currTime = new Date().getTime() / 1000;
            var dt = currTime - (lastFrameTime || currTime);
            totalGameTime += dt;

            update(dt, totalGameTime);

            lastFrameTime = currTime;
        }, 0);
    }

    function render() {
        renderer.render(scene, camera);


        requestAnimFrame(render);
    }

    render();
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