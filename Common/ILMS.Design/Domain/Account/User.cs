using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class User : LoginUser
	{
		public User() { }

		public User(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "아이디(학번)")]
		public string UserID { get; set; }

		[Display(Name = "비밀번호")]
		public string Password { get; set; }

		[Display(Name = "사용자 이름")]
		public string HangulName { get; set; }

		[Display(Name = "사용자 소속")]
		public string AssignNo { get; set; }

		[Display(Name = "사용자 소속명")]
		public string AssignName { get; set; }

		[Display(Name = "사용자 유형")]
		public string UserType { get; set; }

		[Display(Name = "사용자 유형명")]
		public string UserTypeName { get; set; }

		[Display(Name = "최근접속일시")]
		public string LastConnectedDay { get; set; }

		[Display(Name = "IP")]
		public string IPAddress { get; set; }

		[Display(Name = "일반회원여부")]
		public bool IsGeneral { get; set; }

		[Display(Name = "Email")]
		public string Email { get; set; }

		//20211213 추가(회원가입 관련)
		[Display(Name = "승인 구분")]
		public String ApprovalGubun { get; set; }
		[Display(Name = "학생 여부")]
		public String StudentYesNo { get; set; }
		[Display(Name = "관리자 여부")]
		public String ManagerYesNo { get; set; }
		[Display(Name = "대학교 코드")]
		public String UniversityCode { get; set; }
		[Display(Name = "집 전화 공개 여부")]
		public String HousePhoneOpenYesNo { get; set; }
		[Display(Name = "사무실 전화 공개 여부")]
		public String OfficePhoneOpenYesNo { get; set; }

		[Display(Name = "사무실 전화")]
		public String OfficePhone { get; set; }

		[Display(Name = "모바일 공개 여부")]
		public String MobileOpenYesNo { get; set; }

		[Display(Name = "이메일 공개 여부")]
		public String EmailOpenYesNo { get; set; }

		[Display(Name = "집 주소 공개 여부")]
		public String HouseAddressOpenYesNo { get; set; }

		[Display(Name = "집 전화")]
		public String HousePhone { get; set; }

		[Display(Name = "사무실 주소 공개 여부")]
		public String OfficeAddressOpenYesNo { get; set; }

		[Display(Name = "사무실 주소")]
		public string OfficeAddress1 { get; set; }

		[Display(Name = "사무실 상세주소")]
		public string OfficeAddress2 { get; set; }

		[Display(Name = "모바일")]
		public String Mobile { get; set; }

		//20211214 추가(회원 조회 관련)
		[Display(Name = "접근 유형")]
		public int AType { get; set; }

		[Display(Name = "내용")]
		public String AData { get; set; }

		[Display(Name = "생년월일")]
		public String ResidentNo { get; set; }

		[Display(Name = "성별")]
		public String SexGubun { get; set; }

		[Display(Name = "승인 구분 이름")]
		public String ApprovalGubunName { get; set; }

		[Display(Name = "우편번호")]
		public String HouseZipCode { get; set; }

		[Display(Name = "주소")]
		public String HouseAddress1 { get; set; }

		[Display(Name = "상세주소")]
		public String HouseAddress2 { get; set; }

		[Display(Name = "소속")]
		public String AssignText { get; set; }

		[Display(Name = "외국인여부")]
		public String ForeignYesNo { get; set; }
		
		[Display(Name = "사용자 구분")]
		public string UserGubun { get; set; }

		[Display(Name = "일반사용자코드")]
		public string GeneralUserCode { get; set; }


		[Display(Name = "페이스북")]
		public string FacebookID { get; set; }


		[Display(Name = "트위터")]
		public string TwitterID { get; set; }

		[Display(Name = "파일그룹번호")]
		public Int64 FileGroupNo { get; set; }

		#region 학생

		[Display(Name = "학적상태")]
		public string HakjeokGubun { get; set; }

		[Display(Name = "학적상태명")]
		public string HakjeokGubunName { get; set; }

		[Display(Name = "학년")]
		public string Grade { get; set; }

		[Display(Name = "학년명")]
		public string GradeName { get; set; }

		[Display(Name = "강의중간체크일자")]
		public string MiddleCheckDay { get; set; }

		#endregion



	}
}
