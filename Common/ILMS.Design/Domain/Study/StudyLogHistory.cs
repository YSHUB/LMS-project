using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class StudyLogHistory : StudyInning
	{
		public StudyLogHistory() { }

		public StudyLogHistory(string rowState)
		{
			RowState = rowState;
		}
    }
}
