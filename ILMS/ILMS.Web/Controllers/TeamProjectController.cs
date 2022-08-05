using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("TeamProject")]
	public class TeamProjectController : LectureRoomBaseController
	{
		[Route("ListTeacher/{param1}")]
		public ActionResult ListTeacher(int param1)
		{
			//param1 : CourseNo 강좌번호
			TeamProjectViewModel vm = new TeamProjectViewModel();

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.TeamProjectList = baseSvc.GetList<TeamProject>("teamProject.TEAMPROJECT_SELECT_L", paramHash);

			return View(vm);
		}

		[Route("ListStudent/{param1}")]
		public ActionResult ListStudent(int param1)
		{
			//param1 : CourseNo 강좌번호
			TeamProjectViewModel vm = new TeamProjectViewModel();

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			paramHash.Add("UserNo", sessionManager.UserNo);
			vm.TeamProjectList = baseSvc.GetList<TeamProject>("teamProject.TEAMPROJECT_SELECT_A", paramHash);

			return View(vm);

		}

		#region 팀프로젝트 관리자

		[AuthorFilter(IsAdmin = true)]
		[Route("ListAdmin/{param1}")]
		public ActionResult ListAdmin(TeamProjectViewModel vm, int param1)
		{
			// param1 : ProgramNo 프로그램번호(1:정규과정, 2:MOOC)

			// 프로그램과정, 학기 조회
			vm.ProgramList = baseSvc.GetList<TeamProject>("teamProject.PROGRAM_SELECT_L", new TeamProject("L"));
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			// 페이징
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 프로젝트 리스트 조회
			if (vm.TeamProject == null)
			{
				vm.TeamProject = new TeamProject();
				vm.TeamProject.ProgramNo = vm.UnivYN().Equals("Y") ? param1 : 2;
				vm.TeamProject.TermNo = Convert.ToInt32(Request.QueryString["TermNo"]);
			}

			TeamProject teamProject = new TeamProject();
			teamProject.TermNo = vm.TeamProject.TermNo > 0 ? vm.TeamProject.TermNo : vm.TermList.Count > 0 ? vm.TermList[0].TermNo : 0;
			teamProject.ProgramNo = vm.UnivYN().Equals("Y") ? vm.TeamProject.ProgramNo : 2;
			
			
			teamProject.SubjectName = !string.IsNullOrEmpty(vm.SearchText) ? vm.SearchText : null;
			teamProject.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) -1)) + 1 : 1;
			teamProject.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.TeamProjectList = baseSvc.GetList<TeamProject>("teamProject.TEAMPROJECT_SELECT_B", teamProject);
			vm.PageTotalCount = vm.TeamProjectList.Count > 0 ? vm.TeamProjectList[0].TotalCount : 0;

			if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "TeamProject.TermNo", teamProject.TermNo }, { "TeamProject.ProgramNo", teamProject.ProgramNo }
												, { "SearchText", vm.SearchText } };
			}
			else
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "TeamProject.TermNo", teamProject.TermNo }, { "SearchText", vm.SearchText } };
			}


			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult ListAdminExcel(int param1, int param2, string param3)
		{
			// param1 : ProgramNo 프로그램번호(1:정규과정, 2:MOOC),  param2 : TermNo 학기번호, param3 : SubjectName 강좌이름

			// 엑셀다운로드
			Hashtable hash = new Hashtable();
			hash.Add("ProgramNo", WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? param1 : 2);
			hash.Add("TermNo", param2);
			hash.Add("SubjectName", param3);

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("teamProject.TEAMPROJECT_SELECT_C", hash);

			string[] headers;
			string[] columns;
			string excelFileName = "";

			if (WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				headers = new string[] { "과정", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "캠퍼스 / 분반", "강의형태", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "과제출제수" };
				columns = new string[] { "ProgramName", "SubjectName", "CampusName", "강의형태", "ProfessorName", "TeamProjectCnt" };
				excelFileName = String.Format("강의운영관리_팀프로젝트관리_{1}_{0}", DateTime.Now.ToString("yyyyMMdd"), param1 == 1 ? "정규과정" : "MOOC");
			}
			else
			{
				headers = new string[] { WebConfigurationManager.AppSettings["SubjectText"].ToString(), "캠퍼스 / 분반", "강의형태", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "과제출제수" };
				columns = new string[] { "SubjectName", "CampusName", "강의형태", "ProfessorName", "TeamProjectCnt" };
				excelFileName = String.Format("강의운영관리_팀프로젝트관리_{0}", DateTime.Now.ToString("yyyyMMdd"));
			}
	
			return ExportExcel(headers, columns, hashList, excelFileName); ;
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListDetail/{param1}")]
		public ActionResult DetailAdmin(TeamProjectViewModel vm, int param1)
		{
			// param1 : CourseNo 강좌번호

			// 교과목 정보 조회
			Course course = new Course("S");
			course.CourseNo = param1;
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", course);

			TeamProject teamProject = new TeamProject();
			teamProject.CourseNo = param1;
			vm.TeamProjectList = baseSvc.GetList<TeamProject>("teamProject.TEAMPROJECT_SELECT_L", teamProject);

			if (vm.TeamProject != null)
			{
				TeamProjectSubmit teamProjectSubmit = new TeamProjectSubmit();
				teamProjectSubmit.CourseNo = param1;
				teamProjectSubmit.ProjectNo = vm.TeamProject.ProjectNo;
				vm.TeamProjectSubmitList = baseSvc.GetList<TeamProjectSubmit>("teamProject.TEAMPROJECT_SUBMIT_SELECT_L", teamProjectSubmit);

				if (vm.SortType == "UserID")
				{
					vm.TeamProjectSubmitList = baseSvc.GetList<TeamProjectSubmit>("teamProject.TEAMPROJECT_SUBMIT_SELECT_L", teamProjectSubmit).OrderBy(x => x.UserID).ToList();
					vm.SortType = "HangulName";
				}
				else
				{
					vm.TeamProjectSubmitList = baseSvc.GetList<TeamProjectSubmit>("teamProject.TEAMPROJECT_SUBMIT_SELECT_L", teamProjectSubmit).OrderBy(x => x.HangulName).ToList();
					vm.SortType = "UserID";
				}
			}

			vm.PageRowSize = vm.PageRowSize ?? 10;
			vm.PageNum = vm.PageNum ?? 1;

			return View(vm);
		}

		[HttpPost]
		[Route("SubmitList")]
		public JsonResult SubmitList(int courseNo, Int64 projectNo, string sortType)
		{
			TeamProjectViewModel vm = new TeamProjectViewModel();

			// 토론 참여자 리스트
			Hashtable paramHash = new Hashtable();

			TeamProjectSubmit teamProjectSubmit = new TeamProjectSubmit();
			teamProjectSubmit.CourseNo = courseNo;
			teamProjectSubmit.ProjectNo = projectNo;

			if (sortType == "UserID")
			{
				vm.TeamProjectSubmitList = baseSvc.GetList<TeamProjectSubmit>("teamProject.TEAMPROJECT_SUBMIT_SELECT_L", teamProjectSubmit).OrderBy(x => x.UserID).ToList();
				vm.SortType = "HangulName";
			}
			else
			{
				vm.TeamProjectSubmitList = baseSvc.GetList<TeamProjectSubmit>("teamProject.TEAMPROJECT_SUBMIT_SELECT_L", teamProjectSubmit).OrderBy(x => x.HangulName).ToList();
				vm.SortType = "UserID";
			}

			return Json(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult DetailAdminExcel(int param1)
		{
			// param1 : CourseNo 강좌번호

			// 엑셀다운로드
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("teamProject.TEAMPROJECT_SELECT_D", paramHash);
			string[] headers = new string[] { "팀프로젝트제목", "제출기간", "제출방식", "제출인원", "평가인원" };
			string[] columns = new string[] { "ProjectTitle", "SubmitDay", "SubmitType", "SubmitCount", "FeedbackCount" };
			string excelFileName = String.Format("강의운영관리_팀프로젝트관리_상세보기_{0}", DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, hashList, excelFileName);
		}
		
		#endregion 팀프로젝트 관리자
	}
}