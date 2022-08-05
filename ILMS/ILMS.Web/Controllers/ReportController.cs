using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Linq;
using System.Web.Mvc;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("Report")]
	public class ReportController : LectureRoomBaseController
	{
		public TeamProjectService teamProjectSvc { get; set; }

		[Route("List/{param1}")]
		public ActionResult List(int param1)
		{
			//param1 : CourseNo 강좌번호
			HomeworkViewModel vm = new HomeworkViewModel();
			Output output = new Output("L");

			output.CourseNo = param1;
			output.UserNo = sessionManager.UserNo;

			vm.OutputList = baseSvc.GetList<Output>("homework.OUTPUT_SELECT_L", output);

			return View(vm);
		}

		#region 팀프로젝트 등록

		[Route("Write/{param1}")]
		[Route("Write/{param1}/{param2}/{param3}")]
		public ActionResult Write(int param1, int? param2, Int64? param3)
		{
			//param1 : CourseNo 강좌번호, param2 : isOutput 산출물, param3 : ProjectNo 프로젝트번호
			TeamProjectViewModel vm = new TeamProjectViewModel();

			vm.IsOutput = param2 ?? 0; //산출물여부

			// 공통코드 (계획서/결과보고서/주간보고서/회의록/발표자료)
			Code code = new Code("A");
			code.ClassCode = "SMTP";
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			// 팀편성 그룹 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			paramHash.Add("DeleteYesNo", "N");
			vm.GroupList = baseSvc.GetList<Group>("team.GROUP_SELECT_L", paramHash);

			// 수정 조회
			if (param3 != null)
			{
				// 팀프로젝트 상세보기
				TeamProject paramTeamProject = new TeamProject(param1, param3);
				vm.TeamProject = baseSvc.Get<TeamProject>("teamProject.TEAMPROJECT_SELECT_S", paramTeamProject);

				if (vm.TeamProject.FileGroupNo > 0)
				{
					File file = new File();
					file.RowState = "L";
					file.FileGroupNo = vm.TeamProject.FileGroupNo ?? 0;
					if (vm.TeamProject.FileGroupNo != null)
						vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					else
						vm.FileList = null;
				}
			}

			return View(vm);
		}

		[HttpPost]
		[Route("Write/{param1}/{param2}")]
		public ActionResult Write(TeamProjectViewModel vm)
		{
			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long? fileGroupNo = 0;

			#region "파일관련"
			if (Request.Files.Count > 1)
			{
				fileGroupNo = FileUpload(vm.TeamProject.RowState ?? "C", "TeamProject", vm.TeamProject.FileGroupNo, "TeamProjectFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}
			#endregion "파일관련"

			if (fileSuccess)
			{
				// 파일 업로드 성공 시 게시물 저장
				vm.TeamProject.CreateUserNo = sessionManager.UserNo;
				vm.TeamProject.UpdateUserNo = sessionManager.UserNo;
				vm.TeamProject.DeleteYesNo = "N";
				vm.TeamProject.LeaderYesNo = "Y";
				vm.TeamProject.EstimationOpenYesNo = "N";
				vm.TeamProject.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo;

				if (vm.TeamProject.ProjectNo == 0)
				{
					teamProjectSvc.TeamProjectInsert(vm.TeamProject);
				}
				else
				{
					teamProjectSvc.TeamProjectUpdate(vm.TeamProject);
				}
			}
			return Redirect(vm.TeamProject.IsOutput == 0 ? string.Format("/TeamProject/ListTeacher/{0}", vm.TeamProject.CourseNo) : string.Format("/Report/List/{0}", vm.TeamProject.CourseNo));
		}

		#endregion 팀프로젝트 등록

		#region 팀프로젝트 상세보기

		[Route("Detail/{param1}/{param2}")]
		[Route("Detail/{param1}/{param2}/{param3}")]
		public ActionResult Detail(int param1, Int64 param2, string param3)
		{
			//param1 : CourseNo 강좌번호, param2 : ProjectNo 프로젝트번호, param3 : SortType 정렬타입
			TeamProjectViewModel vm = new TeamProjectViewModel();

			// 팀프로젝트 상세보기
			TeamProject paramTeamProject = new TeamProject(param1, param2);
			vm.TeamProject = baseSvc.Get<TeamProject>("teamProject.TEAMPROJECT_SELECT_S", paramTeamProject);

			// 팀프로젝트 첨부파일 조회
			File file = new File();
			file.RowState = "L";
			file.FileGroupNo = vm.TeamProject.FileGroupNo ?? 0;
			if (vm.TeamProject.FileGroupNo != null)
			{
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
			}
			else
			{
				vm.FileList = null;
			}

			// 팀프로젝트 제출 학생 보기
			TeamProjectSubmit paramTeamProjectSubmit = new TeamProjectSubmit(param1, param2);
			vm.TeamProjectSubmitList = baseSvc.GetList<TeamProjectSubmit>("teamProject.TEAMPROJECT_SUBMIT_SELECT_L", paramTeamProjectSubmit);

			// 정렬 (성명/학번순)
			if (!string.IsNullOrEmpty(param3))
			{
				if (param3.Equals("UserID"))
				{
					vm.TeamProjectSubmitList = vm.TeamProjectSubmitList.OrderBy(x => x.UserID).ToList();
					vm.SortType = "HangulName";
				}
				else
				{
					vm.TeamProjectSubmitList = vm.TeamProjectSubmitList.OrderBy(x => x.HangulName).ToList();
					vm.SortType = "UserID";
				}
			}

			return View(vm);
		}

		[HttpPost]
		[Route("AllFeedback")]
		public JsonResult AllFeedback(Int64 projectNo, string feedback)
		{
			// 일괄 평가
			TeamProjectViewModel vm = new TeamProjectViewModel();

			int cnt = 0;

			foreach (var item in feedback.Split(';'))
			{
				Hashtable paramHash = new Hashtable();
				paramHash.Add("ProjectNo", projectNo);
				paramHash.Add("TeamNo", Convert.ToInt32(item.Split(':')[0]));
				paramHash.Add("Score", Convert.ToInt32(item.Split(':')[1] == "" ? 0 : Convert.ToInt32(item.Split(':')[1])));
				paramHash.Add("Feedback", item.Split(':')[2]);
				paramHash.Add("UpdateUserNo", sessionManager.UserNo);

				 cnt += baseSvc.Save("teamProject.TEAMPROJECT_SUBMIT_SAVE_A", paramHash);
			}

			return Json(cnt);

		}

		[HttpPost]
		[Route("Feedback")]
		public JsonResult Feedback(Int64 projectNo, string feedback)
		{
			// 개별 평가
			TeamProjectViewModel vm = new TeamProjectViewModel();

			int cnt = 0;

			foreach (var item in feedback.Split(';'))
			{
				Hashtable paramHash = new Hashtable();
				paramHash.Add("ProjectNo", projectNo);
				paramHash.Add("TeamNo", Convert.ToInt32(item.Split(':')[0]));
				paramHash.Add("SubmitNo", Convert.ToInt32(item.Split(':')[1]));
				paramHash.Add("SubmitUserNo", Convert.ToInt32(item.Split(':')[2]));
				paramHash.Add("Score", item.Split(':')[3]);
				paramHash.Add("UpdateUserNo", sessionManager.UserNo);

				cnt += baseSvc.Save("teamProject.TEAMPROJECT_SUBMIT_SAVE_B", paramHash);
			}

			return Json(cnt);

		}

		[HttpPost]
		[Route("Delete")]
		public JsonResult Delete(int courseNo, Int64 projectNo)
		{
			TeamProject teamProject = new TeamProject();

			teamProject.CourseNo = courseNo;
			teamProject.ProjectNo = projectNo;
			teamProject.UpdateUserNo = sessionManager.UserNo;
			teamProject.DeleteYesNo = "Y";

			return Json(baseSvc.Save("teamProject.TEAMPROJECT_SAVE_D", teamProject));
		}

		[HttpPost]
		[Route("EstimationEdit")]
		public JsonResult EstimationEdit(int courseNo, Int64 projectNo)
		{
			// 개별 평가
			TeamProjectViewModel vm = new TeamProjectViewModel();

			// 팀프로젝트 평가 공개 여부 수정
			TeamProject teamProject = new TeamProject();

			teamProject.CourseNo = courseNo;
			teamProject.ProjectNo = projectNo;
			teamProject.UpdateUserNo = sessionManager.UserNo;

			return Json(baseSvc.Save("teamProject.TEAMPROJECT_SAVE_A", teamProject));
		}

		#endregion 팀프로젝트 상세보기

		#region 팀원보기

		[HttpPost]
		[Route("GroupTeam")]
		public JsonResult GroupTeam(int courseNo, Int64 groupNo)
		{
			TeamProjectViewModel vm = new TeamProjectViewModel();

			// 그룹명 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", courseNo);
			paramHash.Add("GroupNo", groupNo);

			vm.TeamProjectTeam = baseSvc.Get<TeamProject>("teamProject.GROUP_TEAM_SELECT_B", paramHash);

			return Json(vm.TeamProjectTeam);
		}

		[HttpPost]
		[Route("GroupTeamList")]
		public JsonResult GroupTeamList(int courseNo, Int64 groupNo)
		{
			TeamProjectViewModel vm = new TeamProjectViewModel();

			// 팀 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", courseNo);
			paramHash.Add("GroupNo", groupNo);
			
			vm.TeamProjectTeamList = baseSvc.GetList<TeamProject>("teamProject.GROUP_TEAM_SELECT_B", paramHash);

			return Json(vm.TeamProjectTeamList);
		}

		[HttpPost]
		[Route("GroupTeamMebmerList")]
		public JsonResult GroupTeamMemberList(int courseNo, Int64 groupNo, Int64 teamNo)
		{
			TeamProjectViewModel vm = new TeamProjectViewModel();

			// 팀 멤버 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("TeamNo", teamNo);
			paramHash.Add("GroupNo", groupNo);
			paramHash.Add("CourseNo", courseNo);

			vm.TeamProjectTeamMemberList = baseSvc.GetList<TeamProject>("teamProject.GROUP_TEAM_MEMBER_SELECT_B", paramHash);

			return Json(vm.TeamProjectTeamMemberList);
		}

		#endregion 팀원보기

		#region 학생 제출

		[Route("Submit/{param1}")]
		public ActionResult Submit(int param1, Int64 param2)
		{
			//param1 : CourseNo 강좌번호, param2 : ProjectNo 프로젝트번호
			TeamProjectViewModel vm = new TeamProjectViewModel();

			// 팀프로젝트 상세보기
			TeamProject paramTeamProject = new TeamProject(param1, param2);
			vm.TeamProject = baseSvc.Get<TeamProject>("teamProject.TEAMPROJECT_SELECT_S", paramTeamProject);

			// 파일조회
			File file = new File();
			file.RowState = "L";
			file.FileGroupNo = vm.TeamProject.FileGroupNo ?? 0;
			if (vm.TeamProject.FileGroupNo != null)
			{
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
			}
			else
			{
				vm.FileList = null;
			}

			// 팀프로젝트 제출내용 상세보기
			TeamProjectSubmit paramTeamProjectSubmit = new TeamProjectSubmit(param1, param2);
			paramTeamProjectSubmit.UserNo = sessionManager.UserNo;
			vm.TeamProjectSubmit = baseSvc.Get<TeamProjectSubmit>("teamProject.TEAMPROJECT_SUBMIT_SELECT_S", paramTeamProjectSubmit);

			// 파일조회
			if (vm.TeamProjectSubmit != null)
			{
				file = new File();
				file.RowState = "L";
				file.FileGroupNo = vm.TeamProjectSubmit.FileGroupNo ?? 0;
				if (vm.TeamProjectSubmit.FileGroupNo != null)
				{
					vm.FileCopyList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
				}
				else
				{
					vm.FileCopyList = null;
				}
			}
		
			return View(vm);
		}

		[HttpPost]
		[Route("Submit/{param1}")]
		public ActionResult Submit(TeamProjectViewModel vm)
		{

			#region 파일관련

			long? fileGroupNo = 0;

			if (vm.TeamProjectSubmit.FileGroupNo > 0 && Request.Files["TeamProjectSubmitFile"] == null)
			{
				fileGroupNo = vm.TeamProjectSubmit.FileGroupNo;
			}
			else
			{
				if (Request.Files["TeamProjectSubmitFile"].ContentLength.Equals(0))
				{
					fileGroupNo = vm.TeamProjectSubmit.FileGroupNo;
				}
				else
				{
					fileGroupNo = FileUpload("C", "TeamProjectSubmit", vm.TeamProjectSubmit.FileGroupNo, "TeamProjectSubmitFile", Request.Files["TeamProjectSubmitFile"]);

				}
			}

			#endregion 파일관련

			vm.TeamProjectSubmit.SubmitUserNo = Convert.ToInt32(sessionManager.UserNo);
			vm.TeamProjectSubmit.CreateUserNo = sessionManager.UserNo;
			vm.TeamProjectSubmit.UpdateUserNo = sessionManager.UserNo;
			vm.TeamProjectSubmit.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo;

			// 팀리더 과제 제출
			if (vm.TeamProjectSubmit.SubmitNo.Equals(0))
			{
				baseSvc.Save("teamProject.TEAMPROJECT_SUBMIT_SAVE_C", vm.TeamProjectSubmit);
			}
			else
			{
				baseSvc.Save("teamProject.TEAMPROJECT_SUBMIT_SAVE_U", vm.TeamProjectSubmit);
			}

			return Redirect(vm.TeamProject.IsOutput == 0 ? string.Format("/TeamProject/ListStudent/{0}", vm.TeamProjectSubmit.CourseNo) : string.Format("/Report/List/{0}", vm.TeamProjectSubmit.CourseNo));
		}

		#endregion 학생 제출

	}
}