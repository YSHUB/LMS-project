using System.Web.Mvc;
using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System.Linq;
using System.Collections.Generic;
using System;
using System.Collections;
using System.Web.Routing;
using System.Web;
using System.Web.Configuration;
using System.Configuration;

namespace ILMS.Web.Controllers
{
    [AuthorFilter(IsMember = true)]
    [RoutePrefix("Homework")]
	public class HomeworkController : LectureRoomBaseController
	{
		public HomeworkService homeworkSvc{ get; set; }

        [Route("ListTeacher/{param1}")]
        public ActionResult ListTeacher(HomeworkViewModel vm)
        {
            //vm.id = 29565;
            Homework homework = new Homework("L");
			homework.CourseNo = ViewBag.Course.CourseNo;
            vm.HomeworkList = baseSvc.GetList<Homework>("homework.HOMEWORK_SELECT_L", homework);

            return View(vm);
        }

		[Route("Write/{param1}")]
		[Route("Write/{param1}/{param2}")]
		[Route("Write/{param1}/{param2}/{param3}")]
		public ActionResult Write(int param1, int? param2, int? param3)
		{
			int CourseNo = param1 > 0 ? param1 : 0; //강좌번호
			int isOutput = param2 ?? 0; //산출물여부
			int HomeworkNo = param3 ?? 0; //과제번호

			HomeworkViewModel vm = new HomeworkViewModel();
			
			Hashtable paramHash = new Hashtable();
			paramHash.Add("RowState", "L");
			paramHash.Add("CourseNo", param1);
			paramHash.Add("DeleteYesNo", "N");

			vm.GroupList = baseSvc.GetList<Group>("team.GROUP_SELECT_L", paramHash);
			vm.IsOutput = isOutput;
			vm.SubmitYesNo = false;
			vm.CourseNo = CourseNo;

			if (HomeworkNo > 0)
			{
				HomeworkSubmit homeworksubmit = new HomeworkSubmit("L");

				homeworksubmit.CourseNo = CourseNo;
				homeworksubmit.HomeworkNo = HomeworkNo;
				vm.HomeworkSubmitList = baseSvc.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit);

				Homework homework = new Homework();
				homework.HomeworkNo = HomeworkNo;
				vm.Homework = baseSvc.Get<Homework>("homework.HOMEWORK_SELECT_S", homework);

				if (vm.Homework == null)
				{
					Response.Redirect(string.Format("/Home/Index?InfoMessage={0}", "MSG_EREGULAR_PATH"));
				}
				else
				{
					vm.HomeworkType = vm.Homework.HomeworkType;
					vm.ExamKind = (vm.Homework.ExamKind != null) ? vm.Homework.ExamKind : "";

					foreach (var item in vm.HomeworkSubmitList)
					{
						vm.Homework.UserNoString = vm.Homework.UserNo.ToString() + "|" + item.UserNo.ToString();
						vm.Homework.UseYesNo = vm.Homework.UseYesNo + "|" + item.TargetYesNo;
					}
					if (vm.Homework.FileGroupNo > 0)
					{
						File file = new File();
						file.RowState = "L";
						file.FileGroupNo = vm.Homework.FileGroupNo ?? 0;
						if (vm.Homework.FileGroupNo != null)
							vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
						else
							vm.FileList = null;
					}
				}				

				for (int i = 0; i < vm.HomeworkSubmitList.Count; i++)
				{
					if (!string.IsNullOrEmpty(vm.HomeworkSubmitList[i].SubmitContents) || vm.HomeworkSubmitList[i].FileGroupNo > 0)
					{
						vm.SubmitYesNo = true;
						break;
					}
				}
			}		

			Inning week = new Inning("N");
			week.CourseNo = CourseNo;

			vm.WeekList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_N", week);
			if (vm.Homework != null)
			{
				Inning inning = new Inning("A");
				inning.CourseNo = CourseNo;

				inning.Week = vm.Homework.Week;

				vm.InningList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_A", inning);
			}
			else
			{
				vm.InningList = new List<Inning>();
				vm.Output = new Output();

				if (isOutput > 0)
				{
					//산출물의 경우 제일 빠른 주차-차시로 등록처리
					Inning output = new Inning("A");
					output.CourseNo = CourseNo;

					vm.InningList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_A", output);

					if (vm.InningList != null && vm.InningList.Count > 0)
					{
						vm.Output.Week = vm.InningList.FirstOrDefault().Week;
						vm.Output.InningNo = vm.InningList.FirstOrDefault().InningNo;
					}
					//else
					//{
					//	Response.Redirect(string.Format("/Home/Index?InfoMessage={0}", "MSG_EREGULAR_PATH"));
					//}
				}
				else
				{
					if (!string.IsNullOrEmpty(Request.QueryString["week"]))
					{
						Inning inning = new Inning("A");

						inning.CourseNo = CourseNo;
						inning.Week = Convert.ToInt32(Request.QueryString["week"].ToString());

						vm.InningList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_A", inning);
					}
				}
			}

