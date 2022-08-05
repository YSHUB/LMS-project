using ILMS.Design.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.ViewModels
{
	//과제 관련 페이지
    public class FacilityViewModel : BaseViewModel
    {
		[Display(Name = "에러메세지")]
		public string ErrorMessage { get; set; }

		[Display(Name = "시설장비")]
		public Facility Facility { get; set; }

		[Display(Name = "시설장비 리스트")]
		public IList<Facility> FacilityList { get; set; }

		[Display(Name = "시설장비예약")]
		public FacilityReservation FacilityReservation { get; set; }

		[Display(Name = "시설장비예약 리스트")]
		public IList<FacilityReservation> FacilityReservationList { get; set; }

		[Display(Name = "시설장비이용제한")]
		public FacilityBan FacilityBan { get; set; }

		[Display(Name = "시설장비이용제한 리스트")]
		public IList<FacilityBan> FacilityBanList { get; set; }

		[Display(Name = "시설장비 관리자 여부")]
		public bool isAdmin { get; set; }

		[Display(Name = "검색시작일자")]
		public string SearchStartDay { get; set; }

		[Display(Name = "검색종료일자")]
		public string SearchEndDay { get; set; }

		[Display(Name = "검색카테고리")]
		public string Category { get; set; }

		[Display(Name = "검색시설장비타입")]
		public string FacilityType { get; set; }

		[Display(Name = "검색유저번호")]
		public Int64 UserNo { get; set; }

	}
}
