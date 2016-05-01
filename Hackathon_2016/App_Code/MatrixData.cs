using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for MatrixData
/// </summary>
public class MatrixData
{
    public GeoCoordinate Point { get; set; }

    public string Name { get; set; }

    public int Count { get; set; }

	public MatrixData()
	{

		//
		// TODO: Add constructor logic here
		//
	}

    public static List<MatrixData> GetGroupedMatrixData(DateTime dateTime, int divCount)
    {
        List<MatrixData> matrixDataList = null;

        using (var conn = new SqlConnection(MyConnStringList.Hackathon2016))
        {
            var sqlCmd = conn.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;

            sqlCmd.CommandText = @"QueryLocationCheckingCountByTime ";

            sqlCmd.Parameters.AddWithValue("@Time", dateTime);
            sqlCmd.Parameters.AddWithValue("@Div", divCount);

            conn.Open();

            using (var reader = sqlCmd.ExecuteReader())
            {
                if (reader.HasRows)
                {
                    matrixDataList = new List<MatrixData>();
                    while (reader.Read())
                    {
                        MatrixData matrixData = new MatrixData();
                        matrixData.Point = new GeoCoordinate(Convert.ToDouble(reader["Longitude"]), Convert.ToDouble(reader["Latitude"]));
                        matrixData.Count = Convert.ToInt32(reader["Count"]);

                        matrixDataList.Add(matrixData);
                    }
                }
            }
        }

        return matrixDataList;
    }

    public static List<MatrixData> GetLocationData(DateTime startTime, DateTime endTime)
    {
        List<MatrixData> matrixDataList = null;

        using (var conn = new SqlConnection(MyConnStringList.Hackathon2016))
        {
            var sqlCmd = conn.CreateCommand();
            sqlCmd.CommandType = CommandType.Text;

            sqlCmd.CommandText = @"
SELECT * FROM (
            SELECT TOP 10 [Longitude],
                  [Latitude],
                  [name],SUM([Difference_Count]) AS DCOUNT
              FROM [dbo].[MatrixDataCountLog] as [Log] 
              inner join
              (
               SELECT [Id],[Name]
               FROM [dbo].[LocationInfo]
               group by [Id],[Name]
              ) as [Location]
              on [Log].[Id] = [Location].[Id]
              --Where [QueryTime]>='2016-05-01 04:00:00.00'
              Where [QueryTime] BETWEEN @StartTime AND @EndTime
              AND [Difference_Count] > 0
              GROUP BY [Longitude],
                  [Latitude],
                  name
              Order by DCOUNT desc
 ) A
UNION
  SELECT  [Longitude],
      [Latitude],
      [name],SUM([Difference_Count])*2 AS DCOUNT
  FROM [dbo].[MatrixDataCountLog] as [Log] 
  inner join
  (
   SELECT [Id],[Name]
   FROM [dbo].[LocationInfo]
   group by [Id],[Name]
  ) as [Location]
  on [Log].[Id] = [Location].[Id]
  --Where [QueryTime]>='2016-05-01 04:00:00.00'
  Where [QueryTime] BETWEEN @StartTime AND @EndTime
  AND [Difference_Count] > 0
  AND [Name]IN(N'2016 Bigdata x Maker Hackathon',N'2016 Big Data X Maker Hackathon 大數據應用競賽')
  GROUP BY [Longitude],
      [Latitude],
      [Name]
               ";

            sqlCmd.Parameters.AddWithValue("@StartTime", startTime);
            sqlCmd.Parameters.AddWithValue("@EndTime", endTime);

            conn.Open();

            using (var reader = sqlCmd.ExecuteReader())
            {
                if (reader.HasRows)
                {
                    matrixDataList = new List<MatrixData>();
                    while (reader.Read())
                    {
                        MatrixData matrixData = new MatrixData();
                        matrixData.Point = new GeoCoordinate(Convert.ToDouble(reader["Longitude"]), Convert.ToDouble(reader["Latitude"]));
                        matrixData.Count = Convert.ToInt32(reader["DCount"]);
                        matrixData.Name = Convert.ToString(reader["Name"]);

                        matrixDataList.Add(matrixData);
                    }
                }
            }
        }

        return matrixDataList;
    }


    public static List<MatrixData> GetGroupedMatrixData(List<GeoCoordinate> bounds, DateTime startTime, DateTime endTime, int xDivide, int yDivide)
    {
        List<MatrixData> matrixDataList = null;

        using (var conn = new SqlConnection(MyConnStringList.Hackathon2016))
        {
            var sqlCmd = conn.CreateCommand();
            sqlCmd.CommandType = CommandType.Text;

            sqlCmd.CommandText = @"
                SELECT [Longitude]
              ,[Latitude]
              ,MAX([Count])
               -MIN([Count]) AS Difference_Count
        FROM [MatrixDataCount]
        WHERE 1=1
        AND [QueryTime] BETWEEN @StartTime AND @EndTime
        AND [Longitude] BETWEEN @LeftLng AND @RightLng
        AND [Latitude] BETWEEN @BottomLat AND @TopLat 
        GROUP BY [Longitude],[Latitude]";

            sqlCmd.Parameters.AddWithValue("StartTime", startTime);
            sqlCmd.Parameters.AddWithValue("EndTime", endTime);
            sqlCmd.Parameters.AddWithValue("TopLat", bounds[0].lat);
            sqlCmd.Parameters.AddWithValue("BottomLat", bounds[2].lat);
            sqlCmd.Parameters.AddWithValue("RightLng", bounds[0].lng);
            sqlCmd.Parameters.AddWithValue("LeftLng", bounds[2].lng);

            conn.Open();

            using (var reader = sqlCmd.ExecuteReader())
            {
                if (reader.HasRows)
                {
                    matrixDataList = new List<MatrixData>();
                    while (reader.Read())
                    {
                        MatrixData matrixData = new MatrixData();
                        matrixData.Point = new GeoCoordinate(Convert.ToDouble(reader["Longitude"]), Convert.ToDouble(reader["Latitude"]));
                        matrixData.Count = Convert.ToInt32(reader["Difference_Count"]);

                        matrixDataList.Add(matrixData);
                    }
                }
            }
        }

        return matrixDataList;
    }
}