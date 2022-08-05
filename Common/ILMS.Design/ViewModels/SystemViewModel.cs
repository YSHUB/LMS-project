using ILMS.Design.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.ViewModels
{
	//관리자 > 시스템관리 관련 페이지
	public class SystemViewModel : BaseViewModel
	{
		// 메뉴관리 ▼
		[Display(Name = "메뉴")]
		public Menu Menu { get; set; }

		[Display(Name = "메뉴 리스트")]
		public IList<Menu> MenuList { get; set; }

		[Display(Name = "Depth1 메뉴코드")]
		public string Depth1 { get; set; }

		[Display(Name = "Depth2 메뉴코드")]
		public string Depth2 { get; set; }

		[Display(Name = "Depth3 메뉴코드")]
		public string Depth3 { get; set; }
		// 메뉴관리 ▲

		// 사용자별 권한관리 ▼
		[Display(Name = "권한그룹")]
		public AuthorityGroup AuthorityGroup { get; set; }

		[Display(Name = "권한그룹 리스트")]
		public IList<AuthorityGroup> AuthorityGroupList { get; set; }
		// 사용자별 권한관리 ▲

		// 사용자별 메뉴 권한관리 ▼
		[Display(Name = "권한그룹")]
		public MenuAuthority MenuAuthority { get; set; }

		[Display(Name = "권한그룹 리스트")]
		public IList<MenuAuthority> MenuAuthorityList { get; set; }
		// 사용자별 메뉴 권한관리 ▲

		// 코드관리 ▼
		[Display(Name="코드관리")]
		public Code Code { get; set; }

		[Display(Name ="상위코드 리스트")]
		public IList<Code> CodeList { get; set; }

		[Display(Name ="하위코드 리스트")]
		public IList<Code> DetailCodeList { get; set; }

		[Display(Name ="상위코드")]
		public string ClassCode { get; set; }
		// 코드관리 ▲

		// 학기관리 ▼
		[Display(Name = "학기")]
		public Term Term { get; set; }
		[Display(Name = "주차")]
		public TermWeek TermWeek { get; set; }

		[Display(Name = "학기 리스트")]
		public IList<Term> TermList { get; set; }

		[Display(Name = "학기 주차관리")]
		public IList<TermWeek> TermWeekList { get; set; }

		public string ID { get; set; }
		public bool IsUpdate { get; set; }


		// 학기관리 ▲
	}
}
