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

    public int Count { get; set; }

	public MatrixData()
	{

		//
		// TODO: Add constructor logic here
		//
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