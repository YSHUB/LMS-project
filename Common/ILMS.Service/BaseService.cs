using ILMS.Data.Dao;
using System;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Service
{
	public class BaseService
	{
		public BaseDAO baseDao { get; set; }

		//리스트 반환
		public IList<T> GetList<T>(string queryId, object obj)
		{
			return baseDao.GetList<T>(queryId, obj);
		}

		public IList<T> GetList<T>(string queryId, string s)
		{
			return baseDao.GetList<T>(queryId, s);
		}

		public IList<T> GetList<T>(string queryId, int i)
		{
			return baseDao.GetList<T>(queryId, i);
		}

		public IList<T> GetList<T>(string queryId, Int64 i64)
		{
			return baseDao.GetList<T>(queryId, i64);
		}

		//오브젝트 반환
		public T Get<T>(string queryId)
		{
			return baseDao.Get<T>(queryId);
		}

		public T Get<T>(string queryId, Hashtable paramHash)
		{
			return baseDao.Get<T>(queryId, paramHash);
		}

		public T Get<T>(string queryId, object obj)
		{
			return baseDao.Get<T>(queryId, obj);
		}

		public T Get<T>(string queryId, string s)
		{
			return baseDao.Get<T>(queryId, s);
		}

		public T Get<T>(string queryId, int i)
		{
			return baseDao.Get<T>(queryId, i);
		}

		public T Get<T>(string queryId, Int64 i64)
		{
			return baseDao.Get<T>(queryId, i64);
		}

		//저장 - 결과 반환
		public int Save(string queryId, Hashtable paramHash)
		{
			return baseDao.Save(queryId, paramHash);
		}

		public int Save<T>(string queryId, T t)
		{
			return baseDao.Save<T>(queryId, t);
		}
	}
}
