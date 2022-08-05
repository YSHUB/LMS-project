using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class AssignHierarchy : AssignInfo
	{
		public AssignHierarchy()
			: base()
		{
		}

        [Display(Name = "하위소속명")]
        public string ChildAssignName { get; set; }

        [Display(Name = "하위 소속코드")]
        public string ChildAssignCode { get; set; }

        [Display(Name = "하위 대학코드")]
        public string ChildCampusCode { get; set; }


    }
}
