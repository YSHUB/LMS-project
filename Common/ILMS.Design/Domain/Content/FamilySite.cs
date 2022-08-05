using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class FamilySite : Common
	{
		public FamilySite() { }

		public FamilySite(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "사이트 번호")]
		public int SiteNo { get; set; }

		[Display(Name = "사이트 링크")]
		public string SiteUrl { get; set; }

		[Display(Name = "사이트 명")]
		public string SiteName { get; set; }

        [Required]
        [Display(Name = "퀵링크번호")]
        public int QuickNo { get; set; }

        [Display(Name = "퀵링크명")]
        public string QuickName { get; set; }

        [Display(Name = "시작일자")]
        public string Url { get; set; }

        [Display(Name ="파일명")]
        public string SaveFileName { get; set; }

        [Display(Name = "파일그룹번호")]
        public Int64 FileGroupNo { get; set; }

        [Display(Name = "표시순서")]
        public Int64 DisplayOrder { get; set; }

        [Display(Name = "표시여부")]
        public string OutputYesNo { get; set; }

        [Display(Name = "리스트번호")]
        public int Row { get; set; }

    }
}
