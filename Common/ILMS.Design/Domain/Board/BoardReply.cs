using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class BoardReply : Common
	{
		public BoardReply() { }

		public BoardReply(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "답글 No")]
		public int ReplyNo { get; set; }

		[Display(Name = "내용")]
		public string Contents { get; set; }

		[Display(Name = "게시물 번호")]
		public long BoardNo { get; set; }

		[Display(Name = "메뉴코드")]
		public string MenuCode { get; set; }

		[Display(Name = "참여도 인정 여부")]
		public string ParticipationAcceptYesNo { get; set; }

		[Display(Name = "답변 채택 여부")]
		public string AnswerYesNo { get; set; }

		[Display(Name = "답변작성자")]
		public string UserName { get; set; }
	}
}
