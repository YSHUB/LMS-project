using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
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
	[RoutePrefix("Quiz")]
	public class QuizController : LectureRoomBaseController
	{
		public ExamService examSvc { get; set; }
		string Gubun = "Q"; // 퀴즈

		[Route("ListTeacher/{param1}")]
		public ActionResult ListTeacher(int? param1)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);

			// 현재학기여부 조회
			Term term = new Term("B");
			term.CourseNo = vm.CourseNo;
			vm.CurrentTermYn = baseSvc.Get<Term>("term.TERM_SELECT_B", term).CurrentTermYn;

			// 퀴즈 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("RowState", "L");
			paramHash.Add("CourseNo", vm.CourseNo);
			paramHash.Add("Gubun", Gubun);
			vm.QuizList = baseSvc.GetList<Exam>("exam.EXAM_SELECT_L", paramHash).ToList();

			return View(vm);
		}

		[Route("Write/{param1}")]
		[Route("Write/{param1}/{param2}")]
		public ActionResult Write(int? param1, int? param2)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);
			
			// 주차
			Inning paramWeek = new Inning("L");
			paramWeek.CourseNo = vm.CourseNo;
			vm.WeekList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_N", paramWeek).ToList();
			
			
			if (!string.IsNullOrEmpty(Request.QueryString["week"]))
			{
				// 차시
				Inning inning = new Inning("A");
				inning.CourseNo = vm.CourseNo;
				inning.Week = Convert.ToInt32(Request.QueryString["week"].ToString());

				vm.InningList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_A", inning);
			}
			

			// 공통코드
			Code code = new Code("A", new string[] { "EXRS" });
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";
			vm.baseCodes = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			// 주차별 문항수 및 배점 설정
			ExamRandom examRandom = new ExamRandom("L");
			examRandom.ExamNo = vm.ExamNo;
			examRandom.Gubun = Gubun;
			vm.RandomList = baseSvc.GetList<ExamRandom>("exam.EXAM_RANDOM_SELECT_L", examRandom).ToList();

			// 퀴즈 상세조회
			if (!vm.ExamNo.Equals(0))
			{
				vm.ExamDetail = examSvc.ExamDetailInfo(vm.CourseNo, vm.ExamNo, Gubun);

				// 문제설정 조회
				ExamQuestion examQuestion = new ExamQuestion("L");
				examQuestion.ExamNo = vm.ExamNo;
				examQuestion.Gubun = Gubun;
				vm.QuestionList = baseSvc.GetList<ExamQuestion>("exam.EXAM_QUESTION_SELECT_L", examQuestion).ToList();
			}
			else
			{
				vm.ExamDetail = new Exam();
				vm.ExamDetail.Gubun = Gubun;
				vm.QuestionList = new List<ExamQuestion>();
			}

			return View(vm);
		}

		[Route("DetailTeacher/{param1}")]
		[Route("DetailTeacher/{param1}/{param2}")]
		public ActionResult DetailTeacher(int? param1, int? param2)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);

			// 퀴즈 상세조회
			if (!vm.ExamNo.Equals(0))
			{
				vm.ExamDetail = examSvc.ExamDetailInfo(vm.CourseNo, vm.ExamNo, Gubun);

				// 주차별 문항수 및 배점 설정
				ExamRandom examRandom = new ExamRandom("L");
				examRandom.ExamNo = vm.ExamNo;
				examRandom.Gubun = Gubun;
				vm.RandomList = baseSvc.GetList<ExamRandom>("exam.EXAM_RANDOM_SELECT_L", examRandom).Where(c => c.ExamRowNum > 0).ToList();

				// 문제설정 조회
				ExamQuestion examQuestion = new ExamQuestion("L");
				examQuestion.ExamNo = vm.ExamNo;
				examQuestion.Gubun = Gubun;
				vm.QuestionList = baseSvc.GetList<ExamQuestion>("exam.EXAM_QUESTION_SELECT_L", examQuestion).ToList();

				// 퀴즈 응시대상자 인원
				Examinee examinee = new Examinee("L");
				examinee.CourseNo = vm.CourseNo;
				examinee.ExamNo = vm.ExamNo;
				examinee.Gubun = Gubun;
				vm.ExamCandidate = baseSvc.GetList<Examinee>("exam.EXAMINEE_SELECT_L", examinee).Count();

				// 퀴즈 미응시자 인원
				vm.ExamNonTaker = baseSvc.GetList<Examinee>("exam.EXAMINEE_SELECT_L", examinee).Where(c => c.TakeDateTimeFormat == null || c.TakeDateTimeFormat == "").Count();
			}
			else
			{
				vm.ExamDetail = new Exam();
				vm.RandomList = new List<ExamRandom>();
				vm.QuestionList = new List<ExamQuestion>();
			}

			return View(vm);
		}

		[Route("Copy/{param1}")]
		[Route("Copy/{param1}/{param2}")]
		public ActionResult Copy(int? param1, int? param2)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.TermNo = Convert.ToInt32(param2);

			// 학기 리스트
			Term term = new Term("L");
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", term);
			vm.TermList = vm.TermList.Where(x => x.TermGubun.Equals("CTGB001")).OrderByDescending(y => y.TermNo).ToList();
			vm.TermNo = param2 ?? vm.TermList.OrderByDescending(d => d.TermNo).FirstOrDefault().TermNo;

			// 퀴즈 가져오기 리스트
			Hashtable paramHash = new Hashtable();
			paramHash.Add("RowState", "A");
			paramHash.Add("CourseNo", vm.CourseNo);
			paramHash.Add("TermNo", vm.TermNo);
			paramHash.Add("Gubun", Gubun);
			vm.QuizList = baseSvc.GetList<Exam>("exam.EXAM_SELECT_A", paramHash).ToList();

			return View(vm); 
		}

		[Route("EstimationList/{param1}")]
		[Route("EstimationList/{param1}/{param2}")]
		public ActionResult EstimationList(int param1, int? param2)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);

			// 퀴즈 상세조회
			if (!vm.ExamNo.Equals(0))
			{
				vm.ExamDetail = examSvc.ExamDetailInfo(vm.CourseNo, vm.ExamNo, Gubun);
				vm.ExamineeList = examSvc.ExamineeList("L", vm.CourseNo, vm.ExamNo, Gubun, null, null, null, null);
			}
			else
			{
				vm.ExamDetail = new Exam();
				vm.ExamineeList = new List<Examinee>();
			}

			return View(vm);
		}

		[Route("EstimationOffline/{param1}")]
		[Route("EstimationOffline/{param1}/{param2}")]
		[Route("EstimationOffline/{param1}/{param2}/{param3}")]
		public ActionResult EstimationOffline(int param1, int param2, int param3)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);

			// 퀴즈, 시험 상세조회
			vm.ExamDetail = examSvc.ExamDetailInfo(vm.CourseNo, vm.ExamNo, Gubun);

			// 퀴즈 응시대상자 정보 및 오프라인 평가 정보
			vm.ExamineeDetail = examSvc.ExamPensonInfo(vm.CourseNo, vm.ExamNo, Gubun, 0, param3);

			// 만점
			vm.perfectScore = examSvc.PerfectScore(vm.ExamNo, Gubun);

			// 첨부파일
			if(vm.ExamineeDetail.OFFFile > 0)
			{
				File file = new File("L");
				file.FileGroupNo = vm.ExamineeDetail.OFFFile;
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
			}
			else
			{
				vm.FileList = null;
			}

			return View(vm);
		}

		[Route("EstimationWrite/{param1}")]
		[Route("EstimationWrite/{param1}/{param2}")]
		[Route("EstimationWrite/{param1}/{param2}/{param3}")]
		public ActionResult EstimationWrite(int param1, int param2, int param3)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);

			// 퀴즈 상세조회
			if (!vm.ExamNo.Equals(0))
			{
				vm.ExamineeList = examSvc.ExamineeList("L", vm.CourseNo, vm.ExamNo, Gubun, null, null, null, null);
				vm.ExamDetail = examSvc.ExamDetailInfo(vm.CourseNo, vm.ExamNo, Gubun);
			}
			else
			{
				vm.ExamineeList = new List<Examinee>();
				vm.ExamDetail = new Exam();
			}

			// 퀴즈 응시대상자 정보 및 오프라인 평가 정보
			vm.ExamineeDetail = vm.ExamineeList.Where(c => c.ExamineeNo.Equals(param3)).SingleOrDefault();
			vm.ExamineeScore = examSvc.ExamineeScoreInfo(vm.ExamNo, Gubun, param3);

			// 이전학생, 다음학생 ExamineeNo
			int currentIndex = vm.ExamineeList.IndexOf(vm.ExamineeDetail);
			int preIndex = ((currentIndex - 1) < 0) ? 0 : (currentIndex - 1);
			int nextIndex = (vm.ExamineeList.Count - 1 < (currentIndex + 1)) ? vm.ExamineeList.Count - 1 : (currentIndex + 1);
			
			vm.PrePage = vm.ExamineeList[preIndex].ExamineeNo;
			vm.NextPage = vm.ExamineeList[nextIndex].ExamineeNo;

			return View(vm);
		}

		[Route("ListStudent/{param1}")]
		public ActionResult ListStudent(int param1)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);

			// 퀴즈 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("RowState", "C");
			paramHash.Add("CourseNo", vm.CourseNo);
			paramHash.Add("Gubun", Gubun);
			paramHash.Add("UserNo", sessionManager.UserNo);
			vm.QuizList = baseSvc.GetList<Exam>("exam.EXAM_SELECT_C", paramHash).ToList();

			return View(vm);
		}

		[Route("DetailStudent/{param1}")]
		[Route("DetailStudent/{param1}/{param2}")]
		public ActionResult DetailStudent(int param1, int? param2)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);
			
			// 퀴즈 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("RowState", "C");
			paramHash.Add("CourseNo", vm.CourseNo);
			paramHash.Add("ExamNo", vm.ExamNo);
			paramHash.Add("Gubun", Gubun);
			paramHash.Add("UserNo", sessionManager.UserNo);
			vm.ExamDetail = baseSvc.Get<Exam>("exam.EXAM_SELECT_C", paramHash);

			vm.totalCntQuestion = examSvc.TotalCntQuestion(vm.ExamNo, Gubun);

			return View(vm);
		}

		[Route("EstimationStudent/{param1}")]
		[Route("EstimationStudent/{param1}/{param2}")]
		[Route("EstimationStudent/{param1}/{param2}/{param3}")]
		public ActionResult EstimationStudent(int param1, int param2, int param3)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);

			// 퀴즈 상세조회
			if (!vm.ExamNo.Equals(0))
			{
				vm.ExamineeList = examSvc.ExamineeList("L", vm.CourseNo, vm.ExamNo, Gubun, null, null, null, null);

				// 퀴즈 조회
				Hashtable paramHash = new Hashtable();
				paramHash.Add("RowState", "C");
				paramHash.Add("CourseNo", vm.CourseNo);
				paramHash.Add("ExamNo", vm.ExamNo);
				paramHash.Add("Gubun", Gubun);
				paramHash.Add("UserNo", sessionManager.UserNo);
				vm.ExamDetail = baseSvc.Get<Exam>("exam.EXAM_SELECT_C", paramHash);
			}
			else
			{
				vm.ExamineeList = new List<Examinee>();
				vm.ExamDetail = new Exam();
			}

			// 퀴즈 응시대상자 정보 및 오프라인 평가 정보
			vm.ExamineeDetail = vm.ExamineeList.Where(c => c.ExamineeNo.Equals(param3)).SingleOrDefault();
			vm.ExamineeScore = examSvc.ExamineeScoreInfo(vm.ExamNo, Gubun, param3);

			return View(vm);
		}

		[Route("Run/{param1}")]
		[Route("Run/{param1}/{param2}")]
		public ActionResult Run(int param1, int? param2)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);

			// 퀴즈 정보
			vm.ExamDetail = examSvc.ExamDetailInfo(vm.CourseNo, vm.ExamNo, Gubun);
			ViewBag.CurrentMenuTitle = vm.ExamDetail.ExamTitle;

			// 퀴즈 응시대상자 정보
			vm.ExamineeDetail = examSvc.ExamPensonInfo(vm.CourseNo, vm.ExamNo, Gubun, sessionManager.UserNo, 0);
			vm.AdminYn = (vm.ExamineeDetail != null) ? "N" : "Y";

			// 문제 목록
			vm.QuestionList = examSvc.ExamListInfo(vm.ExamNo, (vm.ExamineeDetail != null) ? vm.ExamineeDetail.ExamineeNo : 0, Gubun, sessionManager.UserNo, vm.AdminYn).ToList();

			// 미답변 건수
			vm.noAnswerCnt = vm.QuestionList.Where(c => c.AnswerChk.Equals("N")).Count();

			// 관리자인 경우
			if (vm.ExamineeDetail == null)
			{
				vm.initSecond = vm.ExamDetail.LimitTime * 60;

				vm.ExamineeDetail = new Examinee();
				vm.ExamineeDetail.UserID = "1234567";
				vm.ExamineeDetail.HangulName = "홍길동";
				vm.ExamineeDetail.GradeNm = "2";
				vm.ExamineeDetail.AssignName = "관리자 미리보기";
			}
			else
			{
				vm.initSecond = vm.ExamineeDetail.InitSecond;

				//접속한 아이피
				if (vm.ExamineeDetail.TakeDateTimeFormat == null)
				{
					string userIp = Request.ServerVariables["REMOTE_ADDR"].ToString();

					Examinee examinee = new Examinee("U");
					examinee.ExamineeNo = vm.ExamineeDetail.ExamineeNo;
					examinee.ExamUserIpAddr = userIp;

					baseSvc.Save<Examinee>("exam.EXAMINEE_SAVE_U", examinee);
				}
			}

			vm.QuestionDetail = (vm.QuestionList.Count > 0) ? vm.QuestionList[0] : null;
			vm.CurrentPage = (vm.QuestionList.Count > 0) ? vm.QuestionList[0].QuestionBankNo : 0;
			vm.NextPage = (vm.QuestionList.Count > 1) ? vm.QuestionList[1].QuestionBankNo : 0;

			// 문제 보기
			if (vm.QuestionDetail != null)
			{
				vm.QuestionExampleList = examSvc.ExampleListInfo(vm.ExamDetail.ExampleMixYesNo, vm.ExamNo, vm.QuestionDetail.QuestionBankNo, (vm.ExamineeDetail != null) ? vm.ExamineeDetail.ExamineeNo : 0).ToList();
			}
			else
			{
				vm.QuestionExampleList = new List<ExamineeReply>();
			}

			return View(vm);
		}

		[Route("Statistics/{param1}")]
		[Route("Statistics/{param1}/{param2}")]
		public ActionResult Statistics(int param1, int? param2)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);

			// 퀴즈 상세조회
			if (!vm.ExamNo.Equals(0))
			{
				vm.ExamDetail = examSvc.ExamDetailInfo(vm.CourseNo, vm.ExamNo, Gubun);
			}
			else
			{
				vm.ExamDetail = new Exam();
			}

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListAdmin/{param1}")]
		public ActionResult ListAdmin(ExamViewModel vm, int param1)
		{
			// 프로그램과정, 학기 조회
			vm.ProgramList = baseSvc.GetList<TeamProject>("teamProject.PROGRAM_SELECT_L", new TeamProject("L"));
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			// 페이징
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				vm.ProgramNo = (vm.ProgramNo > 0) ? vm.ProgramNo : vm.ProgramList[0].ProgramNo;
			}
			else
			{
				vm.ProgramNo = 2;
			}
			vm.TermNo = (vm.TermNo > 0) ? vm.TermNo : vm.TermList[0].TermNo;
			vm.FirstIndex = FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum));
			vm.LastIndex = LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum));

			vm.PageTotalCount = examSvc.ExamAdminListCnt(vm, Gubun);
			vm.QuizList = examSvc.ExamAdminList(vm, "D", Gubun);

			if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				vm.Dic = new RouteValueDictionary { { "ProgramNo", vm.ProgramNo }, { "TermNo", vm.TermNo }, { "SearchText", vm.SearchText }, { "PageRowSize", vm.PageRowSize } };
			}
			else
			{
				vm.Dic = new RouteValueDictionary { { "TermNo", vm.TermNo }, { "SearchText", vm.SearchText }, { "PageRowSize", vm.PageRowSize } };
			}

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("DetailAdmin/{param1}")]
		public ActionResult DetailAdmin(ExamViewModel vm, int param1)
		{
			vm.CourseNo = param1;
			vm.ExamDetail = examSvc.ExamAdminList(vm, "D", Gubun).FirstOrDefault();
			vm.ExamDetail.Gubun = Gubun;

			// 퀴즈 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("RowState", "L");
			paramHash.Add("CourseNo", vm.CourseNo);
			paramHash.Add("Gubun", Gubun);
			vm.QuizList = baseSvc.GetList<Exam>("exam.EXAM_SELECT_L", paramHash).ToList();

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("AnswerAdmin/{param1}")]
		[Route("AnswerAdmin/{param1}/{param2}")]
		[Route("AnswerAdmin/{param1}/{param2}/{param3}")]
		public ActionResult AnswerAdmin(int param1, int param2, int param3)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.CourseNo = Convert.ToInt32(param1);
			vm.ExamNo = Convert.ToInt32(param2);

			// 퀴즈 상세조회
			if (!vm.ExamNo.Equals(0))
			{
				vm.ExamineeList = examSvc.ExamineeList("L", vm.CourseNo, vm.ExamNo, Gubun, null, null, null, null);
				ViewBag.CurrentMenuTitle = vm.ExamineeList.FirstOrDefault().ExamTitle;
			}
			else
			{
				vm.ExamineeList = new List<Examinee>();
			}

			// 퀴즈 응시대상자 정보 및 오프라인 평가 정보
			vm.ExamineeDetail = vm.ExamineeList.Where(c => c.ExamineeNo.Equals(param3)).SingleOrDefault();
			vm.ExamineeScore = examSvc.ExamineeScoreInfo(vm.ExamNo, Gubun, param3);

			return View(vm);
		}

		public JsonResult InningList(int courseno, int weekno)
		{
			// 차시
			Inning inning = new Inning("A");
			inning.CourseNo = courseno;
			inning.Week = weekno;

			List<Inning> InningList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_A", inning).ToList();

			return Json(InningList);
		}

		public JsonResult AddQuestionList(string questionBankNos)
		{
			Hashtable paramHash = new Hashtable();
			paramHash.Add("RowState", "L");
			paramHash.Add("CreateUserNo", sessionManager.UserNo);
			paramHash.Add("QuestionBankNos", questionBankNos);

			List<QuestionBankQuestion> TempQuestionList = baseSvc.GetList<QuestionBankQuestion>("questionBankQuestion.QUESTION_SELECT_L", paramHash).ToList();

			return Json(TempQuestionList);
		}

		public JsonResult QuizCreate(ExamViewModel vm)
		{
			int result = 0;

			if (vm.ExamDetail.ExamNo == 0) vm.ExamDetail.RowState = "C";
			else vm.ExamDetail.RowState = "U";

			vm.ExamDetail.CreateUserNo = sessionManager.UserNo;
			vm.ExamDetail.UpdateUserNo = sessionManager.UserNo;
			vm.ExamDetail.Gubun = Gubun;

			result = examSvc.ExamSave(vm);

			return Json(result);
		}

		public JsonResult QuizDelete(ExamViewModel vm)
		{
			int result = 0;

			vm.ExamDetail.RowState = "D";
			vm.ExamDetail.Gubun = Gubun;

			result = examSvc.ExamSave(vm);

			return Json(result);
		}

		public JsonResult UpdateEndDay(int examNo, string endDay)
		{
			int result = 0;

			DateTime endday_format = DateTime.ParseExact(endDay.Trim().Replace("-", "").Replace(":", ""), "yyyyMMddHHmm", null);
			
			Exam exam = new Exam("B");
			exam.ExamNo = examNo;
			exam.Gubun = Gubun;
			exam.EndDayFormat = endday_format.ToString("yyyy-MM-dd HH:mm:00.000");
			exam.UpdateUserNo = sessionManager.UserNo;

			result = baseSvc.Save<Exam>("exam.EXAM_SAVE_B", exam);

			return Json(result);
		}

		public JsonResult QuizComplete(ExamViewModel vm)
		{
			int result = 0;
			
			vm.ExamDetail.CreateUserNo = sessionManager.UserNo;
			vm.ExamDetail.UpdateUserNo = sessionManager.UserNo;
			vm.ExamDetail.Gubun = Gubun;

			result = examSvc.ExamComplete(vm);

			return Json(result);
		}

		public JsonResult QuizUnComplete(int examNo)
		{
			int result = 0;

			result = examSvc.ExamUnComplete(examNo, Gubun);

			return Json(result);
		}

		public JsonResult CopyQuiz(int courseNo, int examNo)
		{
			int result = 0;

			Exam exam = new Exam("A");
			exam.CourseNo = courseNo;
			exam.ExamNo = examNo;
			exam.Gubun = Gubun;
			exam.CreateUserNo = sessionManager.UserNo;
			exam.UpdateUserNo = sessionManager.UserNo;

			result = baseSvc.Save<Exam>("exam.EXAM_SAVE_A", exam);

			return Json(result);
		}

		public JsonResult GetQuestion(int examNo, int examineeNo, int currentPage, string adminYn)
		{
			ExamViewModel vm = new ExamViewModel();

			// 문제 목록
			vm.QuestionList = examSvc.ExamListInfo(examNo, (adminYn == "N") ? examineeNo : 0, Gubun, sessionManager.UserNo, adminYn).ToList();

			if (currentPage >= 0)
			{
				// 다음페이지
				int NextPage = currentPage + 1;
				int PrePage = currentPage - 1;

				vm.QuestionDetail = (vm.QuestionList.Count > currentPage) ? vm.QuestionList[currentPage] : null;
				vm.CurrentPage = (vm.QuestionList.Count > currentPage) ? vm.QuestionList[currentPage].QuestionBankNo : 0;
				vm.NextPage = (vm.QuestionList.Count > NextPage) ? vm.QuestionList[NextPage].QuestionBankNo : 0;
				vm.PrePage = (PrePage > -1) ? vm.QuestionList[PrePage].QuestionBankNo : 0;
			}

			return Json(vm);
		}

		public JsonResult GetExample(string exampleMixYesNo, int examNo, int questionBankNo, int examineeNo)
		{
			ExamViewModel vm = new ExamViewModel();

			// 문제 보기
			vm.QuestionExampleList = examSvc.ExampleListInfo(exampleMixYesNo, examNo, questionBankNo, examineeNo).ToList();

			return Json(vm);
		}

		public JsonResult ChkExaminee(int courseNo, int examNo)
		{
			// 퀴즈 응시자 인원
			Examinee examinee = new Examinee("L");
			examinee.CourseNo = courseNo;
			examinee.ExamNo = examNo;
			examinee.Gubun = Gubun;
			int result = baseSvc.GetList<Examinee>("exam.EXAMINEE_SELECT_L", examinee).Where(c => c.TakeDateTimeFormat == null || c.TakeDateTimeFormat == "").Count();

			return Json(result);
		}

		public JsonResult ChkSetType(int examNo)
		{
			int result = 0;

			ExamViewModel vm = new ExamViewModel();

			Exam exam = new Exam("B");
			exam.ExamNo = examNo;

			vm.ExamDetail = baseSvc.Get<Exam>("exam.EXAM_SELECT_B", exam);

			if (vm.ExamDetail.SE0State.Equals(0) || (vm.ExamDetail.EndDay < DateTime.Now)) result = 0;
			else result = 1;

			return Json(result);
		}

		public JsonResult SaveTime(int examineeNo, int remainTime, int remainSecond)
		{
			int result = 0;

			Examinee examinee = new Examinee("U");
			examinee.ExamineeNo = examineeNo;
			examinee.RemainTime = remainTime;
			examinee.RemainSecond = remainSecond;

			result = baseSvc.Save<Examinee>("exam.EXAMINEE_SAVE_U", examinee);

			return Json(result);
		}

		public JsonResult RunSubmit(ExamViewModel vm)
		{
			int result = 0;

			result = examSvc.ExamSubmitSave(vm);

			return Json(result);
		}

		public JsonResult ExamineeSearch(int courseNo, int examNo, string examStatus, string searchGubun, string searchText, string sortGubun)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.ExamineeList = examSvc.ExamineeList("L", courseNo, examNo, Gubun, examStatus, searchGubun, searchText, sortGubun).ToList();
			
			return Json(vm.ExamineeList);
		}

		public JsonResult UpdateStatus(int examNo, string examStatus)
		{
			int result = 0;

			Exam exam = new Exam("F");
			exam.ExamNo = examNo;
			exam.Gubun = Gubun;
			exam.SE0State = Convert.ToInt32(examStatus);

			result = baseSvc.Save<Exam>("exam.EXAM_SAVE_F", exam);

			return Json(result);
		}

		public JsonResult UpdateOpen(int examNo, string openYesNo)
		{
			int result = 0;

			result = examSvc.OpenYesnoSave(examNo, Gubun, openYesNo);

			return Json(result);
		}

		public JsonResult UpdateAutoScoring(int courseNo, int examNo)
		{
			int result = 0;

			result = examSvc.AutoScoringSave(courseNo, examNo, Gubun);

			return Json(result);
		}

		public JsonResult UpdateQuestionnaireStatus(string btnGubun, int examNo, string statusGubun)
		{
			int result = 0;

			result = examSvc.chgExamStatus(btnGubun, examNo, Gubun, statusGubun);

			return Json(result);
		}

		public JsonResult UpdateAttendanceCheck(int courseNo, int examNo, int examineeNo, int retestGubun)
		{
			int result = 0;

			result = examSvc.deadlineSave(courseNo, examNo, examineeNo, retestGubun, sessionManager.UserNo, Gubun);

			return Json(result);
		}

		public JsonResult UpdateExamReset(int courseNo, int examNo, int examineeNo, long userNo, string adminYn)
		{
			int result = 0;

			userNo = (adminYn.Equals("N")) ? sessionManager.UserNo : userNo;
			result = examSvc.ExamReset(courseNo, examNo, Gubun, examineeNo, userNo);

			return Json(result);
		}

		public ActionResult ExamineeExcel(int param1, int param2, string hdnExamStatus, string hdnSearchGubun, string hdnSearchText, string hdnSearchSortGubun, string hdnadminYn)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.ExamineeList = examSvc.ExamineeList("C", param1, param2, Gubun, hdnExamStatus, hdnSearchGubun, hdnSearchText, hdnSearchSortGubun).ToList();

			string[] headers;
			string[] colums;
			string fileNm = "";

			if (hdnadminYn.Equals("Y"))
			{
				if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
				{
					headers = new string[] { "No", "소속", ConfigurationManager.AppSettings["StudIDText"].ToString(), "이름", "학적", "IP", "상태", "응시일시", "제출일시", "경과시간", "총점" };
					colums = new string[] { "ExamineeRowNum", "AssignName", "UserID", "HangulName", "HakjeokGubunName", "ExamUserIpAddr", "ExamStatusNm", "TakeDateTimeFormatView", "LastDateTimeFormatView", "RemainTimeFormat", "ExamTotalScore" };
				}
				else
				{
					headers = new string[] { "No", ConfigurationManager.AppSettings["StudIDText"].ToString(), "이름", "IP", "상태", "응시일시", "제출일시", "경과시간", "총점" };
					colums = new string[] { "ExamineeRowNum", "UserID", "HangulName", "ExamUserIpAddr", "ExamStatusNm", "TakeDateTimeFormatView", "LastDateTimeFormatView", "RemainTimeFormat", "ExamTotalScore" };
				}

				fileNm = "응시대상자목록";
			}
			else
			{
				if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
				{
					headers = new string[] { "No", "소속", "이름", ConfigurationManager.AppSettings["StudIDText"].ToString(), "응시일자", "제출일자", "경과시간", "응시상태", "총점" };
					colums = new string[] { "ExamineeRowNum", "AssignName", "HangulName", "UserID", "TakeDateTimeFormatView", "LastDateTimeFormatView", "RemainTimeFormat", "ExamStatusNm", "ExamTotalScore" };
				}
				else
				{
					headers = new string[] { "No", "이름", ConfigurationManager.AppSettings["StudIDText"].ToString(), "응시일자", "제출일자", "경과시간", "응시상태", "총점" };
					colums = new string[] { "ExamineeRowNum", "HangulName", "UserID", "TakeDateTimeFormatView", "LastDateTimeFormatView", "RemainTimeFormat", "ExamStatusNm", "ExamTotalScore" };

				}
				fileNm = "평가목록";
			}

			return ExportExcel(headers, colums, vm.ExamineeList, String.Format("{0}{1}", fileNm, DateTime.Now.ToString("yyyyMMdd")));
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult DetailAdminExcel(int param1, string param2)
		{
			// param1 : CourseNo 강좌번호
			ExamViewModel vm = new ExamViewModel();

			// 엑셀다운로드
			Hashtable hash = new Hashtable();
			hash.Add("RowState", "L");
			hash.Add("CourseNo", param1);
			hash.Add("Gubun", param2);

			vm.QuizList = baseSvc.GetList<Exam>("exam.EXAM_SELECT_L", hash).ToList();

			string[] headers;
			string[] columns;
			string excelFileName = "";

			headers = new string[] { "주차", "차시", "퀴즈제목", "응시방법", "응시기간", "상태", "응시인원", "평가인원" };
			columns = new string[] { "Week", "InningSeqNo", "ExamTitle", "LectureTypeNm", "ExamDate", "EstimationGubunNm", "TakeStudentCount", "EstimationCount" };
			excelFileName = String.Format("강의운영관리_퀴즈관리_상세보기_{0}", DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, vm.QuizList, excelFileName);
		}

		public JsonResult OffCreate(ExamViewModel vm)
		{
			int result = 0;

			vm.ExamineeDetail.Gubun = Gubun;

			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long fileGroupNo = 0;

			if (Request.Files.Count > 0)
			{
				if(Request.Files["OffFile"].FileName != null && Request.Files["OffFile"].FileName != "")
				{
					fileGroupNo = FileUpload(vm.ExamineeDetail.OFFFile.Equals("") ? "C" : "U", "ExamOff", vm.ExamineeDetail.OFFFile, "OffFile", Request.Files["OffFile"]);

					if (fileGroupNo <= 0)
						fileSuccess = false;
				}
			}

			if (fileSuccess)
			{
				result = examSvc.offSave(vm, (fileGroupNo.Equals(0) ? vm.ExamineeDetail.OFFFile : fileGroupNo), sessionManager.UserNo); 
			}

			return Json(result);
		}

		public JsonResult UpdateExamineeEstimation(ExamViewModel vm)
		{
			int result = 0;

			vm.ExamineeDetail.FeedbackUserNo = sessionManager.UserNo;
			vm.ExamineeDetail.Gubun = Gubun;

			result = examSvc.EstimationSave(vm);

			return Json(result);
		}

		public JsonResult GetQuestionStatement(int examNo)
		{
			ExamViewModel vm = new ExamViewModel();

			// 문제 목록
			vm.QuestionList = examSvc.ExamStatementList(examNo).ToList();

			return Json(vm);
		}

		public ActionResult AdminExcel(int param1, int param2, string param3)
		{
			ExamViewModel vm = new ExamViewModel();

			vm.ProgramNo = WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? param1 : 2;
			vm.TermNo = param2;
			vm.SearchText = param3;

			vm.QuizList = examSvc.ExamAdminList(vm, "E", Gubun);

			string[] headers;
			string[] colums;

			if (WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				headers = new string[] { "과정", "강의형태", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "분반", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "등록퀴즈수" };
				colums = new string[] { "ProgramName", "StudyTypeName", "SubjectName", "ClassNo", "ProfessorNm", "CreateCnt" };
			}
			else
			{
				headers = new string[] { "강의형태", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "분반", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "등록퀴즈수" };
				colums = new string[] { "StudyTypeName", "SubjectName", "ClassNo", "ProfessorNm", "CreateCnt" };
			}

			return ExportExcel(headers, colums, vm.QuizList, String.Format("퀴즈목록{0}", DateTime.Now.ToString("yyyyMMdd")));
		}
	}
}