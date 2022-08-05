using ILMS.Data.Dao;
using ILMS.Design.Domain;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Service
{
	public class TeamService
	{
		public TeamDao teamDao { get; set; }

		public int AutoTeamAddSave(IList<CourseLecture> courseLectureStudentList, Group group, int teamMemberCnt)
		{
			return teamDao.AutoTeamAddSave(courseLectureStudentList, group, teamMemberCnt);
		}


		public int GroupCopy(long createUserNo, int orgGroupNo)
		{
			return teamDao.GroupCopy(createUserNo, orgGroupNo);
		}
	}
}
