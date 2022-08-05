using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Web.Configuration;
using System.Web.Mvc;

namespace ILMS.Design.ViewModels
{
	//강의실관련 페이지
	public class CourseViewModel : BaseViewModel
    {
		[Display(Name = "강좌정보")]
		public Course Course { get; set; }

		[Display(Name = "수강정보")]
		public CourseLecture CourseLecture { get; set; }

		[Display(Name = "강좌 리스트")]
		public IList<Course> CourseList { get; set; }

		[Display(Name = "수강 리스트")]
		public IList<CourseLecture> CourseLectureList { get; set; }

		[Display(Name = "강좌번호")]
		public int CourseNo { get; set; }

		[Display(Name = "년도")]
		public string Year { get; set; }

		[Display(Name = "월")]
		public string Month { get; set; }

		[Display(Name = "평가기준")]
		public EstimationItemBasis EstimationBasis { get; set; }

		[Display(Name = "평가기준")]
		public IList<EstimationItemBasis> EstimationItemBasis { get; set; }

		[Display(Name = "참여도평가기준 리스트")]
		public IList<EstimationItemBasis> ParticipationEstimationItemBasis { get; set; }

		[Display(Name = "참여도평가기준")]
		public EstimationItemBasis ParticipationEstimationBasis { get; set; }

		[Display(Name = "주차별강의계획")]
		public IList<Inning> Inning { get; set; }

		[Display(Name = "분류설정")]
		public IList<Category> CategoryList { get; set; }

		[Display(Name = "학기 리스트")]
		public IList<Term> TermList { get; set; }

		[Display(Name = "성적 리스트")]
		public IList<Grade> GradeList { get; set; }

		[Display(Name = "학기 번호")]
		public int TermNo { get; set; }

		[Display(Name = "프로그램 번호")]
		public int ProgramNo { get; set; }

		[Display(Name = "프로그램 리스트")]
		public IList<Homework> ProgramList { get; set; }

		[Display(Name = "유형별성적")]
		public IList<Inning> GradeToStatusList { get; set; }

		[Display(Name = "주차별성적")]
		public IList<Inning> GradeToWeekList { get; set; }

		[Display(Name = "강의실유저정보")]
		public CourseLecture LectureUserDetail { get; set; }

		[Display(Name = "교수명 검색")]
		public string SearchProf { get; set; }

		[Display(Name = "학생 리스트")]
		public IList<Student> StudentList { get; set; }

		[Display(Name = "학생")]
		public Student Student { get; set; }

		[Display(Name = "학생 ocw정보(OCW등록 수, 접근횟수, 의견 수)")]
		public CourseLecture StudentOCW { get; set; }

		[Display(Name = "정렬 분류")]
		public string SearchSort { get; set; }

		[Display(Name = "상세검색 분류")]
		public string SearchOption { get; set; }

		[Display(Name = "검색구분 분류")]
		public string SearchGbn { get; set; }

		[Display(Name = "학생명 검색")]
		public string SearchStud { get; set; }

		[Display(Name = "페이지 구분(학습진도, 참여도, 컨텐츠 활동)")]
		public string hdnPageMode { get; set; }

		[Display(Name = "교수 리스트")]
		public IList<Course> ProfessorList { get; set; }

		[Display(Name = "정렬 타입")]
		public string SortType { get; set; }

		[Display(Name = "과목 정보")]
		public Subject Subject { get; set; }

		[Display(Name = "파일그룹번호")]
		public int FileGroupNo { get; set; }

		[Display(Name = "참여도 현황 리스트")]
		public IList<Hashtable> ProgressDetailList { get; set; }

		[Display(Name = "참여도 현황")]
		public Hashtable ProgressDetail { get; set; }

		[Display(Name = "참여도 현황 (OCW)")]
		public Hashtable ProgressDetailOCW { get; set; }

		[Display(Name = "참여도 현황 리스트")]
		public IList<Course> ProgressCourseDetailList { get; set; }

		[Display(Name = "교수")]
		public Course Professor { get; set; }

		[Display(Name = "주차 리스트")]
		public IList<Inning> WeekList { get; set; }

		[Display(Name = "학습차시정보")]
		public IList<StudyInning> StudyInningInfo { get; set; }

