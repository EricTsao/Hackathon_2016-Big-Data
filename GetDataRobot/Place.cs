using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GetDataRobot
{
    class MatrixData
    {
        public double Longitude { get; set; }
        public double Latitude { get; set; }
    }

    class GetPlaceResultData : MatrixData
    {
        public List<Place> data { get; set; }
        public Paging paging { get; set; }
    }

    class Paging
    {
        public string next { get; set; }
    }

    class Place : FbObj
    {
        public string category { get; set; }
        public List<FbObj> category_list { get; set; }
    }

    class Location
    {
        public string street { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string country { get; set; }
        public string zip { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set; }
    }

    class FbObj
    {
        public string id { get; set; }
        public string name { get; set; }
    }


}
