using System;
using System.Web;
using System.Web.Hosting;
using System.IO;
using System.Web.Caching;
using System.Collections;
using System.Reflection;

namespace ILMS.Core.System
{
	public class AssemblyResourceProvider : VirtualPathProvider
	{
        public AssemblyResourceProvider() { }

		private bool IsAppResourcePath(string virtualPath)
        {
            String checkPath = VirtualPathUtility.ToAppRelative(virtualPath);
            return checkPath.StartsWith("~/Plugin/", StringComparison.InvariantCultureIgnoreCase);
        }

		public override bool FileExists(string virtualPath)
		{
			return (IsAppResourcePath(virtualPath) || base.FileExists(virtualPath));
		}

		public override VirtualFile GetFile(string virtualPath)
		{
			if (IsAppResourcePath(virtualPath))
				return new AssemblyResourceVirtualFile(virtualPath);
			else
				return base.GetFile(virtualPath);
		}

		public override CacheDependency GetCacheDependency(string virtualPath, IEnumerable virtualPathDependencies, DateTime utcStart)
		{
			if (IsAppResourcePath(virtualPath))
				return null;
			else
				return base.GetCacheDependency(virtualPath, virtualPathDependencies, utcStart);
		}
	}

	class AssemblyResourceVirtualFile : VirtualFile
	{
		string path;

		public AssemblyResourceVirtualFile(string virtualPath) : base(virtualPath)
		{
			path = VirtualPathUtility.ToAppRelative(virtualPath);
		}

		public override Stream Open()
		{
			string[] parts = path.Split('/');
			string assemblyName = parts[2];
			string resourceName = parts[3];

			assemblyName = Path.Combine(HttpRuntime.BinDirectory, assemblyName);

			Assembly assembly = Assembly.LoadFile(assemblyName);
			if (assembly != null)
			{
				Stream resourceStream = assembly.GetManifestResourceStream(resourceName);
				return resourceStream;
			}
			return null;
		}
	}
}
