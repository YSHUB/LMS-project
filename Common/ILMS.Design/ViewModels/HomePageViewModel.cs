using ILMS.Design.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.ViewModels
{
	//메인페이지
	public class HomePageViewModel : BaseViewModel
    {
		[Display(Name = "게시판 리스트")]
		public IList<Board> BoardList { get; set; }

		[Display(Name = "강좌 리스트")]
		public IList<Course> CourseList { get; set; }

		[Display(Name = "강좌상세 리스트")]
		public IList<Inning> InningList { get; set; }

		[Display(Name = "팝업 리스트")]
		public IList<Popup> PopupList { get; set; }

		[Display(Name = "퀵링크 리스트")]
		public IList<QuickLink> QuickLinkList { get; set; }
	}
}
