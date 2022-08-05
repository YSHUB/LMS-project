using ILMS.Core.System;
using ILMS.Data.Dao;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;

namespace ILMS.Web.Controllers
{
    [RoutePrefix("Account")]
    public class AccountController : WebBaseController
    {
        public AccountService accountSvc { get; set; }

        [Route("Index")]
        public ActionResult Index()
        {
            return View();
        }

        [Route("LogOnProcess")]
        public ActionResult LogOnProcess(AccountViewModel vm)
        {
            string clientIP = Request.ServerVariables["REMOTE_ADDR"].ToString();

            if (vm.UnivCode().Equals("HYC"))
            {
                if (vm.LoginGbn.Equals("E"))
                {
                    vm.UserID = "E" + vm.UserID;
                }
            }

            //일치하는 사용자 확인
            User user = new User();
            vm.Password = vm.Password == null ? "" : vm.Password;
            user = accountSvc.Login(vm.UserID, vm.Password, clientIP);

            if (user != null)
            {
                accountSvc.SignIn(user.UserID, false);

                //로그인 기록 저장
                Hashtable hashForLoginSave = new Hashtable();
                hashForLoginSave.Add("UserNo", user.UserNo);
                hashForLoginSave.Add("IPAddress", Request.UserHostAddress);
                hashForLoginSave.Add("ConnectGubun", Request.Browser.IsMobileDevice ? 2 : 1);
                hashForLoginSave.Add("UserAgent", Request.UserAgent);
                baseSvc.Save("account.LOGIN_SAVE_B", hashForLoginSave);

                // 접속 내역 확인
                Hashtable hashForLoginUser = new Hashtable();
                hashForLoginUser.Add("UserNo", user.UserNo);
                User loginUser = baseSvc.Get<User>("account.LOGIN_SELECT_C", hashForLoginUser);

                //접속 기록에 따른 user객체 업데이트
                if (loginUser != null)
                {
                    user.IPAddress = loginUser.LoginIPAddress;
                    user.LastConnectedDay = loginUser.LoginDay;
                }
                else
                {
                    user.IPAddress = clientIP;
                    user.LastConnectedDay = DateTime.Now.ToString("yyyy-MM-dd");
                }

                //세션 저장
                sessionManager.IsLogin = true;
                sessionManager.IsAutoLogin = false;
				if (vm.UnivYN().Equals("Y"))
				{
					sessionManager.IsAdmin = new string[] { "USRT010", "USRT011", "USRT012" }.Any(user.UserType.Contains);
				}
				else
				{
					sessionManager.IsAdmin = new string[] { "USRT010", "USRT011" }.Any(user.UserType.Contains);
				}
                sessionManager.IsGeneral = user.IsGeneral;
                sessionManager.IsLecturer = new string[] { "USRT007", "USRT009", "USRT010", "USRT011", "USRT012" }.Any(user.UserType.Contains);
                sessionManager.SetValue(SessionConstants.UserInfo, user);
				sessionManager.AdminUserNo = sessionManager.IsAdmin ? user.UserNo : 0;
				sessionManager.UserNo = user.UserNo;
                sessionManager.UserType = user.UserType;
                sessionManager.LoginNo = loginUser.LoginNo;

                return Redirect("/");
            }
            else
            {
                return Redirect(string.Format("{0}://{1}{2}?InfoMessage={3}", vm.SSLStr(), Request.UrlReferrer.Authority, Request.UrlReferrer.LocalPath, "MSG_ERROR_LOGIN"));
            }
        }

		[AuthorFilter(IsAdmin = true)]
        [Route("AutoLogOnProcess")]
        public ActionResult AutoLogOnProcess(string userNo, string returnUrl)
		{
			UserAccessSave(7, "AdminUserNo:" + sessionManager.AdminUserNo + " Login to UserNo:" + userNo);
			
			Hashtable htUser = new Hashtable();
            htUser.Add("UserNo", userNo);
			User user = baseSvc.Get<User>("account.USER_SELECT_S", htUser);

            if (user != null)
            {
                accountSvc.SignIn(user.UserID, false);

				user.LastConnectedDay = DateTime.Now.ToString("yyyy-MM-dd");
				user.IPAddress = Request.ServerVariables["REMOTE_ADDR"].ToString();

				//세션 저장
				sessionManager.IsLogin = true;
                sessionManager.IsAutoLogin = true;
				if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
				{
					sessionManager.IsAdmin = new string[] { "USRT010", "USRT011", "USRT012" }.Any(user.UserType.Contains);
				}
				else
				{
					sessionManager.IsAdmin = new string[] { "USRT010", "USRT011" }.Any(user.UserType.Contains);
				}
				sessionManager.IsGeneral = user.IsGeneral;
                sessionManager.IsLecturer = new string[] { "USRT007", "USRT009", "USRT010", "USRT011", "USRT012" }.Any(user.UserType.Contains);
                sessionManager.SetValue(SessionConstants.UserInfo, user);
                sessionManager.UserNo = user.UserNo;
                sessionManager.UserType = user.UserType;

                if (!string.IsNullOrEmpty(returnUrl))
                {
					if (WebConfigurationManager.AppSettings["UseSSL"].ToString().Equals("Y"))
					{
						return Redirect(returnUrl.Replace("http://", "https://") + "?InfoMessage=MSG_AUTO_LOGIN");
					}
					else
					{
						return Redirect(returnUrl.Replace("https://", "http://") + "?InfoMessage=MSG_AUTO_LOGIN");
					}
                }
                else
                {
                    return Redirect("/?InfoMessage=MSG_AUTO_LOGIN");
                }
            }
            return Redirect("/?InfoMessage=MSG_AUTO_LOGIN");
        }
		
