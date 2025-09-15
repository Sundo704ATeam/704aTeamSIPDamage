<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Vworld 2.0 지도</title>
  <!-- Vworld API 2.0 -->
<script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=60DA3367-BC75-32D9-B593-D0386112A70C"></script>
  <style>
    body, html { margin:0; padding:0; width:100%; height:100%; }
    #map { width:100%; height:100%; }
  </style>
</head>
<body>
  <div id="map"></div>
  <script>
    // API 로드 확인 후 실행
    window.onload = function() {
/*   if (typeof vworld === "undefined") {
        alert("Vworld API 로드 실패 (Key 확인 필요)");
        return;
      }
 */      vworld.init("map", "base", {
        basemapType: "GRAPHIC",   // "GRAPHIC", "PHOTO", "HYBRID"
        controlDensity: "FULL",
        interaction: "ALL",
        controlsAutoArrange: true,
        initPosition: { x: 127.024612, y: 37.5326, z: 11 }
      });
    }
  </script>
</body>
</html>