		[Display(Name = "학습상세 총 시간")]
		public TimeSpan TotalTime { get; set; }

		[Display(Name = "권장 진도율")]
		public double RecommandProgressRate { get; set; }

		[Display(Name = "카테고리 번호")]
		public int CategoryNo { get; set; }

		[Display(Name = "학습 차시")]
		public int GetTotalStudyInning()
		{
			var temp = from c in StudyInningInfo
					   where c.StudyLatelyDateTime != null
					   select c;
			if (temp == null || temp.Count() == 0) return 0;
			else return temp.Count();

		}

		[Display(Name = "총 학습 차시")]
		public int GetTotalInning()
		{
			return StudyInningInfo.Count;
		}

		[Display(Name = "마지막 학습 주차")]
		public int GetLastStudyWeek()
		{
			var temp = (from c in StudyInningInfo
						where c.StudyLatelyDateTime != null
						select c).OrderByDescending(c => c.StudyLatelyDateTime);
			if (temp == null || temp.Count() == 0) return 0;
			else return temp.FirstOrDefault().Week;

		}

		[Display(Name = "마지막 학습 차시")]
		public int GetLastStudyInning()
		{
			var temp = (from c in StudyInningInfo
						where c.StudyLatelyDateTime != null
						select c).OrderByDescending(c => c.StudyLatelyDateTime);
			if (temp == null || temp.Count() == 0) return 0;
			else
			{
				return Inning.Where(c => c.InningNo == temp.FirstOrDefault().InningNo).FirstOrDefault().InningSeqNo;

			}
		}

		[Display(Name = "총 학습시간")]
		public int GetTotalStudyTime()
		{
			return StudyInningInfo.Sum(c => c.StudyTime);
		}

		[Display(Name = "강의 접속 수")]
		public int GetTotalConnectedCount()
		{
			return StudyInningInfo.Sum(c => c.StudyConnectCount);
		}

		[Display(Name = "평균 학습시간")]
		public int GetAvgStudyTime()
		{
			int totalStudyTime = GetTotalStudyTime();
			double totalConnected = GetTotalConnectedCount();
			if (totalConnected <= 0)
			{
				return 0;
			}
			else
			{
				return (int)Math.Round(totalStudyTime / totalConnected);
			}
		}

		public double GetTotalConnectedTime()
		{

			long tick = 0;

			foreach (var item in UserLogList)
			{
				if (item.LogoutDay != null)
				{
					TimeSpan termTime = (DateTime.Parse(item.LogoutDay)).Subtract(DateTime.Parse(item.LoginDay));
					tick += termTime.Ticks;
				}
				else
				{
					if (item.MiddleCheckDay != null)
					{
						TimeSpan termTime = (DateTime.Parse(item.MiddleCheckDay)).Subtract(DateTime.Parse(item.LoginDay));
						tick += termTime.Ticks;
					}

				}

			}
			TotalTime = new TimeSpan(tick);
			return Math.Round(TotalTime.TotalMinutes, 1);
		}

		public double GetAvgConnectedTime()
		{
			if (UserLogList.Count == 0) return 0;
			else return Math.Round((TotalTime.TotalMinutes / UserLogList.Count), 1);
		}

		[Display(Name = "OcwTheme")]
		public OcwTheme OcwTheme { get; set; }

		[Display(Name = "OcwTheme리스트")]
		public IList<OcwTheme> OcwThemeList { get; set; }

		[Display(Name = "수강생출결정보")]
		public IList<StudyInning> StudyInningList { get; set; }

		[Display(Name = "수강생출결변경사유")]
		public StudyInning StudyInningAttendanceList { get; set; }

		[Display(Name = "주차 정보")]
		public Inning CourseInning { get; set; }

		[Display(Name = "학습상세OCW리스트")]
		public IList<OcwCourse> OcwCourseList { get; set; }

		[Display(Name = "학습상세접속정보리스트")]
		public IList<User> UserLogList { get; set; }

		[Display(Name = "StudyInningNo배열")]
		public string[] StudyInningNo { get; set; }

		[Display(Name = "ParticipationItemGubun 배열")]
		public string[] ParticipationItemGubun { get; set; }

