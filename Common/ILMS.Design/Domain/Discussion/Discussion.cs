using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Discussion : Inning
	{
		public Discussion() { }

		public Discussion(string rowState)
		{
			RowState = rowState;
		}

		public Discussion(int courseNo, Int64? discussionNo)
		{
			CourseNo = courseNo;
			DiscussionNo = discussionNo ?? 0;
		}

		[Display(Name = "토론 번호")]
		public Int64 DiscussionNo { get; set; }

		[Display(Name = "토론 그룹 번호")]
		public Int64 GroupNo { get; set; }

		[Display(Name = "토론 그룹 이름")]
		public string GroupName { get; set; }

		[Display(Name = "강좌 그룹 번호")]
		public int CourseGroupNo { get; set; }

		[Display(Name = "토론속성(CDAB001/CDAB002)")]
		public string DiscussionAttribute { get; set; }

		[Display(Name = "토론속성명(개별/조별)")]
		public string DiscussionAttributeName { get; set; }

		[Display(Name = "토론 공개여부(Y/N)")]
		public string OpenYesNo { get; set; }

		[Display(Name = "토론 시작일자")]
		public String DiscussionStartDay { get; set; }

		[Display(Name = "토론 종료일자")]
		public String DiscussionEndDay { get; set; }

		[Display(Name = "토론 주제")]
		public string DiscussionSubject { get; set; }

		[Display(Name = "토론 개요")]
		public string DiscussionSummary { get; set; }

		[Display(Name = "등록된 의견 수(참여글수)")]
		public int OpinionCount { get; set; }

		[Display(Name = "등록된 의견 작성자수(참여자수)")]
		public int OpinionUserCount { get; set; }

		[Display(Name = "토론 진행상황 (진행예정/ 진행중/ 종료)")]
		public String DiscussionSituation { get; set; }

		[Display(Name = "강좌 그룹 번호(수정용)")]
		public int UpdateCourseGroupNo { get; set; }

		[Display(Name = "토론 등록 수")]
		public int DiscuccionCnt { get; set; }

	}
}
