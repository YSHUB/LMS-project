using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class OcwOpinion : OcwCourse
	{
		public OcwOpinion() { }

		public OcwOpinion(string rowState)
		{
			RowState = rowState;
		}


		[Display(Name = "Ocw 의견번호")]
		public Int64 OpinionNo { get; set; }

		[Display(Name = "상위 Ocw 의견번호")]
		public Int64 ParentOpinionNo { get; set; }

		[Display(Name = "최상위 Ocw 의견번호")]
		public Int64 TopOpinionNo { get; set; }

		[Display(Name = "Ocw 의견등록 유저번호")]
		public Int64 OpinionUserNo { get; set; }
		
		[Display(Name = "Ocw 의견등록 유저ID")]
		public string CreateUserID { get; set; }

		[Display(Name = "Ocw 의견등록 유저ID 마스킹")]
		public string CreateUserIDsecu { get; set; }

		[Display(Name = "Ocw 의견텍스트")]
		public string OpinionText { get; set; }

		[Display(Name = "Ocw 의견 레벨")]
		public int OPLevel { get; set; }

		[Display(Name = "Ocw 의견개수")]
		public int OpinionTotalCount { get; set; }




	}
}
