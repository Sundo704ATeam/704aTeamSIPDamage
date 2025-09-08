<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="map"></div>
<script>
  (function () {
    if (!window.ol) { console.error('OpenLayers not loaded'); return; }

    // 이미 만들어진 전역 지도가 있으면, 같은 target만 재지정
    if (window.olMap instanceof ol.Map) {
      window.olMap.setTarget('map');
      return;
    }

    // 전역으로 노출 (window.olMap)
    window.olMap = new ol.Map({
      target: 'map',
      layers: [
        new ol.layer.Tile({ source: new ol.source.OSM() })
      ],
      view: new ol.View({
        center: ol.proj.fromLonLat([127.024612, 37.5326]),
        zoom: 11
      })
    });
  })();
</script>
