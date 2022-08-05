using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class StudyLog : StudyInning
	{
		public StudyLog() { }

		public StudyLog(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "수강로그번호")]
		public Int64 StudyLogNo { get; set; }

		[Display(Name = "수강생 사용자번호")]
		public Int64 StudyUserNo { get; set; }

		[Display(Name = "수강시간(초)")]
		public int TotalStudyTime { get; set; }

		[Display(Name = "수강이력")]
		public string StudyHistory { get; set; }

		[Display(Name = "수강횟수")]
		public int StudyCount { get; set; }

		[Display(Name = "최초 수강일시")]
		public string FirstStudyDateTime { get; set; }

		[Display(Name = "마지막 수강일시")]
		public string LastStudyDateTime { get; set; }

    }
}
