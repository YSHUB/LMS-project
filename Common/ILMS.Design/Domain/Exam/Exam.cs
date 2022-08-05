using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Exam : Course
	{
		public Exam() { }

		public Exam(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "시험 번호(Key)")]
		public int ExamNo { get; set; }

		[Display(Name = "주차")]
		public int Week { get; set; }

		[Display(Name = "차시순번")]
		public int InningSeqNo { get; set; }

		[Display(Name = "시험 제목")]
		public string ExamTitle { get; set; }

		[Display(Name = "시험 종류")]
		public string ExamItem { get; set; }

		[Display(Name = "성적반영여부")]
		public int IsGrading { get; set; }

		[Display(Name = "공개여부")]
		public string OpenYesNo { get; set; }

		[Display(Name = "응시방식")]
		public int SEType { get; set; }

		[Display(Name = "응시방식(시작/종료방식) 시작/종료 여부 (0 : 종료, 1 : 시작)")]
		public int SE0State { get; set; }

		[Display(Name = "문제섞기여부")]
		public string UseMixYesNo { get; set; }

		[Display(Name = "보기섞기여부")]
		public string ExampleMixYesNo { get; set; }

		[Display(Name = "성적반영여부명칭")]
		public string IsGradingNm { get; set; }

		[Display(Name = "공개여부명칭")]
		public string OpenYesNoNm { get; set; }

		[Display(Name = "응시방식명칭")]
		public string SETypeNm { get; set; }

		[Display(Name = "문제섞기여부명칭")]
		public string UseMixYesNoNm { get; set; }

		[Display(Name = "보기섞기여부명칭")]
		public string ExampleMixYesNoNm { get; set; }

		[Display(Name = "제한시간")]
		public int LimitTime { get; set; }

		[Display(Name = "응시제한유형")]
		public string RestrictionType { get; set; }

		[Display(Name = "응시제한유형명칭")]
		public string RestrictionTypeNm { get; set; }

		[Display(Name = "평가완료여부")]
		public string EstimationGubun { get; set; }

		[Display(Name = "평가완료여부명칭")]
		public string EstimationGubunNm { get; set; }

		[Display(Name = "응시시작일자")]
		public DateTime StartDay { get; set; }

		[Display(Name = "응시종료일자")]
		public DateTime EndDay { get; set; }

		[Display(Name = "응시시작일자포맷(yyyy-MM-dd)")]
		public string StartDayFormat { get; set; }

		[Display(Name = "응시종료일자포맷(yyyy-MM-dd)")]
		public string EndDayFormat { get; set; }

		[Display(Name = "응시시작시(HH)")]
		public string StartHours { get; set; }

		[Display(Name = "응시시작분(mm)")]
		public string StartMin { get; set; }

		[Display(Name = "응시종료시(HH)")]
		public string EndHours { get; set; }

		[Display(Name = "응시종료분(mm)")]
		public string EndMin { get; set; }

		[Display(Name = "구분 (Q : 퀴즈 / E : 시험)")]
		public string Gubun { get; set; }

		[Display(Name = "응시인원")]
		public int TakeStudentCount { get; set; }

		[Display(Name = "평가완료인원")]
		public int CheckStudentCount { get; set; }

		[Display(Name = "평가총인원")]
		public int TotalStudentCount { get; set; }

		[Display(Name = "시험내용")]
		public string ExamContents { get; set; }

		[Display(Name = "응시방법")]
		public string TakeType { get; set; }

		[Display(Name = "학기년도명")]
		public string TermQuarterName { get; set; }
		
		[Display(Name = "출제완료여부")]
		public string CompleteYesNo { get; set; }

		[Display(Name = "추가시험여부")]
		public string AddExamYesNo { get; set; }

		[Display(Name = "재시험여부")]
		public string ReExamYesNo { get; set; }

		[Display(Name = "제출유형")]
		public string SubmitType { get; set; }

		[Display(Name = "시험유형(중간, 기말)")]
		public string ExamType { get; set; }

		[Display(Name = "수업방식")]
		public string LessonForm { get; set; }

		[Display(Name = "수업방식명칭")]
		public string LessonFormNm { get; set; }

		[Display(Name = "온라인오프라인여부")]
		public string LectureType { get; set; }

		[Display(Name = "온라인오프라인여부명칭")]
		public string LectureTypeNm { get; set; }

		[Display(Name = "응시자 응시상태")]
		public string UserState { get; set; }

		[Display(Name = "응시자 응시상태 명칭")]
		public string UserStateNm { get; set; }

		[Display(Name = "시작/종료방식 응시대기 구분하기 위해 필요")]
		public int SE0StateGbn { get; set; }

		[Display(Name = "추가시험 신규 구분")]
		public string AddExamGbn { get; set; }

		[Display(Name = "추가시험 Rowstate")]
		public string AddExamRowstate { get; set; }

		[Display(Name = "시험완료여부(0 : 미완료 / 1 : 완료)")]
		public string IsResultYesNo { get; set; }

		[Display(Name = "응시번호")]
		public int ExamineeNo { get; set; }

		[Display(Name = "총점")]
		public decimal ExamTotalScore { get; set; }

		[Display(Name = "담당교수명")]
		public string ProfessorNm { get; set; }

		[Display(Name = "학기기간")]
		public string PeriodTerm { get; set; }

		[Display(Name = "생성수")]
		public int CreateCnt { get; set; }

		[Display(Name = "응시기간 (엑셀)")]
		public string ExamDate { get; set; }

		[Display(Name = "평가인원 (엑셀)")]
		public string EstimationCount { get; set; }

		[Display(Name = "수강완료여부")]
		public string AvailabilityYesNo { get; set; }
	}
}
