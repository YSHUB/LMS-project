using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
    public class FacilityReservation : Facility
	{
		public FacilityReservation() { }

		public FacilityReservation(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "예약연번")]
		public Int64 ReservationNo { get; set; }

		[Display(Name = "예약시간")]
		public int ReservedHour { get; set; }

		[Display(Name = "예약날짜")]
		public string ReservedDate { get; set; }

		[Display(Name = "예약유저")]
		public Int64 ReservedUserNo { get; set; }

		[Display(Name = "예약인원")]
		public int ReservedUserCount { get; set; }

		[Display(Name = "예약상태")]
		public string ReservationState { get; set; }

		[Display(Name = "예약유저아이디")]
		public string ReservedUserID { get; set; }

		[Display(Name = "예약유저이름")]
		public string ReservedUserName { get; set; }

		[Display(Name = "예약유저소속명")]
		public string ReservedAssignName { get; set; }

		[Display(Name = "예약시간저장")]
		public string ReservedHourList { get; set; }

		[Display(Name = "예약인원저장")]
		public string UserCountList { get; set; }

		[Display(Name = "검색시작일자")]
		public string SearchStartDay { get; set; }

		[Display(Name = "검색종료일자")]
		public string SearchEndDay { get; set; }

	}
}
