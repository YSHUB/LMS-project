using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	public class FileFolder : Common
	{
		public FileFolder() { }

		[Display(Name = "폴더 번호")]
		public int FolderNo { get; set; }

		[Display(Name = "폴더명")]
		public string FolderName { get; set; }

		[Display(Name = "Physical 경로")]
		public string PhysicalPath { get; set; }

		[Display(Name = "Virtual 경로")]
		public string VirtualPath { get; set; }

		[Display(Name = "비고")]
		public string Remark { get; set; }
		
	}
}
