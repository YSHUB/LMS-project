using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class EstimationItemBasis : Course
	{
		public EstimationItemBasis() { }

		public EstimationItemBasis(string rowState)
		{
			RowState = rowState;
		}
		[Display(Name = "평가 방법")]
		public string EstimationType { get; set; }

		[Display(Name = "만점 처리 기준")]
		public string PerfectionHandleBasis { get; set; }

		[Display(Name = "평가항목구분")]
		public string EstimationItemGubun { get; set; }

		[Display(Name = "평가항목")]
		public string EstimationItemGubunName { get; set; }

		[Display(Name = "비율점수")]
		public int RateScore { get; set; }

		[Display(Name = "기준점수")]
		public int BasisScore { get; set; }

		[Display(Name = "참여도항목구분")]
		public string ParticipationItemGubun { get; set; }

		[Display(Name = "참여도항목구분이름")]
		public string ParticipationItemGubunName { get; set; }

		[Display(Name = "상중하기준코드")]
		public string HighMiddleLowBasisCode { get; set; }

		[Display(Name = "상중하기준코드이름")]
		public string HighMiddleLowBasisCodeName { get; set; }

		[Display(Name = "충족횟수")]
		public int EnoughCount { get; set; }

		[Display(Name = "연결일자")]
		public string LinkDateTime { get; set; }

		[Display(Name = "출석 자동 수동 여부")]
		public string AttendanceAutoPassiveYesNo { get; set; }

		[Display(Name = "지각 감점 값")]
		public decimal LatenessPenaltyValue { get; set; }

		[Display(Name = "지각 감점 값")]
		public decimal AbsencePenaltyValue { get; set; }

		[Display(Name = "평가 항목 합계")]
		public int EstimationItemSummary { get; set; }

		[Display(Name = "참여도 인정 방법")]
		public string ParticipationAcceptType { get; set; }

		[Display(Name = "MOOC 평가기준 설정 저장 여부")]
		public bool saveEstimationOut { get; set; }

		[Display(Name = "중간고사비율")]
		public int MidtermExamRatio { get; set; }

		[Display(Name = "기말고사비율")]
		public int FinalExamRatio { get; set; }

		[Display(Name = "출석비율")]
		public int AttendanceRatio { get; set; }

		[Display(Name = "퀴즈비율")]
		public int QuizRatio { get; set; }

		[Display(Name = "과제비율")]
		public int HomeworkRatio { get; set; }
	}
}
