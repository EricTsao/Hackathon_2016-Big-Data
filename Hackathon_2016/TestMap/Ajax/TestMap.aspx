<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestMap.aspx.cs" Inherits="TestMap_TestMap" %>

<!DOCTYPE html>


<script src="../Public/Script/jquery-1.12.3.js"></script>
<script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB9ozNMaZaiUQLyCfJkXwzDXgnyf6IUy2U&libraries=places&callback=initMap&language=en">
    </script>
<script src="/Hackathon_2016/Public/Script/turf.min.js"></script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <script>
                    $(document).ready(function(){
        
                        //alert("!");


                        $.ajax({
                            url: '/Hackathon_2016/TestMap/Ajax/GetMapPointData.ashx',
                            //    /TrainingWebSite/FinalHomework/Ajax/SearchCity.ashx
                            //<a href="Ajax/SearchCity.ashx">Ajax/SearchCity.ashx</a>
                            async: false,
                            cache: false,
                            dataType: 'json',
                            typr: 'POST',
                            //data: { stringMat: stringMat },
                            success: function (result) {

                                alert("!");

                            },
                            error: function () {
                                alert('看看程式碼');
                            }
                        });

        
                    });
            </script>




    </div>
    </form>
</body>
</html>
