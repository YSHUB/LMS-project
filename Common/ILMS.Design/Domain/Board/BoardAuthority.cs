using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class BoardAuthority : Common
	{
		public BoardAuthority() { }

		public BoardAuthority(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "게시판 마스터 번호")]
		public int BoardMasterNo { get; set; }

		[Display(Name = "사용자 권한 번호")]
		public int AuthorityGroupNo { get; set; }

		[Display(Name = "사용자 권한명")]
		public string AuthorityGroupName { get; set; }

		[Display(Name = "읽기 가능여부")]
		public string IsRead { get; set; }

		[Display(Name = "쓰기 가능여부")]
		public string IsWrite { get; set; }
	}
}
