using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Configuration;
using System;
using System.Web.Routing;
using ILMS.Core.System;
using System.Web.Configuration;
using System.Web;

namespace ILMS.Web.Controllers
{
    [RoutePrefix("Course")]
	public class CourseController : WebBaseController
	{
		public CourseService courseSvc { get; set; }

		public OcwService ocwSvc { get; set; }

		[Route("List")]
		[Route("List/{param1}")]
		public ActionResult List(int? param1, CourseViewModel vm)
		{
			vm.Year = vm.Year ?? DateTime.Today.ToString("yyyy");
			vm.Month = vm.Month ?? DateTime.Today.ToString("MM");
			vm.PageRowSize = vm.PageRowSize ?? 5;
			vm.PageNum = vm.PageNum ?? 1;

			string searchText = HttpUtility.UrlDecode(vm.SearchText) ?? "";
			string searchDate = vm.Year + "-" + String.Format("{0:00}", Convert.ToInt32(vm.Month)) + "-01";
			int Mno = !vm.CategoryNo.Equals(0) ? vm.CategoryNo : Convert.ToInt32(param1);
			vm.CategoryNo = Mno;

			if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N"))
			{
				Code code = new Code("A");
				code.ClassCode = "CSTD";

				vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
				
			}
		
			Course course = new Course();

			course.Mnos = vm.CategoryNo.ToString();
			course.ProgramNo = 2; //1: 정규 2:Mooc
			course.UnivYN = ConfigurationManager.AppSettings["UnivYN"].ToString();
			course.SearchText = searchText;
			course.SearchDate = searchDate;
			course.StudyType = vm.SearchGbn;


			vm.PageTotalCount = baseSvc.GetList<Course>("course.COURSE_SELECT_L", course).Count;
			
			course.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 5) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			course.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 5) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 5) : 5;


			if (param1 != null)
			{
				vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_L", course).
														Where(w => ("," + w.Mnos + ",").IndexOf(Mno.ToString()) > -1).													
														OrderByDescending(c => c.RStart).ThenByDescending(c => c.REnd).ToList();
			}
			else //param1이 null인 경우 전체 조회
			{
				vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_L", course).OrderByDescending(c => c.RStart).ThenByDescending(c => c.REnd).ToList();
			}
			
			vm.Dic = new RouteValueDictionary { { "Year", vm.Year }, { "Month", vm.Month }, { "CategoryNo", vm.CategoryNo }, { "SearchText", HttpUtility.UrlEncode(searchText) }, { "SearchGbn", vm.SearchGbn } };
			return View(vm);
		}

		[HttpPost]
		public JsonResult CourseList(int? termNo)
		{
			Course paramCourseA = new Course();
			paramCourseA.TermNo = termNo ?? 0;
			paramCourseA.UserNo = sessionManager.UserNo;
			IList<Course> courseList = baseSvc.GetList<Course>("course.COURSE_SELECT_A", paramCourseA);

			return Json(courseList);
		}

		#region 관리자 분반상세설정

		[AuthorFilter(IsAdmin = true)]
		[Route("ListAdmin")]
		public ActionResult ListAdmin(CourseViewModel vm)
		{
			// 소속, 학기 조회
			vm.AssignList = baseSvc.GetList<Assign>("common.COMMON_DEPT_SELECT_L", new Assign("L"));
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			// 페이징
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 조회
			if (vm.Course == null)
			{
				vm.Course = new Course();
				vm.Course.AssignNo = Request.QueryString["AssignNo"];
				vm.Course.TermNo = Convert.ToInt32(Request.QueryString["TermNo"]);
			}

			string searchText = HttpUtility.UrlDecode(vm.SearchText);
			string searchProf = HttpUtility.UrlDecode(vm.SearchProf);

			Course course = new Course();
			course.AssignNo = vm.Course.AssignNo != null ? vm.Course.AssignNo.Equals("") ? null : vm.Course.AssignNo : null;
			course.TermNo = vm.Course.TermNo > 0 ? vm.Course.TermNo : vm.TermList.Count > 0 ? vm.TermList[0].TermNo : 0;
			course.SearchText = searchText != null ? searchText : null;
			course.ProfessorName = searchProf != null ? searchProf : null;
			course.CreditAcceptGubun = "CHGB001";
			course.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			course.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_N", course);
			vm.PageTotalCount = vm.CourseList.Count > 0 ? vm.CourseList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Course.AssignNo", course.AssignNo }, { "Course.TermNo", course.TermNo }
												, { "SearchText", HttpUtility.UrlEncode(searchText) }, { "SearchProf", HttpUtility.UrlEncode(searchProf) } };
			
			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListAdminExcel")]
		public ActionResult ListAdminExcel(int param1, string param2, string param3, string param4)
		{
			// param1 : TermNo 학기번호,  param2 : AssignNo 소속번호, param3 : SearchText 교과목명, param4 : SearchProf 교수명

			// 엑셀다운로드
			Hashtable hash = new Hashtable();
			hash.Add("TermNo", param1);
			hash.Add("AssignNo", param2);
			hash.Add("SearchText", param3);
			hash.Add("ProfessorName", param4);
			hash.Add("CreditAcceptGubun", "CHGB001");

			IList <Hashtable> hashList = baseSvc.GetList<Hashtable>("course.COURSE_SELECT_O", hash);

			string[] headers = new string[] { WebConfigurationManager.AppSettings["SubjectText"].ToString(), "소속", "분반", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "이수구분", "학점", "학년", "강의형태", "개설상태" };
			string[] columns = new string[] { "SubjectName", "AssignName", "ClassNo", "ProfessorName", "FinishGubunName", "TargetGradeName", "Credit", "StudyTypeName", "CourseOpenStatusName" };
			string excelFileName = String.Format("교육과정관리_분반별상세설정_{0}", DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, hashList, excelFileName); ;
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("DetailAdmin/{param1}")]
		public ActionResult DetailAdmin(CourseViewModel vm, int param1)
		{

			ViewBag.viewOption = Request["viewOption"] ?? "0";
			ViewBag.AssignNo = Request.QueryString["AssignNo"];
			vm.SearchText = Request.QueryString["SearchText"];
			vm.SearchProf = Request.QueryString["SearchProf"];
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 공통코드 조회
			Code code = new Code("A", new string[] { "CSTD", "COST" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
			
			// 교과정보 및 수업계획 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);

			// 분반 리스트 조회
			Hashtable paramHash2 = new Hashtable();
			paramHash2.Add("SubjectNo", vm.Course.SubjectNo);
			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_N", paramHash2);

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[HttpPost]
		public JsonResult StudyTypeChange(int courseNo, string studyType)
		{
			// 강의 형태 변경
			int cnt = 0;

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", courseNo);
			paramHash.Add("StudyType", studyType);

			cnt = baseSvc.Save("course.COURSE_SAVE_A", paramHash);

			return Json(cnt);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListWeekAdmin")]
		public ActionResult ListWeekAdmin(CourseViewModel vm, int param1)
		{

			ViewBag.AssignNo = Request.QueryString["AssignNo"];
			vm.SearchText = Request.QueryString["SearchText"];
			vm.SearchProf = Request.QueryString["SearchProf"];
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 교과정보 및 주차 리스트 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);
			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", paramHash);

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[HttpPost]
		public JsonResult InningDelete(int courseNo, int inningNo, int week, int inningSeqNo)
		{
			// 차시 및 차시 관련 데이터 삭제
			int cnt = courseSvc.InningDelete(courseNo, inningNo, week, inningSeqNo);

			return Json(cnt);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("EstimationWriteAdmin")]
		public ActionResult EstimationWriteAdmin(CourseViewModel vm, int param1)
		{
			ViewBag.AssignNo = Request.QueryString["AssignNo"];
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 교과정보 조회
			Hashtable paramCourse = new Hashtable();
			paramCourse.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramCourse);

			// 평가기준 및 참여도항목 세부기준 조회
			Hashtable paramEst = new Hashtable();
			paramEst.Add("CourseNo", param1);
			vm.ParticipationEstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_SELECT_K", paramEst);

			paramEst.Add("UnivYN", ConfigurationManager.AppSettings["UnivYN"].ToString());
			vm.EstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_EST_SELECT_S", paramEst);

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[HttpPost]
		public JsonResult EstimationWriteAdmin(CourseViewModel vm)
		{
			
			int cnt = 0;

			// 평가항목기준
			vm.EstimationBasis = vm.EstimationBasis ?? new EstimationItemBasis();

			// 참여도항목
			vm.ParticipationEstimationBasis.HighMiddleLowBasisCode = "CHBC001";
			vm.ParticipationEstimationBasis.CreateUserNo = sessionManager.UserNo;
			vm.ParticipationEstimationBasis.UpdateUserNo = sessionManager.UserNo;

			cnt = courseSvc.EstimationSave(vm);

			return Json(cnt);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("OcwAdmin/{param1}")]
		public ActionResult OcwAdmin(CourseViewModel vm, int param1)
		{
			int courseNo = param1;

			ViewBag.AssignNo = Request.QueryString["AssignNo"];
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 교과정보 조회
			Hashtable paramCourse = new Hashtable();
			paramCourse.Add("CourseNo", courseNo);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramCourse);

			//강좌 OCW적용 리스트 조회
			vm.OcwCourseList = ocwSvc.GetOcwCourseList(courseNo);

			return View(vm);
		}

		#endregion 관리자 분반상세설정

		#region 관리자 MOOC강좌설정

		[AuthorFilter(IsAdmin = true)]
		[Route("ListOutAdmin")]
		public ActionResult ListOutAdmin(CourseViewModel vm)
		{
			// 학기 조회
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			// 페이징
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 조회
			if (vm.Course == null)
			{
				vm.Course = new Course();
				vm.Course.TermNo = Convert.ToInt32(Request.QueryString["TermNo"]);
			}

			string searchText = HttpUtility.UrlDecode(vm.SearchText);

			Course course = new Course();
			course.TermNo = vm.Course.TermNo > 0 ? vm.Course.TermNo : vm.TermList.Count > 0 ? vm.TermList[0].TermNo : 0;
			course.SearchText = searchText != null ? searchText : null;
			course.CreditAcceptGubun = "CHGB002";
			course.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			course.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_N", course);
			vm.PageTotalCount = vm.CourseList.Count > 0 ? vm.CourseList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Course.TermNo", course.TermNo }, { "SearchText", HttpUtility.UrlEncode(searchText) } };

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListOutAdminExcel")]
		public ActionResult ListOutAdminExcel(int param1, string param2)
		{
			// param1 : TermNo 학기번호,  param2 : SearchText 교과목명

			// 엑셀다운로드
			Hashtable hash = new Hashtable();
			hash.Add("TermNo", param1);
			hash.Add("SearchText", param2);
			hash.Add("CreditAcceptGubun", "CHGB002");

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("course.COURSE_SELECT_O", hash);

			string[] headers = new string[] { "No", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "신청기간", "운영기간", "상태" };
			string[] columns = new string[] { "RowNum", "SubjectName", "ProfessorName", "RDay", "LDay", "LSituation" };
			string excelFileName = String.Format("교육과정관리_개설{0}_{1}",WebConfigurationManager.AppSettings["SubjectText"] , DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, hashList, excelFileName); ;
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("WriteOutAdmin/{param1}")]
		public ActionResult WriteOutAdmin(CourseViewModel vm, int? param1)
		{
			
			if (param1 != null)
			{
				Hashtable paramHash = new Hashtable();
				paramHash.Add("CourseNo", param1);
				vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);
				vm.ProfessorList = baseSvc.GetList<Course>("course.COURSE_PROFESSOR_SELECT_B", paramHash);

				if (vm.ProfessorList.Count() > 0)
				{
					vm.Course.ProfessorNos = string.Join(",", vm.ProfessorList.Select(s => s.ProfessorNo).ToList());
				}

				// 썸네일 조회
				if (vm.Course.FileGroupNo > 0)
				{
					File file = new File();
					file.FileGroupNo = vm.Course.FileGroupNo ?? 0;
					if (vm.Course.FileGroupNo != null)
						vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					else
						vm.FileList = null;
				}
			}
			else
			{
				vm.Course = new Course();
				vm.Subject = new Subject();
				vm.ProfessorList = new List<Course>() { };
			}			

			// 학기 조회
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			// 카테고리(Mno) 모달 조회
			Hashtable paramCategory = new Hashtable();
			paramCategory.Add("Mnos", vm.Course != null ? null : vm.Course.Mnos);
			paramCategory.Add("IsOpen", 1);
			vm.CategoryList = baseSvc.GetList<Category>("course.COURSE_CATEGORY_SELECT_L", paramCategory);

			if (WebConfigurationManager.AppSettings["UnivYN"].Equals("N"))
			{
				Code code = new Code("A");
				code.ClassCode = "CSTD";
				code.DeleteYesNo = "N";
				code.UseYesNo = "Y";

				vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
			}

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;
			ViewBag.TermNo = Request.QueryString["TermNo"];

			return View(vm);
		}

		[HttpPost]
		[AuthorFilter(IsAdmin = true)]
		[Route("WriteOutAdmin/{param1}")]
		public ActionResult WriteOutAdmin(CourseViewModel vm)
		{
			long? fileGroupNo = 0;
			string Time = " 23:59:59";

			if(vm.Course.FileGroupNo > 0 && Request.Files["File"] == null)
			{
				fileGroupNo = vm.Course.FileGroupNo;
			}
			else
			{
				if (Request.Files["File"].ContentLength.Equals(0))
				{
					fileGroupNo = vm.Course.FileGroupNo;
				}
				else
				{
					fileGroupNo = FileUpload("C", "MOOCThumbnail", vm.Course.FileGroupNo, "MOOCThumbnailFile", Request.Files["File"]);

				}
			}

			vm.Course.FileGroupNo = fileGroupNo;
			vm.Course.ClassNo = 1;
			vm.Course.SubjectName = vm.Subject.SubjectName;
			vm.Course.ViewYesNo = ((vm.Course.ViewYesNo ?? "Y").Equals("on")) ? "Y" : "N";
			vm.Course.REnd = vm.Course.REnd + Time;
			vm.Course.LEnd = vm.Course.LEnd + Time;

			if (vm.Course.CourseNo.Equals(0))
			{
				// 저장
				vm.Subject.StudyType = vm.Course.StudyType;
				vm.Subject.TermNo = vm.Course.TermNo;
				vm.Subject.CreateUserNo = sessionManager.UserNo;
				vm.Course.CreateUserNo = sessionManager.UserNo;

				courseSvc.CourseInsert(vm);
			}
			else
			{
				// 수정
				vm.Subject.StudyType = vm.Course.StudyType;
				vm.Subject.TermNo = vm.Course.TermNo;
				vm.Subject.SubjectNo = vm.Course.SubjectNo;
				vm.Subject.SubjectName = vm.Course.SubjectName;
				vm.Subject.UpdateUserNo = sessionManager.UserNo;
				vm.Course.UpdateUserNo = sessionManager.UserNo;

				courseSvc.CourseUpdate(vm);
			}

			return RedirectToAction("ListOutAdmin");
		}

		[AuthorFilter(IsAdmin = true)]
		[HttpPost]
		public JsonResult SearchProfessor(string searchGbn, string searchText)
		{
			// 담당교수 검색
			Hashtable paramHash = new Hashtable();
			paramHash.Add("SearchGbn", searchGbn);
			paramHash.Add("SearchText", searchText);
			paramHash.Add("UserType", "USRT007,USRT008,USRT009,USRT010,USRT011,USRT012,USRT015,USRT016");
			IList<User> userList = baseSvc.GetList<User>("account.USER_SELECT_L", paramHash);

			return Json(userList);
		}

		[AuthorFilter(IsAdmin = true)]
		[HttpPost]
		public JsonResult LectureChk(int courseNo, int subjectNo)
		{
			// 등록된 강의가 있는지 확인
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", courseNo);
			paramHash.Add("SubjectNo", subjectNo);

			return Json(baseSvc.Get<CourseLecture>("course.COURSE_LECTURE_SELECT_F", paramHash));
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("MoocDelete/{param1}")]
		public void MoocDelete(int param1)
		{
			//param1 : CourseNo 강좌번호

			// MOOC강좌 삭제
			Course paramCourse = new Course();
			paramCourse.CourseNo = param1;
			baseSvc.Save("course.COURSE_SAVE_D", paramCourse);

			Response.Redirect("/Course/ListOutAdmin/");
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListWeekOutAdmin")]
		public ActionResult ListWeekOutAdmin(CourseViewModel vm, int param1)
		{
			// param1 : CourseNo 강좌번호

			// 교과정보 및 주차 리스트 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);
			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", paramHash);

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			return View(vm);
		}

		[AuthorFilter(IsMember = true)]
		[Route("StudyLogChk")]
		[HttpPost]
		public JsonResult StudyLogChk(int inningNo)
		{
			CourseViewModel vm = new CourseViewModel();
			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_F", inningNo);

			return Json(vm.Inning);
		}

		[AuthorFilter(IsMember = true)]
		[Route("InningDeleteAjax")]
		[HttpPost]
		public JsonResult InningDeleteAjax(int inningNo)
		{
			int cnt = 0;
			
			// 차시 재정리
			cnt += baseSvc.Save("course.COURSE_INNING_SAVE_J", inningNo);
			// 삭제된 차시가 맛보기면 맛보기 차시 초기화
			cnt += baseSvc.Save("course.COURSE_SAVE_B", inningNo);
			// 수강 데이터 삭제
			cnt += baseSvc.Save("course.STUDY_INNING_SAVE_D", inningNo);
			// 차시 삭제
			cnt += baseSvc.Save("course.COURSE_INNING_SAVE_D", inningNo);

			return Json(cnt);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("EstimationOutWriteAdmin")]
		public ActionResult EstimationOutWriteAdmin(CourseViewModel vm, int param1)
		{
			// 교과정보 및 수료기준 조회
			Hashtable paramCourse = new Hashtable();
			paramCourse.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramCourse);

			// 평가기준 및 참여도항목 세부기준 조회
			Hashtable paramEst = new Hashtable();
			paramEst.Add("CourseNo", param1);
			vm.ParticipationEstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_SELECT_K", paramEst);

			paramEst.Add("UnivYN", ConfigurationManager.AppSettings["UnivYN"].ToString());
			vm.EstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_EST_SELECT_S", paramEst);

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[HttpPost]
		public JsonResult EstimationOutWriteAdmin(CourseViewModel vm)
		{
	
			int cnt = 0;

			// 평가항목기준
			vm.EstimationBasis = vm.EstimationBasis ?? new EstimationItemBasis();
			if (vm.EstimationBasis != null)
			{
				vm.EstimationBasis.saveEstimationOut = true;
				vm.EstimationBasis.CourseNo = vm.ParticipationEstimationBasis.CourseNo;
				vm.EstimationBasis.EstimationType = "CEST002";
				vm.EstimationBasis.PerfectionHandleBasis = "CPHB002";
				vm.EstimationBasis.CreateUserNo = sessionManager.UserNo;
				vm.EstimationBasis.UpdateUserNo = sessionManager.UserNo;
			}

			// 참여도항목 세부기준
			vm.ParticipationEstimationBasis.HighMiddleLowBasisCode = "CHBC001";
			vm.ParticipationEstimationBasis.CreateUserNo = sessionManager.UserNo;
			vm.ParticipationEstimationBasis.UpdateUserNo = sessionManager.UserNo;

			cnt = courseSvc.EstimationSave(vm);

			return Json(cnt);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("OcwOutAdmin/{param1}")]
		public ActionResult OcwOutAdmin(CourseViewModel vm, int param1)
		{
			int courseNo = param1;

			// 교과정보
			Hashtable paramCourse = new Hashtable();
			paramCourse.Add("CourseNo", courseNo);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramCourse);

			//강좌 OCW적용 리스트 조회
			vm.OcwCourseList = ocwSvc.GetOcwCourseList(courseNo);

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			return View(vm);
		}

		#endregion 관리자 MOOC강좌설정

		#region 차시관리 팝업

		[AuthorFilter(IsMember = true)]
		[Route("WriteWeekAdmin")]
		public ActionResult WriteWeekAdmin(int param1, int? param2)
		{

			// param1 : CourseNo 강좌번호, param2 : InningNo 차시번호
			CourseViewModel vm = new CourseViewModel();

			// 주차 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);
			vm.WeekList = baseSvc.GetList<Inning>("common.COURSE_WEEK_SELECT_L", paramHash).ToList();

			// 공통코드 조회
			Code code = new Code("A", new string[] { "CINN", "CINM" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).ToList();

			// OCW선택 모달
			// OCW테마 조회
			vm.OcwTheme = new OcwTheme();
			vm.OcwTheme.IsAdmin = 0; //0 : 아니오, 1 : 관리자전용
			vm.OcwTheme.IsOpen = 1; //0 : 비공개, 1 : 공개
			vm.OcwThemeList = baseSvc.GetList<OcwTheme>("ocw.OCW_THEME_SELECT_L", vm.OcwTheme);

			if (!param2.Equals(0))
			{
				Hashtable paramInning = new Hashtable();
				paramInning.Add("InningNo", param2);

				vm.CourseInning = baseSvc.Get<Inning>("course.COURSE_INNING_SELECT_S", paramInning);
			}

			return View(vm);
		}

		[AuthorFilter(IsMember = true)]
		[HttpPost]
		public JsonResult NewInning(int courseNo, int weekNo)
		{
			// 주차 변경 시 차시, 학습기간 조회
			Inning inning = new Inning();
			inning.CourseNo = courseNo;
			inning.Week = weekNo;

			return Json(baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_I", inning));
		}

		[AuthorFilter(IsMember = true)]
		[Route("SearchOCW")]
		[HttpPost]
		public JsonResult SearchOCW(string themeNos, string searchText, string isAdmin)
		{
			// OCW 검색
			Hashtable paramHash = new Hashtable();
			paramHash.Add("ThemeNos", themeNos == null ? "" : themeNos.ToString());
			paramHash.Add("SearchText", searchText);
			paramHash.Add("ViewUserNo", isAdmin.Equals("True") ? 0 : sessionManager.UserNo);
			IList<Ocw> ocwList = baseSvc.GetList<Ocw>("ocw.OCW_SELECT_D", paramHash);

			return Json(ocwList);
		}

		[AuthorFilter(IsMember = true)]
		[Route("InningSave")]
		[HttpPost]
		public JsonResult InningSave(CourseViewModel vm)
		{
			int count = 0;

			string endTime = " 23:59:59";
			vm.CourseInning.LessonForm = vm.CourseInning.LessonForm == null ? "CINM001" : vm.CourseInning.LessonForm;

			if (!vm.CourseInning.LessonForm.Equals("CINM001"))
			{
				vm.CourseInning.LMSContentsNo = 0;
				vm.CourseInning.ZoomURL = null;
				vm.CourseInning.AttendanceAcceptTime = 0;
				vm.CourseInning.MiddleAttendanceStartMinute = 0;
				vm.CourseInning.MiddleAttendanceEndMinute = 0;
			}

			vm.CourseInning.IsPreview = vm.CourseInning.LessonForm != "CINM001" ? "N" : ((vm.CourseInning.IsPreview ?? "N").Equals("on")) ? "Y" : "N";
			if(vm.CourseInning.IsPreview == "Y")
			{
				vm.CourseInning.AttendanceAcceptTime = 0;
				vm.CourseInning.MiddleAttendanceStartMinute = 0;
				vm.CourseInning.MiddleAttendanceEndMinute = 0;
			}
			vm.CourseInning.CreateUserNo = sessionManager.UserNo;
			vm.CourseInning.UpdateUserNo = sessionManager.UserNo;
			vm.CourseInning.InningStartDay = vm.CourseInning.InningStartDay;
			vm.CourseInning.InningEndDay = vm.CourseInning.InningEndDay + endTime;

			if (vm.CourseInning.InningNo.Equals(0))
			{
				count = courseSvc.InningSave(vm);
			}
			else
			{
				count = courseSvc.InningUpdate(vm);
			}

			return Json(count);
		}

		#endregion 차시관리 팝업

		#region 관리자 분류설정

		[AuthorFilter(IsAdmin = true)]
		[Route("Category")]
		public ActionResult Category(CourseViewModel vm)
		{
			vm.CategoryList = baseSvc.GetList<Category>("course.COURSE_CATEGORY_SELECT_L", null);

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		public JsonResult CategoryAjax(int MNo,int SortNo, string MName, string IsOpen)
        {
			int cnt = 0;

			Hashtable paramHash = new Hashtable();
			paramHash.Add("MNo"		, MNo);
			paramHash.Add("MName"	, MName);
			paramHash.Add("SortNo"	, SortNo);
			paramHash.Add("IsOpen"  , IsOpen.Equals("Y") ? 1 : 0 );
			paramHash.Add("IsDeleted", 0);
			paramHash.Add("UNO", sessionManager.UserNo);

			cnt = baseSvc.Save("course.COURSE_CATEGORY_SAVE_" + (MNo == 0 ? "C" : "U"), paramHash);

            return Json(cnt);

        }

		[AuthorFilter(IsAdmin = true)]
		public JsonResult CategoryDelete(int MNo)
		{
			int cnt = 0;

			Hashtable paramHash = new Hashtable();
			paramHash.Add("MNo", MNo);
			paramHash.Add("IsDeleted", 1);
			paramHash.Add("UNO", sessionManager.UserNo);
			
			cnt = baseSvc.Save("course.COURSE_CATEGORY_SAVE_D", paramHash);

			return Json(cnt);
		}

		#endregion

		[Route("Detail")]
		[Route("Detail/{param1}")]
		public ActionResult Detail(CourseViewModel vm, int param1)
		{
			Hashtable ht = new Hashtable();

			vm.SearchText = Request.QueryString["Searhtext"];
			//+int Mno = Request.QueryString["Dic"].ToString();

			ht.Add("CourseNo", param1);

			// 강좌설명 & 강좌소개
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", ht);

			// 평가기준
			vm.EstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_EST_SELECT_S", ht);

			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", ht);

			

			return View(vm);
		}

		[HttpPost]
		[AuthorFilter(IsLogIn = true)]
		[Route("ReqCourse")]
		public JsonResult ReqCourse(int CourseNo)
		{
			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", CourseNo);
			ht.Add("UserNo", sessionManager.UserNo);
			ht.Add("LectureStatus", "CLST001");
			ht.Add("CreateUserNo", sessionManager.UserNo);

			//수강자생성
			Int64 lectureNo = baseSvc.Get<Int64>("course.COURSE_LECTURE_SAVE_C", ht);

			try
			{
				if (lectureNo > 0)
				{
					ht.Add("LectureNo", lectureNo);
					//수강데이터생성
					int rs = baseSvc.Get<int>("course.COURSE_INNING_SAVE_C", ht);
					if (rs > 0)
					{
						return Json(lectureNo);
					}
					else
					{
						return Json(-2);
					}
				}
				else
				{
					return Json(-3);
				}
			}
			catch(Exception)
			{
				return Json(-4);
			}
		}

		[HttpPost]
		public JsonResult IsPossibleLecture(int CourseNo)
		{
			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", CourseNo);
			ht.Add("UserNo", sessionManager.UserNo);
			
            if (sessionManager == null || sessionManager.UserNo < 1)
            {
				return Json(-1);
			}
            else if(baseSvc.GetList<CourseLecture>("course.COURSE_LECTURE_SELECT_A", ht).Count > 0)
            {
                return Json(-2);
            }

			return Json(-3);
		}

		[HttpPost]
		public JsonResult getProfessorMatched(int CourseNo)
		{
			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", CourseNo);
			ht.Add("UserNo", sessionManager.UserNo);

			return Json(baseSvc.Get<int>("course.COURSE_PROFESSOR_SELECT_A", ht));
		}

		#region 운영통계

		[AuthorFilter(IsAdmin = true)]
		[Route("Statistics")]
		public ActionResult Statistics(StatisticsViewModel vm)
		{
			vm.Year = vm.Year != null ? vm.Year : System.DateTime.Today.ToString("yyyy");

			Hashtable paramForStatistics = new Hashtable();
			paramForStatistics.Add("Year", vm.Year);

			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_COURSE_SELECT_L", paramForStatistics);

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("CourseStatisticsExcel")]
		public ActionResult CourseStatisticsExcel(StatisticsViewModel vm)
		{
			Hashtable paramForExcel = new Hashtable();
			paramForExcel.Add("Year", vm.Year);
			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_COURSE_SELECT_L", paramForExcel);

			string[] headers = new string[] { "구분", "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월", "소계" };
			string[] colums = new string[] { "CourseStatisticsGubun", "JanCnt", "FebCnt", "MarCnt", "AprCnt", "MayCnt", "JunCnt"
											, "JulCnt", "AguCnt", "SepCnt", "OctCnt", "NovCnt", "DecCnt", "TotalCount"};

			return ExportExcel(headers, colums, vm.StatisticsList, String.Format("운영통계{0}", DateTime.Now.ToString("yyyyMMdd")));
		}

		#endregion 운영통계

	}
}