		[Route("AutoLogout")]
		public ActionResult AutoLogout(string returnUrl)
		{
			UserAccessSave(7, "AdminUserNo:" + sessionManager.AdminUserNo + " Logout From UserNo:" + sessionManager.UserNo);

			Hashtable htUser = new Hashtable();
			htUser.Add("UserNo", sessionManager.AdminUserNo);
			User user = baseSvc.Get<User>("account.USER_SELECT_S", htUser);

			if (user != null)
			{
				Hashtable hashForLoginUser = new Hashtable();
				hashForLoginUser.Add("UserNo", user.UserNo);
				User loginUser = baseSvc.Get<User>("account.LOGIN_SELECT_C", hashForLoginUser);

				//접속 기록에 따른 user객체 업데이트
				if (loginUser != null)
				{
					user.LastConnectedDay = loginUser.LoginDay;
				}
				else
				{
					user.LastConnectedDay = DateTime.Now.ToString("yyyy-MM-dd");
				}

				user.IPAddress = Request.ServerVariables["REMOTE_ADDR"].ToString();

				sessionManager.IsLogin = true;
				sessionManager.IsAutoLogin = false;
				sessionManager.IsAdmin = true;
				sessionManager.IsGeneral = user.IsGeneral;
				sessionManager.IsLecturer = new string[] { "USRT007", "USRT009", "USRT010", "USRT011", "USRT012" }.Any(user.UserType.Contains);
				sessionManager.SetValue(SessionConstants.UserInfo, user);
				sessionManager.UserNo = user.UserNo;
				sessionManager.AdminUserNo = user.UserNo;
				sessionManager.UserType = user.UserType;

				if (!string.IsNullOrEmpty(returnUrl))
				{
					if (WebConfigurationManager.AppSettings["UseSSL"].ToString().Equals("Y"))
					{
						return Redirect(returnUrl.Replace("http://", "https://"));
					}
					else
					{
						return Redirect(returnUrl.Replace("https://", "http://"));
					}
				}
				else
				{
					return Redirect("/");
				}
			}
			return Redirect("/");
		}
		
		[Route("Logout")]
        public ActionResult Logout(AccountViewModel vm)
		{
			if (sessionManager.IsAutoLogin)
			{
				UserAccessSave(7, "AdminUserNo:" + sessionManager.AdminUserNo + " Logout From UserNo:" + sessionManager.UserNo);
			}

			//로그아웃 기록
			Hashtable paramHash = new Hashtable();
            paramHash.Add("LoginNo", sessionManager.LoginNo);

            int IsLogout = baseSvc.Save("account.LOGIN_SAVE_C", paramHash);

            if (IsLogout > 0)
            {
                accountSvc.SignOut();
                sessionManager.Abandon();

                return Redirect("/Home/Index");
            }
            else
            {
                return Redirect(string.Format("{0}://{1}{2}?InfoMessage={3}", vm.SSLStr(), Request.UrlReferrer.Authority, Request.UrlReferrer.LocalPath, "MSG_ERROR_LOGOUT"));
            }
        }

		#region 접속통계

		[AuthorFilter(IsAdmin = true)]
		[Route("AccessListTime")]
        public ActionResult AccessListTime(StatisticsViewModel vm)
        {
            // 강의실/홈페이지 공통코드 조회
            Code code = new Code();
            code.ClassCode = "BTYP";
            code.DeleteYesNo = "N";
            code.UseYesNo = "Y";

            vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

            // 활동통계 조회

            if (vm.Year == null)
            {
                vm.Year = System.DateTime.Today.ToString("yyyy");
            }
            if (vm.Month == null)
            {
                vm.Month = System.DateTime.Today.ToString("MM");
            }
            if (vm.Day == null)
            {
                vm.Day = System.DateTime.Today.ToString("dd");
            }

            vm.Gubun = vm.Gubun ?? "BTYP001";

            Hashtable paramForAccessList = new Hashtable();
            paramForAccessList.Add("SearchDate", vm.Year + "-" + String.Format("{0:D2}", Convert.ToInt16(vm.Month)) + "-" + String.Format("{0:D2}", Convert.ToInt16(vm.Day)));

            if (vm.Gubun == "BTYP001")
            {
                vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_L", paramForAccessList);
                vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_B", paramForAccessList);
            }
            else
            {
                vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_A", paramForAccessList);
                vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_E", paramForAccessList);
            }

            return View(vm);
        }

		[AuthorFilter(IsAdmin = true)]
		[Route("AccessListDay")]
        public ActionResult AccessListDay(StatisticsViewModel vm)
        {
            // 강의실/홈페이지 공통코드 조회
            Code code = new Code();
            code.ClassCode = "BTYP";
            code.DeleteYesNo = "N";
            code.UseYesNo = "Y";

            vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

            // 활동통계 조회
            if (vm.Year == null)
            {
                vm.Year = System.DateTime.Today.ToString("yyyy");
            }
            if (vm.Month == null)
            {
                vm.Month = System.DateTime.Today.ToString("MM");
            }

            vm.Gubun = vm.Gubun ?? "BTYP001";

            Hashtable paramForAccessList = new Hashtable();
            paramForAccessList.Add("SearchDate", vm.Year + "-" + String.Format("{0:D2}", Convert.ToInt16(vm.Month)));

            if (vm.Gubun == "BTYP001")
            {
                vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_F", paramForAccessList);
                vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_B", paramForAccessList);
            }
            else
            {
                vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_G", paramForAccessList);
                vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_E", paramForAccessList);
            }

            return View(vm);
        }

		[AuthorFilter(IsAdmin = true)]
		[Route("AccessListMonth")]
        public ActionResult AccessListMonth(StatisticsViewModel vm)
        {
            // 홈페이지/시험사이트 공통코드 조회
            Code code = new Code();
            code.ClassCode = "BTYP";
            code.DeleteYesNo = "N";
            code.UseYesNo = "Y";

            vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

            // 활동통계 조회
            if (vm.Year == null)
            {
                vm.Year = System.DateTime.Today.ToString("yyyy");
            }

            vm.Gubun = vm.Gubun ?? "BTYP001";

            Hashtable paramForAccessList = new Hashtable();
            paramForAccessList.Add("SearchDate", vm.Year);

            if (vm.Gubun == "BTYP001")
            {
                vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_H", paramForAccessList);
                vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_B", paramForAccessList);
            }
            else
            {
                vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_I", paramForAccessList);
                vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_E", paramForAccessList);
            }

            return View(vm);
        }

