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


         window.initMap = function () {
             var map;
             map = new google.maps.Map(document.getElementById('mapLayout'), {
                 zoom: 6,
                 center: { lat: 59.663487, lng: 23.333170 }

             });
             google.maps.event.addListener(map, 'zoom_changed', function () { });
         }


         window.createedgePoint = function ( North, South, East, West) {

             var edgePointArray = [];
             var Northaxis = North.Longtitude;
             var Southaxis = South.Longtitude;
             var Eastaxis = East.Latitude;
             var Westaxis = West.Latitude;

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
        
                        //alert("!");

                    
                      // initMap();



                        $.ajax({
                            url: '../TestMap/Ajax/GetMapPointData.ashx',
                            //    /TrainingWebSite/FinalHomework/Ajax/SearchCity.ashx
                            //<a href="Ajax/SearchCity.ashx">Ajax/SearchCity.ashx</a>
                            async: false,
                            cache: false,
                            dataType: 'json',
                            typr: 'POST',
                         //   data: { stringMat: stringMat },
                            success: function (result) {

                             

                                var List = createedgePoint(result[3], result[1], result[2], result[0]);

                                var bbox = [ result[0].Latitude, result[1].Longtitude,result[2].Latitude, result[3].Longtitude ];
                              //  var bbox = [  121.457128 ,24.96159,121.665287,25.210126]
                                // var bbox = [121.51083, 25.05127, 121.5441, 25.06838];
                                //GeoJson物件
                                //var dc = {
                                //    "type": "Feature",
                                //    "properties": {},
                                //    "geometry": {
                                //        "type": "LineString",
                                //        "coordinates": result
                                //    }
                                //};

                                var data = turf.bboxPolygon(bbox);
                                var center = turf.center(data);
                             //   var squareGrid = turf.squareGrid(bbox, 1, 'kilometers');


                                    // 地圖初始設定
                                    var mapOptions = {
                                        center: new google.maps.LatLng(center.geometry.coordinates[1], center.geometry.coordinates[0]),
                                        zoom: 12,
                                        mapTypeId: google.maps.MapTypeId.ROADMAP
                                    };

                                    var mapElement = document.getElementById("mapLayout");

                                    // Google 地圖初始化
                               //     map = new google.maps.Map(mapElement, mapOptions);

                                    // 載入 GeoJSON 資料
                              //     map.data.addGeoJson(squareGrid); //這邊劃格線
                                  //  map.data.addGeoJson(data);   // 這邊畫好範圍
                              
                                //劃入點


                                    for(var i = 0; i<result.length;i++){
                                    
                                       

                                        var turfPoint = turf.point([result[i].Longtitude, result[i].Latitude]);

                                        var buffered = turf.buffer(turfPoint, 20, "kilometers");

                                        var dataMap = new google.maps.Data();

                                        dataMap.addGeoJson(buffered);

                                      //  map.data.addGeoJson(buffered);
                                      // 失效   
                                      //  map.data.setMap();
                                    }
                                       
                                  // map.setMap(data);



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

