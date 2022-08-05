using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class ExamRandom : Exam
	{
		public ExamRandom() { }

		public ExamRandom(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "문제출제주차")]
		public string Difficulty { get; set; }

		[Display(Name = "문제출제주차명칭")]
		public string WeekName { get; set; }

		[Display(Name = "출제문항수")]
		public int ExamRowNum { get; set; }

		[Display(Name = "배점(정수 - 소수점버림)")]
		public int EachPoint { get; set; }

		[Display(Name = "배점(소수)")]
		public decimal EachPointDec { get; set; }

		[Display(Name = "후보문항수")]
		public int QuestionCnt { get; set; }
	}
}
