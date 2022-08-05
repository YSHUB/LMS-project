using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class CourseLecture : Course
	{
		public CourseLecture() { }

		public CourseLecture(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "수강번호")]
		public int LectureNo { get; set; }

		[Display(Name = "수강상태")]
		public string LectureStatus { get; set; }

		[Display(Name = "수강상태명")]
		public string LectureStatusName { get; set; }

		[Display(Name = "기타 점수")]
		public int Point { get; set; }

		[Display(Name = "기타 점수 타입")]
		public string PointType { get; set; }

		[Display(Name = "Q&A게시판 성적반영여부")]
		public string IsUseParticipationQandA { get; set; }

		[Display(Name = "Q&A게시판 게시글 점수")]
		public int QandAParticipationCheckCount { get; set; }

		[Display(Name = "PDS 성적반영여부")]
		public string IsUseParticipationPDS { get; set; }

		[Display(Name = "PDS 게시글 점수")]
		public int PDSParticipationCheckCount { get; set; }

		[Display(Name = "토론 성적반영여부")]
		public string IsUseDisscussion { get; set; }

		[Display(Name = "토론 게시글 점수")]
		public int DiscussionCheckCount { get; set; }

		[Display(Name = "자유게시판 성적반영여부")]
		public string IsUseParticipationFreeBoard { get; set; }

		[Display(Name = "자유게시판 게시글 점수")]
		public int FreeBoardParticipationCheckCount { get; set; }

		[Display(Name = "상담게시판 성적반영여부")]
		public string IsUseParticipationIntroduceBoard { get; set; }

		[Display(Name = "상담게시판 게시글 점수")]
		public int IntroduceBoardParticipationCheckCount { get; set; }

		[Display(Name = "수강 학생 학년")]
		public string GradeName { get; set; }

		[Display(Name = "수강 학생 성별")]
		public string SexGubun { get; set; }

		[Display(Name = "수강 학생 학번")]
		public string UserID { get; set; }

		[Display(Name = "수료증 출력 일자")]
		public string PrintDay { get; set; }

		[Display(Name = "수료증 출력번호")]
		public int? PrintNum { get; set; }

		[Display(Name = "수료증 등록번호")]
		public string ResidentNo { get; set; }

		[Display(Name = "수강 시작 일자")]
		public string StartDay { get; set; }

		[Display(Name = "수강 종료 일자")]
		public string EndDay { get; set; }

		[Display(Name = "학적 구분")]
		public string HakjeokGubunName { get; set; }

		[Display(Name = "수강 인원 수")]
		public int LectureCount { get; set; }

		[Display(Name = "수강 회원 구분")]
		public string GeneralUserName { get; set; }

		[Display(Name = "수강신청일")]
		public string LectureRequestDay { get; set; }

		[Display(Name = "승인 구분")]
		public String ApprovalGubun { get; set; }

	}
}
