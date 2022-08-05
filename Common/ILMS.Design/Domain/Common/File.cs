using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	public class File : FileGroup
	{
		public File() { }

		public File(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "파일 번호")]
		public Int64 FileNo { get; set; }

		[Display(Name = "등록 파일 명(변환 전)")]
		public string OriginFileName { get; set; }

		[Display(Name = "서버 파일 명(변환 후)")]
		public string SaveFileName { get; set; }

		[Display(Name = "파일 사이즈")]
		public int FileSize { get; set; }

		[Display(Name = "확장자")]
		public string Extension { get; set; }

	}
}
