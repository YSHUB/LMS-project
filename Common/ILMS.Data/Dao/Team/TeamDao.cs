using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace ILMS.Data.Dao
{
	public class TeamDao
	{
		public int AutoTeamAddSave(IList<CourseLecture> courseLectureStudentList, Group group, int teamMemberCnt)
		{
			int rsCount = 0;
			int groupNo = 0;

			DaoFactory.Instance.BeginTransaction();
			try
			{
				// 그룹저장
				Hashtable paramGroup = new Hashtable();
				paramGroup.Add("CourseNo", group.CourseNo);
				paramGroup.Add("GroupName", group.GroupName);
				paramGroup.Add("CreateUserNo", group.CreateUserNo);
				paramGroup.Add("GroupType", group.GroupType);

				groupNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("team.GROUP_SAVE_C", paramGroup));

				if (group.GroupType == "CGCT002") // 순차균등방식
				{
					var teamCnt = courseLectureStudentList.Count / teamMemberCnt;

					for (int tNo = 1; tNo <= teamCnt; tNo++)
					{
						Hashtable paramTeam = new Hashtable();
						paramTeam.Add("CreateUserNo", group.CreateUserNo);
						paramTeam.Add("CourseNo", group.CourseNo);
						paramTeam.Add("TeamName", tNo + "조");
						paramTeam.Add("GroupNo", groupNo);

						Convert.ToInt32(DaoFactory.Instance.QueryForObject("team.GROUP_TEAM_SAVE_C", paramTeam));
					}

					Hashtable paramHash = new Hashtable();
					paramHash.Add("GroupNo", groupNo);
					paramHash.Add("CourseNo", group.CourseNo);
					var teamNo = DaoFactory.Instance.QueryForList<GroupTeam>("team.GROUP_TEAM_SELECT_L", paramHash).Select(s => s.TeamNo).ToArray();
					int leaderIndex = 1;
					int teamIndex = 0;

					foreach (var item in courseLectureStudentList)
					{
						Hashtable paramMember = new Hashtable();
						paramMember.Add("TeamMemberUserNo", Convert.ToInt32(item.UserNo));
						paramMember.Add("TeamNo", teamNo[teamIndex]);
						paramMember.Add("TeamLeaderYesNo", leaderIndex <= teamCnt ? "Y" : "N");
						paramMember.Add("CourseNo", group.CourseNo);
						paramMember.Add("GroupNo", groupNo);

						leaderIndex++;
						teamIndex++;

						if (teamIndex >= teamCnt)
						{
							teamIndex = 0;
						}

						rsCount += Convert.ToInt32(DaoFactory.Instance.QueryForObject("team.GROUP_TEAM_MEMBER_SAVE_C", paramMember));
					}

				}
				else
				{
					int teamNo = 0;
					int teamIndexNo = 1;
					int teamUserIndexNo = 1;
					string leaderYesNo = "N";

					for (int i = 0; i < courseLectureStudentList.Count(); i++)
					{
						leaderYesNo = "N";
						if (i == 0 || teamUserIndexNo > teamMemberCnt)
						{
							Hashtable paramTeam = new Hashtable();
							paramTeam.Add("GroupNo", groupNo);
							paramTeam.Add("CourseNo", group.CourseNo);
							paramTeam.Add("TeamName", teamIndexNo + "조");
							paramTeam.Add("CreateUserNo", group.CreateUserNo);

							teamNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("team.GROUP_TEAM_SAVE_C", paramTeam));
							teamIndexNo++;
							leaderYesNo = "Y";
							teamUserIndexNo = 1;
						}

						Hashtable paramMember = new Hashtable();
						paramMember.Add("TeamMemberUserNo", courseLectureStudentList[i].UserNo);
						paramMember.Add("TeamNo", teamNo);
						paramMember.Add("GroupNo", groupNo);
						paramMember.Add("CourseNo", group.CourseNo);
						paramMember.Add("TeamLeaderYesNo", leaderYesNo);

						rsCount += Convert.ToInt32(DaoFactory.Instance.QueryForObject("team.GROUP_TEAM_MEMBER_SAVE_C", paramMember));

						teamUserIndexNo++;
					}
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

		public int GroupCopy(long createUserNo, int orgGroupNo)
		{
			int rsCount = 0;
			DaoFactory.Instance.BeginTransaction();
			try
			{
				Hashtable paramGroup = new Hashtable();
				paramGroup.Add("CreateUserNo", createUserNo);
				paramGroup.Add("GroupNo", orgGroupNo);
				int newGroupNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("team.GROUP_SAVE_A", paramGroup));

				Hashtable paramTeam = new Hashtable();
				paramTeam.Add("CreateUserNo", createUserNo);
				paramTeam.Add("GroupNo", orgGroupNo);
				paramTeam.Add("NewGroupNo", newGroupNo);
				Convert.ToInt32(DaoFactory.Instance.QueryForObject("team.GROUP_TEAM_SAVE_B", paramTeam));

				Hashtable paramMember = new Hashtable();
				paramMember.Add("GroupNo", orgGroupNo);
				paramMember.Add("NewGroupNo", newGroupNo);
				rsCount += DaoFactory.Instance.Update("team.GROUP_TEAM_MEMBER_SAVE_A", paramMember); ;

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
