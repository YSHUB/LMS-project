using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Term : Common
	{
		public Term() { }

		public Term(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "학기 번호")]
		public int TermNo { get; set; }

		[Display(Name = "학기 구분")]
		public string TermGubun { get; set; }

		[Display(Name = "학년도")]
		public string TermYear { get; set; }

		[Display(Name = "학기")]
		public string TermQuarter { get; set; }

		[Display(Name = "학기명( 년도 + 학기 또는 년도 + 회차 + (기간) )")]
		public string TermName { get; set; }

		[Display(Name = "학기 시작일자")]
		public string TermStartDay { get; set; }

		[Display(Name = "학기 종료일자")]
		public string TermEndDay { get; set; }

		[Display(Name = "수강신청 시작일자")]
		public string LectureRequestStartDay { get; set; }

		[Display(Name = "수강신청 종료일자")]
		public string LectureRequestEndDay { get; set; }

		[Display(Name = "수강 시작일자")]
		public string LectureStartDay { get; set; }

		[Display(Name = "수강 종료일자")]
		public string LectureEndDay { get; set; }

		[Display(Name = "접속제한 시작일자")]
		public string AccessRestrictionStartDay { get; set; }

		[Display(Name = "접속제한 종료일자")]
		public string AccessRestrictionEndDay { get; set; }

		[Display(Name = "접속제한명")]
		public string AccessRestrictionName { get; set; }


		[Display(Name = "지각처리 일수")]
		public int LatenessSetupDay { get; set; }

		[Display(Name = "강좌번호(LMS)")]
		public int CourseNo { get; set; }

		[Display(Name = "현재학기여부")]
		public string CurrentTermYn { get; set; }

		[Display(Name = "학기 구분 코드이름")]
		public string TermGubunName { get; set; }

		[Display(Name = "회차")]
		public string TermRound { get; set; }

		[Display(Name = "학기 또는 회차명")]
		public string TermSemester { get; set; }
	}
}
