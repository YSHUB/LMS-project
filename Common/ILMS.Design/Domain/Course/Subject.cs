using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Subject : Term
	{
		public Subject() { }

		public Subject(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "프로그램번호(1:교과, 2:비교과)")]
		public int ProgramNo { get; set; }

		[Display(Name = "프로그램명")]
		public string ProgramName { get; set; }

		[Display(Name = "교과목번호(LMS)")]
		public int SubjectNo { get; set; }

		[Display(Name = "교과목명")]
		public string SubjectName { get; set; }

		[Display(Name = "학수번호")]
		public string HaksuNo { get; set; }

		[Display(Name = "학습유형(CSTD)")]
		public string StudyType { get; set; }
	}
}
