<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>OpenLayers + GeoServer</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@7.4.0/ol.css" />
  <script src="https://cdn.jsdelivr.net/npm/ol@7.4.0/dist/ol.js"></script>
  <style>
    #map {
      width: 100%;
      height: 100vh;
    }
  </style>
</head>
<body>
  <div id="map"></div>

  <script>
    // 1. 베이스맵 (OSM)
    const osmLayer = new ol.layer.Tile({
      source: new ol.source.OSM(),
    });

    // 2-1. 육교(yookgyo) 레이어
    const yookgyoLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
        url: 'http://localhost:1221/geoserver/wms',
        params: {
          'LAYERS': 'gisdb:yookgyo', 	
          'TILED': true
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false   // 처음엔 숨김
    });

    // 2-2. 교량(gyoryang) 레이어
    const gyoryangLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
        url: 'http://localhost:1221/geoserver/wms',
        params: {
          'LAYERS': 'gisdb:gyoryang',
          'TILED': true
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false  
    });

    // 2-3. 터널(tunnel) 레이어
    const tunnelLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
        url: 'http://localhost:1221/geoserver/wms',
        params: {
          'LAYERS': 'gisdb:tunnel',
          'TILED': true
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false  
    });
    
 // 2-4. 건축물 연령 정보(age) 레이어
    const AgeLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
        url: 'http://localhost:1221/geoserver/wms',
        params: {
          'LAYERS': 'gisdb:ageage',
          'TILED': true
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false  
    });
    
    // 3. 지도 생성
    const map = new ol.Map({
      target: 'map',
      layers: [osmLayer, yookgyoLayer, gyoryangLayer, tunnelLayer,AgeLayer],
      view: new ol.View({
        center: ol.proj.fromLonLat([127.024612, 37.5326]), // 서울 좌표
        zoom: 12,
        projection: 'EPSG:3857'
      }), 
    });

    //사이드바 버튼과 연동
    //교량 선택
    document.getElementById("btnBridge")?.addEventListener("click", function() {
   	  gyoryangLayer.setVisible(true);
      yookgyoLayer.setVisible(false);     
      tunnelLayer.setVisible(false);
      AgeLayer.setVisible(false);
    });
    
	//육교 선택
    document.getElementById("btnFootbridge")?.addEventListener("click", function() {
      gyoryangLayer.setVisible(false);
      yookgyoLayer.setVisible(true);
      tunnelLayer.setVisible(false);
      AgeLayer.setVisible(false);
    });
	
  	//터널 선택
    document.getElementById("btnTunnel")?.addEventListener("click", function() {
      gyoryangLayer.setVisible(false);
      yookgyoLayer.setVisible(false);
      tunnelLayer.setVisible(true);
      AgeLayer.setVisible(false);
    });
  	
  	//연령 선택
    document.getElementById("btnAge")?.addEventListener("click", function() {
      gyoryangLayer.setVisible(false);
      yookgyoLayer.setVisible(false);
      tunnelLayer.setVisible(false);
      AgeLayer.setVisible(true);
    });
	
	//전체 보기
    document.getElementById("btnAll")?.addEventListener("click", function() {
      yookgyoLayer.setVisible(true);
      gyoryangLayer.setVisible(true);
      tunnelLayer.setVisible(true);
      AgeLayer.setVisible(true);
    });
	
    //전체 해제
    document.getElementById("btnAlldown")?.addEventListener("click", function() {
        gyoryangLayer.setVisible(false);
        yookgyoLayer.setVisible(false);
        tunnelLayer.setVisible(false);
        AgeLayer.setVisible(false);
      });
    
  </script>
</body>
</html>
