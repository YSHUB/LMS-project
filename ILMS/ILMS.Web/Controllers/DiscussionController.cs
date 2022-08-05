using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("Discussion")]
	public class DiscussionController : LectureRoomBaseController
	{
		public DiscussionService discussionSvc { get; set; }

		#region 토론 목록

		[Route("List/{param1}")]
		public ActionResult List(int param1)
		{
			//param1 : CourseNo 강좌번호
			DiscussionViewModel vm = new DiscussionViewModel();

			// 토론 리스트 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			vm.DiscussionList = baseSvc.GetList<Discussion>("discussion.DISCUSSION_SELECT_L", paramHash);

			return View(vm);
		}

		[HttpPost]
		[Route("ParticipationMemberList")]
		public JsonResult ParticipationMemberList(int courseNo, Int64 discussionNo)
		{
			// 토론 참여자 조회 (참여자 정보)
			DiscussionOpinion paramDiscussionOpinion = new DiscussionOpinion();
			paramDiscussionOpinion.CourseNo = courseNo;
			paramDiscussionOpinion.DiscussionNo = discussionNo;
			List<DiscussionOpinion> DiscussionOpinionList = baseSvc.GetList<DiscussionOpinion>("discussion.DISCUSSION_OPINION_SELECT_A", paramDiscussionOpinion).ToList();

			return Json(DiscussionOpinionList);
		}

		#endregion 토론 목록

		#region 토론 등록

		[Route("Write/{param1}")]
		[Route("Write/{param1}/{param2}")]
		public ActionResult Write(int param1, Int64? param2)
		{
			//param1 : CourseNo 강좌번호, param2 : DiscussionNo 토론번호
			DiscussionViewModel vm = new DiscussionViewModel();

			// 공통코드 (조별/개별토론)
			Code code = new Code("A");
			code.ClassCode = "CDAB";
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			// 팀편성 그룹 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", param1);
			paramHash.Add("DeleteYesNo", "N");
			vm.GroupList = baseSvc.GetList<Group>("team.GROUP_SELECT_L", paramHash);

			// 토론 수정 조회
			if (param2 != null)
			{
				Discussion paramDiscussion = new Discussion(param1, param2);
				vm.Discussion = baseSvc.Get<Discussion>("discussion.DISCUSSION_SELECT_S", paramDiscussion);

				if (vm.Discussion.FileGroupNo > 0)
				{
					File file = new File();
					file.RowState = "L";
					file.FileGroupNo = vm.Discussion.FileGroupNo ?? 0;
					if (vm.Discussion.FileGroupNo != null)
						vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					else
						vm.FileList = null;
				}
			}

			return View(vm);
		}

		[HttpPost]
		[Route("Write/{param1}")]
		public ActionResult Write(DiscussionViewModel vm)
		{

			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long? fileGroupNo = 0;

			#region "파일관련"
			if (Request.Files.Count > 1)
			{
				fileGroupNo = FileUpload(vm.Discussion.RowState ?? "C", "CourseDiscussion", vm.Discussion.FileGroupNo, "DiscussionFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}
			#endregion "파일관련"

			if (fileSuccess)
			{
				// 파일 업로드 성공 시 게시물 저장
				vm.Discussion.CreateUserNo = sessionManager.UserNo;
				vm.Discussion.UpdateUserNo = sessionManager.UserNo;
				vm.Discussion.DeleteYesNo = "N";
				vm.Discussion.OpenYesNo = vm.Discussion.DiscussionAttribute.Equals("CDAB001") ? "Y" : ((vm.Discussion.OpenYesNo ?? "N").Equals("on")) ? "Y" : "N";
				vm.Discussion.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo;

				if (vm.Discussion.DiscussionNo.Equals(0)) // 토론등록
				{
					discussionSvc.DiscussionInsert(vm.Discussion);
				}
				else // 토론 수정
				{
					discussionSvc.DiscussionUpdate(vm.Discussion);
				}
			}
			return RedirectToAction("List", new { param1 = vm.Discussion.CourseNo });
		}

		#endregion 토론 등록

		#region 토론 상세보기

		[Route("Detail/{param1}/{param2}")]
		[Route("Detail/{param1}/{param2}/{param3}")]
		public ActionResult Detail(int param1, Int64 param2, Int64? param3)
		{
			//param1 : CourseNo 강좌번호, param2 : DiscussionNo 토론번호, param3 : TeamNo 팀번호
			DiscussionViewModel vm = new DiscussionViewModel();
			vm.TeamNo = 0;

			// 토론 상세보기
			Discussion paramDiscussion = new Discussion(param1, param2);
			vm.Discussion = baseSvc.Get<Discussion>("discussion.DISCUSSION_SELECT_S", paramDiscussion);

			// 토론 첨부파일 조회
			File file = new File();
			file.RowState = "L";
			file.FileGroupNo = vm.Discussion.FileGroupNo ?? 0;
			if (vm.Discussion.FileGroupNo != null)
			{
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
			}
			else
			{ 
				vm.FileList = null;
			}

			// 조별토론 팀 리스트 및 의견 수 조회
			if (vm.Discussion.DiscussionAttribute.Equals("CDAB002"))
			{
				Hashtable paramHash2 = new Hashtable();
				paramHash2.Add("CourseNo", param1);
				paramHash2.Add("DiscussionNo", param2);
				paramHash2.Add("GroupNo", vm.Discussion.GroupNo);
				paramHash2.Add("UserNo", sessionManager.UserNo);
				vm.DiscussionGroupList = baseSvc.GetList<DiscussionGroup>("discussion.DISCUSSION_OPINION_SELECT_B", paramHash2);

				vm.TeamNo = param3 ?? vm.DiscussionGroupList.FirstOrDefault().TeamNo;
				// 로그인 유저의 조별 확인 (IsMember Y/N)
				paramHash2.Add("TeamNo", vm.TeamNo);
				vm.DiscussionGroup = baseSvc.Get<DiscussionGroup>("discussion.DISCUSSION_OPINION_SELECT_B", paramHash2);

			}

			// 토론 의견조회
			Hashtable paramHash3 = new Hashtable();
			paramHash3.Add("CourseNo", param1);
			paramHash3.Add("DiscussionNo", param2);
			paramHash3.Add("TeamNo", vm.TeamNo);
			paramHash3.Add("UserNo", sessionManager.UserNo);
			vm.DiscussionOpinionList = baseSvc.GetList<DiscussionOpinion>("discussion.DISCUSSION_OPINION_SELECT_L", paramHash3);

			return View(vm);
		}

		[HttpPost]
		[Route("Detail")]
		[Route("Detail/{param1}/{param2}")]
		public ActionResult Detail(DiscussionViewModel vm)
		{
			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long? fileGroupNo = 0;

			#region "파일관련"
			if (Request.Files.Count > 1)
			{
				fileGroupNo = FileUpload(vm.DiscussionOpinion.RowState ?? "C", "CourseDiscussionOpinion", vm.DiscussionOpinion.FileGroupNo, "DiscussionOpinionFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}
			#endregion "파일관련"

			if (fileSuccess)
			{
				vm.DiscussionOpinion.TeamNo = vm.TeamNo;
				vm.DiscussionOpinion.OpinionUserNo = sessionManager.UserNo;
				vm.DiscussionOpinion.CreateUserNo = sessionManager.UserNo;
				vm.DiscussionOpinion.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo;

				baseSvc.Save("discussion.DISCUSSION_OPINION_SAVE_C", vm.DiscussionOpinion);
			}
			return RedirectToAction("Detail", new { param1 = vm.DiscussionOpinion.CourseNo, param2 = Convert.ToInt32(vm.DiscussionOpinion.DiscussionNo) });
		}

		[HttpPost]
		[Route("OpinionTeamMemberList")]
		public JsonResult OpinionTeamMemberList(Int64 groupNo, Int64 teamNo)
		{
			DiscussionViewModel vm = new DiscussionViewModel();
			// 팀원 조회
			Hashtable paramHash = new Hashtable();
			paramHash.Add("GroupNo", groupNo);
			paramHash.Add("TeamNo", teamNo);

			vm.DiscussionGroupList = baseSvc.GetList<DiscussionGroup>("discussion.DISCUSSION_OPINION_SELECT_C", paramHash);

			return Json(vm.DiscussionGroupList);
		}

		[HttpPost]
		[Route("ParticipationYesNo")]
		public JsonResult ParticipationYesNo(string opinionNo, string yesNo)
		{
			DiscussionViewModel vm = new DiscussionViewModel();

			string[] strOpinionNo = opinionNo.ToString().Substring(1).Split('|');

			int cnt = 0;

			for (int i = 0; i < strOpinionNo.Count(); i++)
			{
				// 토론 참여도 점수 인정/취소
				Hashtable paramHash = new Hashtable();
				paramHash.Add("ParticipationYesNo", yesNo);
				paramHash.Add("UpdateUserNo", sessionManager.UserNo);
				paramHash.Add("OpinionNo", strOpinionNo[i]);
				cnt += baseSvc.Save("discussion.DISCUSSION_OPINION_SAVE_A", paramHash);
			}

			return Json(cnt);
			
		}

		[HttpPost]
		[Route("OpinionYesNo")]
		public JsonResult OpinionYesNo(Int64 opinionNo, string yesNo)
		{
			// 토론 의견 좋아요/싫어요
			DiscussionViewModel vm = new DiscussionViewModel();

			Hashtable paramHash = new Hashtable();
			paramHash.Add("OpinionNo", opinionNo);
			paramHash.Add("YesNoCode", yesNo);
			paramHash.Add("YesNoUserNo", sessionManager.UserNo);
			
			string msg = baseSvc.Get<string>("discussion.DISCUSSION_OPINION_YESNO_SAVE_C", paramHash);

			return Json(msg);
		}

		[HttpPost]
		[Route("Delete")]
		public JsonResult Delete(int courseNo, Int64 discussionNo)
		{
			// 토론 삭제
			Discussion paramDiscussion = new Discussion(courseNo, discussionNo);
			paramDiscussion.UpdateUserNo = sessionManager.UserNo;

			return Json(baseSvc.Save("discussion.DISCUSSION_SAVE_D", paramDiscussion));
		}

		#endregion 토론 상세보기

		#region 토론 의견 상세보기

		[Route("OpinionView/{param1}/{param2}/{param3}")]
		public ActionResult OpinionView(int param1, Int64 param2, Int64 param3)
		{
			//param1 : CourseNo 강좌번호, param2 : DiscussionNo 토론번호, param3 : OpinionNo 의견번호
			DiscussionViewModel vm = new DiscussionViewModel();

			// 토론 상세보기
			Discussion paramDiscussion = new Discussion(param1, param2);
			vm.Discussion = baseSvc.Get<Discussion>("discussion.DISCUSSION_SELECT_S", paramDiscussion);

			// 토론 첨부파일 조회
			File file = new File();
			file.RowState = "L";
			file.FileGroupNo = vm.Discussion.FileGroupNo ?? 0;
			if (vm.Discussion.FileGroupNo != null)
			{
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
			}
			else
			{
				vm.FileList = null;
			}

			// 토론 의견조회
			Hashtable paramHash2 = new Hashtable();
			paramHash2.Add("OpinionNo", param3);
			paramHash2.Add("UserNo", sessionManager.UserNo);
			vm.DiscussionOpinion = baseSvc.Get<DiscussionOpinion>("discussion.DISCUSSION_OPINION_SELECT_S", paramHash2);

			// 토론의견 첨부파일 조회
			file = new File();
			file.RowState = "L";
			file.FileGroupNo = vm.DiscussionOpinion.FileGroupNo ?? 0;
			if (vm.DiscussionOpinion.FileGroupNo != null)
			{
				vm.FileCopyList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
			}
			else
			{
				vm.FileCopyList = null;
			}

			// 토론 한줄의견 조회
			Hashtable paramHash3 = new Hashtable();
			paramHash3.Add("OpinionNo", param3);
			vm.DiscussionReplyList = baseSvc.GetList<DiscussionReply>("discussion.DISCUSSION_OPINION_REPLY_SELECT_L", paramHash3);

			// 이전글/다음글 조회
			Hashtable paramHash4 = new Hashtable();
			paramHash4.Add("CourseNo", param1);
			paramHash4.Add("DiscussionNo", param2);
			paramHash4.Add("OpinionNo", param3);
			vm.PrevNextList = baseSvc.GetList<DiscussionOpinion>("discussion.DISCUSSION_OPINION_SELECT_D", paramHash4);

			return View(vm);
		}

		[HttpPost]
		[Route("OpinionUpdate/{param1}/{param2}/{param3}")]
		public ActionResult OpinionUpdate(DiscussionViewModel vm)
		{
			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long? fileGroupNo = 0;

			#region "파일관련"
			if (Request.Files.Count > 1)
			{
				fileGroupNo = FileUpload(vm.DiscussionOpinion.RowState ?? "C", "CourseDiscussionOpinion", vm.DiscussionOpinion.FileGroupNo, "DiscussionOpinionFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}
			#endregion "파일관련"

			if (fileSuccess)
			{
				// 토론 의견 수정
				vm.DiscussionOpinion.OpinionUserNo = sessionManager.UserNo;
				vm.DiscussionOpinion.UpdateUserNo = sessionManager.UserNo;
				vm.DiscussionOpinion.TopOpinionYesNo = (vm.DiscussionOpinion.TopOpinionYesNo ?? "Y").Equals("on") ? "Y" : "N";
				vm.DiscussionOpinion.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo; //추후 수정
			}

			baseSvc.Save("discussion.DISCUSSION_OPINION_SAVE_U", vm.DiscussionOpinion);

			return RedirectToAction("OpinionView", new { param1 = vm.DiscussionOpinion.CourseNo, param2 = Convert.ToInt32(vm.DiscussionOpinion.DiscussionNo), param3 = vm.DiscussionOpinion.OpinionNo });
		}

		[HttpPost]
		[Route("OpinionReplySave/{param1}/{param2}/{param3}")]
		public ActionResult OpinionReplySave(DiscussionViewModel vm)
		{
			
			// 토론 한줄 의견 등록 및 수정
			if (vm.DiscussionReply.RowState.Equals("C"))
			{
				vm.DiscussionReply.OpinionNo = vm.DiscussionOpinion.OpinionNo;
				vm.DiscussionReply.ReplyUserNo = Convert.ToInt32(sessionManager.UserNo);
				vm.DiscussionReply.CreateUserNo = sessionManager.UserNo;

				baseSvc.Save("discussion.DISCUSSION_OPINION_REPLY_SAVE_C", vm.DiscussionReply);
			}
			else
			{
				vm.DiscussionReply.ReplyUserNo = Convert.ToInt32(sessionManager.UserNo);
				vm.DiscussionReply.UpdateUserNo = sessionManager.UserNo;
				vm.DiscussionReply.ReplyContents = vm.DiscussionReply.ReplyUpdateContents;

				baseSvc.Save("discussion.DISCUSSION_OPINION_REPLY_SAVE_U", vm.DiscussionReply);
			}

			return RedirectToAction("OpinionView", new { param1 = vm.DiscussionOpinion.CourseNo, param2 = Convert.ToInt32(vm.DiscussionOpinion.DiscussionNo), param3 = vm.DiscussionOpinion.OpinionNo });
		}

		[HttpPost]
		[Route("TopOpinionYesNo")]
		public JsonResult TopOpinionYesNo(string opinionNo, string yesNo)
		{
			// 공지사항 처리/취소
			Hashtable paramHash = new Hashtable();
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);
			paramHash.Add("TopOpinionYesNo", yesNo.Equals("Y") ? "N" : "Y");
			paramHash.Add("OpinionNo", opinionNo);
			int cnt = baseSvc.Save("discussion.DISCUSSION_OPINION_SAVE_B", paramHash);

			return Json(cnt);
		}

		[HttpPost]
		[Route("OpinionDelete")]
		public JsonResult OpinionDelete(Int64 opinionNo)
		{
			// 토론의견 삭제
			Hashtable paramHash = new Hashtable();
			paramHash.Add("OpinionNo", opinionNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);
			
			return Json(baseSvc.Save("discussion.DISCUSSION_OPINION_SAVE_D", paramHash));
		}

		[HttpPost]
		[Route("OpinionReplyDelete")]
		public JsonResult OpinionReplyDelete(Int64 replyNo)
		{
			// 토론 한 줄 의견 삭제
			Hashtable paramHash = new Hashtable();
			paramHash.Add("ReplyNo", replyNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);

			return Json(baseSvc.Save("discussion.DISCUSSION_OPINION_REPLY_SAVE_D", paramHash));
		}

		#endregion 토론 의견 상세보기

		#region 토론 관리자

		[AuthorFilter(IsAdmin = true)]
		[Route("ListAdmin/{param1}")]
		public ActionResult ListAdmin(DiscussionViewModel vm, int param1)
		{
			// param1 : ProgramNo 프로그램번호(1:정규과정, 2:MOOC)

			// 프로그램과정, 학기 조회
			vm.ProgramList = baseSvc.GetList<Discussion>("discussion.PROGRAM_SELECT_L", new Discussion("L"));
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L")).OrderByDescending(o => o.TermNo).ToList();

			// 페이징
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 토론 리스트 조회
			if (vm.Discussion == null)
			{
				vm.Discussion = new Discussion();
				//vm.Discussion.ProgramNo = param1;
				vm.Discussion.ProgramNo = vm.UnivYN().Equals("Y") ? param1 : 2;
				vm.Discussion.TermNo = Convert.ToInt32(Request.QueryString["TermNo"]);
			}

			string searchText = HttpUtility.UrlDecode(vm.SearchText);

			Discussion discussion = new Discussion();
			discussion.TermNo = vm.Discussion.TermNo > 0 ? vm.Discussion.TermNo : vm.TermList.Count > 0 ? vm.TermList[0].TermNo : 0;		
			discussion.ProgramNo = vm.Discussion.ProgramNo;		
			discussion.SubjectName = !string.IsNullOrEmpty(searchText) ? searchText : null;
			discussion.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			discussion.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;
			
			vm.DiscussionList = baseSvc.GetList<Discussion>("discussion.DISCUSSION_SELECT_A", discussion);
			vm.PageTotalCount = vm.DiscussionList.Count > 0 ? vm.DiscussionList[0].TotalCount : 0;
			if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Discussion.ProgramNo", discussion.ProgramNo }, { "Discussion.TermNo", discussion.TermNo }
												, { "SearchText", HttpUtility.UrlEncode(searchText) } };
			}
			else
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Discussion.TermNo", discussion.TermNo }, { "SearchText", HttpUtility.UrlEncode(searchText) } };
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

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("discussion.DISCUSSION_SELECT_B", hash);

			string[] headers;
			string[] columns;
			string excelFileName = "";

			if (WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				headers = new string[] { "과정", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "캠퍼스 / 분반", "강의형태", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "토론등록수" };
				columns = new string[] { "ProgramName", "SubjectName", "CampusName", "StudyTypeName", "ProfessorName", "DiscussionCnt" };

				excelFileName = String.Format("강의운영관리_토론관리_{1}_{0}", DateTime.Now.ToString("yyyyMMdd"), param1 == 1 ? "정규과정" : "MOOC");
			}
			else
			{
				headers = new string[] { WebConfigurationManager.AppSettings["SubjectText"].ToString(), "캠퍼스 / 분반", "강의형태", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "토론등록수" };
				columns = new string[] { "SubjectName", "CampusName", "StudyTypeName", "ProfessorName", "DiscussionCnt" };

				excelFileName = String.Format("강의운영관리_토론관리_{0}", DateTime.Now.ToString("yyyyMMdd"));
			}

			return ExportExcel(headers, columns, hashList, excelFileName); ;
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListDetail/{param1}")]
		public ActionResult DetailAdmin(DiscussionViewModel vm, int param1)
		{
			// param1 : CourseNo 강좌번호

			// 교과목 정보 조회
			Course course = new Course("S");
			course.CourseNo = param1;
			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", course);

			Discussion discussion = new Discussion();
			discussion.CourseNo = param1;

			vm.DiscussionList = baseSvc.GetList<Discussion>("discussion.DISCUSSION_SELECT_L", discussion);

			// 페이징
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			return View(vm);
		}

		[HttpPost]
		[Route("OpinionList")]
		public JsonResult OpinionList(int courseNo, Int64 discussionNo, string sortType)
		{
			DiscussionViewModel vm = new DiscussionViewModel();

			// 토론 참여자 리스트
			Hashtable paramHash = new Hashtable();

			DiscussionOpinion discussionOpinion = new DiscussionOpinion();
			discussionOpinion.CourseNo = courseNo;
			discussionOpinion.DiscussionNo = discussionNo;

			if (sortType == "UserID")
			{
				vm.DiscussionOpinionList = baseSvc.GetList<DiscussionOpinion>("discussion.DISCUSSION_OPINION_SELECT_A", discussionOpinion).OrderBy(x => x.UserID).ToList();
				vm.SortType = "HangulName";
			}
			else
			{
				vm.DiscussionOpinionList = baseSvc.GetList<DiscussionOpinion>("discussion.DISCUSSION_OPINION_SELECT_A", discussionOpinion).OrderBy(x => x.HangulName).ToList();
				vm.SortType = "UserID";
			}

			return Json(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult DetailAdminExcel(int param1)
		{
			// param1 : CourseNo 강좌번호

			// 엑셀다운로드
			Hashtable hash = new Hashtable();
			hash.Add("CourseNo", param1);

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("discussion.DISCUSSION_SELECT_C", hash);

			string[] headers = new string[] { "토론제목", "개설자", "참여글수", "토론기간", "상태" };
			string[] columns = new string[] { "DiscussionSubject", "CreateUserName", "OpinionCount", "DiscussionDay", "DiscussionSituation" };
			string excelFileName = String.Format("강의운영관리_토론관리_상세보기_{0}", DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, hashList, excelFileName);
		}

		#endregion 토론 관리자

	}


}