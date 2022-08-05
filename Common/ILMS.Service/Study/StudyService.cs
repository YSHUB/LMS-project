using ILMS.Data.Dao;
using ILMS.Design.Domain;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Service
{
	public class StudyService
	{
		public StudyDao studyDao { get; set; }

		public int AttendanceUpdate(IList<StudyInning> studyInningsList)
		{
			return studyDao.AttendanceUpdate(studyInningsList);
		}
		
		public int StudyLogSave(StudyLog studyLog)
		{
			return studyDao.StudyLogSave(studyLog);
		}
	}
}
