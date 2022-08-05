using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class LoginUser : Common
	{
		public LoginUser() { }

		public LoginUser(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "로그인번호")]
		public Int64 LoginNo { get; set; }

		[Display(Name = "로그인 사용자번호")]
		public int LoginUserNo { get; set; }

		[Display(Name = "로그인일시")]
		public string LoginDay { get; set; }

		[Display(Name = "로그아웃일시")]
		public string LogoutDay { get; set; }

		[Display(Name = "로그인IP주소")]
		public string LoginIPAddress { get; set; }

		[Display(Name = "강의실 접속일시")]
		public string LectureRoomCheckDay { get; set; }

		[Display(Name = "연결구분 (1:PC  2:Mobile)")]
		public int ConnectGubun { get; set; }
	}
}
