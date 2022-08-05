using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class GroupTeamMember : GroupTeam
	{
		public GroupTeamMember() { }

		[Display(Name = "팀멤버 번호")]
		public Int64 TeamMemberNo { get; set; }

		[Display(Name = "팀멤버 사용자 번호")]
		public Int64 TeamMemberUserNo { get; set; }

		[Display(Name = "팀 리더 Y/N")]
		public string TeamLeaderYesNo{ get; set; }

		[Display(Name = "학생 학번")]
		public string UserID { get; set; }

		[Display(Name = "학생 성별")]
		public string SexGubun { get; set; }

		[Display(Name = "학년")]
		public string GradeName { get; set; }

		[Display(Name = "학적")]
		public string HakjeokGubunName { get; set; }

		[Display(Name = "구분")]
		public string GeneralUserCode { get; set; }

		[Display(Name = "생년월일")]
		public string ResidentNo { get; set; }


		[Display(Name = "새 그룹 번호")]
		public Int64 NewGroupNo { get; set; }

	}
}
