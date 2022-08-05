using ILMS.Design.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.ViewModels
{
	//계정관련 페이지
	public class AccountViewModel : BaseViewModel
	{
		[Display(Name = "아이디(학번)")]
		public string UserID { get; set; }

		[Display(Name = "비밀번호")]
		public string Password { get; set; }

		[Display(Name = "로그인구분(학생/교직원)")]
		public string LoginGbn { get; set; }

		[Display(Name = "사용자정보")]
		public User User { get; set; }

		[Display(Name = "사용자 유형")]
		public string UserType { get; set; }


		[Display(Name = "사용자 리스트")]
		public IList<User> UserList { get; set; }

		[Display(Name = "학생")]
		public Student Student { get; set; }

		public string SearchOption { get; set; }

		[Display(Name = "소속")]
		public string AssignNo { get; set; }
		
		
		[Display(Name = "검색조건 직원구분 ")]
		public string UserTypeGubun { get; set; }

		[Display(Name = "대학교")]
		public string University { get; set; }

		[Display(Name = "캠퍼스")]
		public string Campus { get; set; }

		[Display(Name = "조직")]
		public string Organization { get; set; }
		[Display(Name = "대학")]
		public string College { get; set; }
		[Display(Name = "부서")]
		public string Department { get; set; }
		[Display(Name = "전공")]
		public string Major { get; set; }

		[Display(Name = "파일그룹번호")]
		public int FileGroupNo { get; set; }

		[Display(Name = "HangulName 배열")]
		public string[] HangulNameArray { get; set; }

		[Display(Name = "UserID 배열")]
		public string[] UserIDArray { get; set; }

		[Display(Name = "Password 배열")]
		public string[] PasswordArray { get; set; }

		[Display(Name = "ResidentNo 배열")]
		public string[] ResidentNoArray { get; set; }

		[Display(Name = "AssignText 배열")]
		public string[] AssignTextArray { get; set; }

		[Display(Name = "Mobile 배열")]
		public string[] MobileArray { get; set; }

		[Display(Name = "Email 배열")]
		public string[] EmailArray { get; set; }

		[Display(Name = "SexGubun 배열")]
		public string[] SexGubunArray { get; set; }

		[Display(Name = "UploadGubun 배열")]
		public string[] UploadGubunArray { get; set; }

		[Display(Name = "검색구분")]
		public string SearchGbn { get; set; }

		[Display(Name = "인증구분")]
		public string ApprovalGbn { get; set; }
	}
}
