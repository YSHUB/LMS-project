using System.Web.Mvc;
using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using System.Collections.Generic;
using System;
using System.Collections;
using System.Web.Routing;
using System.Web.Configuration;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("Facility")]
	public class FacilityController : WebBaseController
	{
		[AuthorFilter(IsAdmin = true)]
		[Route("ListFacilityAdmin")]
		public ActionResult ListFacilityAdmin(FacilityViewModel vm)
		{
			Code code = new Code("A");
			code.ClassCode = "FCCT";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			Facility facility = new Facility();

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			facility.FacilityType = "FACILITY";
			facility.Category = vm.Category;
			facility.SearchText = vm.SearchText;
			facility.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			facility.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;
			
			vm.FacilityList = baseSvc.GetList<Facility>("facility.FACILITY_SELECT_L", facility);
			
			vm.PageTotalCount = vm.FacilityList.Count > 0 ? vm.FacilityList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "SearchText", vm.SearchText }, { "Facility.FacilityType", facility.FacilityType} };

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListEquipmentAdmin")]
		public ActionResult ListEquipmentAdmin(FacilityViewModel vm)
		{
			Code code = new Code("A");
			code.ClassCode = "EQCT";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			Facility facility = new Facility();

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			facility.FacilityType = "EQUIPMENT";
			facility.Category = vm.Category;
			facility.SearchText = vm.SearchText;
			facility.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			facility.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.FacilityList = baseSvc.GetList<Facility>("facility.FACILITY_SELECT_L", facility);

			vm.PageTotalCount = vm.FacilityList.Count > 0 ? vm.FacilityList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "SearchText", vm.SearchText }, { "Facility.FacilityType", facility.FacilityType } };

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("WriteAdmin/{param1}/{param2}")]
		public ActionResult WriteAdmin(string param1, int param2)
		{
			FacilityViewModel vm = new FacilityViewModel();
			vm.FacilityType = param1;

			Code code = new Code("A");
			code = new Code("A");
			code.ClassCode = param1 == "FACILITY" ? "FCCT" : param1 == "EQUIPMENT" ? "EQCT" : "";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			Facility facility = new Facility();
			facility.FacilityNo = param2;

			vm.Facility = baseSvc.Get<Facility>("facility.FACILITY_SELECT_S", facility);

			if(vm.Facility != null)
			{
				if(vm.Facility.FileGroupNo > 0)
				{
					File file = new File();
					file.RowState = "L";
					file.FileGroupNo = vm.Facility.FileGroupNo ?? 0;
					if (vm.Facility.FileGroupNo != null)
						vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					else
						vm.FileList = null;
				}
			}

			return View(vm);
		}

		public JsonResult WriteFacility(FacilityViewModel vm)
		{
			bool fileSuccess = true;

			//파일관련 Start------------------------------------------------------------------------------------
			string saveFolderName = DateTime.Now.ToString("yyyyMMdd");

			Hashtable htFileFolder = new Hashtable();
			htFileFolder.Add("RowState", "S");
			htFileFolder.Add("FolderName", "Facility");
			string subFolderName = baseSvc.Get<FileFolder>("common.FILEFOLDER_SELECT_S", htFileFolder).FolderName;
			long? fileGroupNo = vm.Facility.FileGroupNo > 0 ? (long?)vm.Facility.FileGroupNo : null;
			fileGroupNo = SaveFile(Request.Files, "FacilityFile", fileGroupNo, "Facility");

			//업로드한 파일이 디렉토리에 저장되었는지 확인
			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fileGroupNo ?? 0);
			htFile.Add("DeleteYesNo", "N");

			vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", htFile);

			vm.Facility.RowState = vm.Facility.FacilityNo == 0 ? "C" : "U";

			foreach (var item in vm.FileList)
			{
				if (!System.IO.File.Exists(Server.MapPath("/" + FileRootFolder + item.SaveFileName)))
				{
					fileSuccess = false;
					if ("C" == vm.Facility.RowState)
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
				Facility facility = new Facility();

				facility.FacilityNo = vm.Facility.FacilityNo;
				facility.FacilityName = vm.Facility.FacilityName;
				facility.FacilityType = vm.Facility.FacilityType;
				facility.FacilityText = vm.Facility.FacilityText;
				facility.Category = vm.Facility.Category;
				facility.MaxUserCount = vm.Facility.MaxUserCount;
				facility.FileGroupNo = (int)fileGroupNo;
				facility.UserNo = sessionManager.UserNo;
				facility.IsFree = vm.Facility.IsFree;
				facility.FacilityExpense = vm.Facility.FacilityExpense;

				if(vm.Facility.RowState == "C")
				{
					int facilityno = baseSvc.Get<int>("facility.FACILITY_SAVE_C", facility);
					vm.Facility.FacilityNo = facilityno;
				}
				else if(vm.Facility.RowState == "U")
				{
					baseSvc.Save("facility.FACILITY_SAVE_U", facility);
				}
			}

			return Json(vm.Facility.FacilityNo);
		}
		[HttpPost]
		public JsonResult FacilityTypeSelect(string FacilityType)
		{
			Code code = new Code("A");
			code = new Code("A");
			code.ClassCode = FacilityType == "FACILITY" ? "FCCT" : FacilityType == "EQUIPMENT" ? "EQCT" : "";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			IList<Code> codeList = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			return Json(codeList);
		}

		[HttpPost]
		public JsonResult DeleteFacility(int param1, int param2)
		{
			Facility facility = new Facility();
			facility.FacilityNo = param1;
			facility.UserNo = sessionManager.UserNo;
			
			baseSvc.Save("facility.FACILITY_SAVE_D", facility);

			FileDeleteByGroup(param2);

			return Json(param1);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("DetailAdmin/{param1}")]
		public ActionResult DetailAdmin(FacilityViewModel vm, int param1)
		{
			Facility facility = new Facility();
			facility.FacilityNo = param1;

			vm.Facility = baseSvc.Get<Facility>("facility.FACILITY_SELECT_S", facility);

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			FacilityReservation facilityReservation = new FacilityReservation();
			facilityReservation.FacilityNo = param1;
			facilityReservation.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			facilityReservation.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;
			facilityReservation.SearchStartDay = vm.SearchStartDay;
			facilityReservation.SearchEndDay = vm.SearchEndDay;
			facilityReservation.SearchText = vm.SearchText;

			vm.FacilityReservationList = baseSvc.GetList<FacilityReservation>("facility.FACILITY_SELECT_C", facilityReservation);

			ArrayList arrayList = TimeArrayList("09:00", "18:00", 30);

			for(int i = 0; i < vm.FacilityReservationList.Count; i++)
			{
				int ReservedHour = vm.FacilityReservationList[i].ReservedHour;
				vm.FacilityReservationList[i].ReservedHourList = string.Format("{0} ~ {1}", arrayList[ReservedHour], arrayList[ReservedHour + 1]);
			}

			vm.PageTotalCount = vm.FacilityReservationList.Count > 0 ? vm.FacilityReservationList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "SearchStartDay", vm.SearchStartDay }, { "SearchEndDay", vm.SearchEndDay }, { "SearchText", vm.SearchText } };

			ViewBag.Category = string.IsNullOrEmpty(Request.QueryString["Category"]) ? "" : Request.QueryString["Category"];
			ViewBag.SearchText = string.IsNullOrEmpty(Request.QueryString["SearchText"]) ? "" : Request.QueryString["SearchText"];
			ViewBag.PageRowSize = string.IsNullOrEmpty(Request.QueryString["PageRowSize"]) ? "" : Request.QueryString["PageRowSize"];
			ViewBag.PageNum = string.IsNullOrEmpty(Request.QueryString["PageNum"]) ? "" : Request.QueryString["PageNum"];

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult DetailAdminExcel(int param1, string param2, string param3, string param4)
		{
			Facility facility = new Facility();
			facility.FacilityNo = param1;

			Facility Facilitys = baseSvc.Get<Facility>("facility.FACILITY_SELECT_S", facility);


			FacilityReservation facilityReservation = new FacilityReservation();
			facilityReservation.FacilityNo = param1;
			facilityReservation.FirstIndex = 1;
			facilityReservation.LastIndex = 10000;

			if(string.IsNullOrEmpty(param2) && string.IsNullOrEmpty(param3))
			{
				facilityReservation.SearchStartDay = param2;
				facilityReservation.SearchEndDay = param3;
			}
			
			facilityReservation.SearchText = param4;

			IList<FacilityReservation> FacilityReservationList = baseSvc.GetList<FacilityReservation>("facility.FACILITY_SELECT_C", facilityReservation);

			ArrayList arrayList = TimeArrayList("09:00", "18:00", 30);

			for (int i = 0; i < FacilityReservationList.Count; i++)
			{
				int ReservedHour = FacilityReservationList[i].ReservedHour;
				FacilityReservationList[i].ReservedHourList = string.Format("{0} ~ {1}", arrayList[ReservedHour], arrayList[ReservedHour + 1]);
			}

			string[] headers = new string[] { "신청인", "소속", "예약날짜", "예약시간", "신청인원", "예약현황" };
			string[] columns = new string[] { "ReservedUserName", "ReservedAssignName", "ReservedDate", "ReservedHourList", "ReservedUserCount", "ReservationState" };
			string excelFileName = String.Format("통합예약관리_{1}관리_{2}_예약현황_{0}", DateTime.Now.ToString("yyyyMMdd"), Facilitys.FacilityTypeName, Facilitys.FacilityName);

			return ExportExcel(headers, columns, FacilityReservationList, excelFileName);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListBannedAdmin")]
		public ActionResult ListBannedAdmin(FacilityViewModel vm)
		{
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			FacilityBan facilityBan = new FacilityBan();
			facilityBan.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			facilityBan.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.FacilityBanList = baseSvc.GetList<FacilityBan>("facility.FACILITY_SELECT_D", facilityBan);

			vm.PageTotalCount = vm.FacilityBanList.Count > 0 ? vm.FacilityBanList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize } };

			return View(vm);
		}

		[HttpPost]
		public JsonResult CancelBan(int param1)
		{
			FacilityBan facilityBan = new FacilityBan();
			facilityBan.BanNo = param1;

			baseSvc.Save("facility.FACILITY_SAVE_B", facilityBan);

			return Json(facilityBan.BanNo);
		}

		[Route("ListFacility")]
		public ActionResult ListFacility(FacilityViewModel vm)
		{
			Code code = new Code("A");
			code.ClassCode = "FCCT";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			Facility facility = new Facility();

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 6;

			facility.FacilityType = "FACILITY";
			facility.Category = vm.Category;
			facility.SearchText = vm.SearchText;
			facility.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 6) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			facility.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 6) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 6) : 6;

			vm.FacilityList = baseSvc.GetList<Facility>("facility.FACILITY_SELECT_L", facility);

			vm.PageTotalCount = vm.FacilityList.Count > 0 ? vm.FacilityList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "SearchText", vm.SearchText }, { "Facility.FacilityType", facility.FacilityType } };

			return View(vm);
		}

		[Route("ListEquipment")]
		public ActionResult ListEquipment(FacilityViewModel vm)
		{
			Code code = new Code("A");
			code.ClassCode = "EQCT";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			Facility facility = new Facility();

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 6;

			facility.FacilityType = "EQUIPMENT";
			facility.Category = vm.Category;
			facility.SearchText = vm.SearchText;
			facility.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 6) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			facility.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 6) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 6) : 6;

			vm.FacilityList = baseSvc.GetList<Facility>("facility.FACILITY_SELECT_L", facility);

			vm.PageTotalCount = vm.FacilityList.Count > 0 ? vm.FacilityList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "SearchText", vm.SearchText }, { "Facility.FacilityType", facility.FacilityType } };

			return View(vm);
		}

		[Route("DetailFacility/{param1}")]
		public ActionResult DetailFacility(int param1)
		{
			FacilityViewModel vm = new FacilityViewModel();

			vm.isAdmin = sessionManager.IsAdmin;

			Facility facility = new Facility();
			facility.FacilityNo = param1;

			vm.Facility = baseSvc.Get<Facility>("facility.FACILITY_SELECT_S", facility);

			FacilityReservation facilityReservation = new FacilityReservation();
			facilityReservation.FacilityNo = param1;

			vm.FacilityReservationList = baseSvc.GetList<FacilityReservation>("facility.FACILITY_SELECT_B", facilityReservation); //전부 예약된 날짜 조회

			if (vm.Facility != null)
			{
				if (vm.Facility.FileGroupNo > 0)
				{
					File file = new File();
					file.RowState = "L";
					file.FileGroupNo = vm.Facility.FileGroupNo ?? 0;
					if (vm.Facility.FileGroupNo != null)
						vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					else
						vm.FileList = null;
				}
			}

			ViewBag.Category = string.IsNullOrEmpty(Request.QueryString["Category"]) ? "" : Request.QueryString["Category"];
			ViewBag.SearchText = string.IsNullOrEmpty(Request.QueryString["SearchText"]) ? "" : Request.QueryString["SearchText"];
			ViewBag.PageRowSize = string.IsNullOrEmpty(Request.QueryString["PageRowSize"]) ? "" : Request.QueryString["PageRowSize"];
			ViewBag.PageNum = string.IsNullOrEmpty(Request.QueryString["PageNum"]) ? "" : Request.QueryString["PageNum"];

			return View(vm);
		}

		[Route("DetailEquipment/{param1}")]
		public ActionResult DetailEquipment(int param1)
		{
			FacilityViewModel vm = new FacilityViewModel();

			vm.isAdmin = sessionManager.IsAdmin;

			Facility facility = new Facility();
			facility.FacilityNo = param1;

			vm.Facility = baseSvc.Get<Facility>("facility.FACILITY_SELECT_S", facility);

			FacilityReservation facilityReservation = new FacilityReservation();
			facilityReservation.FacilityNo = param1;

			vm.FacilityReservationList = baseSvc.GetList<FacilityReservation>("facility.FACILITY_SELECT_B", facilityReservation); //전부 예약된 날짜 조회

			if (vm.Facility != null)
			{
				if (vm.Facility.FileGroupNo > 0)
				{
					File file = new File();
					file.RowState = "L";
					file.FileGroupNo = vm.Facility.FileGroupNo ?? 0;
					if (vm.Facility.FileGroupNo != null)
						vm.FileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);
					else
						vm.FileList = null;
				}
			}

			ViewBag.Category = string.IsNullOrEmpty(Request.QueryString["Category"]) ? "" : Request.QueryString["Category"];
			ViewBag.SearchText = string.IsNullOrEmpty(Request.QueryString["SearchText"]) ? "" : Request.QueryString["SearchText"];
			ViewBag.PageRowSize = string.IsNullOrEmpty(Request.QueryString["PageRowSize"]) ? "" : Request.QueryString["PageRowSize"];
			ViewBag.PageNum = string.IsNullOrEmpty(Request.QueryString["PageNum"]) ? "" : Request.QueryString["PageNum"];

			return View(vm);
		}

		[Route("ListReserve/{param1}")]
		public ActionResult ListReserve(FacilityViewModel vm, int param1)
		{
			Facility facility = new Facility();
			facility.FacilityNo = param1;

			vm.Facility = baseSvc.Get<Facility>("facility.FACILITY_SELECT_S", facility);

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			FacilityReservation facilityReservation = new FacilityReservation();
			facilityReservation.FacilityNo = param1;
			facilityReservation.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			facilityReservation.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;
			if (!sessionManager.IsAdmin)
			{
				facilityReservation.UserNo = sessionManager.UserNo;
			}
			else
			{
				facilityReservation.SearchStartDay = vm.SearchStartDay;
				facilityReservation.SearchEndDay = vm.SearchEndDay;
				facilityReservation.SearchText = vm.SearchText;
			}

			vm.FacilityReservationList = baseSvc.GetList<FacilityReservation>("facility.FACILITY_SELECT_C", facilityReservation);

			ArrayList arrayList = TimeArrayList("09:00", "18:00", 30);

			for (int i = 0; i < vm.FacilityReservationList.Count; i++)
			{
				int ReservedHour = vm.FacilityReservationList[i].ReservedHour;
				vm.FacilityReservationList[i].ReservedHourList = string.Format("{0} ~ {1}", arrayList[ReservedHour], arrayList[ReservedHour + 1]);
			}

			vm.isAdmin = sessionManager.IsAdmin;
			vm.PageTotalCount = vm.FacilityReservationList.Count > 0 ? vm.FacilityReservationList[0].TotalCount : 0;

			if (!sessionManager.IsAdmin)
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize } };
			}
			else
			{
				vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "SearchStartDay", vm.SearchStartDay }, { "SearchEndDay", vm.SearchEndDay }, { "SearchText", vm.SearchText } };
			}

			return View(vm);
		}

		[HttpPost]
		public JsonResult GetReservedData(int FacilityNo, int MaxUserCount, string ReservedDate)
		{
			string htmlResult = string.Empty;
			bool banned = false;

			FacilityBan facilityBan = new FacilityBan();

			facilityBan.UserNo = sessionManager.UserNo;

			FacilityBan fcBanned = baseSvc.Get<FacilityBan>("facility.FACILITY_SELECT_A", facilityBan); //밴 여부 체크

			if (fcBanned != null)
			{
				if (!string.IsNullOrEmpty(fcBanned.BannedDate))
				{
					if (DateTime.Now < DateTime.Parse(fcBanned.BannedDate).AddDays(30))
					{
						htmlResult = string.Format("<td colspan=\"3\"><a class=\"text-center text-danger\">{0} 사유로 인한 이용제한 상태입니다.<br/>" +
							"{1} 이후로 이용 가능합니다.</a></td>" +
							"<input type=\"hidden\" id=\"hdnBanned\" value=\"Y\">"
							, fcBanned.BannedReason
							, DateTime.Parse(fcBanned.BannedDate).AddDays(30).ToString("yyyy-MM-dd"));
						banned = true;
					}
				}
			}

			if (!banned)
			{
				Facility facility = new Facility();
				facility.FacilityNo = FacilityNo;

				string facilityType = baseSvc.Get<Facility>("facility.FACILITY_SELECT_S", facility).FacilityType;

				FacilityReservation facilityReservation = new FacilityReservation();

				facilityReservation.FacilityNo = FacilityNo;
				facilityReservation.ReservedDate = ReservedDate;

				IList<FacilityReservation> facilityRsvList = baseSvc.GetList<FacilityReservation>("facility.FACILITY_SELECT_R", facilityReservation);

				ArrayList arrayList = TimeArrayList("09:00", "18:00", 30);

				if(arrayList.Count > 0)
				{
					htmlResult += string.Format("<input type=\"hidden\" id=\"hdnTimeCount\" value=\"{0}\">", arrayList.Count - 1);

					for (int i = 0; i < arrayList.Count - 1; i++) //9시부터 18시까지 30분단위
					{
						string chkClass = string.Empty;
						string txtClass = string.Format("<input type=\"text\" id=\"userCount{0}\" class=\"form-control text-right\" placeholder=\"{1}\" disabled=\"disabled\" />"
																	, i.ToString()
																	, "최대 " + MaxUserCount.ToString() + "명");
						//string userCount = "0";

						if (DateTime.Parse(ReservedDate + " " + DateTime.Now.ToString("hh:mm:ss")) < DateTime.Now.AddDays(-1) && !sessionManager.IsAdmin)
						{
							chkClass = string.Format("<input type=\"checkbox\" id=\"customCheck{0}\" disabled=\"disabled\">" +
																		"<span class=\"checkmark\"></span>"
																	, i.ToString());
							txtClass = string.Format("<input type=\"text\" id=\"userCount{0}\" class=\"form-control text-right\" value=\"예약불가\" disabled=\"disabled\" />"
																	, i.ToString());
						}
						else
						{
							chkClass = string.Format("<input type=\"checkbox\" id=\"customCheck{0}\">" +
																 "<span class=\"checkmark\"></span>"
																, i.ToString());

							foreach (FacilityReservation facilityCheck in facilityRsvList)
							{
								if (facilityCheck.ReservedHour == i && facilityCheck.ReservationState != "RVCD003")
								{
									if (facilityCheck.ReservedUserNo != sessionManager.UserNo && !sessionManager.IsAdmin)
									{
										chkClass = string.Format("<input type=\"checkbox\" id=\"customCheck{0}\" disabled=\"disabled\">" +
																			 "<span class=\"checkmark\"></span>" +
																			 "<input type=\"hidden\" id=\"hdnReservationNo{0}\" value=\"{1}\">"
																			 , i.ToString()
																			 , facilityCheck.ReservationNo);
										//facilityList.RemoveAt(0);
										txtClass = string.Format("<input type=\"text\" id=\"userCount{0}\" class=\"form-control text-right\" value=\"예약불가\" disabled=\"disabled\" />"
																		, i.ToString());
									}
									else if (facilityCheck.ReservedUserNo == sessionManager.UserNo || sessionManager.IsAdmin)
									{
										if(facilityCheck.ReservationState == "RVCD002")
										{
											chkClass = string.Format("<button id=\"customCheck{0}\" class=\"btn\" title=\"예약취소\" onclick=\"fnCancelReservation('{0}', {1});\">" +
																				"<i class=\"bi bi-x-square text-point\"></i>" +
																			 "</button>" +
																			 "<input type=\"hidden\" id=\"hdnReservationNo{0}\" value=\"{1}\">"
																			 , arrayList[i]
																			 , facilityCheck.ReservationNo);
											//facilityList.RemoveAt(0);
											txtClass = string.Format("<input type=\"text\" id=\"userCount{0}\" class=\"form-control text-right\" value=\"승인대기\" disabled=\"disabled\" />"
																			, i.ToString());
										}
										else
										{
											chkClass = string.Format("<button id=\"customCheck{0}\" class=\"btn\" title=\"예약취소\" onclick=\"fnCancelReservation('{0}', {1});\">" +
																				"<i class=\"bi bi-x-circle text-point\"></i>" +
																			 "</button>" +
																			 "<input type=\"hidden\" id=\"hdnReservationNo{0}\" value=\"{1}\">"
																			 , arrayList[i]
																			 , facilityCheck.ReservationNo);
											//facilityList.RemoveAt(0);
											txtClass = string.Format("<input type=\"text\" id=\"userCount{0}\" class=\"form-control text-right\" value=\"예약완료\" disabled=\"disabled\" />"
																			, i.ToString()
																			/*, facilityCheck.ReservedUserCount.ToString() + "명"*/);
										}
									}
								}
							}
						}

						htmlResult += string.Format("<tr>" +
																		"<input type=\"hidden\" id=\"hdnCheckTime{2}\" value=\"{0}\">" +
																		"<th scope=\"row\" class=\"text-nowrap\">{0} ~ {1}" +
																		"<td>" +
																			"<label for=\"customCheck{2}\" class=\"sr-only\">예약상태</label>" +
																			chkClass +
																		"</td>" +
																		"{3}" +
																	"</tr >"
																	, arrayList[i]
																	, arrayList[i + 1]
																	, i.ToString()
																	, facilityType == "FACILITY" ? "<td class=\"text-nowrap col-5\">" +
																													txtClass +
																												"</td >"
																											  : "");
					}
				}
			}

			return Json(htmlResult);
		}

		public ArrayList TimeArrayList(string start, string end, int set)
		{
			ArrayList arrayList = new ArrayList();

			DateTime startTime = DateTime.Parse(start); //시작 시간 설정
			DateTime endTime = DateTime.Parse(end); //종료 시간 설정
			int setTime = set; //30분 단위

			bool endCheck = true;
			int timeCheck = 0;
			while (endCheck)
			{
				arrayList.Add(startTime.AddMinutes(setTime * timeCheck).ToString("HH:mm"));
				if (startTime.AddMinutes(setTime * timeCheck).ToString("HH:mm").Equals(endTime.ToString("HH:mm"))
					|| startTime.AddMinutes(setTime * timeCheck) > endTime)
				{
					endCheck = false;
				}
				else
				{
					timeCheck++;
				}
			}

			return arrayList;
		}

		[HttpPost]
		public JsonResult ReserveFacility(int FacilityNo, string ReservedDate, List<int> TimeArray, List<int> UserCountArray)
		{
			string reservedHourList = string.Empty;
			string userCountList = string.Empty;

			FacilityReservation facilityReservation = new FacilityReservation();

			facilityReservation.FacilityNo = FacilityNo;
			facilityReservation.ReservedDate = ReservedDate;
			facilityReservation.UserNo = sessionManager.UserNo;

			foreach(int hours in TimeArray)
			{
				if(hours >= 0)
				{
					reservedHourList += hours.ToString() + ",";
				}
			}

			foreach(int counts in UserCountArray)
			{
				if(counts >= 0)
				{
					userCountList += counts.ToString() + ",";
				}
			}

			if(!string.IsNullOrEmpty(reservedHourList) && !string.IsNullOrEmpty(userCountList))
			{
				facilityReservation.ReservedHourList = reservedHourList.Length > 0 ? reservedHourList.Substring(0, reservedHourList.Length - 1) : string.Empty;
				facilityReservation.UserCountList = userCountList.Length > 0 ? userCountList.Substring(0, userCountList.Length - 1) : string.Empty;

				baseSvc.Save("facility.FACILITY_SAVE_R", facilityReservation);
			}

			return Json(FacilityNo);
		}

		[HttpPost]
		public JsonResult CancelReservation (int FacilityNo, int ReservationNo)
		{
			FacilityReservation facilityReservation = new FacilityReservation();

			facilityReservation.FacilityNo = FacilityNo;
			facilityReservation.ReservationNo = ReservationNo;
			facilityReservation.UserNo = sessionManager.UserNo;

			baseSvc.Save("facility.FACILITY_SAVE_A", facilityReservation);

			return Json(ReservationNo);
		}

		[HttpPost]
		public JsonResult AddBan(int param1, string param2, string param3)
		{
			FacilityBan facilityBan = new FacilityBan();

			facilityBan.BannedUserNo = param1;
			facilityBan.BannedDate = param2;
			facilityBan.BannedReason = param3;
			facilityBan.UserNo = sessionManager.UserNo;

			baseSvc.Save("facility.FACILITY_SAVE_E", facilityBan);

			return Json(param1);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ListChargedAdmin/{param1}")]
		public ActionResult ListChargedAdmin(FacilityViewModel vm, string param1)
		{
			Code code = new Code("A");
			code.ClassCode = param1 == "FACILITY" ? "FCCT" : "EQCT";
			code.DeleteYesNo = "N";
			code.UseYesNo = "Y";

			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;

			FacilityReservation facilityReservation = new FacilityReservation();
			facilityReservation.FacilityType = param1 ?? "FACILITY";
			facilityReservation.SearchText = vm.SearchText;
			facilityReservation.Category = vm.Category;
			facilityReservation.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			facilityReservation.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

			vm.FacilityReservationList = baseSvc.GetList<FacilityReservation>("facility.FACILITY_SELECT_E", facilityReservation);

			vm.PageTotalCount = vm.FacilityReservationList.Count > 0 ? vm.FacilityReservationList[0].TotalCount : 0;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "SearchText", vm.SearchText }, { "Category", vm.Category } };

			return View(vm);
		}

		[HttpPost]
		public JsonResult GetChargedReservedData(string param1)
		{
			FacilityReservation facilityReservation = new FacilityReservation();

			facilityReservation.ReservationNoList = param1;

			IList<FacilityReservation> reservationList = baseSvc.GetList<FacilityReservation>("facility.FACILITY_SELECT_F", facilityReservation);

			string resultHtml = string.Empty;

			if(reservationList.Count > 0)
			{
				ArrayList arrayList = TimeArrayList("09:00", "18:00", 30);

				for (int i = 0; i < reservationList.Count; i++)
				{
					int ReservedHour = reservationList[i].ReservedHour;
					reservationList[i].ReservedHourList = string.Format("{0} ~ {1}", arrayList[ReservedHour], arrayList[ReservedHour + 1]);

					resultHtml += string.Format("<tr>"
														   +	 "<td>{0}</td>"
														   +	 "<td class=\"text-nowrap\">{1}</td>"
														   +	 "<td class=\"text-nowrap\">{2}</td>"
														   +	 "<td>{3}명</td>"
														   + "</tr>"
														   , reservationList[i].FacilityName
														   , reservationList[i].ReservedDate
														   , reservationList[i].ReservedHourList
														   , reservationList[i].ReservedUserCount);
				}
			}
			return Json(resultHtml);
		}

		[HttpPost]
		public JsonResult ApproveChargedReservedData(string param1)
		{
			FacilityReservation facilityReservation = new FacilityReservation();

			facilityReservation.ReservationNoList = param1;
			facilityReservation.UserNo = sessionManager.UserNo;

			return Json(baseSvc.Save("facility.FACILITY_SAVE_F", facilityReservation));
		}

		[HttpPost]
		public JsonResult CancelChargedReservedData(string param1)
		{
			FacilityReservation facilityReservation = new FacilityReservation();

			facilityReservation.ReservationNoList = param1;
			facilityReservation.UserNo = sessionManager.UserNo;

			return Json(baseSvc.Save("facility.FACILITY_SAVE_G", facilityReservation));
		}
	}
}