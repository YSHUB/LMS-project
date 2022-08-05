using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Grade : CourseLecture
	{
		public Grade() { }

		public Grade(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "성적번호")]
		public int GradeNo { get; set; }

		[Display(Name = "성적텍스트")]
		public string GradeText { get; set; }

		[Display(Name = "중간고사 만점")]
		public decimal MidtermExamPerfectScore { get; set; }

		[Display(Name = "중간고사 원점수")]
		public decimal MidtermExamScore { get; set; }

       [Display(Name = "중간고사 환산점수")]
        public decimal MidtermExam { get; set; }

		[Display(Name = "기말고사 만점")]
		public decimal FinalExamPerfectScore { get; set; }

		[Display(Name = "기말고사 원점수")]
		public decimal FinalExamScore { get; set; }

		[Display(Name = "기말고사 환산점수")]
		public decimal FinalExam { get; set; }

		[Display(Name = "출결 만점점수")]
		public decimal AttendancePerfectScore { get; set; }

		[Display(Name = "출결 원점수")]
		public decimal AttendanceScore { get; set; }

		[Display(Name = "출결 환산점수")]
		public decimal Attendance { get; set; }

		[Display(Name = "출결 만점점수")]
		public decimal HomeWorkPerfectScore { get; set; }

		[Display(Name = "과제 원점수")]
		public decimal HomeWorkScore { get; set; }

		[Display(Name = "과제 환산점수")]
		public decimal HomeWork { get; set; }

		[Display(Name = "퀴즈 만점점수")]
		public decimal QuizPerfectScore { get; set; }

		[Display(Name = "출결 원점수")]
		public decimal QuizScore { get; set; }

		[Display(Name = "퀴즈 환산점수")]
		public decimal Quiz { get; set; }

		[Display(Name = "팀프로젝트 만점점수")]
		public decimal TeamProjectPerfectScore { get; set; }

		[Display(Name = "팀프로젝트 원점수")]
		public decimal TeamProjectScore { get; set; }

		[Display(Name = "팀프로젝트 환산점수")]
		public decimal TeamProject { get; set; }

		[Display(Name = "기타 만점점수")]
		public decimal EtcPerfectScore { get; set; }
        public decimal Etc2PerfectScore { get; set; }
        public decimal Etc3PerfectScore { get; set; }

		[Display(Name = "발표 만점점수")]
		public decimal AnnouncePerfectScore { get; set; }

		[Display(Name = "역량 만점점수")]
		public decimal AbilityPerfectScore { get; set; }
        public decimal Ability2PerfectScore { get; set; }
        public decimal Ability3PerfectScore { get; set; }

		[Display(Name = "기타 원점수")]
		public decimal EtcScore { get; set; }
        public decimal Etc2Score { get; set; }
        public decimal Etc3Score { get; set; }

		[Display(Name = "발표 만점점수")]
		public decimal AnnounceScore { get; set; }

		[Display(Name = "역량 만점점수")]
		public decimal AbilityScore { get; set; }
        public decimal Ability2Score { get; set; }
        public decimal Ability3Score { get; set; }

		[Display(Name = "기타 일괄점수")]
		public decimal BatchScore { get; set; }


		[Display(Name = "기타 환산점수")]
		public decimal Etc { get; set; }
        public decimal Etc2 { get; set; }
        public decimal Etc3 { get; set; }

		[Display(Name = "발표 환산점수")]
		public decimal Announce { get; set; }

		[Display(Name = "역량 환산점수")]
		public decimal Ability { get; set; }
        public decimal Ability2 { get; set; }
        public decimal Ability3 { get; set; }

		[Display(Name = "QnA 갯수")]
		public int QnaCount { get; set; }

		[Display(Name = "QnA 만점점수")]
		public decimal QnaPerfectScore { get; set; }

		[Display(Name = "QnA 원점수")]
		public decimal QnaScore { get; set; }

		[Display(Name = "QnA 환산점수")]
		public decimal Qna { get; set; }

		[Display(Name = "자료실 갯수")]
		public int ReferenceRoomCount { get; set; }

		[Display(Name = "자료실 만점점수")]
		public decimal ReferenceRoomPerfectScore { get; set; }

		[Display(Name = "자료실 원점수")]
		public decimal ReferenceRoomScore { get; set; }

		[Display(Name = "자료실 환산점수")]
		public decimal ReferenceRoom { get; set; }


		[Display(Name = "토론 갯수")]
		public int DiscussionCount { get; set; }

		[Display(Name = "토론 만점점수")]
		public decimal DiscussionPerfectScore { get; set; }

		[Display(Name = "토론 원점수")]
		public decimal DiscussionScore { get; set; }

		[Display(Name = "토론 환산점수")]
		public decimal Discussion { get; set; }

		[Display(Name = "자유게시판 갯수")]
		public int FreeBoardCount { get; set; }

		[Display(Name = "자유게시판 만점점수")]
		public decimal FreeBoardPerfectScore { get; set; }

		[Display(Name = "자유게시판 원점수")]
		public decimal FreeBoardScore { get; set; }

		[Display(Name = "자유게시판 환산점수")]
		public decimal FreeBoard { get; set; }

		[Display(Name = "소개게시판 갯수")]
		public int IntroduceBoardCount { get; set; }

		[Display(Name = "소개게시판 만점점수")]
		public decimal IntroduceBoardPerfectScore { get; set; }

		[Display(Name = "소개게시판 원점수")]
		public decimal IntroduceBoardScore { get; set; }

		[Display(Name = "소개게시판 환산점수")]
		public decimal IntroduceBoard { get; set; }

		[Display(Name = "오프라인 참여횟수")]
		public int OfflineCount { get; set; }

		[Display(Name = "오프라인 만점점수")]
		public decimal OfflinePerfectScore { get; set; }

		[Display(Name = "오프라인 원점수")]
		public decimal OfflineScore { get; set; }

		[Display(Name = "오프라인 환산점수")]
		public decimal Offline { get; set; }

		[Display(Name = "참여도 만점점수")]
		public decimal ParticipationPerfectScore { get; set; }

		[Display(Name = "참여도 원점수")]
		public decimal ParticipationScore { get; set; }

		[Display(Name = "참여도 환산점수")]
		public decimal Participation { get; set; }

		[Display(Name = "수료점수")]
		public decimal CompleteScore { get; set; }

		[Display(Name = "백분율")]
		public decimal Percentage { get; set; }

		[Display(Name = "저장된 등급")]
		public string GradeSaved { get; set; }

		[Display(Name = "저장된 등급 이름")]
		public string GradeSavedName { get; set; }

		[Display(Name = "1/3 결석여부")]
		public string FailingGradeYesNo { get; set; }

		[Display(Name = "평가 방법")]
		public string EstimationType { get; set; }

		[Display(Name = "생일")] //TODO 사용 용도 파악
		public string BirthDay { get; set; }

		[Serializable] //절대평가 등급 범례
		public class EstimationABSStandard
		{
			public int StartP { get; set; }
			public int EndP { get; set; }
			public string Grade { get; set; }
		}

		[Display(Name = "외국인 여부")]
		public String ForeignYesNo { get; set; }
	}
}
