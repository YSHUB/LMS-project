using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
    public class Homework : Inning
	{
		public Homework() { }

		public Homework(string rowState)
		{
			RowState = rowState;
		}

        [Display(Name = "과제 종류")]
        public String HomeworkKind { get; set; }

		[Display(Name = "과제 종류명")]
		public String HomeworkKindName { get; set; }

		[Display(Name = "과제 유형")]
        public String HomeworkTypeName { get; set; }

        [Display(Name = "제출 방법")]
        public String SubmitTypeName { get; set; }

		[Display(Name = "제출 시작일자")]
		public String SubmitStartDay { get; set; }

		[Display(Name = "제출 종료일자")]
		public String SubmitEndDay { get; set; }

		[Display(Name = "추가 제출 시작일자")]
		public String AddSubmitStartDay { get; set; }

		[Display(Name = "추가 제출 종료일자")]
		public String AddSubmitEndDay { get; set; }

        [Display(Name = "공개 여부")]
		public String OpenYesNo { get; set; }

		[Display(Name = "과제 제목")]
		public String HomeworkTitle { get; set; }

		[Display(Name = "과제 내용")]
		public String HomeworkContents { get; set; }

		[Display(Name = "제출 인원")]
		public int SubmitCnt { get; set; }

		[Display(Name = "평가 완료 인원")]
		public int SubmitScoreCnt { get; set; }

		[Display(Name = "과제 제출 대상 학생수")]
		public int StudentCnt { get; set; }

		[Display(Name = "파일번호")]
		public int? FileNo { get; set; }

		[Display(Name = "시험종류")]
        public String ExamKind { get; set; }

        [Display(Name = "학생아이디(스플릿용)")]
        public String UserNoString { get; set; }

		[Display(Name = "가중치")]
		public int Weighting { get; set; }

		[Display(Name = "평가공개여부")]
		public String EstimationOpenYesNo { get; set; }

		[Display(Name = "산출물")]
		public int IsOutput { get; set; }

		[Display(Name = "대상학생리스트(스플릿용)")]
		public String MemberYesList { get; set; }

		[Display(Name = "미대상학생리스트(스플릿용)")]
		public String MemberNoList { get; set; }

		[Display(Name = "그룹번호")]
		public int GroupNo { get; set; }

		[Display(Name = "그룹 이름")]
		public string GroupName { get; set; }

		[Display(Name = "강좌 그룹 번호")]
		public int CourseGroupNo { get; set; }

		[Display(Name = "기존그룹번호")]
		public int OrgGroupNo { get; set; }

		[Display(Name = "팀번호")]
		public int TeamNo { get; set; }

		[Display(Name = "팀번호")]
		public int NewTeamNo { get; set; }

		[Display(Name = "추가제출기간사용여부")]
		public string AddSubmitPeriodUseYesNo { get; set; }

		[Display(Name = "제출타입")]
		public string SubmitType { get; set; }

		[Display(Name = "제출파일그룹번호")]
		public int SubmitFilleGroupNo { get; set; }

		[Display(Name = "기존과제번호")]
		public int OrgHomeworkNo { get; set; }

		[Display(Name = "제출내용")]
		public string SubmitContents { get; set; }

		[Display(Name = "팀장제출내용")]
		public string LeaderContents { get; set; }

		[Display(Name = "점수")]
		public decimal? Score { get; set; }

		[Display(Name = "과제출제갯수")]
		public int HomeworkCount { get; set; }

	}
}
