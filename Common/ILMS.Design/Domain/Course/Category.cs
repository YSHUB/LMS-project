using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Category : Course
	{
		public Category() { }

		public Category(string rowState)
		{
			RowState = rowState;
		}
		
		[Display(Name = "분류 코드")]
		public int MNo { get; set; }

		[Display(Name = "공개 여부")]
		public int IsOpen { get; set; }

		[Display(Name = "삭제 여부")]
		public int IsDeleted { get; set; }
		
		[Display(Name = "생성(작성)일시")]
		public string CDT { get; set; }

		[Display(Name = "현재 사용자 아이디(로그인한 사용자 번호)")]
		public Int64 UNO { get; set; }
    }
}
