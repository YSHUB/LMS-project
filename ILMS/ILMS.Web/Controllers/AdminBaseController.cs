using System.Linq;
using System.Web.Mvc;

namespace ILMS.Web.Controllers
{
	public class AdminBaseController : WebBaseController
	{
		protected override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			base.OnActionExecuting(filterContext);
			
			if (Request.AcceptTypes != null
				&& !Request.AcceptTypes.Contains("application/json")
				&& Request.Files.Count == 0
				&& !filterContext.RequestContext.RouteData.Values["action"].ToString().ToUpper().Equals("FILEDOWNLOAD"))
			{
				if (ViewBag.IsLogin)
				{
					if (ViewBag.IsAdmin && !ViewBag.IsAutoLogin)
					{

					}
					else
					{
						Response.Redirect(string.Format("/Home/Index?InfoMessage={0}", "MSG_ERROR_AUTHORITY"));
					}
			}
				else
				{
					Response.Redirect(string.Format("/Home/Index?InfoMessage={0}", "MSG_REQUIRE_LOGIN"));
				}
			}
		}
	}
}