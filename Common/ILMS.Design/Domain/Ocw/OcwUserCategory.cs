using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class OcwUserCategory : Common
	{
		public OcwUserCategory() { }

		public OcwUserCategory(string rowState)
		{
			RowState = rowState;
		}

		[Required]
		[Display(Name = "카테고리코드")]
		public int CatCode { get; set; }
		
		[Required]
		[Display(Name = "카테고리명")]
		public string CatName { get; set; }

		[Required]
		[Display(Name = "로그인 유저의 해당 카테고리에 자신이 등록한 OCW 개수")]
		public int OcwCount { get; set; }

		[Required]
		[Display(Name = "로그인 유저의 해당 카테고리에 담겨진 OCW 개수")]
		public int OcwPocketCount { get; set; }
		

	}
}
