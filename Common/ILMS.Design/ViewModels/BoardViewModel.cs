using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using ILMS.Design.Domain;

namespace ILMS.Design.ViewModels
{
	//게시판 관련 페이지
	public class BoardViewModel : BaseViewModel
	{
		[Display(Name = "게시물")]
		public Board Board { get; set; }

		[Display(Name = "게시판 리스트")]
		public IList<Board> BoardList { get; set; }

		[Display(Name = "게시판 마스터 리스트")]
		public IList<BoardMaster> BoardMasterList { get; set; }

		[Display(Name = "공지 리스트")]
		public IList<Board> HighestFixList { get; set; }

		[Display(Name = "이전글/다음글")]
		public IList<Board> PrevNextList { get; set; }

		[Display(Name = "검색유형")]
		public string SearchType { get; set; }

		[Display(Name = "마스터번호")]
		public int MasterNo { get; set; }

		[Display(Name = "공용구분")]
		public int? PublicGubun { get; set; }

		[Display(Name = "강좌번호")]
		public int? CourseNo { get; set; }

		[Display(Name = "마스터정보")]
		public BoardMaster BoardMaster { get; set; }

		[Display(Name = "팀번호")]
		public int TeamNo { get; set; }

		[Display(Name = "파일그룹번호")]
		public int FileGroupNo { get; set; }

		[Display(Name = "게시물 답변 리스트")]
		public IList<BoardReply> BoardContentReplyList { get; set; }

		[Display(Name = "한줄의견 내용")]
		public string ReplyContent { get; set; }

		[Display(Name = "게시판 이벤트")]
		public BoardEvent BoardEvent { get; set; }

		[Display(Name = "게시물 총 댓글 카운트")]
		public int BoardReplyCount { get; set; }

		[Display(Name = "상위 게시물 번호")]
		public int ParentBoardNo { get; set; }

		[Display(Name = "공지 숨기기")]
		public string HighFixHide { get; set; }

		[Display(Name = "파일성공여부")]
		public int FileSuccess { get; set; }

		[Display(Name = "교수여부")]
		public int IsProf { get; set; }

		[Display(Name = "사용자 권한그룹 리스트")]
		public IList<BoardAuthority> BoardAuthorityList { get; set; }

		[Display(Name = "사용자 권한")]
		public BoardAuthority BoardAuthority { get; set; }

		[Display(Name = "게시판명")]
		public string BoardTitle { get; set; }
	}
}
