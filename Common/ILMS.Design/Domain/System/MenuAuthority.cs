using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class MenuAuthority : AuthorityGroup
	{
		public MenuAuthority() { }

		public MenuAuthority(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "메뉴코드")]
		public String MenuCode { get; set; }

		[Display(Name = "메뉴경로")]
		public String MenuPath { get; set; }

		[Display(Name = "메뉴유형")]
		public String MenuType { get; set; }

		[Display(Name = "하위메뉴 포함 여부")]	//Y인경우 메뉴권한 저장시 하위메뉴 같이 저장
		public string IncludeYN { get; set; }

		[Display(Name = "권한 보유 여부")]
		public string OwnYN { get; set; }

		[Display(Name = "메뉴코드 배열")]        //ex) 1001|1003|1004
		public string MenuCodeArray { get; set; }
	}
}
