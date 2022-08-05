using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class DiscussionGroup : DiscussionOpinion
	{
		public DiscussionGroup() { }

		public DiscussionGroup(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "한 그룹 당 팀 갯수")]
		public int TeamCnt { get; set; }

		[Display(Name = "팀 멤버 연번")]
		public Int64 TeamMemberNo { get; set; }

		[Display(Name = "팀 멤버 번호")]
		public Int64 TeamMemberUserNo { get; set; }

		[Display(Name = "팀 멤버 리더 여부 Y/N")]
		public string TeamLeaderYesNo { get; set; }

		[Display(Name = "학년")]
		public string GradeName { get; set; }

		[Display(Name = "로그인 유저가 팀의 멤버인지 확인여부")]
		public string IsMember { get; set; }

		[Display(Name = "구분")]
		public string GeneralUserCode { get; set; }

		[Display(Name = "생년월일")]
		public string ResidentNo { get; set; }
	}
}
