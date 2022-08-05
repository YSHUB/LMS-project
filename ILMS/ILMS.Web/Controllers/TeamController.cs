using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("Team")]
	public class TeamController : LectureRoomBaseController
	{
		public TeamService teamSvc { get; set; }
		
		public CourseService courseSvc { get; set; }

		#region 팀리스트

		[Route("List/{param1}")]
		public ActionResult List(TeamViewModel vm)
		{

			// 그룹 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", ViewBag.Course.CourseNo);
			vm.GroupList = baseSvc.GetList<Group>("team.GROUP_SELECT_L", paramHash);

			vm.GroupNo = vm.GroupNo > 0 ? Convert.ToInt32(vm.Group.GroupNo) : 0;

			// 팀 조회
			Hashtable paramHash2 = new Hashtable();
			paramHash2.Add("GroupNo", vm.Group != null ? vm.Group.GroupNo.ToString() : vm.GroupList.Count.Equals(0) ? "" : vm.GroupList[0].GroupNo.ToString());
			paramHash2.Add("CourseNo", ViewBag.Course.CourseNo);
			vm.GroupTeamList = baseSvc.GetList<GroupTeam>("team.GROUP_TEAM_SELECT_L", paramHash2);

			// 팀 멤버 조회
			Hashtable paramHash3 = new Hashtable();
			paramHash3.Add("TeamNo", vm.GroupTeam == null ? "" : vm.GroupTeam.TeamNo.ToString());
			paramHash3.Add("GroupNo", vm.Group == null ? vm.GroupList.Count.Equals(0) ? "" : vm.GroupList[0].GroupNo.ToString() : vm.Group.GroupNo.Equals(0) ? "" : vm.Group.GroupNo.ToString());
			paramHash3.Add("CourseNo", ViewBag.Course.CourseNo);
			vm.GroupTeamMemberList = baseSvc.GetList<GroupTeamMember>("team.GROUP_TEAM_MEMBER_SELECT_L", paramHash3);

			// 해당 강좌 수강 학생 조회
			Hashtable paramHash4 = new Hashtable();
			paramHash4.Add("CourseNo", ViewBag.Course.CourseNo);
			vm.CourseLectureStudentList = baseSvc.GetList<CourseLecture>("team.COURSE_LECTURE_SELECT_D", paramHash4);

			// 자동 팀편성 공통코드 조회
			Code code = new Code("A", new string[] { "CGCT", "CGST"});
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			return View(vm);
		}

		[HttpPost]
		[Route("TeamList/{param1}/{param2}")]
		public JsonResult TeamList(int courseNo, Int64 groupNo)
		{
			TeamViewModel vm = new TeamViewModel();

			// 팀 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("GroupNo", groupNo);
			paramHash.Add("CourseNo", courseNo);
			vm.GroupTeamList = baseSvc.GetList<GroupTeam>("team.GROUP_TEAM_SELECT_L", paramHash);

			return Json(vm.GroupTeamList);
		}

		[HttpPost]
		[Route("AutoTeamAddSave/{param1}/{param2}")]
		public JsonResult AutoTeamAddSave(int courseNo, int teamMemberCnt, string groupName, string groupType, string orderBy)
		{

			// 해당 강좌 수강 학생 조회
			IList<CourseLecture> courseLectureStudentList = courseSvc.CourseLectureStudentList(courseNo, groupType, orderBy);

			// 자동편성 저장
			Group group = new Group();
			group.GroupName = groupName;
			group.CreateUserNo = sessionManager.UserNo;
			group.CourseNo = courseNo;
			group.GroupType = groupType;

			return Json(teamSvc.AutoTeamAddSave(courseLectureStudentList, group, teamMemberCnt));
		}

		#endregion 팀리스트

		#region 그룹관리

		[Route("Write/{param1}")]
		public ActionResult Write(int param1)
		{
			//param1 : CourseNo 강좌번호
			TeamViewModel vm = new TeamViewModel();

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.GroupList = baseSvc.GetList<Group>("team.GROUP_SELECT_L", paramHash);

			return View(vm);
		}

		[Route("GroupSave/{param1}")]
		public ActionResult GroupSave(TeamViewModel vm)
		{

			// 그룹 저장
			vm.Group.CreateUserNo = sessionManager.UserNo;
			vm.Group.UpdateUserNo = sessionManager.UserNo;
			
			if (vm.Group.RowState.Equals("C"))
			{
				baseSvc.Get<int>("team.GROUP_SAVE_C", vm.Group);
			}
			else
			{
				baseSvc.Get<int>("team.GROUP_SAVE_U", vm.Group);
			}

			return RedirectToAction("Write", new { param1 = vm.Group.CourseNo });
		}

		[HttpPost]
		[Route("GroupDelete/{param1}")]
		public JsonResult GroupDelete(int groupNo)
		{
			// 그룹 삭제
			Hashtable paramHash = new Hashtable();
			paramHash.Add("GroupNo", groupNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);

			return Json(baseSvc.Save("team.GROUP_SAVE_D", paramHash));
		}

		[HttpPost]
		[Route("GroupCopy/{param1}")]
		public JsonResult GroupCopy(int orgGroupNo)
		{
			// 그룹 복제
			return Json(teamSvc.GroupCopy(sessionManager.UserNo, orgGroupNo));
		}

		[HttpPost]
		[Route("ExcelUpload/{param1}")]
		public ActionResult ExcelUpload(TeamViewModel vm)
		{
			// 팀, 멤버 엑셀 업로드
			HttpPostedFileBase f = Request.Files[0];

			string fileName = "";
			string fileNewName = "";
			string fileSize = "";
			string fileType = "";

			if (!Directory.Exists(Server.MapPath("Files/Temp")))
			{
				Directory.CreateDirectory(Server.MapPath("/Files/Temp/"));
			}
			if (f != null && !string.IsNullOrEmpty(f.FileName))
			{
				fileName = f.FileName.Split('\\').Last();
				fileNewName = sessionManager.UserNo.ToString() + "_" + DateTime.Now.ToString("yyyyMMddHHmmssFFF") + "." + f.FileName.Split('.').Last();
				fileSize = f.ContentLength.ToString();
				fileType = f.FileName.Split('.').Last(); //f.ContentType;
				f.SaveAs(Server.MapPath("/Files/Temp/" + fileNewName));
			}

			string connString = string.Empty;
			string systemCheck = string.Empty;

			if (Environment.Is64BitOperatingSystem) systemCheck = "64";
			else systemCheck = "32";

			if (systemCheck.Equals("64"))
			{
				connString = String.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=Excel 12.0 Xml;", Server.MapPath("/Files/Temp/" + fileNewName));
			}
			else
			{
				connString = String.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=Excel 8.0;", Server.MapPath("/Files/Temp/" + fileNewName));
			}

			int teamCnt = 0;
			int teamMemberCnt = 0;
			OleDbConnection oledbConn = new OleDbConnection(connString);

			try
			{
				oledbConn.Open();
				OleDbCommand cmd = new OleDbCommand("SELECT * FROM [Sheet1$]", oledbConn);
				OleDbDataAdapter oleda = new OleDbDataAdapter();
				oleda.SelectCommand = cmd;
				DataSet ds = new DataSet();
				oleda.Fill(ds, "GroupTeam");
				var tempData = from c in ds.Tables[0].AsEnumerable()
							   select c;

			
				string teamName = string.Empty;
				string teamLeader = "N";

				foreach (var item in tempData)
				{
					if (item.Field<object>("팀명") != null)
					{
						string tempTeamName = item.Field<object>("팀명").ToString();

						if (teamName.Equals(tempTeamName))
						{
							GroupTeamMember tempTeamMember = new GroupTeamMember();
							tempTeamMember.GroupNo = vm.Group.GroupNo;
							tempTeamMember.CourseNo = vm.Group.CourseNo;
							tempTeamMember.TeamName = tempTeamName;
							tempTeamMember.UserID = item.Field<object>("학번") == null ? "" : item.Field<object>("학번").ToString();
							tempTeamMember.TeamLeaderYesNo = item.Field<object>("팀장여부") == null ? "" : item.Field<object>("팀장여부").ToString();
							if (tempTeamMember.TeamLeaderYesNo.Equals("Y") && teamLeader.Equals("Y"))
							{
								tempTeamMember.TeamLeaderYesNo = "N";
							}
							baseSvc.Get<int>("team.GROUP_TEAM_MEMBER_SAVE_E", tempTeamMember);
							teamMemberCnt++;
							continue;
						}
						else
						{
							teamLeader = "N";
							GroupTeam tempTeam = new GroupTeam();
							tempTeam.GroupNo = vm.Group.GroupNo;
							tempTeam.CourseNo = vm.Group.CourseNo;
							tempTeam.TeamName = tempTeamName;
							tempTeam.CreateUserNo = Convert.ToInt32(sessionManager.UserNo);
							teamName = tempTeamName;
							baseSvc.Get<int>("team.GROUP_TEAM_SAVE_C", tempTeam);
							teamCnt++;

							GroupTeamMember tempTeamMember = new GroupTeamMember();
							tempTeamMember.GroupNo = vm.Group.GroupNo;
							tempTeamMember.CourseNo = vm.Group.CourseNo;
							tempTeamMember.TeamName = tempTeamName;
							tempTeamMember.UserID = item.Field<object>("학번") == null ? "" : item.Field<object>("학번").ToString();
							tempTeamMember.TeamLeaderYesNo = item.Field<object>("팀장여부") == null ? "" : item.Field<object>("팀장여부").ToString();
							if (tempTeamMember.TeamLeaderYesNo.Equals("Y"))
							{
								tempTeamMember.TeamLeaderYesNo = "Y";
							}
							baseSvc.Get<int>("team.GROUP_TEAM_MEMBER_SAVE_E", tempTeamMember);
							teamMemberCnt++;
						}
					}
				}
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
			}
			finally
			{
				oledbConn.Close();
			}

			return RedirectToAction(String.Format("Write/{0}", vm.Group.CourseNo));
			//return View(teamCnt.ToString() + "." + teamMemberCnt.ToString());
		}

		[Route("TeamSave/{param1}")]
		public JsonResult TeamSave(int courseNo, Int64 groupNo, Int64? teamNo, string teamName, string rowState)
		{
			// 팀 저장
			Hashtable paramTeam = new Hashtable();
			paramTeam.Add("GroupNo", groupNo);
			paramTeam.Add("CourseNo", courseNo);
			paramTeam.Add("TeamName", teamName);
			paramTeam.Add("CreateUserNo", sessionManager.UserNo);
			paramTeam.Add("UpdateUserNo", sessionManager.UserNo);

			if (rowState.Equals("C"))
			{
				baseSvc.Get<int>("team.GROUP_TEAM_SAVE_C", paramTeam);
			}
			else
			{
				paramTeam.Add("TeamNo", teamNo);
				baseSvc.Get<int>("team.GROUP_TEAM_SAVE_U", paramTeam);
			}

			return Json(paramTeam);
		}

		[HttpPost]
		[Route("TeamDelete/{param1}")]
		public JsonResult TeamDelete(Int64 teamNo)
		{
			// 팀 삭제
			Hashtable paramTeam = new Hashtable();
			paramTeam.Add("TeamNo", teamNo);
			paramTeam.Add("UpdateUserNo", sessionManager.UserNo);

			return Json(baseSvc.Save("team.GROUP_TEAM_SAVE_D", paramTeam));
		}

		[HttpPost]
		[Route("TeamMemberList/{param1}/{param2}/{param3}")]
		public JsonResult TeamMemberList(int courseNo, Int64 groupNo, Int64 teamNo)
		{
			TeamViewModel vm = new TeamViewModel();

			// 팀멤버 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("TeamNo", teamNo);
			paramHash.Add("GroupNo", groupNo);
			paramHash.Add("CourseNo", courseNo);
			vm.GroupTeamMemberList = baseSvc.GetList<GroupTeamMember>("team.GROUP_TEAM_MEMBER_SELECT_L", paramHash);

			return Json(vm.GroupTeamMemberList);
		}

		[HttpPost]
		[Route("TeamNotMemberList/{param1}/{param2}/{param3}")]
		public JsonResult TeamNotMemberList(int courseNo, Int64 groupNo, string sortType)
		{
			TeamViewModel vm = new TeamViewModel();

			// 미배정된 학생 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("GroupNo", groupNo);
			paramHash.Add("CourseNo", courseNo);
			vm.GroupTeamNotMemberList = baseSvc.GetList<GroupTeamMember>("team.GROUP_TEAM_MEMBER_SELECT_A", paramHash).OrderBy(x => x.UserID).ToList();

			if (!string.IsNullOrEmpty(sortType))
			{
				if (sortType.Equals("AssignName"))
				{
					vm.GroupTeamNotMemberList = vm.GroupTeamNotMemberList.OrderBy(x => x.AssignName).ToList();
				} else if (sortType.Equals("HangulName"))
				{
					vm.GroupTeamNotMemberList = vm.GroupTeamNotMemberList.OrderBy(x => x.HangulName).ToList();
				} else
				{
					vm.GroupTeamNotMemberList = vm.GroupTeamNotMemberList.OrderBy(x => x.UserID).ToList();
				}
			}


			return Json(vm.GroupTeamNotMemberList);
		}

		[HttpPost]
		[Route("TeamMemberDelete/{param1}")]
		public JsonResult TeamMemberDelete(Int64 teamMemberNo)
		{
			// 미배정된 학생 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("TeamMemberNo", teamMemberNo);
			
			return Json(baseSvc.Get<int>("team.GROUP_TEAM_MEMBER_SAVE_D", paramHash));
		}

		[HttpPost]
		[Route("TeamLeaderUpdate/{param1}/{param2}")]
		public JsonResult TeamLeaderUpdate(Int64 teamNo, Int64 teamMemberNo)
		{
			// 미배정된 학생 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("TeamNo", teamNo);
			paramHash.Add("TeamMemberNo", teamMemberNo);

			return Json(baseSvc.Get<int>("team.GROUP_TEAM_MEMBER_SAVE_U", paramHash));
		}

		[HttpPost]
		[Route("TeamMemberSave/{param1}/{param2}/{param3}/{param4}")]
		public JsonResult TeamMemberSave(int courseNo, Int64 groupNo, Int64 teamNo, Int64 teamMemberUserNo)
		{
			// 미배정된 학생 팀원 추가
			Hashtable paramHash = new Hashtable();
			paramHash.Add("TeamMemberUserNo", teamMemberUserNo);
			paramHash.Add("TeamNo", teamNo);
			paramHash.Add("GroupNo", groupNo);
			paramHash.Add("CourseNo", courseNo);
			paramHash.Add("TeamLeaderYesNo", "N");

			return Json(baseSvc.Get<int>("team.GROUP_TEAM_MEMBER_SAVE_C", paramHash));
		}

		#endregion 그룹관리

		#region 팀편성보기

		[HttpPost]
		[Route("GroupTeam")]
		public JsonResult GroupTeam(int courseNo, Int64 groupNo)
		{
			TeamViewModel vm = new TeamViewModel();

			// 그룹명 조회
			Hashtable paramHash3 = new Hashtable();
			paramHash3.Add("RowState", "L");
			paramHash3.Add("CourseNo", courseNo);
			paramHash3.Add("GroupNo", groupNo);

			vm.GroupTeam = baseSvc.Get<GroupTeam>("team.GROUP_TEAM_SELECT_L", paramHash3);

			return Json(vm.GroupTeam);
		}

		[HttpPost]
		[Route("GroupTeamList")]
		public JsonResult GroupTeamList(int courseNo, Int64 groupNo)
		{
			TeamViewModel vm = new TeamViewModel();

			// 팀 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("RowState", "L");
			paramHash.Add("GroupNo", groupNo);
			paramHash.Add("CourseNo", courseNo);

			vm.GroupTeamList = baseSvc.GetList<GroupTeam>("team.GROUP_TEAM_SELECT_L", paramHash);

			return Json(vm.GroupTeamList);
		}

		[HttpPost]
		[Route("GroupTeamMebmerList")]
		public JsonResult GroupTeamMemberList(int courseNo, Int64 groupNo, Int64 teamNo)
		{
			TeamViewModel vm = new TeamViewModel();

			// 팀 멤버 조회
			Hashtable paramHash2 = new Hashtable();
			paramHash2.Add("RowState", "L");
			paramHash2.Add("TeamNo", teamNo);
			paramHash2.Add("GroupNo", groupNo);
			paramHash2.Add("CourseNo", courseNo);

			vm.GroupTeamMemberList = baseSvc.GetList<GroupTeamMember>("team.GROUP_TEAM_MEMBER_SELECT_L", paramHash2);

			return Json(vm.GroupTeamMemberList);
		}

		#endregion 팀편성보기
	}
}