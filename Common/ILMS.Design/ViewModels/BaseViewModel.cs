using ILMS.Design.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Configuration;
using System.Web.Routing;

namespace ILMS.Design.ViewModels
{
	public class BaseViewModel
    {
        public BaseViewModel()
        {
		}

		[Display(Name = "SSL http문자열")]
		public string SSLStr()
		{
			return WebConfigurationManager.AppSettings["UseSSL"].ToString().Equals("Y") ? "https" : "http";
		}

		[Display(Name = "학교/기관 코드")]
		public string UnivCode()
		{
			return WebConfigurationManager.AppSettings["UnivCode"].ToString();
		}

		[Display(Name = "학교/기관명")]
		public string UnivName()
		{
			return WebConfigurationManager.AppSettings["UnivName"].ToString();
		}

		[Display(Name = "학교/기관 여부")]
		public string UnivYN()
		{
			return WebConfigurationManager.AppSettings["UnivYN"].ToString();
		}

		[Display(Name = "부서 리스트")]
		public IList<Assign> AssignList { get; set; }

		[Display(Name = "페이징 번호")]
		public int? PageNum { get; set; }

		[Display(Name = "1페이지 당 게시물 개수")]
		public int? PageRowSize { get; set; }

		[Display(Name = "공통코드")]
		public IList<Code> baseCodes { get; set; }

		public IList<Code> BaseCode { get; set; }

		[Display(Name = "리스트 파라미터")]
		public RouteValueDictionary Dic { get; set; }

		[Display(Name = "총 ROW 카운트")]
		public int PageTotalCount { get; set; }

		[Display(Name = "검색어")]
		public string SearchText { get; set; }

		[Display(Name = "첨부파일 리스트")]
		public IList<File> FileList { get; set; }

		[Display(Name = "첨부파일 리스트2")]
		public IList<File> FileCopyList { get; set; }
	}
}