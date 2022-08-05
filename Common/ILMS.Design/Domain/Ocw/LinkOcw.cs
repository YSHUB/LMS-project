using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class LinkOcw : Ocw
	{
		public LinkOcw() { }

		public LinkOcw(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "연계OCW 번호")]
		public Int64 LinkOcwNo { get; set; }

		[Display(Name = "연계OCW명")]
		public string LinkOcwName { get; set; }

	}
}
