using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class AuthorityGroup : Common
	{
		public AuthorityGroup() { }

		public AuthorityGroup(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "권한그룹번호")]
		public int GroupNo { get; set; }

		[Display(Name = "권한그룹명")]
		public String AuthorityGroupName { get; set; }

		[Display(Name = "비고")]
		public String Remark { get; set; }

		[Display(Name = "사용자유형 배열")]        //ex) USRT001|USRT007
		public string UserTypeArray { get; set; }
	}
}
