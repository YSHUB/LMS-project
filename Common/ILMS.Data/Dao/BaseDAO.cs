using System;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Data.Dao
{
	public class BaseDAO
    {
		//리스트 반환
		public IList<T> GetList<T>(string queryId)
		{
			return DaoFactory.Instance.QueryForList<T>(queryId, null);
		}

		public IList<T> GetList<T>(string queryId, Object obj)
		{
			return DaoFactory.Instance.QueryForList<T>(queryId, obj);
		}

		public IList<T> GetList<T>(string queryId, string s)
		{
			return DaoFactory.Instance.QueryForList<T>(queryId, s);
		}

		public IList<T> GetList<T>(string queryId, int i)
		{
			return DaoFactory.Instance.QueryForList<T>(queryId, i);
		}

		public IList<T> GetList<T>(string queryId, Int64 i64)
		{
			return DaoFactory.Instance.QueryForList<T>(queryId, i64);
		}

		//객체 반환
		public T Get<T>(string queryId)
		{
			return DaoFactory.Instance.QueryForObject<T>(queryId, null);
		}

		public T Get<T>(string queryId, Hashtable paramHash)
		{
			return DaoFactory.Instance.QueryForObject<T>(queryId, paramHash);
		}

		public T Get<T>(string queryId, Object obj)
		{
			return DaoFactory.Instance.QueryForObject<T>(queryId, obj);
		}

		public T Get<T>(string queryId, string s)
		{
			return DaoFactory.Instance.QueryForObject<T>(queryId, s);
		}

		public T Get<T>(string queryId, int i)
		{
			return DaoFactory.Instance.QueryForObject<T>(queryId, i);
		}

		public T Get<T>(string queryId, Int64 i64)
		{
			return DaoFactory.Instance.QueryForObject<T>(queryId, i64);
		}

		//저장 - 결과 반환
		public int Save(string queryId, Hashtable paramHash)
		{
			return DaoFactory.Instance.Update(queryId, paramHash);
		}

		public int Save<T>(string queryId, T t)
		{
			return DaoFactory.Instance.Update(queryId, t);
		}
	}
}