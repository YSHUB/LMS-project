using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;

namespace ILMS.Web.Controllers 
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("LecInfo")]
	public class LecInfoController : LectureRoomBaseController
	{
		public StudyService studySvc { get; set; }
		public CourseService courseSvc { get; set; }
		public LecInfoService lecInfoSvc { get; set; }

		[Route("Index/{param1}")]
		public ActionResult Index(CourseViewModel vm, int param1)
		{
			//param1 : CourseNo 강좌번호
			int courseNo = param1;
			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();

			if (ViewBag.Course.IsProf == 1)
			{
				ht.Add("CourseNo", courseNo);
				vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", ht);
			}
			else
			{
				ht.Add("CourseNo", courseNo);
				ht.Add("UserNo", userNo);

				vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_J", ht);

			}

			List<Term> termList = new List<Term>();

			foreach ( Term terms in ViewBag.TermList)
			{
				termList.Add(terms);	
			}
						
			Term term = termList.Where(c => c.TermNo == ViewBag.Course.TermNo).FirstOrDefault();

			vm.LatenessSetupDay = term.LatenessSetupDay;

			return View(vm);
		}

		#region 강의계획설정

		[Route("CoursePlan/{param1}")]
		public ActionResult CoursePlan(int param1)
		{
			//param1 : CourseNo 강좌번호
			CourseViewModel vm = new CourseViewModel();

			// 교과정보 및 주차 리스트 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);
			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", paramHash);

			// 카테고리(Mno) 모달 조회
			Hashtable paramCategory = new Hashtable();
			paramCategory.Add("Mnos", vm.Course != null ? null : vm.Course.Mnos);
			paramCategory.Add("IsOpen", 1);
			vm.CategoryList = baseSvc.GetList<Category>("course.COURSE_CATEGORY_SELECT_L", paramCategory);

			return View(vm);
		}

		[HttpPost]
		[Route("MoocSave/{param1}")]
		public JsonResult MoocSave(CourseViewModel vm)
		{
			//  기본정보 저장
			string Time = " 23:59:59";

			vm.Course.REnd = vm.Course.REnd + Time;
			vm.Course.LEnd = vm.Course.LEnd + Time;
			vm.Course.UpdateUserNo = Convert.ToInt32(sessionManager.UserNo);

			return Json(baseSvc.Save("course.COURSE_SAVE_U", vm.Course));
		}

		[HttpPost]
		[Route("CourseCopyList")]
		public JsonResult CourseCopyList(int courseNo, int subjectNo)
		{
			// 강의계획복사 조회
			Hashtable paramCourse = new Hashtable();
			paramCourse.Add("CourseNo", courseNo);
			paramCourse.Add("SubjectNo", subjectNo);

			var Result = Json(baseSvc.GetList<Inning>("course.COURSE_SELECT_P", paramCourse));
			Result.MaxJsonLength = int.MaxValue;

			return Result;
		}

		[HttpPost]
		[Route("CourseCopySave")]
		public JsonResult CourseCopySave(int courseNo, int copyCourseNo, int week)
		{
			// 강의계획복사
			int cnt = 0;
			int userNo = Convert.ToInt32(sessionManager.UserNo);

			cnt = lecInfoSvc.CourseCopySave(courseNo, copyCourseNo, week, userNo);

			return Json(cnt);
		}

		#endregion 강의계획설정

		[Route("Plan/{param1}")]
		public ActionResult Plan(CourseViewModel vm, int param1)
		{
			// 강좌설명 & 강좌소개
			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", param1);

			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", ht);

			// 평가기준
			Hashtable ht2 = new Hashtable();
			ht2.Add("CourseNo", param1);

			vm.EstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_EST_SELECT_S", ht2);

			// 주차별 강의계획
			Hashtable ht3 = new Hashtable();
			ht3.Add("CourseNo", param1);

			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", ht3);

			// 담당교원/연락처/이메일
			Hashtable ht4 = new Hashtable();
			ht4.Add("CourseNo", param1);

			vm.Professor = baseSvc.GetList<Course>("course.COURSE_PROFESSOR_SELECT_B", ht4).Where(w => w.Usertype == "USRT007").OrderByDescending(w => w.ProfessorCEO).FirstOrDefault();

			return View(vm);

		}

		[Route("StudentStatusOcwUserDetail/{param1}/{param2}")]
		public ActionResult StudentStatusOcwUserDetail(int param1, int param2)
		{
			CourseViewModel vm = new CourseViewModel();

			ViewBag.PageTitle = "학습상황";

			Course course = new Course("L");
			course.CourseNo = param1;

			CourseLecture courselecture = new CourseLecture();
			courselecture.CourseNo = param1;
			courselecture.UserNo = param2;

			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", course);
			vm.LectureUserDetail = baseSvc.Get<CourseLecture>("course.COURSE_LECTURE_SELECT_H", courselecture);

			Hashtable hashtable = new Hashtable();
			hashtable.Add("CourseNo", param1);
			hashtable.Add("ViewUserNo", param2);

			vm.OcwCourseList = baseSvc.GetList<OcwCourse>("ocw.OCW_SELECT_E", hashtable);

			return View(vm);
		}

		[Route("StudyTimePopup/{param1}/{param2}")]
		public ActionResult StudyTimePopup(int param1, int param2)
		{
			CourseViewModel vm = new CourseViewModel();

			Inning inning = new Inning();
			inning.InningNo = param1;
			inning.UserNo = param2;

			StudyInning studyInning = new StudyInning();
			studyInning.InningNo = param1;
			studyInning.UserNo = param2;

			vm.CourseInning = baseSvc.Get<Inning>("course.COURSE_INNING_SELECT_H", inning);
			vm.StudyInningInfo = baseSvc.GetList<StudyInning>("course.USP_STUDY_INNING_SELECT_EXCEL_N", studyInning);
			vm.StudyInningList = baseSvc.GetList<StudyInning>("course.USP_STUDY_INNING_SELECT_EXCEL_O", studyInning);

			return View(vm);
		}

		public JsonResult InningList(int courseno, int weekno)
		{
			// 차시 조회
			Inning inning = new Inning("A");
			inning.CourseNo = courseno;
			inning.Week = weekno;

			List<Inning> InningList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_A", inning).ToList();

			return Json(InningList);
		}

		[Route("Attendance/{param1}")]
		[Route("Attendance/{param1}/{param2}/{param3}/{param4}")]
		public ActionResult Attendance(CourseViewModel vm, int param1, int? param2, int? param3, string param4) // CourseNo, Week, InningNo, SortType
		{
			string userType = sessionManager.UserType;

			if (ViewBag.Course.IsProf != 1)
			{
				return Redirect("/Mypage/LectureRoom");
			}

			// 주차
			vm.CourseNo = param1;
			Inning inning = new Inning("B");
			inning.CourseNo = param1;
			vm.WeekList = baseSvc.GetList<Inning>("common.COURSE_WEEK_SELECT_B", inning).ToList();


			Hashtable ht = new Hashtable();


			if (vm.CourseInning == null)
			{
				vm.CourseInning = new Inning();
				vm.CourseInning.Week = param2 ?? 0;
				vm.CourseInning.InningNo = param3 ?? 0;
				ht.Add("CourseNo", param1);
				ht.Add("InningNo", vm.CourseInning.InningNo);

				vm.StudyInningList = baseSvc.GetList<StudyInning>("course.STUDY_INNING_SELECT_L", ht).ToList();
			}
			else
			{
				int week = vm.CourseInning.Week;
				int inningNo = vm.CourseInning.InningNo;

				ht.Add("CourseNo", param1);
				ht.Add("InningNo", inningNo);


				vm.StudyInningList = baseSvc.GetList<StudyInning>("course.STUDY_INNING_SELECT_L", ht).ToList();
			}

			

			if (!string.IsNullOrEmpty(param4))
			{

				vm.CourseInning.Week = param2 ?? 0;
				vm.CourseInning.InningNo = param3 ?? 0;
				Hashtable ht2 = new Hashtable();
				ht2.Add("CourseNo", param1);
				ht2.Add("InningNo", param3);
				  

				if (param4.Equals("UserID"))
				{
					vm.StudyInningList = baseSvc.GetList<StudyInning>("course.STUDY_INNING_SELECT_L", ht2).OrderBy(x => x.UserID).ToList();
					vm.SortType = "HangulName";
				}
				else
				{
					vm.StudyInningList = baseSvc.GetList<StudyInning>("course.STUDY_INNING_SELECT_L", ht2).OrderBy(x => x.HangulName).ToList();
					vm.SortType = "UserID";
				}
			}
			

			return View(vm);
		}

		[HttpPost]
		[Route("AttendanceSave/{param1}")]
		public JsonResult AttendanceSave(CourseViewModel vm, int param1) // CourseNo
		{
			vm.CourseNo = param1;

			List<StudyInning> StudyInningList = new List<StudyInning>();

			foreach(var item in vm.StudyInningNo)
			{

				StudyInningList.Add(new StudyInning()
				{

					StudyInningNo = Convert.ToInt32(item.Split('|')[0]),
					UpdateUserNo = sessionManager.UserNo,
					UserNo = Convert.ToInt32(item.Split('|')[1]),
					AttendanceStatus = Request["AttendanceStutus" + item.Split('|')[0]],

				});

			}

			int resultCnt = 0;

			resultCnt = studySvc.AttendanceUpdate(StudyInningList);

			if (resultCnt > 0)
			{
				return Json(1);
			}
			else
			{
				return Json(-1);
			}
		}

		[HttpPost]
		public JsonResult MakeRandomNumber(int ino, int cno, int weekno, int seqno)
		{
			Inning courseInnings = new Inning();

			courseInnings.InningNo = ino;
			courseInnings.CourseNo = cno;
			courseInnings.Week = weekno;
			courseInnings.InningSeqNo = seqno;

			Inning issueCourseInnings = new Inning();
			issueCourseInnings = baseSvc.Get<Inning>("course.ATTENDANCE_RANDOM_SELECT_A", courseInnings);

			// 오프라인 강좌만 처리
			if (issueCourseInnings.LectureType.Equals("CINN002"))
			{
				if (issueCourseInnings.IssueYN.Equals("N"))
				{
					return Json(2);
				}
				else
				{
					courseInnings.IssueNo = issueCourseInnings.IssueNo;

					Random random = new Random();
					string random1 = random.Next(0, 100000).ToString("D5");
					string random2 = random.Next(0, 100000).ToString("D5");
					
					courseInnings.Random1 = random1;
					courseInnings.Random2 = random2;
					courseInnings.CreateUserNo = (int)sessionManager.UserNo;

					int resultCnt = 0;
					resultCnt = baseSvc.Save("course.ATTENDANCE_RANDOM_SAVE_C", courseInnings);

					if (resultCnt > 0)
					{
						Hashtable ht = new Hashtable();
						ht.Add("InningNo", ino);
						ht.Add("CourseNo", cno);
						ht.Add("Week", weekno);
						ht.Add("InningSeqNo", seqno);
						ht.Add("IssueNo", courseInnings.IssueNo);

						return Json(baseSvc.Get<Inning>("course.ATTENDANCE_RANDOM_SELECT_S", ht));
					}
					else
					{
						return Json(0);
					}
				}
			}
			else
			{
				return Json(-1);
			}
		}

		[Route("StudentStatusList")]
		[Route("StudentStatusList/{param1}")]
		[Route("StudentStatusList/{param1}/{param2}")]
		public ActionResult StudentStatusList(CourseViewModel vm, int param1, string param2) //int CourseNo, string PageMode
		{

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);
			vm.PageGubun = "StudentStatusList";


			vm.SearchSort = vm.SearchSort ?? "USERNAME";
			vm.SearchOption = vm.SearchOption ?? "ALL";
			vm.SearchGbn = vm.SearchGbn ?? "N";
			vm.SearchStud = vm.SearchStud ?? ""; // 학습진도현황 - 학생명 검색
			
			vm.CourseNo = param1;
			vm.TermNo   = Convert.ToInt32(vm.Course.TermNo);

			//vm.ProgramNo = param3 ?? 0;
			//vm.SearchText = ""; // 학습상황관리 - 강좌명 검색
			vm.PageRowSize = 0; // 지정안할 시  오류 남 공통 ascx 
			vm.PageNum = 0;     // 지정안할 시  오류 남
			
			vm.hdnPageMode = param2 ?? "Progress";

			// 학생 정보 리스트
			Hashtable paramForStudList = new Hashtable();
			paramForStudList.Add("CourseNo", param1);
			paramForStudList.Add("TermNo", vm.TermNo);
			paramForStudList.Add("SearchSort", vm.SearchSort);
			paramForStudList.Add("SearchGbn", vm.SearchGbn);
			paramForStudList.Add("SearchStud", vm.SearchStud);

			if (vm.hdnPageMode.Equals("Progress")) // 학습진도현황
			{
				if (vm.SearchOption.Equals("ALL"))
				{
					vm.StudentList = baseSvc.GetList<Student>("course.COURSE_PROGRESS_DETAIL_SELECT_A", paramForStudList);
				}
				else if (vm.SearchOption.Equals("Absence"))
				{
					vm.StudentList = baseSvc.GetList<Student>("course.COURSE_PROGRESS_DETAIL_SELECT_A", paramForStudList).Where(c => c.FailingGradeYesNo.Equals("Y")).ToList(); ;
				}
				else
				{
					vm.StudentList = baseSvc.GetList<Student>("course.COURSE_PROGRESS_DETAIL_SELECT_A", paramForStudList).Where(c => c.ForeignYesNo.Equals("Y")).ToList();
				}
			}
			else if (vm.hdnPageMode.Equals("Part")) // 참여도현황
			{
				vm.ProgressDetailList = baseSvc.GetList<Hashtable>("course.COURSE_PROGRESS_DETAIL_SELECT_B", paramForStudList);

			}
			else if(vm.hdnPageMode.Equals("Ocw")) // 컨텐츠현황
			{
				vm.ProgressDetailList = baseSvc.GetList<Hashtable>("course.COURSE_PROGRESS_DETAIL_SELECT_C", paramForStudList);
			}

			return View(vm);
		}

		[Route("StudentStatusDetail/{param1}")]
		public ActionResult StudentStatusDetail(int param1, int param2)
		{
			// param1: courseNo, param2: userNo
			CourseViewModel vm = new CourseViewModel();

			//ViewBag.PageTitle = "학습상세";

			Course course = new Course("L");
			course.CourseNo = param1;

			CourseLecture courselecture = new CourseLecture();
			courselecture.CourseNo = param1;
			courselecture.UserNo = param2;

			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", course);

			if (vm.Inning.Count.Equals(0))
			{
				return Redirect(string.Format("{0}?InfoMessage={1}", Request.UrlReferrer.LocalPath, "MSG_NO_STUDY"));
			}
			else
			{
				vm.LectureUserDetail = baseSvc.Get<CourseLecture>("course.COURSE_LECTURE_SELECT_H", courselecture);

				if (vm.LectureUserDetail != null)
				{
					// 학습 참여현황 (온라인강의)
					Hashtable paramStudent = new Hashtable();
					paramStudent.Add("CourseNo", param1);
					paramStudent.Add("UserNo", param2);
					paramStudent.Add("TermNo", vm.LectureUserDetail.TermNo);
					vm.Student = baseSvc.Get<Student>("course.COURSE_PROGRESS_DETAIL_SELECT_A", paramStudent);

					// 학습 참여현황 (과제,강의,토론)
					vm.ProgressDetail = baseSvc.Get<Hashtable>("course.COURSE_PROGRESS_DETAIL_SELECT_B", paramStudent);

					// 학습 참여현황 (접근횟수, 의견 수)
					vm.ProgressDetailOCW = baseSvc.Get<Hashtable>("course.COURSE_PROGRESS_DETAIL_SELECT_C", paramStudent);

					//온라인출결관리 
					Code code = new Code("A");
					code.ClassCode = "CLAT";
					vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

					Inning inning = new Inning("L");
					inning.CourseNo = param1;
					vm.WeekList = baseSvc.GetList<Inning>("common.COURSE_WEEK_SELECT_L", inning);

					StudyInning studyInning = new StudyInning();
					studyInning.CourseNo = param1;
					studyInning.UserNo = param2;
					studyInning.LectureNo = vm.LectureUserDetail.LectureNo;

					vm.StudyInningInfo = baseSvc.GetList<StudyInning>("course.USP_STUDY_INNING_SELECT_EXCEL_K", studyInning);

					DateTime currentDate = DateTime.Now;

					//foreach(Inning item in vm.Inning)
					//{
					//	item.InningEndDay.
					//}

					DateTime maxDate = Convert.ToDateTime(vm.Inning.Max(c => c.InningEndDay));

					if (currentDate >= maxDate)
					{
						vm.RecommandProgressRate = 100;
					}
					else
					{

						var temp = vm.Inning.Where(c => DateTime.Parse(c.InningStartDay) <= currentDate);
						if (temp == null)
						{
							vm.RecommandProgressRate = 0;
						}
						else
						{
							vm.RecommandProgressRate = Math.Round((temp.Count() / (double)(vm.Inning.Count())) * 100, 2);
						}
					}
				}

				return View(vm);
			}			
		}

		[HttpPost]
		public JsonResult OffAttendanceSave(int ino, int cno, int weekno, int seqno, string attCode1, string attCode2)
		{
			int cnt = 0;

			Hashtable paramInning = new Hashtable();
			paramInning.Add("InningNo", ino);
			paramInning.Add("CourseNo", cno);
			paramInning.Add("Week", weekno);
			paramInning.Add("InningSeqNo", seqno);
			paramInning.Add("attCode1", attCode1);
			paramInning.Add("attCode2", attCode2);
			paramInning.Add("UserNo", (int)sessionManager.UserNo);

			StudyInning studyInning = new StudyInning();
			studyInning = baseSvc.Get<StudyInning>("course.STUDY_INNING_SELECT_A", paramInning);

			if (studyInning.IssueNo > 0)
			{
				StudyInning attReasonStudyInning = new StudyInning();
				attReasonStudyInning.StudyInningNo = studyInning.StudyInningNo;
				attReasonStudyInning.UserID = Convert.ToString(studyInning.UserNo);
				attReasonStudyInning.AttendanceStatus = "CLAT001";
				attReasonStudyInning.AttendanceReason = studyInning.IssueNo + "회차 출석코드 : " + attCode1 + " " + attCode2;
				attReasonStudyInning.CreateUserNo = sessionManager.UserNo;
				attReasonStudyInning.UpdateUserNo = sessionManager.UserNo;
				attReasonStudyInning.DeleteYesNo = "N";

				cnt = courseSvc.StudyInningInsert(attReasonStudyInning);
			}
			else
			{
				cnt = 0;
			}

			return Json(cnt);
		}

		public ActionResult ConnectionLogExcel(int param1, int param2)
		{
			// param1 : CourseNo,  param2 : UserNo

			// 엑셀다운로드
			Hashtable hash = new Hashtable();
			hash.Add("CourseNo", param1);
			hash.Add("UserNo", param2);

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("course.USP_STUDY_INNING_SELECT_EXCEL_K2", hash);

			string[] headers = new string[] { "주차", "차시", "학습시간(분)", "강의접속수", "최초학습일", "학습완료일", "최근학습일" };
			string[] columns = new string[] { "Week", "InningSeqNo", "StudyTimeExcel", "StudyConnectCount", "StudyStartDateTime", "StudyEndDateTime", "StudyLatelyDateTime" };
			string excelFileName = String.Format("학습로그_{0}", DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, hashList, excelFileName); ;
		}

		[Route("StudentTimeDetail/{param1}")]
		public ActionResult StudentTimeDetail(int param1)
		{
			//param1 : CourseNo 강좌번호

			return View();
		}

		public ActionResult CourseLectureProgressInfoExcel(CourseViewModel vm, int param1, string param2)
		{
			List<StudyInning> courseAttendanceList = new List<StudyInning>();

			#region 기본정보
			//Course기본정보
			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", ht);
			#endregion

			#region 출결정보
			string userID = string.Empty;
			string hangulName = string.Empty;

			if (string.IsNullOrEmpty(vm.SearchOption))
				vm.SearchOption = "ALL";

			if (!string.IsNullOrEmpty(vm.SearchStud))
			{
				if (vm.SearchOption.ToUpper().Equals("USERID"))
				{
					userID = vm.SearchStud;
				}
				else if (vm.SearchOption.ToUpper().Equals("USERNAME"))
				{
					hangulName = vm.SearchStud;
				}
			}


			if (vm.SearchOption.Equals("Absence")) // 1/3 결석자
			{
				vm.StudyInningList = CourseAttendance(param1, userID, hangulName).Where(c => c.FailingGradeYesNo.Equals("Y")).ToList(); 
			}
			else if (vm.SearchOption.Equals("Foriegn")) // 외국인학생
			{
				vm.StudyInningList = CourseAttendance(param1, userID, hangulName).Where(c => c.ForeignYesNo.Equals("Y")).ToList();
			}
			else
			{
				vm.StudyInningList = CourseAttendance(param1, userID, hangulName);
			}
			#endregion

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);


			// 학생 정보 리스트
			Hashtable paramForStudList = new Hashtable();
			paramForStudList.Add("CourseNo", param1);
			paramForStudList.Add("TermNo", vm.Course.TermNo);
			paramForStudList.Add("SearchSort", vm.SearchSort);
			paramForStudList.Add("SearchGbn", vm.SearchGbn);
			paramForStudList.Add("SearchStud", vm.SearchStud);

			//학습참여도 현황 <- 진도현황도 해당쿼리에서 모두 찾아짐
			vm.ProgressDetailList = baseSvc.GetList<Hashtable>("course.COURSE_PROGRESS_DETAIL_SELECT_B", paramForStudList);

			var temp1 = (from c in vm.ProgressDetailList
						 join x in vm.StudyInningList on c["UserNo"] equals x.UserNo
						 select c).ToList();

			// 시험 응시대상자 
			Examinee examinee = new Examinee("L");
			examinee.CourseNo = vm.CourseNo;
			vm.ExamineeList = baseSvc.GetList<Examinee>("exam.EXAMINEE_SELECT_L", examinee);

			vm.ProgressDetailList = temp1;
			if (param2.Equals("Y"))
			{
				foreach (var item in vm.ProgressDetailList)
				{
					StudyInning tempAtt = new StudyInning();

					tempAtt = vm.StudyInningList.Where(c => c.UserNo == (long)item["UserNo"]).FirstOrDefault();

					item["strHangulName"] = item["HangulName"] + (item["ForeignYesNo"] != null && item["ForeignYesNo"].Equals("Y") ? "(외)" : "");
					item["strAttendanceCount"] = "&nbsp;" + tempAtt.TotalStudy.ToString() + " / " + tempAtt.TotalInning.ToString();
					item["strHomework"] = string.Format("&nbsp;{0} / {1}", item["HomeworkSubmitCount"], item["HomeworkCount"]);
					item["strQuiz"] = string.Format("&nbsp;{0} / {1}", item["QuizSubmitCount"], item["QuizCount"]);
					item["strProject"] = string.Format("&nbsp;{0} / {1}", item["TeamProjectSubmitCount"], item["TeamProjectCount"]);
					item["strExamStatus1"] = vm.GetExamStatusString(Convert.ToInt64(item["UserNo"]), "CHEK001").ToString();
					item["strExamStatus2"] = vm.GetExamStatusString(Convert.ToInt64(item["UserNo"]), "CHEK002").ToString();
					item["UserID"] = "&nbsp;" + item["UserID"];
				}

				if (WebConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
				{
					return ExportExcel(new string[] { "소속", WebConfigurationManager.AppSettings["StudIDText"].ToString(), "이름", "학적", "학습현황", "과제", "퀴즈", "팀프로젝트", "중간", "기말" }
									 , new string[] { "AssignName", "UserID", "strHangulName", "HakjeokGubunName", "strAttendanceCount", "strHomework", "strQuiz", "strProject", "strExamStatus1", "strExamStatus2" }
									 , vm.ProgressDetailList, String.Format("학습진도현황_{0}", DateTime.Now.ToString("yyyyMMdd")));
				}
				else
				{
					return ExportExcel(new string[] { WebConfigurationManager.AppSettings["StudIDText"].ToString(), "이름", "학습현황", "과제", "퀴즈", "성취도평가" }
									 , new string[] { "UserID", "strHangulName", "strAttendanceCount", "strHomework", "strQuiz", "strExamStatus1" }
									 , vm.ProgressDetailList, String.Format("학습진도현황_{0}", DateTime.Now.ToString("yyyyMMdd")));
				}
				
			}
			else
			{

				foreach (var item in vm.ProgressDetailList)
				{
					item["strHangulName"] = item["HangulName"] + (item["ForeignYesNo"] != null && item["ForeignYesNo"].Equals("Y") ? "(외)" : "");
					item["InningCount"] = vm.StudyInningList.Where(c => c.UserNo == (long)item["UserNo"]).FirstOrDefault().TotalInning;
					item["strAttendanceCount"] = vm.StudyInningList.Where(c => c.UserNo == (long)item["UserNo"]).FirstOrDefault().TotalStudy;
					item["strQandACount"] = string.Format("&nbsp;{0} / {1}", item["QACheckCount"], item["QACount"].ToString());
					item["strDisscussionCount"] = string.Format("&nbsp;{0} / {1}", item["DiscussionCheckCount"], item["DiscussionCount"].ToString());

				}

				if (WebConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
				{
					return ExportExcel(new string[] { "소속", WebConfigurationManager.AppSettings["StudIDText"].ToString(), "이름", "학적", "강의 Q&A", "토론방" }
									 , new string[] { "AssignName", "UserID", "strHangulName", "HakjeokGubunName", "strQandACount", "strDisscussionCount" }, vm.ProgressDetailList, String.Format("학습참여도현황_{0}", DateTime.Now.ToString("yyyyMMdd")));
				}
				else
				{
					return ExportExcel(new string[] { WebConfigurationManager.AppSettings["StudIDText"].ToString(), "이름", "강의 Q&A", "토론방" }
									 , new string[] { "AssignName", "UserID", "strHangulName", "HakjeokGubunName", "strQandACount", "strDisscussionCount" }, vm.ProgressDetailList, String.Format("학습참여도현황_{0}", DateTime.Now.ToString("yyyyMMdd")));
				}

			}

		}

		public List<StudyInning> CourseAttendance(int param1, string userID, string hangulName)
		{
			List<StudyInning> courseAttendanceList = new List<StudyInning>();

			IList<Inning> courseInningLIst = new List<Inning>();
			IList<StudyInning> courseStudentList = new List<StudyInning>();
			IList<Inning> studyInningList = new List<Inning>();


			Hashtable ht2 = new Hashtable();
			ht2.Add("CourseNo", param1);

			courseInningLIst = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", ht2);

			Hashtable ht3 = new Hashtable();
			ht3.Add("CourseNo", param1);
			ht3.Add("HangulName", hangulName);
			ht3.Add("UserID", userID);

			courseStudentList = baseSvc.GetList<StudyInning>("course.STUDY_INNING_SELECT_X", ht2);

			Hashtable ht4 = new Hashtable();
			ht4.Add("CourseNo", param1);

			studyInningList = baseSvc.GetList<Inning>("course.COURSE_GRADE_SELECT_C", ht4);

			#region 출석처리 시 중간고사, 기말고사는 제외하도록 요청 - 17.01.05 교무부서

			if (studyInningList.Count() > 0)
			{
				studyInningList = studyInningList.Where(c => !c.LessonForm.Equals("CINM002") && !c.LessonForm.Equals("CINM003")).ToList();
			}

			int TotalInning = courseInningLIst.Where(c => !c.LessonForm.Equals("CINM002") && !c.LessonForm.Equals("CINM003")).Count();

			#endregion 출석처리 시 중간고사, 기말고사는 제외하도록 요청 - 17.01.05 교무부서 요청사항

			Hashtable ht5 = new Hashtable();
			ht5.Add("CourseNo", param1);

			Course course = baseSvc.Get<Course>("course.COURSE_SELECT_S", ht5);

			// 1/3 결석자 판별
			if (courseStudentList.Count > 0)
			{
				double LatenessPenaltyPoint = (double)courseStudentList.FirstOrDefault().LatenessPenaltyValue;
				double AbsencePenaltyPoint = (double)courseStudentList.FirstOrDefault().AbsencePenaltyValue;

				foreach (var item in courseStudentList)
				{
					int TotalRateScore = courseInningLIst.Where(c => DateTime.Parse(c.InningStartDay) <= DateTime.Now).Count();// 출석할 총 갯수
					int TotalCLAT001Score = studyInningList.Where(c => c.AttendanceStatus.Equals("CLAT001") && c.UserNo == item.UserNo).Count();// 출석한 총 갯수
					int TotalCLAT003Score = studyInningList.Where(c => c.AttendanceStatus.Equals("CLAT003") && c.UserNo == item.UserNo).Count();// 지각한 총 갯수
					int TotalCLAT005Score = studyInningList.Where(c => c.AttendanceStatus.Equals("CLAT005") && c.UserNo == item.UserNo).Count();// 조퇴한 총 갯수

					int OnlineAttendance = studyInningList.Count(c => c.UserNo == item.UserNo && c.LectureType.ToString().Equals("CINN001") && c.AttendanceStatus.ToString().Equals("CLAT001"));
					int OnlineLateness = studyInningList.Count(c => c.UserNo == item.UserNo && c.LectureType.ToString().Equals("CINN001") && c.AttendanceStatus.ToString().Equals("CLAT003"));
					int OnlineEarlyLeave = studyInningList.Count(c => c.UserNo == item.UserNo && c.LectureType.ToString().Equals("CINN001") && c.AttendanceStatus.ToString().Equals("CLAT005"));
					int OnlineAbsence = studyInningList.Count(
																c => c.UserNo == item.UserNo
																&& c.LectureType.ToString().Equals("CINN001")
																&& (c.AttendanceStatus.ToString().Equals("CLAT002") || c.AttendanceStatus.ToString().Equals("CLAT004"))
																&& (((DateTime.Parse(c.InningLatenessEndDay) == new DateTime(0001, 01, 01, 00, 00, 00)) ? DateTime.Parse(c.InningEndDay) : DateTime.Parse(c.InningLatenessEndDay)) < DateTime.Now)
															);

					int OfflineAttendance = studyInningList.Count(c => c.UserNo == item.UserNo && c.LectureType.ToString().Equals("CINN002") && c.AttendanceStatus.ToString().Equals("CLAT001"));
					int OfflineLateness = studyInningList.Count(c => c.UserNo == item.UserNo && c.LectureType.ToString().Equals("CINN002") && c.AttendanceStatus.ToString().Equals("CLAT003"));
					int OfflineEarlyLeave = studyInningList.Count(c => c.UserNo == item.UserNo && c.LectureType.ToString().Equals("CINN002") && c.AttendanceStatus.ToString().Equals("CLAT005"));
					int OfflineAbsence = studyInningList.Count(c => c.UserNo == item.UserNo && c.LectureType.ToString().Equals("CINN002") && c.AttendanceStatus.ToString().Equals("CLAT002"));
					int OfflineStandby = studyInningList.Count(c => c.UserNo == item.UserNo && c.LectureType.ToString().Equals("CINN002") && c.AttendanceStatus.ToString().Equals("CLAT004"));
					int TotalAttendance = studyInningList.Count(c => c.UserNo == item.UserNo && c.AttendanceYesNo.ToString().Equals("Y"));
					int AttendanceTime = studyInningList.Where(c => c.UserNo == item.UserNo && c.AttendanceYesNo.ToString().Equals("Y")).Sum(c => c.AttendanceTime);


					StudyInning attendance = new StudyInning();
					attendance.UserNo = item.UserNo;
					attendance.HangulName = item.HangulName;
					attendance.AssignName = item.AssignName;
					attendance.UserTypeName = item.UserTypeName;
					attendance.UserID = item.UserID;
					attendance.StudentNo = item.StudentNo;
					attendance.UniversityName = item.UniversityName;
					attendance.ForeignYesNo = item.ForeignYesNo;
					attendance.Grade = item.Grade;
					attendance.HakjeokGubunName = item.HakjeokGubunName;


					attendance.OnlineAttendance = OnlineAttendance;
					attendance.OnlineLateness = OnlineLateness;
					attendance.OnlineEarlyLeave = OnlineEarlyLeave;
					attendance.OnlineAbsence = OnlineAbsence;

					attendance.OfflineAttendance = OfflineAttendance;
					attendance.OfflineLateness = OfflineLateness;
					attendance.OfflineEarlyLeave = OfflineEarlyLeave;
					attendance.OfflineAbsence = OfflineAbsence;
					attendance.OfflineStandby = OfflineStandby;

					attendance.TotalAttendance = OnlineAttendance + OfflineAttendance;
					attendance.TotalLateness = OnlineLateness + OfflineLateness;
					attendance.TotalEarlyLeave = OnlineEarlyLeave + OfflineEarlyLeave;
					attendance.TotalAbsence = OnlineAbsence + OfflineAbsence + OfflineStandby;
					attendance.TotalStudy = attendance.TotalAttendance + attendance.TotalLateness + attendance.TotalEarlyLeave - (attendance.TotalEarlyLeave / 3);
					attendance.TotalInning = TotalInning;


					if (TotalInning - TotalCLAT001Score - TotalCLAT003Score - TotalCLAT005Score + (TotalCLAT005Score / 3) > (TotalRateScore * 0.33))
					{
						attendance.FailingGradeYesNo = "Y";
					}
					else
					{
						attendance.FailingGradeYesNo = "N";
					}

					courseAttendanceList.Add(attendance);
				}
				
			}

			return courseAttendanceList.ToList();

		}

		//출석-성적부 엑셀다운로드
		public ActionResult GradeListEstimationExcel(int param1, string param2)
		{
			CourseViewModel vm = new CourseViewModel();

			Course course = new Course();
			course.CourseNo = param1;

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_H", course);
			int baseCourseNo = vm.CourseList[0].CourseNo;

			EstimationItemBasis estimationItemBasis = new EstimationItemBasis();
			estimationItemBasis.CourseNo = baseCourseNo;

			vm.EstimationBasis = baseSvc.Get<EstimationItemBasis>("course.COURSE_SELECT_I", estimationItemBasis);
			vm.EstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_SELECT_J", estimationItemBasis);

			EstimationItemBasis participationEstimationItemBasis = new EstimationItemBasis();
			participationEstimationItemBasis.CourseNo = baseCourseNo;

			vm.ParticipationEstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_SELECT_K", participationEstimationItemBasis);

			IList<Grade> GradeList = new List<Grade>();
			if (vm.EstimationBasis != null)
			{
				GradeList = courseSvc.GradeList(vm.CourseList, vm.EstimationBasis, vm.EstimationItemBasis, vm.ParticipationEstimationItemBasis);
			}

			if (param2.Equals("Absence"))
			{
				vm.GradeList = GradeList.Where(c => c.FailingGradeYesNo.Equals("Y")).ToList();
			}
			else if (param2.Equals("Foriegn"))
			{
				vm.GradeList = GradeList.Where(c => c.ForeignYesNo.Equals("Y")).ToList();
			}
			else
			{
				vm.GradeList = GradeList.OrderBy(c => c.HangulName).ToList();
			}

			Inning weekInning = new Inning("L");
			weekInning.CourseNo = param1;
			vm.GradeToWeekList = baseSvc.GetList<Inning>("course.COURSE_GRADE_SELECT_J", weekInning);

			weekInning = new Inning("I");
			weekInning.CourseNo = param1;
			vm.GradeToStatusList = baseSvc.GetList<Inning>("course.COURSE_GRADE_SELECT_I", weekInning);

			course = new Course();
			course.CourseNo = param1;
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", course);

			String tempGrid = "<table cellspacing='0' rules='all' border='1' style='border-collapse:collapse;'>";
			tempGrid += "<tr><th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>NO</th>";
			if (WebConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
			{
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>소속</th>";
			}
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>" + WebConfigurationManager.AppSettings["StudIDText"].ToString() + "</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>이름</th>";
			tempGrid += "{0}";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>출/지/결/미</th>";
			if (WebConfigurationManager.AppSettings["UnivCode"].Equals("KIRIA"))
			{
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>성취도평가</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>출석</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>과제</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>퀴즈</th>";
			}
			else
			{
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>중간</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>기말</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>출석</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>과제</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>퀴즈</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>팀프로젝트</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>기타</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>참여도</th>";
				tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>합계</th>";
			}
			tempGrid += "</tr><tr>{1}</tr>";

			String tempHeadWeek = "";
			String tempHeadinningSeq = "";
			for (int i = 0; i < vm.GradeToWeekList.Count; i++)
			{
				tempHeadWeek += string.Format("<th colspan='{1}' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>{0}</th>", vm.GradeToWeekList[i].Week, vm.GradeToWeekList[i].InningSeqNo);
				for (int j = 0; j < vm.GradeToWeekList[i].InningSeqNo; j++)
				{
					tempHeadinningSeq += string.Format("<th style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>{0}</th>", (j + 1));
				}
			}
			tempGrid = string.Format(tempGrid, tempHeadWeek, tempHeadinningSeq);

			string[] StudyStatusInfo = null;
			string strType = string.Empty;
			string strClass = string.Empty;
			int itype1, itype2, itype3, itype4;
			if (vm.GradeList.Count() < 1)
			{
				vm.GradeList.Add(new Grade() { });
			}
			for (int i = 0; i < vm.GradeList.Count; i++)
			{
				tempGrid += "<tr>";
				tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", (i + 1));
				if (WebConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
				{
					tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].AssignName ?? "");
				}
				tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].UserID ?? "");
				tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].HangulName ?? "");

				// 학습 데이터
				if (vm.GradeToStatusList.Where(c => c.UserNo == vm.GradeList[i].UserNo).FirstOrDefault() != null)
				{
					StudyStatusInfo = (vm.GradeToStatusList.Where(c => c.UserNo == vm.GradeList[i].UserNo).FirstOrDefault().StudyStatus ?? "").Split(new string[] { "," }, StringSplitOptions.None);
					itype1 = itype2 = itype3 = itype4 = 0;
					if (StudyStatusInfo[0] != "")
					{
						for (int j = 0; j < StudyStatusInfo.Length; j++)
						{
							string[] strStudyInfo = StudyStatusInfo[j].Split(new string[] { "|" }, StringSplitOptions.None);

							switch (strStudyInfo[0])
							{
								case "CLAT001":
									strType = "O"; itype1++; break;
								case "CLAT003":
									strType = "X"; itype2++; break;
								case "CLAT002":
									strType = "/"; itype3++; break;
								case "CLAT004":
									strType = "*"; itype4++; break;
							}

							strClass = (strStudyInfo[1] == "CINN001") ? "color:blue;" : "color:red;";
							tempGrid += string.Format("<td style='{1} mso-data-placement:same-cell; text-align:center;'>{0}</td>", strType, strClass);
						}
					}
					tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}/{1}/{2}/{3}</td>", itype1.ToString(), itype2.ToString(), itype3.ToString(), itype4.ToString());
					if (WebConfigurationManager.AppSettings["UnivCode"].Equals("KIRIA"))
					{
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].MidtermExam);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].Attendance);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].HomeWork);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].Quiz);
					}
					else
					{
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].MidtermExam);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].FinalExam);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].Attendance);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].HomeWork);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].Quiz);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].TeamProject);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].Etc);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].Participation);
						tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;'>{0}</td>", vm.GradeList[i].TotalScore);
					}
					
				}
				else
				{
					tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;' colspan='11'>-데이터가 없습니다.-</td>");
				}
				tempGrid += "</tr>";
			}

			tempGrid += "</table>";

			String PageName = HttpUtility.UrlEncode("출석성적.xls", Encoding.UTF8);

			//Response.AppendHeader("Content-Disposition", "attachment; filename=" + PageName);
			//Response.AppendHeader("Content-Type", "application/vnd.ms-excel");
			//Response.Output.Write("\n<html>\n<body>");
			//Response.Output.Write(tempGrid);
			//Response.Output.Write("\n</body>\n</html>");
			//Response.Flush();
			//System.Web.HttpContext.Current.ApplicationInstance.CompleteRequest();

			System.Text.StringBuilder sbResponseString = new System.Text.StringBuilder();

			sbResponseString.Append("<html xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns=\"http://www.w3.org/TR/REC-html40\">");
			sbResponseString.Append("<head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\"><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>Sheet1</x:Name><x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head> <body>");
			sbResponseString.Append(tempGrid + "</body></html>");

			Response.Clear();
			Response.AppendHeader("Content-Type", "application/vnd.ms-excel");
			Response.AppendHeader("Content-disposition", "attachment; filename=" + PageName);
			Response.Charset = "utf-8";
			Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");

			Response.Write(sbResponseString.ToString());
			Response.Flush();
			System.Web.HttpContext.Current.ApplicationInstance.CompleteRequest();

			return null;
		}

		public ActionResult ListStudent(int param1)
		{
			return StudentStatusDetail(param1, (int)sessionManager.UserNo);
		}

		public ActionResult ListStudentOcw(int param1)
		{
			return StudentStatusOcwUserDetail(param1, (int)sessionManager.UserNo);
		}

		public ActionResult GradeList(CourseViewModel vm, int param1)
		{
			Course course = new Course();
			course.CourseNo = param1;

			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", course);
			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_H", course);

			EstimationItemBasis estimationItemBasis = new EstimationItemBasis();
			estimationItemBasis.CourseNo = vm.Course.CourseNo;

			vm.EstimationBasis = baseSvc.Get<EstimationItemBasis>("course.COURSE_SELECT_I", estimationItemBasis);
			vm.EstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_SELECT_J", estimationItemBasis);

			if(vm.EstimationBasis != null)
			{
				vm.EstimationBasis.MidtermExamRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT001")).FirstOrDefault().RateScore;
				vm.EstimationBasis.FinalExamRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT002")).FirstOrDefault().RateScore;
				vm.EstimationBasis.QuizRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT003")).FirstOrDefault().RateScore;
				vm.EstimationBasis.HomeworkRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT004")).FirstOrDefault().RateScore;
				vm.EstimationBasis.AttendanceRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT006")).FirstOrDefault().RateScore;
			}

			EstimationItemBasis participationEstimationItemBasis = new EstimationItemBasis();
			participationEstimationItemBasis.CourseNo = vm.Course.CourseNo;

			vm.ParticipationEstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_SELECT_K", participationEstimationItemBasis);

			if (vm.CourseList != null && vm.EstimationBasis != null && vm.EstimationItemBasis != null)
			{
				IList<Grade> GradeList = courseSvc.GradeList(vm.CourseList, vm.EstimationBasis, vm.EstimationItemBasis, vm.ParticipationEstimationItemBasis);

				if (GradeList != null)
				{
					vm.GradeList = GradeList.OrderBy(x => x.HangulName).ToList();
				}
				else
				{
					vm.GradeList = new List<Grade>();
				}
			}
			else
			{
				vm.GradeList = new List<Grade>();
			}
			
			vm.ListType = "Absolute";

			return View(vm);
		}

		[HttpPost]
		public ActionResult AbsoluteEvaluation(CourseViewModel vm)
		{
			Course course = new Course();
			course.CourseNo = vm.Course.CourseNo;

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_H", course);

			EstimationItemBasis estimationItemBasis = new EstimationItemBasis();
			estimationItemBasis.CourseNo = vm.Course.CourseNo;

			vm.EstimationBasis = baseSvc.Get<EstimationItemBasis>("course.COURSE_SELECT_I", estimationItemBasis);
			vm.EstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_SELECT_J", estimationItemBasis);

			vm.EstimationBasis.MidtermExamRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT001")).FirstOrDefault().RateScore;
			vm.EstimationBasis.FinalExamRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT002")).FirstOrDefault().RateScore;
			vm.EstimationBasis.QuizRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT003")).FirstOrDefault().RateScore;
			vm.EstimationBasis.HomeworkRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT004")).FirstOrDefault().RateScore;
			vm.EstimationBasis.AttendanceRatio = vm.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT006")).FirstOrDefault().RateScore;

			EstimationItemBasis participationEstimationItemBasis = new EstimationItemBasis();
			participationEstimationItemBasis.CourseNo = vm.Course.CourseNo;

			vm.ParticipationEstimationItemBasis = baseSvc.GetList<EstimationItemBasis>("course.COURSE_SELECT_K", participationEstimationItemBasis);

			IList<Grade> GradeList = new List<Grade>();
			GradeList = courseSvc.GradeList(vm.CourseList, vm.EstimationBasis, vm.EstimationItemBasis, vm.ParticipationEstimationItemBasis);

			List<Grade> InsertGradeList = new List<Grade>();

			foreach (var item in GradeList.Where(c => c.EstimationType.Equals("CEST002") || c.EstimationType.Equals("CEST003")))
			{
				Grade InsertGrade = new Grade();

				InsertGrade.CourseNo = item.CourseNo;
				InsertGrade.UserNo = item.UserNo;

				InsertGrade.MidtermExamPerfectScore = item.MidtermExamPerfectScore;
				InsertGrade.MidtermExamScore = item.MidtermExamScore;
				InsertGrade.MidtermExam = item.MidtermExam;

				InsertGrade.FinalExamPerfectScore = item.FinalExamPerfectScore;
				InsertGrade.FinalExamScore = item.FinalExamScore;
				InsertGrade.FinalExam = item.FinalExam;

				InsertGrade.AttendancePerfectScore = item.AttendancePerfectScore;
				InsertGrade.AttendanceScore = item.AttendanceScore;
				InsertGrade.Attendance = item.Attendance;

				InsertGrade.HomeWorkPerfectScore = item.HomeWorkPerfectScore;
				InsertGrade.HomeWorkScore = item.HomeWorkScore;
				InsertGrade.HomeWork = item.HomeWork;

				InsertGrade.QuizPerfectScore = item.QuizPerfectScore;
				InsertGrade.QuizScore = item.QuizScore;
				InsertGrade.Quiz = item.Quiz;

				InsertGrade.TotalScore = item.TotalScore;
				InsertGrade.IsPass = item.TotalScore >= vm.Course.PassPoint ? 1 : 0;
				InsertGrade.LectureNo = item.LectureNo;

				if (Request["Grade_" + item.UserNo.ToString()] != null)
					InsertGrade.GradeText = Request["Grade_" + item.UserNo.ToString()].ToString();
				else
					InsertGrade.GradeText = "";

				InsertGrade.FailingGradeYesNo = item.FailingGradeYesNo;
				InsertGrade.EstimationType = item.EstimationType;
				InsertGrade.CreateUserNo = sessionManager.UserNo;
				InsertGrade.UpdateUserNo = sessionManager.UserNo;

				InsertGradeList.Add(InsertGrade);
			}

			int result = courseSvc.GradeUpdate(InsertGradeList);

			return RedirectToAction("/LecInfo/GradeList", new { param1 = vm.Course.CourseNo });
		}

		[HttpPost]
		public ActionResult AbsoluteEvaluation_Delete(CourseViewModel vm)
		{
			IList<Student> StudentList = new List<Student>();

			Hashtable paramHash = new Hashtable();

			paramHash.Add("RowState", "B");
			paramHash.Add("CourseNo", vm.Course.CourseNo);

			StudentList = baseSvc.GetList<Student>("course.COURSE_LECTURE_SELECT_B", paramHash);

			List<Grade> DeleteGradeList = new List<Grade>();

			foreach (var item in StudentList)
			{
				Grade DeleteGrade = new Grade();

				DeleteGrade.CourseNo = vm.Course.CourseNo;
				DeleteGrade.UserNo = item.UserNo;
				DeleteGrade.LectureNo = item.LectureNo;

				DeleteGradeList.Add(DeleteGrade);
			}

			int ret = courseSvc.GradeDelete(DeleteGradeList);

			return RedirectToAction("/LecInfo/GradeList", new { param1 = vm.Course.CourseNo });
		}

	}
}