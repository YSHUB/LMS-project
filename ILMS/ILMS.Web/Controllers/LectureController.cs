using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;
using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;

namespace ILMS.Web.Controllers
{
	[RoutePrefix("Lecture")]
	public class LectureController : AdminBaseController
	{
		CourseService courseSvc = new CourseService();

		[AuthorFilter(IsAdmin = true)]
		[Route("StatisticsListAdmin")]
		public ActionResult StatisticsListAdmin(StatisticsViewModel vm)
		{
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;
			
			// 학기 바인딩
			vm.Term = new Term();
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term());
			vm.TermList = vm.TermList.Where(c => DateTime.ParseExact(c.TermStartDay, "yyyy-MM-dd", null) <= DateTime.Now).OrderByDescending(c => c.TermNo).ToList();

			vm.TermNo = vm.TermNo > 0 ? vm.TermNo : baseSvc.Get<int>("term.TERM_SELECT_C", new Term());

			// 학생별이수현황 조회
			Hashtable paramForStudent = new Hashtable();
			paramForStudent.Add("TermNo", vm.TermNo);
			paramForStudent.Add("SearchSubject", vm.SearchSubject);
			paramForStudent.Add("SearchText", vm.SearchName);
			paramForStudent.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramForStudent.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));

			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_STUDENT_SELECT_L", paramForStudent);

			vm.PageTotalCount = vm.StatisticsList.FirstOrDefault() != null ? vm.StatisticsList.FirstOrDefault().TotalCount : 0;

			vm.Dic = new RouteValueDictionary
			{
				{ "TermNo", vm.TermNo }, { "SearchSubject", vm.SearchSubject }, { "SearchName", vm.SearchName }, { "PageRowsize", vm.PageRowSize }
			};

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("StudentExcel")]
		public ActionResult StudentExcel(StatisticsViewModel vm)
		{
			Hashtable paramForExcel = new Hashtable();
			paramForExcel.Add("RowState", "L");
			paramForExcel.Add("TermNo", vm.TermNo);
			paramForExcel.Add("SearchSubject", vm.SearchSubject);
			paramForExcel.Add("SearchText", vm.SearchName);

			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_STUDENT_SELECT_L", paramForExcel);

			string[] headers;
			string[] colums;

			if (vm.UnivYN().Equals("Y"))
			{
				headers = new string[] { "연번", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "분반", "소속", WebConfigurationManager.AppSettings["StudIDText"].ToString(), "성명", "학적", "수강강의수", "등록된강의수", "강의이수율", "퀴즈제출수", "퀴즈현황", "퀴즈이수율" };
				colums = new string[] { "RowNum", "SubjectName", "ClassNo", "AssignName", "UserID", "HangulName", "HakjeokGubunName", "AttendanceCourse", "EnrollCourse", "CourseRate", "AttendanceQuiz", "EnrollQuiz", "QuizRate" };
			}
			else
			{
				headers = new string[] { "연번", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "분반", "구분", WebConfigurationManager.AppSettings["StudIDText"].ToString(), "성명", "수강강의수", "등록된강의수", "강의이수율", "퀴즈제출수", "퀴즈현황", "퀴즈이수율" };
				colums = new string[] { "RowNum", "SubjectName", "ClassNo", "GeneralUserCode", "UserID", "HangulName", "AttendanceCourse", "EnrollCourse", "CourseRate", "AttendanceQuiz", "EnrollQuiz", "QuizRate" };
			}

			return ExportExcel(headers, colums, vm.StatisticsList, String.Format("{0}별이수현황_{1}", WebConfigurationManager.AppSettings["StudentText"].ToString(), DateTime.Now.ToString("yyyyMMdd")));
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("StatisticsOutAdmin")]
		public ActionResult StatisticsOutAdmin(StatisticsViewModel vm)
		{
			//페이징 처리
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			//년도 학기 설정
			vm.Term = new Term();
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term());
			vm.TermList = vm.TermList.Where(c => DateTime.ParseExact(c.TermStartDay, "yyyy-MM-dd", null) <= DateTime.Now).OrderByDescending(c => c.TermNo).ToList();

			vm.TermNo = vm.TermNo > 0 ? vm.TermNo : baseSvc.Get<int>("term.TERM_SELECT_C", new Term());

			//처음 로드 시 과목 리스트 조회
			Course paramForSubject = new Course();
			paramForSubject.TermNo = vm.TermNo;
			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_M", paramForSubject);

			if (vm.CourseList.Count() > 0)
			{
				vm.CourseNo = vm.CourseNo > 0 ? vm.CourseNo : vm.CourseList.FirstOrDefault().CourseNo;
			}

			//검색 조회
			Hashtable paramForMooc = new Hashtable();
			paramForMooc.Add("TermNo", vm.TermNo);
			paramForMooc.Add("CourseNo", vm.CourseNo);
			paramForMooc.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramForMooc.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));

			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_OUTADMIN_SELECT_L", paramForMooc);
			
			//시험 과목 조회
			Hashtable paramForExam = new Hashtable();
			paramForExam.Add("CourseNo", vm.CourseNo);

			vm.ExamList = baseSvc.GetList<Statistics>("statistics.STATISTICS_OUTADMIN_SELECT_A", paramForExam);

			vm.PageTotalCount = vm.StatisticsList.FirstOrDefault() != null ? vm.StatisticsList.FirstOrDefault().TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "TermNo", vm.TermNo }, { "CourseNo", vm.CourseNo }, { "PageRowSize", vm.PageRowSize } };
			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("MenuAdminExcel")]
		public ActionResult MenuAdminExcel(StatisticsViewModel vm)
		{
			Hashtable paramForExcel = new Hashtable();
			paramForExcel.Add("RowState", "L");
			paramForExcel.Add("TermNo", vm.TermNo);
			paramForExcel.Add("CourseNo", vm.CourseNo);
			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_OUTADMIN_SELECT_L", paramForExcel);

			string[] headers;
			string[] colums;

			if (vm.UnivYN().Equals("Y"))
			{
				headers = new string[] { "소속", "수강인원", "등록차시", "강의이수완료자", "강의이수완료율", "퀴즈(1) 응시자", "퀴즈(1) 응시율", "퀴즈(2) 응시자", "퀴즈(2) 응시율", "퀴즈(3) 응시자", "퀴즈(3) 응시율", "퀴즈(4) 응시자", "퀴즈(4) 응시율", "퀴즈(5) 응시자", "퀴즈(5) 응시율" };
				colums = new string[] { "AssignName", "PersonCount", "EnrollCourse", "AttendanceCourse", "AttendanceCourseRate", "TakeExaminee1", "TakeExamineeRate1", "TakeExaminee2", "TakeExamineeRate2", "TakeExaminee3", "TakeExamineeRate3", "TakeExaminee4", "TakeExamineeRate4", "TakeExaminee5", "TakeExamineeRate5" };
			}
			else
			{
				headers = new string[] { "수강인원", "등록차시", "강의이수완료자", "강의이수완료율", "퀴즈(1) 응시자", "퀴즈(1) 응시율", "퀴즈(2) 응시자", "퀴즈(2) 응시율", "퀴즈(3) 응시자", "퀴즈(3) 응시율", "퀴즈(4) 응시자", "퀴즈(4) 응시율", "퀴즈(5) 응시자", "퀴즈(5) 응시율" };
				colums = new string[] { "PersonCount", "EnrollCourse", "AttendanceCourse", "AttendanceCourseRate", "TakeExaminee1", "TakeExamineeRate1", "TakeExaminee2", "TakeExamineeRate2", "TakeExaminee3", "TakeExamineeRate3", "TakeExaminee4", "TakeExamineeRate4", "TakeExaminee5", "TakeExamineeRate5" };
			
			}

			return ExportExcel(headers, colums, vm.StatisticsList, String.Format("프로그램이수현황_{0}", DateTime.Now.ToString("yyyyMMdd")));
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("CourseListAdmin")]
		public ActionResult CourseListAdmin(CourseViewModel vm)
		{
			Hashtable hashtable = new Hashtable();
			hashtable.Add("ROWSTATE", "L");
			vm.ProgramList = baseSvc.GetList<Homework>("homework.PROGRAM_SELECT_L", hashtable);

			if (ConfigurationManager.AppSettings["UnivYN"].Equals("N"))
			{
				Code code = new Code("A");
				code.ClassCode = "CSTD";
				vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
			}

			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();
			//vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L"));

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			if (vm.Course == null)
			{
				vm.Course = new Course();
				vm.Course.ProgramNo = 1;
				if (ConfigurationManager.AppSettings["UnivYN"].Equals("N"))
				{
					vm.Course.StudyType = vm.BaseCode[0].CodeValue;
				}
			}
			Course course = new Course("L");
			
			if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
			{
				course.ProgramNo = vm.Course.ProgramNo;
			}
			else
			{
				course.StudyType = vm.Course.StudyType;
			}
			course.TermNo = vm.Course.TermNo > 0 ? vm.Course.TermNo : vm.TermList.Count > 0 ? vm.TermList[0].TermNo : 0;

			course.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			course.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_L", course);

			vm.PageTotalCount = vm.CourseList.Count > 0 ? vm.CourseList[0].TotalCount : 0;
			if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Course.TermNo", course.TermNo }, { "Course.ProgramNo", course.ProgramNo }
																 , { "Course.SubjectName", vm.Course.SubjectName } };
			}
			else
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Course.TermNo", course.TermNo }, { "Course.StudyType", course.StudyType }
																 , { "Course.SubjectName", vm.Course.SubjectName } };
			}

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("CourseListAdminExcel")]
		public ActionResult CourseListAdminExcel(int param1, int param2)
		{
			Hashtable hash = new Hashtable();
			hash.Add("ProgramNo", WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? param1 : 2);
			hash.Add("TermNo", param2);
			
			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("course.COURSE_SELECT_EXCEL_G", hash);

			string[] headers;
			string[] columns;
			string excelFileName = "";

			if (WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				headers = new string[] { "과정", "강의형태", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "개설처/분반", "수강신청기간", "이수구분", "학점", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "수강인원", "개설상태" };
				columns = new string[] { "ProgramName", "StudyTypeName", "SubjectName", "AssignName", "LectureRequestStartDay", "FinishGubunName", "Credit", "ProfessorName", "StudentCount", "CourseOpenStatusName" };
				excelFileName = String.Format("강의운영관리_수강신청관리_{1}_{0}", DateTime.Now.ToString("yyyyMMdd"), param1 == 1 ? "정규과정" : "MOOC");
			}
			else
			{
				headers = new string[] { "강의형태", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "수강신청기간", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "수강인원", "개설상태" };
				columns = new string[] { "StudyTypeName", "SubjectName", "LectureRequestStartDay", "ProfessorName", "StudentCount", "CourseOpenStatusName" };
				excelFileName = String.Format("강의운영관리_수강신청관리_{0}", DateTime.Now.ToString("yyyyMMdd"));

			}

			return ExportExcel(headers, columns, hashList, excelFileName);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("CourseDetailAdmin/{param1}")]
		[Route("CourseDetailAdmin/{param1}/{param2}")]
		public ActionResult CourseDetailAdmin(CourseViewModel vm, int param1, string param2)
		{
			// 공통코드 조회
			Code code = new Code("A", new string[] { "CSTD", "COST" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);

			CourseLecture courselecture = new CourseLecture("E");
			courselecture.CourseNo = param1;
			courselecture.FirstIndex = 1;
			courselecture.LastIndex = 1000;

			vm.CourseLectureList = baseSvc.GetList<CourseLecture>("course.COURSE_LECTURE_SELECT_E", courselecture);

			if (!string.IsNullOrEmpty(param2))
			{
				if (param2.Equals("UserID"))
				{
					vm.CourseLectureList = vm.CourseLectureList.OrderBy(x => x.UserID).ToList();
					vm.SortType = "HangulName";
				}
				else
				{
					vm.CourseLectureList = vm.CourseLectureList.OrderBy(x => x.HangulName).ToList();
					vm.SortType = "UserID";
				}
			}

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("CourseLetureExcelUpload")]
		public ActionResult CourseDetailExcelUploadAdmin(CourseViewModel vm, int param1, string fileNewName)
		{
			// 공통코드 조회
			Code code = new Code("A", new string[] { "CSTD", "COST" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);

			CourseLecture courselecture = new CourseLecture("E");
			courselecture.CourseNo = param1;
			courselecture.FirstIndex = 1;
			courselecture.LastIndex = 1000;

			vm.CourseLectureList = baseSvc.GetList<CourseLecture>("course.COURSE_LECTURE_SELECT_E", courselecture);

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ExcelUploadChk")]
		[HttpPost]
		public JsonResult ExcelUploadChk(CourseViewModel vm)
		{

			if (Request.Files.Count > 0 && !string.IsNullOrEmpty(Request.Files[0].FileName))
			{
				vm.CourseLectureList = new List<CourseLecture>();

				#region 파일 및 dbCoon
				HttpPostedFileBase f = Request.Files[0];

				string fileName = "";
				string fileNewName = "";
				string fileSize = "";
				string fileType = "";

				if (!Directory.Exists(Server.MapPath("/Files/Temp")))
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

				OleDbConnection oledbConn = new OleDbConnection(connString);
				#endregion

				try
				{
					oledbConn.Open();
					OleDbCommand cmd = new OleDbCommand("SELECT * FROM [수강신청정보$]", oledbConn);
					OleDbDataAdapter oleda = new OleDbDataAdapter();
					oleda.SelectCommand = cmd;
					DataSet ds = new DataSet();
					oleda.Fill(ds, "User");
					var tempUser = from c in ds.Tables[0].AsEnumerable()
								   select c;
					DataTable dtUser = tempUser.CopyToDataTable();

					Hashtable paramHash = new Hashtable();
					paramHash.Add("CourseNo", vm.CourseNo);
					List<CourseLecture> ParticipateLectureList = baseSvc.GetList<CourseLecture>("team.COURSE_LECTURE_SELECT_D", paramHash).ToList();

					foreach (DataRow item in dtUser.Rows)
					{
						CourseLecture user = new CourseLecture();

						try
						{
							user.HangulName = item.Field<object>("이름") == null ? "" : item.Field<object>("이름").ToString();
							user.UserID = item.Field<object>("ID") == null ? "" : item.Field<object>("ID").ToString();
							user.LectureRequestDay = DateTime.Now.ToString("yyyy-MM-dd");
							user.LectureStatus = item.Field<object>("수강상태") == null ? "" : item.Field<object>("수강상태").ToString();

							User getUser = new User();
							getUser.UserID = item.Field<object>("ID") == null ? "" : item.Field<object>("ID").ToString();
							getUser = baseSvc.Get<User>("account.USER_SELECT_S", getUser);
							if(getUser == null)
							{
								user.ApprovalGubun = "등록된 회원이 아닙니다.";
							}
							else
							{
								user.UserNo = getUser.UserNo;
								user.ApprovalGubun = getUser.ApprovalGubun;

								//유효성 체크
								if (!user.ApprovalGubun.Equals("UAST001"))
								{
									user.ApprovalGubun = "등록 불가능한 회원입니다.";
								}
								else
								{
									if (string.IsNullOrEmpty(user.HangulName)) { user.ApprovalGubun = "이름없음 "; } else { user.ApprovalGubun = "등록가능"; }
									if (string.IsNullOrEmpty(user.UserID)) { user.ApprovalGubun = "아이디없음 "; } else { user.ApprovalGubun = "등록가능"; }
									if (string.IsNullOrEmpty(user.LectureRequestDay)) { user.ApprovalGubun = "신청일없음 "; } else { user.ApprovalGubun = "등록가능"; }
									if (string.IsNullOrEmpty(user.LectureStatus)) { user.ApprovalGubun = "수강상태없음 "; } else { user.ApprovalGubun = "등록가능"; }

									if (!getUser.HangulName.Equals(user.HangulName))
									{
										user.ApprovalGubun += "해당 ID의 회원 이름이 틀립니다.";
									}
									//int numUnicode = BitConverter.ToInt16(Encoding.Unicode.GetBytes(user.UserID[0].ToString()), 0);
									//if (!((97 <= numUnicode && numUnicode <= 122) || (65 <= numUnicode && numUnicode <= 90))) { user.ApprovalGubun = "아이디오류 "; } else { user.ApprovalGubun = "등록가능"; }
									//if (!IDChk(user.UserID).Equals(0)) { user.ApprovalGubun = "아이디중복 "; } else { user.ApprovalGubun = "등록가능"; }

									if (ParticipateLectureList.Where(t => t.UserID.Equals(user.UserID)).Count().Equals(0))
									{
										user.ApprovalGubun = "등록가능";

									}
									else
									{
										user.ApprovalGubun = "이미 등록된 회원입니다.";
									}

								}
							}

							vm.CourseLectureList.Add(user);

						}
						catch (Exception ex)
						{
							string errorMessage = ex.Message;

							user.HangulName = "엑셀파일 양식이 맞지 않습니다.";
							user.UserID = "";
							user.LectureRequestDay = "";
							user.LectureStatus = "";
							vm.CourseLectureList.Add(user);
							break;
						}
					}
				}
				finally
				{
					oledbConn.Close();
				}
			}

			return Json(vm.CourseLectureList);
		}

		public JsonResult CourseStudentCheck(CourseViewModel vm, string id, string userid, string username)
		{
			CourseLecture CL = new CourseLecture();

			CL.HangulName = username;
			CL.UserID = userid;
			CL.LectureRequestDay = DateTime.Now.ToShortDateString();
			CL.LectureStatus = "CLST001";
			CL.LectureStatusName = "승인";

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", id);
			List<CourseLecture> CourseLectureList = baseSvc.GetList<CourseLecture>("team.COURSE_LECTURE_SELECT_D", paramHash).ToList();

			User user = new User();
			user.UserID = userid;
			User searchUser = baseSvc.Get<User>("account.USER_SELECT_S", user);

			if (searchUser != null)
			{
				CL.UserNo = searchUser.UserNo;

				if (searchUser.UseYesNo.Equals("N"))
				{
					CL.ApprovalGubun += "등록 불가능한 회원입니다.";
				}
				else if (searchUser.DeleteYesNo.Equals("Y"))
				{
					CL.ApprovalGubun += "삭제된 회원입니다.";
				}
				else if (!searchUser.HangulName.Equals(username))
				{
					CL.ApprovalGubun += "해당 ID의 회원 이름이 틀립니다.";
				}
				else if (!searchUser.ApprovalGubun.Equals("UAST001"))
				{
					CL.ApprovalGubun += "등록 불가능한 회원입니다.";
				}
				else
				{
					if (CourseLectureList.Where(t => t.UserID.Equals(userid)).Count().Equals(0))
					{
						CL.ApprovalGubun += "등록가능";

					}
					else
					{
						CL.ApprovalGubun += "이미 등록된 회원입니다.";
					}
				}
			}
			else
			{
				CL.ApprovalGubun += "해당 사용자 없음.";
			}

			return this.Json(CL);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("CourseLetureUpload")]
		[HttpPost]
		public JsonResult CourseLetureUpload(CourseViewModel vm)
		{
			CourseLecture cl = new CourseLecture();
			vm.CourseLectureList = new List<CourseLecture>();

			int cnt = 0;

			for (var i = 0; i < vm.HangulNameArray.Length; i++)
			{
				cl = new CourseLecture();
				vm.HangulNameArray[i] = (vm.HangulNameArray[i] == "" || vm.HangulNameArray[i] == null) ? "" : vm.HangulNameArray[i];
				vm.UserIDArray[i] = (vm.UserIDArray[i] == "" || vm.UserIDArray[i] == null) ? "" : vm.UserIDArray[i];
				vm.LectureRequestDayArray[i] = (vm.LectureRequestDayArray[i] == "" || vm.LectureRequestDayArray[i] == null) ? "" : vm.LectureRequestDayArray[i];
				vm.LectureStatusNameArray[i] = (vm.LectureStatusNameArray[i] == "" || vm.LectureStatusNameArray[i] == null) ? "" : vm.LectureStatusNameArray[i];
				vm.UserNoArray[i] = (vm.UserNoArray[i] == "" || vm.UserNoArray[i] == null) ? "" : vm.UserNoArray[i];

				cl.CourseNo = vm.CourseNo;
				cl.HangulName = vm.HangulNameArray[i];
				cl.UserID = vm.UserIDArray[i];
				cl.LectureRequestDay = vm.LectureRequestDayArray[i];
				cl.LectureStatus = vm.LectureStatusNameArray[i];
				cl.UserNo = Convert.ToInt64(vm.UserNoArray[i]);
				cl.CreateUserNo = sessionManager.UserNo;

				

				if (vm.UploadGubunArray[i].ToString().Equals("등록가능"))
				{
					vm.CourseLectureList.Add(cl);
				}
				
			}

			cnt = courseSvc.LectureUserInsert(vm.CourseLectureList);

			return Json(cnt);
		}

		public int IDChk(String id)
		{
			Hashtable paramIDChk = new Hashtable();
			paramIDChk.Add("UserID", id);
			int result = baseSvc.Get<int>("account.USER_SELECT_A", paramIDChk);

			return result;
		}



		[AuthorFilter(IsAdmin = true)]
		[Route("CourseDetailAdminExcel")]
		public ActionResult CourseDetailAdminExcel(int param1, string param2)
		{
			CourseViewModel vm = new CourseViewModel();

			Code code = new Code("A", new string[] { "CSTD", "COST" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", paramHash);

			CourseLecture courselecture = new CourseLecture("E");
			courselecture.CourseNo = param1;
			courselecture.FirstIndex = 1;
			courselecture.LastIndex = 1000;

			vm.CourseLectureList = baseSvc.GetList<CourseLecture>("course.COURSE_LECTURE_SELECT_E", courselecture);

			if (!string.IsNullOrEmpty(param2))
			{
				if (param2.Equals("UserID"))
				{
					vm.CourseLectureList = vm.CourseLectureList.OrderBy(x => x.UserID).ToList();
					vm.SortType = "HangulName";
				}
				else
				{
					vm.CourseLectureList = vm.CourseLectureList.OrderBy(x => x.HangulName).ToList();
					vm.SortType = "UserID";
				}
			}

			if (vm.UnivYN().Equals("Y"))
			{
				string[] headers = new string[] {  "이름(" + WebConfigurationManager.AppSettings["StudIDText"].ToString() + ")", "학적", "신청일", "승인상태" };
				string[] columns = new string[] {  "MName", "HakjeokGubunName", "LectureRequestStartDay", "LectureStatusName" };
				string excelFileName = String.Format("수강신청{0}목록_{1}", WebConfigurationManager.AppSettings["StudentText"].ToString(), DateTime.Now.ToString("yyyyMMdd"));
				
				return ExportExcel(headers, columns, vm.CourseLectureList, excelFileName);
			}
			else
			{
				string[] headers = new string[] { "이름" , WebConfigurationManager.AppSettings["StudIDText"].ToString(),  "신청일", "승인상태" };
				string[] columns = new string[] { "HangulName", "UserID", "LectureRequestStartDay", "LectureStatusName" };
				string excelFileName = String.Format("{0}_{1}_{2}", vm.Course.SubjectName, WebConfigurationManager.AppSettings["StudentText"].ToString(), DateTime.Now.ToString("yyyyMMdd"));

				return ExportExcel(headers, columns, vm.CourseLectureList, excelFileName);
			}

		}

		[HttpPost]
		public JsonResult LectureLink(int CourseNo, int ClassNo)
		{
			Hashtable hashtable = new Hashtable();
			hashtable.Add("CourseNo", CourseNo);
			hashtable.Add("CreateUserNo", sessionManager.UserNo);
			hashtable.Add("ClassNo", ClassNo);

			return Json(baseSvc.Save("course.COURSE_LECTURE_SAVE_L", hashtable));
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("LectureListAdmin")]
		public ActionResult LectureListAdmin(CourseViewModel vm)
		{
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			if (vm.CourseLecture == null)
			{
				vm.CourseLecture = new CourseLecture();
			}

			CourseLecture courselecture = new CourseLecture("E");
			courselecture.TermNo = vm.CourseLecture.TermNo > 0 ? vm.CourseLecture.TermNo : 0;
			courselecture.SearchGbn = "personal";
			courselecture.SearchText = vm.CourseLecture.SearchText;
			courselecture.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			courselecture.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.CourseLectureList = baseSvc.GetList<CourseLecture>("course.COURSE_LECTURE_SELECT_E", courselecture);

			vm.PageTotalCount = vm.CourseLectureList.Count > 0 ? vm.CourseLectureList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "CourseLecture.TermNo", courselecture.TermNo }, { "CourseLecture.SearchText", vm.CourseLecture.SearchText } };

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("AttendanceListAdmin")]
		public ActionResult AttendanceListAdmin(CourseViewModel vm)
		{
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();
			vm.AssignList = baseSvc.GetList<Assign>("common.COMMON_DEPT_SELECT_L", new Assign("L"));

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			if (vm.CourseLecture == null)
			{
				vm.CourseLecture = new CourseLecture();
				vm.CourseLecture.AssignNo = "100000"; //화면 최초접근시 리스트에는 아무것도 조회되지 않도록
				vm.CourseLecture.SearchGbn = "AssignNo"; //화면 최초접근시 검색 옵션을 소속으로
			}


			CourseLecture courselecture = new CourseLecture("E");
			courselecture.TermNo = vm.CourseLecture.TermNo > 0 ? vm.CourseLecture.TermNo : 0;
			courselecture.SearchGbn = "personal";
			courselecture.SearchText = vm.CourseLecture.SearchText;
			courselecture.AssignNo = vm.CourseLecture.AssignNo;
			courselecture.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			courselecture.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.CourseLectureList = baseSvc.GetList<CourseLecture>("course.COURSE_LECTURE_SELECT_E", courselecture);
			

			vm.PageTotalCount = vm.CourseLectureList.Count > 0 ? vm.CourseLectureList[0].TotalCount : 0;

			if(ConfigurationManager.AppSettings["UnivYN"].ToString() == "N")
			{
				vm.CourseLecture.SearchGbn = "UserID";
			}

			if (vm.CourseLecture.SearchGbn.Equals("UserID"))
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "CourseLecture.TermNo", courselecture.TermNo }, { "CourseLecture.SearchText", vm.CourseLecture.SearchText }, { "CourseLecture.SearchGbn", vm.CourseLecture.SearchGbn } };
			}
			else
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "CourseLecture.TermNo", courselecture.TermNo }, { "CourseLecture.AssignNo", vm.CourseLecture.AssignNo }, { "CourseLecture.SearchGbn", vm.CourseLecture.SearchGbn } };
			}

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("LectureListExcelAdmin")]
		public ActionResult LectureListExcelAdmin(CourseViewModel vm)
		{
			CourseLecture courselecture = new CourseLecture("G");
			courselecture.TermNo = vm.CourseLecture.TermNo > 0 ? vm.CourseLecture.TermNo : 0;
			courselecture.SearchGbn = "personal";
			courselecture.SearchText = vm.CourseLecture.SearchText;
			courselecture.AssignNo = vm.CourseLecture.AssignNo;

			vm.CourseLectureList = baseSvc.GetList<CourseLecture>("course.COURSE_LECTURE_SELECT_G", courselecture);

			string[] headers;
			string[] columns;

			if (vm.UnivYN().Equals("Y"))
			{
				headers = new string[] { WebConfigurationManager.AppSettings["StudIDText"].ToString(), "이름", "소속", "학적", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "년도/" + ConfigurationManager.AppSettings["TermText"].ToString(), "캠퍼스/분반", "이수구분", "신청일", "신청상태" };
				columns = new string[] { "UserID", "HangulName", "AssignName", "HakjeokGubunName", "SubjectName", "StartDay", "MName", "FinishGubunName", "LectureRequestStartDay", "LectureStatusName" };
			}
			else
			{
				headers = new string[] { "년도/" + ConfigurationManager.AppSettings["TermText"].ToString(), WebConfigurationManager.AppSettings["SubjectText"].ToString(), WebConfigurationManager.AppSettings["StudIDText"].ToString(), "이름",  "신청일", "신청상태" };
				columns = new string[] { "StartDay", "SubjectName", "UserID", "HangulName", "LectureRequestStartDay", "LectureStatusName" };
			}

			string excelFileName = String.Format("{2}수강현황_{1}_{0}", DateTime.Now.ToString("yyyyMMdd"), courselecture.AssignNo ?? courselecture.SearchText, WebConfigurationManager.AppSettings["StudentText"].ToString());

			return ExportExcel(headers, columns, vm.CourseLectureList, excelFileName);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("AttendanceListExcelAdmin")]
		public ActionResult AttendanceListExcelAdmin(CourseViewModel vm)
		{
			CourseLecture courselecture = new CourseLecture("J");
			courselecture.TermNo = vm.CourseLecture.TermNo > 0 ? vm.CourseLecture.TermNo : 0;
			courselecture.SearchText = vm.CourseLecture.SearchText;
			courselecture.AssignNo = vm.CourseLecture.AssignNo;

			IList<Hashtable> hashtable = baseSvc.GetList<Hashtable>("course.COURSE_LECTURE_SELECT_J", courselecture);

			string[] headers;
			string[] columns;

			if (vm.UnivYN().Equals("Y"))
			{
				headers = new string[] { WebConfigurationManager.AppSettings["StudIDText"].ToString(), "이름", "소속", "학적", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "주차", "차시", "학습기간", "출결상태명" };
				columns = new string[] { "UserID", "HangulName", "AssignName", "HakjeokGubunName", "SubjectName", "Week", "InningSeqNo", "InningPeriod", "AttendanceName" };
			}
			else
			{
				headers = new string[] { WebConfigurationManager.AppSettings["SubjectText"].ToString(), WebConfigurationManager.AppSettings["StudIDText"].ToString(), "이름", "주차", "차시", "학습기간", "출결상태명" };
				columns = new string[] { "SubjectName", "UserID", "HangulName", "Week", "InningSeqNo", "InningPeriod", "AttendanceName" };
			}

			string excelFileName = String.Format("{2}출석현황_{1}_{0}", DateTime.Now.ToString("yyyyMMdd"), courselecture.AssignNo ?? courselecture.SearchText, WebConfigurationManager.AppSettings["StudentText"].ToString());

			return ExportExcel(headers, columns, hashtable, excelFileName);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ProgressListAdmin")]
		public ActionResult ProgressListAdmin(CourseViewModel vm)
		{
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;
			
			// 과정 바인딩
			Hashtable paramForProgram = new Hashtable();
			paramForProgram.Add("ROWSTATE", "L");

			vm.ProgramList = baseSvc.GetList<Homework>("homework.PROGRAM_SELECT_L", paramForProgram);

			// 학기 바인딩
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term());
			vm.TermList = vm.TermList.Where(c => DateTime.ParseExact(c.TermStartDay, "yyyy-MM-dd", null) <= DateTime.Now).OrderByDescending(c => c.TermNo).ToList();

			vm.TermNo = vm.TermNo > 0 ? vm.TermNo : baseSvc.Get<int>("term.TERM_SELECT_C", new Term());

			// 학습상황관리 리스트
			Hashtable paramForList = new Hashtable();
			
			paramForList.Add("ProgramNo", vm.UnivYN().Equals("Y") ? vm.ProgramNo : 2);
			paramForList.Add("TermNo", vm.TermNo);
			paramForList.Add("SearchText", vm.SearchText);
			paramForList.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramForList.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_PROGRESS_LIST_SELECT_L", paramForList);

			vm.PageTotalCount = vm.CourseList.FirstOrDefault() != null ? vm.CourseList.FirstOrDefault().TotalCount : 0;

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
		[Route("ProgressListExcel")]
		public ActionResult ProgressListExcel(CourseViewModel vm)
		{
			Hashtable paramForExcel = new Hashtable();
			paramForExcel.Add("ProgramNo", vm.UnivYN().Equals("Y") ? vm.ProgramNo : 2);
			paramForExcel.Add("TermNo", vm.TermNo);
			paramForExcel.Add("SearchText", vm.SearchText);

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_PROGRESS_LIST_SELECT_L", paramForExcel);

			string[] headers;
			string[] colums;

			if (vm.UnivYN().Equals("Y"))
			{
				headers = new string[] { "순번", "과정구분", "수강기간", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "분반", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "수강인원", "학습진도율" };
				colums = new string[] { "RowNum", "ProgramName", "ExcelToLectureDay", "SubjectName", "ClassNo", "ProfessorName", "StudentCount", "InningRate" };
			}
			else
			{
				headers = new string[] { "순번", "수강기간", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "분반", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "수강인원", "학습진도율" };
				colums = new string[] { "RowNum", "ExcelToLectureDay", "SubjectName", "ClassNo", "ProfessorName", "StudentCount", "InningRate" };
			}
			return ExportExcel(headers, colums, vm.CourseList, String.Format("학습상황관리_{0}", DateTime.Now.ToString("yyyyMMdd")));
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ProgressDetailAdmin")]
		public ActionResult ProgressDetailAdmin(CourseViewModel vm, int CourseNo, int TermNo, int ProgramNo, string SearchText, int PageRowSize, int PageNum, string PageMode)
		{
			// 교과목 정보 리스트
			Hashtable paramForCourseList = new Hashtable();
			paramForCourseList.Add("CourseNo", CourseNo);
			paramForCourseList.Add("TermNo", TermNo);

			vm.Course = baseSvc.Get<Course>("course.COURSE_PROGRESS_DETAIL_SELECT_L", paramForCourseList);
			vm.PageGubun = "ProgressDetailAdmin";


			vm.SearchSort = vm.SearchSort ?? "USERNAME";
			vm.SearchOption = vm.SearchOption ?? "ALL";
			vm.SearchGbn = vm.SearchGbn ?? "N";
			vm.SearchStud = vm.SearchStud ?? ""; // 학습진도현황 - 학생명 검색

			vm.CourseNo = CourseNo;
			vm.TermNo = TermNo;
			vm.ProgramNo = ProgramNo;
			vm.SearchText = ""; // 학습상황관리 - 강좌명 검색
			vm.PageRowSize = PageRowSize;
			vm.PageNum = PageNum;
			vm.hdnPageMode = PageMode ?? "Progress";

			// 학생 정보 리스트
			Hashtable paramForStudList = new Hashtable();
			paramForStudList.Add("CourseNo", CourseNo);
			paramForStudList.Add("TermNo", TermNo);
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
			else // 컨텐츠현황
			{
				vm.ProgressDetailList = baseSvc.GetList<Hashtable>("course.COURSE_PROGRESS_DETAIL_SELECT_C", paramForStudList);
			}
		
			return View(vm);
		}

		[AuthorFilter(IsLogIn = true)]
		public JsonResult InsertAttendance(CourseViewModel vm)
		{
			bool fileSuccess = true;
			long? fileGroupNo = 0;

			#region 파일관련
			int fileCnt = 0;

			for (var i = 0; i < Request.Files.Count; i++)
			{
				if (Request.Files[i].ContentLength != 0)
				{
					fileCnt++;
				}
			}

			if (fileCnt > 0)
			{
				fileGroupNo = FileUpload("C", "Attendance", vm.FileGroupNo, "AttendanceFile");
				if (fileGroupNo <= 0)
				{
					fileSuccess = false;
				}
			}

			#endregion

			StudyInning studyInning = new StudyInning();
			
			if (fileSuccess)
			{
				studyInning.StudyInningNo = vm.StudyInningAttendanceList.StudyInningNo;
				studyInning.UserID = vm.StudyInningAttendanceList.UserID;
				studyInning.AttendanceStatus = vm.StudyInningAttendanceList.StudyStatus;
				studyInning.AttendanceReason = vm.StudyInningAttendanceList.AttendanceReason;
				studyInning.CreateUserNo = sessionManager.UserNo;
				studyInning.UpdateUserNo = sessionManager.UserNo;
				studyInning.DeleteYesNo = "N";
				studyInning.FileGroupNo = fileGroupNo;
			}
			
			return Json(courseSvc.StudyInningInsert(studyInning));
		}

		[AuthorFilter(IsLogIn = true)]
		public JsonResult InsertFileAttendance(CourseViewModel vm)
		{
			bool fileSuccess = true;
			long? fileGroupNo = 0;

			#region 파일관련
			int fileCnt = 0;

			for (var i = 0; i < Request.Files.Count; i++)
			{
				if (Request.Files[i].ContentLength != 0)
				{
					fileCnt++;
				}
			}

			if (fileCnt > 0)
			{
				fileGroupNo = FileUpload("C", "Attendance", vm.FileGroupNo, "AttendanceFile");
				if (fileGroupNo <= 0)
				{
					fileSuccess = false;
				}
			}

			#endregion 파일관련

			StudyInning attReasonStudyInning = new StudyInning();

			if (fileSuccess)
			{
				attReasonStudyInning.StudyInningNo = vm.StudyInningAttendanceList.StudyInningNo;
				attReasonStudyInning.UserID = vm.StudyInningAttendanceList.UserID;
				attReasonStudyInning.AttendanceStatus = vm.StudyInningAttendanceList.StudyStatus;
				attReasonStudyInning.AttendanceReason = vm.StudyInningAttendanceList.AttendanceReason;
				attReasonStudyInning.CreateUserNo = sessionManager.UserNo;
				attReasonStudyInning.UpdateUserNo = sessionManager.UserNo;
				attReasonStudyInning.DeleteYesNo = "N";
				attReasonStudyInning.FileGroupNo = fileGroupNo;
			}
			return Json(courseSvc.StudyInningInsert(attReasonStudyInning));
		}

		[AuthorFilter(IsLogIn = true)]
		public JsonResult GetAttendanceReason(int param1, int param2)
		{
			StudyInning studyInning = new StudyInning();
			studyInning.InningNo = param1;
			studyInning.UserNo = param2;

			return Json(baseSvc.GetList<StudyInning>("course.USP_STUDY_INNING_SELECT_EXCEL_M", studyInning));
		}

		[AuthorFilter(IsLogIn = true)]
		[Route("ProgressUser/{param1}/{param2}")]
		public ActionResult ProgressUser(int param1, int param2)
		{
			CourseViewModel vm = new CourseViewModel();

			ViewBag.PageTitle = "학습상세";

			Course course = new Course("L");
			course.CourseNo = param1;

			CourseLecture courselecture = new CourseLecture();
			courselecture.CourseNo = param1;
			courselecture.UserNo = param2;

			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", course);
			vm.LectureUserDetail = baseSvc.Get<CourseLecture>("course.COURSE_LECTURE_SELECT_H", courselecture);

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

			return View(vm);
		}

		[AuthorFilter(IsLogIn = true)]
		[Route("StudyPagePopup/{param1}/{param2}")]
		public ActionResult StudyPagePopup(int param1, int param2)
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

			return View(vm);
		}

		[AuthorFilter(IsLogIn = true)]
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

		[AuthorFilter(IsLogIn = true)]
		[Route("LogUser/{param1}/{param2}")]
		public ActionResult LogUser(int param1, int param2)
		{
			CourseViewModel vm = new CourseViewModel();

			ViewBag.PageTitle = "학습상황";

			Course course = new Course("L");
			course.CourseNo = param1;

			CourseLecture courselecture = new CourseLecture();
			courselecture.CourseNo = param1;
			courselecture.UserNo = param2;

			Hashtable hashtable = new Hashtable();
			hashtable.Add("UserNo", param2);

			vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", course);
			vm.LectureUserDetail = baseSvc.Get<CourseLecture>("course.COURSE_LECTURE_SELECT_H", courselecture);
			vm.UserLogList = baseSvc.GetList<User>("account.USER_SELECT_I", hashtable);

			return View(vm);
		}

		[AuthorFilter(IsLogIn = true)]
		[Route("OcwUser/{param1}/{param2}")]
		public ActionResult OcwUser(int param1, int param2)
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

		[AuthorFilter(IsAdmin = true)]
		[Route("Certification")]
		public ActionResult Certification(CourseViewModel vm)
		{
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			Course course = new Course();
			course.TermNo = vm.Course != null ? vm.Course.TermNo : 1;
			course.IsPass = -1;

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			if (vm.Course != null)
			{
				course.SubjectName = vm.Course.SubjectName;
				course.ProfessorName = vm.Course.ProfessorName;
				//course.UserID = vm.Course.UserID;
				course.IsPass = vm.Course.IsPass;
			}

			course.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			course.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.CourseList = baseSvc.GetList<Course>("course.COMPLETION_SELECT_L", course);

			vm.PageTotalCount = vm.CourseList.Count > 0 ? vm.CourseList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Course.TermNo", course.TermNo }
																 , { "Course.SubjectName", vm.Course != null ? vm.Course.SubjectName : "" }
																 , { "Course.IsPass", vm.Course != null ? vm.Course.IsPass : -1 } };

			return View(vm);
		}

		public ActionResult CertificationPopup(int param1, int param2)
		{
			CourseViewModel vm = new CourseViewModel();

			CourseLecture courselecture = new CourseLecture();
			courselecture.CourseNo = param1;
			courselecture.UserNo = param2;
			courselecture.PrintUserNo = (int)sessionManager.UserNo;

			vm.LectureUserDetail = baseSvc.Get<CourseLecture>("course.COMPLETION_SELECT_S", courselecture); //TODO : XML내 리턴객체 student로 변경

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("GradeList")]
		public ActionResult GradeList(CourseViewModel vm)
		{
			Hashtable hashtable = new Hashtable();
			hashtable.Add("ROWSTATE", "L");

			vm.ProgramList = baseSvc.GetList<Homework>("homework.PROGRAM_SELECT_L", hashtable);

			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			if (vm.Course == null)
			{
				vm.Course = new Homework();
				vm.Course.ProgramNo = vm.UnivYN().Equals("Y") ? 1 : 2;
			}

			Course course = new Course("L");
			course.TermNo = vm.Course.TermNo > 0 ? vm.Course.TermNo : vm.TermList.Count > 0 ? vm.TermList[0].TermNo : 0;
			course.ProgramNo = vm.UnivYN().Equals("Y") ? vm.Course.ProgramNo : 2;
			course.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			course.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_L", course);

			vm.PageTotalCount = vm.CourseList.Count > 0 ? vm.CourseList[0].TotalCount : 0;

			if (ConfigurationManager.AppSettings["UnivYN"].ToString() == "Y")
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Course.TermNo", course.TermNo }, { "Course.ProgramNo", course.ProgramNo }
																 , { "Course.SubjectName", vm.Course.SubjectName } };
			}
			else
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Course.TermNo", course.TermNo }, { "Course.SubjectName", vm.Course.SubjectName } };
			}

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult GradeListExcel(int param1, int param2)
		{
			Hashtable hash = new Hashtable();
			hash.Add("ProgramNo", param1);
			hash.Add("TermNo", param2);

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("course.COURSE_SELECT_EXCEL_G", hash);

			string[] headers = new string[] { "과정", "강의형태", "수강기간", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "캠퍼스 / 분반", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString() };
			string[] columns = new string[] { "ProgramName", "StudyTypeName", "TermDay", "SubjectName", "CampusName", "ProfessorName" };
			string excelFileName = String.Format("강의운영관리_성적관리_{1}_{0}", DateTime.Now.ToString("yyyyMMdd"), param1 == 1 ? "정규과정" : "MOOC");

			return ExportExcel(headers, columns, hashList, excelFileName);
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult GradeListEstimationExcel(int param1)
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
			GradeList = courseSvc.GradeList(vm.CourseList, vm.EstimationBasis, vm.EstimationItemBasis, vm.ParticipationEstimationItemBasis);
			vm.GradeList = GradeList.OrderBy(c => c.HangulName).ToList();

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
			if (vm.UnivYN().Equals("Y"))
			{
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>소속</th>";
			}
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>" + WebConfigurationManager.AppSettings["StudIDText"].ToString() + "</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>이름</th>";
			tempGrid += "{0}";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>출/지/결/미</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>중간</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>기말</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>출석</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>과제</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>퀴즈</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>팀프로젝트</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>기타</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>참여도</th>";
			tempGrid += "<th rowspan='2' style='background:#E9F5F5;mso-data-placement:same-cell;text-align:center;'>합계</th>";
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
				if (vm.UnivYN().Equals("Y"))
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
				else
				{
					tempGrid += string.Format("<td style='mso-data-placement:same-cell; text-align:center;' colspan='11'>-데이터가 없습니다.-</td>");
				}
				tempGrid += "</tr>";
			}

			tempGrid += "</table>";

			String PageName = HttpUtility.UrlEncode("성적관리.xls", Encoding.UTF8);

			Response.AppendHeader("Content-Disposition", "attachment; filename=" + PageName);
			Response.AppendHeader("Content-Type", "application/vnd.ms-excel");
			Response.Output.Write("\n<html>\n<body>");
			Response.Output.Write(tempGrid);
			Response.Output.Write("\n</body>\n</html>");
			Response.Flush();
			System.Web.HttpContext.Current.ApplicationInstance.CompleteRequest();

			return null;
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("License")]
		public ActionResult License(HomeworkViewModel vm)
		{
			Code code = new Code("A");
			code.ClassCode = "CFCD";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			Hashtable hashtable = new Hashtable();
			hashtable.Add("ROWSTATE", "L");

			vm.ProgramList = baseSvc.GetList<Homework>("homework.PROGRAM_SELECT_L", hashtable);

			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			IList<Code> ProgramGubun = vm.BaseCode.Where(x => x.ClassCode.Equals("CHGB")).ToList();

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			if (vm.License == null)
			{
				vm.License = new License();
				vm.License.ProgramNo = vm.UnivYN().Equals("Y") ? 1 : 2;
			}

			License license = new License("L");
			license.TermNo = vm.License.TermNo > 0 ? vm.License.TermNo : vm.TermList.Count > 0 ? vm.TermList[0].TermNo : 0;

			license.ProgramNo = vm.UnivYN().Equals("Y") ? vm.License.ProgramNo : 2;
			license.CertCode = !string.IsNullOrEmpty(vm.License.CertCode) ? vm.License.CertCode : null;
			license.SubjectName = !string.IsNullOrEmpty(vm.License.SubjectName) ? vm.License.SubjectName : null;
			license.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			license.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.LicenseList = baseSvc.GetList<License>("homework.CERTIFICATE_SELECT_L", license);

			vm.PageTotalCount = vm.LicenseList.Count > 0 ? vm.LicenseList[0].TotalCount : 0;

			if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "License.TermNo", license.TermNo }, { "License.ProgramNo", license.ProgramNo },
																	{ "License.TermGubun", vm.License.TermGubun }, { "License.SubjectName", vm.License.SubjectName }, { "License.SearchText", string.IsNullOrEmpty(vm.License.SearchText) ? "Y" : vm.License.SearchText } };
			}
			else
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "License.TermNo", license.TermNo }, 
																	{ "License.TermGubun", vm.License.TermGubun }, { "License.SubjectName", vm.License.SubjectName }, { "License.SearchText", string.IsNullOrEmpty(vm.License.SearchText) ? "Y" : vm.License.SearchText } };
			}


			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("License")]
		public ActionResult LicenseExcel(int param1, int param2, string param3, string param4)
		{
			License license = new License("A");

			
			license.ProgramNo = ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? param1 : 2;
			license.TermNo = param2;
			license.SubjectName = param3;
			license.CertCode = param4;

			 IList<License> LicenseList = baseSvc.GetList<License>("homework.CERTIFICATE_SELECT_A", license);

			Code code = new Code("A");
			code.ClassCode = "CFCD";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			IList<Code> BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
			string certName = "";
			if(BaseCode.Count > 0)
			{
				certName = BaseCode.Where(x => x.CodeValue == param4).FirstOrDefault().CodeName;
			}

			string[] headers = new string[] { ConfigurationManager.AppSettings["SubjectText"].ToString()+"명", ConfigurationManager.AppSettings["ProfIDText"].ToString(), ConfigurationManager.AppSettings["StudIDText"].ToString(), "자격증", "취득일자" };
			string[] columns = new string[] { "SubjectName", "ProfessorName", "HangulName", "CertName", "CertDate" };
			string excelFileName = String.Format("자격증취득현황_{0}_목록_{1}", certName ?? "" , DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, LicenseList, excelFileName);
		}

		[AuthorFilter(IsAdmin = true)]
		[HttpPost]
		public JsonResult SubjectList(StatisticsViewModel vm, int param1)
		{
			JsonResult returnJsonResult = new JsonResult();

			Course paramForSubject = new Course();
			paramForSubject.TermNo = param1;

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_M", paramForSubject);

			return Json(vm.CourseList);
		}

		public JsonResult ChangeLS(String lenos, String LS)
		{
			int cnt = 0;
			Hashtable hashtable = new Hashtable();
			hashtable.Add("LENos", lenos);
			hashtable.Add("LectureStatus", LS);

			cnt = baseSvc.Save("course.COURSE_STATE_SAVE_U", hashtable);

			return Json(cnt);
		}

		

	}

}
