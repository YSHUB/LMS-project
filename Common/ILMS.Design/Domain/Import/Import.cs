using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Import : Common
	{
		public Import() { }

		public Import(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "로그번호")]
		public int LinkageNo { get; set; }

		[Display(Name = "로그일자")]
		public string LinkageDate { get; set; }

		[Display(Name = "신규로그카운트")]
		public int InsertCount { get; set; }
		
		[Display(Name = "수정로그카운트")]
		public int UpdateCount { get; set; }

		[Display(Name = "로그 시작일자")]
		public string StartDate { get; set; }

		[Display(Name = "로그 종료일자")]
		public string EndDate { get; set; }

		[Display(Name = "연동타입")]
		public String LinkageType { get; set; }

		[Display(Name = "구분")]
		public string IsAuto { get; set; }

		public String CodeName { get; set; }

	}
}
