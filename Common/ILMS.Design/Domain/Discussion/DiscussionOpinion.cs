using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class DiscussionOpinion : Discussion
	{
		public DiscussionOpinion() { }

		public DiscussionOpinion(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "의견 번호")]
		public Int64 OpinionNo { get; set; }

		[Display(Name = "의견 제목")]
		public String OpinionTitle { get; set; }

		[Display(Name = "의견 내용")]
		public String OpinionContents { get; set; }

		[Display(Name = "의견 조회 수")]
		public int ReadCount { get; set; }

		[Display(Name = "참여도 인정 여부")]
		public String ParticipationYesNo { get; set; }

		[Display(Name = "공지사항 등록 여부")]
		public String TopOpinionYesNo { get; set; }

		[Display(Name = "의견 작성자 번호")]
		public Int64 OpinionUserNo { get; set; }

		[Display(Name = "팀 번호")]
		public Int64 TeamNo { get; set; }

		[Display(Name = "팀 명")]
		public String TeamName { get; set; }

		[Display(Name = "등록된 댓글수")]
		public int ReplyCount { get; set; }

		[Display(Name = "해당 의견 찬성 수")]
		public int YesCount { get; set; }

		[Display(Name = "해당 의견 반대 수")]
		public int NoCount { get; set; }

		[Display(Name = "좋아요/싫어요를 누른 유저가 로그인 유저와 동일한지 확인하는 변수")]
		public int IsUserYesNo { get; set; }

		[Display(Name = "좋아요/싫어요 코드(Y/N)")]
		public string YesNoCode { get; set; }

		[Display(Name = "작성자 ID")]
		public String UserID { get; set; }

		[Display(Name = "참여도 인정 글 수")]
		public int ParticipationCount { get; set; }

		[Display(Name = "참여도 인정 점수")]
		public int ParticipationRateScore { get; set; }

		[Display(Name = "이전글/다음글 구분")]
		public string ListType { get; set; }

		[Display(Name = "학적")]
		public string HakjeokGubunName { get; set; }

	}
}
