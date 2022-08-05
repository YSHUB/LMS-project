using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using ILMS.Design.Domain;
namespace ILMS.Design.ViewModels
{
	public class ImportViewModel : BaseViewModel
	{

        [Display(Name = "로그 리스트")]
        public IList<Import> LogList { get; set; }

		[Display(Name ="연동 시작일자")]
		public string StartDate { get; set; }

		[Display(Name = "연동 종료일자")]
		public string EndDate { get; set; }

	}
}
