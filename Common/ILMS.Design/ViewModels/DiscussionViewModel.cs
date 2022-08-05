using ILMS.Design.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Routing;

namespace ILMS.Design.ViewModels
{
	//토론 관련 페이지
	public class DiscussionViewModel : BaseViewModel
	{
		[Display(Name = "토론 리스트")]
		public IList<Discussion> DiscussionList { get; set; }

		[Display(Name = "토론")]
		public Discussion Discussion { get; set; }

		[Display(Name = "토론 의견 리스트")]
		public IList<DiscussionOpinion> DiscussionOpinionList { get; set; }

		[Display(Name = "토론 의견")]
		public DiscussionOpinion DiscussionOpinion { get; set; }

		[Display(Name = "이전글/다음글")]
		public IList<DiscussionOpinion> PrevNextList { get; set; }

		[Display(Name = "토론 한 줄 의견")]
		public DiscussionReply DiscussionReply { get; set; }

		[Display(Name = "토론 한 줄 의견 리스트")]
		public IList<DiscussionReply> DiscussionReplyList { get; set; }

		[Display(Name = "토론 그룹 리스트")]
		public IList<DiscussionGroup> DiscussionGroupList { get; set; }

		[Display(Name = "토론 그룹")]
		public DiscussionGroup DiscussionGroup { get; set; }

		[Display(Name = "강좌 그룹 리스트")]
		public IList<Group> GroupList { get; set; }

		[Display(Name = "팀 번호")]
		public Int64 TeamNo { get; set; }

		[Display(Name = "파일그룹번호")]
		public int FileGroupNo { get; set; }

		[Display(Name = "프로그램 리스트")]
		public IList<Discussion> ProgramList { get; set; }

		[Display(Name = "학기 리스트")]
		public IList<Term> TermList { get; set; }

		[Display(Name = "강의")]
		public Course Course { get; set; }

		[Display(Name = "정렬타입")]
		public string SortType { get; set; }
	}
}
