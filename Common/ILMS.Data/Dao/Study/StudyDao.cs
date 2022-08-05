using ILMS.Core.System;
using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Configuration;

namespace ILMS.Data.Dao
{
	public class StudyDao
	{
		public int AttendanceUpdate(IList<StudyInning> studyInningsList)
		{
			int rsCount = 1;

			DaoFactory.Instance.BeginTransaction();
			try
			{
				foreach(var item in studyInningsList)
				{
					Hashtable ht = new Hashtable();
					ht.Add("UpdateUserNo", item.UpdateUserNo);
					ht.Add("StudyInningNo", item.StudyInningNo);
					ht.Add("AttendanceStatus", item.AttendanceStatus);

					Convert.ToInt32(DaoFactory.Instance.Update("course.STUDY_INNING_SAVE_E", ht));


					StudyInning param = new StudyInning();
					param.UpdateUserNo = item.UpdateUserNo;
					param.StudyInningNo = item.StudyInningNo;
					param.AttendanceStatus = item.AttendanceStatus;
					param.AttendanceReason = WebConfigurationManager.AppSettings["ProfIDText"].ToString() + " > 강의실 > 출결관리 > (일괄)저장";
					param.DeleteYesNo = "N";
					param.UserID = item.UserNo.ToString();

					Convert.ToInt32(DaoFactory.Instance.Update("course.STUDY_INNING_SAVE_A", param));

				}
				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int StudyLogSave(StudyLog studyLog)
		{
			int rsCount = 1;

			DaoFactory.Instance.BeginTransaction();
			try
			{
				if (studyLog.RowState.Equals("C"))
				{
					DaoFactory.Instance.Update("course.STUDY_LOG_SAVE_C", studyLog);

					Hashtable hash = new Hashtable();
					hash.Add("StudyInningNo", studyLog.StudyInningNo);
					hash.Add("StudyStatus", "STST002");
					DaoFactory.Instance.Update("course.STUDY_INNING_SAVE_U", hash);
				}
				else if (studyLog.RowState.Equals("U"))
				{
					DaoFactory.Instance.Update("course.STUDY_LOG_SAVE_U", studyLog);

					Hashtable hash = new Hashtable();
					if (studyLog.TotalStudyTime > 0)
					{
						hash.Add("StudyTime", Convert.ToInt32(studyLog.TotalStudyTime / 60));
					}
					hash.Add("StudyInningNo", studyLog.StudyInningNo);
					DaoFactory.Instance.Update("course.STUDY_INNING_SAVE_U", hash);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}
	}
}
