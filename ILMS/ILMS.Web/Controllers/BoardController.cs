using ILMS.Core.System;
using ILMS.Data.Dao;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using System;
using System.Collections;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;

namespace ILMS.Web.Controllers
{
	[RoutePrefix("Board")]
	public class BoardController : LectureRoomBaseController
	{
		[Route("/")]
		[Route("List")]
		[Route("List/{param1}")]
		[Route("List/{param1}/{param2}")]
		public ActionResult List(BoardViewModel vm, int? param1, int? param2)
		{
			//param1 = courseNo, param2 = masterNo
			vm.CourseNo = param1 ?? 0;
			vm.MasterNo = param2 ?? 0;
			vm.PageRowSize = vm.PageRowSize ?? 10;
			vm.PageNum = vm.PageNum ?? 1;
			vm.PublicGubun = vm.PublicGubun ?? 0;
			vm.SearchType = vm.SearchType ?? "BoardTitle";
			vm.HighFixHide = vm.HighFixHide ?? "N";

			//게시판 마스터 조회
			Hashtable htMaster = new Hashtable();
			htMaster.Add("MasterNo", vm.MasterNo);

			vm.BoardMaster = baseSvc.Get<BoardMaster>("board.BOARD_MASTER_SELECT_S", htMaster);

			Hashtable htHighFix = new Hashtable();
			Hashtable htBoard = new Hashtable();

			vm.SearchText = HttpUtility.UrlDecode(vm.SearchText) ?? "";

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

			if (vm.HighFixHide != "Y")
			{
				//상단고정 공지사항 조회
				htHighFix.Add("MasterNo", param2);
				htHighFix.Add("InquiryUserNo", ViewBag.User.UserNo);
				htHighFix.Add("HighestFixYesNo", "Y");
				htHighFix.Add("DeleteYesNo", "N");
				if (vm.CourseNo > 0)
					htHighFix.Add("CourseNo", vm.CourseNo);

				vm.HighestFixList = baseSvc.GetList<Board>("board.BOARD_SELECT_L", htHighFix);
			}

			//게시물 조회
			htBoard.Add("MasterNo", param2);
			htBoard.Add("InquiryUserNo", ViewBag.User.UserNo);
			htBoard.Add("DeleteYesNo", "N");
			if (vm.CourseNo > 0)
				htBoard.Add("CourseNo", vm.CourseNo);
			vm.PageTotalCount = baseSvc.GetList<Board>("board.BOARD_SELECT_L", htBoard).Count;

			htBoard.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			htBoard.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.BoardList = baseSvc.GetList<Board>("board.BOARD_SELECT_L", htBoard);

			vm.Dic = new RouteValueDictionary { { "HighFixHide", vm.HighFixHide }, { "SearchType", vm.SearchType }, { "SearchText", HttpUtility.UrlEncode(vm.SearchText) }, { "PageRowSize", vm.PageRowSize }, { "PublicGubun", vm.PublicGubun } };
			
			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", Convert.ToInt32(param1));
			ht.Add("BoardMasterNo", Convert.ToInt32(param2));
			ht.Add("UserNo", (sessionManager.UserNo > 0 ? sessionManager.UserNo : 0));
			vm.BoardAuthority = baseSvc.Get<BoardAuthority>("board.BOARD_AUTHORITY_SELECT_S", ht);

			//강좌 번호로 마스터 페이지 구분
			if (vm.CourseNo > 0)
				return View("List", "~/Views/Shared/LectureRoom.Master", vm);
			else
				return View("List", "~/Views/Shared/Sub.Master", vm);
		}

