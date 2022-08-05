using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;
using ICSharpCode.SharpZipLib.Zip;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("Ocw")]
	public class OcwController : LectureRoomBaseController
	{
		public OcwService ocwSvc { get; set; }
		public StudyService studySvc { get; set; }
		
		#region 메소드

		public static string ConvertOutputValue(string pValue)
		{
			pValue = pValue.Replace("&amp;", "&");
			pValue = pValue.Replace("&lt;", "<");
			pValue = pValue.Replace("&gt;", ">");
			pValue = pValue.Replace("&quot;", "\"");
			pValue = pValue.Replace("&apos;", "'");
			pValue = pValue.Replace("&#x2F;", "\\");
			pValue = pValue.Replace("&nbsp;", " ");
			pValue = pValue.Replace("<br />", "\n");

			return pValue;
		}

		protected int GetRandom(int s, int e, int? not, int? notvalue)
		{
			Random r = new Random();
			int rtn = r.Next(s, e);
			return not != null && not == rtn ? notvalue.Value : rtn;
		}

		protected void SetLearnLog(Hashtable OcwByInning)
		{
			//차시 생성 이후 수강등록된 학생의 경우 studyinning이 생성되어 있지 않아 접근 시 생성
			if (Convert.ToInt32(OcwByInning["StudyInningNo"].ToString()) == 0)
			{
				Hashtable hash = new Hashtable();
				hash.Add("LectureNo", Convert.ToInt32(OcwByInning["LectureNo"].ToString()));
				hash.Add("InningNo", Convert.ToInt32(OcwByInning["InningNo"].ToString()));
				hash.Add("UserNo", sessionManager.UserNo);
				baseSvc.Save("course.STUDY_INNING_SAVE_G", hash);

				hash = new Hashtable();
				hash.Add("InningNo", Convert.ToInt32(OcwByInning["InningNo"].ToString()));
				hash.Add("UserNo", sessionManager.UserNo);
				OcwByInning = baseSvc.Get<Hashtable>("course.COURSE_INNING_SELECT_M", hash);
			}

			Hashtable param = new Hashtable();
			param.Add("StudyInningNo", Convert.ToInt32(OcwByInning["StudyInningNo"].ToString()));
			StudyLog log = baseSvc.Get<StudyLog>("course.STUDY_LOG_SELECT_S", param);

			if (log == null)
			{
				log = new StudyLog("C");
				log.StudyInningNo = Convert.ToInt32(OcwByInning["StudyInningNo"].ToString());
				log.UserNo = sessionManager.UserNo;
				log.InningNo = Convert.ToInt32(OcwByInning["InningNo"].ToString());
				log.CourseNo = Convert.ToInt32(OcwByInning["CourseNo"].ToString());
				log.SubjectNo = Convert.ToInt32(OcwByInning["SubjectNo"].ToString());
				log.LMSContentsNo = Convert.ToInt32(OcwByInning["LMSContentsNo"].ToString());
				log.StudyHistory = DateTime.Now.ToString("yyyyMMdd") + "@1:0:" + (Request.Browser.IsMobileDevice ? "M" : "P");
				studySvc.StudyLogSave(log);
			}
			else
			{
				log.RowState = "U";
				int rs = studySvc.StudyLogSave(log);
				if(rs > 0)
				{
					StudyInningUpdate(log);
				}
				
			}
		}

		public void StudyInningUpdate(StudyLog log)
		{
			Inning inning = new Inning();
			inning.InningNo = log.InningNo;
			inning = baseSvc.Get<Inning>("course.COURSE_INNING_SELECT_S", inning);

			Hashtable hash = new Hashtable();
			hash.Add("StudyInningNo", log.StudyInningNo);
			hash.Add("InningNo", log.InningNo);
			StudyInning studyInning = baseSvc.Get<StudyInning>("course.STUDY_INNING_SELECT_S", hash);

			// 차시시작 이후
			if (Convert.ToDateTime(inning.InningStartDay) <= DateTime.Now)
			{
				Hashtable paramHash = new Hashtable();
				paramHash.Add("StudyInningNo", studyInning.StudyInningNo);

				//학습종료시간 23시59분59초로 변경    
				if (!string.IsNullOrEmpty(inning.InningEndDay))
				{
					inning.InningEndDay = Convert.ToDateTime(inning.InningEndDay).ToString("yyyy-MM-dd") + " 23:59:59";
				}

				if (!string.IsNullOrEmpty(inning.InningLatenessEndDay))
				{
					inning.InningLatenessEndDay = Convert.ToDateTime(inning.InningLatenessEndDay).ToString("yyyy-MM-dd") + " 23:59:59";
				}

				//총 수업시간이 출석인정시간을 넘고 출석상태(CLAT001)가 아닌 경우
				if ((log.TotalStudyTime >= (inning.AttendanceAcceptTime * 60)) && studyInning.AttendanceStatus != "CLAT001")
				{
					paramHash.Add("StudyEndDateTime", DateTime.Now);
					paramHash.Add("StudyStatus", "STST001");

					if (!string.IsNullOrEmpty(inning.InningStartDay) && !string.IsNullOrEmpty(inning.InningEndDay))
					{
						if (Convert.ToDateTime(inning.InningStartDay) <= Convert.ToDateTime(log.LastStudyDateTime)
							&& Convert.ToDateTime(inning.InningEndDay) >= Convert.ToDateTime(log.LastStudyDateTime))
						{
							paramHash.Add("AttendanceStatus", "CLAT001");
						}
						else
						{
							//지각설정에 따른 출석처리
							if (!string.IsNullOrEmpty(inning.InningLatenessStartDay) && !string.IsNullOrEmpty(inning.InningLatenessEndDay))
							{
								if (Convert.ToDateTime(inning.InningLatenessStartDay) <= Convert.ToDateTime(log.LastStudyDateTime)
									&& Convert.ToDateTime(inning.InningLatenessEndDay) >= Convert.ToDateTime(log.LastStudyDateTime))
								{
									paramHash.Add("AttendanceStatus", "CLAT003"); //지각
								}
								else if (studyInning.AttendanceStatus != "CLAT005") //조퇴가 아닐 시 
								{
									paramHash.Add("AttendanceStatus", "CLAT002"); //결석
								}
							}
							else if (studyInning.AttendanceStatus != "CLAT005") //지각설정이 없을때 조퇴가 아닐 시 (사실상 미체크인 경우밖에 없음.)
							{
								paramHash.Add("AttendanceStatus", "CLAT002"); //결석
							}
						}
					}
				}
				else if (studyInning.StudyEndDateTime == null)
				{
					paramHash.Add("StudyStatus", "STST002");       //미완료
				}

				baseSvc.Save("course.STUDY_INNING_SAVE_U", paramHash);
			}
		}

		public void SaveHtmlOcw(long OcwNo, long? FileGroupNo)
		{
			File file = new File();
			file.FileGroupNo = FileGroupNo ?? 0;

			IList<File> fileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);

			if (fileList.Count > 0)
			{
				foreach (var item in fileList)
				{
					if (System.IO.File.Exists(Server.MapPath("/" + FileRootFolder + item.SaveFileName)))
					{
						try
						{
							string fileFolderPath = Server.MapPath(string.Format(@"\{0}\{1}\{2}\{3}\", FileRootFolder, "OCW", "OcwHtml", "Ocw" + OcwNo.ToString()));

							if (!System.IO.Directory.Exists(fileFolderPath))
							{
								//폴더생성
								System.IO.DirectoryInfo dir = new System.IO.DirectoryInfo(fileFolderPath);
								dir.Create();
							}
							else
							{
								System.IO.DirectoryInfo dir = new System.IO.DirectoryInfo(fileFolderPath);
								dir.Delete(true);
							}
							//zip파일 풀기
							FastZip zipFile = new FastZip();

							zipFile.ExtractZip(Server.MapPath("/" + FileRootFolder + item.SaveFileName), fileFolderPath, null);
						}
						catch (Exception ex)
						{
							string message = ex.Message;
						}
					}
				}
			}
		}

		#endregion

		[Route("/")]
		[Route("Index")]
		[Route("Index/{param1}")]
		public ActionResult Index(OcwViewModel vm)
		{
			vm.OcwThemeSel = vm.OcwThemeSel ?? "%";
			vm.AssignSel = vm.AssignSel ?? "%";

			vm.PageRowSize = vm.PageRowSize ?? 5;
			vm.PageNum = vm.PageNum ?? 1;

			//정렬순 공통코드 조회
			Code code = new Code("A", new string[] { "SRTN" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
			vm.OcwSort = vm.OcwSort  ??  vm.BaseCode.FirstOrDefault().CodeValue;

			//OCW 리스트조회
			vm.Ocw = new Ocw();

			string sortParam = string.Empty;
			switch (vm.OcwSort)
			{
				case "SRTN001":	sortParam = "NEWEST";
					break;
				case "SRTN002":	sortParam = "USING";
					break;
				case "SRTN003":	sortParam = "LIKE";
					break;

			}

			string ThemeNo = vm.OcwThemeSel;
			string AssignNo = vm.AssignSel;
			int? IsAuth = 2; //0: (검토중)미승인, 1: 거절, 2: 승인
			int? IsOpen = 1; //0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시)
			string SearchText = vm.SearchText;
			int? FirstIdx = FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum));
			int? LastIdx = LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum));

			vm.OcwList = ocwSvc.GetOcwList(ThemeNo, AssignNo, sortParam, IsAuth, IsOpen, SearchText, FirstIdx, LastIdx);
			foreach (var ocw in vm.OcwList)
			{
				ocw.AssignNamePath = ConvertOutputValue(ocw.AssignNamePath).Replace("|", " / ");
			}
			vm.Ocw.OcwAllCount = vm.PageTotalCount = vm.OcwList.FirstOrDefault() == null ? 0 : vm.OcwList.FirstOrDefault().OcwAllCount;
			 			
			//OCW 테마조회
			vm.OcwTheme = new OcwTheme();
			vm.OcwTheme.IsAdmin = 0; //0 : 아니오, 1 : 관리자전용
			vm.OcwTheme.IsOpen = 1; //0 : 비공개, 1 : 공개
			vm.OcwThemeList = ocwSvc.GetOcwThemeList(vm.OcwTheme);

			//전공 조회
			Assign assign = new Assign();
			vm.AssignList = baseSvc.GetList<Assign>("common.COMMON_DEPT_SELECT_L", assign);
			

			//페이징관련
			vm.Dic = new RouteValueDictionary 
			{
				{ "OcwThemeSel" , vm.OcwThemeSel }, { "OcwAssignSel" , vm.AssignSel }, { "OcwSort" , vm.OcwSort }, { "SearchText", vm.SearchText }, { "PageRowSize", vm.PageRowSize }
			};

			return View(vm);
		}

		[Route("Detail/{param1}")]
		public ActionResult Detail(OcwViewModel vm, int? param1)
		{
			Hashtable ht, ht2, ht3;
			vm.PageRowSize = vm.PageRowSize == null || vm.PageRowSize.Value == 0 ? 10 : vm.PageRowSize;
			vm.PageNum = vm.PageNum ?? 1;

			ModelState.Clear();
			Int64 ocwNo = Convert.ToInt64(param1);
			Int64 userNo = sessionManager.UserNo;

			//개별 OCW 조회
			ht = new Hashtable();
			ht.Add("OcwNo", ocwNo);
			ht.Add("ViewUserNo", userNo);
			vm.Ocw = baseSvc.Get<Ocw>("ocw.OCW_SELECT_S", ht);
			vm.Ocw.AssignNamePath = ConvertOutputValue(vm.Ocw.AssignNamePath).Replace("|", " / ");

			//작성자 추천 및 기타추천 OCW조회
			ht2 = new Hashtable();
			vm.OcwList = new List<Ocw>();
			
			ht2.Add("OcwNo", ocwNo);
			ht2.Add("OcwUserNo", vm.Ocw.OcwUserNo); // 해당 OCW 작성자
			ht2.Add("KWord", vm.Ocw.KWord ?? "");
			ht2.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			ht2.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.OcwList = baseSvc.GetList<Ocw>("ocw.OCW_SELECT_A", ht2);
			vm.PageTotalCount = vm.OcwList.Where(w => w.IsUserOcw == false).FirstOrDefault() == null ? 0 : vm.OcwList.Where(w => w.IsUserOcw == false).FirstOrDefault().MR;

			//기타 추천 페이징관련
			vm.Dic = new RouteValueDictionary
			{
				{ "PageRowSize", vm.PageRowSize }
			};


			//OCW 강의적용현황 조회
			vm.OcwCourse = new OcwCourse();
			vm.OcwCourseList = new List<OcwCourse>();
			vm.OcwCourse.OcwNo = ocwNo;
			vm.OcwCourseList = baseSvc.GetList<OcwCourse>("ocw.OCW_COURSE_SELECT_L", vm.OcwCourse);

			//의견 조회
			ht3 = new Hashtable();
			vm.OcwOpinion = new OcwOpinion();
			vm.OcwOpinionList = new List<OcwOpinion>();

			ht3.Add("OcwNo", ocwNo);
			vm.OcwOpinionList = baseSvc.GetList<OcwOpinion>("ocw.OCW_OPINION_SELECT_L", ht3);

			int opLv1Totalcnt = vm.OcwOpinionList.Where(w => w.OPLevel == 1).FirstOrDefault() == null ? 0 : 
								vm.OcwOpinionList.Where(w => w.OPLevel == 1).FirstOrDefault().OpinionTotalCount;
			
			int opLv2Totalcnt = vm.OcwOpinionList.Where(w => w.OPLevel > 1).FirstOrDefault() == null ? 0 :
								vm.OcwOpinionList.Where(w => w.OPLevel > 1).FirstOrDefault().OpinionTotalCount;

			vm.OcwOpinion.OpinionTotalCount = opLv1Totalcnt + opLv2Totalcnt;

			//OCW 테마조회
			vm.OcwTheme = new OcwTheme();
			vm.OcwTheme.IsAdmin = null;
			vm.OcwTheme.IsOpen = null;
			vm.OcwThemeList = baseSvc.GetList<OcwTheme>("ocw.OCW_THEME_SELECT_L", vm.OcwTheme);
			vm.OcwTheme.ThemeName = string.Join(", ", vm.OcwThemeList.Where(w => vm.Ocw.ThemeNos.IndexOf(("," + w.ThemeNo.ToString() + ",")) > -1).Select(s => s.ThemeName));


			//유저 카테고리 조회
			bool addDefualt = true;
			vm.OcwUserCat = new OcwUserCategory();
			vm.OcwUserCat.UserNo = userNo;
			vm.OcwUserCatList = baseSvc.GetList<OcwUserCategory>("ocw.OCW_USERCAT_SELECT_L", vm.OcwUserCat);
			var cat = vm.OcwUserCatList.Where(w => w.CatCode == 0).FirstOrDefault();
			if(!addDefualt && cat != null)
			{
				vm.OcwUserCatList.Remove(cat);
			}

			//OCW 추천 유무
			vm.OcwLike = new OcwLike();
			vm.OcwLike.OcwNo = ocwNo;
			vm.OcwLike.UserNo = userNo;
			vm.OcwLike = baseSvc.Get<OcwLike>("ocw.OCW_LIKE_SELECT_A", vm.OcwLike);

			//OCW 담기(관심) 유무
			vm.OcwPocket = new OcwPocket();
			vm.OcwPocket.OcwNo = ocwNo;
			vm.OcwPocket.UserNo = userNo;
			vm.OcwPocket = baseSvc.Get<OcwPocket>("ocw.OCW_POCKET_SELECT_A", vm.OcwPocket);

			//현재 학기 바인딩
			vm.TermList = new List<Term>();
			vm.TermList = ocwSvc.GetTermList(new Term("L")).OrderByDescending(w => w.TermYear).ToList();

			//중요도 공통코드 조회
			Code code = new Code("A", new string[] { "IMPT" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
			vm.OcwSort = vm.OcwSort ?? vm.BaseCode.FirstOrDefault().CodeValue;

			return View(vm);
		}

		[Route("Like/{param1}")]
		public ActionResult Like(OcwViewModel vm)
		{
			ModelState.Clear();
			Int64 userNo = sessionManager.UserNo;

			//OCW 테마조회
			vm.OcwTheme = new OcwTheme();
			vm.OcwTheme.IsAdmin = 0; //0 : 아니오, 1 : 관리자전용
			vm.OcwTheme.IsOpen = 1; //0 : 비공개, 1 : 공개
			vm.OcwThemeList = baseSvc.GetList<OcwTheme>("ocw.OCW_THEME_SELECT_L", vm.OcwTheme);

			//유저 카테고리 조회
			vm.OcwUserCat = new OcwUserCategory();
			vm.OcwUserCat.RowState = "L";
			vm.OcwUserCat.UserNo = userNo;
			bool addDefualt = true;

			vm.OcwUserCatList = ocwSvc.GetUserCategory(vm.OcwUserCat, vm.OcwUserCat.RowState, addDefualt);

			//관심 OCW 조회
			Hashtable ht = new Hashtable();

			vm.Ocw = new Ocw();
			vm.UserCat = string.IsNullOrEmpty(vm.UserCat) ? "-1" : vm.UserCat; // -1일 경우 전체 조회

			//vm.Ocw.IsAuth = 2;  //0: (검토중)미승인, 1: 거절, 2: 승인
			//vm.Ocw.IsOpen = 1;  //0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시)

			ht.Add("ViewUserNo", userNo);
			ht.Add("SearchText", vm.SearchText);
			ht.Add("CatCode", Convert.ToInt32(vm.UserCat));
			vm.OcwList = baseSvc.GetList<Ocw>("ocw.OCW_SELECT_B", ht);
			vm.OcwList = vm.OcwList.Where(w => w.IsUserOcw == false).ToList();

			return View(vm);
		}

		[Route("UserCategory/{param1}")]
		public ActionResult UserCategory(OcwViewModel vm)
		{
			ModelState.Clear();
			Int64 userNo = sessionManager.UserNo;

			//유저 카테고리 조회
			vm.OcwUserCat = new OcwUserCategory();
			vm.OcwUserCat.RowState = "L";
			vm.OcwUserCat.UserNo = userNo;
			bool addDefualt = false;

			vm.OcwUserCatList = ocwSvc.GetUserCategory(vm.OcwUserCat, vm.OcwUserCat.RowState, addDefualt);

			return View(vm);
		}

		[Route("MyOcw/{param1}")]
		public ActionResult MyOcw(OcwViewModel vm)
		{
			ModelState.Clear();
			Int64 userNo = sessionManager.UserNo;

			//공개상태 및 등록상태 공통코드 조회
			Code code = new Code("A", new string[] { "OPGB", "ERGB" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
			vm.OcwSort = vm.OcwSort ?? vm.BaseCode.FirstOrDefault().CodeValue;


			//유저 카테고리 조회
			bool addDefualt = true;
			vm.OcwUserCat = new OcwUserCategory();
			vm.OcwUserCat.UserNo = userNo;
			vm.OcwUserCatList = baseSvc.GetList<OcwUserCategory>("ocw.OCW_USERCAT_SELECT_L", vm.OcwUserCat);
			var cat = vm.OcwUserCatList.Where(w => w.CatCode == 0).FirstOrDefault();
			if (!addDefualt && cat != null)
			{
				vm.OcwUserCatList.Remove(cat);
			}

			//나의 OCW 조회
			vm.Ocw = new Ocw();

			vm.PageRowSize = vm.PageRowSize ?? 10;
			vm.PageNum = vm.PageNum ?? 1;

			int? openGb = null;
			switch (vm.OpenGb)
			{
				case "OPGB001":	openGb = 1;
					break;
				case "OPGB002":	openGb = 2;
					break;
				case "OPGB003":	openGb = 0;
					break;
				case "%": openGb = null;
					break;

			}

			int? AuthGb = null;
			switch (vm.AuthGb)
			{
				case "ERGB001":	AuthGb = 0;
					break;
				case "ERGB002":	AuthGb = 1;
					break;
				case "ERGB003":	AuthGb = 2;
					break;
				case "%": AuthGb = null;
					break;

			}
			vm.Ocw.IsOpen = openGb;  //0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시)
			vm.Ocw.IsAuth = AuthGb;  //0: (검토중)미승인, 1: 거절, 2: 승인

			vm.UserCat = string.IsNullOrEmpty(vm.UserCat) ? "-1" : vm.UserCat; // -1일 경우 전체 조회

			Hashtable ht = new Hashtable();

			ht.Add("SortValue", "NEWEST");
			ht.Add("SearchText", vm.SearchText);
			ht.Add("IsAuth", vm.Ocw.IsAuth);
			ht.Add("IsOpen", vm.Ocw.IsOpen);
			ht.Add("CatCode", vm.UserCat);
			ht.Add("OcwUserNo", userNo);
			ht.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			ht.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.OcwList = baseSvc.GetList<Ocw>("ocw.OCW_SELECT_L", ht);

			vm.Ocw.OcwAllCount = vm.PageTotalCount = vm.OcwList.FirstOrDefault() == null ? 0 : vm.OcwList.FirstOrDefault().OcwAllCount;

            //페이징관련

            vm.Dic = new RouteValueDictionary
            {
                { "OpenGb" ,vm.OpenGb }, { "AuthGb" , vm.AuthGb }, { "UserCat" , vm.UserCat }, { "SearchText", vm.SearchText }, { "PageRowSize", vm.PageRowSize }
            };

            return View(vm);
		}

		[Route("Member/{param1}")]
		public ActionResult Member(OcwViewModel vm)
		{
			ModelState.Clear();
			vm.PageRowSize = vm.PageRowSize ?? 5;
			vm.PageNum = vm.PageNum ?? 1;

			vm.UserNo = (Request.QueryString["search"] != null) ? Convert.ToInt64(Request.QueryString["search"].ToString()) : vm.UserNo;

			//유저 카테고리 조회
			bool addDefualt = true;
			vm.OcwUserCat = new OcwUserCategory();
			vm.OcwUserCat.UserNo = vm.UserNo;
			vm.OcwUserCatList = baseSvc.GetList<OcwUserCategory>("ocw.OCW_USERCAT_SELECT_A", vm.OcwUserCat);
			var cat = vm.OcwUserCatList.Where(w => w.CatCode == 0).FirstOrDefault();
			if (!addDefualt && cat != null)
			{
				vm.OcwUserCatList.Remove(cat);
			}

			//OCW 테마조회
			vm.OcwTheme = new OcwTheme();
			vm.OcwTheme.IsAdmin = 0; //0 : 아니오, 1 : 관리자전용
			vm.OcwTheme.IsOpen = 1; //0 : 비공개, 1 : 공개
			vm.OcwThemeList = baseSvc.GetList<OcwTheme>("ocw.OCW_THEME_SELECT_L", vm.OcwTheme);

			//개인별 OCW 조회
			Hashtable ht = new Hashtable();

			vm.Ocw = new Ocw();
			vm.UserCat = string.IsNullOrEmpty(vm.UserCat) ? "-1" : vm.UserCat; // -1일 경우 전체 조회

			vm.Ocw.IsAuth = 2;  //0: (검토중)미승인, 1: 거절, 2: 승인
			vm.Ocw.IsOpen = 1;  //0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시)

			ht.Add("IsAuth", vm.Ocw.IsAuth);
			ht.Add("IsOpen", vm.Ocw.IsOpen);
			ht.Add("OcwUserNo", vm.UserNo);
			ht.Add("SortValue", "NEWEST");
			ht.Add("CatCode", Convert.ToInt32(vm.UserCat));
			ht.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			ht.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.OcwList = baseSvc.GetList<Ocw>("ocw.OCW_SELECT_L", ht);
			foreach (var ocw in vm.OcwList)
			{
				ocw.AssignNamePath = ConvertOutputValue(ocw.AssignNamePath).Replace('|', '>');
			}
			vm.Ocw.OcwAllCount = vm.PageTotalCount = vm.OcwList.FirstOrDefault() == null ? 0 : vm.OcwList.FirstOrDefault().OcwAllCount;

			//사용자 정보 조회
			if(vm.UserNo != 0)
            {
				Hashtable paramHash = new Hashtable();
				paramHash.Add("UserNo", vm.UserNo);
				vm.Ocw.OcwUserNm = baseSvc.Get<User>("account.USER_SELECT_S", paramHash).HangulName;
            }

			//페이징관련
			vm.Dic = new RouteValueDictionary
            {
				{ "search", vm.UserNo}, { "UserCat" , vm.UserCat }, { "PageRowSize", vm.PageRowSize }
            };


            return View(vm);
		}

		[Route("OcwReg/{param1}")]
		public ActionResult OcwReg(OcwViewModel vm, int? param1)
		{
			Int64 userNo = sessionManager.UserNo;
			string sessionUserType = sessionManager.UserType;

			bool isStud = (sessionUserType == "USRT001" || sessionUserType == "USRT002"); //학부생이거나 대학원생

			//콘텐츠 종류, 콘텐츠 등록방식, 공개설정 공통코드 조회
			Code code = new Code("A", new string[] { "CTKD", "CTRB", "OPGB"});
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			if (isStud)
			{				
				vm.BaseCode = vm.BaseCode.Where(x => !x.CodeValue.Equals("OPGB002") && !x.CodeValue.Equals("OPGB003")).ToList();
			}

			//관련학과 조회
			Assign assign = new Assign();
			vm.AssignList = baseSvc.GetList<Assign>("common.COMMON_DEPT_SELECT_L", assign);

			//OCW 테마조회
			vm.OcwTheme = new OcwTheme();
			vm.OcwTheme.IsAdmin = 0; //0 : 아니오, 1 : 관리자전용
			vm.OcwTheme.IsOpen = 1; //0 : 비공개, 1 : 공개
			vm.OcwThemeList = ocwSvc.GetOcwThemeList(vm.OcwTheme);


			//수정으로 들어올때
			vm.Ocw = new Ocw();
			Int64 ocwNo = Convert.ToInt64(param1);
			if(ocwNo > 1)
            {
				vm.Ocw = ocwSvc.GetOcw(ocwNo);

				if(vm.Ocw.OcwType == 0 && vm.Ocw.OcwSourceType == 4)
				{
					vm.XIDstart = vm.Ocw.OcwData;
				}

				//연계 콘텐츠 조회
				vm.LinkOcwList = ocwSvc.GetLinkOcw(ocwNo);				
			}

			//modal용 나의 OCW 조회			
			Hashtable ht = new Hashtable();
			
			vm.UserCat = string.IsNullOrEmpty(vm.UserCat) ? "-1" : vm.UserCat; // -1일 경우 전체 조회

			ht.Add("IsAuth", 2); //승인
			ht.Add("IsOpen", 1); //공개
			ht.Add("OcwUserNo", sessionManager.IsAdmin ? vm.Ocw.CreateUserNo : userNo);
			ht.Add("ViewUserNo", sessionManager.IsAdmin ? vm.Ocw.CreateUserNo : userNo);
			ht.Add("SearchText", vm.SearchText);
			ht.Add("CatCode", Convert.ToInt32(vm.UserCat));
			vm.OcwList = baseSvc.GetList<Ocw>("ocw.OCW_SELECT_B", ht);

			//폴더 조회
			vm.Ocw.CreateUserNo = ocwNo > 1 ? vm.Ocw.CreateUserNo : userNo;

			vm.OcwUserCat = new OcwUserCategory();
			vm.OcwUserCat.RowState = "A";
			vm.OcwUserCat.UserNo = sessionManager.IsAdmin ? vm.Ocw.CreateUserNo : userNo;
			bool addDefualt = true;

			vm.OcwUserCatList = ocwSvc.GetUserCategory(vm.OcwUserCat, vm.OcwUserCat.RowState, addDefualt);


			//썸네일 가져오기
			if (vm.Ocw.ThumFileGroupNo > 0 )
            {
				File file = new File();
				file.FileGroupNo = vm.Ocw.ThumFileGroupNo ?? 0;
				if (vm.Ocw.ThumFileGroupNo != null)
					vm.ThumFileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
				else
					vm.ThumFileList = null;
			}

			//파일 가져오기
			if(vm.Ocw.OcwFileGroupNo > 0)
            {
				File file = new File();
				file.FileGroupNo = vm.Ocw.OcwFileGroupNo ?? 0;
				if (vm.Ocw.OcwFileGroupNo != null)
				{
					if (vm.Ocw.OcwSourceType == 3)
					{
						vm.MP4FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					}
					if (vm.Ocw.OcwSourceType == 4)
					{
						vm.HTMLFileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					}
					if (vm.Ocw.OcwSourceType == 5)
					{
						vm.BasicFileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					}
				}

                else
                {
					vm.MP4FileList = vm.HTMLFileList = vm.BasicFileList = null;
                }
			}

			string ocwDelPossibleYN = "N";
            if (vm.Ocw.OcwNo > 0)
                ocwDelPossibleYN = ocwSvc.GetOcwDelPossibleYN(ocwNo);
            vm.Ocw.OcwDeletePossibleYN = ocwDelPossibleYN;

			return View(vm);
		}

		[Route("OcwCourse/{param1}")]
		public ActionResult OcwCourse(OcwViewModel vm, int? param1)
		{
			Int64 userNo = sessionManager.UserNo;
			int ocwNo = Convert.ToInt32(param1);

			//중요도 공통코드 조회
			Code code = new Code("A", new string[] { "IMPT" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			//OCW 기본정보
			Hashtable ht = new Hashtable();
			ht.Add("OcwNo", ocwNo);
			ht.Add("ViewUserNo", userNo);
			vm.Ocw = baseSvc.Get<Ocw>("ocw.OCW_SELECT_S", ht);

			//현재 학기 바인딩
			vm.TermList = new List<Term>();
			vm.TermList = ocwSvc.GetTermList(new Term("L")).OrderByDescending(w => w.TermYear).ToList();

			//강의연계 현황 조회
			vm.CourseList = new List<Course>();
			Hashtable ht2 = new Hashtable();
			ht2.Add("OcwNo", vm.Ocw.OcwNo);
			ht2.Add("TermNo", vm.TermNo);

			vm.OcwCourseList = baseSvc.GetList<OcwCourse>("ocw.OCW_COURSE_SELECT_A", ht2);

			return View(vm);
		}

		[Route("MyOpinion/{param1}")]
		public ActionResult MyOpinion(OcwViewModel vm)
		{
			ModelState.Clear();
			Int64 userNo = sessionManager.UserNo;
			Hashtable ht = new Hashtable();

			ht.Add("UserNo", userNo);

			vm.OcwOpinionList = baseSvc.GetList<OcwOpinion>("ocw.OCW_OPINION_SELECT_S", ht); 
			
			return View(vm);
		}

		[Route("WeekList/{param1}")]
		public ActionResult WeekList(OcwViewModel vm, int param1)
		{
			ModelState.Clear();
			int CourseNo = param1;

			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", CourseNo);

			vm.OcwCourseList = baseSvc.GetList<OcwCourse>("ocw.OCW_COURSE_WEEK_SELECT_A", ht);

			return View(vm);
		}

		[Route("WeekListSub/{param1}")]
		public ActionResult WeekListSub(OcwViewModel vm, int param1)
		{
			int CourseNo = param1;

			return WeekList(vm, CourseNo);
		}

		[Route("WeekDetail/{param1}")]
		public ActionResult WeekDetail(OcwViewModel vm, int param1)
		{
			ModelState.Clear();

			int CourseNo = param1;
			vm.OcwCourse = new OcwCourse();
			vm.OcwCourse.Week = Convert.ToInt32(Request.QueryString["week"] ?? vm.OcwCourse.Week.ToString());
						
			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", CourseNo);
			ht.Add("Week", vm.OcwCourse.Week);

			vm.OcwCourse = baseSvc.Get<OcwCourse>("ocw.OCW_COURSE_WEEK_SELECT_A", ht);


			//학습OCW 리스트 조회
			int CCStatus = 2; //연계상태(0 : 검토중 , 1 : 거절, 2 : 승인)
			string CreateUserType = null;
			int NotCCStatus = -1;

			vm.OcwCourseList = ocwSvc.GetOcwCourseList(CourseNo, CCStatus, CreateUserType, vm.OcwCourse.Week, NotCCStatus);

			//학습OCW 주차별 학습의견 조회
			vm.OcwOpinion = new OcwOpinion();
			Hashtable ht2 = new Hashtable();
			
			ht2.Add("CourseNo", CourseNo);
			ht2.Add("Week", vm.OcwCourse.Week);

			vm.OcwOpinionList = baseSvc.GetList<OcwOpinion>("ocw.OCW_OPINION_SELECT_A", ht2);

			vm.OcwOpinion.OpinionTotalCount = vm.OcwOpinionList.FirstOrDefault() != null ? vm.OcwOpinionList.FirstOrDefault().OpinionTotalCount : 0;

			Term term = new Term("B");
			term.CourseNo = CourseNo;
			vm.CurrentTermYn = baseSvc.Get<Term>("term.TERM_SELECT_B", term).CurrentTermYn;

			return View(vm);
		}

		[Route("LectureRoom/{param1}")]
		public ActionResult LectureRoom(OcwViewModel vm, int param1)
		{
			ModelState.Clear();
			Int64 userNo = sessionManager.UserNo;

			//중요도 공통코드 조회
			Code code = new Code("A", new string[] { "IMPT" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			int CourseNo = param1;
			int CCStatus = 2; //연계상태(0 : 검토중 , 1 : 거절, 2 : 승인)
			
			vm.OcwCourseList = ocwSvc.GetOcwCourseList(CourseNo, CCStatus);

			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", CourseNo);

			vm.WeekList = baseSvc.GetList<Inning>("common.COURSE_WEEK_SELECT_A", ht);

			//OCW 리스트 조회
			Hashtable ht2 = new Hashtable();

			vm.Ocw = new Ocw();
			vm.UserCat = string.IsNullOrEmpty(vm.UserCat) ? "-1" : vm.UserCat; // -1일 경우 전체 조회
			ht2.Add("ViewUserNo", userNo);
			ht2.Add("SearchText", vm.SearchText);
			ht2.Add("CatCode", Convert.ToInt32(vm.UserCat));
			vm.OcwList = baseSvc.GetList<Ocw>("ocw.OCW_SELECT_B", ht2);


			return View(vm);
		}

		[Route("ProfOcwAuth/{param1}")]
		public ActionResult ProfOcwAuth(OcwViewModel vm, int param1)
		{
			ModelState.Clear();			

			//연계여부 공통코드 조회
			Code code = new Code("A", new string[] { "CCST" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
			
			int CourseNo = param1;
			
			string CreateUserType = "USRT001";
			vm.CCStatus = string.IsNullOrEmpty(vm.CCStatus) ? "-1" : vm.CCStatus;
			int CCStatus = Convert.ToInt32(vm.CCStatus); //연계상태(0 : 검토중 , 1 : 거절, 2 : 승인) -1일 경우 전체조회

			vm.OcwCourseList = ocwSvc.GetOcwCourseList(CourseNo, CCStatus, CreateUserType);

			return View(vm);
		}

		[Route("Select")]
		public ActionResult Select(OcwViewModel vm)
		{
			ModelState.Clear();

			ViewBag.CurrentMenuTitle = "OCW 선택";
			Int64 userNo = sessionManager.UserNo;

			vm.PageRowSize = vm.PageRowSize ?? 5;
			vm.PageNum = vm.PageNum ?? 1;

			//유저 카테고리 조회
			vm.OcwUserCat = new OcwUserCategory();
			vm.OcwUserCat.RowState = "B";
			vm.OcwUserCat.UserNo = userNo;
			bool addDefualt = true;

			vm.OcwUserCatList = ocwSvc.GetUserCategory(vm.OcwUserCat, vm.OcwUserCat.RowState, addDefualt);


			//OCW 조회		
			Hashtable ht = new Hashtable();

			vm.Ocw = new Ocw();
			vm.UserCat = string.IsNullOrEmpty(vm.UserCat) ? "-1" : vm.UserCat; // -1일 경우 전체 조회

			ht.Add("ViewUserNo", userNo);
			ht.Add("OcwUserNo", userNo);
			ht.Add("SearchText", vm.SearchText);
			ht.Add("CatCode", Convert.ToInt32(vm.UserCat));
			ht.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			ht.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.OcwList = baseSvc.GetList<Ocw>("ocw.OCW_SELECT_B", ht);
			vm.PageTotalCount = vm.OcwList.FirstOrDefault() == null ? 0 : vm.OcwList.FirstOrDefault().TotalCount;

			//페이징관련
			vm.Dic = new RouteValueDictionary
			{
				{ "UserCat" , vm.UserCat },  { "SearchText", vm.SearchText }, { "PageRowSize", vm.PageRowSize }
			};

			return View(vm);
		}

		[Route("Copy/{param1}")]
		public ActionResult Copy(OcwViewModel vm, int param1)
		{
			ModelState.Clear();
			Int64 userNo = sessionManager.UserNo;

			ViewBag.CurrentMenuTitle = "이전강의정보 가져오기";

			int courseNo = param1;

			//선택된 학기 직전학기까지 조회
			Hashtable ht = new Hashtable();
			ht.Add("CourseNo", courseNo);

			vm.TermList = baseSvc.GetList<Term>("term.TERM_SELECT_D", ht);

			//선택된 강좌정보
			Course paramCourseB = new Course();
			paramCourseB.CourseNo = courseNo;
			paramCourseB.UserNo = userNo;

			vm.Course = baseSvc.Get<Course>("course.COURSE_SELECT_B", paramCourseB);
			
			//강좌정보의 학수번호와 동일한 강의리스트 가져오기
			if(vm.TermList.Count > 0 && vm.Course != null)
			{
				vm.TermNo = vm.TermNo < 1 ? vm.TermList.FirstOrDefault().TermNo : vm.TermNo;

				Hashtable ht2 = new Hashtable();
				ht2.Add("HaksuNo", vm.Course.HaksuNo);
				ht2.Add("UserNo", userNo);

				vm.CourseList = baseSvc.GetList<Course>("course.COURSE_PROFESSOR_SELECT_C", ht2).Where(w => w.TermNo == vm.TermNo).ToList();

			}
			return View(vm);
		}

		[Route("OcwPopup/{param1}")]
		public ActionResult OcwPopup(OcwViewModel vm, int param1)
		{
			ModelState.Clear();
			
			return Detail(vm, param1);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListAdmin")]
		public ActionResult ListAdmin(OcwViewModel vm)
		{
			ModelState.Clear();

			vm.OcwThemeSel = vm.OcwThemeSel ?? "%";
			vm.AssignSel = vm.AssignSel ?? "%";
			vm.IsOpen = vm.IsOpen ?? -1;

			vm.PageRowSize = vm.PageRowSize ?? 50;
			vm.PageNum = vm.PageNum ?? 1;

			//정렬순, 공개여부 공통코드 조회
			Code code = new Code("A", new string[] { "SRTN", "OPGB" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);
			vm.OcwSort = vm.OcwSort ?? vm.BaseCode.Where(w => w.ClassCode == "SRTN").FirstOrDefault().CodeValue;

			//OCW 테마조회
			vm.OcwTheme = new OcwTheme();
			vm.OcwTheme.IsAdmin = null; //0 : 아니오, 1 : 관리자전용 -> null일경우 전체 조회
			vm.OcwTheme.IsOpen = null; //0 : 비공개, 1 : 공개 -> null일경우 전체 조회

			vm.OcwThemeList = ocwSvc.GetOcwThemeList(vm.OcwTheme);

			//전공 조회
			Assign assign = new Assign();
			vm.AssignList = baseSvc.GetList<Assign>("common.COMMON_DEPT_SELECT_L", assign);

			//OCW 리스트조회
			vm.Ocw = new Ocw();

			string sortParam = string.Empty;
			switch (vm.OcwSort)
			{
				case "SRTN001":
					sortParam = "NEWEST";
					break;
				case "SRTN002":
					sortParam = "USING";
					break;
				case "SRTN003":
					sortParam = "LIKE";
					break;

			}
			
			string ThemeNo = vm.OcwThemeSel;
			string AssignNo = vm.AssignSel;
			int? IsAuth = null; // 0: (검토중)미승인, 1: 거절, 2: 승인 -> null일 경우 전체 조회	
			int? IsOpen = vm.IsOpen == -1 ? null : vm.IsOpen; //0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시) -> null일 경우 전체 조회
			string SearchText = vm.SearchText;
			int? FirstIdx = FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum));
			int? LastIdx = LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum));

			vm.OcwList = ocwSvc.GetOcwList(ThemeNo, AssignNo, sortParam, IsAuth, IsOpen, SearchText, FirstIdx, LastIdx);

			foreach (var ocw in vm.OcwList)
			{
				ocw.AssignNamePath = ConvertOutputValue(ocw.AssignNamePath).Replace('|', '>');
			}
			vm.Ocw.OcwAllCount = vm.PageTotalCount = vm.OcwList.FirstOrDefault() == null ? 0 : vm.OcwList.FirstOrDefault().OcwAllCount;

			//페이징관련
			vm.Dic = new RouteValueDictionary
			{
				{ "OcwThemeSel" , vm.OcwThemeSel }
				, { "OcwAssignSel" , vm.AssignSel }
				, { "IsOpen", vm.IsOpen }				
				, { "OcwSort" , vm.OcwSort }
				, { "SearchText", vm.SearchText }
				, { "PageRowSize", vm.PageRowSize }
			};

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("WriteAdmin/{param1}")]
		public ActionResult WriteAdmin(OcwViewModel vm, int param1)
		{
			ModelState.Clear();

			return OcwReg(vm, param1);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("CourseListAdmin/{param1}")]
		public ActionResult CourseListAdmin(OcwViewModel vm, int param1)
		{
			ModelState.Clear();

			Int64 userNo = sessionManager.UserNo;
			int ocwNo = param1;

			//OCW 기본정보
			Hashtable ht = new Hashtable();
			ht.Add("OcwNo", ocwNo);
			ht.Add("ViewUserNo", userNo);
			vm.Ocw = baseSvc.Get<Ocw>("ocw.OCW_SELECT_S", ht);

			//학기 리스트
			vm.TermList = new List<Term>();
			vm.TermList = ocwSvc.GetTermList(new Term("L")).OrderByDescending(w => w.TermYear).ToList();

			//현재 학기
			vm.TermNo = vm.TermNo > 0 ? vm.TermNo : baseSvc.Get<int>("term.TERM_SELECT_C", new Term());

			//강의연계 조회
			vm.OcwCourse = new OcwCourse();

			Hashtable ht2 = new Hashtable();
			ht2.Add("OcwNo", ocwNo);
			ht2.Add("TermNo", vm.TermNo);

			vm.OcwCourseList = baseSvc.GetList<OcwCourse>("ocw.OCW_COURSE_SELECT_A", ht2);

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListAcceptAdmin/{param1}")]
		public ActionResult ListAcceptAdmin(OcwViewModel vm, int param1)
		{
			ModelState.Clear();

			vm.PageRowSize = vm.PageRowSize ?? 50;
			vm.PageNum = vm.PageNum ?? 1;

			vm.IsAuth = vm.IsAuth ?? -1;

			//연계여부 공통코드 조회
			Code code = new Code("A", new string[] { "CCST" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			string ThemeNo = null;
			string AssignNo = null;
			string sortParam = "NEWEST";
			int? IsAuth = vm.IsAuth == -1 ? null : vm.IsAuth; //0: (검토중)미승인, 1: 거절, 2: 승인
			int? IsOpen = null; 
			string SearchText = null;
			int? FirstIdx = FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum));
			int? LastIdx = LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum));
			
			vm.OcwList = ocwSvc.GetOcwList(ThemeNo, AssignNo, sortParam, IsAuth, IsOpen, SearchText, FirstIdx, LastIdx);

			return View(vm);
		}

		[Route("ThemeList")]
		public ActionResult ThemeList(OcwViewModel vm)
		{
			ModelState.Clear();

			//OCW 테마조회
			vm.OcwTheme = new OcwTheme();
			vm.OcwTheme.IsAdmin = null; //0 : 아니오, 1 : 관리자전용
			vm.OcwTheme.IsOpen = null; //0 : 비공개, 1 : 공개
			vm.OcwThemeList = ocwSvc.GetOcwThemeList(vm.OcwTheme);

			return View(vm);
		}

		[Route("ThemeWrite/{param1}")]
		public ActionResult ThemeWrite(OcwViewModel vm, int param1)
		{
			ModelState.Clear();

			int themeNo = param1;

			//관리자전용, 공개여부 공통코드 조회
			Code code = new Code("A", new string[] { "ADYN", "OPYN" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			if (themeNo < 1) //신규
			{
				vm.OcwTheme = new OcwTheme();
			}
			else //수정
			{
				vm.OcwTheme = new OcwTheme();

				vm.OcwTheme.ThemeNo = themeNo;
				vm.OcwTheme = baseSvc.Get<OcwTheme>("ocw.OCW_THEME_SELECT_S", vm.OcwTheme);
			}

			return View(vm);
		}

		[Route("CommonList")]
		public ActionResult CommonList(OcwViewModel vm)
		{
			ModelState.Clear();
			//Int64 ocwNo = vm.Ocw.OcwNo;

			//return View("Ocw", vm);
			return View();
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("Statistics")]
		public ActionResult Statistics(StatisticsViewModel vm)
		{
			vm.Year = vm.Year != null ? vm.Year : System.DateTime.Today.ToString("yyyy");

			Hashtable paramForStatistics = new Hashtable();
			paramForStatistics.Add("Year", vm.Year);

			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_OCW_SELECT_L", paramForStatistics);

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("OcwStatisticsExcel")]
		public ActionResult OcwStatisticsExcel(StatisticsViewModel vm)
		{
			Hashtable paramForExcel = new Hashtable();
			paramForExcel.Add("Year", vm.Year);
			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_OCW_SELECT_L", paramForExcel);

			string[] headers = new string[] { "구분", "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월", "소계"};
			string[] colums = new string[] { "OcwStatisticsGubun", "JanCnt", "FebCnt", "MarCnt", "AprCnt", "MayCnt", "JunCnt"
											, "JulCnt", "AguCnt", "SepCnt", "OctCnt", "NovCnt", "DecCnt", "TotalCount"};

			return ExportExcel(headers, colums, vm.StatisticsList, String.Format("컨텐츠통계{0}", DateTime.Now.ToString("yyyyMMdd")));
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("StatisticsUser")]
		public ActionResult StatisticsUser(StatisticsViewModel vm)
		{
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 공통코드
			Hashtable paramForCode = new Hashtable();
			paramForCode.Add("ClassCode", "USRT");

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", paramForCode).Where(c => c.CodeValue.Equals("USRT001") || c.CodeValue.Equals("USRT007")).ToList();

			// 년도, 월
			if (vm.Year == null)
			{
				vm.Year = System.DateTime.Today.ToString("yyyy");
			}
			if (vm.Month == null)
			{
				vm.Month = System.DateTime.Today.ToString("MM");
			}

			vm.Sort = vm.Sort != null ? vm.Sort : "COUNT";

			// 개인별 컨텐츠 기준 조회
			Hashtable paramForOcwUser = new Hashtable();
			paramForOcwUser.Add("UserType", vm.Gubun);
			paramForOcwUser.Add("Year", vm.Year);
			paramForOcwUser.Add("Month", vm.Month);
			paramForOcwUser.Add("Sort", vm.Sort);

			paramForOcwUser.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramForOcwUser.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));

			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_PERSONAL_SELECT_L", paramForOcwUser);

			// 페이징
			vm.PageTotalCount = vm.StatisticsList.FirstOrDefault() != null ? vm.StatisticsList.FirstOrDefault().TotalCount : 0;

			vm.Dic = new RouteValueDictionary
			{
				{ "Gubun" ,vm.Gubun }, { "Year" , vm.Year }, { "Month" , vm.Month }, { "Sort", vm.Sort }, { "PageRowSize", vm.PageRowSize }
			};

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("StatisticsPart")]
		public ActionResult StatisticsPart(StatisticsViewModel vm)
		{
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			// 공통코드
			Hashtable paramForCode = new Hashtable();
			paramForCode.Add("ClassCode", "USRT");

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", paramForCode).Where(c => c.CodeValue.Equals("USRT001") || c.CodeValue.Equals("USRT007")).ToList();


			if (vm.Year == null)
			{
				vm.Year = System.DateTime.Today.ToString("yyyy");
			}
			if (vm.Month == null)
			{
				vm.Month = System.DateTime.Today.ToString("MM");
			}

			vm.Sort = vm.Sort != null ? vm.Sort : "USING";

			Hashtable paramForPart = new Hashtable();
			paramForPart.Add("Year", vm.Year);
			paramForPart.Add("Month", vm.Month);
			paramForPart.Add("UserType", vm.Gubun);
			paramForPart.Add("Sort", vm.Sort);
			paramForPart.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramForPart.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));

			vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_PERSONAL_SELECT_A", paramForPart);

			// 페이징
			vm.PageTotalCount = vm.StatisticsList.FirstOrDefault() != null ? vm.StatisticsList.FirstOrDefault().TotalCount : 0;

			vm.Dic = new RouteValueDictionary
			{
				{ "Gubun" ,vm.Gubun }, { "Year" , vm.Year }, { "Month" , vm.Month }, { "Sort", vm.Sort }, { "PageRowSize", vm.PageRowSize }
			};

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("StatisticsExcel/{param1}/{param2}")]
		public ActionResult StatisticsExcel(StatisticsViewModel vm, int param1, string param2)
		{
			Hashtable paramForOcwUser = new Hashtable();
			paramForOcwUser.Add("UserType", vm.Gubun);
			paramForOcwUser.Add("Year", vm.Year);
			paramForOcwUser.Add("Month", vm.Month);
			paramForOcwUser.Add("Sort", vm.Sort);

			if (param2.Equals("U"))
			{
				vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_PERSONAL_SELECT_L", paramForOcwUser);

				string[] headers;
				string[] colums;

				if (vm.UnivYN().Equals("Y"))
				{
					headers = new string[] { "연번", "구분", "소속", "성명(" + WebConfigurationManager.AppSettings["StudIDText"].ToString() + ")", "콘텐츠 등록수", "누적 조회수", "누적 추천수" };
					colums = new string[] { "RowNum", "UserTypeName", "AssignName", "UserName", "OcwCount", "UsingCount", "LikeCount" };
				}
				else
				{
					headers = new string[] { "연번", "구분", "성명(" + WebConfigurationManager.AppSettings["StudIDText"].ToString() + ")", "콘텐츠 등록수", "누적 조회수", "누적 추천수" };
					colums = new string[] { "RowNum", "UserTypeName", "UserName", "OcwCount", "UsingCount", "LikeCount" };
				}

				return ExportExcel(headers, colums, vm.StatisticsList, String.Format("개인별컨텐츠_컨텐츠기준{0}", DateTime.Now.ToString("yyyyMMdd")));
			}
			else
			{
				vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_PERSONAL_SELECT_A", paramForOcwUser);

				string[] headers;
				string[] colums;

				if (vm.UnivYN().Equals("Y"))
				{
					headers = new string[] { "연번", "구분", "소속", "성명(" + WebConfigurationManager.AppSettings["StudIDText"].ToString() + ")", "콘텐츠 조회건수", "댓글 등록수", "추천 클릭수" };
					colums = new string[] { "RowNum", "UserTypeName", "AssignName", "UserName", "UsingCount", "OpinionCount", "LikeCount" };
				}
				else
				{
					headers = new string[] { "연번", "구분", "성명(" + WebConfigurationManager.AppSettings["StudIDText"].ToString() + ")", "콘텐츠 조회수", "댓글 등록수", "추천 클릭수" };
					colums = new string[] { "RowNum", "UserTypeName", "UserName", "UsingCount", "OpinionCount", "LikeCount" };
				}

				return ExportExcel(headers, colums, vm.StatisticsList, String.Format("개인별컨텐츠_참여기준{0}", DateTime.Now.ToString("yyyyMMdd")));
			}
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("OcwListExcel/{param1}/{param2}")]
		public ActionResult OcwListExcel(OcwViewModel vm, int param1)
		{
			//OCW 리스트조회
			vm.Ocw = new Ocw();
			vm.OcwThemeSel = vm.OcwThemeSel ?? "%";
			vm.AssignSel = vm.AssignSel ?? "%";

			string sortParam = string.Empty;
			switch (vm.OcwSort)
			{
				case "SRTN001":
					sortParam = "NEWEST";
					break;
				case "SRTN002":
					sortParam = "USING";
					break;
				case "SRTN003":
					sortParam = "LIKE";
					break;
			}

			vm.Ocw.IsOpen = vm.Ocw.IsOpen == -1 ? null : vm.Ocw.IsOpen; //0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시)

			string ThemeNo = vm.OcwThemeSel;
			string AssignNo = vm.AssignSel;
			int? IsAuth = null;
			int? IsOpen = vm.Ocw.IsOpen;
			string SearchText = vm.SearchText;
			int? FirstIndex = null;
			int? LastIndex = null;

			vm.OcwList = ocwSvc.GetOcwList(ThemeNo, AssignNo, sortParam, IsAuth, IsOpen, SearchText, FirstIndex, LastIndex);


			string[] headers = new string[] { "연번", "제목", "등록일", "작성자", "공개여부"};
			string[] colums = new string[] { "RowNum", "OcwName", "CreateDateTime", "CreateUserName", "OcwOpenName"};

			return ExportExcel(headers, colums, vm.OcwList, string.Format("OCW목록_{0}", DateTime.Now.ToString("yyyyMMdd")));
		}

		[Route("OcwView")]
		public ActionResult OcwView(OcwViewModel vm)
		{
			//vm.DV_SMP = "";
			vm.MidCheckSecond = 0;

			Hashtable hash = new Hashtable();
			hash.Add("OcwNo", vm.Ocw.OcwNo);
			vm.Ocw = baseSvc.Get<Ocw>("ocw.OCW_SELECT_S", hash);

			if ((Request["ISPOST"] ?? "N") != "Y")
			{
				ocwSvc.OcwViewHistory(vm.Ocw.OcwNo, sessionManager.UserNo);
			}

			//비공개(isOpen < 1)이거나 승인 이전단계(isAuth < 2)인 경우
			if (vm.Ocw.UserNo != sessionManager.UserNo && (vm.Ocw.IsOpen < 1 || vm.Ocw.IsAuth < 2))
			{
				vm.Ocw = vm.Ocw == null ? new Ocw() : vm.Ocw;
			}
			//공개 또는 강의전용, 승인 단계인 경우
			else
			{
				if (vm.Inning.InningNo > 0)
				{
					hash = new Hashtable();
					hash.Add("InningNo", vm.Inning.InningNo);
					hash.Add("UserNo", sessionManager.UserNo);
					vm.OcwByInning = baseSvc.Get<Hashtable>("course.COURSE_INNING_SELECT_M", hash);
					vm.StudyTime = baseSvc.Get<int>("course.STUDY_INNING_SELECT_B", hash);

					if (vm.OcwByInning != null)
					{
						if(vm.OcwByInning["LectureNo"] != null && Convert.ToInt32(vm.OcwByInning["LectureNo"].ToString()) > 0)
						{
							//차시시작일자~차시종료일자이고 출석(CLAT001)이 아닌경우
							if (DateTime.Now.Ticks > Convert.ToDateTime(vm.OcwByInning["InningStartDay"].ToString()).Ticks
								&& DateTime.Now.Ticks < Convert.ToDateTime(vm.OcwByInning["InningEndDay"].ToString()).AddDays(1).Ticks
								&& !vm.OcwByInning["AttendanceStatus"].ToString().Equals("CLAT001"))
							{
								vm.IsLog = true;
								vm.MidCheckSecond = !string.IsNullOrEmpty(vm.OcwByInning["MiddleAttendanceStartMinute"].ToString())
													&& !string.IsNullOrEmpty(vm.OcwByInning["MiddleAttendanceEndMinute"].ToString())
													&& vm.OcwByInning["StudyMiddleDateTime"] == null ? GetRandom(Convert.ToInt32(vm.OcwByInning["MiddleAttendanceStartMinute"].ToString()) * 60, Convert.ToInt32(vm.OcwByInning["MiddleAttendanceEndMinute"].ToString()) * 60, 0, 1) : 0;
								SetLearnLog(vm.OcwByInning);
							}
							//차시지각시작일자~차시지각종료일자이고 출석(CLAT001)이 아닌경우 : 지각은 
							else if (DateTime.Now.Ticks > Convert.ToDateTime(vm.OcwByInning["InningLatenessStartDay"].ToString()).Ticks
									&& DateTime.Now.Ticks < Convert.ToDateTime(vm.OcwByInning["InningLatenessEndDay"].ToString()).AddDays(1).Ticks
									&& !vm.OcwByInning["AttendanceStatus"].ToString().Equals("CLAT001"))
							{
								vm.IsLog = true;
								SetLearnLog(vm.OcwByInning);

								StudyLogAfter studyLogAfter = new StudyLogAfter("C");
								studyLogAfter.LectureNo = Convert.ToInt32(vm.OcwByInning["LectureNo"].ToString());
								studyLogAfter.InningNo = Convert.ToInt32(vm.OcwByInning["InningNo"].ToString());
								studyLogAfter.StudyDevice = Request.Browser.IsMobileDevice ? 2 : 1;
								studyLogAfter.LogUserAgent = Request.UserAgent;

								int logNo = baseSvc.Get<int>("course.STUDY_LOG_AFTER_SAVE_C", studyLogAfter);
								vm.AfterLogNo = logNo;
							}
							else
							{
								SetLearnLog(vm.OcwByInning);

								StudyLogAfter studyLogAfter = new StudyLogAfter("C");
								studyLogAfter.LectureNo = Convert.ToInt32(vm.OcwByInning["LectureNo"].ToString());
								studyLogAfter.InningNo = Convert.ToInt32(vm.OcwByInning["InningNo"].ToString());
								studyLogAfter.StudyDevice = Request.Browser.IsMobileDevice ? 2 : 1;
								studyLogAfter.LogUserAgent = Request.UserAgent;

								int logNo = baseSvc.Get<int>("course.STUDY_LOG_AFTER_SAVE_C", studyLogAfter);
								vm.AfterLogNo = logNo;
							}
						}
					}
				}
			}
			return View(vm);
		}

		public JsonResult StudyLogUpdate(int paramStudyInningNo, int paramLastPageNo, int paramTime, string paramHistoryData, int DayCnt = 0)
		{
			Hashtable param = new Hashtable();
			param.Add("StudyInningNo", paramStudyInningNo);
			StudyLog studyLog = baseSvc.Get<StudyLog>("course.STUDY_LOG_SELECT_S", param);

			if (studyLog != null)
			{
				studyLog.StudyTime = paramTime;
				studyLog.TotalStudyTime += paramTime;
				if (studyLog.StudyHistory == null)
				{
					studyLog.StudyHistory = DateTime.Now.ToString("yyyyMMdd") + "@" + paramLastPageNo.ToString() + ":" + paramTime.ToString() + ":" + (Request.Browser.IsMobileDevice ? "M" : "P");
				}
				else
				{
					bool isUpdate = false;
					string _hist = "";
					string _update = "";

					//같은날짜, 같은디바이스 면 시간만 늘려준다.
					foreach (var str in studyLog.StudyHistory.Split('#'))
					{
						_update = str;
						if (!isUpdate)
						{
							if (str.Split('@')[0].ToString() == DateTime.Now.ToString("yyyyMMdd"))
							{
								if (str.Split('@')[1].ToString().Split(':')[0].ToString() == paramLastPageNo.ToString() && str.Split('@')[1].ToString().Split(':')[2].ToString() == (Request.Browser.IsMobileDevice ? "M" : "P"))
								{
									_update = DateTime.Now.ToString("yyyyMMdd") + "@" + paramLastPageNo.ToString() + ":" + (Convert.ToInt32(str.Split('@')[1].ToString().Split(':')[1]) + paramTime).ToString() + ":" + (Request.Browser.IsMobileDevice ? "M" : "P");
									isUpdate = true;
								}
							}
						}
						_hist += _update + "#";
					}
					if (!isUpdate)
					{
						studyLog.StudyHistory += "#" + DateTime.Now.ToString("yyyyMMdd") + "@" + paramLastPageNo.ToString() + ":" + paramTime.ToString() + ":P";
					}
					else
					{
						studyLog.StudyHistory = _hist.Substring(0, _hist.Length - 1);
					}
				}

				studyLog.RowState = "U";
				int rs = studySvc.StudyLogSave(studyLog);
				if (rs > 0)
				{
					StudyInningUpdate(studyLog);
				}

				//학습상세 저장
				StudyLogHistory studyLogHistory = new StudyLogHistory();
				studyLogHistory.StudyInningNo = studyLog.StudyInningNo;
				studyLogHistory.StudyDevice = (Request.Browser.IsMobileDevice ? 2 : 1);
				studyLogHistory.UserNo = studyLog.StudyUserNo;
				studyLogHistory.StudyTime = paramTime;
				baseSvc.Save("course.STUDY_LOG_HISTORY_SAVE_U", studyLogHistory);
			}

			//학습완료여부값 반환 1 = 완료, 0 미완료
			Hashtable hash = new Hashtable();
			hash.Add("StudyInningNo", paramStudyInningNo);
			return Json(baseSvc.Get<int>("course.STUDY_INNING_SELECT_B", hash));
		}

		[Route("OcwLike")]
		public JsonResult OcwLike(Int64 ocwNo)
		{
			int cnt = 0;
			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();
			ht.Add("OcwNo", ocwNo);
			ht.Add("UserNo", userNo);

			cnt = baseSvc.Save("ocw.OCW_LIKE_SAVE_D", ht);

			if(cnt > 0)
			{
				cnt = -1;
			}
			else
			{
				cnt = baseSvc.Save("ocw.OCW_LIKE_SAVE_C", ht) > 0 ? 1 : 0;
			}

			return Json(cnt);
		}

		[Route("OcwPocet")]
		public JsonResult OcwPocket(Int64 ocwNo, int catCode)
		{
			int cnt = 0;
			Hashtable ht = new Hashtable();
			Int64 userNo = sessionManager.UserNo;

			ht.Add("OcwNo", ocwNo);
			ht.Add("CatCode", catCode);
			ht.Add("UserNo", userNo);

			cnt = baseSvc.Save("ocw.OCW_POCKET_SAVE_C", ht);

			return Json(cnt);
		}

		[Route("SaveOcwOpinion")]
		public JsonResult SaveOcwOpinion(OcwOpinion op)
		{
			int cnt;
			Int64 userNo = sessionManager.UserNo;

			op.UserNo = op.UpdateUserNo = userNo;

			if (op.OpinionNo < 1) //등록
			{
				cnt = baseSvc.Save("ocw.OCW_OPINION_SAVE_C", op);
			}
			else if (op.DeleteYesNo == "Y") //삭제
			{
				cnt = baseSvc.Save("ocw.OCW_OPINION_SAVE_D", op);
			}
			else //수정
			{
				cnt = baseSvc.Save("ocw.OCW_OPINION_SAVE_U", op);
			}

			return Json(cnt);
		}

		[Route("SaveOcwCourseOpinion")]
		public JsonResult SaveOcwCourseOpinion(OcwOpinion op)
		{

			//현재 학년도 학기 가져오기
			OcwViewModel vm = new OcwViewModel();
			vm.TermNo = vm.TermNo > 0 ? vm.TermNo : baseSvc.Get<int>("term.TERM_SELECT_C", new Term());

			int cnt;
			Int64 userNo = sessionManager.UserNo;

			op.UserNo = op.UpdateUserNo = userNo;


			if (op.OpinionNo < 1) //등록
			{
				cnt = baseSvc.Save("ocw.OCW_COURSE_OPINION_SAVE_C", op);
			}
			else if (op.DeleteYesNo == "Y") //삭제
			{
				cnt = baseSvc.Save("ocw.OCW_COURSE_OPINION_SAVE_D", op);
			}
			else //수정
			{
				cnt = baseSvc.Save("ocw.OCW_COURSE_OPINION_SAVE_U", op);
			}

			return Json(cnt);
		}

		public JsonResult GetCourse(int TermNo)
		{
			Int64 userNo = sessionManager.UserNo;

			OcwViewModel vm = new OcwViewModel();
			
			vm.Course = new Course();
			vm.CourseList = new List<Course>();

			vm.Course.TermNo = TermNo;
			vm.Course.UserNo = userNo;

			vm.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_C", vm.Course);

			return Json(vm.CourseList);
		}

		public JsonResult GetWeek(int CourseNo)
		{
			OcwViewModel vm = new OcwViewModel();

			vm.Inning = new Inning();
			vm.WeekList = new List<Inning>();

			vm.Inning.CourseNo= CourseNo;

			vm.WeekList = baseSvc.GetList<Inning>("common.COURSE_WEEK_SELECT_L", vm.Inning);
			return Json(vm.WeekList);
		}

		public JsonResult AddCourse(int CourseNo, Int64 OcwNo, int Impt, int Week, int OrgWeek = 0, string OcwReName = null)
		{			
			int cnt;
			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();
			ht.Add("UpdateUserNo", userNo);
			ht.Add("IsImportant", Impt);
			ht.Add("OcwNo", OcwNo);
			ht.Add("CourseNo", CourseNo); 
			ht.Add("Week", Week);
			ht.Add("OcwReName", OcwReName);

			cnt = baseSvc.Save("ocw.OCW_COURSE_SAVE_C", ht);
			
			if(cnt > 0 && OrgWeek > 0 && Week != OrgWeek)
			{
				ht.Add("OrgWeek", OrgWeek);
				int DelCnt = baseSvc.Save("ocw.OCW_COURSE_SAVE_D", ht);
			}

			return Json(cnt);
		}

		public JsonResult DeleteCourse(Int64 OcwNo, int CourseNo, int Week)
		{
			int cnt;
			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();
			ht.Add("UpdateUserNo", userNo);
			ht.Add("OcwNo", OcwNo);
			ht.Add("CourseNo", CourseNo);
			ht.Add("Week", Week);
			
			cnt = baseSvc.Save("ocw.OCW_COURSE_SAVE_A", ht);

			return Json(cnt);
		}

		public JsonResult ChangeOcwCat(OcwPocket op)
		{
			int cnt;
			op.UserNo = op.UpdateUserNo = sessionManager.UserNo;

			cnt = baseSvc.Save("ocw.OCW_POCKET_SAVE_U", op);

			return Json(cnt);
		}

		public JsonResult DeleteOcwCat(OcwPocket op)
		{
			int cnt;
			op.UserNo = op.UpdateUserNo = sessionManager.UserNo;

			cnt = baseSvc.Save("ocw.OCW_POCKET_SAVE_D", op);

			return Json(cnt);
		}

		public JsonResult SaveCategory(OcwUserCategory ouc)
		{
			int cnt;
			ouc.UserNo = ouc.UpdateUserNo = sessionManager.UserNo;

			if(ouc.CatCode < 0)
            {
				cnt = baseSvc.Save("ocw.OCW_USERCAT_SAVE_C", ouc);
			}
            else
            {
				cnt = baseSvc.Save("ocw.OCW_USERCAT_SAVE_U", ouc);
			}

			return Json(cnt);
		}

		public JsonResult DelCategory(OcwUserCategory ouc)
		{
			int cnt;
			ouc.UserNo = ouc.UpdateUserNo = sessionManager.UserNo;

			cnt = baseSvc.Save("ocw.OCW_USERCAT_SAVE_D", ouc);

			return Json(cnt);
		}

		public JsonResult GetOcwSourceType()
        {
			OcwViewModel vm = new OcwViewModel();

			//콘텐츠 종류 및 콘텐츠 등록방식 공통코드 조회
			Code code = new Code("A", new string[] { "CTRB" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			return Json(vm.BaseCode);
        }

		public JsonResult GetMyOcwList(string userCat, string searchText)
        {
			OcwViewModel vm = new OcwViewModel();
			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();

			ht.Add("IsAuth", 2); //승인
			ht.Add("IsOpen", 1); //공개
			ht.Add("OcwUserNo", sessionManager.IsAdmin ? vm.Ocw.CreateUserNo : userNo);
			ht.Add("ViewUserNo", sessionManager.IsAdmin ? vm.Ocw.CreateUserNo : userNo);
			ht.Add("SearchText", searchText);
			ht.Add("CatCode", Convert.ToInt32(userCat));
			vm.OcwList = baseSvc.GetList<Ocw>("ocw.OCW_SELECT_B", ht);

			return Json(vm.OcwList);
		}

		public JsonResult SaveOcwReg(OcwViewModel vm)
        {
			Int64 userNo = sessionManager.UserNo;
			string sessionUserType = sessionManager.UserType;

			bool isStud = sessionUserType == "USRT001" || sessionUserType == "USRT002"; //학부생이거나 대학원생

			if (vm.Ocw.OcwNo > 0 && isStud && ocwSvc.GetOcw(vm.Ocw.OcwNo).IsAuth == 2)
            {
				return Json(0);
            }

			Hashtable ht = new Hashtable();

			ht.Add("OcwNo", vm.Ocw.OcwNo);
			ht.Add("OcwName", vm.Ocw.OcwName);
			ht.Add("OcwType", vm.Ocw.OcwType);
			ht.Add("OcwSourceType", vm.Ocw.OcwSourceType);
			ht.Add("OcwData", Server.UrlDecode(System.Uri.UnescapeDataString(vm.Ocw.OcwData ?? "")));

			ht.Add("OcwWidth", (vm.Ocw.OcwType == 0 && vm.Ocw.OcwWidth < 100 ) ? 1000 : vm.Ocw.OcwWidth);
			ht.Add("OcwHeight", (vm.Ocw.OcwType == 0 && vm.Ocw.OcwHeight < 100) ? 650 : vm.Ocw.OcwHeight);
			ht.Add("AssignNo", WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "000" : vm.Ocw.AssignNo);
			if (WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? sessionUserType == "USRT007" : vm.Ocw.AssignNo != null && sessionUserType == "USRT007")
			{
				ht.Add("AuthAssignNo", WebConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "000" : vm.Ocw.AssignNo);
			}
			ht.Add("ThemeNos", vm.Ocw.ThemeNos);
			ht.Add("UserNo", vm.Ocw.UserNo > 0 ? vm.Ocw.UserNo : userNo);
			ht.Add("CatCode", vm.Ocw.CatCode);

			/*
			if (sessionUserType == "USRT007")
			{
				ht.Add("IsOpen", vm.Ocw.IsOpen); //공개여부(0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시))
				ht.Add("IsAuth", 2); //관리자승인여부(0: 검토(미승인), 1: 거절, 2: 승인)
			}
			else if (vm.Ocw.OcwNo < 1)
			{
				ht.Add("IsOpen", 0);
				ht.Add("IsAuth", 0);
				if (sessionUserType != "USRT007")
				{
					ht["IsOpen"] = 1;
				}
			}
			*/

			if (!isStud)
			{
				ht.Add("IsOpen", vm.Ocw.IsOpen); //공개여부(0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시))
				ht.Add("IsAuth", 2); //학부생이거나 대학원생이 아닐 경우 승인여부 승인으로 고정
			}
			else
			{
				ht.Add("IsOpen", 1); //공개여부(0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시))
				ht.Add("IsAuth", 0); //학부생이거나 대학원생일 경우 승인여부 검토로 고정
			}

			ht.Add("DescText", vm.Ocw.DescText ?? "");
			if (vm.Ocw.KWord != null)
			{
				vm.Ocw.KWord = vm.Ocw.KWord.StartsWith(",") ? vm.Ocw.KWord.Substring(1) : vm.Ocw.KWord;
				vm.Ocw.KWord = vm.Ocw.KWord.EndsWith(",") ? vm.Ocw.KWord.Substring(0, vm.Ocw.KWord.Length - 1) : vm.Ocw.KWord;
			}
			ht.Add("KWord", vm.Ocw.KWord);
			ht.Add("UpdateUserNo", userNo);
			ht.Add("UserUpdateDateTime", DateTime.Now);

			//파일관련
			bool fileSuccess = true; 
			bool thumFileSuccess = true; 
			
			long? fileGroupNo = 0;
			long? thumFileGroupNo = 0;


            if (vm.Ocw.OcwSourceType == 3)
            {
				fileGroupNo = (vm.Ocw.OcwFileGroupNo > 0 && Request.Files["MP4File"] == null) ? 
					vm.Ocw.OcwFileGroupNo : FileUpload("C", "OCW", vm.MP4FileGroupNo, "OcwFile", Request.Files["MP4File"]);
			}
            else if (vm.Ocw.OcwSourceType == 4)
            {
				fileGroupNo = (vm.Ocw.OcwFileGroupNo > 0 && Request.Files["HTMLFile"] == null) ?
					vm.Ocw.OcwFileGroupNo : FileUpload("C", "OCW", vm.HTMLFileGroupNo, "OcwFile", Request.Files["HTMLFile"]);

				ht.Add("XID", Request.Files["HTMLFile"].FileName.ToString());
				ht.Remove("OcwData");
				ht.Add("OcwData", vm.XIDstart);
			}
            else if (vm.Ocw.OcwSourceType == 5)
            {
				fileGroupNo = (vm.Ocw.OcwFileGroupNo > 0 && Request.Files["BasicFile"] == null) ? 
					vm.Ocw.OcwFileGroupNo : FileUpload("C", "OCW", vm.BasicFileGroupNo, "OcwFile", Request.Files["BasicFile"]);
			}

            ht.Add("OcwFileGroupNo", fileGroupNo);

            if (fileGroupNo <= 0)
                fileSuccess = false;

			if (vm.Ocw.ThumFileGroupNo > 0 && Request.Files["ThumbnailFile"] == null)
			{
				thumFileGroupNo = vm.Ocw.ThumFileGroupNo;
			}
			else
			{
				if (Request.Files["ThumbnailFile"].ContentLength.Equals(0))
				{
					thumFileGroupNo = vm.Ocw.ThumFileGroupNo;
				}
				else
				{
					thumFileGroupNo = FileUpload("C", "OCWThumbnail", vm.ThumFileGroupNo, "OcwThumbnailFile", Request.Files["ThumbnailFile"]);

				}
			}

			ht.Add("ThumFileGroupNo", thumFileGroupNo);

			//연관 OCW
			string linkOcw = vm.hdnLinkOcwNo ?? "";
			long ocwNo = 0;

			if (fileSuccess || thumFileSuccess)
            {
				ocwNo = ocwSvc.SaveOcw(ht, linkOcw);

				if (vm.Ocw.OcwSourceType == 4 && fileGroupNo != vm.Ocw.OcwFileGroupNo)
				{
					SaveHtmlOcw(ocwNo, fileGroupNo);
				}
			}

			return Json(ocwNo);
        }

		public JsonResult DeleteOcwReg(int OcwNo)
		{
			int delCnt;
			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();
			ht.Add("OcwNo", Convert.ToInt64(OcwNo));
			ht.Add("UserNo", userNo);

			delCnt = baseSvc.Save("ocw.OCW_SAVE_D", ht);

			return Json(delCnt);
		}

		public JsonResult DeleteOcw(string ChkVal)
		{
			int delCnt;
			Int64 userNo = sessionManager.UserNo;

			string OcwNos = ChkVal;

			Hashtable ht = new Hashtable();
			ht.Add("UserNo", userNo);
			ht.Add("OcwNos", OcwNos);

			delCnt = baseSvc.Save("ocw.OCW_SAVE_A", ht);

			return Json(delCnt);
		}

		public JsonResult AuthCourse(int CourseNo, string ChkVal, int Auth)
		{
			Int64 userNo = sessionManager.UserNo;

			int cnt = 0;
			string[] array = ChkVal.Split('|');

			for(int i = 0; i < array.Length; i++)
			{
				int ocwNo = Convert.ToInt32(array[i].Split('_')[0]);
				int week = Convert.ToInt32(array[i].Split('_')[1]);

				Hashtable ht = new Hashtable();
				ht.Add("UpdateUserNo", userNo);
				ht.Add("IsAuth", Auth);
				ht.Add("CourseNo", CourseNo);
				ht.Add("OcwNo", ocwNo);
				ht.Add("Week", week);

				cnt += baseSvc.Save("ocw.OCW_COURSE_SAVE_U", ht);
			}

			return Json(cnt);

		}
		
		public JsonResult GetCopyCourse(int CourseNo, int PreCourseNo)
		{
			Int64 userNo = sessionManager.UserNo;

			int cnt;
			Hashtable ht = new Hashtable();

			ht.Add("UpdateUserNo", userNo);
			ht.Add("CourseNo", CourseNo);
			ht.Add("PreCourseNo", PreCourseNo);

			cnt = baseSvc.Save("ocw.OCW_COURSE_SAVE_B", ht);
			
			return Json(cnt);
		}

		public JsonResult SaveOcwTheme(OcwTheme ot)
		{
			Int64 userNo = sessionManager.UserNo;
			ot.UpdateUserNo = userNo;
			
			int cnt = ocwSvc.SaveOcwTheme(ot);

			return Json(cnt);
		}

		public JsonResult SaveOcwAuth(string ChkVal, int Auth)
		{
			int cnt = 0;

			Int64 userNo = sessionManager.UserNo;
			string OcwNos = ChkVal;

			Hashtable ht = new Hashtable();
			ht.Add("OcwNos", OcwNos);
			ht.Add("UpdateUserNo", userNo);

			if (Auth == 1) //거절
			{
				cnt = baseSvc.Save("ocw.OCW_AUTH_SAVE_B", ht);
			}
			else if (Auth == 2) //승인
			{
				cnt = baseSvc.Save("ocw.OCW_AUTH_SAVE_A", ht);
			}

			return Json(cnt);
		}

		public JsonResult OcwViewHistory(Int64 OcwNo)
		{
			int cnt = 0;

			Int64 userNo = sessionManager.UserNo;

			cnt = ocwSvc.OcwViewHistory(OcwNo, userNo);

			return Json(cnt);
		}

		public JsonResult StudyMidCheck(int paramStudyInningNo)
		{
			Hashtable hash = new Hashtable();
			hash.Add("StudyInningNo", paramStudyInningNo);
			hash.Add("UserNo", sessionManager.UserNo);
			
			int rs = baseSvc.Save("course.STUDY_INNING_SAVE_H", hash);

			return this.Json(rs);
		}
	}
}