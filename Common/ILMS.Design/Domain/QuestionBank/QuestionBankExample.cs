using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class QuestionBankExample : Common
	{
		public QuestionBankExample() { }

		public QuestionBankExample(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "보기번호")]
		public long ExampleNo { get; set; }
		[Display(Name = "보기내용")]
		public string ExampleContents { get; set; }
		[Display(Name = "정답여부")]
		public string CorrectAnswerYesNo { get; set; }
		[Display(Name = "문제은행번호")]
		public long QuestionBankNo { get; set; }
		[Display(Name = "파일그룹번호")]
		public int? FileGroupNo { get; set; }
		[Display(Name = "GubunNo")]
		public int GubunNo { get; set; }
		[Display(Name = "보기 뒤섞기")]
		public long ExampleNoRandom { get; set; }

		public IList<File> fileList { get; set; } 

		public string FileName { get; set; }
		public int FileNo { get; set; }
		public string SaveFileName { get; set; }
		public string Question { get; set; }

		public string Difficulty { get; set; }
		public string QuestionType { get; set; }
		public string AnswerExplain { get; set; }
		public string Answer { get; set; }

		public string Exam1 { get; set; }
		public string Exam2 { get; set; }
		public string Exam3 { get; set; }
		public string Exam4 { get; set; }
		public string Exam5 { get; set; }
		public string Exam6 { get; set; }
		public string Exam7 { get; set; }
		public int No { get; set; }
		public string QuestionBankNos { get; set; }

	}
}