			Code code = new Code("A", new string[] { "CHWK", "CHWT", "CHST", "CHEK" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			return View(vm);
		}

		[HttpPost]
		public ActionResult Write(HomeworkViewModel vm, int param1)
		{
			bool fileSuccess = true;

			//파일관련 Start------------------------------------------------------------------------------------
			string saveFolderName = DateTime.Now.ToString("yyyyMMdd");

			Hashtable htFileFolder = new Hashtable();
			htFileFolder.Add("RowState", "S");
			htFileFolder.Add("FolderName", "CourseHomework");
			string subFolderName = baseSvc.Get<FileFolder>("common.FILEFOLDER_SELECT_S", htFileFolder).FolderName;
			long? fileGroupNo = vm.FileGroupNo > 0 ? (long?)vm.FileGroupNo : null;
			fileGroupNo = SaveFile(Request.Files, "HomeworkFile", fileGroupNo, "CourseHomework");

			//업로드한 파일이 디렉토리에 저장되었는지 확인
			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fileGroupNo ?? 0);
			htFile.Add("DeleteYesNo", "N");

			vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", htFile);

			vm.Homework.RowState = vm.Homework.HomeworkNo == 0 ? "C" : "U";

			foreach (var item in vm.FileList)
			{
				if (!System.IO.File.Exists(Server.MapPath("/" + FileRootFolder + item.SaveFileName)))
				{
					fileSuccess = false;
					if ("C" == vm.Homework.RowState)
					{
						FileDeleteByGroup(fileGroupNo ?? 0);
						break; //등록의 경우 오류 방지를 위해 첨부파일 내 모든 파일을 삭제함
					}
					else
					{
						FileDelete(item.FileNo); //수정의 경우 기존 파일은 삭제되지 않도록 함
					}
				}
			}
			//파일관련 End------------------------------------------------------------------------------------   

			if (fileSuccess)
			{
				vm.Homework.CreateUserNo = sessionManager.UserNo;
				vm.Homework.DeleteYesNo = "N";
				vm.Homework.EstimationOpenYesNo = "N";
				vm.Homework.UpdateUserNo = sessionManager.UserNo;
				vm.Homework.AddSubmitPeriodUseYesNo = ((vm.Homework.AddSubmitPeriodUseYesNo ?? "Y").Equals("on")) ? "Y" : "N";

				vm.Homework.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo; //TODO 추후 수정
				if (vm.Homework.HomeworkNo == 0)
				{
					vm.Homework.EstimationOpenYesNo = vm.Homework.IsOutput == 1 ? "Y" : "N"; // 산출물이면 평가 공개로 저장

					homeworkSvc.HomeworkInsert(vm.Homework);
				}
				else
				{
					homeworkSvc.HomeworkUpdate(vm.Homework);
				}
			}

			return RedirectToAction(vm.Homework.IsOutput == 0 ? "ListTeacher" : "../Report/List", new { param1 = param1 });
		}

		[HttpPost]
		public JsonResult InningList(int courseno, int weekno)
        {
            Inning inning = new Inning("A");
            inning.CourseNo = courseno;
            inning.Week = weekno;

            List<Inning> InningList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_A", inning).ToList();

            return Json(InningList);
        }

        [HttpPost]
        public JsonResult ExamInningList(int courseno, string examtype, int homeworkNo, string homeworkType)
        {
			Inning inning = new Inning();
			inning.CourseNo = courseno;
			inning.ExamType = examtype;
			inning.HomeworkNo = homeworkNo;
			inning.HomeworkType = homeworkType;
            List<Inning> InningList = baseSvc.GetList<Inning>("common.COURSE_INNING_SELECT_B", inning).ToList();

			return Json(InningList);
        }

		[Route("MemberList/{param1}/{param2}/{param3}")]
		public ActionResult MemberList(int param1, int? param2, int? param3)
		{
			HomeworkViewModel vm = new HomeworkViewModel();

			HomeworkSubmit homeworksubmit = new HomeworkSubmit("A");
			homeworksubmit.CourseNo = param1;
			homeworksubmit.Week = param2 ?? 0;
			homeworksubmit.HomeworkNo = param3 ?? 0;

			vm.HomeworkSubmitList = baseSvc.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_A", homeworksubmit);

			return View(vm);
		}

