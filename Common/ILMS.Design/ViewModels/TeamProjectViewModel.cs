using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using ILMS.Design.Domain;
namespace ILMS.Design.ViewModels
{
	// 수업활동일지, 팀 프로젝트 관련 뷰모델
	public class TeamProjectViewModel : BaseViewModel
	{

		[Display(Name = "팀 프로젝트 리스트")]
		public IList<TeamProject> TeamProjectList { get; set; }

		[Display(Name = "팀 프로젝트")]
		public TeamProject TeamProject { get; set; }

		[Display(Name = "팀 프로젝트 제출 과제 리스트")]
		public IList<TeamProjectSubmit> TeamProjectSubmitList { get; set; }

		[Display(Name = "팀 프로젝트 제출 과제")]
		public TeamProjectSubmit TeamProjectSubmit { get; set; }

		[Display(Name = "팀 프로젝트 팀")]
		public TeamProject TeamProjectTeam { get; set; }

		[Display(Name = "팀 프로젝트 팀 리스트")]
		public IList<TeamProject> TeamProjectTeamList { get; set; }

		[Display(Name = "팀 프로젝트 팀원 리스트")]
		public IList<TeamProject> TeamProjectTeamMemberList { get; set; }

		[Display(Name = "강좌 그룹 리스트")]
		public IList<Group> GroupList { get; set; }

		[Display(Name = "산출물여부")]
		public int IsOutput { get; set; }

		[Display(Name = "정렬타입(학번순/성명순)")]
		public string SortType { get; set; }

		[Display(Name = "파일그룹번호")]
		public int FileGroupNo { get; set; }

		[Display(Name = "프로그램 리스트")]
		public IList<TeamProject> ProgramList { get; set; }

		[Display(Name = "학기 리스트")]
		public IList<Term> TermList { get; set; }

		[Display(Name = "강의")]
		public Course Course { get; set; }

	}
}
