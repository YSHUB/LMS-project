using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class AssignInfo : Common
	{
		public AssignInfo() { }

		public AssignInfo(string rowState)
		{
			RowState = rowState;
		}

        [Display(Name = "소속 번호")]
        public String AssignNo { get; set; }

        [Display(Name = "소속 명")]
        public String AssignName { get; set; }
        public String NewAssignName { get; set; }

        [Display(Name = "상위 소속 번호")]
        public String UpperAssignNo { get; set; }

        [Display(Name = "소속 코드")]
        public String AssignCode { get; set; }
        public String NewAssignCode { get; set; }


        [Display(Name = "메뉴 깊이")]
        public int HierarchyLevel { get; set; }

        [Display(Name = "권재코드")]
        public String GCode { get; set; }

        [Required]
        [Display(Name = "대학교 코드")]
        public String UniversityCode { get; set; }

        [Display(Name = "소속 구분")]
        public String AssignGubun { get; set; }

        [Display(Name = "캠포스 코드")]
        public String CampusCode { get; set; }

        [Display(Name = "캠퍼스 코드")]
        public String UpperAssignCode { get; set; }



        //partial

        public string Navigator
        {
            get
            {
                return (string.IsNullOrEmpty(this.AssignName1) ? this.AssignName1 + " > " : "")
                    + (string.IsNullOrEmpty(this.AssignName2) ? this.AssignName2 + " > " : "")
                    + (string.IsNullOrEmpty(this.AssignName3) ? this.AssignName3 + " > " : "")
                    + (string.IsNullOrEmpty(this.AssignName4) ? this.AssignName4 + " > " : "")
                    + (string.IsNullOrEmpty(this.AssignName5) ? this.AssignName5 + " > " : "")
                    + (string.IsNullOrEmpty(this.AssignName6) ? this.AssignName6 + " > " : "");
            }
        }



        [Display(Name = "학교명")]
        public String UniversityName { get; set; }

        [Display(Name = "캠퍼스명")]
        
        public string CampusName { get; set; }

        [Display(Name = "학기구분명")]
        public string TermQuarterName { get; set; }

        [Display(Name = "학기년도")]
        public string TermYear { get; set; }

        [Display(Name = "과목명")]
        public string SubjectName { get; set; }

        [Display(Name = "분반")]
        public int ClassNo { get; set; }


        public int HierarchyLevel1 { get; set; }
        public int HierarchyLevel2 { get; set; }
        public int HierarchyLevel3 { get; set; }
        public int HierarchyLevel4 { get; set; }
        public int HierarchyLevel5 { get; set; }
        public int HierarchyLevel6 { get; set; }
        public string AssignName1 { get; set; }
        public string AssignName2 { get; set; }
        public string AssignName3 { get; set; }
        public string AssignName4 { get; set; }
        public string AssignName5 { get; set; }
        public string AssignName6 { get; set; }


    }
}
