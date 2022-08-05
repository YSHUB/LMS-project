using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class QuickLink : Common
	{
		public QuickLink() { }

		public QuickLink(string rowState)
		{
			RowState = rowState;
		}

        [Display(Name = "퀵링크번호")]
        public int QuickNo { get; set; }

        [Display(Name = "퀵링크명")]
        public string QuickName { get; set; }

        [Display(Name = "퀵링크주소")]
        public string Url { get; set; }

        [Display(Name = "파일그룹번호")]
        public Int64 FileGroupNo { get; set; }

        [Display(Name = "표시순서")]
        public Int64 DisplayOrder { get; set; }

        [Display(Name = "표시여부")]
        public string OutputYesNo { get; set; }

        [Display(Name = "리스트번호")]
        public int Row { get; set; }

		[Display(Name = "파일경로")]
		public string SaveFileName { get; set; }

	}
}
