using ILMS.Data.Dao;
using System.Collections;

namespace ILMS.Service
{
	public class LecInfoService
	{
		public LecInfoDAO lecInfoDao { get; set; }

		public int CourseCopySave(int courseNo, int copyCourseNo, int week, int userNo)
		{
			int cnt = 0;

			Hashtable paramCourseCopy = new Hashtable();
			paramCourseCopy.Add("CourseNo", courseNo);
			paramCourseCopy.Add("CopyCourseNo", copyCourseNo);
			paramCourseCopy.Add("Week", week);
			paramCourseCopy.Add("CreateUserNo", userNo);

			if (week != 0)
			{
				cnt = lecInfoDao.CourseCopySave(paramCourseCopy);
			}
			else
			{
				cnt = lecInfoDao.CourseCopySaveAll(paramCourseCopy);
			}			

			return cnt;
		}
	}
}
