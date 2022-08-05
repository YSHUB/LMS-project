using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class OcwPocket : Ocw
	{
		public OcwPocket() { }

		public OcwPocket(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "해당 OCW강좌 담기 여부( 0 : 담기X / 1 : 담기)")]
		public int IsPocketed { get; set; }

		[Display(Name = "해당 OCW 강좌가 담겨진 총 개수")]
		public int PocketCount { get; set; }

	}
}
