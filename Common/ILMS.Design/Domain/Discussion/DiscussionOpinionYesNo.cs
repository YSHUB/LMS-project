using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class DiscussionOpinionYesNo : DiscussionOpinion
	{
		public DiscussionOpinionYesNo() { }

		public DiscussionOpinionYesNo(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "좋아요/싫어요 연번")]
		public Int64 YesNoNo { get; set; }

		[Display(Name = "좋아요/싫어요 등록자 연번")]
		public string YesNoUserNo { get; set; }

	}
}
