using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class OcwCourse : Ocw
	{
		public OcwCourse() { }

		public OcwCourse(string rowState)
		{
			RowState = rowState;
		}

		[Required]
		[Display(Name = "강좌 번호")]
		public Int64 CourseNo { get; set; }

		[Display(Name = "LMS 주차 연계 순번")]
		public int SeqNo { get; set; }

		[Display(Name = "교과목")]
		public string SubjectName { get; set; }

		[Display(Name = "분반")]
		public int ClassNo { get; set; }

		[Display(Name = "학년도")]
		public string TermYear { get; set; }

		[Display(Name = "학기")]
		public string TermQuarterName { get; set; }

		[Display(Name = "주차")]
		public int Week { get; set; }

		[Display(Name = "주차시작날짜")]
		public string WeekStartDay { get; set; }

		[Display(Name = "주차종료날짜")]
		public string WeekEndDay { get; set; }

		[Display(Name = "타이틀")]
		public string Title { get; set; }

		[Display(Name = "중요도( 1 : 필수, 0 : 보조 )")]
		public int IsImportant { get; set; }

		[Display(Name = "중요도명")]
		public string IsImportantName { get; set; }

		[Display(Name = "강의연계구분( 1 : 강의LMS, 0 : 출석연계 )")]
		public bool IsCourseOcw { get; set; } 

		[Display(Name = "강의연계구분명")]
		public string IsCourseOcwName { get; set; }

		[Display(Name = "강좌내 OCW 적용수")]
		public int CourseOcwCount { get; set; }

		[Display(Name = "강좌 조회수")]
		public int ViewCount { get; set; }

		[Display(Name = "강좌 의견수")]
		public int CourseOpCount{ get; set; }

		[Display(Name = "신청자명")]
		public string RegUserName { get; set; }
		
		[Display(Name = "새콘텐츠명")]
		public string OcwReName { get; set; }

		[Display(Name = "사용여부")]
		public string UsingYesNo { get; set; }

		[Display(Name = "댓글갯수")]
		public int OcwOpinionCount { get; set; }

		[Display(Name = "썸네일파일명")]
		public string FileName { get; set; }

	}
}
