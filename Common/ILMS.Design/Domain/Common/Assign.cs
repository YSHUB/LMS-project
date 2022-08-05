using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Assign : Common
	{
		public Assign() { }

		public Assign(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "소속 번호")]
		public string AssignNo { get; set; }

		[Display(Name = "소속 명")]
		public string AssignName { get; set; }

		[Display(Name = "소속 깊이")]
		public int HierarchyLevel { get; set; }

		[Display(Name = "상위 소속 번호")]
		public string UpperAssignNo { get; set; }

		[Display(Name = "소속 코드")]
		public string AssignCode { get; set; }
	}
}
