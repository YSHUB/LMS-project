using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using System.Web.Routing;

public static class Helpers
{
	//페이징 처리
	public static MvcHtmlString Pager(this HtmlHelper helper, int currentPage, int pagesToShowSize, int pageSize, int totalRecords, RouteValueDictionary paramValues)
	{
		if (pageSize >= totalRecords)
		{
			return MvcHtmlString.Create("");
		}
		RouteData routeData = helper.ViewContext.RouteData;
		string controllerName = routeData.GetRequiredString("controller");
		string actionName = routeData.GetRequiredString("action");
		//string param1 = routeData.Values["param1"] != null ? routeData.Values["param1"].ToString() : string.Empty;
		//string param2 = routeData.Values["param2"] != null ? routeData.Values["param2"].ToString() : string.Empty;
		//string param3 = routeData.Values["param3"] != null ? routeData.Values["param3"].ToString() : string.Empty;

		RouteValueDictionary values = routeData.Values;
		if (paramValues != null)
		{
			values.Merge(paramValues);
		}

		StringBuilder html = new StringBuilder(@"<div class=""mt-4""><ul class=""pagination justify-content-center"">");
		if (totalRecords > 0)
		{
			var htmlDic = new Dictionary<string, object>();
			int maxPageNo = (int)Math.Ceiling((float)totalRecords / pageSize);
			int startPage = currentPage - ((currentPage - 1) % pagesToShowSize);
			int endPage = startPage + (pagesToShowSize - 1);
			int prevPage = Math.Max(currentPage - 1, 1);
			int nextPage = Math.Min(currentPage + 1, maxPageNo);

			if (maxPageNo < endPage)
			{
				endPage = maxPageNo;
			}

			string styleClass = "page-link";
			htmlDic["class"] = styleClass;

			values["PageNum"] = 1;
			html.AppendFormat("<li class='page-item prev'>{0}</li>", helper.ActionLink("iLMSPagingIcon", actionName, controllerName, values, htmlDic).ToHtmlString().Replace("iLMSPagingIcon", "<i class=\"bi bi-chevron-double-left\"></i>"));

			values["PageNum"] = prevPage;
			html.AppendFormat("<li class='page-item prev'>{0}</li>", helper.ActionLink("iLMSPagingIcon", actionName, controllerName, values, htmlDic).ToHtmlString().Replace("iLMSPagingIcon", "<i class=\"bi bi-chevron-left\"></i>"));

			for (int page = startPage; page <= endPage; page++)
			{
				if (page == currentPage)
				{
					html.AppendFormat(@"<li class=""page-item active""><a href = ""#"" onclick=""javascript:fnPrevent();"" class=""page-link"">{0}</a></li>", page);
				}
				else
				{
					values["PageNum"] = page;
					html.AppendFormat(@"<li class=""page-item"">{0}</li>", helper.ActionLink(page.ToString(), actionName, controllerName, values, htmlDic).ToHtmlString());
				}
			}

			values["PageNum"] = nextPage;
			html.AppendFormat("<li class='page-item next'>{0}</li>", helper.ActionLink("iLMSPagingIcon", actionName, controllerName, values, htmlDic).ToHtmlString().Replace("iLMSPagingIcon", "<i class=\"bi bi-chevron-right\"></i>"));

			values["PageNum"] = maxPageNo;
			html.AppendFormat("<li class='page-item next'>{0}</li>", helper.ActionLink("iLMSPagingIcon", actionName, controllerName, values, htmlDic).ToHtmlString().Replace("iLMSPagingIcon", "<i class=\"bi bi-chevron-double-right\"></i>"));
		}

		html.Append(@"</ul></div>");
		return MvcHtmlString.Create(html.ToString());
	}

	// Route Value를 병합한다.
	public static RouteValueDictionary Merge(this RouteValueDictionary dest, IEnumerable<KeyValuePair<string, object>> src)
	{
		src.ToList().ForEach(x => { dest[x.Key] = x.Value; });
		return dest;
	}
}
