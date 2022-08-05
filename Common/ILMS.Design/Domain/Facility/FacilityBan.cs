using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
    public class FacilityBan : FacilityReservation
	{
		public FacilityBan() { }

		public FacilityBan(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "예약제한번호")]
		public Int64 BanNo { get; set; }

		[Display(Name = "예약제한유저")]
		public Int64 BannedUserNo { get; set; }

		[Display(Name = "예약제한유저이름")]
		public string BannedUserName { get; set; }

		[Display(Name = "예약제한유저소속")]
		public string BannedAsignName { get; set; }

		[Display(Name = "예약제한일자")]
		public string BannedDate { get; set; }

		[Display(Name = "예약제한사유")]
		public string BannedReason { get; set; }

	}
}