		[Route("Detail/{param1}/{param2}/{param3}")]
		public ActionResult Detail(BoardViewModel vm, int? param1, int? param2, int? param3)
		{
			//param1 = courseNo, param2 = masterNo, param3 = BoardNo
			vm.CourseNo = param1 ?? 0;
			vm.MasterNo = param2 ?? 0;
			int boardNo = param3 ?? 0;
			vm.PageRowSize = vm.PageRowSize ?? 10;
			vm.PageNum = vm.PageNum ?? 1;

			//게시판 마스터 조회
			Hashtable htMaster = new Hashtable();
			htMaster.Add("MasterNo", vm.MasterNo);
			vm.BoardMaster = baseSvc.Get<BoardMaster>("board.BOARD_MASTER_SELECT_S", htMaster);

			//게시물 조회
			Hashtable htBoard = new Hashtable();
			htBoard.Add("MasterNo", vm.MasterNo);
			htBoard.Add("BoardNo", boardNo);
			vm.Board = baseSvc.Get<Board>("board.BOARD_SELECT_S", htBoard);

			//게시물 답변 조회
			Hashtable htReply = new Hashtable();
			htReply.Add("BoardNo", boardNo);
			htReply.Add("DeleteYesNo", "N");
			vm.BoardReplyCount = baseSvc.GetList<BoardReply>("board.BOARD_REPLY_SELECT_L", htReply).Count;

			htReply.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			htReply.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.BoardContentReplyList = baseSvc.GetList<BoardReply>("board.BOARD_REPLY_SELECT_L", htReply);

			File file = new File();
			file.FileGroupNo = vm.Board.FileGroupNo ?? 0;
			if (vm.Board.FileGroupNo != null)
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
			else
				vm.FileList = null;

			if (vm.BoardMaster.IsEvent.Equals("Y")) 
			{
				BoardEvent boardEvent = new BoardEvent();
				boardEvent.BoardNo = boardNo;
				boardEvent.UserNo = (sessionManager.UserNo > 0 ? sessionManager.UserNo : 0);
				vm.BoardEvent = baseSvc.Get<BoardEvent>("board.BOARD_EVENT_SELECT_S", boardEvent);
			}

			if (vm.BoardMaster.BoardIsUseAcceptYesNo.Equals("Y"))
			{
				Hashtable htAnswer = new Hashtable();
				htAnswer.Add("MasterNo", vm.MasterNo);
				htAnswer.Add("BoardNo", vm.Board.BoardNo);

				vm.Board.AnswerYesNo = baseSvc.Get<Board>("board.BOARD_SELECT_E", htAnswer).AnswerYesNo;
			}

			//이전글, 다음글 조회
			htBoard = new Hashtable();
			htBoard.Add("MasterNo", vm.MasterNo);
			htBoard.Add("BoardNo", param3 ?? 0);
			htBoard.Add("HighestFixYesNo", vm.Board.HighestFixYesNo);
			htBoard.Add("DeleteYesNo", vm.Board.DeleteYesNo);
			if (vm.CourseNo > 0)
				htBoard.Add("CourseNo", vm.CourseNo);

			string searchText = HttpUtility.UrlDecode(vm.SearchText);

			switch (vm.SearchType)
			{
				case "Contents":
					htBoard.Add("Contents", searchText);
					break;

				case "HangulName":
					htBoard.Add("HangulName", searchText);
					break;

				case "UserID":
					htBoard.Add("UserID", searchText);
					break;

				default:
					htBoard.Add("BoardTitle", searchText);
					break;
			}
			vm.PrevNextList = baseSvc.GetList<Board>("board.BOARD_SELECT_A", htBoard);

			//조회수 +1
			Hashtable htLog = new Hashtable();
			htLog.Add("BoardNo", vm.Board.BoardNo);
			baseSvc.Save("board.BOARD_SAVE_A", htLog);

			//조회 로그 기록
			htLog = new Hashtable();
			htLog.Add("BoardNo", vm.Board.BoardNo);
			htLog.Add("InquiryUserNo", (sessionManager.UserNo > 0 ? sessionManager.UserNo : 0));
			baseSvc.Save("board.BOARD_SAVE_B", htLog);

			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", Convert.ToInt32(param1));
			ht.Add("BoardMasterNo", Convert.ToInt32(param2));
			ht.Add("UserNo", (sessionManager.UserNo > 0 ? sessionManager.UserNo : 0));
			vm.BoardAuthority = baseSvc.Get<BoardAuthority>("board.BOARD_AUTHORITY_SELECT_S", ht);

			//강좌 번호로 마스터 페이지 구분
			if (vm.CourseNo > 0)
				return View("Detail", "~/Views/Shared/LectureRoom.Master", vm);
			else
				return View("Detail", "~/Views/Shared/Sub.Master", vm);
		}

