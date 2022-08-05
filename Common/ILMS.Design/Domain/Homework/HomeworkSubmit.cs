using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
    public class HomeworkSubmit : Homework
    {

        public HomeworkSubmit() { }

        public HomeworkSubmit(string rowState)
        {
            RowState = rowState;
        }

        [Display(Name = "제출번호")]
        public Int64 SubmitNo { get; set; }

        [Display(Name = "제출사용자번호")]
        public Int64 SubmitUserNo { get; set; }

        [Display(Name = "모사율")]
        public String MosaRate { get; set; }

        [Display(Name = "과제참여가능여부")]
        public String TargetYesNo { get; set; }

        [Display(Name = "피드백")]
        public String Feedback { get; set; }

        [Display(Name = "추천")]
        public int IsGood { get; set; }

        [Display(Name = "팀명")]
        public string TeamName { get; set; }

        [Display(Name = "팀장여부")]
        public string TeamLeaderYesNo { get; set; }

        [Display(Name = "팀장제출파일그룹번호")]
        public int? LeaderFileGroupNo { get; set; }

        [Display(Name = "시험")]
        public string ExamItem { get; set; }

		[Display(Name = "임시")]
		public string UserID { get; set; }

        [Display(Name = "임시")]
        public string HakjeokGubunName { get; set; }

		[Display(Name = "임시")]
		public string Grade { get; set; }

		[Display(Name = "임시")]
		public string GeneralUserCode { get; set; }

		[Display(Name = "임시")]
		public string ResidentNo { get; set; }
		
		[Display(Name = "제출일")]
        public string UpdateDateTimeFormat { get; set; }

        [Display(Name = "제출시간")]
        public string UpdateTime { get; set; }

    }
}