		[Route("Copy/{param1}")]
		[Route("Copy/{param1}/{param2}")]
		public ActionResult Copy(HomeworkViewModel vm ,int param1, int? param2)
		{
			Term term = new Term("L");
			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_L", term);

			vm.TermList = vm.TermList.Where(x => x.TermGubun.Equals("CTGB001")).OrderByDescending(y => y.TermNo).ToList();

			Homework homework = new Homework("A");
			homework.CourseNo = param1;
			homework.TermNo = param2 ?? vm.TermList.OrderByDescending(d => d.TermNo).FirstOrDefault().TermNo;

			vm.HomeworkList = baseSvc.GetList<Homework>("homework.HOMEWORK_SELECT_A", homework);

			vm.TermNo = homework.TermNo;

			return View(vm);
		}

		[HttpPost]
		public JsonResult CopyHomework(int param1, int? param2)
		{
			int result = 0;

			Homework homework = new Homework("A");
			homework.CourseNo = param1;
			homework.OrgHomeworkNo = param2 ?? 0;
			homework.CreateUserNo = sessionManager.UserNo;

			result = homeworkSvc.HomeworkCopy(homework);

			return Json(result);
		}

		[Route("Detail/{param1}/{param2}")]
		[Route("Detail/{param1}/{param2}/{param3}")]
		[Route("Detail/{param1}/{param2}/{param3}/{param4}")]
		public ActionResult Detail(HomeworkViewModel vm, int? param1, int? param2, string param3, string param4) //강좌번호, 과제번호, 정렬타입, present 
		{
            if(param2 == null)
            {
				Response.Redirect(string.Format("/Home/Index?InfoMessage={0}", "MSG_EREGULAR_PATH"));
			}
			else
			{
				Homework homework = new Homework("S");
				homework.CourseNo = param1 ?? 0;
				homework.HomeworkNo = param2 ?? 0;

				vm.Homework = baseSvc.Get<Homework>("homework.HOMEWORK_SELECT_S", homework);

				HomeworkSubmit homeworksubmit = new HomeworkSubmit("L");
				homeworksubmit.CourseNo = param1 ?? 0;
				homeworksubmit.HomeworkNo = param2 ?? 0;

				vm.HomeworkSubmitList = baseSvc.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit);

				if (vm.Homework.HomeworkType.Equals("CHWT004"))
				{
					var teamName = vm.HomeworkSubmitList.GroupBy(c => c.TeamName).Select(g => g.First());
					//view로 넘겨주기

					if (!string.IsNullOrEmpty(vm.TeamName))
					{
						vm.HomeworkSubmitList = vm.HomeworkSubmitList.Where(c => c.TeamName == vm.TeamName).ToList();
					}
				}

				vm.Homework.TotalCount = vm.HomeworkSubmitList.Where(x => x.TargetYesNo.Equals("Y")).ToList().Count;
				vm.Homework.SubmitCnt = vm.HomeworkSubmitList.Where(x => !string.IsNullOrEmpty(x.SubmitContents) || x.FileGroupNo > 0).Count();

				switch (param3 ?? "a")
				{
					case "a":
						vm.Present = "a";
						break;
					case "y":
						vm.HomeworkSubmitList = vm.HomeworkSubmitList.Where(x => (!string.IsNullOrEmpty(x.SubmitContents) || x.FileGroupNo > 0)).ToList();
						vm.Present = "y";
						break;
					case "n":
						vm.HomeworkSubmitList = vm.HomeworkSubmitList.Where(x => (string.IsNullOrEmpty(x.SubmitContents) && x.FileGroupNo == 0)).ToList();
						vm.Present = "n";
						break;
				}

				if (!string.IsNullOrEmpty(param4))
				{
					if (param4.Equals("UserID"))
					{
						vm.HomeworkSubmitList = vm.HomeworkSubmitList.OrderBy(x => x.UserID).ToList();
						vm.SortType = "HangulName";
					}
					else
					{
						vm.HomeworkSubmitList = vm.HomeworkSubmitList.OrderBy(x => x.HangulName).ToList();
						vm.SortType = "UserID";
					}
				}
			}

			return View(vm);
		}

		[Route("DetailEstimationEdit/{param1}/{param2}")]
		[Route("DetailEstimationEdit/{param1}/{param2}/{param3}")]
		public ActionResult DetailEstimationEdit(int param1, int? param2, int? param3)
		{
			Homework homework = new Homework("B");

			homework.CourseNo = param1;
			homework.HomeworkNo = param2 ?? 0;
			homework.UpdateUserNo = sessionManager.UserNo;

			baseSvc.Save("homework.HOMEWORK_SAVE_B", homework);

			if(param3 == null)
			{
				return RedirectToAction("Detail", new { param1 = param1, param2 = param2 });
			}
			else
			{
				return RedirectToAction("Feedback", new { param1 = param1, param2 = param2, param3 = param3 });
			}
		}

