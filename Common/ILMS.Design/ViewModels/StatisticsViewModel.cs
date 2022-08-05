using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using ILMS.Design.Domain;

namespace ILMS.Design.ViewModels
{
	public class StatisticsViewModel : BaseViewModel
	{
		[Display(Name = "통계 리스트")]
		public IList<Statistics> StatisticsList { get; set; }
		
		[Display(Name = "비로그인 접속통계")]
		public IList<Statistics> HomeStatisticsList { get; set; }

		[Display(Name = "퀴즈 시험 리스트")]
		public IList<Statistics> ExamList { get; set; }

		[Display(Name = "학기 목록")]

		public IList<Term> TermList { get; set; }

		[Display(Name = "과목명")]
		public IList<Course> CourseList { get; set; }

		[Display(Name = "학기")]
		public Term Term { get; set; }

		[Display(Name = "학기 번호")]
		public int TermNo { get; set; }

		[Display(Name = "구분값")]
		public string Gubun { get; set; }

		//▼ 접속통계
		[Display(Name = "년도")]
		public string Year { get; set; }

		[Display(Name = "월")]
		public string Month { get; set; }

		[Display(Name = "일")]
		public string Day { get; set; }
		//▲ 접속통계
		
		//▼ 프로그램 이수현황
		[Display(Name = "강좌 번호")]
		public int CourseNo { get; set; }
		//▲ 프로그램 이수현황

		//▼ 학생별 이수현황
		[Display(Name = "과목 검색")]
		public string SearchSubject { get; set; }

		[Display(Name = "성명 검색")]
		public string SearchName { get; set; }
		//▲ 학생별 이수현황

		//▼ 개인별컨텐츠 통계
		[Display(Name = "조회 분류")]
		public string Sort { get; set; }
		//▲ 개인별컨텐츠 통계


	}

}
