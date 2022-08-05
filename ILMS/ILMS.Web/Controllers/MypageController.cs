using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("MyPage")]
	public class MypageController : WebBaseController
	{
		public AccountService accountSvc { get; set; }

		#region ActionResult

		[Route("LectureRoom")]
		public ActionResult LectureRoom(CourseViewModel vm)
		{
			IList<Term> termList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L"));
			vm.TermList = termList.Where(c => DateTime.ParseExact(c.TermStartDay, "yyyy-MM-dd", null) <= DateTime.Now).OrderByDescending(c => c.SortNo).ToList();
			vm.TermNo = vm.TermNo > 0 ? vm.TermNo : baseSvc.Get<int>("term.TERM_SELECT_C", new Term("C"));

			if (vm.TermList.Count > 0)
			{
				Course paramCourse = new Course();
				paramCourse.TermNo = vm.TermNo;
				paramCourse.UserNo = ViewBag.User.UserNo;
				vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_F", paramCourse);
			}
			else
			{
				vm.CourseList = new List<Course>();
			}

			if (vm.Course == null)
			{
				vm.Course = new Course();
				vm.Course.ProgramNo = vm.UnivYN().Equals("Y") ? 1 : 2;
			}

			return View(vm);
		}

		public ActionResult QnaExcel(int tNo, int pNo)
		{
			Hashtable hash = new Hashtable();
			hash.Add("RowState", "A");
			hash.Add("TermNo", tNo);
			hash.Add("ProgramNo", pNo);
			hash.Add("UserNo", sessionManager.UserNo);

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("board.BOARD_SELECT_EXCEL_A", hash);

			string[] headers = new string[] { WebConfigurationManager.AppSettings["SubjectText"].ToString(), "분반", "글제목", "글내용", "글작성일자", "글작성자ID", "글작성자성명", "댓글내용", "댓글작성일자", "댓글작성자ID", "댓글작성자성명" };
			string[] columns = new string[] { "SubjectName", "ClassNo", "Title", "Contents", "ContentsCreateDateTime", "CreateUserID", "CreateUserName", "Reply", "ReplyCreateDateTime", "ReplyUserID", "ReplyUserName" };
			string excelFileName = "";

			if (WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
				excelFileName = String.Format("강의과목_Q&A게시판_{1}_{0}", DateTime.Now.ToString("yyyyMMdd"), pNo == 1 ? "정규과정" : "MOOC");
			else
				excelFileName = String.Format("Q&A게시판_{0}", DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, hashList, excelFileName); ;
		}

		[Route("MyInfo")]
		public ActionResult MyInfo(AccountViewModel vm)
		{
			Hashtable paramHash = new Hashtable();

			paramHash.Add("UserNo", ViewBag.User.UserNo);

			vm.User = baseSvc.Get<User>("account.USER_SELECT_S", paramHash);

			if (vm.User.ResidentNo != null) 
			{
				if(vm.User.ResidentNo.Length >= 8)
				{
					vm.User.ResidentNo = vm.User.ResidentNo.Substring(0, 4) + "-" + vm.User.ResidentNo.Substring(4, 2) + "-" + vm.User.ResidentNo.Substring(6, 2);
				}			
			} 

			return View(vm);
		}

		[Route("WriteInfo")]
		public ActionResult WriteInfo(AccountViewModel vm)
		{
			User user = new User();

			user.UserNo = sessionManager.UserNo;
			vm.User = baseSvc.Get<User>("account.USER_SELECT_S", user);

			vm.User.SexGubun = vm.User.SexGubun.Equals("M") ? "USEX001" : "USEX002";
			vm.User.Mobile = vm.User.Mobile.Replace("-", "");
			vm.User.ResidentNo = DateTime.ParseExact(vm.User.ResidentNo, "yyyyMMdd", null).ToString("yyyy-MM-dd");

			//UserAccessSave(3, vm.User.HangulName + "(" + vm.User.UserID + ")");

			return View(vm);
		}

		[Route("Withdrawal")]
		public ActionResult Withdrawal(AccountViewModel vm)
		{
			return View(vm);
		}

		[Route("MyCompletion")]
		public ActionResult MyCompletion(CourseViewModel vm)
		{
			Code code = new Code("A");
			code.ClassCode = "CSTD";
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			if (vm.CourseLecture == null)
			{
				vm.CourseLecture = new CourseLecture();
			}

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			CourseLecture courseLecture = new CourseLecture();
			courseLecture.UserNo = sessionManager.UserNo;
			courseLecture.StudyType = vm.CourseLecture.StudyType;
			courseLecture.TermNo = vm.CourseLecture.TermNo > 0 ? vm.CourseLecture.TermNo : vm.TermList.Count > 0 ? vm.TermList[0].TermNo : 0;
			courseLecture.SearchText = vm.SearchText;
			courseLecture.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			courseLecture.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.CourseLectureList = baseSvc.GetList<CourseLecture>("course.COURSE_LECTURE_SELECT_I", courseLecture);

			vm.PageTotalCount = vm.CourseLectureList.Count > 0 ? vm.CourseLectureList[0].TotalCount : 0;

			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "CourseLecture.TermNo", courseLecture.TermNo }, { "CourseLecture.StudyType", courseLecture.StudyType }
																 , { "SearchText", vm.SearchText } };

			return View(vm);
		}

		[Route("CompletionPopup/{param1}/{param2}")]
		public ActionResult CompletionPopup(int param1, int param2)
		{
			CourseViewModel vm = new CourseViewModel();

			CourseLecture courselecture = new CourseLecture();
			courselecture.CourseNo = param1;
			courselecture.UserNo = param2;
			courselecture.PrintUserNo = (int)sessionManager.UserNo;

			vm.LectureUserDetail = baseSvc.Get<CourseLecture>("course.COMPLETION_SELECT_S", courselecture); //TODO : XML내 리턴객체 student로 변경

			return View(vm);
		}
		#endregion


		#region JsonResult

		public JsonResult CancelLecture(int courseNo)
		{
			CourseLecture paramCourseLecture = new CourseLecture();
			paramCourseLecture.CourseNo = courseNo;
			paramCourseLecture.UserNo = sessionManager.UserNo;
			paramCourseLecture.LectureStatus = "CLST003";
			int result = baseSvc.Save<CourseLecture>("course.COURSE_LECTURE_SAVE_U", paramCourseLecture);

			return Json(result);
		}

		[HttpPost]
		[Route("WriteGeneral")]
		public JsonResult WriteGeneral(AccountViewModel vm)
		{
			int cnt = 0;

			vm.Student.UserType = "USRT001";
			vm.Student.StudentYesNo = "N";
			vm.Student.ManagerYesNo = "N";
			vm.Student.AssignNo = "011";

			vm.Student.ResidentNo = vm.Student.ResidentNo.Replace("-", "");
			vm.Student.CreateUserNo = sessionManager.UserNo;
			vm.Student.UpdateUserNo = sessionManager.UserNo;
			vm.Student.DeleteYesNo = vm.Student.DeleteYesNo ?? "N";
			vm.Student.UseYesNo = vm.Student.UseYesNo ?? "Y";
			vm.Student.GeneralUserCode = "GUCD004";

			if (!string.IsNullOrEmpty(vm.Student.Mobile))
			{
				vm.Student.Mobile = vm.Student.Mobile.Replace("-", "");
				if (vm.Student.Mobile.Length == 10)
				{
					vm.Student.Mobile = vm.Student.Mobile.Substring(0, 3) + "-" + vm.Student.Mobile.Substring(3, 3) + "-" + vm.Student.Mobile.Substring(6);
				}
				else if (vm.Student.Mobile.Length > 10)
				{
					vm.Student.Mobile = vm.Student.Mobile.Substring(0, 3) + "-" + vm.Student.Mobile.Substring(3, 4) + "-" + vm.Student.Mobile.Substring(7);
				}
			}

			cnt = accountSvc.UpdateUser(vm.Student);

			return Json(cnt);
		}

		public JsonResult PasswordCheck(string password)
		{
			int cnt;
			password = ConvertToSecurityPassword(password);

			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();

			ht.Add("UserNo", userNo);
			ht.Add("Password", password);

			cnt = baseSvc.Get<int>("account.USER_SELECT_G", ht);

			return Json(cnt);
		}

		public JsonResult UserWithdrawal(string password)
		{
			int cnt;
			password = ConvertToSecurityPassword(password);

			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();

			ht.Add("UserNo", userNo);
			ht.Add("Password", password);

			cnt = baseSvc.Save("account.USER_SAVE_D", ht);

			return Json(cnt);
		}

		public JsonResult ChangePassword(string newPassword)
		{
			int cnt;
			newPassword = ConvertToSecurityPassword(newPassword);

			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();

			ht.Add("UserNo", userNo);
			ht.Add("Password", newPassword);

			cnt = baseSvc.Save("account.USER_SAVE_F", ht);

			return Json(cnt);
		}

		#endregion

	}
}