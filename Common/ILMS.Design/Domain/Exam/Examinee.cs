using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Examinee : Exam
	{
		public Examinee() { }

		public Examinee(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "순번")]
		public int ExamineeRowNum { get; set; }

		[Display(Name = "응시자 사용자번호")]
		public long ExamineeUserNo { get; set; }

		[Display(Name = "평가완료여부")]
		public string IsEstiamtionYesNo { get; set; }

		[Display(Name = "응시일시")]
		public DateTime TakeDateTime { get; set; }

		[Display(Name = "응시일자포맷(yyyy-MM-dd)")]
		public string TakeDateTimeFormat { get; set; }

		[Display(Name = "응시시간포맷(HH:mm:ss)")]
		public string TakeTime { get; set; }

		[Display(Name = "응시일시포맷(yyyy-MM-dd hh:mm:ss)")]
		public string TakeDateTimeFormatView { get; set; }

		[Display(Name = "피드백")]
		public string Feedback { get; set; }

		[Display(Name = "피드백일시")]
		public DateTime FeedbackDateTime { get; set; }

		[Display(Name = "피드백 사용자번호")]
		public long FeedbackUserNo { get; set; }
		
		[Display(Name = "시험형태")]
		public string ExamGubun { get; set; }

		[Display(Name = "사용자 아이디")]
		public string UserID { get; set; }

		[Display(Name = "학적구분")]
		public string HakjeokGubun { get; set; }

		[Display(Name = "재직상태구분")]
		public string WorkGubun { get; set; }

		[Display(Name = "학적구분명칭,  재직상태구분명칭")]
		public string HakjeokGubunName { get; set; }

		[Display(Name = "남은시간(분)")]
		public int RemainTime { get; set; }

		[Display(Name = "남은시간(초)")]
		public int RemainSecond { get; set; }

		[Display(Name = "재응시일시")]
		public DateTime RetestDateTime { get; set; }

		[Display(Name = "재응시구분")]
		public int RetestGubun { get; set; }

		[Display(Name = "제출일시")]
		public DateTime LastDateTime { get; set; }

		[Display(Name = "제출일자포맷(yyyy-MM-dd)")]
		public string LastDateTimeFormat { get; set; }

		[Display(Name = "제출시간포맷(HH:mm:ss)")]
		public string LastTime { get; set; }

		[Display(Name = "제출일시포맷(yyyy-MM-dd hh:mm:ss)")]
		public string LastDateTimeFormatView { get; set; }

		[Display(Name = "응시자 IP")]
		public string ExamUserIpAddr { get; set; }

		[Display(Name = "핸디캡여부")]
		public string HandicapYN { get; set; }

		[Display(Name = "학년")]
		public string Grade { get; set; }

		[Display(Name = "학년명칭")]
		public string GradeNm { get; set; }

		[Display(Name = "총 남은 초( RemainTime + RemainSecond )")]
		public int InitSecond { get; set; }

		[Display(Name = "응시상태( N : 미응시 / P : 시험중 / Y : 응시완료 )")]
		public string ExamStatus { get; set; }

		[Display(Name = "응시상태명칭")]
		public string ExamStatusNm { get; set; }

		[Display(Name = "오프등록상태")]
		public string OFFYesNo { get; set; }

		[Display(Name = "검색구분")]
		public string SearchGubun { get; set; }

		[Display(Name = "정렬구분")]
		public string SortGubun { get; set; }

		[Display(Name = "경과시간포맷(hh분 ss초)")]
		public string RemainTimeFormat { get; set; }

		[Display(Name = "오프라인 응시 메모")]
		public string OFFMEMO { get; set; }

		[Display(Name = "오프라인 응시 파일")]
		public long OFFFile { get; set; }

		[Display(Name = "추가시험 응시대상자")]
		public string ChkAddExaminee { get; set; }

		[Display(Name = "구분")]
		public string GeneralUserCode { get; set; }
	}
}