		[Display(Name = "Participation RateScore 배열")]
		public string[] ParticipationRateScore { get; set; }

		[Display(Name = "Participation BasisScore 배열")]
		public string[] ParticipationBasisScore { get; set; }

		[Display(Name = "EstimationItemGubun 배열")]
		public string[] EstimationItemGubun { get; set; }

		[Display(Name = "Estimation RateScore 배열")]
		public string[] EstimationRateScore { get; set; }

		[Display(Name = "페이지구분")]
		public string PageGubun { get; set; }

		[Display(Name = "성적관리항목")]
		public string ListType { get; set; }

		[Display(Name = "성적관리수정")]
		public string DetailType { get; set; }

		[Display(Name = "시험응시자리스트")]
		public IList<Examinee> ExamineeList { get; set; }

		[Display(Name = "시험상태변환")]
		public MvcHtmlString GetExamStatusString(long paramUserNo, string paramExGubun)
		{
			var temp = (from c in ExamineeList
						where c.ExamineeUserNo == paramUserNo && c.ExamGubun.Equals(paramExGubun)
						select c).OrderByDescending(c => c.TakeDateTime).FirstOrDefault();
			string rs = "";
			bool isContinue = true;
			if (paramExGubun.Equals("CHEK001"))
			{
				if (Course.MiddleTestIsOnline == null)
				{
					rs = "-";
					isContinue = false;
				}
				else if (Course.MiddleTestIsOnline.Equals("N"))
				{
					rs = "오프라인";
					isContinue = false;
				}
			}
			else if (paramExGubun.Equals("CHEK002"))
			{
				if (Course.LastTestIsOnline == null)
				{
					rs = "-";
					isContinue = false;
				}
				else if (Course.LastTestIsOnline.Equals("N"))
				{
					rs = "오프라인";
					isContinue = false;
				}
			}

			if (isContinue)
			{
				if (temp == null)
				{
					rs = "N";
				}
				else
				{   //과제형시험(오프라인)
					if (temp.ExamType.Equals("EXTP001"))
					{
						rs = "과제대체";
					}//과제형시험(온라인)
					else if (temp.ExamType.Equals("EXTP002"))
					{
						rs = "과제대체";
					}//시험대체형(오프라인)
					else if (temp.ExamType.Equals("EXTP003"))
					{
						rs = "과제대체";
					}//시험대체형(온라인)
					else if (temp.ExamType.Equals("EXTP004"))
					{
						rs = "과제대체";
					}//중간고사(온라인)
					else if (temp.ExamType.Equals("EXTP005"))
					{
						rs = "온라인";
					}//기말고사(온라인)
					else if (temp.ExamType.Equals("EXTP006"))
					{
						rs = "온라인";
					}//과제형시험(이메일)
					else if (temp.ExamType.Equals("EXTP007"))
					{
						rs = "과제대체";
					}//시험대체형(이메일)
					else
					{
						rs = "과제대체";
					}
				}
			}
			return MvcHtmlString.Create(rs);
		}

		public string GetInningTypeName(string inningGbn)
        {
			string inningTypeName = "";

			//동영상(온라인 강의)
			if (inningGbn.Equals("1"))
			{
				inningTypeName = "동영상";
			}

			//대면(오프라인)
			else if (inningGbn.Equals("2"))
			{
				inningTypeName = "대면";
			}

			//동영상(실시간 강의)
			else if (inningGbn.Equals("3"))
			{
				inningTypeName = "실시간화상";
			}

			//시험
			else if (inningGbn.Equals("4"))
			{
				inningTypeName = "시험";
			}

			//퀴즈
			else if (inningGbn.Equals("5"))
			{
				inningTypeName = "퀴즈";
			}

			//과제
			else if (inningGbn.Equals("6"))
			{
				inningTypeName = "과제";
			}

			//수업활동일지
			else if (inningGbn.Equals("7"))
            {
				inningTypeName = "수업활동일지";
			}

			//팀프로젝트
			else if (inningGbn.Equals("8"))
			{
				inningTypeName = "팀프로젝트";
			}

			return inningTypeName;
		}

