using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class StudyInning : Inning
	{
		public StudyInning() { }

		public StudyInning(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "수강번호")]
		public int LectureNo { get; set; }

		[Display(Name = "마지막수강시간")]
		public string StudyLatelyDateTime { get; set; }

		[Display(Name = "학습시간")]
		public int StudyTime { get; set; }

		[Display(Name = "학습접속수")]
		public int StudyConnectCount { get; set; }

		[Display(Name = "학적구분")]
		public string HakjeokGubun { get; set; }

		[Display(Name = "학년")]
		public string Grade { get; set; }

		[Display(Name = "아이디")]
		public string UserID { get; set; }

		[Display(Name = "차시번호")]
		public int StudyInningNo { get; set; }

		[Display(Name = "페이지갯수")]
		public int PageCnt { get; set; }

		[Display(Name = "출석변경사유")]
		public string AttendanceReason { get; set; }

		[Display(Name = "학습기기")]
		public int StudyDevice { get; set; }

		[Display(Name = "학습일자")]
		public string StudyDate { get; set; }

		[Display(Name = "지각감점")]
		public decimal LatenessPenaltyValue { get; set; }

		[Display(Name = "결석감점")]
		public decimal AbsencePenaltyValue { get; set; }

		[Display(Name = "유저타입명")]
		public string UserTypeName { get; set; }

		[Display(Name = "학번")]
		public string StudentNo { get; set; }

		[Display(Name = "대학교명")]
		public string UniversityName { get; set; }

		[Display(Name = "외국인여부")]
		public string ForeignYesNo { get; set; }


		[Display(Name = "학적구분")]
		public string HakjeokGubunName { get; set; }

		[Display(Name = "구분")]
		public string GeneralUserCode { get; set; }

		[Display(Name = "생년월일")]
		public string ResidentNo { get; set; }

		[Display(Name = "파일번호")]
		public int FileNo { get; set; }

		public int OnlineAttendance { get; set; }

		public int OnlineLateness { get; set; }

        public int OnlineEarlyLeave { get; set; }

        /// <summary>
        /// 온라인결석
        /// </summary>
        public int OnlineAbsence { get; set; }

        /// <summary>
        /// 오프라인 출석
        /// </summary>
        public int OfflineAttendance { get; set; }

        /// <summary>
        /// 오프라인지각
        /// </summary>
        public int OfflineLateness { get; set; }

        /// <summary>
        /// 오프라인조퇴
        /// </summary>
        public int OfflineEarlyLeave { get; set; }

        /// <summary>
        /// 오프라인 결석
        /// </summary>
        public int OfflineAbsence { get; set; }

        /// <summary>
        /// 오프라인미체크
        /// </summary>
        public int OfflineStandby { get; set; }

        /// <summary>
        /// 총출석횟숫
        /// </summary>
        public int TotalAttendance { get; set; }

        /// <summary>
        /// 총지각횟숫
        /// </summary>
        public int TotalLateness { get; set; }

        /// <summary>
        /// 총결석횟숫
        /// </summary>
        public int TotalAbsence { get; set; }

        /// <summary>
        /// 총 조퇴 수
        /// </summary>
        public int TotalEarlyLeave { get; set; }

        /// <summary>
        /// 학습진도
        /// </summary>
        public int TotalStudy { get; set; }


        /// <summary>
        /// 총차시횟숫
        /// </summary>
        public int TotalInning { get; set; }

        /// <summary>
        /// 총차시횟숫
        /// </summary>
        public string FailingGradeYesNo { get; set; }


        public string GradeName { get; set; }


        public string StudyAttendance { get; set; }

        public string IsOnline { get; set; }

        [Display(Name = "수강 최초학습일")]
        public string StudyStartDateTime { get; set; }

        [Display(Name = "수강 학습완료일")]
        public string StudyEndDateTime { get; set; }

        [Display(Name = "수강 학습완료일")]
        public string StudyMiddleDateTime { get; set; }

        [Display(Name = "엑셀용 학습시간")]
        public string StudyTimeExel { get; set; }

		[Display(Name = "엑셀용 학습시간")]
		public int OnlineInningCount { get; set; }

		[Display(Name = "엑셀용 학습시간")]
		public int OfflineInningCount { get; set; }

	}
}
