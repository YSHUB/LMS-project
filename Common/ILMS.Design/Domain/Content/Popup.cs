using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Popup : Common
	{
		public Popup() { }

		public Popup(string rowState)
		{
			RowState = rowState;
		}

        [Required]
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
        public int WidthSize { get; set; }

        [Display(Name = "세로크기")]
        public int HeightSize { get; set; }

        [Display(Name = "왼족여백")]
        public int LeftMargin { get; set; }

        [Display(Name = "위여백")]
        public int TopMargin { get; set; }

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

        [Display(Name ="화면 타이틀")]
        public string PageTitle { get; set; }

        [Display(Name = "파일그룹번호")]
        public int FileGroupNo { get; set; }

        [Display(Name = "팝업출력기준일")]
        public string DisplayDay { get; set; }

        [Display(Name = "등록이미지")]
        public string[] UserImgs { get; set; }


        [Display(Name = "게시글 내용(html)")]
        public string HtmlContents { get; set; }

        [Display(Name = "게시글 내용")]
        public string Contents { get; set; }

    }
}
