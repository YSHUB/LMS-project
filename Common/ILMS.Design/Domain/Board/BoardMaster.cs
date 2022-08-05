using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class BoardMaster :Common
	{
		public BoardMaster() { }

		public BoardMaster(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "마스터 No")]
		public int MasterNo { get; set; }

		[Display(Name = "게시판 ID")]
		public string BoardID { get; set; }

		[Display(Name = "게시판 타이틀")]
		public string BoardTitle { get; set; }

		[Display(Name = "로그인 사용자만 접근가능")]
		public string IsMember { get; set; }

		[Display(Name = "그룹유무")]
		public string IsGroup { get; set; }

		[Display(Name = "참여도인정 사용여부")]
		public string BoardIsUseAcceptYesNo { get; set; }

		[Display(Name = "파일 사용여부")]
		public string BoardIsUseFileYesNo { get; set; }

		[Display(Name = "한줄댓글 사용여부")]
		public string BoardIsUseReplyYesNo { get; set; }

		[Display(Name = "비밀글 사용여부")]
		public string BoardIsSecretYesNo { get; set; }

		[Display(Name = "읽음 표시 여부")]
		public string IsRead { get; set; }

		[Display(Name = "게시판쓰기권한")]
		public int NoticeWriteLevel { get; set; }

		[Display(Name = "익명 사용 여부")]
		public string IsAnonymous { get; set; }

		[Display(Name = "쓰기 권한")]
		public int AnswerLevel { get; set; }

		[Display(Name = "좋아요/궁금해요 사용여부")]
		public string IsEvent { get; set; }

		[Display(Name = "공지 사용 여부")]
		public string IsNotice { get; set; }
	}
}
