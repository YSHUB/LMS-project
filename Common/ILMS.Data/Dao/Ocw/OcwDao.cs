using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Data.Dao
{
    public class OcwDao : BaseDAO
    {
        //개별 OCW 조회
        public Ocw GetOcw(Int64 OcwNo, Int64 ViewUserNo)
        {
            Hashtable ht = new Hashtable();
            ht.Add("OcwNo", OcwNo);
            ht.Add("ViewUserNo", ViewUserNo);

            return DaoFactory.Instance.QueryForObject<Ocw>("ocw.OCW_SELECT_S", ht);
        }

        //OCW목록 조회
        public IList<Ocw> GetOcwList(string ThemeNo, string AssignNo, string sortParam, int? IsAuth, int? IsOpen
                                    , string SearchText, int? FirstIndex, int? LastIndex, string UserType)
        {
			Hashtable ht = new Hashtable();

            ThemeNo = ThemeNo ?? "%";

			ht.Add("ThemeNos", "," + ThemeNo + ",");
			ht.Add("AssignNo", AssignNo);
			ht.Add("SortValue", sortParam);
			ht.Add("IsAuth", IsAuth);
			ht.Add("IsOpen", IsOpen);
			ht.Add("SearchText", SearchText);
			ht.Add("FirstIndex", FirstIndex);
			ht.Add("LastIndex", LastIndex);
			ht.Add("UserType", UserType);

			return DaoFactory.Instance.QueryForList<Ocw>("ocw.OCW_SELECT_L", ht);
        }

        //연계 OCW 조회
        public IList<LinkOcw> GetLinkOcw(Int64 OcwNo)
        {
            Hashtable ht = new Hashtable();
            ht.Add("OcwNo", OcwNo);

            return DaoFactory.Instance.QueryForList<LinkOcw>("ocw.OCW_LINK_SELECT_S", ht);
        }

        //OCW 등록/수정/삭제
        public Int64 SaveOcw(Hashtable ht, string links)
        {
            Int64 ocwNo = 0;
            int updateCnt;

            if(Convert.ToInt32(ht["OcwNo"]) < 1)
            {
                ocwNo = Convert.ToInt64(DaoFactory.Instance.QueryForObject("ocw.OCW_SAVE_C", ht));
            }
            else
            {
                updateCnt = DaoFactory.Instance.Update("ocw.OCW_SAVE_U", ht);

                if(updateCnt > 0)
                {
                    ocwNo = Convert.ToInt64(ht["OcwNo"]);

                    if(links != null)
                    {
                        DaoFactory.Instance.Delete("ocw.OCW_LINK_SAVE_D", ocwNo);
                    }
                }
            }

            //연계OCW 
            if (!string.IsNullOrEmpty(links))
            {
                Hashtable ht2 = new Hashtable();

                ht2.Add("OcwNo", ocwNo);
                ht2.Add("UpdateUserNo", ht["UpdateUserNo"]);
                ht2.Add("LinkOcwNo", links);

                DaoFactory.Instance.Update("ocw.OCW_LINK_SAVE_C", ht2);
            }

            return ocwNo;
        }


		//OCW 삭제여부 조회
		public string GetOcwDelPossibleYN(Int64 OcwNo)
        {
            string ocwDelPossibleYN = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("OcwNo", OcwNo);

            ocwDelPossibleYN = DaoFactory.Instance.QueryForObject("ocw.OCW_DELETE_YN_SELECT_A", ht).ToString();

            return ocwDelPossibleYN;
        }

        public IList<Term> GetTermList(Term term)
        {
            return DaoFactory.Instance.QueryForList<Term>("term.TERM_SELECT_L", term);
        }

        public IList<OcwCourse> GetOcwCourseList(int CourseNo, int CCStatus, string CreateUserType, int week, int NotCCStatus)
        {
            Hashtable ht = new Hashtable();
            ht.Add("CourseNo", CourseNo);
            if (CCStatus > -1)
            {
                ht.Add("CCStatus", CCStatus);
            }
            if (CreateUserType != null)
            {
                ht.Add("CreateUserType", CreateUserType);
            }
            if (week > 0)
            {
                ht.Add("Week", week);
            }
            if (NotCCStatus > -1)
            {
                ht.Add("NotCCStatus", NotCCStatus);
            }

            return DaoFactory.Instance.QueryForList<OcwCourse>("ocw.OCW_COURSE_WEEK_SELECT_B", ht);
        }

        //유저 카테고리 조회
        public IList<OcwUserCategory> GetUserCategory(OcwUserCategory ouc, string RowState)
        {
            return DaoFactory.Instance.QueryForList<OcwUserCategory>("ocw.OCW_USERCAT_SELECT_" + RowState, ouc);
        }

        //OCW테마리스트 조회
        public IList<OcwTheme> GetOcwThemeList(OcwTheme ot)
		{
            return DaoFactory.Instance.QueryForList<OcwTheme>("ocw.OCW_THEME_SELECT_L", ot);
        }

        //OCW테마키워드 저장 및 삭제
        public int SaveOcwTheme(OcwTheme ot)
		{
            //신규
            if(ot.ThemeNo < 1)
			{
                return DaoFactory.Instance.Update("ocw.OCW_THEME_SAVE_C", ot);

			}
			else
			{
                //삭제
                if (ot.DeleteYesNo == "Y") 
				{
                    return DaoFactory.Instance.Delete("ocw.OCW_THEME_SAVE_D", ot);
                }

                //수정
                return DaoFactory.Instance.Update("ocw.OCW_THEME_SAVE_U", ot);
            }
        }

        //OCW_VIEW HISTRORY
        public int SaveOcwViewHistory(Int64 ocwNo, Int64 userNo)
        {
            Hashtable ht = new Hashtable();

            ht.Add("OcwNo", ocwNo);
            ht.Add("UserNo", userNo);

            return DaoFactory.Instance.Update("ocw.OCW_HISTORY_SAVE_C", ht);

        }
    }
}
