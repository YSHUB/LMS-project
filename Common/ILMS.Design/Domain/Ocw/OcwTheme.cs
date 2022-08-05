using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class OcwTheme : Common
	{
		public OcwTheme() { }

		public OcwTheme(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "테마 번호")]
		public int ThemeNo { get; set; }

		[Display(Name = "테마 이름")]
		public string ThemeName { get; set; }

		[Display(Name = "해당 테마OCW 컨텐츠 개수")]
		public int OcwCount { get; set; }

		[Display(Name = "OCW 테마키워드 관리자 전용여부(0 : 아니오, 1 : 관리자전용)")]
		public int? IsAdmin { get; set; }

		[Display(Name = "OCW 테마키워드 관리자 전용여부명")]
		public string IsAdminName { get; set; }

		[Display(Name = "OCW 테마키워드 공개여부(0 : 비공개, 1 : 공개)")] 
		public int? IsOpen { get; set; }

		[Display(Name = "OCW 테마키워드 공개여부명")] 
		public string IsOpenName { get; set; }


	}
}
