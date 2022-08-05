using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using ILMS.Design.Domain;
namespace ILMS.Design.ViewModels
{
	//팀 편성 관련 뷰모델
	public class TeamViewModel : BaseViewModel
	{
		[Display(Name = "강좌 그룹")]
		public Group Group { get; set; }

		[Display(Name = "강좌 그룹 리스트")]
		public IList<Group> GroupList { get; set; }

		[Display(Name = "강좌 팀")]
		public GroupTeam GroupTeam { get; set; }

		[Display(Name = "강좌 팀 리스트")]
		public IList<GroupTeam> GroupTeamList { get; set; }

		[Display(Name = "강좌 팀 멤버 리스트")]
		public IList<GroupTeamMember> GroupTeamMemberList { get; set; }

		[Display(Name = "강좌 팀 미배정 멤버 리스트")]
		public IList<GroupTeamMember> GroupTeamNotMemberList { get; set; }

		[Display(Name = "강좌 수강 학생 리스트")]
		public IList<CourseLecture> CourseLectureStudentList { get; set; }

		[Display(Name = "파일리스트 정보 ")]
		public List<File> newFileList { get; set; }

		[Display(Name = "그룹 번호")]
		public int GroupNo { get; set; }

	}
}
