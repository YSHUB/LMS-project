using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class UserAuthority : AuthorityGroup
	{
		public UserAuthority() { }

		public UserAuthority(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "사용자유형")]
		public String UserType { get; set; }
	}
}
