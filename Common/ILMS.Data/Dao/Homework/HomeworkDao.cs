using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace ILMS.Data.Dao
{
	public class HomeworkDao
	{
		public int HomeworkInsert(Homework homework)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				if(homework.OrgGroupNo > 0)
				{
					
					Hashtable ht = new Hashtable();
					ht.Add("ROWSTATE", "B");
					ht.Add("GroupNo", homework.OrgGroupNo);
					ht.Add("CreateUserNo", homework.CreateUserNo);

					int groupNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("homework.GROUP_SAVE_B", ht));
					homework.GroupNo = groupNo;

					ht = new Hashtable();
					ht.Add("ROWSTATE", "A");
					ht.Add("GroupNo", homework.OrgGroupNo);

					IList<GroupTeam> GroupTeamList = DaoFactory.Instance.QueryForList<GroupTeam>("homework.GROUP_TEAM_SELECT_A", ht);

					foreach(var item in GroupTeamList)
					{
						ht = new Hashtable();
						ht.Add("ROWSTATE", "A");
						ht.Add("TeamNo", item.TeamNo);
						ht.Add("GroupNo", homework.GroupNo);
						ht.Add("CourseNo", homework.OrgGroupNo); //teaminsert의 OrgGroupNo = CourseNo로 [TODO : 추후 조율해서 변경]

						int newTeamNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("homework.GROUP_TEAM_SAVE_A", ht));

						ht = new Hashtable();
						ht.Add("ROWSTATE", "B");
						ht.Add("GroupNo", homework.OrgGroupNo);
						ht.Add("TeamNo", item.TeamNo);
						ht.Add("TeamMemberNo", newTeamNo); //teammemberinsert의 newTeamNo = TeamMemberNo로 [TODO : 추후 조율해서 변경]

						DaoFactory.Instance.Update("homework.GROUP_TEAM_MEMBER_SAVE_B", ht);
					}
				}

                if ((homework.HomeworkType.Equals("CHWT002") || homework.HomeworkType.Equals("CHWT003")) && !string.IsNullOrEmpty(homework.ExamKind))
                {
                    homework.InningNo = Convert.ToInt32(homework.ExamKind.Split('|')[1]);
                    homework.ExamKind = homework.ExamKind.Split('|')[0];
                }

                int homeworkno = Convert.ToInt32(DaoFactory.Instance.QueryForObject("homework.HOMEWORK_SAVE_C", homework));

                string[] targetUserNo = Enumerable.Empty<string>().ToArray();
                string[] exceptUserNo = Enumerable.Empty<string>().ToArray();

                if (homework.HomeworkType.Equals("CHWT001") || homework.HomeworkType.Equals("CHWT002") || homework.HomeworkType.Equals("CHWT004"))
                {
                    HomeworkSubmit homeworksubmit = new HomeworkSubmit("L");
                    homeworksubmit.CourseNo = homework.CourseNo;
                    IList<HomeworkSubmit> homeworkSubmitList = DaoFactory.Instance.QueryForList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit);

                    targetUserNo = homeworkSubmitList.Select(x => x.UserNo.ToString()).ToArray();
                }
                else if (homework.HomeworkType.Equals("CHWT003") && (string.IsNullOrEmpty(homework.MemberYesList) && string.IsNullOrEmpty(homework.MemberNoList)))
                {
                    HomeworkSubmit homeworksubmit = new HomeworkSubmit("A");
                    homeworksubmit.CourseNo = homework.CourseNo;
                    homeworksubmit.Week = homework.Week;
                    homeworksubmit.HomeworkNo = homework.HomeworkNo;

                    IList<HomeworkSubmit> homeworkSubmitList = DaoFactory.Instance.QueryForList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_A", homeworksubmit);

                    exceptUserNo = homeworkSubmitList.Select(x => x.UserNo.ToString()).ToArray();
                }
                else
                {
                    targetUserNo = homework.MemberYesList.Length > 0 ? homework.MemberYesList.Split('|') : Enumerable.Empty<string>().ToArray();
                    exceptUserNo = homework.MemberNoList.Length > 0 ? homework.MemberNoList.Split('|') : Enumerable.Empty<string>().ToArray();
                }

				for (int i = 0; i < targetUserNo.Length; i++)
				{
					HomeworkSubmit homeworksubmit = new HomeworkSubmit();

					homeworksubmit.RowState = "C";
					homeworksubmit.CourseNo = homework.CourseNo;
					homeworksubmit.DeleteYesNo = "N";
					homeworksubmit.SubmitUserNo = Convert.ToInt32(targetUserNo[i]);
					homeworksubmit.HomeworkNo = Convert.ToInt32(homeworkno);
					homeworksubmit.CreateUserNo = homework.CreateUserNo;
					homeworksubmit.TargetYesNo = "Y";
					rsCount += DaoFactory.Instance.Update("homework.HOMEWORK_SUBMIT_SAVE_C", homeworksubmit);

					if (homework.HomeworkType.Equals("CHWT002") || homework.HomeworkType.Equals("CHWT003")) //CHWT002 : 과제형시험, CHWT003 : 시험대체형과제
					{
                        string strExamType = string.Empty;

                        if (homework.HomeworkType.Equals("CHWT002"))
                        {
                            switch (homework.SubmitType)
                            {
                                case "CHST001": strExamType = "EXTP002"; break;
                                case "CHST002": strExamType = "EXTP001"; break;
                                case "CHST003": strExamType = "EXTP007"; break;
                                default:
                                    break;
                            }
                        }
                        else
                        {
                            switch (homework.SubmitType)
                            {
                                case "CHST001": strExamType = "EXTP004"; break;
                                case "CHST002": strExamType = "EXTP003"; break;
                                case "CHST003": strExamType = "EXTP008"; break;
                                default:
                                    break;
                            }
                        }

						Examinee examinee = new Examinee("G");

						examinee.ExamineeUserNo = Convert.ToInt32(targetUserNo[i]);
						examinee.ExamNo = Convert.ToInt32(homeworkno);
						examinee.ExamItem = strExamType;
						examinee.SubmitType = homework.ExamKind;
						examinee.Week = homework.Week;
						examinee.CourseNo = homework.CourseNo;
						examinee.InningNo = homework.InningNo;
						examinee.CreateUserNo = homework.UpdateUserNo;

						DaoFactory.Instance.Update("exam.EXAMINEE_SAVE_G", examinee); 

                    }
				}

				for (int i = 0; i < exceptUserNo.Length; i++)
				{
					HomeworkSubmit homeworksubmit = new HomeworkSubmit();

					homeworksubmit.RowState = "C";
					homeworksubmit.CourseNo = homework.CourseNo;
					homeworksubmit.DeleteYesNo = "N";
					homeworksubmit.SubmitUserNo = Convert.ToInt32(exceptUserNo[i]);
                    homeworksubmit.HomeworkNo = homeworkno;
					homeworksubmit.CreateUserNo = homework.CreateUserNo;
					homeworksubmit.TargetYesNo = "N";
					rsCount += DaoFactory.Instance.Update("homework.HOMEWORK_SUBMIT_SAVE_C", homeworksubmit);
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

		public int HomeworkUpdate(Homework homework)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();
			
			try
			{
				//그룹 관련 업데이트 구현
				if (!homework.GroupNo.Equals(homework.OrgGroupNo))
				{
					Hashtable ht = new Hashtable();
					ht.Add("ROWSTATE", "B");
					ht.Add("GroupNo", homework.OrgGroupNo);
					ht.Add("CreateUserNo", homework.CreateUserNo);

					int groupNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("homework.GROUP_SAVE_B", ht));
					homework.GroupNo = groupNo;

					ht = new Hashtable();
					ht.Add("ROWSTATE", "A");
					ht.Add("GroupNo", homework.OrgGroupNo);

					IList<GroupTeam> GroupTeamList = DaoFactory.Instance.QueryForList<GroupTeam>("homework.GROUP_TEAM_SELECT_A", ht);

					foreach (var item in GroupTeamList)
					{
						ht = new Hashtable();
						ht.Add("ROWSTATE", "A");
						ht.Add("TeamNo", item.TeamNo);
						ht.Add("GroupNo", homework.GroupNo);
						ht.Add("CourseNo", homework.OrgGroupNo); //teaminsert의 OrgGroupNo = CourseNo로 [TODO : 추후 조율해서 변경]

						int newTeamNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("homework.GROUP_TEAM_SAVE_A", ht));

						ht = new Hashtable();
						ht.Add("ROWSTATE", "B");
						ht.Add("GroupNo", homework.OrgGroupNo);
						ht.Add("TeamNo", item.TeamNo);
						ht.Add("TeamMemberNo", newTeamNo); //teammemberinsert의 newTeamNo = TeamMemberNo로 [TODO : 추후 조율해서 변경]

						DaoFactory.Instance.Update("homework.GROUP_TEAM_MEMBER_SAVE_B", ht);
					}
				}

				if ((homework.HomeworkType.Equals("CHWT002") || homework.HomeworkType.Equals("CHWT003")) && !string.IsNullOrEmpty(homework.ExamKind))
				{
					homework.InningNo = Convert.ToInt32(homework.ExamKind.Split('|')[1]);
					homework.ExamKind = homework.ExamKind.Split('|')[0];
				}

				DaoFactory.Instance.Update("homework.HOMEWORK_SAVE_U", homework);

				string[] targetUserNo = Enumerable.Empty<string>().ToArray();
				string[] exceptUserNo = Enumerable.Empty<string>().ToArray();

				if (homework.HomeworkType.Equals("CHWT003") && (!string.IsNullOrEmpty(homework.MemberYesList) && !string.IsNullOrEmpty(homework.MemberNoList)))
				{
					targetUserNo = homework.MemberYesList.Length > 0 ? homework.MemberYesList.Split('|') : Enumerable.Empty<string>().ToArray();
					exceptUserNo = homework.MemberNoList.Length > 0 ? homework.MemberNoList.Split('|') : Enumerable.Empty<string>().ToArray();
				}
				else
				{
					HomeworkSubmit homeworksubmit = new HomeworkSubmit("L");
					homeworksubmit.CourseNo = homework.CourseNo;
					IList<HomeworkSubmit> homeworkSubmitList = DaoFactory.Instance.QueryForList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit);

					targetUserNo = homeworkSubmitList.Select(x => x.UserNo.ToString()).ToArray();
				}

				for (int i = 0; i < targetUserNo.Length; i++)
				{
					HomeworkSubmit homeworksubmit = new HomeworkSubmit();

					homeworksubmit.RowState = "U";
					homeworksubmit.CourseNo = homework.CourseNo;
					homeworksubmit.DeleteYesNo = "N";
					homeworksubmit.SubmitUserNo = Convert.ToInt32(targetUserNo[i]);
					homeworksubmit.HomeworkNo = homework.HomeworkNo;
					homeworksubmit.UpdateUserNo = homework.UpdateUserNo;
					homeworksubmit.TargetYesNo = "Y";
					rsCount += DaoFactory.Instance.Update("homework.HOMEWORK_SUBMIT_SAVE_U", homeworksubmit);

					if (homework.HomeworkType.Equals("CHWT002") || homework.HomeworkType.Equals("CHWT003")) //CHWT002 : 과제형시험, CHWT003 : 시험대체형과제
					{
						string strExamType = string.Empty;

						if (homework.HomeworkType.Equals("CHWT002"))
						{
							switch (homework.SubmitType)
							{
								case "CHST001": strExamType = "EXTP002"; break;
								case "CHST002": strExamType = "EXTP001"; break;
								case "CHST003": strExamType = "EXTP007"; break;
								default:
									break;
							}
						}
						else
						{
							switch (homework.SubmitType)
							{
								case "CHST001": strExamType = "EXTP004"; break;
								case "CHST002": strExamType = "EXTP003"; break;
								case "CHST003": strExamType = "EXTP008"; break;
								default:
									break;
							}
						}

						Examinee examinee = new Examinee("G");

						examinee.ExamineeUserNo = Convert.ToInt32(targetUserNo[i]);
						examinee.ExamNo = Convert.ToInt32(homework.HomeworkNo);
						examinee.ExamItem = strExamType;
						examinee.SubmitType = homework.ExamKind;
						examinee.Week = homework.Week;
						examinee.CourseNo = homework.CourseNo;
						examinee.InningNo = homework.InningNo;
						examinee.CreateUserNo = homework.UpdateUserNo;

						DaoFactory.Instance.Update("exam.EXAMINEE_SAVE_G", examinee);

					}
				}

				for (int i = 0; i < exceptUserNo.Length; i++)
				{
					HomeworkSubmit homeworksubmit = new HomeworkSubmit();

					homeworksubmit.RowState = "U";
					homeworksubmit.CourseNo = homework.CourseNo;
					homeworksubmit.DeleteYesNo = "N";
					homeworksubmit.SubmitUserNo = Convert.ToInt32(exceptUserNo[i]);
					homeworksubmit.HomeworkNo = homework.HomeworkNo;
					homeworksubmit.CreateUserNo = homework.CreateUserNo;
					homeworksubmit.TargetYesNo = "N";
					rsCount += DaoFactory.Instance.Update("homework.HOMEWORK_SUBMIT_SAVE_U", homeworksubmit);
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

		public int HomeworkSubmitUpdate(HomeworkSubmit homeworksubmit)
		{
			int rsCount = 0;
			DaoFactory.Instance.BeginTransaction();
			try
			{
				string[] strUserNo = homeworksubmit.UserNoString.Substring(1).Split('|');

				for(int i = 0; i < strUserNo.Length; i++)
				{
					HomeworkSubmit submit = new HomeworkSubmit("U");

					submit.HomeworkNo = homeworksubmit.HomeworkNo;
					submit.CourseNo = homeworksubmit.CourseNo;
					submit.SubmitUserNo = Convert.ToInt32(strUserNo[i]);

					submit.Feedback = homeworksubmit.Feedback;
					submit.Score = homeworksubmit.Score;
					submit.UpdateUserNo = homeworksubmit.UpdateUserNo;

					rsCount += DaoFactory.Instance.Update("homework.HOMEWORK_SUBMIT_SAVE_U", submit);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch(Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}
			return rsCount;
		}

		public int HomeworkCopy(Homework homework)
		{
			int rsCount = 0;
			DaoFactory.Instance.BeginTransaction();

			HomeworkSubmit homeworksubmit = new HomeworkSubmit("B");

			try
			{
				homeworksubmit.HomeworkNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("homework.HOMEWORK_SAVE_A", homework));
				DaoFactory.Instance.Update("homework.HOMEWORK_SUBMIT_SAVE_B", homeworksubmit);
				DaoFactory.Instance.CommitTransaction();

				rsCount = 1000;
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				DaoFactory.Instance.RollBackTransaction();

				rsCount = -1000;
			}

			return rsCount; 
		}

	}
}
