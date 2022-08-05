using System;
using System.Linq;
using System.Web.Mvc;

namespace ILMS.Core.System
{
	public class AuthorFilter : ActionFilterAttribute
	{
		public bool IsMember { get; set; }
		public bool IsAdmin { get; set; }
		public bool IsLogIn { get; set; }
		public string UserRole { get; set; }
		public string RoleType { get; set; }
		private string[] RoleTypeArr { get; set; }

		public override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			//권한을 지정한 경우
			if (!string.IsNullOrEmpty(RoleType))
			{
				RoleTypeArr = RoleType.Split(',');
			}

			//로그인 판별
			if (filterContext.HttpContext.Session[SessionConstants.UserInfo.ToString()] != null)
			{
				IsLogIn = true;
				UserRole = filterContext.HttpContext.Session[SessionConstants.UserType.ToString()].ToString();
			}
			else
			{
				IsLogIn = false;
			}

			if (IsAdmin)
			{
				//관리자 로그인 해야하는 메뉴인 경우 로그인과 권한 모두 판별
				if (!IsLogIn)
				{
					filterContext.Result = new RedirectResult(string.Format("/Account/Index?InfoMessage={0}", "MSG_REQUIRE_LOGIN"));
				}
				else
				{
					if (!Boolean.Parse(filterContext.HttpContext.Session[SessionConstants.IsAdmin.ToString()].ToString()))
					{
						filterContext.Result = new RedirectResult(string.Format("/Home/Index?InfoMessage={0}", "MSG_ERROR_AUTHORITY"));
					}

					if (RoleTypeArr != null && RoleTypeArr.Length > 0)
					{
						if (!RoleTypeArr.Contains(UserRole))
						{
							filterContext.Result = new RedirectResult(string.Format("/Home/Index?InfoMessage={0}", "MSG_ERROR_AUTHORITY"));
						}
					}
				}
			}
			else if(IsMember)
			{
				//로그인 해야하는 메뉴인 경우 로그인과 권한 모두 판별
				if (!IsLogIn)
				{
					filterContext.Result = new RedirectResult(string.Format("/Account/Index?InfoMessage={0}", "MSG_REQUIRE_LOGIN"));
				}
				else
				{
					if (RoleTypeArr != null && RoleTypeArr.Length > 0)
					{
						if (!RoleTypeArr.Contains(UserRole))
						{
							filterContext.Result = new RedirectResult(string.Format("/Home/Index?InfoMessage={0}", "MSG_ERROR_AUTHORITY"));
						}
					}
				}
			}
			else
			{
				//로그인 하지 않아도 되는 메뉴라면 권한만 판별
				if (RoleTypeArr != null && RoleTypeArr.Length > 0)
				{
					if (!RoleTypeArr.Contains(UserRole))
					{
						filterContext.Result = new RedirectResult(string.Format("/Info/Error?InfoMessage={0}", "MSG_ERROR_AUTHORITY"));
					}
				}
			}
		}
	}
}