		[AuthorFilter(IsAdmin = true)]
		[Route("StatisticsExcelSave")]
        public ActionResult StatisticsExcelSave(StatisticsViewModel vm)
        {
            Hashtable paramForExcel = new Hashtable();

            string 구분명 = string.Empty;

            if (vm.Gubun == "BTYP001")
            {
                if (vm.Year != null)
                {
                    if (vm.Month != null)
                    {
                        if (vm.Day != null)
                        {                            
                            //시간별 접속횟수
                            paramForExcel.Add("SearchDate", vm.Year + "-" + string.Format("{0:D2}", Convert.ToInt16(vm.Month)) + "-" + string.Format("{0:D2}", Convert.ToInt16(vm.Day)));

                            vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_L", paramForExcel);
                            vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_B", paramForExcel);

                            구분명 = "시간별";

                        }
                        else
                        {
                            //일별 접속횟수
                            paramForExcel.Add("SearchDate", vm.Year + "-" + string.Format("{0:D2}", Convert.ToInt16(vm.Month)));

                            vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_F", paramForExcel);
                            vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_B", paramForExcel);

                            구분명 = "일별";
                        }
                    }
                    else
                    {
                        //월별 접속횟수
                        paramForExcel.Add("SearchDate", vm.Year);

                        vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_H", paramForExcel);
                        vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_B", paramForExcel);

                        구분명 = "월별";
                    }
                }
            }
            else
            {
                if (vm.Year != null)
                {
                    if (vm.Month != null)
                    {
                        if (vm.Day != null)
                        {
                            //시간별 접속횟수
                            paramForExcel.Add("SearchDate", vm.Year + "-" + string.Format("{0:D2}", Convert.ToInt16(vm.Month)) + "-" + string.Format("{0:D2}", Convert.ToInt16(vm.Day)));

                            vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_A", paramForExcel);
                            vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_E", paramForExcel);

                            구분명 = "시간별";
                        }
                        else
                        {
                            //일별 접속횟수
                            paramForExcel.Add("SearchDate", vm.Year + "-" + string.Format("{0:D2}", Convert.ToInt16(vm.Month)));

                            vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_G", paramForExcel);
                            vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_E", paramForExcel);

                            구분명 = "일별";
                        }
                    }
                    else
                    {
                        //월별 접속횟수
                        paramForExcel.Add("SearchDate", vm.Year);

                        vm.StatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_I", paramForExcel);
                        vm.HomeStatisticsList = baseSvc.GetList<Statistics>("statistics.STATISTICS_ACCESS_SELECT_E", paramForExcel);

                        구분명 = "월별";
                    }
                }
            }

            var dataGrid = new System.Web.UI.WebControls.DataGrid();
            var dataTable = new System.Data.DataTable("접속통계");

            dataTable.Columns.Add("번호");
            dataGrid.DataSource = dataTable;
            dataGrid.DataBind();

            System.IO.StringWriter sw = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(sw);
            dataGrid.RenderControl(htmlWrite);

            System.Text.StringBuilder sbResponseString = new System.Text.StringBuilder();

            sbResponseString.Append("<html xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns=\"http://www.w3.org/TR/REC-html40\">");
            sbResponseString.Append("<head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\"><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>파람컬럼 </x:Name><x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head> <body>");

            sbResponseString.Append("<table><tr><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td style='font-size:20px;'>접 속 통 계</td></tr>");

            if (vm.Year != null)
            {
                if (vm.Month != null)
                {
                    if (vm.Day != null)
                    {
                        sbResponseString.Append("<tr><td> " + vm.Year + "년 " + vm.Month + "월 " + vm.Day + "일 기준  </td></tr>");
                        sbResponseString.Append("<tr><td>시간</td><td>접속자 수</td><td>접속횟수</td></tr>");

                        for (int i = 0; 24 > i; i++)
                        {
                            sbResponseString.Append("<tr><td>" + i + "시~" + (i + 1) + "시</td><td>" + vm.StatisticsList.Where(c => c.LoginDay.Hour >= i && c.LoginDay.Hour < (i + 1)).Count() + "</td><td>" + vm.HomeStatisticsList.Where(c => c.NonLoginDay.Hour >= i && c.NonLoginDay.Hour < (i + 1)).Count() + "</td></tr>");
                        }
                    }
                    else
                    {
                        sbResponseString.Append("<tr><td> " + vm.Year + "년 " + vm.Month + "월 기준  </td></tr>");
                        sbResponseString.Append("<tr><td>일</td><td>접속자 수</td><td>접속횟수</td></tr>");

                        for (int i = 0; 31 > i; i++)
                        {
                            sbResponseString.Append("<tr><td>" + (i + 1) + "일</td><td>" + vm.StatisticsList.Where(c => c.LoginDay.Day.Equals(i + 1)).Count() + "</td><td>" + vm.HomeStatisticsList.Where(c => c.NonLoginDay.Day.Equals(i + 1)).Count() + "</td></tr>");
                        }
                    }

                }
                else
                {
                    sbResponseString.Append("<tr><td> " + vm.Year + "년 기준  </td></tr>");
                    sbResponseString.Append("<tr><td>월</td><td>접속자 수</td><td>접속횟수</td></tr>");

                    for (var i = 0; i < 12; i++)
                    {
                        sbResponseString.Append("<tr><td>" + (i + 1) + "월</td><td>" + vm.StatisticsList.Where(c => c.LoginDay.Month.Equals(i + 1)).Count() + "</td><td>" + vm.HomeStatisticsList.Where(c => c.NonLoginDay.Month.Equals(i + 1)).Count() + "</td></tr>");
                    }
                }

            }
            Code code = new Code();
            code.ClassCode = "BTYP";
                        
            string codeName = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(w => w.CodeValue.Equals(vm.Gubun)).Select(s => s.CodeName).FirstOrDefault() 
                + "_" + 구분명;

            Response.Clear();
            Response.AppendHeader("Content-Type", "application/vnd.ms-excel");
            Response.AppendHeader("Content-disposition", "attachment; filename=" + HttpUtility.UrlEncode(string.Format("접속통계자료_{0}.xls", codeName), Encoding.UTF8));
            Response.Charset = "utf-8";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");

            Response.Write(sbResponseString.ToString());
            Response.Flush();
            System.Web.HttpContext.Current.ApplicationInstance.CompleteRequest();
            return null;
        }

        #endregion 접속통계

        [AuthorFilter(IsAdmin = true)]
        public void UserAccessSave(int aType, string aData)
        {
            // 조회 시 사용자 접근내역 저장
            Hashtable paramUserAccess = new Hashtable();
            paramUserAccess.Add("UserNo", sessionManager.UserNo);
            paramUserAccess.Add("AType", aType);
            paramUserAccess.Add("AData", aData);
            baseSvc.Save("account.USER_SAVE_B", paramUserAccess);
        }

        #region 회원가입 등

        [Route("IDPWSearch")]
        public ActionResult IDPWSearch()
        {
            return View();
        }
		
        [HttpPost]
        public JsonResult CheckID(string paramHangulName, string paramEmail)
        {
            User user = new User();
            string paramUserType = "USRT015001";
            //user = userService.GetIDPWSearch(paramUserType, paramHangulName, paramResidentNo, null, paramEmail);

            Hashtable htIdCheck = new Hashtable();
            htIdCheck["UserType"] = paramUserType;
            htIdCheck["HangulName"] = paramHangulName;
            htIdCheck["Email"] = paramEmail;
            user = baseSvc.Get<User>("account.USER_SELECT_C", htIdCheck);
            string result = "";

            if (user != null)
            {
                result = user.UserID;
            }

            return Json(result);
        }
		
