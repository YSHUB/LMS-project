using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsAdmin = true)]
	[RoutePrefix("Content")]
	public class ContentController : AdminBaseController
	{
		#region 배너관리

		[Route("BannerList")]
		public ActionResult BannerList(ContentViewModel vm)
		{
			vm.PageRowSize = vm.PageRowSize ?? 10;
			vm.PageNum = vm.PageNum ?? 1;
			
			Hashtable paramHash = new Hashtable();

			paramHash.Add("DisplayDay",null);
			paramHash.Add("DeleteYesNo", "N");
			paramHash.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramHash.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			vm.BannerList = baseSvc.GetList<Banner>("content.BANNER_SELECT_L", paramHash);

			vm.PageTotalCount = vm.BannerList.FirstOrDefault() != null ? vm.BannerList.FirstOrDefault().TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize } };

			return View(vm);
		}


		[Route("BannerWrite/{param1}")]
		public ActionResult BannerWrite(ContentViewModel vm,  int? param1)
		{
			Hashtable paramHash = new Hashtable();

			paramHash.Add("BannerNo", param1 ?? 0);
			paramHash.Add("DisplayDay", null);
			paramHash.Add("DeleteYesNo", "N");

			vm.Banner = baseSvc.Get<Banner>("content.BANNER_SELECT_S", paramHash);

			long? fileGroupNo = vm.Banner != null ? vm.Banner.FileGroupNo > 0 ? (long?)vm.Banner.FileGroupNo : 0 : 0;

			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fileGroupNo);
			htFile.Add("DeleteYesNo", "N");
			if (fileGroupNo != null)
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", htFile);
			else
				vm.FileList = null;

			return View(vm);
		}
		
		[HttpPost]
		[Route("BannerWrite")]
		public string BannerWrite(ContentViewModel vm)
		{
			
			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long? fileGroupNo = 0;

			#region "파일관련"
			int fileCnt = 0;
			for (int i = 0; i < Request.Files.Count; i++)
			{
				if (Request.Files[i].ContentLength != 0)
					fileCnt++;
			}
			if (fileCnt > 0)
			{
				fileGroupNo = FileUpload(vm.Banner.RowState ?? "C", "Banner", vm.Banner.FileGroupNo, "BannerFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}

			#endregion "파일관련"

			if (fileSuccess) //파일 업로드 성공 시 게시물을 저장함
			{
				Hashtable paramHash = new Hashtable();
				string RowState = (vm.Banner.BannerNo == 0 ? "C" : "U");

				paramHash.Add("BannerNo"	, vm.Banner.BannerNo);
				paramHash.Add("BannerExplain" , vm.Banner.BannerExplain);
				paramHash.Add("StartDay"	, vm.Banner.StartDay);
				paramHash.Add("EndDay"		, vm.Banner.EndDay);
				paramHash.Add("LinkUrl"		, vm.Banner.LinkUrl);
				paramHash.Add("SortNo"		, vm.Banner.SortNo);
				paramHash.Add("BannerType"	, vm.Banner.BannerType);
				paramHash.Add("FileGroupNo" , vm.Banner.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo);
				paramHash.Add("OutputYesNo" , (vm.Banner.OutputYesNo ?? "N").Equals("Y") ? "Y" : "N");
				paramHash.Add("CreateUserNo", sessionManager.UserNo);
				paramHash.Add("UpdateUserNo", sessionManager.UserNo);
				paramHash.Add("DeleteYesNo" , "N");
				paramHash.Add("LinkType"	, vm.Banner.LinkType);

				baseSvc.Save("content.BANNER_SAVE_" + RowState, paramHash);
			}
			return "<script> opener.fnCompleteAdd(); self.close();</script>";
		}

		public JsonResult BannerDeleteAjax(int paramBannerNo)
		{
			int cnt = 0;
			Hashtable paramHash = new Hashtable();
		
			paramHash.Add("RowState", "D");
			paramHash.Add("BannerNo", paramBannerNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);
			paramHash.Add("DeleteYesNo", "Y");

			cnt = baseSvc.Save("content.BANNER_SAVE_D", paramHash);

			return Json(cnt);
		}

        #endregion

        #region 관련사이트관리

        [Route("FamilySiteList")]
		public ActionResult FamilySiteList(ContentViewModel vm)
		{
			vm.FamilySiteList = baseSvc.GetList<FamilySite>("content.FAMILYSITE_SELECT_A","");
			return View(vm);
		}

		[Route("FamilySiteWrite/{param1}")]
		public ActionResult FamilySiteWrite(ContentViewModel vm , int? param1)
		{
			Hashtable paramHash = new Hashtable();

			paramHash.Add("SiteNo"  , param1);
			vm.FamilySite = baseSvc.Get<FamilySite>("content.FAMILYSITE_SELECT_S", paramHash);

			return View(vm);
		}

		[HttpPost]
		[Route("FamilySiteWrite")]
		public string FamilySiteWrite(ContentViewModel vm)
		{
			Hashtable paramHash = new Hashtable();

			paramHash.Add("QuickNo", vm.FamilySite.SiteNo);
			paramHash.Add("QuickName", vm.FamilySite.SiteName);
			paramHash.Add("Url", vm.FamilySite.SiteUrl);
			paramHash.Add("DisplayOrder", vm.FamilySite.DisplayOrder);
			paramHash.Add("CreateUserNo", sessionManager.UserNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);
			paramHash.Add("OutputYesNo", (vm.FamilySite.OutputYesNo ?? "N").Equals("Y") ? "Y" : "N");
			paramHash.Add("DeleteYesNo", "N");

			baseSvc.Save("content.FAMILYSITE_SAVE_" + vm.FamilySite.RowState, paramHash);

			return "<script> opener.fnCompleteAdd(); self.close();</script>";
		}

		public JsonResult FamilySiteDeleteAjax(int paramSiteNo)
		{
			int cnt = 0;
			Hashtable paramHash = new Hashtable();

			paramHash.Add("RowState"	, "D");
			paramHash.Add("QuickNo"		, paramSiteNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);
			paramHash.Add("DeleteYesNo" , "Y");

			cnt = baseSvc.Save("content.FAMILYSITE_SAVE_D", paramHash);

			return Json(cnt);
		}

		#endregion

		#region 팝업관리

		[Route("PopupList")]
		public ActionResult PopupList(ContentViewModel vm)
		{
			vm.PageRowSize = vm.PageRowSize ?? 10;
			vm.PageNum = vm.PageNum ?? 1;

			Hashtable paramHash = new Hashtable();

			paramHash.Add("RowState", "L");
			paramHash.Add("DisplayDay", null);
			paramHash.Add("DeleteYesNo", "N");
			paramHash.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramHash.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));

			vm.PopupList = baseSvc.GetList<Popup>("content.POPUP_SELECT_L", paramHash);
			vm.PageTotalCount = vm.PopupList.FirstOrDefault() != null ? vm.PopupList.FirstOrDefault().TotalCount : 0;

			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize } };

			return View(vm);
		}

		[Route("PopupWrite/{param1}")]
		public ActionResult PopupWrite(ContentViewModel vm, int? param1)
		{
			Hashtable paramHash = new Hashtable();

			paramHash.Add("RowState", "S");
			paramHash.Add("PopupNo", param1 ?? 0);
			paramHash.Add("DisplayDay", null);
			paramHash.Add("DeleteYesNo", "N");

			vm.Popup = baseSvc.Get<Popup>("content.POPUP_SELECT_S", paramHash);

			if(vm.Popup != null)
				vm.Popup.PopupContents = Server.UrlDecode(vm.Popup.PopupContents);

			long? fileGroupNo = vm.Popup != null ? vm.Popup.FileGroupNo > 0 ? (long?)vm.Popup.FileGroupNo : 0 : 0;

			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fileGroupNo);
			htFile.Add("DeleteYesNo", "N");
			if (fileGroupNo != null)
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", htFile);
			else
				vm.FileList = null;

			return View(vm);
		}

		[HttpPost]
		[Route("PopupWrite")]
		public string PopupWrite(ContentViewModel vm)
		{
			bool fileSuccess = true; //HelpDeskQA일 경우 파일업로드 및 CourseNo를 사용하지 않으므로 오류 방지를 위해 기본값 true로 초기화
			long? fileGroupNo = 0;

			#region "파일관련"
			int fileCnt = 0;
			for (int i = 0; i < Request.Files.Count; i++)
			{
				if (Request.Files[i].ContentLength != 0)
					fileCnt++;
			}
			if (fileCnt > 0)
			{
				fileGroupNo = FileUpload(vm.Popup.RowState ?? "C", "Popup", vm.Popup.FileGroupNo, "PopupFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}
			#endregion "파일관련"

			vm.Popup.FileGroupNo = (int)fileGroupNo;

			if (fileSuccess) //파일 업로드 성공 시 게시물을 저장함
			{
				string RowState		= (vm.Popup.PopupNo == 0 ? "C" : "U");

				vm.Popup.FileGroupNo	= fileGroupNo == null ? 0 : (int)fileGroupNo;
				vm.Popup.CreateUserNo	= vm.Popup.CreateUserNo;
				vm.Popup.UpdateUserNo	= vm.Popup.CreateUserNo;
				vm.Popup.PopupNo		= vm.Popup.PopupNo;
				vm.Popup.PopupTitle		= vm.Popup.PopupTitle;
				vm.Popup.StartDay		= vm.Popup.StartDay;
				vm.Popup.EndDay			= vm.Popup.EndDay;
				vm.Popup.WidthSize		= vm.Popup.WidthSize;
				vm.Popup.HeightSize		= vm.Popup.HeightSize;
				vm.Popup.LeftMargin		= vm.Popup.LeftMargin;
				vm.Popup.TopMargin		= vm.Popup.TopMargin;
				vm.Popup.PopupContents	= vm.Popup.HtmlContents;
				vm.Popup.Contents		= vm.Popup.Contents;
				vm.Popup.LinkUrl		= vm.Popup.LinkUrl;
				vm.Popup.UserNo			= sessionManager.UserNo;
				vm.Popup.OutputYesNo	= (vm.Popup.OutputYesNo ?? "N").Equals("Y") ? "Y" : "N";
				vm.Popup.PopupGubun		= vm.Popup.PopupGubun;
				vm.Popup.DeleteYesNo	= "N";
				
				baseSvc.Save<Popup>("content.POPUP_SAVE_" + RowState, vm.Popup);

			}
			
			return "<script> opener.fnCompleteAdd(); self.close();</script>";
		}

		public JsonResult PopupDeleteAjax(int paramPopupNo)
		{
			int cnt = 0;
			
			Hashtable paramHash = new Hashtable();

			paramHash.Add("RowState", "D");
			paramHash.Add("PopupNo", paramPopupNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);
			paramHash.Add("DeleteYesNo", "Y");

			cnt = baseSvc.Save("content.POPUP_SAVE_D", paramHash);

			return Json(cnt);
		}

		#endregion

		#region 퀵링크관리

		[Route("QuickLinkList")]
		public ActionResult QuickLinkList(ContentViewModel vm)
		{
			vm.QuickLinkList = baseSvc.GetList<QuickLink>("content.QUICKLINK_SELECT_L", "");
			return View(vm);
		}

		[Route("QuickLinkWrite/{param1}")]
		public ActionResult QuickLinkWrite(ContentViewModel vm, int? param1)
		{
			Hashtable paramHash = new Hashtable();

			paramHash.Add("QuickNo", param1);
			vm.QuickLink = baseSvc.Get<QuickLink>("content.QUICKLINK_SELECT_S", paramHash);

			long? fileGroupNo = vm.QuickLink != null ? vm.QuickLink.FileGroupNo > 0 ? (long?)vm.QuickLink.FileGroupNo : 0 : 0;

			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fileGroupNo);
			htFile.Add("DeleteYesNo", "N");
			if (fileGroupNo != null)
				vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", htFile);
			else
				vm.FileList = null;

			return View(vm);
		}

		[HttpPost]
		[Route("QuickLinkWrite")]
		public string QuickLinkWrite(ContentViewModel vm)
		{
			bool fileSuccess = true;
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
				fileGroupNo = FileUpload(vm.QuickLink.RowState ?? "C", "quicklink", vm.QuickLink.FileGroupNo, "QuickLinkFile");
				if (fileGroupNo <= 0)
					fileSuccess = false;
			}
			#endregion 파일관련

			if (fileSuccess)
			{
				Hashtable paramHash = new Hashtable();

				paramHash.Add("QuickNo", vm.QuickLink.QuickNo);
				paramHash.Add("QuickName", vm.QuickLink.QuickName.Trim());
				paramHash.Add("Url", vm.QuickLink.Url.Trim());
				paramHash.Add("DisplayOrder", vm.QuickLink.DisplayOrder);
				paramHash.Add("CreateUserNo", sessionManager.UserNo);
				paramHash.Add("UpdateUserNo", sessionManager.UserNo);
				paramHash.Add("OutputYesNo", (vm.QuickLink.OutputYesNo ?? "N").Equals("Y") ? "Y" : "N");
				paramHash.Add("DeleteYesNo", "N");
				paramHash.Add("FileGroupNo", vm.QuickLink.FileGroupNo = fileGroupNo == null ? 0 : (int)fileGroupNo);

				baseSvc.Save("content.QUICKLINK_SAVE_" + vm.QuickLink.RowState, paramHash);

			}

			return "<script> opener.fnCompleteAdd(); self.close();</script>";
		}
		
		public JsonResult QuickLinkDeleteAjax(int paramQuickNo)
		{
			int cnt = 0;

			Hashtable paramHash = new Hashtable();
			
			paramHash.Add("QuickNo", paramQuickNo);
			paramHash.Add("UpdateUserNo", sessionManager.UserNo);
			paramHash.Add("DeleteYesNo", "Y");

			cnt = baseSvc.Save("content.QUICKLINK_SAVE_D", paramHash);

			return Json(cnt);
		}

		#endregion 퀵링크관리
	}
}