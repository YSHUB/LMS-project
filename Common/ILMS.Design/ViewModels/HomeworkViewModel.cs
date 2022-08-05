using ILMS.Design.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.ViewModels
{
	//과제 관련 페이지
    public class HomeworkViewModel : BaseViewModel
    {
		[Display(Name = "에러메세지")]
		public string ErrorMessage { get; set; }

		[Display(Name = "과제")]
		public Homework Homework { get; set; }

        [Display(Name = "과제 제출")]
        public HomeworkSubmit HomeworkSubmit { get; set; }

		[Display(Name = "과제 리스트")]
		public IList<Homework> HomeworkList { get; set; }

		[Display(Name = "과제 제출 리스트")]
		public IList<HomeworkSubmit> HomeworkSubmitList { get; set; }

		[Display(Name = "산출물")]
		public Output Output { get; set; }

		[Display(Name = "산출물 리스트")]
		public IList<Output> OutputList { get; set; }

		[Display(Name = "과제 제출 리스트")]
        public IList<Inning> WeekList { get; set; }

        [Display(Name = "과제 제출 리스트")]
        public IList<Inning> InningList { get; set; }

		[Display(Name = "학기 리스트")]
		public IList<Term> TermList { get; set; }

		[Display(Name = "강좌 그룹")]
		public Group Group { get; set; }

		[Display(Name = "강좌 그룹 리스트")]
		public IList<Group> GroupList { get; set; }

		[Display(Name = "자격증 리스트")]
		public IList<License> LicenseList { get; set; }

		[Display(Name = "자격증")]
		public License License { get; set; }

		[Display(Name = "강좌")]
		public Course Course { get; set; }

		[Display(Name = "강좌번호")]
		public int CourseNo { get; set; }

        [Display(Name = "산출물여부")]
        public int IsOutput { get; set; }

        [Display(Name = "과제유형")]
        public string HomeworkType { get; set; }

        [Display(Name = "시험종류")]
        public string ExamKind { get; set; }

		[Display(Name = "과제 첨부파일 리스트")]
		public IList<File> HomeworkfileList { get; set; }

		[Display(Name = "프로그램 리스트")]
		public IList<Homework> ProgramList { get; set; }

		[Display(Name = "정렬 타입")]
		public string SortType { get; set; }

		[Display(Name = "현재 탭")]
		public string Present { get; set; }

		[Display(Name = "저장하고 이전 학생")]
		public int PrevUserNo { get; set; }

		[Display(Name = "저장하고 다음 학생")]
		public int NextUserNo { get; set; }

		[Display(Name = "과제 제출 및 평가 구분용")]
		public int RefreshUserNo { get; set; }

		[Display(Name = "학기 번호")]
		public int TermNo { get; set; }

		[Display(Name = "파일 그룹 번호")]
		public int FileGroupNo { get; set; }

		[Display(Name = "팀이름")]
		public string TeamName { get; set; }

		[Display(Name = "제출여부")]
		public bool SubmitYesNo { get; set; }

	}
}
