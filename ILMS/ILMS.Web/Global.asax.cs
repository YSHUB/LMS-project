using ILMS.Core.System;
using Spring.Web.Mvc;
using System.Web.Mvc;
using System.Web.Routing;

namespace ILMS.Web
{
	public class MvcApplication : SpringMvcApplication
	{
		public static void RegisterGlobalFilters(GlobalFilterCollection filters)
		{
			filters.Add(new HandleErrorAttribute());
		}

		public static void RegisterRoutes(RouteCollection routes)
		{
			routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
			routes.IgnoreRoute("");

			routes.MapRoute(
				"Default", // Route name
				"{controller}/{action}/{param1}/{param2}/{param3}/{param4}", // URL with parameters
				new { controller = "Home"
					, action = "Index"
					, param1 = UrlParameter.Optional
					, param2 = UrlParameter.Optional
					, param3 = UrlParameter.Optional
					, param4 = UrlParameter.Optional } // Parameter defaults
			);

			routes.MapRoute(
				"DefaultPages", // Route name
				"{controller}/{action}", // URL with parameters
				new { controller = "Home"
					, action = "Index" } // Parameter defaults
			);
		}

		protected void Application_Start()
		{
			AreaRegistration.RegisterAllAreas();
			RegisterGlobalFilters(GlobalFilters.Filters);
			RegisterRoutes(RouteTable.Routes);
			System.Web.Hosting.HostingEnvironment.RegisterVirtualPathProvider(new AssemblyResourceProvider());
		}
	}
}
