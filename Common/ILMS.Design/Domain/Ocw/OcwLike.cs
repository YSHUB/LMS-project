using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class OcwLike : Ocw
	{
		public OcwLike() { }

		public OcwLike(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "해당 OCW 추천여부(0 : 추천 X / 1 : 추천)")]
		public int IsLiked { get; set; }

		[Display(Name = "해당 OCW 전체 추천수")]
		public int LikeCount { get; set; }

	}
}
