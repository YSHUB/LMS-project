using ILMS.Service;
using ILMS.Design.Domain;
using System.Linq;
using System.Web.Mvc;
using System.Collections.Generic;
using System.Collections;
using ILMS.Core.System;
using System;
using System.Web;
using System.IO;
using System.Web.Configuration;
using System.Text;
using System.Security.Cryptography;

namespace ILMS.Web.Controllers
{
	public class WebBaseController : Controller
	{
		public SessionManager sessionManager { get; set; }
		public BaseService baseSvc { get; set; }

		public string FileRootFolder = WebConfigurationManager.AppSettings["FileRootFolder"].ToString();

		protected override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			base.OnActionExecuting(filterContext);

			//에러메시지 반환
			ViewBag.InfoMessage = "";
			if (Request["InfoMessage"] != null)
			{
				ViewBag.InfoMessage = Message.ResourceManager.GetString(Request["InfoMessage"]);
			}

			//페이지 호출시(파일다운로드나 ajax호출 아닌 경우)
			if (Request.AcceptTypes != null 
				&& !Request.AcceptTypes.Contains("application/json") 
				&& Request.Files.Count == 0 
				&& !filterContext.RequestContext.RouteData.Values["action"].ToString().ToUpper().Equals("FILEDOWNLOAD"))
			{
				bool IsLectureRequestPeriod = false;
				Term lectureRequestTerm = new Term();
				try
				{
					lectureRequestTerm = baseSvc.Get<Term>("term.TERM_SELECT_A", new Term("A"));
					string startDay = lectureRequestTerm.AccessRestrictionStartDay ?? "";
					string endDay = lectureRequestTerm.AccessRestrictionEndDay ?? "";
					IsLectureRequestPeriod = !string.IsNullOrEmpty(startDay) && !string.IsNullOrEmpty(endDay);
				}
				catch
				{
					IsLectureRequestPeriod = false;
				}

				//접근제한기간인 경우 페이지 이동 막기
				if (IsLectureRequestPeriod && !(Request.IsLocal || Request.ServerVariables["REMOTE_ADDR"].ToString().Equals("211.179.185.248")))
				{
					var TempData = filterContext.Controller.TempData;
					TempData["PeriodName"] = lectureRequestTerm.AccessRestrictionName;
					TempData["Period"] = lectureRequestTerm.AccessRestrictionStartDay + " ~ " + lectureRequestTerm.AccessRestrictionEndDay;

					filterContext.Result = RedirectToAction("Restriction", "Info");
				}
				else
				{
					if (!filterContext.RequestContext.RouteData.Values["controller"].ToString().Equals("Info"))
					{
						//사용자 정보
						ViewBag.User = (User)sessionManager.GetValue(SessionConstants.UserInfo);

						if (ViewBag.User == null)
						{
							ViewBag.User = new User();
							ViewBag.User.IPAddress = "";
							ViewBag.User.UserType = "USRT013";
							ViewBag.IsLogin = false;
							ViewBag.IsAdmin = false;
							ViewBag.IsAutoLogin = false;
							ViewBag.IsLecturer = false;

							//안 읽은 쪽지 : 로그인하지 않은 경우 0
							ViewBag.NoteReceiveCount = 0;
						}
						else
						{
							ViewBag.IsLogin = sessionManager.IsLogin;
							ViewBag.IsAutoLogin = sessionManager.IsAutoLogin;
							ViewBag.IsAdmin = sessionManager.IsAdmin;
							ViewBag.IsLecturer = sessionManager.IsLecturer;

							//안 읽은 쪽지
							Hashtable hashForNote = new Hashtable();
							hashForNote.Add("RowState", "B");
							hashForNote.Add("ReceiveUserNo", sessionManager.UserNo);
							ViewBag.NoteReceiveCount = baseSvc.Get<Note>("note.NOTE_SELECT_B", hashForNote).NotReadNoteCount;
						}

						//권한별 메뉴
						Hashtable ht = new Hashtable();
						ht.Add("UserType", ViewBag.User.UserType);
						IList<Menu> menuList = baseSvc.GetList<Menu>("system.MENU_SELECT_A", ht);
						menuList = menuList.OrderBy(c => c.SortNo).ToList();

						ViewBag.MenuList = menuList.Where(c => c.MenuType == "U").ToList();
						ViewBag.LecMenuList = menuList.Where(c => c.MenuType == "L").Where(c => c.VisibleYesNo == "Y").ToList();
						ViewBag.AdmMenuList = menuList.Where(c => c.MenuType == "A").Where(c => c.VisibleYesNo == "Y").ToList();

						string menuUrl = ("/" + filterContext.RouteData.Values["controller"] + "/" + filterContext.RouteData.Values["action"]).ToUpper();
						if (filterContext.RouteData.Values["controller"].ToString().ToUpper().Equals("BOARD"))
						{
							menuUrl += "/%/" + filterContext.RouteData.Values["param2"];
						}

						Menu paramMenu = new Menu();
						paramMenu.MenuUrl = menuUrl;
						Menu currentMenu = baseSvc.Get<Menu>("system.MENU_SELECT_B", paramMenu);

						if (currentMenu == null)
						{
							Menu emptyMenu = new Menu();
							emptyMenu.MenuLv = 3;
							emptyMenu.MenuName = "";

							List<Menu> emptyMenuList = new List<Menu>();
							emptyMenuList.Add(emptyMenu);

							ViewBag.LeftMenuList = emptyMenuList;
							ViewBag.CurrentMenuCode = "0";
							ViewBag.CurrentMenuTitle = "등록이 필요한 메뉴입니다.";
							ViewBag.UpperMenuCode = "0";
							ViewBag.UpperMenuTitle = "미등록 메뉴";
							ViewBag.HighestMenuCode = "0";
							ViewBag.HighestMenuTitle = "미등록 메뉴";
						}
						else
						{
							ViewBag.LeftMenuList = menuList.Where(c => c.UpperMenuCode == currentMenu.HighestMenuCode).ToList();
							ViewBag.CurrentMenuCode = currentMenu.MenuCode;
							ViewBag.CurrentMenuTitle = currentMenu.MenuName;
							ViewBag.UpperMenuCode = currentMenu.UpperMenuCode;
							ViewBag.UpperMenuTitle = currentMenu.UpperMenuName;
							ViewBag.HighestMenuCode = currentMenu.HighestMenuCode;
							ViewBag.HighestMenuTitle = currentMenu.HighestMenuName;
						}

						// 공통코드
						Code code = new Code("A", new string[] { "SNSC" });
						code.DeleteYesNo = "N";
						code.UseYesNo = "Y";
						ViewBag.baseCodes = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).ToList();

						//관련사이트
						ViewBag.FamilySiteList = baseSvc.GetList<FamilySite>("system.FAMILYSITE_SELECT_L", null);

						//메인 하단 교육과정리스트(분류)
						Hashtable htMoocCate = new Hashtable();
						htMoocCate.Add("IsOpen", 1);
						ViewBag.CategoryList = baseSvc.GetList<Category>("course.COURSE_CATEGORY_SELECT_L", htMoocCate);
					}
				}
			}
		}

		//페이징 : 화면 표시 시작번호
		public int FirstIndex(int rowSize, int pageNum)
		{
			return rowSize * (pageNum - 1) + 1;
		}

		//페이징 : 화면 표시 종료번호
		public int LastIndex(int rowSize, int pageNum)
		{
			return rowSize * pageNum;
		}

		public void SaveFile(string paramFileNewName, string paramSaveFolderName, string paramSubFolderName)
		{
			string fileFolderPath = Server.MapPath(string.Format(@"\{0}\{1}", FileRootFolder, "Temp"));
			string fileFolderToday = Server.MapPath(string.Format(@"\{0}\{1}\{2}", FileRootFolder, paramSaveFolderName, paramSubFolderName));
			string fileFullPath = string.Format(@"{0}\{1}", fileFolderPath, Path.GetFileName(paramFileNewName));//임시폴더경로
			if (System.IO.File.Exists(fileFullPath))
			{
				DirectoryInfo dir = new DirectoryInfo(fileFolderToday);
				if (dir.Exists)
				{
					System.IO.File.Move(string.Format("{0}\\{1}", fileFolderPath, Path.GetFileName(paramFileNewName)), string.Format("{0}\\{1}", fileFolderToday, Path.GetFileName(paramFileNewName)));
				}
				else
				{
					dir.Create();
					System.IO.File.Move(string.Format("{0}\\{1}", fileFolderPath, Path.GetFileName(paramFileNewName)), string.Format("{0}\\{1}", fileFolderToday, Path.GetFileName(paramFileNewName)));
				}
			}
		}

		public long FileUpload(string rowState, string folderName, long? fileGroupNo, string filename)
		{
			Hashtable htFileFolder = new Hashtable();
			htFileFolder.Add("RowState", "S");
			htFileFolder.Add("FolderName", folderName);
			string subFolderName = baseSvc.Get<FileFolder>("common.FILEFOLDER_SELECT_S", htFileFolder).FolderName;
			fileGroupNo = fileGroupNo > 0 ? (long?)fileGroupNo : null;
			fileGroupNo = SaveFile(Request.Files, filename, fileGroupNo, folderName);

			//업로드한 파일이 디렉토리에 저장되었는지 확인
			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fileGroupNo ?? 0);
			htFile.Add("DeleteYesNo", "N");

			foreach (var item in baseSvc.GetList<Design.Domain.File>("common.FILE_SELECT_L", htFile))
			{
				if (!System.IO.File.Exists(Server.MapPath("/" + FileRootFolder + item.SaveFileName)))
				{
					fileGroupNo = 0;
					if ("C" == rowState)
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

			return fileGroupNo ?? 0;
		}

		//단일 파일저장 overloading
		public long FileUpload(string rowState, string folderName, long? fileGroupNo, string filename, HttpPostedFileBase file)
		{
			Hashtable htFileFolder = new Hashtable();
			htFileFolder.Add("RowState", "S");
			htFileFolder.Add("FolderName", folderName);
			string subFolderName = baseSvc.Get<FileFolder>("common.FILEFOLDER_SELECT_S", htFileFolder).FolderName;
			fileGroupNo = fileGroupNo > 0 ? (long?)fileGroupNo : null;
			fileGroupNo = SaveSingleFile(file, filename, fileGroupNo, folderName);

			//업로드한 파일이 디렉토리에 저장되었는지 확인
			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fileGroupNo ?? 0);
			htFile.Add("DeleteYesNo", "N");

			foreach (var item in baseSvc.GetList<Design.Domain.File>("common.FILE_SELECT_L", htFile))
			{
				if (!System.IO.File.Exists(Server.MapPath("/" + FileRootFolder + item.SaveFileName)))
				{
					fileGroupNo = 0;
					if ("C" == rowState)
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

			return fileGroupNo ?? 0;
		}

		//파일 저장
		protected Int64? SaveFile(HttpFileCollectionBase files, String filename, Int64? fgno, string saveFolderName, int getindex = -1)
		{
			fgno = fgno > 0 ? (long?)fgno : null;
			if (files == null || (getindex > -1 && files.Count <= getindex))
			{
				return fgno;
			}
			List<HttpPostedFileBase> hpfs = new List<HttpPostedFileBase>();
			for (int i = files.Count; i > 0; i--)
			{
				if (!string.IsNullOrEmpty(files[i - 1].FileName) && (getindex == -1 || getindex == i - 1))
				{
					hpfs.Insert(0, files.Get(i - 1));
				}
			}
			if (hpfs.Count() > 0)
			{
				int fcount = hpfs.Count;
				int incount = 0;
				string[] fileName = new string[fcount];
				string[] fileNewName = new string[fcount];
				string[] fileSize = new string[fcount];
				string[] fileType = new string[fcount];
				if (!Directory.Exists(Server.MapPath("/" + FileRootFolder) + "/" + saveFolderName))
				{
					Directory.CreateDirectory(Server.MapPath("/" + FileRootFolder) + "/" + saveFolderName);
				}
				foreach (var f in hpfs)
				{
					if (f != null && !string.IsNullOrEmpty(f.FileName))
					{
						fileName[incount] = f.FileName.Split('\\').Last();
						//fileNewName[incount] = sessionManager.UserNo.ToString() + "_" + getindex + "_" + DateTime.Now.ToString("yyyyMMddHHmmssFFF") + "." + f.FileName.Split('.').Last();
						fileNewName[incount] = sessionManager.UserNo.ToString() + "_" + getindex + "_" + DateTime.Now.ToString("yyyyMMddHHmmssFFF") + "_" + incount + "." + f.FileName.Split('.').Last();
						fileSize[incount] = f.ContentLength.ToString();
						fileType[incount] = f.FileName.Split('.').Last(); //f.ContentType;
						f.SaveAs(Server.MapPath("/" + FileRootFolder) + "/" + saveFolderName + "/" + fileNewName[incount]);
						incount++;
					}
				}
				fgno = FileInsert(fileName, fileNewName, fileSize, fileType, saveFolderName, saveFolderName, sessionManager.UserNo, fgno);

			}
			return fgno ?? 0;
		}


		//단일 파일 저장
		protected Int64? SaveSingleFile(HttpPostedFileBase file, String filename, Int64? fgno, string saveFolderName, int getindex = -1)
		{
			fgno = fgno > 0 ? (long?)fgno : null;

			string fileName = file.FileName.Split('\\').Last();
			string fileNewName = sessionManager.UserNo.ToString() + "_" + getindex + "_" + DateTime.Now.ToString("yyyyMMddHHmmssFFF") + "." + file.FileName.Split('.').Last();
			string fileSize = file.ContentLength.ToString();
			string fileType = file.FileName.Split('.').Last(); //f.ContentType;

			if (!Directory.Exists(Server.MapPath("/" + FileRootFolder) + "/" + saveFolderName))
			{
				Directory.CreateDirectory(Server.MapPath("/" + FileRootFolder) + "/" + saveFolderName);
			}

			file.SaveAs(Server.MapPath("/" + FileRootFolder) + "/" + saveFolderName + "/" + fileNewName);


			int saveCount = 0;
			Hashtable htFileFolder = new Hashtable();
			htFileFolder.Add("RowState", "S");
			htFileFolder.Add("FolderName", "Board");
			int fileFolderNo = baseSvc.Get<FileFolder>("common.FILEFOLDER_SELECT_S", htFileFolder).FolderNo;

			Hashtable htFileGroup = new Hashtable();
			htFileGroup.Add("RowState", "C");
			htFileGroup.Add("FolderNo", fileFolderNo);
			long fileGroupNo = fgno == null || fgno == 0 ? baseSvc.Get<FileGroup>("common.FILEGROUP_SAVE_C", htFileGroup).FileGroupNo : (long)fgno; //저장하고 그룹번호 가져옴.

			string changedFileName = fileName.IsNormalized() ? fileName : fileName.Normalize();

			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "C");
			htFile.Add("FileGroupNo", fileGroupNo);
			htFile.Add("OriginFileName", changedFileName);
			htFile.Add("SaveFileName", string.Format(@"/{0}/{1}", saveFolderName, fileNewName));
			htFile.Add("FileSize", int.Parse(fileSize));
			htFile.Add("Extension", fileType.StartsWith(".") ? fileType.Substring(1) : fileType.Substring(0));
			htFile.Add("UseYesNo", "Y");
			htFile.Add("DeleteYesNo", "N");
			htFile.Add("CreateUserNo", sessionManager.UserNo);

			saveCount = baseSvc.Save("common.FILE_SAVE_C", htFile);

			return fileGroupNo;
		}

		public long FileInsert(string[] paramFileName, string[] paramFileNewName, string[] paramFileSize, string[] paramFileExt, string paramFolderName, string paramSaveFolderName, long paramUserNo, long? paramFileGroupNo)
		{
			int saveCount = 0;
			Hashtable htFileFolder = new Hashtable();
			htFileFolder.Add("RowState", "S");
			htFileFolder.Add("FolderName", "Board");
			int fileFolderNo = baseSvc.Get<FileFolder>("common.FILEFOLDER_SELECT_S", htFileFolder).FolderNo;

			Hashtable htFileGroup = new Hashtable();
			htFileGroup.Add("RowState", "C");
			htFileGroup.Add("FolderNo", fileFolderNo);
			long fileGroupNo = paramFileGroupNo == null || paramFileGroupNo == 0 ? baseSvc.Get<FileGroup>("common.FILEGROUP_SAVE_C", htFileGroup).FileGroupNo : (long)paramFileGroupNo; //저장하고 그룹번호 가져옴.
			for (int i = 0; i < paramFileName.Length; i++)
			{
				string changedFileName = paramFileName[i].IsNormalized() ? paramFileName[i] : paramFileName[i].Normalize();

				Hashtable htFile = new Hashtable();
				htFile.Add("RowState", "C");
				htFile.Add("FileGroupNo", fileGroupNo);
				htFile.Add("OriginFileName", changedFileName);
				htFile.Add("SaveFileName", string.Format(@"/{0}/{1}", paramSaveFolderName, paramFileNewName[i]));
				htFile.Add("FileSize", int.Parse(paramFileSize[i]));
				htFile.Add("Extension", paramFileExt[i].StartsWith(".") ? paramFileExt[i].Substring(1) : paramFileExt[i].Substring(0));
				htFile.Add("UseYesNo", "Y");
				htFile.Add("DeleteYesNo", "N");
				htFile.Add("CreateUserNo", paramUserNo);

				saveCount += baseSvc.Save("common.FILE_SAVE_C", htFile);
			}
			return fileGroupNo;

		}

		public void FileDeleteByGroup(long fgno)
		{
			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "L");
			htFile.Add("FileGroupNo", fgno);
			foreach (var f in baseSvc.GetList<ILMS.Design.Domain.File>("common.FILE_SELECT_L", htFile))
			{
				FileDelete(f.FileNo);
			}
		}

		public JsonResult FileDelete(long paramFileId)
		{
			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "S");
			htFile.Add("FileNo", paramFileId);
			ILMS.Design.Domain.File entity = baseSvc.Get<ILMS.Design.Domain.File>("common.FILE_SELECT_S", htFile);

			if (entity != null)
			{
				if (System.IO.File.Exists(Request.MapPath("/Files/" + entity.SaveFileName)))
				{
					System.IO.File.Delete(Request.MapPath("/Files/" + entity.SaveFileName));
				}
			}

			htFile = new Hashtable();
			htFile.Add("RowState", "B");
			htFile.Add("FileNo", paramFileId);
			return this.Json(baseSvc.Save("common.FILE_SAVE_B", htFile), JsonRequestBehavior.AllowGet);
		}

		public ActionResult ExportExcel(string[] paramHeaders, string[] paramColumns, IEnumerable paramObj, string paramFileNameNoExt, System.Data.DataTable _dt = null)
		{
			var dataGrid = new System.Web.UI.WebControls.DataGrid();
			var dataTable = new System.Data.DataTable(paramFileNameNoExt);
			if (_dt == null)
			{
				//컬럼생성
				for (int i = 0; i < paramHeaders.Length; i++)
				{
					dataTable.Columns.Add(paramHeaders[i]);
				}

				foreach (object instance in paramObj)
				{
					Type t = instance.GetType();

					System.Data.DataRow newRow = dataTable.NewRow();
					for (int i = 0; i < paramColumns.Length; i++)
					{
						if (t.Equals(typeof(Hashtable)))
						{
							newRow[i] = (instance as Hashtable)[paramColumns[i]].ToString();
						}
						else
						{
							System.Reflection.PropertyInfo property = t.GetProperty(paramColumns[i]);
							newRow[i] = property.GetValue(instance, null);
						}
					}
					dataTable.Rows.Add(newRow);
				}
			}
			else
			{
				dataTable = _dt;
			}
			dataGrid.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(dataExportExcel_ItemDataBound);
			dataGrid.DataSource = dataTable;
			dataGrid.DataBind();
			System.IO.StringWriter sw = new System.IO.StringWriter();
			System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(sw);
			dataGrid.RenderControl(htmlWrite);
			System.Text.StringBuilder sbResponseString = new System.Text.StringBuilder();

			sbResponseString.Append("<html xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns=\"http://www.w3.org/TR/REC-html40\">");
			sbResponseString.Append("<head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\"><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>Sheet1</x:Name><x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head> <body>");
			sbResponseString.Append(sw.ToString() + "</body></html>");

			Response.Clear();
			Response.AppendHeader("Content-Type", "application/vnd.ms-excel");
			Response.AppendHeader("Content-disposition", "attachment; filename=" + HttpUtility.UrlEncode(string.Format(paramFileNameNoExt + ".xls"), Encoding.UTF8));
			Response.Charset = "utf-8";
			Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");

			Response.Write(sbResponseString.ToString());
			Response.Flush();
			System.Web.HttpContext.Current.ApplicationInstance.CompleteRequest();
			return null;
		}

		private void dataExportExcel_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if (e.Item.ItemType == System.Web.UI.WebControls.ListItemType.Header)
			{
				e.Item.Font.Bold = true;
				int cellIndex = 0;
				while (cellIndex < e.Item.Cells.Count)
				{
					e.Item.Cells[cellIndex].Attributes.Add("x:autofilter", "all");
					e.Item.Cells[cellIndex].Width = 150;
					e.Item.Cells[cellIndex].HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
					cellIndex++;
				}
			}

			if (e.Item.ItemType == System.Web.UI.WebControls.ListItemType.Item || e.Item.ItemType == System.Web.UI.WebControls.ListItemType.AlternatingItem)
			{
				int cellIndex = 0;
				while (cellIndex < e.Item.Cells.Count)
				{
					e.Item.Cells[cellIndex].HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Left;
					cellIndex++;
				}
			}
		}

		public string ConvertToSecurityPassword(string password)
		{
			SHA256Managed hash = new SHA256Managed();
			byte[] signatureData = hash.ComputeHash(Encoding.UTF8.GetBytes(password), 0, Encoding.UTF8.GetByteCount(password));

			string hashResult = BitConverter.ToString(signatureData).Replace("-", "").ToLower();

			return hashResult;
		}

	}
}