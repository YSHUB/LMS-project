
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using ILMS.Design.Domain;
using System;

namespace ILMS.Design.ViewModels
{
	//쪽지함 페이지
	public class NoteViewModel : BaseViewModel
	{
		[Display(Name = "쪽지함 리스트")]
		public IList<Note> NoteList { get; set; }

		[Display(Name = "쪽지")]
		public Note Note { get; set; }

		[Display(Name = "학기")]
		public IList<Term> TermList { get; set; }

		[Display(Name = "과목명")]
		public IList<Course> CourseList { get; set; }

		[Display(Name = "과목")]
		public Course Course { get; set; }

		[Display(Name = "리스트 구분값")]
		public string NoteGubun { get; set; }
		
	}

}
