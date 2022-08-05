using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Linq;
using System.Web.Mvc;

namespace ILMS.Web.Controllers
{
	[RoutePrefix("Home")]
	public class HomeController : WebBaseController
	{
		public BoardService boardSvc { get; set; }
		public CourseService courseSvc { get; set; }

		[Route("/")]
		[Route("Index")]
		public ActionResult Index()
		{
			HomePageViewModel vm = new HomePageViewModel();

			//비로그인 접속기록 저장
			if (ViewBag.IsLogin == null || !ViewBag.IsLogin)
			{
				Hashtable ht = new Hashtable();
				ht.Add("IPAddress", Request.ServerVariables["REMOTE_ADDR"].ToString());
				ht.Add("UserAgent", Request.UserAgent);

				baseSvc.Save("account.LOGIN_SAVE_A", ht);
			}

			//공지사항 조회
			Hashtable htBoard = new Hashtable();
			htBoard.Add("RowState", "L");
			htBoard.Add("MasterNo", 4);
			htBoard.Add("FirstIndex", FirstIndex(5, 1));
			htBoard.Add("LastIndex", LastIndex(6, 1));
			htBoard.Add("DeleteYesNo", "N");
			vm.BoardList = baseSvc.GetList<Board>("board.BOARD_SELECT_L", htBoard);

			//팝업 조회
			Hashtable htPopup = new Hashtable();
			htPopup.Add("RowState", "L");
			htPopup.Add("DisplayDay", DateTime.Now.ToString("yyyy-MM-dd"));
			htPopup.Add("DeleteYesNo", "N");
			htPopup.Add("OutputYesNo", "Y");
			htPopup.Add("FirstIndex", "1");
			htPopup.Add("LastIndex", "10000");
			vm.PopupList = baseSvc.GetList<Popup>("content.POPUP_SELECT_L", htPopup);


			//최근개설 강좌 조회(비교과:MOOC)
			string 현재날짜 = DateTime.Now.ToString("yyyy-MM-dd");

			Course paramCourse = new Course();
			paramCourse.ProgramNo = 2;
			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_L", paramCourse).
									Where(x => (x.RStart.CompareTo(현재날짜) <= 0 && x.REnd.CompareTo(현재날짜) >= 0) || x.RStart.CompareTo(현재날짜) >= 0).
									OrderBy(c => c.RStart).ThenBy(c => c.REnd).Take(5).ToList();

			string courseNos = string.Join(",", vm.CourseList.Select(s => s.CourseNo));

			//교육내용
			Hashtable ht2 = new Hashtable();
			ht2.Add("CourseNos", courseNos);
			vm.InningList = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_K", ht2);
			
			//퀵링크
			vm.QuickLinkList = baseSvc.GetList<QuickLink>("content.QUICKLINK_SELECT_L", "").Where(w => w.OutputYesNo == "Y").OrderBy(c => c.SortNo).ToList();

			return View(vm);
		}
	}
}