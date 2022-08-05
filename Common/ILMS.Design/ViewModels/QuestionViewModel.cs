using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Routing;
using ILMS.Design.Domain;
namespace ILMS.Design.ViewModels
{
	public class QuestionViewModel : BaseViewModel
	{
        //공통
        public string[] fileName { get; set; }

        public string[] fileNewName { get; set; }

        public string[] fileSize { get; set; }

        public string[] fileType { get; set; }

		public string SearchOption { get; set; }

        public int FileGroupNo { get; set; }

        public string ID { get; set; }

		[Display(Name = "파일리스트 정보 ")]
		public List<File> newFileList { get; set; }

		[Display(Name = "에디터 이미지")]
		public string[] UserImgs { get; set; }

		public int QuestionTotalCount { get; set; }

		public string QuestionBankType { get; set; }

		[Display(Name = "문제유형구분")]
		public string QuestionType { get; set; }
		
		public string[] CorrectAnswerYesNo { get; set; }

		public string[] ExampleContents { get; set; }
		[Display(Name = "답안설명")]
		public string AnswerExplain { get; set; }

		public string Difficulty { get; set; }

		public string UseYesNo  { get; set; }

		public string Question  { get; set; }

		public int GubunNo { get; set; }

		public int GubunNoOri { get; set; }

		public QuestionBankQuestion QuestionEntity { get; set; }

		public IList<QuestionBankExample> ExampleEntity { get; set; }

		public IList<QuestionBankQuestion> QuestionList { get; set; }

		public IList<QuestionBankQuestion> QuestionTypeCountList { get; set; }

		public IList<QuestionBankGubun> CategoryList { get; set; }

        public string GubunName { get; set; }
				
		public string Message { get; set; }

	}
}