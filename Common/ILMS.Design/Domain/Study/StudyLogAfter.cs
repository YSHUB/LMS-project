using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class StudyLogAfter : Common
	{
		public StudyLogAfter() { }

		public StudyLogAfter(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "로그번호")]
		public Int64 LogNo { get; set; }

		[Display(Name = "수강번호")]
		public int LectureNo { get; set; }

		[Display(Name = "차시번호")]
		public int InningNo { get; set; }

		[Display(Name = "로그시작일시")]
		public string LStart { get; set; }

		[Display(Name = "로그종료일시")]
		public string LEnd { get; set; }

		[Display(Name = "로그시간(초)")]
		public int LSecond { get; set; }

		[Display(Name = "학습기기")]
		public int StudyDevice { get; set; }

		[Display(Name = "로그기록자환경")]
		public string LogUserAgent { get; set; }
	}
}
