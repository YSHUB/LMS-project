using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Statistics : Common
	{
		public Statistics() { }

		public Statistics(string rowState)
		{
			RowState = rowState;
		}
		
		#region 접속통계용

		[Display(Name = "로그인 날짜")]
		public DateTime LoginDay { get; set; }

		[Display(Name = "비회원 로그인 날짜")]
		public DateTime NonLoginDay { get; set; }

		#endregion 접속통계용

		#region 활동통계용 - 교수 메뉴활동현황

		[Display(Name = "과목 번호")]
		public int CourseNo { get; set; }
		
		[Display(Name = "교과목명")]
		public string SubjectName { get; set; }
		
		[Display(Name = "캠퍼스명")]
		public string CampusName { get; set; }

		[Display(Name = "분반")]
		public int ClassNo { get; set; }

		[Display(Name = "학점")]
		public decimal Credit { get; set; }

		[Display(Name = "시간")]
		public decimal LecTime { get; set; }

		[Display(Name = "소속명")]
		public string AssignName { get; set; }

		[Display(Name = "교수 이름")]
		public string ProNameList { get; set; }
		
		[Display(Name = "학습 유형")]
		public string StudyTypeName { get; set; }

		[Display(Name = "퀴즈 카운트")]
		public int ExamCount { get; set; }

		[Display(Name = "과제 카운트")]
		public int HomeworkCount { get; set; }

		[Display(Name = "팀프로젝트 카운트")]
		public int ProjectCount { get; set; }

		[Display(Name = "토론 카운트")]
		public int DiscussionCount { get; set; }

		[Display(Name = "강의LMS 적용 카운트")]
		public int CourseOcwCount { get; set; }

		[Display(Name = "주별 학습의견 카운트")]
		public int CourseOcwOpinionCount { get; set; }

		#endregion 활동통계용 - 교수 메뉴활동현황

		#region 활동통계용 - 게시물 등록현황

		[Display(Name = "공지사항 카운트")]
		public int NCount { get; set; }

		[Display(Name = "강의 Q&A 카운트")]
		public int QACount { get; set; }

		[Display(Name = "강의 Q&A 답변 카운트")]
		public int ReQACount { get; set; }

		[Display(Name = "강의자료 카운트")]
		public int FileCount { get; set; }

		[Display(Name = "1:1 상담 카운트")]
		public int OneCount { get; set; }

		[Display(Name = "1:1 상담 답변 카운트")]
		public int ReOneCount { get; set; }

		#endregion 활동통계용 - 게시물 등록현황

		#region 컨텐츠통계 및 운영통계용

		[Display(Name = "통계 구분")]
		public string OcwStatisticsGubun { get; set; }

		[Display(Name = "통계 구분")]
		public string CourseStatisticsGubun { get; set; }

		[Display(Name = "1월")]
		public int JanCnt { get; set; }

		[Display(Name = "2월")]
		public int FebCnt { get; set; }

		[Display(Name = "3월")]
		public int MarCnt { get; set; }

		[Display(Name = "4월")]
		public int AprCnt { get; set; }

		[Display(Name = "5월")]
		public int MayCnt { get; set; }

		[Display(Name = "6월")]
		public int JunCnt { get; set; }

		[Display(Name = "7월")]
		public int JulCnt { get; set; }

		[Display(Name = "8월")]
		public int AguCnt { get; set; }

		[Display(Name = "9월")]
		public int SepCnt { get; set; }

		[Display(Name = "10월")]
		public int OctCnt { get; set; }

		[Display(Name = "11월")]
		public int NovCnt { get; set; }

		[Display(Name = "12월")]
		public int DecCnt { get; set; }

		#endregion 컨텐츠통계 및 운영통계용

		#region 개인별컨텐츠통계

		[Display(Name = "학부생/교원 구분")]
		public string UserTypeName { get; set; }

		[Display(Name = "이름(학번)")]
		public string UserName { get; set; }

		[Display(Name = "컨텐츠 등록수")]
		public int OcwCount { get; set; }

		[Display(Name = "컨텐츠 조회수")]
		public int UsingCount { get; set; }

		[Display(Name = "컨텐츠 추천수")]
		public int LikeCount { get; set; }

		[Display(Name = "컨텐츠 추천수")]
		public int OpinionCount { get; set; }

		#endregion 개인별컨텐츠통계

		# region 프로그램이수현황

		[Display(Name = "수강인원")]
		public int PersonCount { get; set; }

		[Display(Name = "등록차시")]
		public int EnrollCourse { get; set; }

		[Display(Name = "강의이수 완료자")]
		public int AttendanceCourse { get; set; }

		[Display(Name = "강의이수 완료율")]
		public decimal AttendanceCourseRate { get; set; }

		[Display(Name = "퀴즈(1) 응시자")]
		public int TakeExaminee1 { get; set; }

		[Display(Name = "퀴즈(1) 응시율")]
		public decimal TakeExamineeRate1 { get; set; }

		[Display(Name = "퀴즈(2) 응시자")]
		public int TakeExaminee2 { get; set; }

		[Display(Name = "퀴즈(2) 응시율")]
		public decimal TakeExamineeRate2 { get; set; }

		[Display(Name = "퀴즈(3) 응시자")]
		public int TakeExaminee3 { get; set; }

		[Display(Name = "퀴즈(3) 응시율")]
		public decimal TakeExamineeRate3 { get; set; }

		[Display(Name = "퀴즈(4) 응시자")]
		public int TakeExaminee4 { get; set; }

		[Display(Name = "퀴즈(4) 응시율")]
		public decimal TakeExamineeRate4 { get; set; }

		[Display(Name = "퀴즈(5) 응시자")]
		public int TakeExaminee5 { get; set; }

		[Display(Name = "퀴즈(5) 응시율")]
		public decimal TakeExamineeRate5 { get; set; }
		
		[Display(Name = "시험 제목")]
		public string ExamTitle { get; set; }

		#endregion 프로그램이수현황

		#region 학생별이수현황

		[Display(Name = "유저 아이디")]
		public string UserID { get; set; }

		[Display(Name = "유저 이름")]
		public string HangulName { get; set; }

		[Display(Name = "학적 구분")]
		public string HakjeokGubunName { get; set; }

		[Display(Name = "강의이수율")]
		public decimal CourseRate { get; set; }

		[Display(Name = "퀴즈수강현황")]
		public int AttendanceQuiz { get; set; }

		[Display(Name = "퀴즈수강차시")]
		public int EnrollQuiz { get; set; }

		[Display(Name = "퀴즈이수율")]
		public decimal QuizRate { get; set; }

		[Display(Name = "구분")]
		public string GeneralUserCode { get; set; }

		[Display(Name = "이메일")]
		public string Email { get; set; }

		#endregion 학생별이수현황

	}
}
