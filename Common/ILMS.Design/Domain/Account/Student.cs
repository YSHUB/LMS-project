using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
    [Serializable]
    public class Student : User
    {
        public Student() { }

        public Student(string rowState)
        {
            RowState = rowState;
        }

        [Display(Name = "학과 반")]
        public String DepartmentClass { get; set; }

        [Display(Name = "주야 여부")]
        public String DayNightYesNo { get; set; }

        [Display(Name = "수강 주야 여부")]
        public String LectureDayNightYesNo { get; set; }

        [Display(Name = "학년")]
        public String Grade2 { get; set; }

        [Display(Name = "원래 대학교 학번")]
        public String OriginUniversityStudentNo { get; set; }

        [Display(Name = "가입 학기 코드")]
        public int JoinTermCode { get; set; }

        public int LectureNo { get; set; }

        public string GradeSaved { get; set; }

        public string GradeSavedName { get; set; }

        public string BirthDay { get; set; }

        public string PartTimeYN { get; set; }

        public int? IsPass { get; set; }

        public int? PrintNum { get; set; }

        public decimal CompleteScore { get; set; }

		[Display(Name = "총 출석수")]
		public int TotalAttendance { get; set; }

        [Display(Name = "온라인 출석수")]
        public int OnlineAttendance { get; set; }

        [Display(Name = "오프라인 출석수")]
        public int OfflineAttendance { get; set; }

        [Display(Name = "총 지각수")]
		public int TotalLateness { get; set; }

		[Display(Name = "총 조퇴수")]
		public int TotalEarlyLeave { get; set; }

		[Display(Name = "총 결석수")]
		public int TotalAbsence { get; set; }

		[Display(Name = "수강 가능한 차시수")]
		public int LectureInningCount { get; set; }

		[Display(Name = "전체 차시수")]
		public int InningCount { get; set; }

		[Display(Name = "엑셀용 학습시간")]
		public int OnlineInningCount { get; set; }

		[Display(Name = "엑셀용 학습시간")]
		public int OfflineInningCount { get; set; }

		[Display(Name = "1/3 결석여부")]
		public string FailingGradeYesNo { get; set; }

        public string strHangulName { get; set; }

        public int AttendanceCount { get; set; }

        public string strQandACount { get; set; }

        public int QandAParticipationCount { get; set; }

        public int QandAParticipationCheckCount { get; set; }

        public string strDisscussionCount { get; set; }

        public int DiscussionCount { get; set; }

        public int DiscussionCheckCount { get; set; }

        
    }
}
