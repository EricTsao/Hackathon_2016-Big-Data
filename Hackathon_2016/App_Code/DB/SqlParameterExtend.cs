using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for SqlParameterExtend
/// </summary>
public class SqlParameterExtend
{
    /// <summary>
    /// Allow insert null value
    /// </summary>
    /// <param name="parameters"></param>
    /// <param name="parameterName"></param>
    /// <param name="value"></param>
    /// <returns></returns>
    public static SqlParameter AddWithValueSafe(this SqlParameterCollection parameters, string parameterName, object value)
    {
        return parameters.AddWithValue(parameterName, value ?? DBNull.Value);
    }
}