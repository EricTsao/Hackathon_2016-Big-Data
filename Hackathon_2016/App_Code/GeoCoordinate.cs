using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for GeoCoordinate
/// </summary>
public class GeoCoordinate
{
    public double lat { get; set; }
    public double lng { get; set; }

    public GeoCoordinate(double lng, double lat)
    {
        this.Lng = lng;
        this.Lat = lat;
    }
}