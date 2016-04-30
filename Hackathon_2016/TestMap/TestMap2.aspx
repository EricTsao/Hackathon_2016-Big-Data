<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true" CodeFile="TestMap2.aspx.cs" Inherits="TestMap_TestMap2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <script src="../Public/Script/jquery-1.12.3.js"></script>
    <script src="../Public/Script/turf.min.js"></script>
    <%--<script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB9ozNMaZaiUQLyCfJkXwzDXgnyf6IUy2U&libraries=places&callback=initMap&language=en" async defer></script>--%>

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB9ozNMaZaiUQLyCfJkXwzDXgnyf6IUy2U&libraries=places&language=en" async defer></script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <script>
         var map;
         var dataMap = new google.maps.Data();

         window.initMap = function () {
             map = new google.maps.Map(document.getElementById('mapLayout'), {
                 zoom: 12,
                 center: { lat: 24.96052, lng: 121.45713 }

             });
             google.maps.event.addListener(map, 'zoom_changed', function () { });
         }


         window.createedgePoint = function ( North, South, East, West) {

             var edgePointArray = [];
             var Northaxis = North.Latitude;
             var Southaxis = South.Latitude;
             var Eastaxis = East.Longtitude;
             var Westaxis = West.Longtitude;

             var Lefttoppoint = { lng: Westaxis, lat:Northaxis };
             var Leftbotpoint = { lng: Westaxis, lat:Southaxis };

             var Righttoppoint = {lng: Eastaxis, lat:Northaxis};
             var Rightbotpoint = { lng: Eastaxis, lat: Southaxis };


           //  var CenterPoint = { lat: (Eastaxis + Westaxis) / 2, lng: (Northaxis + Southaxis / 2) };

         

             edgePointArray.push(Righttoppoint);
             edgePointArray.push(Lefttoppoint);
             edgePointArray.push(Leftbotpoint);
             edgePointArray.push(Rightbotpoint);

             return edgePointArray;
         }

        $(document).ready(function(){
        
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

                                var bbox = [ result[0].Longtitude, result[1].Latitude,result[2].Longtitude, result[3].Latitude ];

                                var data = turf.bboxPolygon(bbox);
                                var center = turf.center(data);
                                map.setCenter({ lng: center.geometry.coordinates[0], lat: center.geometry.coordinates[1] });

                                    // 載入 GeoJSON 資料
                                   //map.data.addGeoJson(squareGrid); //這邊劃格線
                                map.data.addGeoJson(data);   // 這邊畫好範圍

                                //劃入點
                                dataMap.setMap(null);
                                dataMap = new google.maps.Data();

                                for(var i = 0; i<result.length;i++){

                                    var turfPoint = turf.point([result[i].Longtitude, result[i].Latitude]);
                                    var buffered = turf.buffer(turfPoint, 3, "kilometers");

                                    dataMap.addGeoJson(buffered);
                                }
                                       
                                dataMap.setMap(map);

                            },
                            error: function () {
                                alert('看看程式碼');
                            }
                        });

        
                    });


         </script>

    <div id="mapLayout" style=" width:1800px; height:1000px">


    </div>
</asp:Content>

