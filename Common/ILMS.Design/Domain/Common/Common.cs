using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Common
	{
		[Display(Name = "RowState")]
		public string RowState { get; set; }

		[Display(Name = "리스트 번호(연번)")]
		public int RowNum { get; set; }

		[Display(Name = "사용 여부")]
		public string UseYesNo { get; set; }

		[Display(Name = "삭제 여부")]
		public string DeleteYesNo { get; set; }

		[Display(Name = "표시여부")]
		public String VisibleYesNo { get; set; }

		[Display(Name = "정렬 번호")]
		public int SortNo { get; set; }

		[Display(Name = "전체 건수")]
		public int TotalCount { get; set; }

		[Display(Name = "생성(작성)일시")]
		public string CreateDateTime { get; set; }

		[Display(Name = "생성(작성)자 아이디")]
		public Int64 CreateUserNo { get; set; }

		[Display(Name = "생성(작성)자명")]
		public string CreateUserName { get; set; }

		[Display(Name = "수정일시")]
		public string UpdateDateTime { get; set; }

		[Display(Name = "수정자 아이디")]
		public Int64 UpdateUserNo { get; set; }

		[Display(Name = "현재 사용자 아이디(로그인한 사용자 번호)")]
		public Int64 UserNo { get; set; }

		[Display(Name = "검색구분")]
		public String SearchGbn { get; set; }
		
		[Display(Name = "검색어")]
		public String SearchText { get; set; }

		[Display(Name = "페이징 첫번째 번호")]
		public int FirstIndex { get; set; }

		[Display(Name = "페이징 마지막 번호")]
		public int LastIndex { get; set; }
	}
}
