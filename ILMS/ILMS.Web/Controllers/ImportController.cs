using ILMS.Design.ViewModels;
using ILMS.Design.Domain;
using System.Collections;
using System;
using System.Web.Mvc;
using System.Web.Routing;
using System.Linq;
using ILMS.Core.System;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsAdmin = true)]
	[RoutePrefix("Import")]
	public class ImportController : AdminBaseController
	{
		[Route("ImportAssign")]
		public ActionResult ImportAssign()
		{
			return View();
		}

		[Route("ImportMember")]
		public ActionResult ImportMember()
		{
			return View();
		}

		[Route("ImportSubject")]
		public ActionResult ImportSubject()
		{
			return View();
		}

		[Route("ImportCourse")]
		public ActionResult ImportCourse()
		{
			return View();
		}

		[Route("ImportCourse")]
		[HttpPost]
		public JsonResult ImportCourse(int CourseNo)
		{
			Hashtable ht = new Hashtable();
			ht.Add("@IOType", "SET");
			ht.Add("@UpdateUserNo", sessionManager.UserNo);
			ht.Add("@Param1", CourseNo);

			return Json(baseSvc.Save("import.IMPORT_SAVE_COURSEUPDATE", ht));
		}

		[Route("ImportLecture")]
		public ActionResult ImportLecture()
		{
			return View();
		}

		[Route("ImportLogList")]
		public ActionResult ImportLogList(ImportViewModel vm)
		{
			// 학사연동 - 연동로그 리스트 조회
			vm.PageRowSize = vm.PageRowSize ?? 10;
			vm.PageNum = vm.PageNum ?? 1;
			
			Hashtable paramHash = new Hashtable();

			paramHash.Add("StartDate", vm.StartDate);
			paramHash.Add("EndDate", vm.EndDate);
			paramHash.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
			paramHash.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));

			vm.LogList = baseSvc.GetList<Import>("import.IMPORT_LOG_SELECT_L", paramHash);
			vm.PageTotalCount = vm.LogList.FirstOrDefault() != null ? vm.LogList.FirstOrDefault().TotalCount : 0;

			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "StartDate", vm.StartDate }, { "EndDate", vm.EndDate } };

			return View(vm);
		}

        #region 엑셀다운로드
		[Route("ImportLogList")]
		public ActionResult ImportLogListExcel(ImportViewModel vm, string StartDate, string EndDate)
		{
			Hashtable paramHash = new Hashtable();

			// 학사연동 - 연동로그 리스트 엑셀 다운로드
			paramHash.Add("StartDate", StartDate == "" ? null : StartDate );
			paramHash.Add("EndDate"	 , EndDate == "" ? null : EndDate);

			vm.LogList = baseSvc.GetList<Import>("import.IMPORT_LOG_SELECT_L", paramHash);

			string[] headers = new string[] { "연동일", "항목", "신규", "수정" };
			string[] colums = new string[] { "LinkageDate", "CodeName", "InsertCount", "UpdateCount" };

			// ExportExcel(헤더 , 칼럼명 , 데이터List, 파일명<확장자없이>)
			return ExportExcel(headers, colums, vm.LogList , String.Format("연동로그_{0}", DateTime.Now.ToString("yyyyMMdd")));
		}

		#endregion 엑셀 Export
	}
}