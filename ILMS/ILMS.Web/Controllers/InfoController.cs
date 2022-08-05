using System.Web.Mvc;

namespace ILMS.Web.Controllers
{
	[RoutePrefix("Info")]
	public class InfoController : WebBaseController
	{
		[Route("Restriction")]
		public ActionResult Restriction()
		{
			ViewBag.PeriodName = TempData["PeriodName"];
			ViewBag.Period = TempData["Period"];
			return View();
		}

		[Route("Error")]
		public ActionResult Error()
		{
			ViewBag.InfoMessage = Request.QueryString["InfoMessage"] != null ? Request.QueryString["InfoMessage"].ToString() : "관리자에게 문의해 주세요.";

			return View();
		}
	}
}