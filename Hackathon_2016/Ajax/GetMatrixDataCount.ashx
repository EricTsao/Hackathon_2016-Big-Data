<%@ WebHandler Language="C#" Class="GetMatrixDataCount" %>

using System;
using System.Web;
using Newtonsoft.Json;
using System.Collections.Generic;

public class GetMatrixDataCount : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {

        string boundsJson = context.Request["bounds"];
        string startTimeStr = context.Request["startTime"];
        string endTimeStr = context.Request["endTime"];
        //int xDivide = Convert.ToInt32(context.Request["xDivide"]);
        //int yDivide = Convert.ToInt32(context.Request["yDivide"]);
        
        //List<GeoCoordinate> bounds = JsonConvert.DeserializeObject<List<GeoCoordinate>>(boundsJson);
        DateTime startTime = Convert.ToDateTime(startTimeStr);
        //DateTime endTime = String.IsNullOrEmpty(endTimeStr) ? DateTime.Now.AddDays(1)//set to future date for no end time
        //    : Convert.ToDateTime(endTimeStr);

        //List <MatrixData> matrixDataList = MatrixData.GetGroupedMatrixData(bounds, startTime, endTime, xDivide, yDivide);

        List<MatrixData> matrixDataList = MatrixData.GetGroupedMatrixData(startTime, 20);
        
        context.Response.ContentType = "text/plain";
        context.Response.Write(JsonConvert.SerializeObject(matrixDataList));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}