		[AuthorFilter(IsMember = true)]
		[Route("Write/{param1}/{param2}/{param3}")]
		[Route("Write/{param1}/{param2}/{param3}/{param4}")]
		public ActionResult Write(int? param1, int? param2, string param3, int? param4)
		{
			//param1 = courseNo, param2 = masterNo, param3 = rowState, param4 = BoardNo( param4는 수정일때 BoardNo 사용)
			int answerRepleNo = (Request.QueryString["AnswerRepleNo"] != "" ? Convert.ToInt32(Request.QueryString["AnswerRepleNo"]) : 0); //답글로 연결시 사용
			BoardViewModel vm = new BoardViewModel();
			vm.FileSuccess = (Request.QueryString["fileSuccess"] != "" ? Convert.ToInt32(Request.QueryString["fileSuccess"]) : 0); 

			vm.CourseNo = param1 ?? 0;
			vm.MasterNo = param2 ?? 0;
			int boardNo = param4 ?? 0;

			Board board = new Board();
			vm.Board = board;
			vm.Board.RowState = param3;

			//게시판 마스터 조회
			Hashtable htMaster = new Hashtable();
			htMaster.Add("MasterNo", vm.MasterNo);

			vm.BoardMaster = baseSvc.Get<BoardMaster>("board.BOARD_MASTER_SELECT_S", htMaster);

			if (vm.Board.RowState == "U")
			{
				//게시물 조회
				Hashtable htBoard = new Hashtable();
				htBoard.Add("MasterNo", vm.MasterNo);
				htBoard.Add("BoardNo", boardNo);
				vm.Board = baseSvc.Get<Board>("board.BOARD_SELECT_S", htBoard);
				vm.Board.RowState = "U";

				File file = new File();
				file.FileGroupNo = vm.Board.FileGroupNo ?? 0;
				if (vm.Board.FileGroupNo != null)
					vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
				else
					vm.FileList = null;
			}
			else if(vm.Board.RowState == "R") //답글로 연결시
			{
				//게시물 조회
				Hashtable htBoard = new Hashtable();
				htBoard.Add("MasterNo", vm.MasterNo);
				htBoard.Add("BoardNo", boardNo);
				vm.Board = baseSvc.Get<Board>("board.BOARD_SELECT_S", htBoard);
				vm.Board.RowState = "R";

				vm.Board.HtmlContents = string.Format("<div id='orgnText'><br/><br/><br/>=============원본글==============<br/>{0}</div>", Server.UrlDecode(vm.Board.HtmlContents));

				//댓글 조회
				Hashtable htReply = new Hashtable();
				htReply.Add("ReplyNo", answerRepleNo);
				string repleText = baseSvc.Get<BoardReply>("board.BOARD_REPLY_SELECT_S", htReply).Contents;
				vm.Board.HtmlContents = string.Format("<div id='repleText'><br/><br/><br/>=============채택된 정답 댓글==============<br/>{0}</div>", repleText) + vm.Board.HtmlContents;

				//상위 게시물 번호
				vm.ParentBoardNo = boardNo;
			}

			//강좌 번호로 마스터 페이지 구분
			if (vm.CourseNo > 0)
				return View("Write", "~/Views/Shared/LectureRoom.Master", vm);
			else
				return View("Write", "~/Views/Shared/Sub.Master", vm);
		}

