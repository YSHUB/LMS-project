using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Configuration;
using System.Web.Mvc;

namespace ILMS.Web.Controllers
{
	[RoutePrefix("Sub")]
	public class SubController : WebBaseController
	{
		public ActionResult Greetings()
		{
			return View();
		}

		public ActionResult History()
		{
			return View();
		}

		public ActionResult Vision()
		{
			return View();
		}

		public ActionResult Map()
		{
			return View();
		}

		public ActionResult Introduce()
		{
			return View();
		}

		public ActionResult Business()
		{
			return View();
		}

		public ActionResult RoadMap()
		{
			return View();
		}
	}
}