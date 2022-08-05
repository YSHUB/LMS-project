using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
    public class Facility : Common
	{
		public Facility() { }

		public Facility(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "시설장비연번")]
		public Int64 FacilityNo { get; set; }

		[Display(Name = "시설장비이름")]
		public string FacilityName { get; set; }

		[Display(Name = "시설장비타입")]
		public string FacilityType { get; set; }

		[Display(Name = "시설장비타입")]
		public string FacilityTypeName { get; set; }

		[Display(Name = "시설장비설명")]
		public string FacilityText { get; set; }

		[Display(Name = "카테고리")]
		public string Category { get; set; }

		[Display(Name = "카테고리")]
		public string CategoryName { get; set; }

		[Display(Name = "최대수용인원")]
		public int MaxUserCount { get; set; }

		[Display(Name = "파일그룹번호")]
		public int? FileGroupNo { get; set; }

		[Display(Name = "파일명")]
		public string FileName { get; set; }

		[Display(Name = "파일확장자")]
		public string FileExtension { get; set; }

		[Display(Name = "유/무료여부")]
		public string IsFree { get; set; }

		[Display(Name = "예약비용")]
		public int FacilityExpense { get; set; }

		[Display(Name = "예약번호리스트")]
		public string ReservationNoList { get; set; }

		[Display(Name = "예약현황")]
		public string ReservationStateName { get; set; }

	}
}
