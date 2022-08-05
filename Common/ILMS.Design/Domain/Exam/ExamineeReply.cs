using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class ExamineeReply : Exam
	{
		public ExamineeReply() { }

		public ExamineeReply(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "답변번호(Key)")]
		public int ReplyNo { get; set; }

		[Display(Name = "문항번호")]
		public int QuestionNo { get; set; }

		[Display(Name = "응시자답안")]
		public string ExamineeAnswer { get; set; }

		[Display(Name = "점수(정수)")]
		public int Score { get; set; }

		[Display(Name = "점수(소수)")]
		public decimal ScoreDec { get; set; }

		[Display(Name = "문제은행번호")]
		public int QuestionBankNo { get; set; }

		[Display(Name = "주차 코드")]
		public string Difficulty { get; set; }

		[Display(Name = "문제유형")]
		public string QuestionType { get; set; }

		[Display(Name = "문제")]
		public string Question { get; set; }

		[Display(Name = "답안 설명")]
		public string AnswerExplain { get; set; }

		[Display(Name = "구분번호")]
		public int GubunNo { get; set; }

		[Display(Name = "보기번호")]
		public int ExampleNo { get; set; }

		[Display(Name = "보기내용")]
		public string ExampleContents { get; set; }

		[Display(Name = "정답여부")]
		public string CorrectAnswerYesNo { get; set; }

		[Display(Name = "파일번호")]
		public int FileNo { get; set; }

		[Display(Name = "파일명")]
		public string OriginFileName { get; set; }

		[Display(Name = "응시자 객관식 만점")]
		public decimal MultipleChoice { get; set; }

		[Display(Name = "응시자 주관식 만점")]
		public decimal EssayQuestion { get; set; }

		[Display(Name = "응시자 객관식 총점")]
		public decimal MultipleChoiceScore { get; set; }

		[Display(Name = "응시자 주관식 총점")]
		public decimal EssayQuestionScore { get; set; }

		[Display(Name = "모범답안")]
		public string CorrectAnswer { get; set; }
	}
}