		[Route("DetailIsGoodEdit/{param1}/{param2}/{param3}")]
		public ActionResult DetailIsGoodEdit(int param1, int? param2, int? param3)
		{
			HomeworkSubmit homeworksumbit = new HomeworkSubmit("A");

			homeworksumbit.CourseNo = param1;
			homeworksumbit.HomeworkNo = param2 ?? 0;
			homeworksumbit.SubmitNo = param3 ?? 0;

			baseSvc.Save("homework.HOMEWORK_SUBMIT_SAVE_A", homeworksumbit);

			return RedirectToAction("Detail", new { param1 = param1, param2 = param2 });
		}

		[Route("DetailDelete/{param1}/{param2}")]
		public ActionResult DetailDelete(int param1, int? param2)
		{
			HomeworkSubmit homework = new HomeworkSubmit("D");

			homework.CourseNo = param1;
			homework.HomeworkNo = param2 ?? 0;
			homework.UpdateUserNo = sessionManager.UserNo;
			homework.EstimationOpenYesNo = "N";
			homework.DeleteYesNo = "Y";

			baseSvc.Save("homework.HOMEWORK_SAVE_D", homework);

			return RedirectToAction("ListTeacher", new { param1 = param1 });
		}

		[Route("Feedback/{param1}/{param2}/{param3}")] 
		public ActionResult Feedback(int param1, int? param2, int? param3)
		{

			HomeworkViewModel vm = new HomeworkViewModel();
			if (param2 == null)
			{
				Response.Redirect(string.Format("/Home/Index?InfoMessage={0}", "MSG_EREGULAR_PATH"));
			}
			else
			{
				Homework homework = new Homework("S");
				homework.CourseNo = param1;
				homework.HomeworkNo = param2 ?? 0;

				vm.Homework = baseSvc.Get<Homework>("homework.HOMEWORK_SELECT_S", homework);

				HomeworkSubmit homeworksubmit = new HomeworkSubmit("L");
				homeworksubmit.CourseNo = param1;
				homeworksubmit.HomeworkNo = param2 ?? 0;

				vm.HomeworkSubmitList = baseSvc.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit);

				vm.HomeworkSubmit = vm.HomeworkSubmitList.Where(x => x.SubmitUserNo == param3).FirstOrDefault();

				if (vm.HomeworkSubmit != null)
				{
					File file = new File();
					file.RowState = "L";
					file.FileGroupNo = vm.HomeworkSubmit.FileGroupNo ?? 0;
					if (vm.HomeworkSubmit.FileGroupNo != null)
						vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					else
						vm.FileList = null;

					if (vm.HomeworkSubmit.RowNum != 1)
					{
						vm.PrevUserNo = Convert.ToInt32(vm.HomeworkSubmitList.Where(t => t.RowNum.Equals(vm.HomeworkSubmit.RowNum - 1)).SingleOrDefault().SubmitUserNo);
					}

					if (vm.HomeworkSubmit.RowNum != vm.HomeworkSubmitList.Count)
					{
						vm.NextUserNo = Convert.ToInt32(vm.HomeworkSubmitList.Where(t => t.RowNum.Equals(vm.HomeworkSubmit.RowNum + 1)).SingleOrDefault().SubmitUserNo);
					}
				}
			}

