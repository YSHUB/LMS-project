using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace ILMS.Web.Controllers
{
	public class LectureRoomBaseController : WebBaseController
	{
		protected override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			base.OnActionExecuting(filterContext);
			
			if (Request.AcceptTypes != null
			&& !Request.AcceptTypes.Contains("application/json")
			&& Request.Files.Count == 0
			&& !filterContext.RequestContext.RouteData.Values["action"].ToString().ToUpper().Equals("FILEDOWNLOAD"))
			{
				if (filterContext.RequestContext.RouteData.Values["param1"] == null)
				{
					if (!filterContext.RequestContext.RouteData.Values["action"].Equals("OcwView"))
					{
						Response.Redirect(string.Format("/Home/Index?InfoMessage={0}", "MSG_EREGULAR_PATH"));
					}
				}
				else
				{
					string controllerStr = filterContext.RequestContext.RouteData.Values["controller"].ToString();
					if (ViewBag.IsLogin || controllerStr.Equals("Board"))
					{
						//TODO TLoginUser 테이블 LectureRoomCheckDay 업데이트 추가

						//강의정보
						Course paramCourseB = new Course();
						paramCourseB.CourseNo = int.Parse(filterContext.RouteData.Values["param1"].ToString());
						paramCourseB.UserNo = ViewBag.User.UserNo;
						ViewBag.Course = baseSvc.Get<Course>("course.COURSE_SELECT_B", paramCourseB);
						if (ViewBag.Course == null)
						{
							ViewBag.Course = new Course();
						}

						Hashtable ht = new Hashtable();
						ht.Add("UserType", ViewBag.Course.IsProf == 1 ? "USRT007" : "USRT001");
						ht.Add("GroupNo", ViewBag.Course.IsProf == 1 ? 3 : Request.IsLocal ? 5 : 4);
						IList<Menu> menuList = baseSvc.GetList<Menu>("system.MENU_SELECT_A", ht).OrderBy(c => c.SortNo).ToList();

						ViewBag.LecMenuList = menuList.Where(c => c.MenuType == "L").Where(c => c.VisibleYesNo == "Y").ToList();

						//강의실인 경우 해당 강의번호 가지고 다닐 수 있도록 URL 수정
						string courseNo = filterContext.RequestContext.RouteData.Values["param1"].ToString();

						if (!controllerStr.Equals("QuestionBank"))
						{
							foreach (var item in ViewBag.LecMenuList)
							{
								string[] urlArray = item.MenuUrl.ToString().Split('/');
								if (!urlArray[1].Equals("QuestionBank"))
								{
									if (urlArray.Length > 3)
									{
										urlArray[3] = courseNo;
									}
									else
									{
										List<string> urlList = urlArray.ToList();
										urlList.Add(courseNo);
										urlArray = urlList.ToArray();
									}

									string url = "";
									foreach (var urlStr in urlArray)
									{
										if (!string.IsNullOrEmpty(urlStr))
										{
											url += "/" + urlStr;
										}
									}
									item.MenuUrl = url;
								}
							}
						}

						//강의실 학기 목록
						IList<Term> termList = baseSvc.GetList<Term>("term.TERM_SELECT_L", new Term("L"));

						if (termList.Count > 0)
						{
							ViewBag.TermList = termList.Where(c => DateTime.ParseExact(c.TermStartDay, "yyyy-MM-dd", null) <= DateTime.Now).OrderByDescending(c => c.SortNo);
							int currentTermNo = termList.Where(c => DateTime.ParseExact(c.TermStartDay, "yyyy-MM-dd", null) <= DateTime.Now).FirstOrDefault().TermNo;

							ViewBag.SelectedTermNo = ViewBag.Course.TermNo > 0 ? ViewBag.Course.TermNo : currentTermNo;

							//강의실 교과목 목록
							Course paramCourseA = new Course();
							paramCourseA.TermNo = ViewBag.Course.TermNo;
							paramCourseA.UserNo = ViewBag.User.UserNo;
							ViewBag.CourseList = baseSvc.GetList<Course>("course.COURSE_SELECT_A", paramCourseA);
						}

						bool isLecCourse = false;
						foreach (var item in ViewBag.CourseList)
						{
							if (item.CourseNo.ToString().Equals(courseNo))
							{
								isLecCourse = true;
							}
						}

						bool isLecMenu = false;
						string path = Request.Path;
						if (controllerStr.Equals("Board"))
						{
							path = path.Replace(courseNo, "1");
						}
						else
						{
							path = path.Replace(courseNo, "");
							path = path.Substring(0, (path.LastIndexOf('/') + 1) == path.Length ? path.Length - 1 : path.Length);
						}

						Hashtable paramMenuC = new Hashtable();
						paramMenuC.Add("MenuUrl", path);
						isLecMenu = baseSvc.Get<int>("system.MENU_SELECT_C", paramMenuC) == 1;

						if (!isLecCourse && isLecMenu)
						{
							Response.Redirect(string.Format("/Mypage/LectureRoom?InfoMessage={0}", "MSG_ERROR_COURSE"));
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
}