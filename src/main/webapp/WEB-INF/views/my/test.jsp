<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Weather</title>

<script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=E554AC2B-8B18-3D89-8C98-C31F6B9701CF"></script>
<script src="https://openlayers.org/en/v3.10.1/build/ol.js"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol-ext/dist/ol-ext.css">
<script src="https://cdn.jsdelivr.net/npm/ol-ext/dist/ol-ext.js"></script>

<style>
	#map {
	  width: 100%;
	  height: 100vh;
	}
</style>
</head>
<body>
	<div id="vmap" style="width:100%;height:100%;left:0px;top:0px"></div>
	
	<script type="text/javascript">
		vw.ol3.MapOptions = {
		      basemapType: vw.ol3.BasemapType.GRAPHIC
		    , controlDensity: vw.ol3.DensityType.EMPTY
		    , interactionDensity: vw.ol3.DensityType.BASIC
		    , controlsAutoArrange: true
		    , homePosition: vw.ol3.CameraPosition
		    , initPosition: vw.ol3.CameraPosition
		 };
		
		vmap = new vw.ol3.Map("vmap",  vw.ol3.MapOptions); 
		
		/* 
		const weatherData = [
		    { lon: 126.978, lat: 37.5665, temp: 30 },
		    { lon: 129.0756, lat: 35.1796, temp: 28 },
		    { lon: 127.3845, lat: 36.3504, temp: 27 },
		    { lon: 126.7052, lat: 37.4563, temp: 29 }
		  ];
		 */
	  
		 const weatherData = [
			  { lon: 44645510, lat: 20419810, temp: 23 },
			  { lon: 44107740, lat: 20946730, temp: 31 },
			  { lon: 44337240, lat: 20603240, temp: 27 },
			  { lon: 44785140, lat: 21093260, temp: 19 },
			  { lon: 45123720, lat: 21452360, temp: 33 },
			  { lon: 46322960, lat: 20415540, temp: 25 },
			  { lon: 46161610, lat: 20499990, temp: 34 },
			  { lon: 46446690, lat: 20484150, temp: 28 },
			  { lon: 45999220, lat: 20224820, temp: 22 },
			  { lon: 45420310, lat: 20183300, temp: 18 },
			  { lon: 45624950, lat: 20423690, temp: 29 },
			  { lon: 45634240, lat: 20820370, temp: 26 },
			  { lon: 45352490, lat: 20706810, temp: 32 },
			  { lon: 45276510, lat: 20351300, temp: 21 },
			  { lon: 45463610, lat: 20610870, temp: 30 },
			  { lon: 45152090, lat: 20324660, temp: 24 },
			  { lon: 45156200, lat: 20324380, temp: 27 },
			  { lon: 45267190, lat: 19844900, temp: 19 },
			  { lon: 45478040, lat: 19683700, temp: 20 },
			  { lon: 45156690, lat: 19982280, temp: 34 },
			  { lon: 44877140, lat: 20728680, temp: 28 },
			  { lon: 45590180, lat: 19371950, temp: 25 },
			  { lon: 45318900, lat: 19143330, temp: 17 },
			  { lon: 45823380, lat: 19265000, temp: 29 },
			  { lon: 45329250, lat: 19439900, temp: 31 },
			  { lon: 45182680, lat: 19126420, temp: 23 },
			  { lon: 44936460, lat: 19382650, temp: 30 },
			  { lon: 44812500, lat: 19912110, temp: 21 },
			  { lon: 44774390, lat: 20068210, temp: 18 },
			  { lon: 45016190, lat: 18671560, temp: 32 },
			  { lon: 45081270, lat: 18381700, temp: 22 },
			  { lon: 44640470, lat: 18819580, temp: 27 },
			  { lon: 44760150, lat: 18919870, temp: 25 },
			  { lon: 44742410, lat: 19080280, temp: 33 },
			  { lon: 44524910, lat: 19092950, temp: 20 },
			  { lon: 44398740, lat: 19006520, temp: 28 },
			  { lon: 44349540, lat: 18731680, temp: 19 },
			  { lon: 44587000, lat: 19464780, temp: 34 },
			  { lon: 44555270, lat: 19677120, temp: 26 },
			  { lon: 43972750, lat: 19075530, temp: 23 },
			  { lon: 44180249, lat: 18926290, temp: 27 },
			  { lon: 44208620, lat: 19573270, temp: 22 },
			  { lon: 44281840, lat: 19188710, temp: 25 },
			  { lon: 44270030, lat: 20288210, temp: 31 },
			  { lon: 44456380, lat: 19949280, temp: 20 },
			  { lon: 44613110, lat: 20937880, temp: 29 },
			  { lon: 44417470, lat: 21313980, temp: 33 }
			];
		 
		 const features = weatherData.map(d => {
		    return new ol.Feature({
		        geometry: new ol.geom.Point(ol.proj.fromLonLat([d.lon, d.lat])),
		        weight: d.temp / 40
		    });
	  });
		 
	  var vectorSource = new ol.source.Vector({
			features: features
		})
	 
	 const heatmapLayer = new ol.layer.Heatmap({
	    source: vectorSource,
	    blur: 25,
	    radius: 15,
	    weight: f => f.get('weight')
	  });

	  vmap.addLayer(heatmapLayer);

	  vmap.getView().setCenter(
			  ol.proj.transform([126.95, 37.53], "EPSG:4326", "EPSG:3857")
		  );
	  vmap.getView().setZoom(13);
	</script>
</body>
</html>
