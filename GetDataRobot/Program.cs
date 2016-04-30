using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.IO;
using Newtonsoft.Json;
using System.Data.SqlClient;
using System.Data;
using System.Threading;
using System.Configuration;

namespace GetDataRobot
{
    class Program
    {
        static GetPlaceResultData GetPlaceResultByAPIUrl(string url)
        {
            //Thread.Sleep(2000);

            WebRequest wrGETURL;
            wrGETURL = WebRequest.Create(url);

            WebProxy myProxy = new WebProxy("myproxy", 80);
            myProxy.BypassProxyOnLocal = true;

            wrGETURL.Proxy = myProxy;

            wrGETURL.Proxy = WebProxy.GetDefaultProxy();

            Stream objStream;
            objStream = wrGETURL.GetResponse().GetResponseStream();

            StreamReader objReader = new StreamReader(objStream);

            string sLine = "";
            int i = 0;

            sLine = objReader.ReadToEnd();

            var p = JsonConvert.DeserializeObject<GetPlaceResultData>(sLine);

            return p;
        }

        static void Main(string[] args)
        {
            var matrixDatas = new List<MatrixData>();
            using (var conn = new SqlConnection("Data Source=10.0.0.143;Initial Catalog=Hackathon2016;Persist Security Info=True;User ID=sa;Password=80503736"))
            {
                var min = int.Parse(ConfigurationManager.AppSettings["min"]);
                var max = int.Parse(ConfigurationManager.AppSettings["max"]);

                conn.Open();
                var cmd = conn.CreateCommand();
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = string.Format(@"SELECT * FROM MatrixData WHERE RecordId >= {0} AND RecordId <= {1}", min, max);

                Console.WriteLine("取得座標資料...");
                using (var rd = cmd.ExecuteReader())
                {
                    if (rd.HasRows)
                    {
                        while (rd.Read())
                        {
                            var data = new MatrixData();
                            data.Latitude = (double)rd["Latitude"];
                            data.Longitude = (double)rd["Longitude"];
                            matrixDatas.Add(data);
                        }
                    }
                }
            }

            var count = 0;
            Console.WriteLine("取的地點資料...");
            foreach (var item in matrixDatas)
            {
                count++;
                Console.WriteLine(string.Format("取的地點資料...({0}/{1})", count, matrixDatas.Count));

                var distance = 231;
                var latitude = item.Latitude;
                var longitude = item.Longitude;
                var token = ConfigurationManager.AppSettings["token"];

                string sURL;
                sURL = string.Format("https://graph.facebook.com/v2.6/search?type=place&center={0},{1}&distance={2}&access_token={3}", latitude, longitude, distance, token);
                var tmpData = GetPlaceResultByAPIUrl(sURL);

                Console.WriteLine(string.Format("一共取得{0}個地點", tmpData.data.Count));
                var resultData = new List<GetPlaceResultData>();
                if (tmpData.data.Count > 0)
                {
                    tmpData.Latitude = item.Latitude;
                    tmpData.Longitude = item.Longitude;
                    resultData.Add(tmpData);
                    while (!string.IsNullOrEmpty(tmpData.paging.next))
                    {
                        tmpData = GetPlaceResultByAPIUrl(tmpData.paging.next);
                        if (tmpData.data.Count > 0)
                        {
                            Console.WriteLine(string.Format("下一頁...一共取得{0}個地點", tmpData.data.Count));
                            tmpData.Latitude = item.Latitude;
                            tmpData.Longitude = item.Longitude;
                            resultData.Add(tmpData);
                        }
                    }

                    Console.WriteLine(string.Format("地點資料取得完成, 開始寫入DB"));
                    using (var conn = new SqlConnection("Data Source=10.0.0.143;Initial Catalog=Hackathon2016;Persist Security Info=True;User ID=sa;Password=80503736"))
                    {
                        var cmd = conn.CreateCommand();
                        cmd.CommandType = CommandType.Text;
                        conn.Open();

                        var dbCount = 0;
                        foreach (var result in resultData)
                        {
                            dbCount++;
                            Console.WriteLine(string.Format("寫入資料...({0}/{1})", dbCount, resultData.Count));
                            foreach (var data in result.data)
                            {
                                cmd.Parameters.Clear();
                                cmd.Parameters.AddWithValue("@Latitude", result.Latitude);
                                cmd.Parameters.AddWithValue("@Longitude", result.Longitude);
                                cmd.Parameters.AddWithValue("@Name", data.name);
                                cmd.Parameters.AddWithValue("@Id", data.id);
                                cmd.CommandText = string.Format(@"
INSERT INTO [LocationInfo] ([Latitude],[Longitude],[Name],[Id],[UpdateTime],[UpdateBy],[CreateTime],[CreateBy])
VALUES(@Latitude,@Longitude,@Name,@Id,GETDATE(),'Eric.Tsao',GETDATE(),'Eric.Tsao')
");
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }

            Console.WriteLine("Done...");
            Console.ReadLine();
        }
    }
}