		[HttpPost]
		public ActionResult Write(BoardViewModel vm)
		{
			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long? fileGroupNo = 0;
			
			#region "파일관련"
			int fileCnt = 0;
			for(int i =0; i < Request.Files.Count; i++)
			{
				if (Request.Files[i].ContentLength != 0)
					fileCnt++;
			}

			if (fileCnt > 0)
			{
				fileGroupNo = FileUpload(vm.Board.RowState ?? "C", "Board", vm.Board.FileGroupNo, "BoardFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}
			#endregion "파일관련"

			if (fileSuccess) //파일 업로드 성공 시 게시물을 저장함
			{
				vm.Board.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo;
				vm.Board.CreateUserNo = vm.Board.CreateUserNo;
				vm.Board.UpdateUserNo = vm.Board.CreateUserNo;

				vm.Board.MasterNo = vm.MasterNo;
				vm.Board.IPAddress = Request.UserHostAddress;
				vm.Board.HtmlContents = Server.UrlDecode(vm.Board.HtmlContents);
				vm.Board.CourseNo = vm.CourseNo ?? 0;
				vm.Board.TeamNo = vm.TeamNo;
				vm.Board.HighestFixYesNo = (vm.Board.HighestFixYesNo ?? "N").Equals("Y") ? "Y" : "N";

				//상단고정, 공지 설정시, 익명, 비밀글 설정 안됨.
				if (vm.Board.HighestFixYesNo == "Y")
				{
					vm.Board.IsSecret = 0;
					vm.Board.IsAnonymous = 0;
				}

				if (vm.Board.RowState == "C")
				{
					// 글작성 시 자동 참여도반영
                    // 부적절한 글을 교수자가 판별 후 해제하는 방식으로 운영 
					vm.Board.ParticipationAcceptYesNo = "Y";
					if (vm.MasterNo.Equals(8) && vm.IsProf == 1) // 8 : CourseQA(강의Q&A)
					{
						vm.Board.ProfessorNo = (int)sessionManager.UserNo;
					}

					Hashtable htBoard = new Hashtable();
					htBoard.Add("MasterNo", vm.MasterNo);
					vm.Board.Thread = baseSvc.Get<Board>("board.BOARD_SELECT_B", htBoard).Thread + 1000;
					vm.Board.DeleteYesNo = vm.Board.DeleteYesNo ?? "N";
					baseSvc.Save<Board>("board.BOARD_SAVE_C", vm.Board);
				}
				else if (vm.Board.RowState == "U")
				{
					baseSvc.Save<Board>("board.BOARD_SAVE_U", vm.Board);
				}
				else if (vm.Board.RowState == "R") //답글로 연결
				{
					//게시물 조회
					Hashtable htParentBoard = new Hashtable();
					htParentBoard.Add("BoardNo", vm.ParentBoardNo);
					Board parentEntity = baseSvc.Get<Board>("board.BOARD_SELECT_S", htParentBoard);

					vm.Board.DeleteYesNo = vm.Board.DeleteYesNo ?? "N";
					vm.Board.HighestFixYesNo = vm.Board.HighestFixYesNo ?? "N";
					vm.Board.Depth = parentEntity.Depth + 1;
					vm.Board.Thread = parentEntity.Thread - 1;
					long prevThread = (parentEntity.Thread - 1) / 1000 * 1000;

					int rsCount = 0;

					DaoFactory.Instance.BeginTransaction();
					try
					{
						Hashtable htThread = new Hashtable();
						htThread.Add("ParentThread", parentEntity.Thread);
						htThread.Add("PrevThread", prevThread);
						rsCount += baseSvc.Save("board.BOARD_SAVE_F", htThread); //하위 게시물 THREAD UPDATE
						vm.Board.RowState = "C"; //RowState를 R에서 C로 변경
						rsCount += baseSvc.Save<Board>("board.BOARD_SAVE_C", vm.Board);
						
						DaoFactory.Instance.CommitTransaction();
					}
					catch (Exception)
					{
						rsCount = 0;
						DaoFactory.Instance.RollBackTransaction();
					}
				}

				vm.Board = null;
				
				return RedirectToAction("List", new { param1 = vm.CourseNo ?? 0, param2 = vm.MasterNo });
			}
			else //파일 저장 실패시
			{
				if ("C" == vm.Board.RowState)
				{
					return RedirectToAction("Write", new { param1 = vm.CourseNo ?? 0, param2 = vm.MasterNo, param3 = "C", fileSuccess = 1 });
				}
				else if ("U" == vm.Board.RowState)
				{
					return RedirectToAction("Write", new { param1 = vm.CourseNo ?? 0, param2 = vm.MasterNo, param3 = "C", fileSuccess = 1 });
				}
				else
				{
					return RedirectToAction("List", new { param1 = vm.CourseNo ?? 0, param2 = vm.MasterNo });
				}
			}
		}
		
		//게시물 삭제 -> json 변경
		//[Route("Delete")]
		//public void Delete(int? param1, int? param2, int? param3)
		//{
		//	long boardNo = param3 ?? 0;
		//	if (boardNo > 0)
		//	{
		//		Hashtable htBoard = new Hashtable();
		//		htBoard.Add("BoardNo", boardNo);
		//		htBoard.Add("InquiryUserNo", ViewBag.User.UserNo);
		//		baseSvc.Save("board.BOARD_SAVE_D", htBoard);

		//		Response.Redirect(string.Format("/Board/List/{0}/{1}", param1, param2));
		//	}
		//}

		//댓글 등록
		[Route("ReplyCreate")]
		public ActionResult ReplyCreate(BoardViewModel vm)
		{
			if (!string.IsNullOrEmpty(vm.ReplyContent))
			{
				BoardReply replyCont = new BoardReply()
				{
					Contents = vm.ReplyContent,
					CreateUserNo = 1,
					DeleteYesNo = "N",
					UpdateUserNo = 1,
					BoardNo = vm.Board.BoardNo
				};

				baseSvc.Save<BoardReply>("board.BOARD_REPLY_SAVE_C", replyCont);
			}

			return RedirectToAction("Detail", new { param1 = vm.CourseNo, param2 = vm.MasterNo, param3 = vm.Board.BoardNo });
		}

		[AuthorFilter(IsMember = true)]
		[Route("ListAdmin/{param1}/{param2}")]
		public ActionResult ListAdmin(StatisticsViewModel vm, int param1, int param2)
		{
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 학기 바인딩
			vm.Term = new Term();
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term()).Where(c => DateTime.ParseExact(c.TermStartDay, "yyyy-MM-dd", null) <= DateTime.Now).OrderByDescending(c => c.SortNo).ToList();

			vm.TermNo = vm.TermNo > 0 ? vm.TermNo : baseSvc.Get<int>("term.TERM_SELECT_C", new Term());

			// 조회
			Hashtable paramForList = new Hashtable();
			paramForList.Add("TermNo", vm.TermNo);
			paramForList.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramForList.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_BOARD_SELECT_L", paramForList);

			vm.PageTotalCount = vm.StatisticsList.FirstOrDefault() != null ? vm.StatisticsList.FirstOrDefault().TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "TermNo", vm.TermNo }, { "PageRowsize", vm.PageRowSize } };

