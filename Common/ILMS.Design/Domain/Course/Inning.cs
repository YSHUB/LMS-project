using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Inning : Course
	{
		public Inning() { }

		public Inning(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "학습구분(1 : 온라인 / 2 : 오프라인 / 3 : 실시간강의(zoom) / 4 : 시험 / 5 : 퀴즈 / 6 : 과제 / 7 : 수업활동일지 / 8 : 팀프로젝트)")]
		public string InningGbn { get; set; }

		[Display(Name = "주차")]
		public int Week { get; set; }

        [Display(Name = "주차이름")]
        public string WeekName { get; set; }

        [Display(Name = "차시순번")]
		public int InningSeqNo { get; set; }

        [Display(Name = "차시이름")]
        public string InningSeqNoName { get; set; }

        [Display(Name = "차시시작일자")]
        public string InningStartDay { get; set; }

        [Display(Name = "차시시작요일")]
        public string InningStartDayWeek { get; set; }

		[Display(Name = "차시종료일자")]
		public string InningEndDay { get; set; }

		[Display(Name = "차시종료요일")]
		public string InningEndDayWeek { get; set; }

		[Display(Name = "차시조회용시험타입")]
		public string ExamType { get; set; }

		[Display(Name = "차시조회용시험번호")]
		public int ExamNo { get; set; }

		[Display(Name = "과제번호")]
		public int HomeworkNo { get; set; }

		[Display(Name = "과제타입")]
		public string HomeworkType { get; set; }

		[Display(Name = "시험제목")]
		public string Title { get; set; }

		[Display(Name = "수업방식")]
		public string LessonForm { get; set; }

		[Display(Name = "수업방식명")]
		public string LessonFormName { get; set; }

		[Display(Name = "강의종류")]
		public string LectureType { get; set; }

		[Display(Name = "강의종류명(온/오프라인)")]
		public string LectureTypeName { get; set; }

		[Display(Name = "출석시간")]
		public int AttendanceTime { get; set; }

		[Display(Name = "중간출석시작분")]
		public int MiddleAttendanceStartMinute { get; set; }

		[Display(Name = "중간출석종료분")]
		public int MiddleAttendanceEndMinute { get; set; }

		[Display(Name = "차시시작일자")]
		public string InningLatenessStartDay { get; set; }

		[Display(Name = "차시종료일자")]
		public string InningLatenessEndDay { get; set; }

		[Display(Name = "출석 상태")]
		public string AttendanceStatus { get; set; }

		[Display(Name = "학습 상태")]
		public string StudyStatus { get; set; }


		[Display(Name = "출석 인정 시간")]
		public int AttendanceAcceptTime { get; set; }

		[Display(Name = "총 학습페이지 갯수")]
		public int TotalContentPage { get; set; }

		[Display(Name = "출석코드")]
		public string AttendanceCode { get; set; }

		[Display(Name = "콘텐츠정보번호")]
		public int LMSContentsNo { get; set; }

		[Display(Name = "줌 URL")]
		public string ZoomURL { get; set; }

		[Display(Name = "강의 내용")]
		public string ContentTitle { get; set; }

		[Display(Name = "맛보기 여부")]
		public string IsPreview { get; set; }

		[Display(Name = "발급회차")]
		public int IssueNo { get; set; }

		[Display(Name = "발급가능여부")]
		public String IssueYN { get; set; }

		[Display(Name = "랜덤숫자1")]
		public string Random1 { get; set; }

		[Display(Name = "랜덤숫자2")]
		public string Random2 { get; set; }

		[Display(Name = "유효시작시간")]
		public String ValidateStartTime { get; set; }

		[Display(Name = "유효종료시간")]
		public String ValidateEndTime { get; set; }

		[Display(Name = "출석여부")]
		public string AttendanceYesNo { get; set; }

		[Display(Name = "지금 진행중 학습")]
		public string InningProgress { get; set; }

		[Display(Name = "오늘 마감 학습")]
		public string InningDeadline { get; set; }

		[Display(Name = "내일 마감 학습")]
		public string InningTomorrowDeadline { get; set; }

		[Display(Name = "이후 마감 학습")]
		public string InningAfterDeadline { get; set; }

		[Display(Name = "지난 학습")]
		public string InningBeforeDeadline { get; set; }

		[Display(Name = "시작전(대기)")]
		public string InningBeforeStart { get; set; }

		[Display(Name = "학습진행여부")]
		public string InningUserState { get; set; }

		[Display(Name = "과제수")]
		public int IsHomework { get; set; }

		[Display(Name = "퀴즈수")]
		public int IsQuiz { get; set; }

		[Display(Name = "대상분반 차시 수")]
		public int CompareCourseInningCount { get; set; }

		[Display(Name = "대상분반 강의 동록된 차시 수")]
		public int CompareCourseEnroll { get; set; }

		[Display(Name = "현재분반 강의 등록된 차시 수")]
		public int NowCourseEnroll { get; set; }

		/* OCW 관련 */
		[Display(Name = "Ocw 번호")]
		public Int64 OcwNo { get; set; }

		[Display(Name = "Ocw명")]
		public string OcwName { get; set; }

		[Display(Name = "OCW 컨텐츠 종류(0: 영상, 1: 파일, 2: 패키지(2018고도화))")]
		public int OcwType { get; set; } //2의 경우 현재 안씀

		[Display(Name = "컨텐츠등록방식(0: URL, 1: 소스코드, 2: Cmaker, 3: 업로드(MP4), 4: HTML(ZIP)업로드, 5: 파일업로드)")]
		public int OcwSourceType { get; set; } //2의 경우 현재 안씀

		[Display(Name = "OCW 소스")]
		public string OcwData { get; set; }

		[Display(Name = "OCW 컨텐츠 파일 그룹번호")]
		public Int64? OcwFileGroupNo { get; set; }

		[Display(Name = "OCW 바로보기 팝업너비")]
		public int OcwWidth { get; set; }

		[Display(Name = "OCW 바로보기 팝업높이")]
		public int OcwHeight { get; set; }
	}
}
