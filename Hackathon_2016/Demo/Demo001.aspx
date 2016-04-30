<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true" CodeFile="Demo001.aspx.cs" Inherits="Demo_Demo001" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

   <div id="headerwrap">
	    <div class="container">
			<div class="row">
				<div class="col-lg-8 col-lg-offset-2">
					<h3>Show your work with this beautiful theme</h3>
					<h1>Eyecatching Bootstrap 3 Theme.</h1>
					<h5>Lorem Ipsum is simply dummy text of the printing and typesetting industry.</h5>
					<h5>More Lorem Ipsum added here too.</h5>				
				</div>
				<div class="col-lg-8 col-lg-offset-2 himg">
					<%--<img src="<%=ConfigurationManager.AppSettings["Url"] %>Public/Theme/Solid_Theme/assets/img/browser.png" class="img-responsive">--%>
                    <%--===============================--%>
                    <div id='map'></div>
<p id='zvalue' class='turf-controls'
    style="position: absolute; right: 5px; top: 5px;"> --
</p>
<script>
    L.mapbox.accessToken = 'pk.eyJ1IjoibW9yZ2FuaGVybG9ja2VyIiwiYSI6Ii1zLU4xOWMifQ.FubD68OEerk74AYCLduMZQ';

    var triangle = turf.polygon([[
            [-97.514914, 35.462453],
            [-97.517839, 35.468998],
            [-97.508678, 35.465942]
    ]], {
        "fill": "#6BC65F",
        "stroke": "#6BC65F",
        "stroke-width": 5,
        "a": 12,
        "b": 156,
        "c": 58
    });

    var point = turf.point([-97.509914, 35.464453], {
        "marker-color": "#6BC65F"
    });

    var point_fc = turf.featurecollection([point]);

    var point_layer = L.mapbox.featureLayer().setGeoJSON(point_fc);
    point_layer.eachLayer(function (layer) {
        layer.options.draggable = true;
        layer.on('drag', function (e) {
            calculatePlanepoint();
        });
    });

    var map = L.mapbox.map('map', 'morganherlocker.kgidd73k')
        .setView([35.465453, -97.513914], 15)
        .featureLayer.setGeoJSON(triangle);

    calculatePlanepoint();
    point_layer.addTo(map);

    function calculatePlanepoint() {
        var points = point_layer.getLayers();
        var planepoint = turf.planepoint(points[0].toGeoJSON(), triangle).toFixed(3);
        document.getElementById('zvalue').innerHTML = planepoint;
    }

</script>
                    <%--=================================--%>
				</div>
			</div><!-- /row -->
	    </div> <!-- /container -->
	</div><!-- /headerwrap -->

</asp:Content>

