using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class TermWeek : Common
	{
        public int Count;

        public TermWeek() { }

		public TermWeek(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "학기 번호")]
		public int TermNo { get; set; }

		[Display(Name = "주차")]
		public int Week { get; set; }

		[Display(Name = "주차 시작 일자")]
		public string WeekStartDay { get; set; }

		[Display(Name = "주차 종료 일자")]
		public string WeekEndDay { get; set; }

	}
}
