using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	public class CourseGroup : Course
	{
		[Display(Name = "그룹번호")]
		public Int32 GroupNo { get; set; }

		[Display(Name = "그룹명")]
		public String GroupName { get; set; }

		/// <summary>
		/// CGCT001 = 무작위배정, CGCT002 = 순차균등배정, CGCT003 = 동일집단 우선배정
		/// </summary>
		[Display(Name = "배정방식")]
		public String GroupType { get; set; }
	}
}
