<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true" CodeFile="DemoMapAndy.aspx.cs" Inherits="Demo_DemoMapAndy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <script>
        (function (window) {

            window.HackMap = window.HackMap || {};
            HackMap.MatrixInfo = {points:[],
                maxRadius:10};

            HackMap.PointInfoToBounds = function (pointInfo) {
                var bounds = [];
                var topLat = pointInfo.point.lat + HackMap.MatrixInfo.maxRadius;
                var bottomLat = pointInfo.point.lat - HackMap.MatrixInfo.maxRadius;
                var leftLng = pointInfo.point.lng + HackMap.MatrixInfo.maxRadius;
                var rightLng = pointInfo.point.lng - HackMap.MatrixInfo.maxRadius;

                bounds.push({ lat: topLat, lng: leftLng });
                bounds.push({ lat: bottomLat, lng: leftLng });
                bounds.push({ lat: topLat, lng: rightLng });
                bounds.push({ lat: bottomLat, lng: rightLng });

                return bounds;
            };

            HackMap.CountToRadius = function (count) {
                var radious = 0;

                return radious;
            };

            HackMap.FindPointDataByPoint = function (pointDataList, pointInfo) {
                var bounds = HackMap.PointInfoToBounds(pointInfo);


                return pointDataList.filter(function (item, index, array) {
                    return bounds[0].lat >= item.point.lat && bounds[1].lat <= item.point.lat
                        && bounds[0].lng >= item.point.lng && bounds[3].lng >= item.point.lng;
                });
            };

        })(window, undefined);

    </script>
</asp:Content>