        [Route("JoinGeneral")]
        public ActionResult JoinGeneral(AccountViewModel vm)
        {

            // 공통코드 (구분 - 재직자,학생,미취업자,일반)
            Code code = new Code("A");
            code.ClassCode = "GUCD";
            vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code);

            if (!sessionManager.IsLogin)
			{
                return View(vm);
			}
			else
			{
                return Redirect(string.Format("/Home/Index?InfoMessage={0}", "MSG_ERROR_AUTHORITY"));
            }            
        }
		
        [HttpPost]
        public JsonResult CheckidEmail(String id, String email)
        {
            Int64 userNo = sessionManager.UserNo;

            Hashtable htResult = new Hashtable();

            Hashtable htIdCheck = new Hashtable();

            htIdCheck.Add("UserID", id);
            htResult.Add("id", Json(baseSvc.Get<int>("account.USER_SELECT_A", htIdCheck)));


            Hashtable htEmailCheck = new Hashtable();

            htEmailCheck.Add("Email", email);

            if(userNo > 0) //정보수정으로 들어올 때는 자기 정보는 제외
			{
                htEmailCheck.Add("UserNo", userNo);
			}

            htResult.Add("email", Json(baseSvc.Get<int>("account.USER_SELECT_B", htEmailCheck)));

            return Json(htResult);

        }

        [HttpPost]
        public JsonResult JoinGeneralJoin(Student user)
        {
            int cnt = 0;

            if (!string.IsNullOrEmpty(user.UserID) && user.UserID.Length > 5 && !string.IsNullOrEmpty(user.Password) && user.Password.Length > 7 && user.HangulName.Length > 1 && user.Email.Length > 4)
            {
                //아이디, 이름, 비밀번호, 이메일 체크

                user.UserType = "USRT001";
                user.ApprovalGubun = "UAST001";
                user.StudentYesNo = "N";
                user.ManagerYesNo = "N";
                user.IsGeneral = true;
                user.Password = ConvertToSecurityPassword(user.Password);
                user.HousePhoneOpenYesNo = "N";
                user.OfficePhoneOpenYesNo = "N";
                user.MobileOpenYesNo = "N";
                user.EmailOpenYesNo = "N";
                user.HouseAddressOpenYesNo = "N";
                user.OfficeAddressOpenYesNo = "N";
                user.ResidentNo = user.ResidentNo.Replace("-", "");

                if (!string.IsNullOrEmpty(user.Mobile))
                {
                    user.Mobile = user.Mobile.Replace("-", "");
                    if (user.Mobile.Length == 10)
                    {
                        user.Mobile = user.Mobile.Substring(0, 3) + "-" + user.Mobile.Substring(3, 3) + "-" + user.Mobile.Substring(6);
                    }
                    else if (user.Mobile.Length > 10)
                    {
                        user.Mobile = user.Mobile.Substring(0, 3) + "-" + user.Mobile.Substring(3, 4) + "-" + user.Mobile.Substring(7);
                    }
                }

                user.DeleteYesNo = user.DeleteYesNo ?? "N";
                user.UseYesNo = user.UseYesNo ?? "Y";
                user.StudentYesNo = user.StudentYesNo ?? "Y";

                int UserNo = baseSvc.Get<int>("account.USER_SAVE_C", user);
                Student student = new Student();
                student.UserNo = UserNo;

                cnt = baseSvc.Get<int>("student.STUDENT_SAVE_C", student);

            }
            return Json(cnt);
        }

		#endregion 회원가입 등

		#region 사용자관리

		#region 관리자

