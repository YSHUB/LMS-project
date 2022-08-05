using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	public class Output : Homework
	{
		public Output() { }

		public Output(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "산출물번호")]
		public Int64 OutputNo { get; set; }

		[Display(Name = "산출물종류")]
		public String OutputName { get; set; }

		[Display(Name = "산출물내용")]
		public String OutputContents { get; set; }
	}
}