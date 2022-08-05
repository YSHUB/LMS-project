using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Web.Mvc;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
	[RoutePrefix("LectureRoom")]
	public class LectureRoomController : LectureRoomBaseController
	{
		[Route("Index/{param1}")]
		public ActionResult Index(CourseViewModel vm, int param1)
		{
			//param1 : CourseNo 강좌번호
			int courseNo = param1;
			Int64 userNo = sessionManager.UserNo;

			Hashtable ht = new Hashtable();

            if (ViewBag.Course.IsProf == 1)
            {
				ht.Add("CourseNo", courseNo);
				vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_L", ht);
			}
            else
            {
				ht.Add("CourseNo", courseNo);
				ht.Add("UserNo", userNo);

				vm.Inning = baseSvc.GetList<Inning>("course.COURSE_INNING_SELECT_J", ht);
			}

			return View(vm);
		}

	}
}