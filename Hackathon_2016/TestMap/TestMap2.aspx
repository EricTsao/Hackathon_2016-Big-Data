<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true" CodeFile="TestMap2.aspx.cs" Inherits="TestMap_TestMap2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <script src="../Public/Script/turf.min.js"></script>
    <%--<script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB9ozNMaZaiUQLyCfJkXwzDXgnyf6IUy2U&libraries=places&callback=initMap&language=en" async defer></script>--%>

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB9ozNMaZaiUQLyCfJkXwzDXgnyf6IUy2U&libraries=places&language=en" async defer></script>
  

    <style>
    .customBox {
      background: rgba(150,150,0,0.5);
      position: absolute;
      margin-left:-50px;
      font-weight:bold;
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div id="MainDiv">
            <div style="width:60%;height:50px;margin-top: 80px;padding-left:10px;padding-right:10px;">
        <div id="timeSlider" >
        </div>
        <div >
            <input id="inputTime" type="text" style="width:350px"/>
        </div>
    </div>
    
     <script>
         var map;
         var dataMap = new google.maps.Data();

         function GetLocationDataCount() {
             $.ajax({
                 url: '<%=ConfigurationManager.AppSettings["Url"] %>Ajax/GetLocationDataCount.ashx',
                 async: false,
                 cache: false,
                 dataType: 'json',
                 typr: 'GET',
                 data: { endTime: $("#inputTime").val() },
                 success: function (result) {
                     for (var i in result) {
                         result[i].radius = result[i].Count / 50;
                     }
                     HackMap.DrawCircles(result);
                 },
                 error: function () {
                     alert('GetLocationDataCount failed!');
                 }
             });
         }

         window.DateToString = function (dateTime) {
             return dateTime.getFullYear() + "-" + TwoDigits((dateTime.getMonth() + 1)) + "-" + TwoDigits(dateTime.getDate()) + " " + TwoDigits(dateTime.getHours()) + ":" + TwoDigits(dateTime.getMinutes());
         };
         window.initMap = function () {
             map = new google.maps.Map(document.getElementById('mapLayout'), {
                 zoom: 12,
                 center: { lat: 24.96052, lng: 121.45713 }

             });
             google.maps.event.addListener(map, 'zoom_changed', function () { });
             SliderTime(null, { value: 11 });
             
         }
         window.TwoDigits = function (val) {
             if (val < 10) {
                 return "0" + ~~val;
             }

             return val;
         };
         window.createedgePoint = function (North, South, East, West) {

             var edgePointArray = [];
             var Northaxis = North.Longtitude;
             var Southaxis = South.Longtitude;
             var Eastaxis = East.Latitude;
             var Westaxis = West.Latitude;

             var Lefttoppoint = { lng: Westaxis, lat: Northaxis };
             var Leftbotpoint = { lng: Westaxis, lat: Southaxis };

             var Righttoppoint = { lng: Eastaxis, lat: Northaxis };
             var Rightbotpoint = { lng: Eastaxis, lat: Southaxis };

             edgePointArray.push(Righttoppoint);
             edgePointArray.push(Lefttoppoint);
             edgePointArray.push(Leftbotpoint);
             edgePointArray.push(Rightbotpoint);

             return edgePointArray;
         }
         window.HackMap = window.HackMap || {};
         var maxRadius = 0.6;
         var setStyle = function () {
             dataMap.setStyle(function (feature) {
                 if (feature.getProperty('line')) {
                     return { strokeWeight: 8, strokeColor: '#00f' };
                 }
                 else {
                     return { strokeWeight: 1, strokeColor: '#F00', fillOpacity: 0.8, fillColor: '#FF0000' };
                 }
             });
         };
         HackMap.DrawCircles = function (pointInfos) {
             // clear map
             dataMap.setMap(null);
             // reset dataList
             dataMap = new google.maps.Data();
             setStyle();
             // add data into dataList
             $(".customBox").remove();
             for (var i = 0; i < pointInfos.length; i++) {
                 if (pointInfos[i].radius <= 0) continue;
                 var turfPoint = turf.point([pointInfos[i].Point.lng, pointInfos[i].Point.lat]);
                 var buffered = turf.buffer(turfPoint, pointInfos[i].radius > maxRadius ? maxRadius : pointInfos[i].radius, "kilometers");
                 buffered.properties = {
                     "fill": "#FF0000",
                     "stroke": "#25561F",
                     "stroke-width": 5
                 };
                 dataMap.addGeoJson(buffered);
                 var panel = $('<div/>');
                 var content = $('<div/>');
                 content.text(pointInfos[i].Name);
                 panel.append(content);

                 var latlng = new google.maps.LatLng(pointInfos[i].Point.lat, pointInfos[i].Point.lng);
                 txt = new TxtOverlay(latlng, panel.html(), "customBox", map)
             }
             dataMap.setMap(map);
         };

         window.showAxisandName = function (point, label, map) {

             var latlng = new google.maps.LatLng(parseFloat(point.lat), parseFloat(point.lng));
             var LabelObj = new google.maps.Marker(
                 {
                     // zIndex: 1,
                     // title: titel,
                     position: latlng,
                     draggable: false,
                     //icon: image,
                     label: label,
                     map: map
                     // labelAnchor: new google.maps.Point(30, -2),
                     //labelClass: "labels", // the CSS class for the label
                     // labelStyle: { opacity: 0.80 }


                 }

                 );
             return LabelObj;
         };

         function GetMatrixData() {

             $.ajax({
                 url: '<%=ConfigurationManager.AppSettings["Url"] %>Ajax/GetMatrixDataCount.ashx',
                 async: false,
                 cache: false,
                 dataType: 'json',
                 typr: 'POST',
                 data: { startTime: '2016/4/30 23:50' },
                 success: function (result) {
                     for (var i in result) {
                         result[i].radius = result[i].Count / 1;
                     }
                     HackMap.DrawCircles(result);
                 },
                 error: function () {
                     alert('GetMatrixData failed!');
                 }
             });
         }
         $("#timeSlider").slider({ min:0,max: 11, value: 11 });
         function SliderTime(event, ui) {
             var currentHour = new Date().getHours();
             var value = 11 - ui.value;

             $(inputTime).val(DateToString(new Date(new Date().setHours(currentHour - value))));
             $("#CurrentTime").text($(inputTime).val());
             GetLocationDataCount();
         }

         function TxtOverlay(pos, txt, cls, map) {

             // Now initialize all properties.
             this.pos = pos;
             this.txt_ = txt;
             this.cls_ = cls;
             this.map_ = map;

             // We define a property to hold the image's
             // div. We'll actually create this div
             // upon receipt of the add() method so we'll
             // leave it null for now.
             this.div_ = null;

             // Explicitly call setMap() on this overlay
             this.setMap(map);
         }

         TxtOverlay.prototype = new google.maps.OverlayView();



         TxtOverlay.prototype.onAdd = function () {

             // Note: an overlay's receipt of onAdd() indicates that
             // the map's panes are now available for attaching
             // the overlay to the map via the DOM.

             // Create the DIV and set some basic attributes.
             var div = document.createElement('DIV');
             div.className = this.cls_;

             div.innerHTML = this.txt_;

             // Set the overlay's div_ property to this DIV
             this.div_ = div;
             var overlayProjection = this.getProjection();
             var position = overlayProjection.fromLatLngToDivPixel(this.pos);
             div.style.left = position.x + 'px';
             div.style.top = position.y + 'px';
             // We add an overlay to a map via one of the map's panes.

             var panes = this.getPanes();
             panes.floatPane.appendChild(div);
         }
         TxtOverlay.prototype.draw = function () {


             var overlayProjection = this.getProjection();

             // Retrieve the southwest and northeast coordinates of this overlay
             // in latlngs and convert them to pixels coordinates.
             // We'll use these coordinates to resize the DIV.
             var position = overlayProjection.fromLatLngToDivPixel(this.pos);


             var div = this.div_;
             div.style.left = position.x + 'px';
             div.style.top = position.y + 'px';



         }
         //Optional: helper methods for removing and toggling the text overlay.  
         TxtOverlay.prototype.onRemove = function () {
             this.div_.parentNode.removeChild(this.div_);
             this.div_ = null;
         }
         TxtOverlay.prototype.hide = function () {
             if (this.div_) {
                 this.div_.style.visibility = "hidden";
             }
         }

         TxtOverlay.prototype.show = function () {
             if (this.div_) {
                 this.div_.style.visibility = "visible";
             }
         }

         TxtOverlay.prototype.toggle = function () {
             if (this.div_) {
                 if (this.div_.style.visibility == "hidden") {
                     this.show();
                 } else {
                     this.hide();
                 }
             }
         }

         TxtOverlay.prototype.toggleDOM = function () {
             if (this.getMap()) {
                 this.setMap(null);
             } else {
                 this.setMap(this.map_);
             }
         }

         $(document).ready(function () {
             
             $("#timeSlider").slider({
                 change: function (event, ui) {
                     SliderTime(event, ui);
                 }
             });
            

             initMap();

             $.ajax({
                 url: '<%=ConfigurationManager.AppSettings["Url"] %>TestMap/Ajax/GetMapPointData.ashx',
                            async: false,
                            cache: false,
                            dataType: 'json',
                            typr: 'POST',
                            //   data: { stringMat: stringMat },
                            success: function (result) {

                                var List = createedgePoint(result[3], result[1], result[2], result[0]);

                                var bbox = [result[0].Latitude, result[1].Longtitude, result[2].Latitude, result[3].Longtitude];

                                var data = turf.bboxPolygon(bbox);
                                var center = turf.center(data);
                                map.setCenter({ lng: center.geometry.coordinates[0], lat: center.geometry.coordinates[1] });

                                // 載入 GeoJSON 資料
                                //map.data.addGeoJson(squareGrid); //這邊劃格線
                                map.data.addGeoJson(data);   // 這邊畫好範圍

                                //劃入點
                                //dataMap.setMap(null);
                                //dataMap = new google.maps.Data();

                                //for(var i = 0; i<result.length;i++){

                                //    var turfPoint = turf.point([result[i].Latitude, result[i].Longtitude]);
                                //    var buffered = turf.buffer(turfPoint, 3, "kilometers");

                                //    dataMap.addGeoJson(buffered);
                                //}

                                //dataMap.setMap(map);

                            },
                            error: function () {
                                alert('看看程式碼');
                            }
                        });

            //GetMatrixData();
        });


         </script>

    <div id="mapLayout" style=" width:1800px; height:1000px">


    </div>

    </div>

</asp:Content>

