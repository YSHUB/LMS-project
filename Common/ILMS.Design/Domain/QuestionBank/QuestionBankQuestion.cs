using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class QuestionBankQuestion : Common
	{
		public QuestionBankQuestion() { }

		public QuestionBankQuestion(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "문제은행번호")]
		public long QuestionBankNo { get; set; }

		[Display(Name = "난이도")]
		public string Difficulty { get; set; }

		[Display(Name = "문제유형")]
		public string QuestionType { get; set; }

		[Display(Name = "문제")]
		public string Question { get; set; }

		[Display(Name = "답안설명")]
		public string AnswerExplain { get; set; }

		[Display(Name = "구분번호")]
		public int GubunNo { get; set; }

		[Display(Name = "사용횟수")]
		public int UseCount { get; set; }

		public string QuestionTypeName { get; set; }
		public int QuestionTypeCount { get; set; }
		public string QuestionDifficultyName { get; set; }
		public int Row { get; set; }
		public string GubunName { get; set; }
		public string GubunType { get; set; }

		public string QuestionBankNos { get; set; }
		public double Score { get; set; }

		public int DifficultySeq { get; set; }

	}
}
