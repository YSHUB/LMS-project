using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class QuestionBankPrintInfo : Common
	{
		public QuestionBankPrintInfo() { }

		public QuestionBankPrintInfo(string rowState)
		{
			RowState = rowState;
		}

		public string ExamTitle { get; set; }
		public string ProfName { get; set; }

	}
}
