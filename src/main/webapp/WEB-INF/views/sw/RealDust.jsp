<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사회기반시설 스마트 유지관리 시스템</title>

  <style>
    html, body { margin:0; height:100%; }
    #map { width:100%; height:calc(100vh - 40px); }
    footer {
      height:40px;
      background:#333; color:#fff;
      display:flex; align-items:center; justify-content:center;
      position:fixed; bottom:0; left:0; right:0;
      z-index:1000;
      font-size:14px;
    }
    /* ✅ 오른쪽 상단 버튼 */
    #refreshBtn {
      position: fixed;
      top: 70px;       /* 헤더 밑 */
      right: 20px;
      z-index: 2000;
      background: #3b82f6;
      color: #fff;
      border: none;
      padding: 8px 14px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
      font-weight: 600;
    }
    #refreshBtn:hover {
      background: #2563eb;
    }
  </style>
</head>
<body>
  <%@ include file="/WEB-INF/views/header.jsp" %>
  <%@ include file="/WEB-INF/views/sidebar.jsp" %>

  <!-- ✅ 측정소 갱신 버튼 -->
  <button id="refreshBtn">측정 소 갱신</button>

  <div id="map"></div>

  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>

  <script>
    // ✅ 배경지도
    const vworldLayer = new ol.layer.Tile({
      source: new ol.source.XYZ({
        url: "http://api.vworld.kr/req/wmts/1.0.0/60DA3367-BC75-32D9-B593-D0386112A70C/Base/{z}/{y}/{x}.png"
      })
    });

    const map = new ol.Map({
      target: "map",
      layers: [vworldLayer],
      view: new ol.View({
        center: ol.proj.fromLonLat([127.024612, 37.5326]),
        zoom: 11
      })
    });

    const stations = [
      <c:forEach var="s" items="${getDustStation}" varStatus="loop">
        {
          name: "${s.stationName}",
          addr: "${s.stationAddr}",
          mang: "${s.mangName}",
          lon: ${s.lon},
          lat: ${s.lat},
          active: ${s.stationActive}
        }<c:if test="${!loop.last}">,</c:if>
      </c:forEach>
    ];

    function stationStyle(feature) {
      return new ol.style.Style({
        image: new ol.style.Circle({
          radius: 7,
          fill: new ol.style.Fill({ color: feature.get("active") ? "blue" : "gray" }),
          stroke: new ol.style.Stroke({ color: "#fff", width: 2 })
        }),
        text: new ol.style.Text({
          text: feature.get("name"),
          offsetY: -15,
          font: "bold 11px Noto Sans KR",
          fill: new ol.style.Fill({ color: "#111" }),
          stroke: new ol.style.Stroke({ color: "#fff", width: 3 })
        })
      });
    }

    const features = stations.map(s => new ol.Feature({
      geometry: new ol.geom.Point(ol.proj.fromLonLat([s.lon, s.lat])),
      name: s.name,
      addr: s.addr,
      mang: s.mang,
      active: s.active
    }));

    const stationLayer = new ol.layer.Vector({
      source: new ol.source.Vector({ features }),
      style: stationStyle
    });

    map.addLayer(stationLayer);

    map.on("singleclick", evt => {
      map.forEachFeatureAtPixel(evt.pixel, feature => {
        const props = feature.getProperties();
        alert("측정소명: " + props.name + "\n주소: " + props.addr + "\n망: " + props.mang);
      });
    });

    // ✅ 측정소 갱신 버튼 이벤트
    document.getElementById("refreshBtn").addEventListener("click", () => {
      fetch("${pageContext.request.contextPath}/fetchDustStations")
        .then(res => res.text())
        .then(msg => {
          alert("측정소 정보가 갱신되었습니다! (" + msg + ")");
          location.reload(); // 새로고침해서 DB 반영된 데이터 다시 불러옴
        })
        .catch(err => {
          console.error("갱신 오류:", err);
          alert("갱신 실패: " + err);
        });
    });
  </script>
</body>
</html>
