using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace ILMS.Data.Dao
{
	public class TeamProjectDao
	{
		public int TeamProjectInsert(TeamProject teamProject)
		{
			int rsCount = 0;

			DateTime StartDay = DateTime.ParseExact(teamProject.SubmitStartDay.Replace("-", ""), "yyyyMMdd", null);
			DateTime EndDay = DateTime.ParseExact(teamProject.SubmitEndDay.Replace("-", ""), "yyyyMMdd", null);
			teamProject.SubmitStartDay = StartDay.AddHours(int.Parse(teamProject.SubmitStartHour)).AddMinutes(int.Parse(teamProject.SubmitStartMin)).ToString("yyyy-MM-dd HH:mm:00.000");
			teamProject.SubmitEndDay = EndDay.AddHours(int.Parse(teamProject.SubmitEndHour)).AddMinutes(int.Parse(teamProject.SubmitEndMin)).ToString("yyyy-MM-dd HH:mm:00.000");

			DaoFactory.Instance.BeginTransaction();

			try
			{
				if (teamProject.CourseGroupNo > 0)
				{
					Common(teamProject);
				}

				int projectNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("teamProject.TEAMPROJECT_SAVE_C", teamProject));

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

		public int TeamProjectUpdate(TeamProject teamProject)
		{
			int rsCount = 0;

			DateTime StartDay = DateTime.ParseExact(teamProject.SubmitStartDay.Replace("-", ""), "yyyyMMdd", null);
			DateTime EndDay = DateTime.ParseExact(teamProject.SubmitEndDay.Replace("-", ""), "yyyyMMdd", null);
			teamProject.SubmitStartDay = StartDay.AddHours(int.Parse(teamProject.SubmitStartHour)).AddMinutes(int.Parse(teamProject.SubmitStartMin)).ToString("yyyy-MM-dd HH:mm:00.000");
			teamProject.SubmitEndDay = EndDay.AddHours(int.Parse(teamProject.SubmitEndHour)).AddMinutes(int.Parse(teamProject.SubmitEndMin)).ToString("yyyy-MM-dd HH:mm:00.000");

			DaoFactory.Instance.BeginTransaction();

			try 
			{
				if (!teamProject.GroupNo.Equals(teamProject.UpdateCourseGroupNo))
				{
					Common(teamProject);
				}

				rsCount += DaoFactory.Instance.Update("teamProject.TEAMPROJECT_SAVE_U", teamProject);

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

		public void Common(TeamProject teamProject)
		{
			int ct = 0;

			Hashtable ht = new Hashtable();
			ht.Add("GroupNo", teamProject.CourseGroupNo);
			ht.Add("CreateUserNo", teamProject.CreateUserNo);

			int groupNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("teamProject.GROUP_SAVE_B", ht));
			teamProject.GroupNo = groupNo;

			ht = new Hashtable();
			ht.Add("GroupNo", teamProject.CourseGroupNo);

			IList<GroupTeam> GroupTeamList = DaoFactory.Instance.QueryForList<GroupTeam>("teamProject.GROUP_TEAM_SELECT_A", ht);

			foreach (var item in GroupTeamList)
			{
				ht = new Hashtable();
				ht.Add("TeamNo", item.TeamNo);
				ht.Add("GroupNo", teamProject.GroupNo);
				ht.Add("CourseNo", teamProject.CourseGroupNo);

				int newTeamNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("teamProject.GROUP_TEAM_SAVE_A", ht));

				ht = new Hashtable();
				ht.Add("GroupNo", teamProject.CourseGroupNo);
				ht.Add("TeamNo", item.TeamNo);
				ht.Add("TeamMemberNo", newTeamNo);

				ct += DaoFactory.Instance.Update("teamProject.GROUP_TEAM_MEMBER_SAVE_B", ht);
			}

		}
	}
}
