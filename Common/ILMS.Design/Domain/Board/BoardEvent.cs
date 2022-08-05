using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class BoardEvent : Common
	{
		public BoardEvent() { }

		public BoardEvent(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "게시물 번호")]
		public int BoardNo { get; set; }

		[Display(Name = "이벤트 코드")]
		public string EventCode { get; set; }

		[Display(Name = "좋아요 수")]
		public int LikeCount { get; set; }

		[Display(Name = "궁금해요 수")]
		public int WonderCount { get; set; }

		[Display(Name = "현재 유저 좋아요 수")]
		public int LikeParticipationFlag { get; set; }

		[Display(Name = "현재 유저 궁금해요 수")]
		public int WonderParticipationFlag { get; set; }
	}
}
