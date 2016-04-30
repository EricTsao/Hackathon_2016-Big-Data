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
              ,[Difference_Count]
        FROM [MatrixDataCount]
        WHERE 1=1
        AND [QueryTime] BETWEEN @StartTime AND @EndTime
        AND [Longitude] BEWEEN @LeftLng AND @RightLng
        AND [Latitude] BEWEEN @TopLat AND @BottomLat ";

            sqlCmd.Parameters.AddWithValue("StartTime", startTime);
            sqlCmd.Parameters.AddWithValue("EndTime", endTime);
            sqlCmd.Parameters.AddWithValue("TopLat", bounds[0].lat);
            sqlCmd.Parameters.AddWithValue("BottomLat", bounds[1].lat);
            sqlCmd.Parameters.AddWithValue("LeftLng", bounds[0].lng);
            sqlCmd.Parameters.AddWithValue("RightLng", bounds[3].lng);

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