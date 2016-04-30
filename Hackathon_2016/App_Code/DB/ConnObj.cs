using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ConnObj
/// </summary>
public class ConnObj
{
   
        public ConnObj()
        {
            //
            // TODO: 在此加入建構函式的程式碼
            //
        }

   
}
public class MyConnStringList
{
    public static string Hackathon2016 = ConfigurationManager.ConnectionStrings["ConnHackathon2016"].ConnectionString;

}