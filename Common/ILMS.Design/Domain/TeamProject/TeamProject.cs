using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class TeamProject : Inning
	{
		public TeamProject() { }

		public TeamProject(string rowState)
		{
			RowState = rowState;
		}
		public TeamProject(int courseNo, Int64? projectNo)
		{
			CourseNo = courseNo;
			ProjectNo = projectNo ?? 0;
		}

		[Display(Name = "프로젝트 번호")]
		public Int64 ProjectNo { get; set; }

		[Display(Name = "프로젝트 그룹 번호")]
		public Int64 GroupNo { get; set; }

		[Display(Name = "프로젝트 시작일자")]
		public String SubmitStartDay { get; set; }

		[Display(Name = "프로젝트 종료일자")]
		public String SubmitEndDay { get; set; }

		[Display(Name = "프로젝트 주제")]
		public string ProjectTitle { get; set; }

		[Display(Name = "프로젝트 내용")]
		public string ProjectContents { get; set; }

		[Display(Name = "제출방식 팀장제출 여부 Y/N")]
		public string LeaderYesNo { get; set; }

		[Display(Name = "평가 공개 유무 (공개/비공개)")]
		public string EstimationOpenYesNo { get; set; }

		[Display(Name = "산출물")]
		public int IsOutput { get; set; }

		[Display(Name = "제출구분(0 계획서/1 결과보고서/2 주간보고서/3 회의록/4 발표자료)")]
		public int SubmitType { get; set; }
		
		[Display(Name = "제출 수")]
		public int SubmitCount { get; set; }

		[Display(Name = "평가 인원 수")]
		public int FeedbackCount { get; set; }

		[Display(Name = "프로젝트 진행상황 (진행예정/ 진행중/ 종료)")]
		public string ProjectSituation { get; set; }

		[Display(Name = "팀 번호")]
		public Int64 TeamNo { get; set; }

		[Display(Name = "팀 이름")]
		public string TeamName { get; set; }

		[Display(Name = "팀 리더 여부")]
		public string TeamLeaderYesNo { get; set; }

		[Display(Name = "학생 이름")]
		public string HanguelName { get; set; }

		[Display(Name = "학생 학번")]
		public string UserID { get; set; }

		[Display(Name = "학생 성별")]
		public string SexGubun { get; set; }

		[Display(Name = "팀멤버 번호")]
		public string TeamMemberUserNo { get; set; }

		[Display(Name = "팀 멤버 수")]
		public int MemberCnt { get; set; }

		[Display(Name = "그룹 이름")]
		public string GroupName { get; set; }

		[Display(Name = "강좌 그룹 번호")]
		public int CourseGroupNo { get; set; }

		[Display(Name = "점수")]
		public int Score { get; set; }

		[Display(Name = "리더의 팀프로젝트 제출여부")]
		public string IsLeaderSubmit { get; set; }

		[Display(Name = "팀프로젝트 제출 시작시(HH)")]
		public string SubmitStartHour { get; set; }

		[Display(Name = "팀프로젝트 제출 시작분(mm)")]
		public string SubmitStartMin { get; set; }

		[Display(Name = "팀프로젝트 제출 종료시(HH)")]
		public string SubmitEndHour { get; set; }

		[Display(Name = "팀프로젝트 제출 종료분(mm)")]
		public string SubmitEndMin { get; set; }

		[Display(Name = "제출구분 이름(계획서/결과보고서/주간보고서/회의록/발표자료)")]
		public string SubmitTypeName { get; set; }

		[Display(Name = "강좌 그룹 번호(수정용)")]
		public int UpdateCourseGroupNo { get; set; }

		[Display(Name = "팀프로젝트 등록 수")]
		public int TeamProjectCnt { get; set; }

	}
}