		public string GetCategoryClass(string inningGbn)
        {
			string classGbn = "";

			//동영상(온라인 강의)
			if (inningGbn.Equals("1"))
			{
				classGbn = "category-04";
				
			}

			//대면(오프라인)
			else if (inningGbn.Equals("2"))
			{
				classGbn = "category-05";				
			}

			//동영상(실시간 강의)
			else if (inningGbn.Equals("3"))
			{
				classGbn = "category-04";				
			}

			//시험
			else if (inningGbn.Equals("4"))
			{
				classGbn = "category-02";				
			}

			//퀴즈
			else if (inningGbn.Equals("5"))
			{
				classGbn = "category-01";				
			}

			//과제
			else if (inningGbn.Equals("6"))
			{
				classGbn = "category-03";
			}
			
			//수업활동일지
			else if (inningGbn.Equals("7"))
			{
				classGbn = "category-06";
			}
			
			//팀프로젝트
			else if (inningGbn.Equals("8"))
			{
				classGbn = "category-07";
			}

			return classGbn;
		}

		public MvcHtmlString GetInningStatusTag(string inningGbn, string inningUserState, string inningProgress)
		{
			string inningStatusTag = "";

			//동영상(온라인 강의)
			if (inningGbn.Equals("1"))
			{
				//진행중
                if (inningProgress.Equals("Y"))
                {
					if (inningUserState.Equals("Y"))
					{
						inningStatusTag = "<span class=\"badge badge-scheduled\">출석</span>";
                    }
                    else
                    {
						inningStatusTag = "<span class=\"badge badge-ongoing\">진행예정</span>";
					}
                }

				//지난 학습
                else
                {
					if (inningUserState.Equals("Y"))
                    {
						inningStatusTag = "<span class=\"badge badge-scheduled\">출석</span>";
                    }
                    else
                    {
						inningStatusTag = "<span class=\"badge badge-completed\">결석</span>";
					}
				}
			}

			//대면(오프라인)
			else if (inningGbn.Equals("2"))
			{
				//진행중
				if (inningProgress.Equals("Y"))
				{
					if (inningUserState.Equals("Y"))
					{
						inningStatusTag = "<span class=\"badge badge-scheduled\">출석</span>";
					}
					else
					{
						inningStatusTag = "<span class=\"badge badge-ongoing\">진행예정</span>";
					}
				}

				//지난 학습
				else
				{
					if (inningUserState.Equals("Y"))
					{
						inningStatusTag = "<span class=\"badge badge-scheduled\">출석</span>";
					}
					else
					{
						inningStatusTag = "<span class=\"badge badge-completed\">결석</span>";
					}
				}
			}

			//동영상(실시간 강의)
			else if (inningGbn.Equals("3"))
			{
				//진행중
				if (inningProgress.Equals("Y"))
				{
					if (inningUserState.Equals("Y"))
					{
						inningStatusTag = "<span class=\"badge badge-scheduled\">출석</span>";
					}
					else
					{
						inningStatusTag = "<span class=\"badge badge-ongoing\">진행예정</span>";
					}
				}

				//지난 학습
				else
				{
					if (inningUserState.Equals("Y"))
					{
						inningStatusTag = "<span class=\"badge badge-scheduled\">출석</span>";
					}
					else
					{
						inningStatusTag = "<span class=\"badge badge-completed\">결석</span>";
					}
				}
			}

			//시험
			else if (inningGbn.Equals("4"))
			{
                if (inningUserState.Equals("미응시"))
                {
					inningStatusTag = "<span class=\"badge badge-scheduled\">" + inningUserState + "</span>";
				}
				else if (inningUserState.Equals("시험중"))
                {
					inningStatusTag = "<span class=\"badge badge-ongoing\">" + inningUserState + "</span>";
				}
				else if (inningUserState.Equals("응시완료"))
                {
					inningStatusTag = "<span class=\"badge badge-completed\">" + inningUserState + "</span>";
				}

			}

			//퀴즈
			else if (inningGbn.Equals("5"))
			{
				if (inningUserState.Equals("미응시"))
				{
					inningStatusTag = "<span class=\"badge badge-ongoing\">" + inningUserState + "</span>";
				}
				else if (inningUserState.Equals("시험중"))
				{
					inningStatusTag = "<span class=\"badge badge-scheduled\">" + inningUserState + "</span>";
				}
				else if (inningUserState.Equals("응시완료"))
				{
					inningStatusTag = "<span class=\"badge badge-completed\">" + inningUserState + "</span>";
				}
			}

			//과제
			else if (inningGbn.Equals("6"))
			{
				if (inningUserState.Equals("제출"))
				{
					inningStatusTag = "<span class=\"badge badge-completed\">" + inningUserState + "</span>";
				}
				else if (inningUserState.Equals("미제출"))
				{
					inningStatusTag = "<span class=\"badge badge-ongoing\">" + inningUserState + "</span>";
				}
			}

			//수업활동일지
			else if (inningGbn.Equals("7"))
			{
				if (inningUserState.Equals("제출"))
				{
					inningStatusTag = "<span class=\"badge badge-completed\">" + inningUserState + "</span>";
				}
				else if (inningUserState.Equals("미제출"))
				{
					inningStatusTag = "<span class=\"badge badge-ongoing\">" + inningUserState + "</span>";
				}
			}

			//팀프로젝트
			else if (inningGbn.Equals("8"))
			{
				if (inningUserState.Equals("제출"))
				{
					inningStatusTag = "<span class=\"badge badge-completed\">" + inningUserState + "</span>";
				}
				else if (inningUserState.Equals("미제출"))
				{
					inningStatusTag = "<span class=\"badge badge-ongoing\">" + inningUserState + "</span>";
				}
			}

			return MvcHtmlString.Create(inningStatusTag);
		}

