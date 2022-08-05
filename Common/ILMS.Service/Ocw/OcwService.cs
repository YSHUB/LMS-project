using ILMS.Data.Dao;
using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace ILMS.Service
{
	public class OcwService
	{
		public OcwDao ocwDao { get; set; }

		public Ocw GetOcw(Int64 OcwNo, Int64 ViewUserNo = 0)
		{
			return ocwDao.GetOcw(OcwNo, ViewUserNo);
		}

		public IList<Ocw> GetOcwList(string ThemeNo, string AssignNo, string sortParam, int? IsAuth, int? IsOpen
									, string SearchText, int? FirstIndex, int? LastIndex, string UserType = null)
		{
			return ocwDao.GetOcwList(ThemeNo, AssignNo, sortParam, IsAuth, IsOpen, SearchText, FirstIndex, LastIndex, UserType);
		}

		public IList<Term> GetTermList(Term term)
		{
			return ocwDao.GetTermList(term);
		}

		public Int64 SaveOcw(Hashtable ht, string links)
		{
			return ocwDao.SaveOcw(ht, links);

		}

		public string GetOcwDelPossibleYN(Int64 OcwNo)
		{
			return ocwDao.GetOcwDelPossibleYN(OcwNo);

		}
		public IList<LinkOcw> GetLinkOcw(Int64 OcwNo)
		{
			return ocwDao.GetLinkOcw(OcwNo);
		}

		public IList<OcwCourse> GetOcwCourseList(int CourseNo, int CCStatus = -1, string CreateUserType = null, int week = 0, int NotCCStatus = -1)
		{
			return ocwDao.GetOcwCourseList(CourseNo, CCStatus, CreateUserType, week, NotCCStatus);
		}

		public IList<OcwUserCategory> GetUserCategory(OcwUserCategory ouc, string RowState, bool addDefualt = false)
		{
			var cat = ocwDao.GetUserCategory(ouc, RowState);
			var c = cat.Where(w => w.CatCode == 0).FirstOrDefault();

			//기본 폴더 지우기
			if (!addDefualt && c != null)
			{
				cat.Remove(c);
			}

			return cat;
		}

		public IList<OcwTheme> GetOcwThemeList(OcwTheme ot)
		{
			return ocwDao.GetOcwThemeList(ot);
		}

		public int SaveOcwTheme (OcwTheme ot)
		{
			return ocwDao.SaveOcwTheme(ot);
		}

		public int OcwViewHistory(Int64 ocwNo, Int64 userNo)
		{
			return ocwDao.SaveOcwViewHistory(ocwNo, userNo);
		}
	}

}