			return View(vm);
		}

		[HttpPost]
		public ActionResult Feedback(HomeworkViewModel vm)
		{
			HomeworkSubmit homeworksubmit = new HomeworkSubmit("U");
			homeworksubmit.CourseNo = vm.Homework.CourseNo;
			homeworksubmit.HomeworkNo = vm.Homework.HomeworkNo;
			homeworksubmit.SubmitUserNo = vm.HomeworkSubmit.SubmitUserNo;
			homeworksubmit.SubmitNo = vm.HomeworkSubmit.SubmitNo;

			//시험대체형은 만점대비 89% 초과할 수 없음

			homeworksubmit.Score = vm.HomeworkSubmit.Score;
			homeworksubmit.Feedback = vm.HomeworkSubmit.Feedback;

			baseSvc.Save("homework.HOMEWORK_SUBMIT_SAVE_U", homeworksubmit);
			
			if(vm.RefreshUserNo == vm.HomeworkSubmit.SubmitUserNo)
			{
				return RedirectToAction("Detail", new { param1 = vm.Homework.CourseNo, param2 = vm.Homework.HomeworkNo});
			}
			else
			{
				return RedirectToAction("Feedback", new { param1 = vm.Homework.CourseNo, param2 = vm.Homework.HomeworkNo, param3 = vm.RefreshUserNo });
			}
		}

		[HttpPost]
		public JsonResult AddFeedback(int param1, int? param2, string param3, int? param4, string param5)
		{
			HomeworkSubmit homeworksubmit = new HomeworkSubmit();

			homeworksubmit.CourseNo = param1;
			homeworksubmit.HomeworkNo = param2 ?? 0;
			homeworksubmit.UserNoString = param3;

			homeworksubmit.Score = param4 ?? 0;
			homeworksubmit.Feedback = param5;

			homeworksubmit.UpdateUserNo = sessionManager.UserNo;

			string errorMessage = string.Empty;
			try
			{
				homeworkSvc.HomeworkSubmitUpdate(homeworksubmit);
			}
			catch(Exception ex)
			{
				errorMessage = ex.Message;
			}

			return Json(errorMessage);
		}

		[Route("RegisterLicense/{param1}/{param2}/{param3}")]
		[Route("RegisterLicense/{param1}/{param2}/{param3}/{param4}")]
		public ActionResult RegisterLicense(int param1, int? param2, int? param3, string param4)
		{
			HomeworkViewModel vm = new HomeworkViewModel();

			HomeworkSubmit homeworksubmit = new HomeworkSubmit("S");

			homeworksubmit.CourseNo = param1;
			homeworksubmit.HomeworkNo = param2 ?? 0;
			homeworksubmit.UserNo = param3 ?? 0;

			vm.HomeworkSubmit = baseSvc.Get<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_S", homeworksubmit);

			License license = new License("S");

			license.CourseNo = param1;
			license.HomeworkNo = param2 ?? 0;
			license.UserNo = param3 ?? 0;

			vm.LicenseList = baseSvc.GetList<License>("homework.CERTIFICATE_SELECT_S", license);

			Code code = new Code("A");
			code.ClassCode = "CFCD";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			if (!string.IsNullOrEmpty(param4))
			{
				vm.License = vm.LicenseList.Where(c => c.CertCode.Equals(param4)).FirstOrDefault();

				if((vm.License.FileGroupNo ?? 0) > 0)
				{
					File file = new File();
					file.RowState = "L";
					file.FileGroupNo = vm.License.FileGroupNo ?? 0;
					if (vm.License.FileGroupNo != null)
						vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					else
						vm.FileList = null;
				}
			}

			if(TempData["ErrorMessage"] != null)
			{
				vm.ErrorMessage = TempData["ErrorMessage"].ToString();
			}

			return View(vm); 
		}

		[HttpPost]
		[Route("RegisterLicense/{param1}")]
		public ActionResult RegisterLicense(HomeworkViewModel vm)
		{
			License license = new License("C");

			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화

			//파일관련 Start------------------------------------------------------------------------------------
			string saveFolderName = DateTime.Now.ToString("yyyyMMdd");

			Hashtable htFileFolder = new Hashtable();
			htFileFolder.Add("RowState", "S");
			htFileFolder.Add("FolderName", "Certificate");
			string subFolderName = baseSvc.Get<FileFolder>("common.FILEFOLDER_SELECT_S", htFileFolder).FolderName;
			long? fileGroupNo = vm.FileGroupNo > 0 ? (long?)vm.FileGroupNo : null;
			fileGroupNo = SaveFile(Request.Files, "LicenseFile", fileGroupNo, "Certificate");

			//업로드한 파일이 디렉토리에 저장되었는지 확인
			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fileGroupNo ?? 0);
			htFile.Add("DeleteYesNo", "N");

			vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", htFile);

			foreach (var item in vm.FileList)
			{
				if (!System.IO.File.Exists(Server.MapPath("/" + FileRootFolder + item.SaveFileName)))
				{
					fileSuccess = false;
					if ("C" == license.RowState)
					{
						FileDeleteByGroup(fileGroupNo ?? 0);
						break; //등록의 경우 오류 방지를 위해 첨부파일 내 모든 파일을 삭제함
					}
					else
					{
						FileDelete(item.FileNo); //수정의 경우 기존 파일은 삭제되지 않도록 함
					}
				}
			}
			//파일관련 End------------------------------------------------------------------------------------  

			license.UserNo = vm.License.UserNo;
			license.CourseNo = vm.License.CourseNo;
			license.CertCode = vm.License.CertCode;
			license.CertDate = vm.License.CertDate;

			if(string.IsNullOrEmpty(license.UpdateCertCode))
			{
				license.UpdateCertCode = license.CertCode;
			}

			license.FileGroupNo = fileGroupNo == null ? vm.FileGroupNo > 0 ? vm.FileGroupNo : 0 : (int)fileGroupNo;
			license.CreateUserNo = sessionManager.UserNo;

			if (fileSuccess)
			{
				try
				{
					baseSvc.Save("homework.CERTIFICATE_SAVE_C", license);
				}
				catch (Exception ex)
				{
					TempData["ErrorMessage"] = ex.Message;
				}
			}

			int? param1 = vm.License.CourseNo;
			int? param2 = vm.License.HomeworkNo;
			int? param3 = Convert.ToInt32(vm.License.UserNo);

			return RedirectToAction("RegisterLicense", new { param1 = param1, param2 = param2, param3 = param3 });
		}

		[Route("ListStudent/{param1}")]
		public ActionResult ListStudent(int param1)
		{
			HomeworkViewModel vm = new HomeworkViewModel();
			Homework homework = new Homework("B");

			homework.CourseNo = param1;
			homework.UserNo = sessionManager.UserNo;

			vm.HomeworkList = baseSvc.GetList<Homework>("homework.HOMEWORK_SELECT_B", homework);

			vm.HomeworkList = vm.HomeworkList.Where(x => x.IsOutput != 1).ToList();

			return View(vm);
		}

		[Route("Submit/{param1}/{param2}")]
		public ActionResult Submit(int param1, int? param2)
		{
			HomeworkViewModel vm = new HomeworkViewModel();

			if (param2 == null)
			{
				Response.Redirect(string.Format("/Home/Index?InfoMessage={0}", "MSG_EREGULAR_PATH"));
			}
			else
			{
				Homework homework = new Homework("S");
				homework.CourseNo = param1;
				homework.HomeworkNo = param2 ?? 0;

				vm.Homework = baseSvc.Get<Homework>("homework.HOMEWORK_SELECT_S", homework);

				if (vm.Homework.FileGroupNo > 0)
				{
					File file = new File();
					file.RowState = "L";
					file.FileGroupNo = vm.Homework.FileGroupNo ?? 0;
					if (vm.Homework.FileGroupNo != null)
						vm.HomeworkfileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					else
						vm.HomeworkfileList = null;
				}

				HomeworkSubmit homeworksubmit = new HomeworkSubmit("L");
				homeworksubmit.CourseNo = param1;
				homeworksubmit.HomeworkNo = param2 ?? 0;

				vm.HomeworkSubmitList = baseSvc.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit);

				vm.HomeworkSubmit = vm.HomeworkSubmitList.Where(x => x.SubmitUserNo == sessionManager.UserNo).FirstOrDefault();

				if (vm.HomeworkSubmit != null)
				{
					if (vm.HomeworkSubmit.FileGroupNo > 0)
					{
						File file = new File();
						file.RowState = "L";
						file.FileGroupNo = vm.HomeworkSubmit.HomeworkType != "CHWT004" ? vm.HomeworkSubmit.FileGroupNo ?? 0 : vm.HomeworkSubmit.LeaderFileGroupNo ?? 0;
						if (vm.HomeworkSubmit.FileGroupNo != null)
							vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
						else
							vm.FileList = null;
					}
				}
				else
				{
					vm.HomeworkSubmit = new HomeworkSubmit();
				}
			}

			return View(vm);
		}

		[HttpPost]
		[Route("AddContents/{param1}")]
		public ActionResult AddContents(HomeworkViewModel vm, int param1)
		{
			HomeworkSubmit homeworksubmit = new HomeworkSubmit("U");

			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화

			//파일관련 Start------------------------------------------------------------------------------------
			string saveFolderName = DateTime.Now.ToString("yyyyMMdd");

			Hashtable htFileFolder = new Hashtable();
			htFileFolder.Add("RowState", "S");
			htFileFolder.Add("FolderName", "CourseHomework");
			string subFolderName = baseSvc.Get<FileFolder>("common.FILEFOLDER_SELECT_S", htFileFolder).FolderName;
			long? fileGroupNo = vm.FileGroupNo > 0 ? (long?)vm.FileGroupNo : null;
			fileGroupNo = SaveFile(Request.Files, "SubmitFile", fileGroupNo, "CourseHomework");

			//업로드한 파일이 디렉토리에 저장되었는지 확인
			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fileGroupNo ?? 0);
			htFile.Add("DeleteYesNo", "N");

			vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", htFile);

			foreach (var item in vm.FileList)
			{
				if (!System.IO.File.Exists(Server.MapPath("/" + FileRootFolder + item.SaveFileName)))
				{
					fileSuccess = false;
					if ("C" == homeworksubmit.RowState)
					{
						FileDeleteByGroup(fileGroupNo ?? 0);
						break; //등록의 경우 오류 방지를 위해 첨부파일 내 모든 파일을 삭제함
					}
					else
					{
						FileDelete(item.FileNo); //수정의 경우 기존 파일은 삭제되지 않도록 함
					}
				}
			}
			//파일관련 End------------------------------------------------------------------------------------  

			if (fileSuccess)
			{
				homeworksubmit.CourseNo = param1;
				homeworksubmit.SubmitNo = vm.HomeworkSubmit.SubmitNo;
				homeworksubmit.SubmitUserNo = sessionManager.UserNo;
				homeworksubmit.HomeworkNo = vm.HomeworkSubmit.HomeworkNo;
				homeworksubmit.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo;
				homeworksubmit.SubmitContents = vm.HomeworkSubmit.SubmitContents;

				baseSvc.Save("homework.HOMEWORK_SUBMIT_SAVE_U", homeworksubmit);
			}

			return RedirectToAction("ListStudent", new { param1 = param1 });
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("DetailAdmin/{param1}")]
		public ActionResult DetailAdmin(HomeworkViewModel vm, int param1)
		{
			Course course = new Course("S");
			course.CourseNo = param1;

			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_S", course);

			Homework homework = new Homework("L");
			homework.CourseNo = param1;

			vm.HomeworkList = baseSvc.GetList<Homework>("homework.HOMEWORK_SELECT_L", homework);

			vm.HomeworkList = vm.HomeworkList.OrderBy(x => x.Week).ToList();

			if(vm.Homework != null)
			{
				HomeworkSubmit homeworksubmit = new HomeworkSubmit("L");

				homeworksubmit.CourseNo = param1;
				homeworksubmit.HomeworkNo = vm.Homework.HomeworkNo;
				vm.Course.SortNo = vm.Homework.HomeworkNo;

				if(vm.SortType == "UserID")
				{
					vm.HomeworkSubmitList = baseSvc.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit).OrderBy(x => x.UserID).ToList();
					vm.SortType = "HangulName";
				}
				else
				{
					vm.HomeworkSubmitList = baseSvc.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit).OrderBy(x => x.HangulName).ToList();
					vm.SortType = "UserID";
				}
			}
	
			ViewBag.ProgramNo	= string.IsNullOrEmpty(Request.QueryString["ProgramNo"]) ? vm.Homework.ProgramNo : Convert.ToInt32(Request.QueryString["ProgramNo"]);
			ViewBag.TermNo      = string.IsNullOrEmpty(Request.QueryString["TermNo"]) ? vm.Homework.TermNo : Convert.ToInt32(Request.QueryString["TermNo"]);
			ViewBag.SearchText  = string.IsNullOrEmpty(Request.QueryString["SearchText"]) ? "" : Request.QueryString["SearchText"];

			return View(vm);
		}

		[HttpPost]
		[Route("SubmitList")]
		public JsonResult SubmitList(int courseNo, int homeworkNo, string sortType)
		{
			HomeworkViewModel vm = new HomeworkViewModel();

			// 토론 참여자 리스트
			HomeworkSubmit homeworksubmit = new HomeworkSubmit("L");

			homeworksubmit.CourseNo = courseNo;
			homeworksubmit.HomeworkNo = homeworkNo;

			if (sortType == "UserID")
			{
				vm.HomeworkSubmitList = baseSvc.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit).OrderBy(x => x.UserID).ToList();
				vm.SortType = "HangulName";
			}
			else
			{
				vm.HomeworkSubmitList = baseSvc.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit).OrderBy(x => x.HangulName).ToList();
				vm.SortType = "UserID";
			}

			return Json(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListAdmin/{param1}")]
		public ActionResult ListAdmin(HomeworkViewModel vm, int param1)//param1 : programno, param2 : termno, param3 : termgubun
		{
			Code code = new Code("A", new string[] { "CHGB", "CTGB" });
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

			if(vm.Homework == null)
			{
				vm.Homework = new Homework();
				vm.Homework.ProgramNo = vm.UnivYN().Equals("Y") ? param1 : 2;
				vm.Homework.TermNo = Convert.ToInt32(Request.QueryString["TermNo"]);
				vm.Homework.ProgramNo = Convert.ToInt32(Request.QueryString["ProgramNo"]);
			}

			Homework homework = new Homework("C");
			
			homework.TermNo = vm.Homework.TermNo > 0 ? vm.Homework.TermNo : vm.TermList.Count > 0 ? vm.TermList[0].TermNo : 0;

			if (!string.IsNullOrEmpty(vm.Homework.SearchText))
			{
				homework.TermNo = vm.Homework.SearchText.Equals("Y") ? homework.TermNo : 0;
			}
			
			homework.ProgramNo = vm.UnivYN().Equals("Y") ? vm.Homework.ProgramNo : 2;


			if (vm.SearchText == null)
				homework.SubjectName = !string.IsNullOrEmpty(vm.Homework.SubjectName) ? vm.Homework.SubjectName : null;
			else
				homework.SubjectName = vm.SearchText;

			homework.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			homework.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.HomeworkList = baseSvc.GetList<Homework>("homework.HOMEWORK_SELECT_C", homework);

			vm.PageTotalCount = vm.HomeworkList.Count > 0 ? vm.HomeworkList[0].TotalCount : 0;

			if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Homework.TermNo", homework.TermNo }, { "Homework.ProgramNo", homework.ProgramNo },
																	{ "Homework.TermGubun", vm.Homework.TermGubun }, { "Homework.SubjectName", vm.Homework.SubjectName }, { "Homework.SearchText", string.IsNullOrEmpty(vm.Homework.SearchText) ? "Y" : vm.Homework.SearchText } };

			}
			else
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "Homework.TermNo", homework.TermNo },
																	{ "Homework.TermGubun", vm.Homework.TermGubun }, { "Homework.SubjectName", vm.Homework.SubjectName }, { "Homework.SearchText", string.IsNullOrEmpty(vm.Homework.SearchText) ? "Y" : vm.Homework.SearchText } };

			}

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult ListAdminExcel(int param1, int param2, string param3)
		{
			Hashtable hash = new Hashtable();
			hash.Add("RowState", "D");
			hash.Add("ProgramNo", WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? param1 : 2);
			hash.Add("TermNo", param2);
			hash.Add("SubjectName", param3);

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("homework.HOMEWORK_SELECT_EXCEL_D", hash);

			string[] headers;
			string[] columns;
			string excelFileName = "";

			if (WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
			{
				headers = new string[] { "과정", WebConfigurationManager.AppSettings["SubjectText"].ToString(), "캠퍼스 / 분반", "강의형태", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "과제출제수" };
				columns = new string[] { "ProgramName", "SubjectName", "CampusName", "강의형태", "ProfessorName", "HomeworkCount" };

				excelFileName = String.Format("강의운영관리_과제관리_{1}_{0}", DateTime.Now.ToString("yyyyMMdd"), param1 == 1 ? "정규과정" : "MOOC");
			}
			else
			{
				headers = new string[] { WebConfigurationManager.AppSettings["SubjectText"].ToString(), "캠퍼스 / 분반", "강의형태", "담당" + WebConfigurationManager.AppSettings["ProfIDText"].ToString(), "과제출제수" };
				columns = new string[] { "SubjectName", "CampusName", "강의형태", "ProfessorName", "HomeworkCount" };

				excelFileName = String.Format("강의운영관리_과제관리_{0}", DateTime.Now.ToString("yyyyMMdd"));
			}

			return ExportExcel(headers, columns, hashList, excelFileName); ;
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult DetailAdminExcel(int param1)
		{
			Hashtable hash = new Hashtable();
			hash.Add("RowState", "E");
			hash.Add("CourseNo", param1);

			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("homework.HOMEWORK_SELECT_EXCEL_E", hash);

			string[] headers = new string[] { "주차", "차시", "과제유형", "과제제목", "제출방법", "제출기간", "공개여부", "제출인원", "평가인원" };
			string[] columns = new string[] { "Week", "InningSeqNo", "HomeworkTypeName", "HomeworkTitle", "SubmitTypeName", "SubmitDay", "OpenYesNo", "SubmitCnt", "SubmitScoreCnt" };
			string excelFileName = String.Format("강의운영관리_과제관리_상세보기_{0}", DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, hashList, excelFileName);
		}

		public ActionResult Certification(CourseViewModel vm, int param1)
		{
			Course course = new Course();
			course.TermNo = param1;
			
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			if (vm.Course != null)
			{
				course.SubjectName = vm.Course.SubjectName;
				course.ProfessorName = vm.Course.ProfessorName;
				//course.UserID = vm.Course.UserID;
			}

			course.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			course.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;


			vm.CourseList = baseSvc.GetList<Course>("homework.COMPLETION_SELECT_L", course);

			return View(vm);
		}
	}
}