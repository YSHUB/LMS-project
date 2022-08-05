using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class GroupTeam : Group
	{
		public GroupTeam() { }

		[Display(Name = "팀 번호")]
		public Int64 TeamNo { get; set; }

		[Display(Name = "팀 이름")]
		public string TeamName { get; set; }

		[Display(Name = "멤버 수")]
		public int MemberCnt { get; set; }

	}
}