		public MvcHtmlString GetHrefTag(string inningGbn, int courseNo, string title, Int64 ocwNo, int ocwType, int ocwSourceType, string ocwData
										, Int64? ocwFileGroupNo, int ocwWidth, int ocwHeight, int inningNo, string zoomURL, string inningEndDay )
        {
			string periodChkYN = WebConfigurationManager.AppSettings["PeriodChkYN"].ToString();

			DateTime Today = DateTime.Today;
			DateTime DateTimeEndDay = Convert.ToDateTime(inningEndDay);
			
			string hrefTag = "";

			//동영상(온라인 강의) 
			if (inningGbn.Equals("1"))
			{

				if (periodChkYN == "N")
				{
					if (DateTimeEndDay < Today)
					{
						hrefTag = "<a href=\"javascript:void(0)\" onclick=\"bootAlert('학습기간이 아닙니다.')\"class=\"card-title01 text-dark\">" + title + "</a>";
					}
				}
				else
				{
					hrefTag = string.Format("<a href=\"javascript:void(0);\" onclick=\"javascript:fnOcwView({0}, {1}, {2}, '{3}', {4}, {5}, {6}, 'frmpop', {7});\"" +
						"class=\"card-title01 text-dark\">" + title + "</a>", ocwNo, ocwType, ocwSourceType, ocwType == 1 ? (ocwData ?? "") : ocwSourceType == 0 ? ocwData : "", ocwFileGroupNo, ocwWidth, ocwHeight, inningNo);
				}
				
			}
						
			//대면(오프라인)
			else if (inningGbn.Equals("2"))
			{
				hrefTag = "<a href=\"javascript:void(0)\" onclick=\"bootAlert('" + title + "')\"class=\"card-title01 text-dark\">" + title + "</a>";
			}
		
			//동영상(실시간 강의)
			else if (inningGbn.Equals("3"))
			{
				if (!string.IsNullOrEmpty(zoomURL))
				{
					hrefTag = "<a href=" + zoomURL + " target=\"_blank\" class=\"card-title01 text-dark\">" + title + "</a>";
				}
				else
				{
					hrefTag = "<a href=\"javascript:void(0)\" onclick=\"bootAlert('실시간 화상 주소가 입력되지 않았습니다.')\"class=\"card-title01 text-dark\">" + title + "</a>";
					
				}
			}

			//시험
			else if (inningGbn.Equals("4"))
			{
				hrefTag = "<a href=\"/Exam/ListStudent/" + courseNo + "\" class=\"card-title01 text-dark\">" + title + "</a>";
			}

			//퀴즈
			else if (inningGbn.Equals("5"))
			{
				hrefTag = "<a href=\"/Quiz/ListStudent/" + courseNo + "\" class=\"card-title01 text-dark\">" + title + "</a>";
			}

			//과제
			else if (inningGbn.Equals("6"))
			{
				hrefTag = "<a href=\"/Homework/ListStudent/" + courseNo + "\" class=\"card-title01 text-dark\">" + title + "</a>";				
			}

			//수업활동일지
			else if (inningGbn.Equals("7"))
			{
				hrefTag = "<a href=\"/Report/List/" + courseNo + "\" class=\"card-title01 text-dark\">" + title + "</a>";							}

			//팀프로젝트
			else if (inningGbn.Equals("8"))
			{
				hrefTag = "<a href=\"/TeamProject/ListStudent/" + courseNo + "\" class=\"card-title01 text-dark\">" + title + "</a>";				
			}

			return MvcHtmlString.Create(hrefTag);
		}

