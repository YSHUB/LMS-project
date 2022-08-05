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
	[RoutePrefix("Message")]
	public class MessageController : WebBaseController
	{
		public MessageService messageSvc { get; set; }

		[Route("/")]
		[Route("List")]
		[Route("List/{param1}")]
		[Route("List/{param1}/{param2}")]
		public ActionResult List(BoardViewModel vm, int? param1, int? param2)
		{
			int highFixCount = 0;
			int BoardCount = 0;

			//param1 = courseNo, param2 = masterNo
			vm.CourseNo = param1 ?? 0;
			vm.MasterNo = param2 ?? 0;
			vm.PageRowSize = vm.PageRowSize ?? 10;
			vm.PageNum = vm.PageNum ?? 1;
			vm.PublicGubun = vm.PublicGubun ?? 0;
			vm.SearchType = vm.SearchType ?? "BoardTitle";

			Hashtable htHighFix = new Hashtable();
			Hashtable htBoard = new Hashtable();

			switch (vm.SearchType)
			{
				case "Contents":
					htHighFix.Add("Contents", vm.SearchText);
					htBoard.Add("Contents", vm.SearchText);
					break;
				case "HangulName":
					htHighFix.Add("HangulName", vm.SearchText);
					htBoard.Add("HangulName", vm.SearchText);
					break;
				case "UserID":
					htHighFix.Add("UserID", vm.SearchText);
					htBoard.Add("UserID", vm.SearchText);
					break;

				default:
					htHighFix.Add("BoardTitle", vm.SearchText);
					htBoard.Add("BoardTitle", vm.SearchText);
					break;
			}


			//상단고정 공지사항 조회
			htHighFix.Add("RowState", "L");
			htHighFix.Add("MasterNo", param2);
			htHighFix.Add("InquiryUserNo", ViewBag.User.UserNo);
			htHighFix.Add("HighestFixYesNo", "Y");
			vm.HighestFixList = baseSvc.GetList<Board>("board.BOARD_SELECT_L", htHighFix);
			highFixCount = vm.HighestFixList.Count;


			//게시물 조회
			htBoard.Add("RowState", "L");
			htBoard.Add("MasterNo", param2);
			htBoard.Add("InquiryUserNo", ViewBag.User.UserNo);
			htBoard.Add("HighestFixYesNo", "N");
			BoardCount = baseSvc.GetList<Board>("board.BOARD_SELECT_L", htBoard).Count;

			htBoard.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			htBoard.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.BoardList = baseSvc.GetList<Board>("board.BOARD_SELECT_L", htBoard);

			vm.PageTotalCount = BoardCount;
			vm.Dic = new RouteValueDictionary { { "SearchType", vm.SearchType }, { "SearchText", vm.SearchText }, { "pagerowsize", vm.PageRowSize }, { "PublicGubun", vm.PublicGubun } };

			return View(vm);
		}

		[Route("List/{param1}/{param2}/{param3}")]
		public ActionResult Detail(BoardViewModel vm, int? param1, int? param2, int? param3)
		{
			//param1 = courseNo, param2 = masterNo, param3 = BoardNo
			Hashtable htBoard = new Hashtable();

			//게시물 조회
			htBoard.Add("RowState", "S");
			htBoard.Add("MasterNo", param2 ?? 0);
			htBoard.Add("BoardNo", param3 ?? 0);
			vm.Board = baseSvc.Get<Board>("board.BOARD_SELECT_S", htBoard);

			//이전글, 다음글 조회
			htBoard = new Hashtable();
			htBoard.Add("RowState", "A");
			htBoard.Add("MasterNo", param2 ?? 0);
			htBoard.Add("BoardNo", param3 ?? 0);

			switch (vm.SearchType)
			{
				case "Contents":
					htBoard.Add("Contents", vm.SearchText);
					break;

				case "HangulName":
					htBoard.Add("HangulName", vm.SearchText);
					break;

				case "UserID":
					htBoard.Add("UserID", vm.SearchText);
					break;

				default:
					htBoard.Add("BoardTitle", vm.SearchText);
					break;
			}

			vm.PrevNextList = baseSvc.GetList<Board>("board.BOARD_SELECT_A", htBoard);

			return View(vm);
		}

		[Route("Write")]
		public ActionResult Write(MessageViewModel vm)
		{
			// 사용자 검색 모달 (전공 조회)
			Assign assign = new Assign();
			vm.AssignList = baseSvc.GetList<Assign>("common.COMMON_DEPT_SELECT_L", assign);

			return View(vm);
		}

		public JsonResult GetEmployeeList(string userGbn, string assignInfo, string staffNO)
		{
			// 사용자 조회
			Hashtable paramUser = new Hashtable();
			paramUser.Add("SearchGbn", userGbn);
			paramUser.Add("AssignNo", assignInfo);
			paramUser.Add("SearchText", staffNO);

			IList<Student> studentList = baseSvc.GetList<Student>("message.MESSAGE_SELECT_L", paramUser);

			return Json(studentList, JsonRequestBehavior.AllowGet);
		}

		public JsonResult GetReceiverList(string users)
		{
			// 수신인 조회
			Hashtable paramReceiver = new Hashtable();
			paramReceiver["UserNo"] = users.Replace("|", ",");

			IList<Student> studentList = baseSvc.GetList<Student>("message.MESSAGE_SELECT_A", paramReceiver);

			return Json(studentList, JsonRequestBehavior.AllowGet);
		}

		[Route("SMSWrite")]
		public ActionResult SMSWrite(MessageViewModel vm)
		{

			if (ViewBag.IsAdmin)
			{
				//수신대상 공통코드 구분
				Code code = new Code();
				code.ClassCode = "NTTG";

				if (ViewBag.User.UserType == "USRT001")
				{
					// 학부생일 경우
					vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(x => x.CodeValue.Equals("NTTG001") || x.CodeValue.Equals("NTTG003")).ToList();
				}
				else if (ViewBag.User.UserType == "USRT007" || ViewBag.User.UserType == "USRT009" || (ViewBag.User.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N")))
				{
					//교원, 직원일 경우
					vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(x => x.CodeValue.Equals("NTTG001") || x.CodeValue.Equals("NTTG002") || x.CodeValue.Equals("NTTG003")).ToList();
				}
				else if (ViewBag.User.UserType == "USRT010" || ViewBag.User.UserType == "USRT011" || (ViewBag.User.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y")))
				{
					//통합관리자, 운영자, 강사/부운영자일 경우
					vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
				}
				else
				{
					//그 외일 경우
					vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(x => x.CodeValue.Equals("NTTG001")).ToList();
				}

				//학기 구분
				vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term());
				vm.TermList = vm.TermList.Where(c => DateTime.ParseExact(c.TermStartDay, "yyyy-MM-dd", null) <= DateTime.Now).OrderByDescending(c => c.SortNo).ToList();
			}

			User user = (User)Session[SessionConstants.UserInfo.ToString()];

			var smsServerInfo = System.Configuration.ConfigurationManager.AppSettings["SMSServer"].Split(';');

			vm.SendPhoneNo = !string.IsNullOrEmpty(user.Mobile) ? user.Mobile : smsServerInfo.Count() > 2 ? smsServerInfo[2] : "";
			vm.SendUserNo = Convert.ToInt32(user.UserNo);

			return View(vm);
		}

		[HttpPost]
		[Route("SMSWriteSave")]
		public JsonResult SMSWriteSave(string userNo, string contents, string sendPhoneNo, string courseNo)
		{

			// 교수 SMS전송
			MessageViewModel vm = new MessageViewModel();

			vm.Message = new Design.Domain.Message();

			int rsCount = 0;
			User user = (User)Session[SessionConstants.UserInfo.ToString()];

			if (string.IsNullOrEmpty(user.Mobile))
			{
				return Json(0);
			}

			if (userNo.ToString() != "")
			{
				// Design.Domain.Message 수정해야함
				List<Design.Domain.Message> tempList = new List<Design.Domain.Message>();
				vm.ReceiveUserNos = (userNo).Split(',');
				vm.Message.SendUserName = user.HangulName;
				vm.Message.SendUserNo = user.UserNo;
				vm.Message.SendContents = contents;
				vm.Message.SendPhoneNo = sendPhoneNo;
				vm.Message.CourseNo = string.IsNullOrEmpty(courseNo) ? 0 : Convert.ToInt32(courseNo);
				vm.Message.SendGubun = "N";
				vm.Message.SendCount = vm.ReceiveUserNos.Length;

				string address = string.Empty;

				foreach (var item in vm.ReceiveUserNos)
				{
					Design.Domain.Message tempMessage = new Design.Domain.Message();

					Hashtable paramUser = new Hashtable();
					paramUser.Add("UserNo", item);
					User tempUser = baseSvc.Get<User>("account.USER_SELECT_S", paramUser);

					if (tempUser != null)
					{
						if (!string.IsNullOrEmpty(tempUser.Mobile))
						{
							tempMessage.ReceiveUserName = tempUser.HangulName;
							tempMessage.ReceiveUserNo = long.Parse(item);
							tempMessage.ReceivePhoneNo = tempUser.Mobile.Replace(" ", "").Replace("-", "");
							address += (address == "") ? tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo : "|" + tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo;
							tempList.Add(tempMessage);
						}
					}
				}

				if (address.Length > 0)
				{
					vm.Message.Address = address;
					vm.Message.SendCount = tempList.Count;
					rsCount = tempList.Count;

					//로그기록만 함.(DB insert 방식일 시 SMSDAO.cs에서 수정)
					messageSvc.MessageUpdate(vm.Message, tempList);
				}
			}

			return Json(rsCount);
		}

		[Route("SMSWriteAdminSave/{param1}/{param2}/{param3}/{param4}")]
		public ActionResult SMSWriteAdminSave(MessageViewModel vm, string param1, string param2, int? param3, int? param4)
		{
			// 관리자 SMS 전송
			// param1 : targetVal
			// param2 : userNo
			// param3 : courseNo
			// param4 : termNo
			if (param1.Equals("NTTG001"))
			{
				User user = (User)Session[SessionConstants.UserInfo.ToString()];

				if (string.IsNullOrEmpty(user.Mobile))
				{
					return Json(0);
				}

				if (param2.ToString() != "")
				{
					// Design.Domain.Message 수정해야함
					List<Design.Domain.Message> tempList = new List<Design.Domain.Message>();
					vm.ReceiveUserNos = (param2).Split(',');
					vm.Message.SendUserName = user.HangulName;
					vm.Message.SendUserNo = user.UserNo;
					vm.Message.SendContents = vm.Message.SendContents;
					vm.Message.SendPhoneNo = vm.Message.SendPhoneNo;
					vm.Message.CourseNo = param3.Equals(0) ? 0 : Convert.ToInt32(param3);
					vm.Message.SendGubun = "N";
					vm.Message.SendCount = vm.ReceiveUserNos.Length;

					string address = string.Empty;

					foreach (var item in vm.ReceiveUserNos)
					{
						Design.Domain.Message tempMessage = new Design.Domain.Message();

						Hashtable paramUser = new Hashtable();
						paramUser.Add("UserNo", item);
						User tempUser = baseSvc.Get<User>("account.USER_SELECT_S", paramUser);

						if (tempUser != null)
						{
							if (!string.IsNullOrEmpty(tempUser.Mobile))
							{
								tempMessage.ReceiveUserName = tempUser.HangulName;
								tempMessage.ReceiveUserNo = long.Parse(item);
								tempMessage.ReceivePhoneNo = tempUser.Mobile.Replace(" ", "").Replace("-", "");
								address += (address == "") ? tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo : "|" + tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo;
								tempList.Add(tempMessage);
							}
						}
					}

					if (address.Length > 0)
					{
						vm.Message.Address = address;
						vm.Message.SendCount = tempList.Count;

						//로그기록만 함.(DB insert 방식일 시 SMSDAO.cs에서 수정)
						messageSvc.MessageUpdate(vm.Message, tempList);
					}
				}
			}
			else if (param1.Equals("NTTG002"))
			{
				//관리자 로그인 시 과목 수강생 조회
				Hashtable StudList = new Hashtable();
				StudList.Add("TermNo", param4);
				StudList.Add("CourseNo", param3);
				vm.ReceiverUserList = baseSvc.GetList<Design.Domain.Message>("message.NOTE_SELECT_H", StudList);

				User user = (User)Session[SessionConstants.UserInfo.ToString()];

				// Design.Domain.Message 수정해야함
				List<Design.Domain.Message> tempList = new List<Design.Domain.Message>();
				//vm.ReceiveUserNos = (param2).Split(',');
				vm.Message.SendUserName = user.HangulName;
				vm.Message.SendUserNo = user.UserNo;
				vm.Message.SendContents = vm.Message.SendContents;
				vm.Message.SendPhoneNo = vm.Message.SendPhoneNo;
				vm.Message.CourseNo = param3.Equals(0) ? 0 : Convert.ToInt32(param3);
				vm.Message.SendGubun = "N";
				vm.Message.SendCount = vm.ReceiverUserList.Count();

				string address = string.Empty;

				foreach (var item in vm.ReceiverUserList)
				{
					Design.Domain.Message tempMessage = new Design.Domain.Message();

					Hashtable paramUser = new Hashtable();
					paramUser.Add("UserNo", item.ReceiveUserNo);
					User tempUser = baseSvc.Get<User>("account.USER_SELECT_S", paramUser);

					if (tempUser != null)
					{
						if (!string.IsNullOrEmpty(tempUser.Mobile))
						{
							tempMessage.ReceiveUserName = tempUser.HangulName;
							tempMessage.ReceiveUserNo = item.ReceiveUserNo;
							tempMessage.ReceivePhoneNo = tempUser.Mobile.Replace(" ", "").Replace("-", "");
							address += (address == "") ? tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo : "|" + tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo;
							tempList.Add(tempMessage);
						}
					}
				}

				if (address.Length > 0)
				{
					vm.Message.Address = address;
					vm.Message.SendCount = tempList.Count;

					//로그기록만 함.(DB insert 방식일 시 SMSDAO.cs에서 수정)
					messageSvc.MessageUpdate(vm.Message, tempList);
				}
			}
			else if (param1.Equals("NTTG003"))
			{
				//관리자 로그인 시 과목 교수 조회
				Hashtable StaffList = new Hashtable();
				StaffList.Add("TermNo", param4);
				StaffList.Add("CourseNo", param3);
				vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_E", StaffList);

				User user = (User)Session[SessionConstants.UserInfo.ToString()];

				// Design.Domain.Message 수정해야함
				List<Design.Domain.Message> tempList = new List<Design.Domain.Message>();
				//vm.ReceiveUserNos = (param2).Split(',');
				vm.Message.SendUserName = user.HangulName;
				vm.Message.SendUserNo = user.UserNo;
				vm.Message.SendContents = vm.Message.SendContents;
				vm.Message.SendPhoneNo = vm.Message.SendPhoneNo;
				vm.Message.CourseNo = param3.Equals(0) ? 0 : Convert.ToInt32(param3);
				vm.Message.SendGubun = "N";
				vm.Message.SendCount = vm.CourseList.Count();

				string address = string.Empty;

				foreach (var item in vm.CourseList)
				{
					Design.Domain.Message tempMessage = new Design.Domain.Message();

					Hashtable paramUser = new Hashtable();
					paramUser.Add("UserNo", item.ProfessorNo);
					User tempUser = baseSvc.Get<User>("account.USER_SELECT_S", paramUser);

					if (tempUser != null)
					{
						if (!string.IsNullOrEmpty(tempUser.Mobile))
						{
							tempMessage.ReceiveUserName = tempUser.HangulName;
							tempMessage.ReceiveUserNo = item.ProfessorNo;
							tempMessage.ReceivePhoneNo = tempUser.Mobile.Replace(" ", "").Replace("-", "");
							address += (address == "") ? tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo : "|" + tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo;
							tempList.Add(tempMessage);
						}
					}
				}

				if (address.Length > 0)
				{
					vm.Message.Address = address;
					vm.Message.SendCount = tempList.Count;

					//로그기록만 함.(DB insert 방식일 시 SMSDAO.cs에서 수정)
					messageSvc.MessageUpdate(vm.Message, tempList);
				}
			}
			else if (param1.Equals("NTTG004"))
			{
				//관리자 로그인 시 전체 학생 조회
				Hashtable allStudList = new Hashtable();
				vm.NoteList = baseSvc.GetList<Note>("note.NOTE_SELECT_E", allStudList);

				User user = (User)Session[SessionConstants.UserInfo.ToString()];

				// Design.Domain.Message 수정해야함
				List<Design.Domain.Message> tempList = new List<Design.Domain.Message>();
				//vm.ReceiveUserNos = (param2).Split(',');
				vm.Message.SendUserName = user.HangulName;
				vm.Message.SendUserNo = user.UserNo;
				vm.Message.SendContents = vm.Message.SendContents;
				vm.Message.SendPhoneNo = vm.Message.SendPhoneNo;
				vm.Message.CourseNo = param3.Equals(0) ? 0 : Convert.ToInt32(param3);
				vm.Message.SendGubun = "N";
				vm.Message.SendCount = vm.NoteList.Count();

				string address = string.Empty;

				foreach (var item in vm.NoteList)
				{
					Design.Domain.Message tempMessage = new Design.Domain.Message();

					Hashtable paramUser = new Hashtable();
					paramUser.Add("UserNo", item.ReceiveUserID);
					User tempUser = baseSvc.Get<User>("account.USER_SELECT_S", paramUser);

					if (tempUser != null)
					{
						if (!string.IsNullOrEmpty(tempUser.Mobile))
						{
							tempMessage.ReceiveUserName = tempUser.HangulName;
							tempMessage.ReceiveUserNo = Convert.ToInt32(item.ReceiveUserID);
							tempMessage.ReceivePhoneNo = tempUser.Mobile.Replace(" ", "").Replace("-", "");
							address += (address == "") ? tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo : "|" + tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo;
							tempList.Add(tempMessage);
						}
					}
				}

				if (address.Length > 0)
				{
					vm.Message.Address = address;
					vm.Message.SendCount = tempList.Count;

					//로그기록만 함.(DB insert 방식일 시 SMSDAO.cs에서 수정)
					messageSvc.MessageUpdate(vm.Message, tempList);
				}
			}
			else if (param1.Equals("NTTG005"))
			{
				//관리자 로그인 시 전체 교직원 조회
				Hashtable allStaffList = new Hashtable();
				vm.NoteList = baseSvc.GetList<Note>("note.NOTE_SELECT_F", allStaffList);

				User user = (User)Session[SessionConstants.UserInfo.ToString()];

				// Design.Domain.Message 수정해야함
				List<Design.Domain.Message> tempList = new List<Design.Domain.Message>();
				//vm.ReceiveUserNos = (param2).Split(',');
				vm.Message.SendUserName = user.HangulName;
				vm.Message.SendUserNo = user.UserNo;
				vm.Message.SendContents = vm.Message.SendContents;
				vm.Message.SendPhoneNo = vm.Message.SendPhoneNo;
				vm.Message.CourseNo = param3.Equals(0) ? 0 : Convert.ToInt32(param3);
				vm.Message.SendGubun = "N";
				vm.Message.SendCount = vm.NoteList.Count();

				string address = string.Empty;

				foreach (var item in vm.NoteList)
				{
					Design.Domain.Message tempMessage = new Design.Domain.Message();

					Hashtable paramUser = new Hashtable();
					paramUser.Add("UserNo", item.ReceiveUserID);
					User tempUser = baseSvc.Get<User>("account.USER_SELECT_S", paramUser);

					if (tempUser != null)
					{
						if (!string.IsNullOrEmpty(tempUser.Mobile))
						{
							tempMessage.ReceiveUserName = tempUser.HangulName;
							tempMessage.ReceiveUserNo = Convert.ToInt32(item.ReceiveUserID);
							tempMessage.ReceivePhoneNo = tempUser.Mobile.Replace(" ", "").Replace("-", "");
							address += (address == "") ? tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo : "|" + tempUser.HangulName + "^" + tempMessage.ReceivePhoneNo;
							tempList.Add(tempMessage);
						}
					}
				}

				if (address.Length > 0)
				{
					vm.Message.Address = address;
					vm.Message.SendCount = tempList.Count;

					//로그기록만 함.(DB insert 방식일 시 SMSDAO.cs에서 수정)
					messageSvc.MessageUpdate(vm.Message, tempList);
				}
			}

			return RedirectToAction("SMSWrite");
		}

	}
}