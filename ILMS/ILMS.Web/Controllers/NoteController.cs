using System;
using System.Collections;
using System.Linq;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;
using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("Note")]
	public class NoteController : WebBaseController
	{
		[Route("ReceiveList")]
		public ActionResult ReceiveList(NoteViewModel vm)
		{
			//페이징
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			//받은 쪽지함 리스트 조회
			Hashtable paramForReceiveList = new Hashtable();
			paramForReceiveList.Add("ReceiveUserNo", sessionManager.UserNo);
			paramForReceiveList.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramForReceiveList.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));

			vm.NoteList = baseSvc.GetList<Note>("note.NOTE_SELECT_L", paramForReceiveList);

			
			//쪽지수 조회
			Hashtable paramForCount = new Hashtable();
			paramForCount.Add("ReceiveUserNo", sessionManager.UserNo);
			vm.Note = baseSvc.Get<Note>("note.NOTE_SELECT_B", paramForCount);

			vm.PageTotalCount = vm.NoteList.FirstOrDefault() != null ? vm.NoteList.FirstOrDefault().TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize } };
			return View(vm);

		}

		[Route("SendList")]
		public ActionResult SendList(NoteViewModel vm)
		{
			//페이징
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			//보낸 쪽지함 리스트 조회
			Hashtable paramForSendList = new Hashtable();
			paramForSendList.Add("SendUserNo", sessionManager.UserNo);
			paramForSendList.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramForSendList.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));

			vm.NoteList = baseSvc.GetList<Note>("note.NOTE_SELECT_A", paramForSendList);

			//쪽지수 조회
			Hashtable paramForCount = new Hashtable();
			paramForCount.Add("SendUserNo", sessionManager.UserNo);
			vm.Note = baseSvc.Get<Note>("note.NOTE_SELECT_C", paramForCount);

			vm.PageTotalCount = vm.NoteList.FirstOrDefault() != null ? vm.NoteList.FirstOrDefault().TotalCount : 0;
			vm.Dic = new RouteValueDictionary {{ "pagerowsize", vm.PageRowSize }};
			return View(vm);

		}

		[Route("Detail/{param1}/{param2}")]
		[Route("Detail/{param1}/{param2}/{param3}/{param3}")]
		public ActionResult Detail(NoteViewModel vm, int param1, string param2, int? param3, int? param4)
		{
			vm.Note = new Note();

			vm.Note.NoteNo = param1;
			vm.NoteGubun = param2;
			vm.PageNum = param3 ?? 1;
			vm.PageRowSize = param4 ?? 10;

			if (param2 == "R")
			{
				//쪽지 확인 시간
				Hashtable paramForTime = new Hashtable();
				paramForTime.Add("NoteNo", param1);
				vm.Note = baseSvc.Get<Note>("note.NOTE_SAVE_U", paramForTime);
			}

			//쪽지 내용 조회
			Hashtable paramForDetail = new Hashtable();
			paramForDetail.Add("NoteNo", param1);
			vm.Note = baseSvc.Get<Note>("note.NOTE_SELECT_D", paramForDetail);

			File file = new File();
			//file.RowState = "L";
			file.FileGroupNo = vm.Note.FileGroupNo ?? 0;

			if (vm.Note.FileGroupNo != null)
			{
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
			}
			else {
				vm.FileList = null;
			}

			return View(vm);
		}

		[Route("Write/{param1}/{param2}")]
		public ActionResult Write(NoteViewModel vm, string param1, int? param2)
		{
			vm.Note = new Note();

			if (param2 != null)
			{
				vm.NoteGubun = param1;

				//답장 조회
				Hashtable paramForReply = new Hashtable();
				paramForReply.Add("NoteNo", param2);

				vm.Note = baseSvc.Get<Note>("note.NOTE_SELECT_D", paramForReply);
			}
			
			//수신대상 공통코드 구분
			Code code = new Code();
			code.ClassCode = "NTTG";

			if (sessionManager.UserType == "USRT001")
			{
				// 학부생일 경우
				vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(x => x.CodeValue.Equals("NTTG001") || x.CodeValue.Equals("NTTG003")).ToList();
			}
			else if (sessionManager.UserType == "USRT007" || sessionManager.UserType == "USRT009" || (sessionManager.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N")))
			{
				//교원, 직원일 경우
				vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(x => x.CodeValue.Equals("NTTG001") || x.CodeValue.Equals("NTTG002") || x.CodeValue.Equals("NTTG003")).ToList();
			}
			else if (sessionManager.UserType == "USRT010" || sessionManager.UserType == "USRT011" || (sessionManager.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y")))
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

						
			return View(vm);
		}
		
		[HttpPost]
		public JsonResult SubjectList(NoteViewModel vm, int? param1, string param2)
		{
			// param1 : TermNo
			// param2 : targetVal

			JsonResult returnJsonResult = new JsonResult();

			if (sessionManager.UserType == "USRT001")
			{
				//학생 권한 - 과목 교수
				Course paramForProList = new Course();
				paramForProList.TermNo = param1 ?? 0;
				paramForProList.UserNo = sessionManager.UserNo;

				vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_D", paramForProList);
			}
			else if (sessionManager.UserType == "USRT007" || sessionManager.UserType == "USRT009" || (sessionManager.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N")))
			{
				if (param2.Equals("NTTG002")) {
					//교수 권한 - 과목 학생
					Course paramForStudList = new Course();
					paramForStudList.TermNo = param1 ?? 0;
					paramForStudList.UserNo = sessionManager.UserNo;

					vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_C", paramForStudList);
				}
				else if (param2.Equals("NTTG003")) {
					//교수 권한 - 과목 교수
					Course paramForProList = new Course();
					paramForProList.TermNo = param1 ?? 0;
					paramForProList.UserNo = sessionManager.UserNo;

					vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_D", paramForProList);
				}
			}
			else if (sessionManager.UserType == "USRT010" || sessionManager.UserType == "USRT011" || (sessionManager.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y")))
			{
				//관리자 권한 - 과목 학생, 과목 교수
				Course paramForAllList = new Course();
				paramForAllList.TermNo = param1 ?? 0;
				vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_E", paramForAllList);
			}

			returnJsonResult = Json(vm.CourseList);
			returnJsonResult.MaxJsonLength = 2000000000;

			return returnJsonResult;
		}
		
		public void CommonSend(NoteViewModel vm, string param1, int? param2, int? param3)
		{
			if (param1.Equals("NTTG001"))
			{
				string[] userID = vm.Note.UserID.Split(',');

				foreach (var item in userID)
				{
					// 학생, 교직원 로그인 시 개인에게 발송
					Note memberList = new Note( vm.Note.NoteTitle
											  , vm.Note.NoteContents
											  , Convert.ToInt64(item)
											  , sessionManager.UserNo
											  , vm.Note.FileGroupNo);

					baseSvc.Save("note.NOTE_SAVE_C", memberList);
				}


			}
			else if (param1.Equals("NTTG003"))
			{
				//학생, 교직원 로그인 시 과목 교수 조회
				Course paramForStaffList = new Course();
				paramForStaffList.TermNo = param2 ?? 0;
				paramForStaffList.UserNo = sessionManager.UserNo;
				paramForStaffList.SubjectNo = param3 ?? 0;

				vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_D", paramForStaffList);

				Note memberList = new Note(vm.Note.NoteTitle
										 , vm.Note.NoteContents
										 , vm.Course.ProfessorNo
										 , sessionManager.UserNo
										 , vm.Note.FileGroupNo);

				baseSvc.Save("note.NOTE_SAVE_C", memberList);
			}
		}

		[HttpPost]
		[Route("Save/{param1}/{param2}/{param3}")]
		public ActionResult Save(NoteViewModel vm, string param1, int? param2, int? param3)
		{
			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long? fileGroupNo = 0;

			#region 파일관련

			int fileCnt = 0;
			for (int i = 0; i < Request.Files.Count; i++)
			{
				if (Request.Files[i].ContentLength != 0)
					fileCnt++;
			}

			if (fileCnt > 0)
			{
				fileGroupNo = FileUpload(vm.Note.RowState ?? "C", "Message", vm.Note.FileGroupNo, "MessageFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}
			
			#endregion 파일관련

			#region 쪽지 전송
			// param1 : targetVal
			// param2 : termNo
			// param3 : courseNo
			
			if (fileSuccess) //파일 업로드 성공 시 게시물을 저장함
			{
				vm.Note.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo;
				
				if (sessionManager.UserType == "USRT001")
				{
					CommonSend(vm, param1, param2, param3);
				}
				else if (sessionManager.UserType == "USRT007" || sessionManager.UserType == "USRT009" || (sessionManager.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N")))
				{
					CommonSend(vm, param1, param2, param3);
					
					//교수 로그인 시 과목 수강생 조회
					if (param1.Equals("NTTG002"))
					{
						Hashtable paramForStudList = new Hashtable();
						paramForStudList.Add("SendUserNo", sessionManager.UserNo);
						paramForStudList.Add("TermNo", param2);
						paramForStudList.Add("CourseNo", param3);
						vm.NoteList = baseSvc.GetList<Note>("note.NOTE_SELECT_G", paramForStudList);

						foreach (var user in vm.NoteList)
						{
							Note memberList = new Note(vm.Note.NoteTitle
													 , vm.Note.NoteContents
													 , user.ReceiveUserNo
													 , sessionManager.UserNo
													 , vm.Note.FileGroupNo);

							baseSvc.Save("note.NOTE_SAVE_C", memberList);
						}
					}
				}
				else if (sessionManager.UserType == "USRT010" || sessionManager.UserType == "USRT011" || (sessionManager.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y")))
				{
					if (param1.Equals("NTTG001"))
					{
						string[] userID = vm.Note.UserID.Split(',');

						foreach (var item in userID) {
							// 관리자 로그인 시 개인에게 발송
							Note memberList = new Note(vm.Note.NoteTitle
													 , vm.Note.NoteContents
													 , Convert.ToInt64(item)
													 , sessionManager.UserNo
													 , vm.Note.FileGroupNo);
							
							baseSvc.Save("note.NOTE_SAVE_C", memberList);
						}
					}
					else if (param1.Equals("NTTG002"))
					{
						//관리자 로그인 시 과목 수강생 조회
						Hashtable StudList = new Hashtable();
						StudList.Add("TermNo", param2);
						StudList.Add("CourseNo", param3);
						vm.NoteList = baseSvc.GetList<Note>("note.NOTE_SELECT_H", StudList);

						foreach (var user in vm.NoteList)
						{
							Note memberList = new Note(vm.Note.NoteTitle
													 , vm.Note.NoteContents
													 , user.ReceiveUserNo
													 , sessionManager.UserNo
													 , vm.Note.FileGroupNo);

							baseSvc.Save("note.NOTE_SAVE_C", memberList);
						}
					}
					else if (param1.Equals("NTTG003"))
					{
						//관리자 로그인 시 과목 교수 조회
						Hashtable StaffList = new Hashtable();
						StaffList.Add("TermNo", param2);
						StaffList.Add("CourseNo", param3);
						vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_E", StaffList);

						foreach (var user in vm.CourseList)
						{
							Note memberList = new Note(vm.Note.NoteTitle
													 , vm.Note.NoteContents
													 , user.ProfessorNo
													 , sessionManager.UserNo
													 , vm.Note.FileGroupNo);

							baseSvc.Save("note.NOTE_SAVE_C", memberList);
						}
					}
					else if (param1.Equals("NTTG004"))
					{
						//관리자 로그인 시 전체 학생 조회
						Hashtable allStudList = new Hashtable();
						vm.NoteList = baseSvc.GetList<Note>("note.NOTE_SELECT_E", allStudList);

						foreach (var user in vm.NoteList)
						{
							Note memberList = new Note(vm.Note.NoteTitle
													 , vm.Note.NoteContents
													 , user.ReceiveUserNo
													 , sessionManager.UserNo
													 , vm.Note.FileGroupNo);
					
							baseSvc.Save("note.NOTE_SAVE_C", memberList);
						}
					}
					else if (param1.Equals("NTTG005"))
					{
						//관리자 로그인 시 전체 교직원 조회
						Hashtable allStaffList = new Hashtable();
						vm.NoteList = baseSvc.GetList<Note>("note.NOTE_SELECT_F", allStaffList);

						foreach (var user in vm.NoteList)
						{
							Note memberList = new Note(vm.Note.NoteTitle
													 , vm.Note.NoteContents
													 , user.ReceiveUserNo
													 , sessionManager.UserNo
													 , vm.Note.FileGroupNo);
							
							baseSvc.Save("note.NOTE_SAVE_C", memberList);
						}
					}
				}
			}
			#endregion 쪽지 전송

			return RedirectToAction("SendList");
		}

		[HttpPost]
		public JsonResult Delete(string chkVal, string Rowstate)
		{
			string[] array = chkVal.Split(',');
			int cnt = 0;

			if (Rowstate == "R")
			{
				for (int i = 0; i < array.Length; i++)
				{
					//받은 쪽지 삭제
					Note receiveDelete = new Note("D", int.Parse(array[i]));
					cnt = baseSvc.Save("note.NOTE_SAVE_D", receiveDelete);
				}
			}

			if (Rowstate == "S")
			{
				for (int i = 0; i < array.Length; i++)
				{
					//보낸 쪽지 삭제
					Note sendDelete = new Note("A", int.Parse(array[i]));
					cnt = baseSvc.Save("note.NOTE_SAVE_A", sendDelete);
				}
			}

			return Json(cnt);
		}

		[Route("Write/{param1}/{param2}")]
		public ActionResult LayerNoteWrite(NoteViewModel vm)
		{
			vm.Note = new Note();

			//수신대상 공통코드 구분
			Code code = new Code();
			code.ClassCode = "NTTG";

			if (sessionManager.UserType == "USRT001")
			{
				// 학부생일 경우
				vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(x => x.CodeValue.Equals("NTTG001") || x.CodeValue.Equals("NTTG003")).ToList();
			}
			else if (sessionManager.UserType == "USRT007" || sessionManager.UserType == "USRT009" || (sessionManager.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N")))
			{
				//교원, 직원일 경우
				vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(x => x.CodeValue.Equals("NTTG001") || x.CodeValue.Equals("NTTG002") || x.CodeValue.Equals("NTTG003")).ToList();
			}
			else if (sessionManager.UserType == "USRT010" || sessionManager.UserType == "USRT011" || (sessionManager.UserType == "USRT012" && WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y")))
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

			return View(vm);
		}

		public JsonResult LayerNoteWriteSave(NoteViewModel vm)
		{
			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long? fileGroupNo = 0;

			int cnt = 0;

			#region 파일관련

			int fileCnt = 0;
			for (int i = 0; i < Request.Files.Count; i++)
			{
				if (Request.Files[i].ContentLength != 0)
					fileCnt++;
			}

			if (fileCnt > 0)
			{
				fileGroupNo = FileUpload(vm.Note.RowState ?? "C", "Message", vm.Note.FileGroupNo, "MessageFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}

			#endregion 파일관련

			#region 쪽지 전송

			if (fileSuccess) //파일 업로드 성공 시 게시물을 저장함
			{
				vm.Note.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo;

				string[] userID = vm.Note.UserID.Split(',');

				foreach (var item in userID)
				{
					// 관리자 로그인 시 개인에게 발송
					Note memberList = new Note(vm.Note.NoteTitle
											 , vm.Note.NoteContents
											 , Convert.ToInt64(item)
											 , sessionManager.UserNo
											 , vm.Note.FileGroupNo);

					cnt += baseSvc.Save("note.NOTE_SAVE_C", memberList);
				}
			}

			#endregion 쪽지 전송

			return Json(cnt);
		}

	}

}