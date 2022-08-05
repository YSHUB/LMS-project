using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Board :Common
	{
		public Board() { }

		public Board(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "리스트번호")]
		public int Row { get; set; }

		[Display(Name = "게시글 번호(Key)")]
		public Int64 BoardNo { get; set; }

		[Display(Name = "마스터 No")]
		public Int64 MasterNo { get; set; }

		[Display(Name = "접근유저번호")]
		public int InquiryUserNo { get; set; }

		[Display(Name = "게시글 제목")]
		public string BoardTitle { get; set; }

		[Display(Name = "게시글 내용(html)")]
		public string HtmlContents { get; set; }

		[Display(Name = "게시글 내용")]
		public string Contents { get; set; }

		[Display(Name = "한글이름")]
		public string HangulName { get; set; }

		[Display(Name = "사용자 ID")]
		public string UserID { get; set; }

		[Display(Name = "공용구분")]
		public int PublicGubun { get; set; }

		[Display(Name = "게시글 내용(평문)")]
		public string BoardContents { get; set; }

		[Display(Name = "조회수")]
		public int ReadCount { get; set; }

		[Display(Name = "상단고정여부")]
		public String HighestFixYesNo { get; set; }

		[Display(Name = "이전글/다음글 구분")]
		public string ListType { get; set; }

		[Display(Name = "파일그룹번호")]
		public int? FileGroupNo { get; set; }

		[Display(Name = "게시판별 게시물번호")]
		public int Thread { get; set; }

		[Display(Name = "게시판별 게시물 깊이")]
		public int Depth { get; set; }

		[Display(Name = "비밀글 여부")]
		public int IsSecret { get; set; }

		[Display(Name = "글마감 여부")]
		public int IsFinish { get; set; }

		[Display(Name = "파일 번호")]
		public int FileNo { get; set; }

		[Display(Name = "IP주소")]
		public string IPAddress { get; set; }

		[Display(Name = "강좌번호")]
		public int CourseNo { get; set; }

		[Display(Name = "팀번호")]
		public int TeamNo { get; set; }

		[Display(Name = "익명여부")]
		public int IsAnonymous  { get; set; }

		[Display(Name = "참여도인정여부")]
		public string ParticipationAcceptYesNo { get; set; }

		[Display(Name = "교수번호")]
		public int ProfessorNo { get; set; }

		[Display(Name = "상위게시글 유저번호")]
		public int ParentUserNo { get; set; }

		[Display(Name = "답글 수")]
		public int ReplyCount { get; set; }

		[Display(Name = "신규컨텐츠 여부")]
		public string IsNewContents { get; set; }

		[Display(Name = "하위 답글 유무")]
		public string AnswerYesNo { get; set; }

		[Display(Name = "좋아요 수")]
		public int LikeCount { get; set; }

		[Display(Name = "궁금해요 수")]
		public int WonderCount { get; set; }

	}
}
