<%@ WebHandler Language="C#" Class="GetLocationDataCount" %>

using System;
using System.Web;
using Newtonsoft.Json;
using System.Collections.Generic;

public class GetLocationDataCount : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {

        string startTimeStr = context.Request["startTime"];
        string endTimeStr = context.Request["endTime"];
        
        DateTime endTime = String.IsNullOrEmpty(endTimeStr) ? DateTime.Now.AddHours(1)//set to future date for no end time
            : Convert.ToDateTime(endTimeStr);
        DateTime startTime = String.IsNullOrEmpty(startTimeStr) ? endTime.AddHours(-1)//set to future date for no end time
            : Convert.ToDateTime(startTimeStr);
        //List <MatrixData> matrixDataList = MatrixData.GetGroupedMatrixData(bounds, startTime, endTime, xDivide, yDivide);

        List<MatrixData> matrixDataList = MatrixData.GetLocationData(startTime,endTime);
        
        context.Response.ContentType = "text/plain";
        context.Response.Write(JsonConvert.SerializeObject(matrixDataList));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}