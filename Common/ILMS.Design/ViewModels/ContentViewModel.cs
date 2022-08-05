using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using ILMS.Design.Domain;

namespace ILMS.Design.ViewModels
{
	// CONTENT - 배너,팝업,퀵링크관리
	public class ContentViewModel : BaseViewModel
	{
		[Display(Name ="배너리스트")]
		public IList<Banner> BannerList { get; set; }

		[Display(Name ="배너 상세보기")]
		public Banner Banner { get; set; }

		[Display(Name ="팝업리스트")]
		public IList<Popup> PopupList { get; set; }

		[Display(Name = "팝업 상세보기")]
		public Popup Popup { get; set; }

		[Display(Name = "관련사이트리스트")]
		public IList<FamilySite> FamilySiteList { get; set; }

		[Display(Name = "관련사이트 상세보기")]
		public FamilySite FamilySite { get; set; }

		[Display(Name = "퀵링크 리스트")]
		public IList<QuickLink> QuickLinkList { get; set; }

		[Display(Name = "퀵링크 상세보기")]
		public QuickLink QuickLink { get; set; }

		[Display(Name = "파일그룹번호")]
		public int FileGroupNo { get; set; }

		[Display(Name = "에디터 이미지")]
		public string[] UserImg { get; set; }

        [Display(Name = "팝업번호")]
        public int PopupNo { get; set; }

        [Display(Name = "팝업제목")]
        public string PopupTitle { get; set; }

        [Display(Name = "첨부파일제목")]
        public string SaveFileName { get; set; }

        [Display(Name = "시작일자")]
        public string StartDay { get; set; }

        [Display(Name = "종료일자")]
        public string EndDay { get; set; }

        [Display(Name = "가로크기")]
        public int? WidthSize { get; set; }

        [Display(Name = "세로크기")]
        public int? HeightSize { get; set; }

        [Display(Name = "왼족여백")]
        public int? LeftMargin { get; set; }

        [Display(Name = "위여백")]
        public int? TopMargin { get; set; }

        [Display(Name = "출력여부")]
        public string OutputYesNo { get; set; }

        [Display(Name = "팝업내용")]
        public string PopupContents { get; set; }

        [Display(Name = "팝업구분")]
        public string PopupGubun { get; set; }

        [Display(Name = "팝업연결URL")]
        public string LinkUrl { get; set; }

        [Display(Name = "리스트번호")]
        public int Row { get; set; }

        [Display(Name = "화면 타이틀")]
        public string PageTitle { get; set; }

        [Display(Name = "팝업출력기준일")]
        public string DisplayDay { get; set; }

    }
}
