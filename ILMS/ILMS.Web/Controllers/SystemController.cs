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
	[AuthorFilter(IsAdmin = true)]
	[RoutePrefix("System")]
	public class SystemController : WebBaseController
	{
		public SystemService systemSvc { get; set; }

		// 메뉴관리 ▼
		[Route("MenuList")]
		public ActionResult MenuList(SystemViewModel vm)
		{
			Code paramCode = new Code("A", new string[] { "LNKT", "MNUT" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", paramCode);

			return View(vm);
		}

		[HttpPost]
		public JsonResult MenuList(string upperMenuCode)
		{
			Menu paramMenu = new Menu();
			paramMenu.UpperMenuCode = upperMenuCode;
			IList<Menu> menuList = baseSvc.GetList<Menu>("system.MENU_SELECT_L", paramMenu);
			return Json(menuList);
		}

		[HttpPost]
		public JsonResult Menu(string menuCode)
		{
			Menu paramMenu = new Menu();
			paramMenu.MenuCode = menuCode;
			Menu menu = baseSvc.Get<Menu>("system.MENU_SELECT_S", paramMenu);
			return Json(menu);
		}

		[Route("MenuWrite")]
		public ActionResult MenuWrite(SystemViewModel vm)
		{
			Menu paramMenu = vm.Menu;
			paramMenu.UpperMenuCode = (paramMenu.UpperMenuCode ?? "%").Equals("%") ? null : paramMenu.UpperMenuCode;
			paramMenu.VisibleYesNo = (paramMenu.VisibleYesNo ?? "N").Equals("on") ? "Y" : "N";
			paramMenu.UseYesNo = (paramMenu.UseYesNo ?? "N").Equals("on") ? "Y" : "N";
			paramMenu.PopupYesNo = (paramMenu.PopupYesNo ?? "N").Equals("on") ? "Y" : "N";
			paramMenu.UserNo = sessionManager.UserNo;

			if (paramMenu.RowState.Equals("C"))
			{
				baseSvc.Save("system.MENU_SAVE_C", paramMenu);
			}
			else
			{
				baseSvc.Save("system.MENU_SAVE_U", paramMenu);
			}

			return Redirect(string.Format("/System/MenuList?depth1={0}&depth2={1}&depth3={2}&InfoMessage={3}", vm.Depth1, vm.Depth2, vm.Depth3, "MSG_SAVE_SUCCESS"));
		}

		[HttpPost]
		public JsonResult MenuDelete(string menuCode)
		{
			Menu paramMenu = new Menu();
			paramMenu.MenuCode = menuCode;
			int rs = baseSvc.Save("system.MENU_SAVE_D", paramMenu);
			return Json(rs);
		}
		// 메뉴관리 ▲


		// 사용자 권한관리 ▼
		[Route("PermissionList")]
		public ActionResult PermissionList(SystemViewModel vm)
		{
			Code paramCode = new Code("A", new string[] { "USRT" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", paramCode);

			vm.AuthorityGroup = new AuthorityGroup();
			vm.AuthorityGroupList = baseSvc.GetList<AuthorityGroup>("system.AUTHORITY_GROUP_SELECT_L", null);

			return View(vm);
		}

		[HttpPost]
		public JsonResult PermissionGroup(int groupNo)
		{
			AuthorityGroup paramAuthorityGroup = new AuthorityGroup();
			paramAuthorityGroup.GroupNo = groupNo;
			AuthorityGroup authorityGroup = baseSvc.Get<AuthorityGroup>("system.AUTHORITY_GROUP_SELECT_S", paramAuthorityGroup);
			return Json(authorityGroup);
		}

		[HttpPost]
		public JsonResult PermissionWrite(SystemViewModel vm)
		{
			AuthorityGroup paramAuthorityGroup = vm.AuthorityGroup;
			paramAuthorityGroup.UseYesNo = (paramAuthorityGroup.UseYesNo ?? "N").Equals("on") ? "Y" : "N";
			paramAuthorityGroup.UserNo = sessionManager.UserNo;

			int result = systemSvc.PermessionSave(paramAuthorityGroup);

			return Json(result);
		}

		[HttpPost]
		public JsonResult PermissionDelete(int groupNo)
		{
			AuthorityGroup paramAuthorityGroup = new AuthorityGroup("D");
			paramAuthorityGroup.GroupNo = groupNo;
			paramAuthorityGroup.UserNo = sessionManager.UserNo;

			int result = systemSvc.PermessionSave(paramAuthorityGroup);

			return Json(result);
		}
		// 사용자 권한관리 ▲


		// 권한별 메뉴관리 ▼
		[Route("PermissionMenuList/{param1}")]
		public ActionResult PermissionMenuList(SystemViewModel vm, int param1 = 1)
		{
			//param1 : GroupNo

			vm.AuthorityGroupList = baseSvc.GetList<AuthorityGroup>("system.AUTHORITY_GROUP_SELECT_L", null).Where(c => c.UseYesNo == "Y").ToList();

			vm.MenuAuthority = new MenuAuthority();
			vm.MenuAuthority.GroupNo = param1;

			MenuAuthority paramMenuAuthority = new MenuAuthority();
			paramMenuAuthority.GroupNo = vm.MenuAuthority.GroupNo;
			vm.MenuAuthorityList = baseSvc.GetList<MenuAuthority>("system.AUTHORITY_MENU_SELECT_S", paramMenuAuthority).OrderBy(c => c.SortNo).ToList();

			return View(vm);
		}

		[HttpPost]
		[Route("PermissionMenuList")]
		public ActionResult PermissionMenuList(SystemViewModel vm)
		{
			return Redirect(string.Format("/System/PermissionMenuList/{0}", vm.MenuAuthority.GroupNo > 0 ? vm.MenuAuthority.GroupNo : 1));
		}

		[Route("PermissionMenuWrite/{param1}")]
		public ActionResult PermissionMenuWrite(SystemViewModel vm, int param1)
		{
			//param1 : GroupNo

			vm.AuthorityGroupList = baseSvc.GetList<AuthorityGroup>("system.AUTHORITY_GROUP_SELECT_L", null);

			vm.MenuAuthority = vm.MenuAuthority ?? new MenuAuthority();
			vm.MenuAuthority.GroupNo = param1;
			vm.MenuAuthority.AuthorityGroupName = vm.AuthorityGroupList.Where(c => c.GroupNo == vm.MenuAuthority.GroupNo).FirstOrDefault().AuthorityGroupName;

			MenuAuthority paramMenuAuthority = new MenuAuthority();
			paramMenuAuthority.GroupNo = vm.MenuAuthority.GroupNo;
			vm.MenuAuthorityList = baseSvc.GetList<MenuAuthority>("system.AUTHORITY_MENU_SELECT_L", paramMenuAuthority).OrderBy(c => c.SortNo).ToList();

			return View(vm);
		}

		[HttpPost]
		public JsonResult PermissionMenuSave(SystemViewModel vm)
		{
			vm.MenuAuthority.UserNo = sessionManager.UserNo;
			int result = systemSvc.PermessionMenuSave(vm.MenuAuthority);

			return Json(result);
		}
		// 권한별 메뉴관리 ▲


		// 학기관리 ▼
		[Route("TermList")]
		public ActionResult TermList()
		{
			SystemViewModel vm = new SystemViewModel();
			// 학기설정 리스트 조회
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L"));
			return View(vm);
		}

		[Route("TermWrite/{param1}")]
		public ActionResult TermWrite(int? param1)
		{
			SystemViewModel vm = new SystemViewModel();

			if (param1 != null)
			{
				// 학기설정 상세보기 리스트 조회
				Hashtable hash = new Hashtable();
				hash.Add("RowState", "S");
				hash.Add("TermNo", param1);
				vm.Term = baseSvc.Get<Term>("term.TERM_SELECT_S", hash);

				// 학기설정 상세보기 주 조회
				Hashtable ht = new Hashtable();
				ht.Add("RowState", "L");
				ht.Add("TermNo", param1);
				vm.TermWeekList = baseSvc.GetList<TermWeek>("term.TERM_WEEK_SELECT_L", ht);
			}
			else
			{
				// 년도 학기 설정
				Code code = new Code("A", new string[] { "CTRM" });
				vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

				vm.Term = null;
				vm.TermWeekList = null;
			}
			return View(vm);
		}

		[HttpPost]
		public JsonResult GetWeekDay(DateTime sd, int pd)
		{
			string day = "";

			// 학습주차 설정
			for (int i = 0; i < 16; i++)
			{
				day += ";" + sd.AddDays(i * pd).ToShortDateString() + ";" + sd.AddDays(i * pd + (pd - 1)).ToShortDateString();
			}
			return Json(day.Substring(1));
		}

		[HttpPost]
		[Route("TermWrite")]
		public ActionResult TermWrite(SystemViewModel vm)
		{
			Hashtable paramHash = new Hashtable();

			string StartTime = " 00:00:00";
			string EndTime = " 23:59:59";

			if (vm.Term.TermNo != 0)
			{
				paramHash.Add("RowState", "U");
				paramHash.Add("TermNo", vm.Term.TermNo);
				paramHash.Add("TermYear", vm.Term.TermYear);
				paramHash.Add("TermQuarter", vm.Term.TermQuarter ?? "CTRM001");
				paramHash.Add("TermStartDay", vm.Term.TermStartDay + StartTime);
				paramHash.Add("TermEndDay", vm.Term.TermEndDay + EndTime);
				paramHash.Add("LectureRequestStartDay", vm.Term.LectureRequestStartDay);
				paramHash.Add("LectureRequestEndDay", vm.Term.LectureRequestEndDay);
				paramHash.Add("LectureStartDay", vm.Term.LectureStartDay + StartTime);
				paramHash.Add("LectureEndDay", vm.Term.LectureEndDay + EndTime);
				paramHash.Add("AccessRestrictionName", vm.Term.AccessRestrictionName);
				paramHash.Add("AccessRestrictionStartDay", vm.Term.AccessRestrictionStartDay);
				paramHash.Add("AccessRestrictionEndDay", vm.Term.AccessRestrictionEndDay);
				paramHash.Add("LatenessSetupDay", vm.Term.LatenessSetupDay);
				paramHash.Add("UseYesNo", "Y");
				paramHash.Add("DeleteYesNo", "N");
				paramHash.Add("UpdateUserNo", sessionManager.UserNo);
				paramHash.Add("TermRound", vm.Term.TermRound);

				baseSvc.Save("term.TERM_SAVE_U", paramHash);

				for (int i = 0; i < vm.TermWeekList.Count; i++)
				{
					Hashtable hash = new Hashtable();
					hash.Add("RowState", "U");
					hash.Add("TermNo", vm.Term.TermNo);
					hash.Add("Week", i + 1);
					hash.Add("WeekStartDay", vm.TermWeekList[i].WeekStartDay);
					hash.Add("WeekEndDay", vm.TermWeekList[i].WeekEndDay);

					baseSvc.Save("term.TERM_WEEK_SAVE_U", hash);
				}
			}
			else
			{
				paramHash.Add("RowState", "C");
				paramHash.Add("TermGubun", "CTGB001");
				paramHash.Add("TermYear", vm.Term.TermYear);
				paramHash.Add("TermQuarter", vm.Term.TermQuarter ?? "CTRM001");
				paramHash.Add("TermStartDay", vm.Term.TermStartDay + StartTime);
				paramHash.Add("TermEndDay", vm.Term.TermEndDay + EndTime);
				paramHash.Add("LectureRequestStartDay", vm.Term.LectureRequestStartDay);
				paramHash.Add("LectureRequestEndDay", vm.Term.LectureRequestEndDay);
				paramHash.Add("LectureStartDay", vm.Term.LectureStartDay + StartTime);
				paramHash.Add("LectureEndDay", vm.Term.LectureEndDay + EndTime);
				paramHash.Add("AccessRestrictionName", vm.Term.AccessRestrictionName);
				paramHash.Add("AccessRestrictionStartDay", vm.Term.AccessRestrictionStartDay);
				paramHash.Add("AccessRestrictionEndDay", vm.Term.AccessRestrictionEndDay);
				paramHash.Add("LatenessSetupDay", vm.Term.LatenessSetupDay);
				paramHash.Add("UseYesNo", "Y");
				paramHash.Add("DeleteYesNo", "N");
				paramHash.Add("CreateUserNo", sessionManager.UserNo);
				paramHash.Add("TermRound", vm.Term.TermRound);

				baseSvc.Save("term.TERM_SAVE_C", paramHash);

				for (int i = 0; i < vm.TermWeekList.Count; i++)
				{
					Hashtable hash = new Hashtable();
					hash.Add("RowState", "C");
					hash.Add("TermGubun", "CTGB001");
					hash.Add("Week", i + 1);
					hash.Add("WeekStartDay", vm.TermWeekList[i].WeekStartDay);
					hash.Add("WeekEndDay", vm.TermWeekList[i].WeekEndDay);
					hash.Add("CreateUserNo", sessionManager.UserNo);
					hash.Add("UseYesNo", "Y");

					baseSvc.Save("term.TERM_WEEK_SAVE_C", hash);
				}
			}

			return View(vm);
		}
		// 학기관리 ▲


		// 코드관리 ▼
		[Route("CodeList/{param1}")]
		public ActionResult CodeList(SystemViewModel vm, string param1)
		{
			// 상위코드 조회
			vm.CodeList = baseSvc.GetList<Code>("system.CLASSCODE_SELECT_L", null);

			string classCode = null;
			
			if (param1 != null)
				classCode = param1;
			else
				classCode = vm.CodeList[0].ClassCode;

			Hashtable paramHash = new Hashtable();
			paramHash.Add("ClassCode", classCode);
			paramHash.Add("DeleteYesNo", "N");
			paramHash.Add("UseYesNo", "Y");
			// 하위코드 조회
			vm.DetailCodeList = baseSvc.GetList<Code>("system.CLASSCODE_SELECT_S", paramHash);
			vm.ClassCode = classCode;

			return View(vm);
		}

		public JsonResult CodeSaveAjax(string Code, string CodeName, string UseYN, string Remark, string RowState)
		{
			int cnt = 0;
			
			Hashtable paramHash = new Hashtable();
			paramHash.Add("ClassCode"   , Code);
			paramHash.Add("ClassName"   , CodeName);
			paramHash.Add("UseYesNo"    , UseYN);
			paramHash.Add("Remark"	    , Remark);
			paramHash.Add("SortNo"	    , 0);
			paramHash.Add("DeleteYesNo" , "N");
			paramHash.Add("CreateUserNo", sessionManager.UserNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);

			cnt = baseSvc.Save("system.CLASSCODE_SAVE_" + RowState, paramHash);
			return Json(cnt);
		}

		public JsonResult CodeDetailSaveAjax(string ClassCode, string Code, string CodeName, int SortNo, string UseYN, string RowState)
		{
			int cnt = 0;

			Hashtable paramHash = new Hashtable();
			paramHash.Add("ClassCode"   , ClassCode);
			paramHash.Add("CodeValue"   , Code);
			paramHash.Add("CodeName"	, CodeName);
			paramHash.Add("UseYesNo"    , UseYN);
			paramHash.Add("SortNo"	    , SortNo);
			paramHash.Add("DeleteYesNo" , UseYN.Equals("Y") ? "N" : "Y" );
			paramHash.Add("CreateUserNo", sessionManager.UserNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);

			cnt = baseSvc.Save("system.DETAILCODE_SAVE_" + RowState, paramHash);
			return Json(cnt);
		}
		// 코드관리 ▲


		// 메일관리 ▼
		[Route("MailList")]
		public ActionResult MailList()
		{
			return View();
		}
		// 메일관리 ▲


		// 활동통계 : 교수메뉴활동현황 ▼
		[Route("MenuAccessList/{param1}/{param2}")]
		public ActionResult MenuAccessList(StatisticsViewModel vm)
		{
			// 페이징 처리
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 년도 학기 설정
			vm.Term = new Term();
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term());
			vm.TermList = vm.TermList.Where(c => DateTime.ParseExact(c.TermStartDay, "yyyy-MM-dd", null) <= DateTime.Now).OrderByDescending(c => c.TermNo).ToList();

			vm.TermNo = vm.TermNo > 0 ? vm.TermNo : baseSvc.Get<int>("term.TERM_SELECT_C", new Term());

			Hashtable paramForList = new Hashtable();
			paramForList.Add("TermNo", vm.TermNo);
			paramForList.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramForList.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACTIVITY_SELECT_L", paramForList);

			vm.PageTotalCount = vm.StatisticsList.FirstOrDefault() != null ? vm.StatisticsList.FirstOrDefault().TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "TermNo", vm.TermNo}, { "PageRowsize", vm.PageRowSize } };
			
			return View(vm);
		}

		[Route("MenuAccessExcel")]
		public ActionResult MenuAccessExcel(StatisticsViewModel vm)
		{
			Hashtable paramForExcel = new Hashtable();
			paramForExcel.Add("TermNo", vm.TermNo);
			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACTIVITY_SELECT_L", paramForExcel);

			string[] headers;
			string[] colums;

			if (vm.UnivYN().Equals("Y"))
			{
				headers = new string[] { "연번", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "분반", "학점", "시간", "소속", "강의형태", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "퀴즈", "과제", "팀프로젝트", "토론", "강의OCW 적용현황", "주별 학습의견"};
				colums = new string[] { "RowNum", "SubjectName", "ClassNo", "Credit", "LecTime", "AssignName", "StudyTypeName", "ProNameList", "ExamCount", "HomeworkCount", "ProjectCount", "DiscussionCount", "CourseOcwCount", "CourseOcwOpinionCount"};
			}
			else
			{
				headers = new string[] { "연번", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "퀴즈", "과제", "팀프로젝트", "토론", "강의OCW 적용현황", "주별 학습의견" };
				colums = new string[] { "RowNum", "SubjectName", "ProNameList", "ExamCount", "HomeworkCount", "ProjectCount", "DiscussionCount", "CourseOcwCount", "CourseOcwOpinionCount" };
			}
			return ExportExcel(headers, colums, vm.StatisticsList, String.Format(WebConfigurationManager.AppSettings["ProfIDText"].ToString() + "메뉴활동현황_{0}", DateTime.Now.ToString("yyyyMMdd")));
		}
		// 활동통계 : 교수메뉴활동현황 ▲

		//게시판 마스터 관리 ▼
		public ActionResult BoardMaster(BoardViewModel vm)
		{
			//게시판 마스터 조회
			vm.BoardMasterList = baseSvc.GetList<BoardMaster>("board.BOARD_MASTER_SELECT_L", vm.BoardMaster);

			return View(vm);
		}

		[HttpPost]
		public ActionResult BoardMasterWrite(BoardViewModel vm)
		{
			vm.BoardMaster.BoardIsUseAcceptYesNo = (vm.BoardMaster.BoardIsUseAcceptYesNo ?? "N").Equals("on") ? "Y" : "N";
			vm.BoardMaster.BoardIsUseFileYesNo = (vm.BoardMaster.BoardIsUseFileYesNo ?? "N").Equals("on") ? "Y" : "N";
			vm.BoardMaster.BoardIsUseReplyYesNo = (vm.BoardMaster.BoardIsUseReplyYesNo ?? "N").Equals("on") ? "Y" : "N";
			vm.BoardMaster.BoardIsSecretYesNo = (vm.BoardMaster.BoardIsSecretYesNo ?? "N").Equals("on") ? "Y" : "N";
			vm.BoardMaster.IsRead = (vm.BoardMaster.IsRead ?? "N").Equals("on") ? "Y" : "N";
			vm.BoardMaster.IsAnonymous = (vm.BoardMaster.IsAnonymous ?? "N").Equals("on") ? "Y" : "N";
			vm.BoardMaster.IsEvent = (vm.BoardMaster.IsEvent ?? "N").Equals("on") ? "Y" : "N";
			vm.BoardMaster.IsNotice = (vm.BoardMaster.IsNotice ?? "N").Equals("on") ? "Y" : "N";
			vm.BoardMaster.UseYesNo = (vm.BoardMaster.UseYesNo ?? "N").Equals("on") ? "Y" : "N";

			if (vm.BoardMaster.RowState.Equals("C"))
			{
				baseSvc.Save("board.BOARD_MASTER_SAVE_C", vm.BoardMaster);
			}
			else
			{
				baseSvc.Save("board.BOARD_MASTER_SAVE_U", vm.BoardMaster);
			}
			return Redirect("/System/BoardMaster");
		}

		[Route("BoardAuthority/{param1}")]
		public ActionResult BoardAuthority(BoardViewModel vm, string param1)
		{
			//param1 : 게시판 마스터 번호
			Hashtable htMaster = new Hashtable();
			htMaster.Add("MasterNo", Convert.ToInt32(param1));
			BoardMaster boardMaster = baseSvc.Get<BoardMaster>("board.BOARD_MASTER_SELECT_S", htMaster);

			if(boardMaster != null)
			{
				vm.BoardTitle = boardMaster.BoardTitle;

				Hashtable ht = new Hashtable();
				ht.Add("BoardMasterNo", Convert.ToInt32(param1));
				vm.BoardAuthorityList = baseSvc.GetList<BoardAuthority>("system.BOARD_AUTHORITY_SELECT_L", ht);
			}
			else
			{
				vm.BoardTitle = "";
			}

			return View(vm);
		}

		[HttpPost]
		public JsonResult GetBoardMasterList(string masterNo)
		{
			Hashtable htMaster = new Hashtable();
			htMaster.Add("MasterNo", masterNo);
			BoardMaster boardMaster = baseSvc.Get<BoardMaster>("board.BOARD_MASTER_SELECT_S", htMaster);
			return Json(boardMaster);
		}

		[HttpPost]
		public JsonResult BoardAuthoritySave(int no, int groupNo, string isRead, string isWrite)
		{
			Hashtable ht = new Hashtable();
			ht.Add("BoardMasterNo", no);
			ht.Add("AuthorityGroupNo", groupNo);
			ht.Add("IsRead", isRead);
			ht.Add("IsWrite", isWrite);
			ht.Add("UserNo", sessionManager.UserNo);

			int rs = baseSvc.Save("system.BOARD_AUTHORITY_SAVE_CU", ht);
			return Json(rs);
		}
		//게시판 마스터 관리 ▲
	}
}