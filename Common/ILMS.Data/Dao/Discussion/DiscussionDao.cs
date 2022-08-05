using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Data.Dao
{
	public class DiscussionDao : BaseDAO
	{
		public int DiscussionInsert(Discussion discussion)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// 조별토론 >> 팀편성 그룹 추가
				if (!discussion.CourseGroupNo.Equals(0))
				{
					Common(discussion);
				}

				rsCount += DaoFactory.Instance.Update("discussion.DISCUSSION_SAVE_C", discussion);

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

		public int DiscussionUpdate(Discussion discussion)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				if (!discussion.GroupNo.Equals(discussion.UpdateCourseGroupNo))
				{
					Common(discussion);
				}

				rsCount += DaoFactory.Instance.Update("discussion.DISCUSSION_SAVE_U", discussion);

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

		public void Common(Discussion discussion)
		{
			int groupNo = 0;
			int teamNo = 0;

			// 토론 그룹 추가
			groupNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("discussion.DISCUSSION_GROUP_SAVE_C", discussion));

			// 토론 팀, 팀멤버 추가
			discussion.GroupNo = discussion.CourseGroupNo;
			IList<GroupTeam> GroupTeamList = DaoFactory.Instance.QueryForList<GroupTeam>("team.GROUP_TEAM_SELECT_L", discussion);

			discussion.GroupNo = groupNo;

			foreach (var item in GroupTeamList)
			{
				Hashtable paramHash = new Hashtable();
				paramHash.Add("TeamNo", item.TeamNo);
				paramHash.Add("GroupNo", discussion.GroupNo);
				paramHash.Add("CourseGroupNo", discussion.CourseGroupNo);

				teamNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("discussion.DISCUSSION_GROUP_TEAM_SAVE_C", paramHash));

				paramHash.Add("DiscussionTeamNo", teamNo);

				DaoFactory.Instance.Update("discussion.DISCUSSION_GROUP_TEAM_MEMBER_SAVE_C", paramHash);
			}
		}
	}
}