		public MvcHtmlString GetHrefTagByInningLecture(string lessonForm, string lectureType, int courseNo, string contentTitle
													, Int64 ocwNo, int ocwType, int ocwSourceType, string ocwData , Int64? ocwFileGroupNo
													, int ocwWidth, int ocwHeight, int inningNo, string zoomURL, string inningEndDay)
        {

			string periodChkYN = WebConfigurationManager.AppSettings["PeriodChkYN"].ToString();

			DateTime Today = DateTime.Today;
			DateTime DateTimeEndDay = Convert.ToDateTime(inningEndDay);

			string hrefTag = "";
            
			//강의일 경우
			if (lessonForm.Equals("CINM001"))
			{
				//온라인일 경우
				if(lectureType.Equals("CINN001"))
                {

					if (periodChkYN == "N")
					{
						if (DateTimeEndDay < Today)
						{
							hrefTag = "<a href=\"javascript:void(0)\" onclick=\"bootAlert('학습기간이 아닙니다.')\" class=\"btn btn-lg btn-block btn-primary\">동영상 강의</a>";
						}
					}
					else
					{

						hrefTag = string.Format("<a href=\"javascript:void(0);\" onclick=\"javascript:fnOcwView({0}, {1}, {2}, '{3}', {4}, {5}, {6}, 'frmpop', {7});\"" +
							"class=\"btn btn-lg btn-block btn-primary\">동영상 강의</a>", ocwNo, ocwType, ocwSourceType, ocwType == 1 ? (ocwData ?? "") : "", ocwFileGroupNo, ocwWidth, ocwHeight, inningNo);

					}

				}
				
				//오프라인일 경우
				else if (lectureType.Equals("CINN002"))
                {
					hrefTag = "<a href=\"javascript:void(0)\" onclick=\"bootAlert('" + contentTitle + "')\" class=\"btn btn-lg btn-block btn-info\">대면 강의</a>";
				}
			}
            else
			{
				hrefTag = "<a href=\"/Exam/ListTeacher/" + courseNo + "\" class=\"btn btn-block btn-lg btn-point\">시험</a>";
			}

            if (!string.IsNullOrEmpty(zoomURL))
			{
				hrefTag += "<br><a href=\"" + zoomURL + "\" target=\"_blank\" class=\"btn btn-block btn-lg btn-outline-primary\">실시간 화상</a>";
            }


			return MvcHtmlString.Create(hrefTag);
		}

		public MvcHtmlString GetHrefTagByInningHomework(int isHomework, int courseNo, int week, int inningNo)
        {
			string hrefTag = "";

			if (isHomework > 0)
			{
				hrefTag = "<a href=\"/Homework/ListTeacher/" + courseNo + "\" class=\"btn btn-block btn-lg btn-outline-success\">과제 <span class=\"badge badge-success\">" + isHomework.ToString() + "건</span></a>";

            }
            else
            {
				hrefTag = "<a href=\"/Homework/Write/" + courseNo + "?week=" + week + "&inningNo=" + inningNo + "\" class=\"btn btn-block btn-lg btn-outline-danger\">과제 미출제</a>";
			}

			return MvcHtmlString.Create(hrefTag);
		}

