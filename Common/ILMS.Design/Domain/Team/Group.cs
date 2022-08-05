using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Group : Course
	{
		public Group() { }

		[Display(Name = "그룹 번호")]
		public Int64 GroupNo { get; set; }

		[Display(Name = "그룹 이름")]
		public string GroupName { get; set; }

		[Display(Name = "그룹 타입(CGCT001 = 무작위배정, CGCT002 = 순차균등배정, CGCT003 = 동일집단 우선배정)")]
		public string GroupType { get; set; }

		[Display(Name = "팀 수")]
		public int TeamCnt { get; set; }

	}
}
