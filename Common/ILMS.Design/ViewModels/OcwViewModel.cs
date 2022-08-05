using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using ILMS.Design.Domain;
namespace ILMS.Design.ViewModels
{
	//Ocw 관련 페이지
	public class OcwViewModel : BaseViewModel
	{
		public LinkOcw LinkOcw { get; set; }

		public IList<LinkOcw> LinkOcwList { get; set; }

		public Ocw Ocw { get; set; }

		public IList<Ocw> OcwList { get; set; }

		public OcwTheme OcwTheme { get; set; }

		public IList<OcwTheme> OcwThemeList { get; set; }

		public OcwUserCategory OcwUserCat { get; set; }

		public IList<OcwUserCategory> OcwUserCatList { get; set; }

		public OcwCourse OcwCourse { get; set; }

		public IList<OcwCourse> OcwCourseList { get; set; }

		public OcwOpinion OcwOpinion { get; set; }

		public IList<OcwOpinion> OcwOpinionList { get; set; }

		public OcwLike OcwLike { get; set; }

		public OcwPocket OcwPocket { get; set; }

		public Term Term { get; set; }

		public IList<Term> TermList { get; set; }

		public Course Course{ get; set; }

		public IList<Course> CourseList { get; set; }

		public Inning Inning{ get; set; }

		public IList<Inning> WeekList { get; set; }


		[Display(Name = "정렬순")]
		public string OcwSort { get; set; } 

		[Display(Name = "테마선택")]
		public string OcwThemeSel{ get; set; } 

		[Display(Name = "전공선택")]
		public string AssignSel { get; set; }

		[Display(Name = "폴더(카테고리)선택")]
		public string UserCat { get; set; } 

		[Display(Name = "공개상태 선택")]
		public string OpenGb { get; set; } 

		[Display(Name = "등록상태 선택")]
		public string AuthGb { get; set; } 

		[Display(Name = "유저 선택")]
		public Int64 UserNo { get; set; }

		[Display(Name = "MP4파일그룹번호")]
		public Int64? MP4FileGroupNo { get; set; }

		[Display(Name = "HTML(ZIP)파일그룹번호")]
		public Int64? HTMLFileGroupNo { get; set; }

		[Display(Name = "파일그룹번호")]
		public Int64? BasicFileGroupNo { get; set; }

		[Display(Name = "썸네일파일그룹번호")]
		public Int64? ThumFileGroupNo { get; set; }

		[Display(Name = "파일명")]
		public int FileName { get; set; }

		[Display(Name = "연계OCW 번호")]
		public string hdnLinkOcwNo { get; set; }

		[Display(Name = "썸네일 첨부파일 리스트")]
		public IList<File> ThumFileList { get; set; }				

		[Display(Name = "MP4 첨부파일 리스트")]
		public IList<File> MP4FileList { get; set; }		

		[Display(Name = "HTML 첨부파일 리스트")]
		public IList<File> HTMLFileList { get; set; }

		[Display(Name = "썸네일 첨부파일 리스트")]
		public IList<File> BasicFileList { get; set; }
		
		[Display(Name = "학기 번호")]
		public int TermNo { get; set; }

		[Display(Name = "연계상태")]
		public string CCStatus { get; set; }
		
		[Display(Name = "공개여부")]
		public int? IsOpen { get; set; }
		
		[Display(Name = "승인여부")]
		public int? IsAuth { get; set; }

		[Display(Name = "차시기준OCW정보")]
		public Hashtable OcwByInning { get; set; }

		[Display(Name = "로그대상여부")]
		public bool IsLog { get; set; }

		[Display(Name = "중간체크시간")]
		public int MidCheckSecond { get; set; }

		[Display(Name = "기간외로그번호")]
		public Int64 AfterLogNo { get; set; }

		[Display(Name = "학습시간")]
		public int StudyTime { get; set; }

		[Display(Name = "학습시간")]
		public string XIDstart { get; set; }

		[Display(Name = "현재학기여부")]
		public string CurrentTermYn { get; set; }

	}
}
