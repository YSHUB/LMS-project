using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class FileGroup : Common
	{
		public FileGroup() { }

		public FileGroup(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "파일 그룹 번호")]
		public Int64 FileGroupNo { get; set; }

		[Display(Name = "파일 그룹 번호(여러개)")]
		public string FileGroupNos { get; set; }

		[Display(Name = "폴더 번호")]
		public Int64 FolderNo { get; set; }
	}
}
