<%@ WebHandler Language="C#" Class="GetMapPointData" %>

using System;
using System.Web;
using System.Collections.Generic;
public class GetMapPointData : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        var mapObjList = new List<mapobj>();

        var taipeiWest = new mapobj() { Longtitude = (float)25.10913, Latitude = (float)121.457128 };
        var taipeiEast = new mapobj() { Longtitude = (float)25.025986, Latitude = (float)121.665187 };
        var taipeiNorth = new mapobj() { Longtitude = (float)25.210126, Latitude = (float)121.559439 };
        var taipeiSouth = new mapobj() { Longtitude = (float)24.960519, Latitude = (float)121.597140 };

        // mapObjList.Add(taipeiEast);



        mapObjList.Add(taipeiWest);
        mapObjList.Add(taipeiSouth);
        mapObjList.Add(taipeiEast);
        mapObjList.Add(taipeiNorth);
        var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        var result = serializer.Serialize(mapObjList);

        context.Response.Write(result);
        //context.Response.Write("Hello World");
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
    public class mapobj {
        public float Longtitude { get; set; }
        public float Latitude { get; set; }





    }

}