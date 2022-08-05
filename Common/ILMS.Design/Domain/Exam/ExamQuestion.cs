using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class ExamQuestion : Exam
	{
		public ExamQuestion() { }

		public ExamQuestion(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "문항 번호(Key)")]
		public int QuestionNo { get; set; }
		
		[Display(Name = "순번")]
		public int RowIndex { get; set; }

		[Display(Name = "문제은행 번호")]
		public int QuestionBankNo { get; set; }

		[Display(Name = "배점")]
		public double EachScore { get; set; }

		[Display(Name = "구분 번호")]
		public int GubunNo { get; set; }

		[Display(Name = "문제")]
		public string Question { get; set; }

		[Display(Name = "문제유형")]
		public string QuestionType { get; set; }

		[Display(Name = "주차 코드")]
		public string Difficulty { get; set; }

		[Display(Name = "주차 숫자")]
		public int DifficultySeq { get; set; }

		[Display(Name = "주차 명칭")]
		public string DifficultyNm { get; set; }

		[Display(Name = "문제유형명칭")]
		public string QuestionTypeNm { get; set; }

		[Display(Name = "답안체크")]
		public string AnswerChk { get; set; }

		[Display(Name = "응시자답안")]
		public string ExamineeAnswer { get; set; }

		[Display(Name = "답안번호")]
		public int ReplyNo { get; set; }

		[Display(Name = "배점")]
		public int EachPoint { get; set; }

		[Display(Name = "배점(소수)")]
		public decimal EachPointDec { get; set; }

		[Display(Name = "객관식, 주관식 구분")]
		public string QuestionCategory { get; set; }

		[Display(Name = "답안 저장일시")]
		public string SaveDateTimeFormatView { get; set; }

		[Display(Name = "점수")]
		public int Score { get; set; }

		[Display(Name = "점수(소수)")]
		public decimal ScoreDec { get; set; }

		[Display(Name = "답안설명")]
		public string AnswerExplain { get; set; }

		[Display(Name = "코멘트")]
		public string Feedback { get; set; }

		[Display(Name = "참여인원")]
		public int ParticipationCnt { get; set; }

		[Display(Name = "정답건수")]
		public int RightCnt { get; set; }
	}
}
