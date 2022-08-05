using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Ocw : OcwUserCategory
	{
		public Ocw() { }

		public Ocw(string rowState)
		{
			RowState = rowState;
		}

		[Display(Name = "Ocw 번호")]
		public Int64 OcwNo { get; set; }

		[Display(Name = "Ocw 작성자")]
		public Int64 OcwUserNo { get; set; }
		
		[Display(Name = "Ocw 작성자ID")]
		public string OcwUserID { get; set; }
		
		[Display(Name = "Ocw 작성자명")]
		public string OcwUserNm { get; set; }

		[Display(Name = "유저타입")]
		public string UserType { get; set; }

		[Display(Name = "Ocw명")]
		public string OcwName { get; set; }
		
		[Display(Name = "작성자 OCW(0 : 작성자 OCW x, 1: 작성자 OCW)")]
		public bool IsUserOcw { get; set; }

		[Display(Name = "OCW 소스")]
		public string OcwData { get; set; }

		[Display(Name = "OCW 콘텐츠 종류(0: 영상, 1: 파일, 2: 패키지(2018고도화))")] 
		public int OcwType { get; set; } //2의 경우 현재 안씀

		[Display(Name = "OCW 콘텐츠 종류명")] 
		public string OcwTypeName { get; set; } //2의 경우 현재 안씀

		[Display(Name = "콘텐츠등록방식(0: URL, 1: 소스코드, 2: Cmaker, 3: 업로드(MP4), 4: HTML(ZIP)업로드, 5: 파일업로드)")]
		public int OcwSourceType { get; set; } //2의 경우 현재 안씀

		[Display(Name = "콘텐츠등록방식명")]
		public string OcwSourceTypeName { get; set; } //2의 경우 현재 안씀

		[Display(Name = "OCW 콘텐츠 설명")]
		public string DescText { get; set; }

		[Display(Name = "OCW 콘텐츠 파일 그룹번호")]
		public Int64? OcwFileGroupNo { get; set; }

		[Display(Name = "OCW 콘텐츠 파일 번호")]
		public Int64 OcwFileNo { get; set; }

		[Display(Name = "OCW 콘텐츠 thumbnail 경로")]
		public string ThumFileName { get; set; }

		[Display(Name = "OCW 바로보기 팝업너비")]
		public int OcwWidth { get; set; }

		[Display(Name = "OCW 바로보기 팝업높이")]
		public int OcwHeight { get; set; }

		[Required]
		[Display(Name = "키워드")]
		public string KWord { get; set; }

		[Required]
		[Display(Name = "테마분류")] //키를 콤마로 분리 ex(,1,2,10, : 콤마로시작 콤마로 종료, 조회 시 콤마로 감싸서 like 검색)
		public string ThemeNos { get; set; }

		[Required]
		[Display(Name = "공개여부(0: 비공개, 1: 전체공개, 2: 강의전용(강의실에서만 전시))")]
		public int? IsOpen { get; set; }

		[Display(Name = "공개여부명")]
		public string OcwOpenName { get; set; }

		[Required]
		[Display(Name = "관리자승인여부(0: 검토(미승인), 1: 거절, 2: 승인)")] 
		public int? IsAuth { get; set; }

		[Display(Name = "승인여부명")]
		public string OcwAuthName { get; set; }

		[Display(Name = "승인날짜")]
		public string AuthDateTime { get; set; }

		[Required]
		[Display(Name = "썸네일첨부그룹번호")]
		public Int64? ThumFileGroupNo { get; set; }

		[Display(Name = "전공코드")]
		public string AssignNo { get; set; }

		[Display(Name = "전공분류")]
		public string AssignNamePath { get; set; }
		
		[Display(Name = "OCW 콘텐츠 조회수")]
		public int UsingCount { get; set; }		

		[Display(Name = "OCW 강좌적용수")]
		public int CourseCount { get; set; }

		[Display(Name = "총 OCW 개수")]
		public int OcwAllCount { get; set; }

		[Display(Name = "총 레코드 개수")]
		public int MR { get; set; }

		[Display(Name = "자신의 LMS인지 여부(0 : 자신의 OCW x , 1 : 자기가 등록한 OCW)")]
		public int IsSelfOcw { get; set; }

		[Display(Name = "연계상태(0 : 검토중 , 1 : 거절, 2 : 승인)")]
		public int CCStatus { get; set; }

		[Display(Name = "연계상태명")]
		public string CCStatusName { get; set; }

		[Display(Name = "확장자에 따른 파일썸네일 구분")]
		public string FileExtension
		{
			get
			{
				if (!string.IsNullOrEmpty(ThumFileName))
				{
					return "/" + System.Web.Configuration.WebConfigurationManager.AppSettings["FileRootFolder"].ToString() + this.ThumFileName;
				}
				else
				{
					string extension = (this.OcwData ?? "").Split('.').Last().ToLower();
					switch (extension)
					{
						case "xls":
						case "xlsx":
							return "bi bi-file-excel-fill";
						case "ppt":
						case "pptx":
							return "bi bi-file-ppt-fill";
						case "pdf":
							return "bi bi-file-pdf-fill";
						case "doc":
						case "docx":
							return "bi bi-file-word-fill";
						case "hwp":
							return "bi bi-file-text-fill";
						default:
							if(this.OcwType == 0) //영상
							{
								return "bi bi-collection-play-fill";
							}
							else if(this.OcwType == 0 && this.OcwSourceType == 4) // 영상이고 zip업로드일 경우
							{
								return "bi bi-file-zip-fill";
							}
							return "bi bi-folder-fill";
					}
				}
			}
		}

		[Display(Name = "OCW 삭제가능 여부")]
		public string OcwDeletePossibleYN { get; set; }

		[Display(Name = "OCW 강의자 이름")]
		public string OcwUserName { get; set; }
	}
}
