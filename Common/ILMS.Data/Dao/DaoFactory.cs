using System.Xml;
using IBatisNet.Common.Utilities;
using IBatisNet.DataMapper;
using IBatisNet.DataMapper.Configuration;

namespace ILMS.Data.Dao
{
    public class DaoFactory
    {
        private static object syncLock = new object();
        private static ISqlMapper mapper = null;

        public static ISqlMapper Instance
        {
            get
            {
                try
                {
                    if (mapper == null)
                    {
                        lock (syncLock)
                        {
                            if (mapper == null)
                            {
                                DomSqlMapBuilder dom = new DomSqlMapBuilder();
                                XmlDocument sqlMapConfig = Resources.GetEmbeddedResourceAsXmlDocument("Data.SqlMap.config, ILMS.Core");
                                mapper = dom.Configure(sqlMapConfig);
                            }
                        }
                    }
                    return mapper;
                }
                catch
                {
                    throw;
                }
            }
        }

		//public static void resetMapper()
		//{
		//	mapper = null;
		//}
    }
}