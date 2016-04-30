using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Robot.Robot_ClassLibrary
{
    public partial class Robot
    {
        public string Access_Token { get; set; }

        /// <summary>
        /// 一般初始化
        /// </summary>
        public Robot()
        {
            Access_Token = "";
        }

        /// <summary>
        /// 指定預設初始化
        /// </summary>
        public Robot(string access_Token)
        {
            //Access_Token
            Access_Token = access_Token;
        }
    }
}