			return View(vm);
		}

		#region 게시물등록현황 엑셀다운로드

		[Route("ListAdminExcel/{param1}/{param2}")]
		public ActionResult ListAdminExcel(StatisticsViewModel vm, int param1, int param2)
		{
			Hashtable paramForList = new Hashtable();
			paramForList.Add("TermNo", vm.TermNo);
			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_BOARD_SELECT_L", paramForList);
			
			System.Text.StringBuilder sbResponseString = new System.Text.StringBuilder();

			sbResponseString.Append("<html xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns=\"http://www.w3.org/TR/REC-html40\">");
			sbResponseString.Append("<head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\"><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>게시물등록현황통계</x:Name><x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head> <body>");
			sbResponseString.Append("<table><tr><td>게시물등록현황 통계</td></tr></table>");
			sbResponseString.Append("<table>");
			sbResponseString.Append("<tr>");
			sbResponseString.Append("<td>" + WebConfigurationManager.AppSettings["SubjectText"].ToString() + "</td>");

			if (vm.UnivYN().Equals("Y"))
			{
				sbResponseString.Append("<td>분반</td>");
				sbResponseString.Append("<td>학점</td>");
				sbResponseString.Append("<td>시간</td>");
				sbResponseString.Append("<td>학과</td>");
				sbResponseString.Append("<td>강의형태</td>");
			}

			sbResponseString.Append("<td>담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString() + "</td>");
			sbResponseString.Append("<td>공지사항</td>");
			sbResponseString.Append("<td>강의Q&A/답변</td>");
			sbResponseString.Append("<td>강의자료</td>");
			sbResponseString.Append("<td>1:1상담/답변</td>");
			sbResponseString.Append("</tr>");

			foreach (var item in vm.StatisticsList)
			{
				sbResponseString.Append("<tr>");
				sbResponseString.Append("<td>" + item.SubjectName + "</td>");

				if (vm.UnivYN().Equals("Y"))
				{
					sbResponseString.Append("<td>" + item.ClassNo + "</td>");
					sbResponseString.Append("<td>" + item.Credit + "</td>");
					sbResponseString.Append("<td>" + item.LecTime + "</td>");
					sbResponseString.Append("<td>" + item.AssignName + "</td>");
					sbResponseString.Append("<td>" + item.StudyTypeName + "</td>");
				}

				sbResponseString.Append("<td>" + item.ProNameList + "</td>");
				sbResponseString.Append("<td style='text-align:center;mso-number-format:\\@;'>" + item.NCount + "</td>");
				sbResponseString.Append("<td style='text-align:center;mso-number-format:\\@;'>" + item.QACount + "중(" + item.ReQACount + ")</td>");
				sbResponseString.Append("<td style='text-align:center;mso-number-format:\\@;'>" + item.FileCount + "</td>");
				sbResponseString.Append("<td style='text-align:center;mso-number-format:\\@;'>" + item.OneCount + "/" + item.ReOneCount + "</td>");
				sbResponseString.Append("</tr>");
			}

			sbResponseString.Append("</table></body></html>");

			Response.Clear();
			Response.AppendHeader("Content-Type", "application/vnd.ms-excel");
			Response.AppendHeader("Content-disposition", "attachment; filename=" + HttpUtility.UrlEncode(string.Format(WebConfigurationManager.AppSettings["ProfIDText"].ToString() + "메뉴 활동현황통계" + ".xls"), Encoding.UTF8));
			Response.Charset = "utf-8";
			Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");

			Response.Write(sbResponseString.ToString());
			Response.Flush();
			Response.End();

			return null;

		}
		
		#endregion 게시물 등록현황 엑셀다운로드

		#region JsonResult

		//게시물 좋아요, 궁금해요
		public JsonResult EventChange(string paramRowState, int paramBoardNo, string paramEventCode)
		{
			Hashtable htEvent = new Hashtable();
			htEvent.Add("RowState", paramRowState);
			htEvent.Add("BoardNo", paramBoardNo);
			htEvent.Add("UserNo", (int)sessionManager.UserNo);
			htEvent.Add("EventCode", paramEventCode);

			int rs = baseSvc.Save("board.BOARD_EVENT_SAVE", htEvent);

			return this.Json(rs);
		}

		//게시물 참여도 반영 수정
		public JsonResult SetParticipationAcceptYesNo(int paramBoardNo, string paramYesNo)
		{
			Hashtable htBoard = new Hashtable();
			htBoard.Add("BoardNo", paramBoardNo);
			htBoard.Add("InquiryUserNo", (int)sessionManager.UserNo);
			htBoard.Add("ParticipationAcceptYesNo", paramYesNo);

			int rs = baseSvc.Save("board.BOARD_SAVE_E", htBoard);

			return this.Json(rs);
		}

		//댓글 참여도 반영 수정
		public JsonResult SetReplyParticipationAcceptYesNo(int paramReplyNo, string paramYesNo)
		{
			Hashtable htReply = new Hashtable();
			htReply.Add("ReplyNo", paramReplyNo);
			htReply.Add("ParticipationAcceptYesNo", paramYesNo);
			htReply.Add("UpadateUserNo", (int)sessionManager.UserNo);

			int rs = baseSvc.Save("board.BOARD_REPLY_SAVE_A", htReply);

			return this.Json(rs);
		}

		//댓글 정답채택
		public JsonResult ReplyAnswerUpdate(int paramReplyNo, string paramYesNo)
		{
			Hashtable htReply = new Hashtable();
			htReply.Add("ReplyNo", paramReplyNo);
			htReply.Add("AnswerYesNo", paramYesNo);
			htReply.Add("UpadateUserNo", (int)sessionManager.UserNo);

			int rs = baseSvc.Save("board.BOARD_REPLY_SAVE_B", htReply);

			return this.Json(rs);
		}

		//댓글수정
		public JsonResult ReplyUpdate(int paramReplyNo, string paramContent)
		{
			int rs = 0;
			Hashtable htReply = new Hashtable();
			htReply.Add("ReplyNo", paramReplyNo);

			BoardReply replyEntity = baseSvc.Get<BoardReply>("board.BOARD_REPLY_SELECT_S", htReply);
			if (replyEntity.CreateUserNo == (int)sessionManager.UserNo)
			{
				replyEntity.ReplyNo = paramReplyNo;
				replyEntity.Contents = paramContent;
				replyEntity.UpdateUserNo = (int)sessionManager.UserNo;
				rs = baseSvc.Save("board.BOARD_REPLY_SAVE_U", replyEntity);
			}
			return this.Json(rs);

		}

		//댓글삭제
		public JsonResult ReplyDelete(int paramReplyNo)
		{
			int rs = 0;
			Hashtable htReply = new Hashtable();
			htReply.Add("ReplyNo", paramReplyNo);

			BoardReply replyEntity = baseSvc.Get<BoardReply>("board.BOARD_REPLY_SELECT_S", htReply);

			if (replyEntity.CreateUserNo == (int)sessionManager.UserNo)
			{
				replyEntity.ReplyNo = paramReplyNo;
				replyEntity.DeleteYesNo = "Y";
				replyEntity.UpdateUserNo = (int)sessionManager.UserNo;
				rs = baseSvc.Save("board.BOARD_REPLY_SAVE_D", replyEntity);
			}
			return this.Json(rs);
		}

		//글 삭제
		public JsonResult Delete(int? param1, int? param2, int? param3)
		{
			int rs = 0;
			long boardNo = param3 ?? 0;
			if (boardNo > 0)
			{
				Hashtable htBoard = new Hashtable();
				htBoard.Add("BoardNo", boardNo);
				htBoard.Add("InquiryUserNo", sessionManager.UserNo);
				rs = baseSvc.Save("board.BOARD_SAVE_D", htBoard);

			}
			return this.Json(rs);
		}

		#endregion JsonResult

	}
}