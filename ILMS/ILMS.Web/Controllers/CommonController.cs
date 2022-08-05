using ICSharpCode.SharpZipLib.Zip;
using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.Configuration;
using System.Web.Mvc;

namespace ILMS.Web.Controllers
{
	[RoutePrefix("Common")]
	public class CommonController : Controller
	{
		public BaseService baseSvc { get; set; }

		public SessionManager sessionManager { get; set; }

		private static string _fileRootFolder = WebConfigurationManager.AppSettings["FileRootFolder"].ToString();

		public static string FileRootFolder
		{
			get
			{
				return _fileRootFolder;
			}
		}

		[Route("SearchUser")]
		public ActionResult SearchUser(AccountViewModel vm)
		{
			ViewBag.CurrentMenuTitle = "사용자 검색";
			ViewBag.InfoMessage = "";

			return View(vm);
		}

		[Route("UserList")]
		public ActionResult UserList(AccountViewModel vm)
		{
			ViewBag.CurrentMenuTitle = "사용자 검색";
			ViewBag.InfoMessage = "";

			vm.UserList = new List<User>();

			return View(vm);
		}

		[HttpPost]
		public JsonResult UserList(string SearchGbn, string SearchText)
		{
			Hashtable paramHash = new Hashtable();
			paramHash.Add("SearchGbn", SearchGbn);
			paramHash.Add("SearchText", SearchText);
			IList<User> userList = baseSvc.GetList<User>("account.USER_SELECT_L", paramHash);
			return Json(userList);
		}

		[Route("FileDownLoad")]
		public void FileDownLoad(int? param1)
		{
			string uploadDir = Server.MapPath(string.Format(@"\{0}", FileRootFolder));

			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "A");
			htFile.Add("FileNo", param1 ?? 0);
			baseSvc.Save("common.FILE_SAVE_A", htFile);// 파일 다운로드 횟수 1 증가

			htFile = new Hashtable();
			htFile.Add("RowState", "S");
			htFile.Add("FileNo", param1 ?? 0);
			File entity = baseSvc.Get<File>("common.FILE_SELECT_S", htFile);      // 파일의 상세 정보를 가져온다.
			if ((param1 ?? 0) > 0)
			{
				var cds = new System.Net.Mime.ContentDisposition
				{
					FileName = Server.UrlEncode(entity.OriginFileName),     // 파일의 원래이름(등록할때의 이름)
					Inline = false,
				};
				Response.ClearContent();
				Response.AppendHeader("Content-Disposition", cds.ToString());
				Response.AppendHeader("Content-Length", entity.FileSize.ToString());
				Response.TransmitFile(string.Format("{0}\\{1}", uploadDir, entity.SaveFileName));
				Response.Flush();
			}
			else
			{
				Response.Write("<script language='javascript'>");
				Response.Write("alert('파일이 존재하지 않습니다.');");
				Response.Write("history.back ();");
				Response.Write("</script>");
			}
		}

		[Route("FileDelete")]
		public JsonResult FileDelete(int? param1)
		{
			Hashtable htFile = new Hashtable();
			htFile.Add("RowState", "S");
			htFile.Add("FileNo", param1 ?? 0);
			File entity = baseSvc.Get<File>("common.FILE_SELECT_S", htFile);      // 파일의 상세 정보를 가져온다.

			htFile = new Hashtable();
			htFile.Add("RowState", "D");
			htFile.Add("FileNo", param1 ?? 0);
			htFile.Add("CreateUserNo", sessionManager.UserNo);
			if (ViewBag != null && entity != null && baseSvc.Save("common.FILE_SAVE_D", htFile) == 1)
			{
				try
				{
					System.IO.File.Delete(Request.MapPath("/Files/" + entity.SaveFileName));
				}
				catch (Exception) { }
				return Json(1);
			}
			return Json(0);
		}

		[Route("DownloadFileZip")]
		public JsonResult DownloadFileZip(string param1, string param2, string param3, string param4)
		{
			//param1 = fileno, param2 = title
			IList<File> fileList;
			List<File> newFileList = new List<File>();

			string fileName = string.Empty;
			param1 = param1.Substring(0,1).Equals("|") ? param1.Substring(1) : param1;

			for (int i = 0; i < param1.Split('|').Length; i++)
			{
				if (!param1.Split('|').Equals("0"))
				{
					if (!Convert.ToInt32(param1.Split('|')[i]).Equals(0)){
						File file = new File("L");
						file.FileGroupNo = Convert.ToInt32(param1.Split('|')[i]);
						fileList = baseSvc.GetList<File>("common.FILE_SELECT_L", file);

						foreach (var item in fileList)
						{
							item.SaveFileName = Server.MapPath("/Files" + item.SaveFileName);
							newFileList.Add(item);
						}
					}
				}
			}

			fileName = string.Format("{0}_{1}.zip", param2, DateTime.Now.ToString("yyyyMMddhhmmss"));

			string strSaveFile = "";
			bool ret = false;

			if (newFileList.Count > 0)
			{
				ret = ZipFiles(newFileList, Server.MapPath("/Files/" + param3 +"/") + fileName, param4);
				if (ret)
				{
					strSaveFile = "/Files/" + param3 +"/" + fileName;
				}
			}

			return Json(strSaveFile);
		}

		[Route("ZipFiles")]
		public static bool ZipFiles(IList<File> targetFile, string zipFilePath, string password)
		{
			bool retVal = false;

			ZipFile zfile = ZipFile.Create(System.IO.Path.Combine(zipFilePath));

			try
			{
				// 패스워드가 있는 경우 패스워드 지정.
				if (password != null && password != String.Empty)
					zfile.Password = password;

				zfile.BeginUpdate();

				foreach (var item in targetFile)
				{
					zfile.Add(item.SaveFileName, System.IO.Path.GetFileName(item.SaveFileName));
				}

				zfile.CommitUpdate();


				retVal = true;
			}
			catch
			{
				retVal = false;

				// 오류가 난 경우 생성 했던 파일을 삭제.
				if (System.IO.File.Exists(zipFilePath))
					System.IO.File.Delete(zipFilePath);
			}
			finally
			{
				zfile.Close();
			}

			return retVal;
		}
	}
}