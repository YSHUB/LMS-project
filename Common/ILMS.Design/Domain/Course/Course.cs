using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Course : Subject
	{
		public Course() { }

		public Course(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "분반")]
		public int ClassNo { get; set; }

		[Display(Name = "개설 부서명")]
		public string AssignName { get; set; }

		[Display(Name = "개설 학년(학교용)")]
		public string TargetGradeName { get; set; }

		[Display(Name = "신청 시작일시")]
		public string RStart { get; set; }

		[Display(Name = "신청 종료일시")]
		public string REnd { get; set; }

		[Display(Name = "수강 시작일시")]
		public string LStart { get; set; }

		[Display(Name = "수강 종료일시")]
		public string LEnd { get; set; }

		[Display(Name = "학습유형명")]
		public string StudyTypeName { get; set; }

		[Display(Name = "검색년월")]
		public string SearchDate { get; set; }

		[Display(Name = "대학여부")]
		public string UnivYN { get; set; }

		[Display(Name = "분류번호")]
		public string Mnos { get; set; }

		[Display(Name = "분류명")]
		public string MName { get; set; }

		[Display(Name = "교수번호")]
		public Int64 ProfessorNo { get; set; }

		[Display(Name = "교수명")]
		public string HangulName { get; set; }

		[Display(Name = "과정소개")]
		public string Introduce { get; set; }

		[Display(Name = "이수구분명")]
		public string ClassificationName { get; set; }

		[Display(Name = "캠퍼스명")]
		public string CampusName { get; set; }

		[Display(Name = "수강학생 수")]
		public int StudentCount { get; set; }

		[Display(Name = "학점")]
		public decimal Credit { get; set; }

		[Display(Name = "교수이름")]
		public string ProfessorName { get; set; }

		[Display(Name = "현재까지 진행된 차시 수")]
		public int CurrentInningCount { get; set; }

		[Display(Name = "강좌별 등록된 전체 차시 수")]
		public int InningCount { get; set; }

		[Display(Name = "강좌별 등록된 수강가능한 차시 수")]
		public int LectureInningCount { get; set; }

		[Display(Name = "학생별 진행(수강)한 차시 수")]
		public int AttendanceCount { get; set; }

		[Display(Name = "강의자 여부 (1=강의자 / 0=강의자X)")]
		public int IsProf { get; set; }

		[Display(Name = "강좌별 학습 진도율")]
		public decimal InningRate { get; set; }

		[Display(Name = "이수기준")]
		public int PassPoint { get; set; }

		[Display(Name = "취득점수")]
		public int TotalScore { get; set; }

		[Display(Name = "이수구분")]
		public int? IsPass { get; set; }

		[Display(Name = "구분")]
		public string CreditAcceptGubun { get; set; }

		[Display(Name = "출력 사용자 번호")]
		public int PrintUserNo { get; set; }

		[Display(Name = "전공코드")]
		public string AssignNo { get; set; }

		[Display(Name = "이수 구분")]
		public string FinishGubunName { get; set; }

		[Display(Name = "강좌 개설 상태")]
		public string CourseOpenStatusName { get; set; }

		[Display(Name = "강좌 개설 상태")]
		public string CourseOpenStatus { get; set; }

		[Display(Name = "엑셀용 수강기간 날짜")]
		public string ExcelToLectureDay { get; set; }

		[Display(Name = "수강 신청기간")]
		public string RDay { get; set; }

		[Display(Name = "수강 운영기간")]
		public string LDay { get; set; }

		[Display(Name = "수강 운영상태")]
		public string LSituation { get; set; }

		[Display(Name = "수업개요 및 목표")]
		public string SubjectSummary { get; set; }

		[Display(Name = "교재 및 자료")]
		public string LessonProgressType { get; set; }

		[Display(Name = "수업진행방법")]
		public string TextbookData { get; set; }

		[Display(Name = "출력 여부")]
		public string ViewYesNo { get; set; }

		[Display(Name = "강좌 인원 제한")]
		public int MaxPersonsLimit { get; set; }

		[Display(Name = "교수 번호(여러명)")]
		public string ProfessorNos { get; set; }

		[Display(Name = "파일그룹번호")]
		public Int64? FileGroupNo { get; set; }

		[Display(Name = "시간")]
		public decimal LecTime { get; set; }

		[Display(Name = "강의실(시간)")]
		public string ClassRoom { get; set; }

		[Display(Name = "교과 교육목표")]
		public string ClassTarget { get; set; }

		[Display(Name = "담당교수 이메일")]
		public string Email { get; set; }

		[Display(Name = "담당교수 전화번호")]
		public string OfficePhone { get; set; }

		[Display(Name = "사용자구분")]
		public string Usertype { get; set; }

		[Display(Name = "대표교수구분")]
		public string ProfessorCEO { get; set; }

		[Display(Name = "차시번호")]
		public int InningNo { get; set; }


		[Display(Name = "파일경로")]
		public string SaveFileName { get; set; }

		[Display(Name = "중간고사온라인")]
		public string MiddleTestIsOnline { get; set; }

		[Display(Name = "기말고사온라인")]
		public string LastTestIsOnline { get; set; }

		[Display(Name = "교육시간")]
		public string ClassTime { get; set; }

		[Display(Name = "교육대상")]
		public string TargetUser { get; set; }

		[Display(Name = "교육비")]
		public int CourseExpense { get; set; }

		[Display(Name = "교육문의")]
		public string CourseQA { get; set; }

		[Display(Name = "기기지원")]
		public string SupportDevice { get; set; }

		[Display(Name = "수료증")]
		public string Completion { get; set; }

	}
}
