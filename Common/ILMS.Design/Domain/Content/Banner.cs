using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Banner : Common
	{
		public Banner() { }

		public Banner(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "배너번호")]
		public int BannerNo { get; set; }

		[Display(Name = "배너설명")]
		public string BannerExplain { get; set; }

		[Display(Name = "시작일자")]
		public string StartDay { get; set; }

		[Display(Name = "종료일자")]
		public string EndDay { get; set; }

		[Display(Name = "링크방법")]
		public string LinkType { get; set; }

		[Display(Name = "링크URL")]
		public string LinkUrl { get; set; }

        [Display(Name = "출력여부")]
        public string OutputYesNo { get; set; }

        [Display(Name = "파일그룹번호")]
        public Int64 FileGroupNo { get; set; }

        [Display(Name = "배너타입")]
        public int BannerType { get; set; }

		[Display(Name = "리스트번호")]
		public int Row { get; set; }

		[Display(Name = "서버 파일 명(변환 후)")]
		public string SaveFileName { get; set; }

		public string BannerFileGroupNoUpload { get; set; }

		[Display(Name ="타이틀")]
		public string PageTitle { get; set; }

	}
}
