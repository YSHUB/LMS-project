using System;
using System.Collections;

namespace ILMS.Data.Dao
{
	public class LecInfoDAO : BaseDAO
	{

		public int CourseCopySave(Hashtable paramCourseCopy)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				rsCount = Common(paramCourseCopy);				
				rsCount += DaoFactory.Instance.Update("course.COURSE_WEEK_SAVE_E", paramCourseCopy);			

				DaoFactory.Instance.CommitTransaction();

				//DaoFactory.Instance.RollBackTransaction();
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int CourseCopySaveAll(Hashtable paramCourseCopy)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				rsCount = Common(paramCourseCopy);
				rsCount += DaoFactory.Instance.Update("course.COURSE_WEEK_SAVE_F", paramCourseCopy);

				DaoFactory.Instance.CommitTransaction();

				//DaoFactory.Instance.RollBackTransaction();
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int Common(Hashtable paramCourseCopy)
		{
			int rsCount = 0;

			rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_M", paramCourseCopy);
			rsCount += DaoFactory.Instance.Update("course.STUDY_INNING_SAVE_F", paramCourseCopy);
			rsCount += DaoFactory.Instance.Update("course.COURSE_BOARD_SAVE_C", paramCourseCopy);
			rsCount += DaoFactory.Instance.Update("ocw.OCW_COURSE_SAVE_E", paramCourseCopy);

			return rsCount;

		}
	}
}
