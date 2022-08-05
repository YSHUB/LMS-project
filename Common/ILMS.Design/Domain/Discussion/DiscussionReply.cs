using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class DiscussionReply : DiscussionOpinion
	{
		public DiscussionReply() { }

		public DiscussionReply(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "댓글 번호")]
		public Int32 ReplyNo { get; set; }

		[Display(Name = "댓글 작성자 번호")]
		public Int32 ReplyUserNo { get; set; }

		[Display(Name = "댓글 내용")]
		public String ReplyContents { get; set; }

		[Display(Name = "수정용 댓글 내용")]
		public String ReplyUpdateContents { get; set; }
	}
}
