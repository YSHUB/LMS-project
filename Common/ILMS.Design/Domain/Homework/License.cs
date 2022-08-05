using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	public class License : HomeworkSubmit
	{
		public License() { }

		public License(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "자격증코드")]
		public string CertCode { get; set; }

		[Display(Name = "수정할 자격증코드")]
		public string UpdateCertCode { get; set; }

		[Display(Name = "자격증이름")]
		public string CertName { get; set; }

		[Display(Name = "취득일자")]
		public string CertDate { get; set; }
	}
}