		[AuthorFilter(IsAdmin = true)]
		[Route("ListManager")]
        public ActionResult ListManager(AccountViewModel vm)
        {

            vm.User = new User();

            vm.PageRowSize = vm.PageRowSize ?? 10;
            vm.PageNum = vm.PageNum ?? 1;

            vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", new Code("A", new string[] { "USRT", "UAST" }));

            string searchText = HttpUtility.UrlDecode(vm.SearchText) ?? "";

            Hashtable htUserList = new Hashtable();
            htUserList.Add("UserType", string.IsNullOrEmpty(vm.UserType) ? "USRT010,USRT011,USRT012" : vm.UserType);
            htUserList.Add("UseYesNo", "Y");
            htUserList.Add("SearchGbn", vm.SearchOption ?? "I");
            htUserList.Add("SearchText", searchText);
            htUserList.Add("ApprovalGubun", "UAST001,UAST004");//인증상태: 정상,탈퇴

            htUserList.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
            htUserList.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
            //htUserList.Add("ResidentNo", "");


            vm.UserList = baseSvc.GetList<User>("account.USER_SELECT_L", htUserList);

            vm.PageTotalCount = vm.UserList.FirstOrDefault() != null ? vm.UserList.FirstOrDefault().TotalCount : 0;
            vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "UserType", vm.UserType }, { "SearchOption", vm.SearchOption }, { "SearchText", HttpUtility.UrlEncode(searchText) } };

            return View(vm);
        }

		[AuthorFilter(IsAdmin = true)]
		[HttpPost]
        public JsonResult CreateAdmin(AccountViewModel vm)
        {

            vm.User.Password = ConvertToSecurityPassword(vm.User.Password);

            //vm.User.UserID = vm.User.UserID;
            //vm.User.CreateUserNo = sessionManager.UserNo;
            //vm.User.UpdateUserNo = sessionManager.UserNo;

            vm.User.DeleteYesNo = vm.User.DeleteYesNo ?? "N";
            vm.User.UseYesNo = vm.User.UseYesNo ?? "Y";
            vm.User.ManagerYesNo = vm.User.ManagerYesNo ?? "Y";

            Int64 UserNo = 0;
            DaoFactory.Instance.BeginTransaction();

            try
            {
                UserNo = baseSvc.Get<int>("account.USER_SAVE_C", vm.User);
                vm.User.UserNo = UserNo;
                baseSvc.Save("account.USER_SAVE_E", vm.User);
                baseSvc.Save("account.USER_SAVE_G", vm.User);

                DaoFactory.Instance.CommitTransaction();
            }
            catch (Exception)
            {
                DaoFactory.Instance.RollBackTransaction();

                throw;
            }


            return Json(vm.User);

        }

		[AuthorFilter(IsAdmin = true)]
        public ActionResult ManagerUpdate(AccountViewModel vm)
        {

            //vm.User.AssignNo = (string)IsNullReverse(universty, campuss, organization, college, department, major);
            vm.User.UpdateUserNo = vm.User.UserNo;

            if (!string.IsNullOrEmpty(vm.User.Password))
                vm.User.Password = ConvertToSecurityPassword(vm.User.Password);


            baseSvc.Save("account.USER_SAVE_U", vm.User);


            return Json(vm.User);
        }

		#endregion

		#region 학생

		[AuthorFilter(IsAdmin = true)]
		[Route("ListStudent")]
        public ActionResult ListStudent(AccountViewModel vm)
        {
            vm.User = new User();

            vm.PageRowSize = vm.PageRowSize ?? 10;
            vm.PageNum = vm.PageNum ?? 1;

            vm.SearchText = HttpUtility.UrlDecode(vm.SearchText) ?? "";

            vm.UserType = "USRT001";
            Hashtable htUserList = new Hashtable();
            htUserList.Add("UserType", "USRT001");//유저타입 : 학부생
            htUserList.Add("UseYesNo", "Y");
            htUserList.Add("SearchGbn", vm.SearchOption ?? "I");        
            htUserList.Add("SearchText", vm.SearchText);

            htUserList.Add("AssignNo", vm.AssignNo ?? "");
            htUserList.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
            htUserList.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
            //htUserList.Add("ResidentNo", "");

            vm.UserList = baseSvc.GetList<User>("account.USER_SELECT_L", htUserList);

            vm.PageTotalCount = vm.UserList.FirstOrDefault() != null ? vm.UserList.FirstOrDefault().TotalCount : 0;
            vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize },  { "AssignNo", vm.AssignNo }, { "SearchOption", vm.SearchOption },{ "SearchText", HttpUtility.UrlEncode(vm.SearchText) } };

            Code paramCode = new Code("A", new string[] { "USRT", "UAST" });
            vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", paramCode);
            vm.AssignList = baseSvc.GetList<Assign>("common.COMMON_DEPT_SELECT_L", new Assign("L")).Where(c => c.HierarchyLevel >= 2).ToList();



            return View(vm);
        }

		[AuthorFilter(IsAdmin = true)]
		public ActionResult DetailStudent(AccountViewModel vm, int? param1)
        {


            User user = new User();
            user.UserNo = param1 ?? 0;
            vm.User = baseSvc.Get<User>("account.USER_SELECT_S", user);
            //baseSvc.Get<int>("account.USER_SELECT_H", user);


            IList<AssignHierarchy> userAssignInfos = baseSvc.GetList<AssignHierarchy>("account.USER_SELECT_H", vm.User);

            vm.University = (userAssignInfos.Count(c => c.HierarchyLevel == 1) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 1).AssignName;
            vm.Campus = (userAssignInfos.Count(c => c.HierarchyLevel == 2) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 2).AssignName;
            vm.Organization = (userAssignInfos.Count(c => c.HierarchyLevel == 3) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 3).AssignName;
            vm.College = (userAssignInfos.Count(c => c.HierarchyLevel == 4) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 4).AssignName;
            vm.Department = (userAssignInfos.Count(c => c.HierarchyLevel == 5) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 5).AssignName;
            vm.Major = (userAssignInfos.Count(c => c.HierarchyLevel == 6) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 6).AssignName;


            return View(vm);
        }

		#endregion

		#region 직원

		[AuthorFilter(IsAdmin = true)]
		[Route("ListStaff")]
        public ActionResult ListStaff(AccountViewModel vm)
        {

            vm.User = new User();
            vm.UserList = new List<User>();

            vm.PageRowSize = vm.PageRowSize ?? 10;
            vm.PageNum = vm.PageNum ?? 1;

            vm.SearchText = HttpUtility.UrlDecode(vm.SearchText) ?? "";

            Hashtable htUserList = new Hashtable();
            htUserList.Add("UserType", string.IsNullOrEmpty(vm.UserType) ? "USRT007,USRT009" : vm.UserType);
            htUserList.Add("UseYesNo", "Y");
            htUserList.Add("SearchGbn", vm.SearchOption ?? "I");
            htUserList.Add("SearchText", vm.SearchText);
            //htUserList.Add("UserGubun", "staff");
            htUserList.Add("AssignNo", vm.AssignNo ?? "");
            htUserList.Add("FirstIndex", FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
            htUserList.Add("LastIndex", LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
            //htUserList.Add("ResidentNo", "");

            vm.UserList = baseSvc.GetList<User>("account.USER_SELECT_L", htUserList);


            vm.PageTotalCount = vm.UserList.FirstOrDefault() != null ? vm.UserList.FirstOrDefault().TotalCount : 0;
            vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "UserType", vm.UserType }, { "AssignNo", vm.AssignNo }, { "SearchOption", vm.SearchOption }, { "SearchText", HttpUtility.UrlEncode(vm.SearchText) } };

            // AssignNo=<%:Model.AssignNo%>
            Code paramCode = new Code("A", new string[] { "USRT", "UAST" });
            vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", paramCode);
            vm.AssignList = baseSvc.GetList<Assign>("common.COMMON_DEPT_SELECT_L", new Assign("L")).Where(c => c.HierarchyLevel >= 2).ToList();

            return View(vm);
        }

		[AuthorFilter(IsAdmin = true)]
		[Route("DetailStaff")]
        [Route("DetailStaff/{param1}")]
        public ActionResult DetailStaff(AccountViewModel vm, int? param1)
        {


            User user = new User();
            user.UserNo = param1 ?? 0;
            vm.User = baseSvc.Get<User>("account.USER_SELECT_S", user);
            //baseSvc.Get<int>("account.USER_SELECT_H", user);


            IList<AssignHierarchy> userAssignInfos = baseSvc.GetList<AssignHierarchy>("account.USER_SELECT_H", vm.User);

            vm.University = (userAssignInfos.Count(c => c.HierarchyLevel == 1) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 1).AssignName;
            vm.Campus = (userAssignInfos.Count(c => c.HierarchyLevel == 2) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 2).AssignName;
            vm.Organization = (userAssignInfos.Count(c => c.HierarchyLevel == 3) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 3).AssignName;
            vm.College = (userAssignInfos.Count(c => c.HierarchyLevel == 4) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 4).AssignName;
            vm.Department = (userAssignInfos.Count(c => c.HierarchyLevel == 5) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 5).AssignName;
            vm.Major = (userAssignInfos.Count(c => c.HierarchyLevel == 6) == 0) ? "" : userAssignInfos.First(c => c.HierarchyLevel == 6).AssignName;


            //assignInfoService.GetAssignReverseHierarchyList(vm.user.AssignNo);
            /*
           

            vm.student = userService.GetStudentInfos(new Students() { UserNo = long.Parse(vm.id) });
            vm.staff = userService.GetStaffInfos(new Staffs() { UserNo = int.Parse(vm.id) });
            //vm.manager = userService.GetManagerInfos(new Managers() { UserNo = int.Parse(id) });

            vm.userMacAddressList = userMacAddressService.GetUserMacAddressList(vm.user.UserNo);*/

            //IList<AssignHierarchy> userAssignInfos = assignInfoService.GetAssignReverseHierarchyList(vm.user.AssignNo);


            return View(vm);
        }
		
		#endregion

		#region 일반회원
		[AuthorFilter(IsAdmin = true)]
		[Route("ListGeneral")]
		public ActionResult ListGeneral(AccountViewModel vm)
		{
			// 공통코드 조회
			Code code = new Code("A");
			code.ClassCode = "UAST";
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(w => w.CodeValue.Equals("UAST001") || w.CodeValue.Equals("UAST004")).ToList();

			// 조회 시 사용자 접근내역 저장
			UserAccessSave(1, "일반회원목록");

			// 페이징
			vm.PageNum = vm.PageNum ?? 1;
			vm.PageRowSize = vm.PageRowSize ?? 10;
            vm.SearchText = HttpUtility.UrlDecode(vm.SearchText) ?? "";

            // 조회
            if (vm.User == null)
			{
				vm.User = new User();
				vm.User.ApprovalGubun = Request.QueryString["ApprovalGubun"] ?? "";
				vm.User.SearchGbn = Request.QueryString["SearchGbn"] ?? "";
			}

			User user = new User();
			user.UseYesNo = "Y";
			user.IsGeneral = true;
			user.SearchGbn = !string.IsNullOrEmpty(vm.SearchGbn) ? vm.SearchGbn : null;
			user.SearchText = !string.IsNullOrEmpty(vm.SearchText) ? vm.SearchText : null;
			user.ApprovalGubun = !string.IsNullOrEmpty(vm.ApprovalGbn) ? vm.ApprovalGbn : null;
			user.FirstIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + 1 : 1;
			user.LastIndex = vm.PageNum != null ? ((vm.PageRowSize ?? 10) * ((vm.PageNum ?? 1) - 1)) + (vm.PageRowSize ?? 10) : 10;

            vm.SearchText = user.SearchText;

			vm.UserList = baseSvc.GetList<User>("account.USER_SELECT_D", user);
			vm.PageTotalCount = baseSvc.GetList<User>("account.USER_SELECT_E", user).FirstOrDefault().TotalCount;
			vm.Dic = new RouteValueDictionary { { "pagerowsize", vm.PageRowSize }, { "ApprovalGubun", vm.ApprovalGbn }, { "SearchGbn", user.SearchGbn }, { "SearchText", HttpUtility.UrlEncode(vm.SearchText) } };

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		public ActionResult ListGeneralExcel(string param1, string param2, string param3)
		{
			// param1 : ApprovalGubun 인증상태,  param2 : SearchGbn 검색구분, param3 : SearchText 검색어

			// 엑셀다운로드
			Hashtable hash = new Hashtable();
			hash.Add("ApprovalGubun", param1);
			hash.Add("SearchGbn", param2);
			hash.Add("SearchText", param3);
			hash.Add("UseYesNo", "Y");
			hash.Add("IsGeneral", true);
			IList<Hashtable> hashList = baseSvc.GetList<Hashtable>("account.USER_SELECT_F", hash);

			string[] headers = new string[] { "성명(" + WebConfigurationManager.AppSettings["StudIDText"].ToString() + ")", "생년월일", "성별", "연락처", "이메일", "인증상태" };
			string[] columns = new string[] { "HangulName", "ResidentNo", "SexGubun", "Mobile", "Email", "ApprovalGubunName" };
			string excelFileName = String.Format("사용자관리_일반회원관리_{0}", DateTime.Now.ToString("yyyyMMdd"));

			return ExportExcel(headers, columns, hashList, excelFileName); ;
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("WriteGeneral")]
		public ActionResult WriteGeneral(AccountViewModel vm, int? param1)
		{
			// param1 : UserNo

			// 페이징
			vm.PageRowSize = vm.PageRowSize ?? 10;
			vm.PageNum = vm.PageNum ?? 1;
			vm.SearchGbn = vm.SearchGbn ?? "";
            vm.ApprovalGbn = Request.QueryString["ApprovalGubun"];

			// 공통코드 조회
			Code code = new Code("A", new string[] { "UAST", "USEX" });
			vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", code).Where(w => w.CodeValue.Equals("UAST001") || w.CodeValue.Equals("UAST004") || w.ClassCode.Equals("USEX")).ToList();

			// 수정 조회
			if (param1 != null)
			{
				User user = new User();
				user.UserNo = param1 ?? 0;
				vm.User = baseSvc.Get<User>("account.USER_SELECT_S", user);
				vm.User.SexGubun = vm.User.SexGubun.Equals("M") ? "USEX001" : "USEX002";

				// 조회 시 사용자 접근내역 저장
				UserAccessSave(3, vm.User.HangulName + "(" + vm.User.UserID + ")");
			}

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[HttpPost]
		[Route("WriteGeneral")]
		public JsonResult WriteGeneral(AccountViewModel vm)
		{
			int cnt = 0;

			vm.Student.UserType = "USRT001";
			vm.Student.StudentYesNo = "N";
			vm.Student.ManagerYesNo = "N";
			vm.Student.SexGubun = vm.Student.SexGubun.Equals("USEX001") ? "M" : "F";
			vm.Student.CreateUserNo = sessionManager.UserNo;
			vm.Student.UpdateUserNo = sessionManager.UserNo;
			vm.Student.DeleteYesNo = vm.Student.DeleteYesNo ?? "N";
			vm.Student.UseYesNo = vm.Student.UseYesNo ?? "Y";
            vm.Student.GeneralUserCode = "GUCD004";
            if (!string.IsNullOrEmpty(vm.Student.Password))
			{
                vm.Student.Password = ConvertToSecurityPassword(vm.Student.Password);
			}

            // 저장
            if (vm.Student.UserNo.Equals(0))
			{
				vm.Student.IsGeneral = true;

				int UserNo = baseSvc.Get<int>("account.USER_SAVE_C", vm.Student);
				vm.Student.UserNo = UserNo;

				cnt = baseSvc.Get<int>("student.STUDENT_SAVE_C", vm.Student);

			}
			else //수정
			{

				cnt = accountSvc.UpdateUser(vm.Student);
			}

			return Json(cnt);

			//return RedirectToAction("ListGeneral");
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ImportGeneral")]
		public ActionResult ImportGeneral()
		{
			AccountViewModel vm = new AccountViewModel();
			//vm.Student = new Student();

			return View(vm);
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ImportGeneralChk")]
		[HttpPost]
		public JsonResult ImportGeneralChk(AccountViewModel vm)
		{

			if (Request.Files.Count > 0 && !string.IsNullOrEmpty(Request.Files[0].FileName))
			{
				vm.UserList = new List<User>();

				HttpPostedFileBase f = Request.Files[0];

				string fileName = "";
				string fileNewName = "";
				string fileSize = "";
				string fileType = "";

				if (!Directory.Exists(Server.MapPath("/Files/Temp")))
				{
					Directory.CreateDirectory(Server.MapPath("/Files/Temp/"));
				}
				if (f != null && !string.IsNullOrEmpty(f.FileName))
				{
					fileName = f.FileName.Split('\\').Last();
					fileNewName = sessionManager.UserNo.ToString() + "_" + DateTime.Now.ToString("yyyyMMddHHmmssFFF") + "." + f.FileName.Split('.').Last();
					fileSize = f.ContentLength.ToString();
					fileType = f.FileName.Split('.').Last(); //f.ContentType;
					f.SaveAs(Server.MapPath("/Files/Temp/" + fileNewName));
				}

				string connString = string.Empty;
				string systemCheck = string.Empty;

				if (Environment.Is64BitOperatingSystem) systemCheck = "64";
				else systemCheck = "32";

				if (systemCheck.Equals("64"))
				{
					connString = String.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=Excel 12.0 Xml;", Server.MapPath("/Files/Temp/" + fileNewName));
				}
				else
				{
					connString = String.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=Excel 8.0;", Server.MapPath("/Files/Temp/" + fileNewName));
				}

				OleDbConnection oledbConn = new OleDbConnection(connString);

				try
				{
					oledbConn.Open();
					OleDbCommand cmd = new OleDbCommand("SELECT * FROM [수강신청정보$]", oledbConn);
					OleDbDataAdapter oleda = new OleDbDataAdapter();
					oleda.SelectCommand = cmd;
					DataSet ds = new DataSet();
					oleda.Fill(ds, "User");
					var tempUser = from c in ds.Tables[0].AsEnumerable()
								   select c;
					DataTable dtUser = tempUser.CopyToDataTable();

					foreach (DataRow item in dtUser.Rows)
					{
						User user = new User();

						try
						{
							user.HangulName = item.Field<object>("이름") == null ? "" : item.Field<object>("이름").ToString();
							user.UserID = item.Field<object>("ID") == null ? "" : item.Field<object>("ID").ToString();
							user.Password = item.Field<object>("비밀번호") == null ? "" : item.Field<object>("비밀번호").ToString();
							user.ResidentNo = item.Field<object>("생년월일") == null ? "" : item.Field<object>("생년월일").ToString();
							user.AssignText = item.Field<object>("소속") == null ? "" : item.Field<object>("소속").ToString();
							user.Mobile = item.Field<object>("휴대폰") == null ? "" : item.Field<object>("휴대폰").ToString();
							user.Email = item.Field<object>("이메일") == null ? "" : item.Field<object>("이메일").ToString();
							if (item.Field<object>("성별").ToString().Equals("M")) { user.SexGubun = "남자"; }
							else { user.SexGubun = "여자"; }

							// 유효성 체크
							if (string.IsNullOrEmpty(user.HangulName)) { user.ApprovalGubun += "이름없음 "; }
							if (string.IsNullOrEmpty(user.UserID)) { user.ApprovalGubun += "아이디없음 "; }

							int numUnicode = BitConverter.ToInt16(Encoding.Unicode.GetBytes(user.UserID[0].ToString()), 0);
							if (!((97 <= numUnicode && numUnicode <= 122) || (65 <= numUnicode && numUnicode <= 90))) { user.ApprovalGubun += "아이디오류 "; }
							if (!IDChk(user.UserID).Equals(0)) { user.ApprovalGubun += "아이디중복 "; }

							for (int i = 0; i < dtUser.Rows.Count; i++)
							{
								if (dtUser.Rows[i]["ID"].ToString().Equals(user.UserID) && i != dtUser.Rows.IndexOf(item))
								{
									user.ApprovalGubun += "Excel파일내ID중복 ";
									break;
								}
							}

							for (int i = 0; i < dtUser.Rows.Count; i++)
							{
								if (dtUser.Rows[i]["이메일"].ToString().ToString().Equals(user.Email) && i != dtUser.Rows.IndexOf(item))
								{
									user.ApprovalGubun += "Excel파일내이메일중복 ";
									break;
								}
							}

							if (string.IsNullOrEmpty(user.Password)) { user.ApprovalGubun += "비밀번호없음 "; }
							if (string.IsNullOrEmpty(user.ResidentNo)) { user.ApprovalGubun += "생년월일없음 "; }
							else { if (!Regex.IsMatch(user.ResidentNo, @"^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$")) user.ApprovalGubun += "생년월일오류 "; }
							if (string.IsNullOrEmpty(user.Mobile)) { user.ApprovalGubun += "휴대폰번호없음 "; }
							if (string.IsNullOrEmpty(user.Email)) { user.ApprovalGubun += "이메일없음 "; }
							else
							{
								if (!Regex.IsMatch(user.Email, @"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?") && !string.IsNullOrEmpty(user.Email))
								{
									user.ApprovalGubun += "이메일오류 ";
								}
								else if (!EmailChk(user.Email).Equals(0)) { user.ApprovalGubun += "사용자이메일중복 "; }
							}
							if (string.IsNullOrEmpty(user.SexGubun)) { user.ApprovalGubun += "성별없음 "; }
							if (string.IsNullOrEmpty(user.ApprovalGubun)) { user.ApprovalGubun += "등록가능"; }

							User generalUser = baseSvc.Get<User>("account.USER_SELECT_S", user);
							vm.UserList.Add(user);

						}
						catch (Exception ex)
						{
							string errorMessage = ex.Message;

							user.HangulName = "엑셀파일 양식이 맞지 않습니다.";
							user.UserID = "";
							user.Password = "";
							user.ResidentNo = "";
							user.AssignText = "";
							user.Mobile = user.Email = "";
							user.Email = "";
							vm.UserList.Add(user);
							break;
						}
					}
				}
				finally
				{
					oledbConn.Close();
				}
			}

			return Json(vm.UserList);
		}

		public int IDChk(String id)
		{
			Hashtable paramIDChk = new Hashtable();
			paramIDChk.Add("UserID", id);
			int result = baseSvc.Get<int>("account.USER_SELECT_A", paramIDChk);

			return result;
		}

		public int EmailChk(String email)
		{
			Hashtable paramEmailChk = new Hashtable();
			paramEmailChk.Add("Email", email);
			int result = baseSvc.Get<int>("account.USER_SELECT_B", paramEmailChk);

			return result;
		}

		[AuthorFilter(IsAdmin = true)]
		[Route("ImportGeneralSave")]
		[HttpPost]
		public JsonResult ImportGeneralSave(AccountViewModel vm)
		{
			int cnt = 0;

			for (var i = 0; i < vm.HangulNameArray.Length; i++)
			{

				//vm.Student.UserType = "USRT001";
				vm.Student.StudentYesNo = "N";
				vm.Student.ManagerYesNo = "N";
				vm.Student.IsGeneral = true;
				vm.Student.CreateUserNo = sessionManager.UserNo;
				vm.Student.DeleteYesNo = "N";
				vm.Student.UseYesNo = "Y";
				vm.Student.ApprovalGubun = "UAST001";
                vm.Student.GeneralUserCode = "GUCD004";

                vm.HangulNameArray[i] = (vm.HangulNameArray[i] == "" || vm.HangulNameArray[i] == null) ? "" : vm.HangulNameArray[i];
				vm.UserIDArray[i] = (vm.UserIDArray[i] == "" || vm.UserIDArray[i] == null) ? "" : vm.UserIDArray[i];
				vm.PasswordArray[i] = (vm.PasswordArray[i] == "" || vm.PasswordArray[i] == null) ? "" : vm.PasswordArray[i];
				vm.ResidentNoArray[i] = (vm.ResidentNoArray[i] == "" || vm.ResidentNoArray[i] == null) ? "" : vm.ResidentNoArray[i];
				vm.AssignTextArray[i] = (vm.AssignTextArray[i] == "" || vm.AssignTextArray[i] == null) ? "" : vm.AssignTextArray[i];
				vm.MobileArray[i] = (vm.MobileArray[i] == "" || vm.MobileArray[i] == null) ? "" : vm.MobileArray[i];
				vm.EmailArray[i] = (vm.EmailArray[i] == "" || vm.EmailArray[i] == null) ? "" : vm.EmailArray[i];
				vm.SexGubunArray[i] = (vm.SexGubunArray[i] == "" || vm.SexGubunArray[i] == null) ? "" : vm.SexGubunArray[i];

				vm.Student.HangulName = vm.HangulNameArray[i];
				vm.Student.UserID = vm.UserIDArray[i];
				vm.Student.Password = ConvertToSecurityPassword(vm.PasswordArray[i]);
				vm.Student.ResidentNo = vm.ResidentNoArray[i];
				vm.Student.AssignText = vm.AssignTextArray[i];
				vm.Student.Mobile = vm.MobileArray[i];
				vm.Student.Email = vm.EmailArray[i];
				vm.Student.SexGubun = vm.SexGubunArray[i].ToString().Equals("남자") ? "M" : "F";

				if (vm.UploadGubunArray[i].ToString().Equals("등록가능"))
				{
					cnt = accountSvc.ImportGeneralSave(vm.Student);
				}
			}

			return Json(cnt);
		}
		#endregion

		#endregion
		
		[HttpPost]
        public JsonResult ResetPassword(AccountViewModel vm)
        {
            Console.Write(vm.User.Mobile);
            
            string password = ConvertToSecurityPassword((vm.User.Mobile.Substring(vm.User.Mobile.ToString().Length - 9, 9)).Replace("-","").Trim());

            Hashtable htResetPassword = new Hashtable();
            htResetPassword.Add("UserNo", vm.User.UserNo);
            htResetPassword.Add("Password", password);
            htResetPassword.Add("UpdateUserNo", vm.User.UserNo);

            int result = baseSvc.Save("account.USER_SAVE_U", htResetPassword);

            return Json(result);
        }

        [HttpPost]
        public JsonResult ChkUser(string paramHangulName, string paramUserID, string paramEmail)
        {

            User user = new User();

            Hashtable htIdCheck = new Hashtable();
            htIdCheck["HangulName"] = paramHangulName;
            htIdCheck["UserID"] = paramUserID;
            htIdCheck["Email"] = paramEmail;
            user = baseSvc.Get<User>("account.USER_SELECT_C", htIdCheck);

            string result = "";

            if (user != null)
            {
                result = "ChkUser";
			}
			else
			{
                result = "NoUser";
			}

            return Json(result);

        }

        [HttpPost]
        public JsonResult ResetPassword2(string paramHangulName, string paramUserID, string paramEmail)
        {

            User user = new User();

            Hashtable htIdCheck = new Hashtable();
            htIdCheck["HangulName"] = paramHangulName;
            htIdCheck["UserID"] = paramUserID;
            htIdCheck["Email"] = paramEmail;
            user = baseSvc.Get<User>("account.USER_SELECT_C", htIdCheck);
            
            int result = -1;

            if (user != null)
            {
                string password = ConvertToSecurityPassword((user.Mobile.Substring(user.Mobile.ToString().Length - 9, 9)).Replace("-", "").Trim());

                Hashtable htResetPassword = new Hashtable();
                
                htResetPassword.Add("UserNo", user.UserNo);
                htResetPassword.Add("Password", password);
                htResetPassword.Add("UpdateUserNo", user.UserNo);

                result = baseSvc.Save("account.USER_SAVE_U", htResetPassword);                
            }

            return Json(result);
        }

        [HttpPost]
        public JsonResult UserInfoUpdate(string userID, string userType)
        {
            //USP_IMPORT_SAVE @LINKID
            Hashtable htUserInfoUpdate = new Hashtable();
            htUserInfoUpdate.Add("IOTYPE", "SET");
            htUserInfoUpdate.Add("UpdateUserNo", sessionManager.UserNo);
            htUserInfoUpdate.Add("PARAM1", userType);
            htUserInfoUpdate.Add("PARAM2", userID);
            int result = baseSvc.Save("account.USER_IMPORT_SAVE_MEMBER", htUserInfoUpdate);

            return Json(result);
        }
    }
}