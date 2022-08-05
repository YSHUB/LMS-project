using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
    public class TeamProjectSubmit : TeamProject
    {

        public TeamProjectSubmit() { }

        public TeamProjectSubmit(int courseNo, Int64? projectNo)
        {
            CourseNo = courseNo;
            ProjectNo = projectNo ?? 0;
        }

        [Display(Name = "제출번호")]
        public Int64 SubmitNo { get; set; }

        [Display(Name = "제출사용자번호")]
        public Int64 SubmitUserNo { get; set; }

        [Display(Name = "제출내용")]
        public string SubmitContents { get; set; }

        [Display(Name = "피드백")]
        public string Feedback { get; set; }

        [Display(Name = "재적구분")]
        public string HakjeokGubunName { get; set; }

        [Display(Name = "파일 번호")]
        public Int64? FileNo { get; set; }

        [Display(Name = "제출일")]
        public string CreateDateTimeFormat { get; set; }

        [Display(Name = "제출시간")]
        public string CreateTime { get; set; }

    }
}