		public MvcHtmlString GetHrefTagByInningQuiz(int isQuiz, int courseNo, int week, int inningNo)
        {
			string hrefTag = "";

			if (isQuiz > 0)
			{
				hrefTag = "<a href=\"/Quiz/ListTeacher/" + courseNo + "\" class=\"btn btn-block btn-lg btn-outline-secondary\">퀴즈 <span class=\"badge badge-secondary\">" + isQuiz.ToString() + "건</span></a>";

			}
			else
			{
				hrefTag = "<a href=\"/Quiz/Write/" + courseNo + "?week=" + week + "&inningNo=" + inningNo + "\" class=\"btn btn-block btn-lg btn-outline-danger\">퀴즈 미출제</a>";
			}

			return MvcHtmlString.Create(hrefTag);
		}

		public MvcHtmlString GetWeekAttendanceStatus()
		{
			int maxInning = Inning.Max(c => c.InningSeqNo);
			int maxWeek = Inning.Max(c => c.Week);
			StringBuilder htmlText = new StringBuilder();
			for (int i = 1; i <= maxInning; i++)
			{
				htmlText.Append(string.Format("<tr><td class=\"text-center\">{0}차시</td>", i));
				for (int k = 1; k <= maxWeek; k++)
				{
					var tempInning = Inning.Where(c => c.Week == k && c.InningSeqNo == i).FirstOrDefault();
					if (tempInning != null)
					{

						var tempAttInfo = StudyInningInfo.FirstOrDefault(c => c.InningNo == tempInning.InningNo);

						string flag = "-";
						if (tempAttInfo != null)
						{
							flag = GetAttendanceFlag(tempAttInfo.AttendanceStatus);
						}

						if (tempInning.LessonForm.Equals("CINM001") && (tempInning.LectureType.Equals("CINN001") || tempInning.LectureType.Equals("CINN002")) || (!tempInning.LMSContentsNo.Equals(0) || !string.IsNullOrEmpty(tempInning.ZoomURL)))
						{
							if (tempInning.LectureType.Equals("CINN001"))
							{
								htmlText.Append(string.Format("<td class=\"text-center text-primary\">{0}</td>", flag));
							}
							else
							{
								htmlText.Append(string.Format("<td class=\"text-center text-danger\">{0}</td>", flag));
							}
						}
						else 
						{

							if (tempInning.LectureType.Equals("CINN001"))
							{
								htmlText.Append(string.Format("<td class=\"text-center text-primary\">{0}</td>", "-"));
							}
							else
							{
								htmlText.Append(string.Format("<td class=\"text-center text-danger\">{0}</td>", "-"));
							}
						}
					}
					else
					{
						htmlText.Append(string.Format("<td class=\"text-center\">{0}</td>", "-"));
					}

				}
				htmlText.Append("</tr>");
			}

			return MvcHtmlString.Create(htmlText.ToString());
		}

		private string GetAttendanceFlag(string paramStatusCode)
		{
			string rs = "";
			if (paramStatusCode.Equals("CLAT001")) //출석
			{
				rs = "O";
			}
			else if (paramStatusCode.Equals("CLAT002")) //결석
			{
				rs = "&#47;";
			}
			else if (paramStatusCode.Equals("CLAT003")) //지각
			{
				rs = "X";
			}
			else if (paramStatusCode.Equals("CLAT005")) //조퇴
			{
				rs = "△";
			}
			else if (paramStatusCode.Equals("CLAT004")) //미체크
			{
				rs = "&#47;"; // 미체크여도 결석으로 표기되도록 요청
			}
			return rs;
		}

		[Display(Name = "HangulName 배열")]
		public string[] HangulNameArray { get; set; }

		[Display(Name = "UserID 배열")]
		public string[] UserIDArray { get; set; }

		[Display(Name = "UserNo 배열")]
		public string[] UserNoArray { get; set; }

		[Display(Name = "LectureRequestDay 배열")]
		public string[] LectureRequestDayArray { get; set; }

		[Display(Name = "LectureStatusName 배열")]
		public string[] LectureStatusNameArray { get; set; }

		[Display(Name = "UploadGubun 배열")]
		public string[] UploadGubunArray { get; set; }

		[Display(Name = "LatenessSetupDay")]
		public int LatenessSetupDay { get; set; }

	}
}
