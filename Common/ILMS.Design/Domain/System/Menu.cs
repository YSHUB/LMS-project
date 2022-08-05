using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Menu : Common
	{
		public Menu() { }

		public Menu(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "메뉴코드")]
		public String MenuCode { get; set; }

		[Display(Name = "메뉴명")]
		public String MenuName { get; set; }

		[Display(Name = "상위 메뉴코드")]
		public String UpperMenuCode { get; set; }

		[Display(Name = "상위 메뉴명")]
		public String UpperMenuName { get; set; }

		[Display(Name = "최상위 메뉴코드")]
		public String HighestMenuCode { get; set; }

		[Display(Name = "최상위 메뉴명")]
		public String HighestMenuName { get; set; }

		[Display(Name = "메뉴 URL")]
		public String MenuUrl { get; set; }

		[Display(Name = "메뉴 열림방식")]
		public String LinkTarget { get; set; }

		[Display(Name = "메뉴 설명")]
		public String MenuExplain { get; set; }

		[Display(Name = "메뉴 레벨")]
		public int MenuLv { get; set; }

		[Display(Name = "메뉴 경로(1depth > 2depth)")]
		public String MenuPath { get; set; }

		[Display(Name = "마지막 메뉴 여부[상단/좌측 메뉴 표시용]")]
		public String LastMenuYN { get; set; }

		[Display(Name = "메뉴 유형(U:웹, L:웹-강의실, A:관리자")]
		public String MenuType { get; set; }

		[Display(Name = "메뉴 접근 사용자 권한")]
		public String UserType { get; set; }

		[Display(Name = "팝업여부")]
		public String PopupYesNo { get; set; }

		[Display(Name = "팝업 가로px")]
		public int PopupWidth { get; set; }

		[Display(Name = "팝업 세로px")]
		public int PopupHeight { get; set; }
	}
}
