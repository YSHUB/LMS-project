using ILMS.Data.Dao;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Configuration;

namespace ILMS.Service
{
	public class CourseService
	{
		public CourseDao courseDao { get; set; }

		public BaseDAO baseDao { get; set; }

		public IList<Grade> GradeList(IList<Course> GradeDivisionCourseList, EstimationItemBasis EstimationBasis, IList<EstimationItemBasis> EstimationItemBasis, IList<EstimationItemBasis> ParticipationEstimationItemBasis)
		{
			IList<Grade> GradeList = new List<Grade>();

			#region 벌점 체크
			decimal LatenessPenalty = 0;
			decimal AbsencePenalty = 0;
			try
			{
				if (EstimationBasis.AttendanceAutoPassiveYesNo == "Y")
				{
					//지각벌점
					LatenessPenalty = (decimal)0.1;

					//결석벌점
					AbsencePenalty = (decimal)0.3;
				}
				else
				{
					//지각벌점
					LatenessPenalty = EstimationBasis.LatenessPenaltyValue;

					//결석벌점
					AbsencePenalty = EstimationBasis.AbsencePenaltyValue;
				}
			}
			catch (Exception ex)
			{
				string strErrorMessage = ex.Message;
				return null;
			}
			#endregion

			#region 비율 정보 및 기준 정보
			string UnivName = WebConfigurationManager.AppSettings["UnivName"];
			decimal? dtemp = 0;

			//중간고사비율
			if (!UnivName.Equals("동주대학교"))
			{
				dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT001")).FirstOrDefault().RateScore;
			}
			decimal MidtermExamRatio = dtemp ?? 0;

			//기말시험비율
			if (!UnivName.Equals("동주대학교"))
			{
				dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT002")).FirstOrDefault().RateScore;
			}
			decimal FinalExamRatio = dtemp ?? 0;

			//퀴즈비율
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT003")).FirstOrDefault().RateScore;
			decimal QuizRatio = dtemp ?? 0;

			//과제비율
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT004")).FirstOrDefault().RateScore;
			decimal HomeworkRatio = dtemp ?? 0;

			//팀프로젝트비율
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT005")).FirstOrDefault().RateScore;
			decimal TeamProjectRatio = dtemp ?? 0;

			//출석비율
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT006")).FirstOrDefault().RateScore;
			decimal AttendanceRatio = dtemp ?? 0;

			//기타비율
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT007")).FirstOrDefault().RateScore;
			decimal EtcRatio = dtemp ?? 0;
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT008")).FirstOrDefault().RateScore;
			decimal Etc2Ratio = dtemp ?? 0;
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT010")).FirstOrDefault().RateScore;
			decimal Etc3Ratio = dtemp ?? 0;

			//발표비율
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT011")).FirstOrDefault().RateScore;
			decimal AnnounceRatio = dtemp ?? 0;

			//역량비율
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT012")).FirstOrDefault().RateScore;
			decimal AbilityRatio = dtemp ?? 0;
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT013")).FirstOrDefault().RateScore;
			decimal Ability2Ratio = dtemp ?? 0;
			dtemp = EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT014")).FirstOrDefault().RateScore;
			decimal Ability3Ratio = dtemp ?? 0;

			//강의Q&A 
			dtemp = ParticipationEstimationItemBasis.Where(c => c.ParticipationItemGubun.Equals("CPGB001")).FirstOrDefault().RateScore;
			decimal QnaRatio = dtemp ?? 0;

			dtemp = ParticipationEstimationItemBasis.Where(c => c.ParticipationItemGubun.Equals("CPGB001")).FirstOrDefault().BasisScore;
			decimal QnaBasisScore = dtemp ?? 0;

			//토론방
			dtemp = ParticipationEstimationItemBasis.Where(c => c.ParticipationItemGubun.Equals("CPGB003")).FirstOrDefault().RateScore;
			decimal DiscussionRatio = dtemp ?? 0;
			dtemp = ParticipationEstimationItemBasis.Where(c => c.ParticipationItemGubun.Equals("CPGB003")).FirstOrDefault().BasisScore;
			decimal DiscussionBasisScore = dtemp ?? 0;

			//자유게시판
			dtemp = (ParticipationEstimationItemBasis.Where(c => c.ParticipationItemGubun.Equals("CPGB006")).FirstOrDefault() ?? new EstimationItemBasis()).RateScore;
			decimal FreeBoardRatio = dtemp ?? 0;
			dtemp = (ParticipationEstimationItemBasis.Where(c => c.ParticipationItemGubun.Equals("CPGB006")).FirstOrDefault() ?? new EstimationItemBasis()).BasisScore;
			decimal FreeBoardBasisScore = dtemp ?? 0;

			//자기소개
			dtemp = (ParticipationEstimationItemBasis.Where(c => c.ParticipationItemGubun.Equals("CPGB007")).FirstOrDefault() ?? new EstimationItemBasis()).RateScore;
			decimal IntroduceBoardRatio = dtemp ?? 0;
			dtemp = (ParticipationEstimationItemBasis.Where(c => c.ParticipationItemGubun.Equals("CPGB007")).FirstOrDefault() ?? new EstimationItemBasis()).BasisScore;
			decimal IntroduceBoardBasisScore = dtemp ?? 0;

			#endregion

			string EstimationType = EstimationBasis.EstimationType;

			IList<ILMS.Design.Domain.Grade.EstimationABSStandard> AbsStandard = new List<ILMS.Design.Domain.Grade.EstimationABSStandard>();

			foreach (var CourseItem in GradeDivisionCourseList)
			{
				Grade grade = new Grade();
				grade.CourseNo = CourseItem.CourseNo;

				IList<Grade> GradeSavedList = baseDao.GetList<Grade>("course.COURSE_GRADE_SELECT_G", grade);

				#region 수강생정보

				IList<Student> StudentList = new List<Student>();

				Hashtable paramHash = new Hashtable();

				paramHash.Add("RowState", "B");
				paramHash.Add("CourseNo", CourseItem.CourseNo);

				StudentList = baseDao.GetList<Student>("course.COURSE_LECTURE_SELECT_B", paramHash);

				#endregion

				#region 이닝정보

				paramHash = new Hashtable();

				paramHash.Add("RowState", "L");
				paramHash.Add("CourseNo", CourseItem.CourseNo);

				IList<Inning> InningLIst = baseDao.GetList<Inning>("course.COURSE_INNING_SELECT_L", paramHash);

				decimal TotalInning = InningLIst.Count();

				//불필요하게 15주차에 차시 만들어 두면 1/3 결석자로 나올수 있음
				decimal TotalStudyTime = 0;
				decimal MiddleExamPoint = 0;
				decimal LastExamPoint = 0;

				//일반적인 차시일경우 지각이 있기 때문에 지각 종료일을 기준으로 함
				TotalStudyTime = InningLIst.Where(c => c.LectureType.Equals("CINN001") && DateTime.Parse(c.InningLatenessEndDay) <= DateTime.Now).Sum(c => c.AttendanceTime);

				MiddleExamPoint = InningLIst.Where(c => c.LessonForm.Equals("CINM002")).Sum(c => c.AttendanceTime);
				LastExamPoint = InningLIst.Where(c => c.LessonForm.Equals("CINM003")).Sum(c => c.AttendanceTime);

				#endregion

				#region 시험 정보

				Examinee examinee = new Examinee("L");
				examinee.CourseNo = CourseItem.CourseNo;

				IList<Examinee> ExamineeList = baseDao.GetList<Examinee>("exam.EXAMINEE_SELECT_L", examinee);

				Exam exam = new Exam("S");
				exam.CourseNo = CourseItem.CourseNo;
				exam.ExamItem = "CHEK001";
				exam.Gubun = "E";

				Exam MidtermExam = baseDao.Get<Exam>("exam.EXAM_SELECT_S", exam);

				decimal MidtermExamPerfectScore = 100;
				decimal MidExamToHomeworkPerfectScore = 100; //시험대체형의 만점

				if(MidtermExam != null)
				{
					if(MidtermExam.TakeType == "EXST001") //온라인시험
					{
						if(EstimationBasis.PerfectionHandleBasis == "CPHB001") //100점 만점 처리
						{
							MidtermExamPerfectScore = 100;
						}
						else
						{
							Homework homework = new Homework("L");
							homework.CourseNo = CourseItem.CourseNo;

							MidExamToHomeworkPerfectScore = (decimal)((baseDao.GetList<Homework>("homework.HOMEWORK_SELECT_L", homework).Where(w => w.ExamKind == "CHEK001" && w.HomeworkType == "CHWT003" && w.DeleteYesNo == "N").FirstOrDefault() ?? new Homework()).Weighting);
						}
					}
					else
					{
						if (EstimationBasis.PerfectionHandleBasis == "CPHB001") //100점 만점 처리
						{
							MidtermExamPerfectScore = 100;
						}
						else
						{
							Homework homework = new Homework("L");
							homework.CourseNo = CourseItem.CourseNo;

							MidtermExamPerfectScore = EstimationItemBasis.Where(c => c.EstimationItemGubun == "CEIT001").FirstOrDefault().RateScore;

							MidExamToHomeworkPerfectScore = (decimal)((baseDao.GetList<Homework>("homework.HOMEWORK_SELECT_L", homework).Where(w => w.ExamKind == "CHEK001" && w.HomeworkType == "CHWT003" && w.DeleteYesNo == "N").FirstOrDefault() ?? new Homework()).Weighting);
						}
					}
				}

				string MidtermExamKind = "CHEK001";

				Hashtable hashtable = new Hashtable();
				hashtable.Add("CourseNo", CourseItem.CourseNo);
				hashtable.Add("ExamKind", MidtermExamKind);

				string MidExamChallengesTypeExamYesNo = baseDao.Get<string>("course.COURSE_GRADE_SELECT_A", hashtable);

				if (MidExamChallengesTypeExamYesNo == "Y")
				{
					if(EstimationBasis.PerfectionHandleBasis == "CPHB001")
					{
						MidtermExamPerfectScore = 100;
					}
					else
					{
						MidtermExamPerfectScore = baseDao.Get<int>("course.COURSE_GRADE_SELECT_B", hashtable);
					}
				}

				exam = new Exam("S");
				exam.CourseNo = CourseItem.CourseNo;
				exam.ExamItem = "CHEK002";

				Exam FinaltermExam = baseDao.Get<Exam>("exam.EXAM_SELECT_S", exam);

				decimal FinalExamPerfectScore = 100;
				decimal FinalExamToHomeworkPerfectScore = 100; //시험대체형의 만점

				if (FinaltermExam != null)
				{
					if (FinaltermExam.TakeType == "EXST001") //온라인시험
					{
						if (EstimationBasis.PerfectionHandleBasis == "CPHB001") //100점 만점 처리
						{
							FinalExamPerfectScore = 100;
						}
						else
						{
							Homework homework = new Homework("L");
							homework.CourseNo = CourseItem.CourseNo;

							FinalExamToHomeworkPerfectScore = (decimal)((baseDao.GetList<Homework>("homework.HOMEWORK_SELECT_L").Where(w => w.ExamKind == "CHEK002" && w.HomeworkType == "CHWT003" && w.DeleteYesNo == "N").FirstOrDefault() ?? new Homework()).Weighting);
						}
					}
					else
					{
						if (EstimationBasis.PerfectionHandleBasis == "CPHB001") //100점 만점 처리
						{
							FinalExamPerfectScore = 100;
						}
						else
						{
							FinalExamPerfectScore = EstimationItemBasis.Where(c => c.EstimationItemGubun == "CEIT002").FirstOrDefault().RateScore;

							FinalExamToHomeworkPerfectScore = (decimal)((baseDao.GetList<Homework>("homework.HOMEWORK_SELECT_L").Where(w => w.ExamKind == "CHEK002" && w.HomeworkType == "CHWT003" && w.DeleteYesNo == "N").FirstOrDefault() ?? new Homework()).Weighting);
						}
					}
				}

				string FinaltermExamKind = "CHEK002";

				hashtable = new Hashtable();
				hashtable.Add("CourseNo", CourseItem.CourseNo);
				hashtable.Add("ExamKind", FinaltermExamKind);

				string FinalExamChallengesTypeExamYesNo = baseDao.Get<string>("course.COURSE_GRADE_SELECT_A", hashtable);

				if (FinalExamChallengesTypeExamYesNo == "Y")
				{
					if (EstimationBasis.PerfectionHandleBasis == "CPHB001")
					{
						FinalExamPerfectScore = 100;
					}
					else
					{
						FinalExamPerfectScore = baseDao.Get<int>("course.COURSE_GRADE_SELECT_B", hashtable);
					}
				}

				#endregion

				#region 퀴즈 정보

				ExamQuestion examquestion = new ExamQuestion("E");
				examquestion.CourseNo = CourseItem.CourseNo;
				examquestion.Gubun = "Q";

				IList<ExamQuestion> ExamQuestionList = baseDao.GetList<ExamQuestion>("course.COURSE_GRADE_SELECT_E", examquestion); //임시

				decimal QuizPerfectScore = 100;

				//퀴즈는 오프라인이 없기때문에 온라인의 경우만 처리
				if (ExamQuestionList != null)
				{
					// 100점 만점 처리
					if (EstimationBasis.PerfectionHandleBasis == "CPHB001")
					{
						// 출제된 점수
						QuizPerfectScore = 100;
					}
					else
					{
						//비율만점 처리 시
						QuizPerfectScore = 0;

						for(int i = 0; i < ExamQuestionList.Count; i++)
						{
							QuizPerfectScore += (ExamQuestionList[i].RowNum * (int)ExamQuestionList[i].EachScore);
						}
						if(CourseItem.CourseNo > 0)
						{
							hashtable = new Hashtable();
							hashtable.Add("Rowstate", "F");
							hashtable.Add("CourseNo", CourseItem.CourseNo);
							QuizPerfectScore = baseDao.Get<int>("course.COURSE_GRADE_SELECT_F", hashtable);
						}
					}
				}

				#endregion

				#region 과제정보
				Homework homework_new = new Homework("L");
				homework_new.CourseNo = CourseItem.CourseNo;

				IList<Homework> HomeworkList = baseDao.GetList<Homework>("homework.HOMEWORK_SELECT_L", homework_new);

				decimal HomeWorkPerfectScore = HomeworkList.Where(c => c.IsOutput == 0).Sum(c => c.Weighting);

				HomeworkSubmit homeworksubmit = new HomeworkSubmit("L");
				homeworksubmit.CourseNo = CourseItem.CourseNo;

				IList<HomeworkSubmit> courseHomeworkSubmitList = baseDao.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit).Where(c => c.IsOutput == 0 && (c.HomeworkType.Equals("CHWT001") || c.HomeworkType.Equals("CHWT004"))).ToList();
				#endregion

				#region 팀프로젝트 정보

				Hashtable teamproject = new Hashtable();
				teamproject.Add("CourseNo", CourseItem.CourseNo);

				IList<TeamProject> TeamProjectList = baseDao.GetList<TeamProject>("teamProject.TEAMPROJECT_SELECT_L", teamproject);

				decimal TeamProjectPerfectScore = TeamProjectList.Where(c => c.IsOutput == 0).Count() * 100;

				TeamProjectSubmit teamprojectsubmit = new TeamProjectSubmit();
				teamprojectsubmit.CourseNo = CourseItem.CourseNo;

				IList<TeamProjectSubmit> TeamProjectSubmitList = baseDao.GetList<TeamProjectSubmit>("teamProject.TEAMPROJECT_SUBMIT_SELECT_L", teamprojectsubmit).Where(c => c.IsOutput == 0).ToList();
				#endregion

				#region 출석정보
				decimal AttendancePerfectScore = 100;

				hashtable = new Hashtable();
				hashtable.Add("CourseNo", CourseItem.CourseNo);

				IList<Inning> studyInningList = baseDao.GetList<Inning>("course.COURSE_GRADE_SELECT_C", hashtable);

				#endregion

				#region 참여도 정보

				CourseLecture courseparticipation = new CourseLecture();
				courseparticipation.CourseNo = CourseItem.CourseNo;

				IList<CourseLecture> LectureParicipationList = baseDao.GetList<CourseLecture>("course.COURSE_LECTURE_SELECT_C", courseparticipation);

				#endregion

				#region 기타 정보
				IList<CourseLecture> CourseEtcList = baseDao.GetList<CourseLecture>("course.COURSE_GRADE_SELECT_D", courseparticipation);
				#endregion

				foreach (var item in StudentList)
				{
					Grade Grade = new Grade();

					#region 학생 기초 정보

					Grade.CourseNo = CourseItem.CourseNo;
					Grade.LectureNo = item.LectureNo;
					Grade.CampusName = CourseItem.CampusName;
					Grade.ClassNo = CourseItem.ClassNo;
					Grade.UserNo = item.UserNo;
					Grade.HangulName = item.HangulName;
					Grade.AssignName = item.AssignName;
					//Grade.UserTypeName = item.UserTypeName;
					Grade.UserID = item.UserID;
					//Grade.StudentNo = item.StudentNo;
					//Grade.UniversityName = item.UniversityName;
					Grade.ForeignYesNo = item.ForeignYesNo;
					//Grade.Grade2 = item.Grade2;
					//Grade.Lecture_part = CourseItem.Lecture_part;
					Grade.IsPass = item.IsPass;
					Grade.PrintNum = item.PrintNum;
					Grade.CompleteScore = item.CompleteScore;
					#endregion

					#region 중간 고사
					// 중간고사 및 기말고사 과제형 시험일때 과제 점수를 시험쪽으로 끌고오는 로직 필요
					decimal MidtermExamScore = 0;
					bool isExamToHomework = false;

					if (MidtermExamRatio > 0)
					{
						if (ExamineeList != null)
						{
							if (ExamineeList.Where(c => c.ExamineeUserNo == item.UserNo && c.ExamType.Equals("CHEK001")).Count() > 0)
							{
								//시험대체자 시험대체형과제점수 가져오기                                  
								Examinee ce = ExamineeList.Where(c => c.ExamineeUserNo == item.UserNo && c.ExamType.Equals("CHEK001")).OrderByDescending(c => c.ExamineeNo).FirstOrDefault();
								if (ce.ExamTotalScore != 0)
								{
									if (ce.ExamGubun == "EXTP003" || ce.ExamGubun == "EXTP004")//오프시험대체, 온라인시험대체
									{
										//시험대체형이니깐 만점도 시험대체형 과제의 만점을 가지고 온다.
										isExamToHomework = true;
									}
									else if (EstimationBasis.PerfectionHandleBasis.Equals("CPHB002") && !string.IsNullOrEmpty(ce.TakeType) && ce.TakeType.Equals("EXST001")) //온라인, 비율만점 일 때
									{
										//추가시험에 따른 학습자별 중간고사 만점기준 가져오기
										examquestion = new ExamQuestion("H");
										examquestion.ExamNo = ce.ExamNo;

										IList<ExamQuestion> MidExamQuestionList = baseDao.GetList<ExamQuestion>("course.COURSE_GRADE_SELECT_H", examquestion); //임시

										for(int i = 0; i < MidExamQuestionList.Count; i++)
										{
											int MidPerfect = 0;
											MidPerfect += MidExamQuestionList[i].RowNum * (int)MidExamQuestionList[i].EachScore;

											MidtermExamPerfectScore = MidPerfect;
										}

									}
									MidtermExamScore = (decimal)ce.ExamTotalScore;
								}
							}
						}
						if (isExamToHomework)
						{
							//시험대체형은 시험대체형과제의 만점으로 계산
							Grade.MidtermExamPerfectScore = MidExamToHomeworkPerfectScore;
							Grade.MidtermExamScore = MidtermExamScore;
							Grade.MidtermExam = MidExamToHomeworkPerfectScore == 0 ? 0 : (MidtermExamScore / MidExamToHomeworkPerfectScore) * MidtermExamRatio;
						}
						else
						{
							Grade.MidtermExamPerfectScore = MidtermExamPerfectScore;
							Grade.MidtermExamScore = MidtermExamScore;
							Grade.MidtermExam = MidtermExamPerfectScore == 0 ? 0 : (MidtermExamScore / MidtermExamPerfectScore) * MidtermExamRatio;
						}
					}
					else
					{
						Grade.MidtermExamPerfectScore = 0;
						Grade.MidtermExamScore = 0;
						Grade.MidtermExam = 0;
					}


					//중간고사가 과제형시험이면
					if (MidExamChallengesTypeExamYesNo == "Y")
					{
						// 과제형 중간고사는 과제라서 재시험 개념이 없기때문에 하나만 가져옴
						HomeworkSubmit midtemp = baseDao.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit).Where(c => c.UserNo == item.UserNo && c.HomeworkType.Equals("CHWT002") && c.ExamKind.Equals("CHEK001")).FirstOrDefault(); //CHEK001 은중간고사 CHWT002 은 과제형시험
						if (midtemp != null)
						{
							MidtermExamScore = midtemp.Score ?? 0;
						}
						else
						{
							MidtermExamScore = 0;
						}

						Grade.MidtermExamPerfectScore = MidtermExamPerfectScore;
						Grade.MidtermExamScore = MidtermExamScore;
						Grade.MidtermExam = MidtermExamPerfectScore == 0 ? 0 : (MidtermExamScore / MidtermExamPerfectScore) * MidtermExamRatio;

					}

					#endregion

					#region 기말 고사
					decimal FinalExamScore = 0;
					bool isExamToHomeworkFinal = false;
					if (FinalExamRatio > 0)
					{
						if (ExamineeList != null)
						{
							if (ExamineeList.Where(c => c.ExamineeUserNo == item.UserNo && c.ExamType.Equals("CHEK002")).Count() > 0)
							{
								Examinee ce = ExamineeList.Where(c => c.ExamineeUserNo == item.UserNo && c.ExamType.Equals("CHEK002")).OrderByDescending(c => c.ExamineeNo).FirstOrDefault();
								if (ce.ExamTotalScore != 0)
								{
									if (ce.ExamGubun == "EXTP003" || ce.ExamGubun == "EXTP004")//오프시험대체, 온라인시험대체
									{
										//시험대체형이니깐 만점도 시험대체형 과제의 만점을 가지고 온다.
										isExamToHomeworkFinal = true;
									}
									else if (EstimationBasis.PerfectionHandleBasis.Equals("CPHB002") && !string.IsNullOrEmpty(ce.TakeType) && ce.TakeType.Equals("EXST001")) //온라인, 비율만점 일 때
									{
										//추가시험에 따른 학습자별 기말고사 만점기준 가져오기
										examquestion = new ExamQuestion("H");
										examquestion.ExamNo = ce.ExamNo;

										IList<ExamQuestion> FinalExamQuestionList = baseDao.GetList<ExamQuestion>("course.COURSE_GRADE_SELECT_H", examquestion); //임시

										for (int i = 0; i < FinalExamQuestionList.Count; i++)
										{
											int FinalPerfect = 0;
											FinalPerfect += FinalExamQuestionList[i].RowNum * (int)FinalExamQuestionList[i].EachScore;

											FinalExamPerfectScore = FinalPerfect;
										}
									}
									FinalExamScore = (decimal)ce.ExamTotalScore;
								}

							}
						}

						if (isExamToHomeworkFinal)
						{
							//시험대체형은 시험대체형과제의 만점으로 계산
							Grade.FinalExamPerfectScore = FinalExamToHomeworkPerfectScore;
							Grade.FinalExamScore = FinalExamScore;
							Grade.FinalExam = FinalExamToHomeworkPerfectScore == 0 ? 0 : (FinalExamScore / FinalExamToHomeworkPerfectScore) * FinalExamRatio;
						}
						else
						{
							Grade.FinalExamPerfectScore = FinalExamPerfectScore;
							Grade.FinalExamScore = FinalExamScore;
							Grade.FinalExam = FinalExamPerfectScore == 0 ? 0 : (FinalExamScore / FinalExamPerfectScore) * FinalExamRatio;
						}
					}
					else
					{
						Grade.FinalExamPerfectScore = 0;
						Grade.FinalExamScore = 0;
						Grade.FinalExam = 0;
					}

					//기말고사가 과제형시험이면
					if (FinalExamChallengesTypeExamYesNo == "Y")
					{
						// 과제형 중간고사는 과제라서 재시험 개념이 없기때문에 하나만 가져옴
						HomeworkSubmit finaltemp = baseDao.GetList<HomeworkSubmit>("homework.HOMEWORK_SUBMIT_SELECT_L", homeworksubmit).Where(c => c.UserNo == item.UserNo && c.HomeworkType.Equals("CHWT002") && c.ExamKind.Equals("CHEK002")).FirstOrDefault(); //CHEK002 기말고사 CHWT002 은 과제형시험
						if (finaltemp != null)
						{
							FinalExamScore = finaltemp.Score ?? 0;
						}
						else
						{
							FinalExamScore = 0;
						}

						Grade.FinalExamPerfectScore = FinalExamPerfectScore;
						Grade.FinalExamScore = FinalExamScore;
						Grade.FinalExam = FinalExamPerfectScore == 0 ? 0 : (FinalExamScore / FinalExamPerfectScore) * FinalExamRatio;
					}
					#endregion

					#region 출석 처리
					if (AttendanceRatio > 0)
					{
						decimal TotalInningCnt = studyInningList.Count(c => c.UserNo == item.UserNo);
						decimal TotalAttendance = studyInningList.Count(c => c.UserNo == item.UserNo && c.AttendanceStatus.ToString().Equals("CLAT001"));
						decimal TotalLateness = studyInningList.Count(c => c.UserNo == item.UserNo && c.AttendanceStatus.ToString().Equals("CLAT003"));
						decimal TotalEarlyLeave = studyInningList.Count(c => c.UserNo == item.UserNo && c.AttendanceStatus.ToString().Equals("CLAT005"));

						//출석점수 학칙 - 조퇴 3회시 결석1회로 처리
						decimal TotalAbsence = studyInningList.Count(c => c.UserNo == item.UserNo && (c.AttendanceStatus.ToString().Equals("CLAT002") || c.AttendanceStatus.ToString().Equals("CLAT004"))) + Math.Floor(TotalEarlyLeave / 3);

						Grade.AttendancePerfectScore = AttendancePerfectScore;
						Grade.AttendanceScore = TotalInningCnt < 1 ? 0 : Math.Round((TotalAttendance + (TotalEarlyLeave / 3)) / TotalInningCnt * 100, 2, MidpointRounding.AwayFromZero);
						Grade.Attendance = Grade.AttendanceScore * (AttendanceRatio / 100);

					}
					else
					{
						Grade.AttendancePerfectScore = 0;
						Grade.AttendanceScore = 0;
						Grade.Attendance = 0;
					}

					if (Grade.AttendanceScore < 0)
						Grade.AttendanceScore = 0;

					if (Grade.Attendance < 0)
						Grade.Attendance = 0;

					#endregion

					#region 과제 처리
					decimal HomeWorkScore = 0;

					if (HomeworkRatio > 0 && HomeWorkPerfectScore > 0)
					{
						if (courseHomeworkSubmitList != null)
						{
							HomeWorkScore = (int)courseHomeworkSubmitList.Where(c => c.UserNo == item.UserNo).Sum(c => c.Score);
						}

						Grade.HomeWorkPerfectScore = HomeWorkPerfectScore;
						Grade.HomeWorkScore = HomeWorkScore;
						Grade.HomeWork = HomeWorkScore / HomeWorkPerfectScore * HomeworkRatio;

					}
					else
					{
						Grade.HomeWorkPerfectScore = 0;
						Grade.HomeWorkScore = 0;
						Grade.HomeWork = 0;
					}
					#endregion

					#region 퀴즈 처리
					decimal QuizScore = 0;

					if (QuizRatio > 0 && QuizPerfectScore > 0)
					{
						if (ExamineeList != null)
						{
							if (ExamineeList.Where(c => c.ExamineeUserNo == item.UserNo && c.ExamType.Equals("CHEK003")).Count() > 0)
								QuizScore = (int)ExamineeList.Where(c => c.ExamineeUserNo.Equals(item.UserNo) && c.ExamType.Equals("CHEK003")).Sum(c => c.ExamTotalScore);
						}
						Grade.QuizPerfectScore = QuizPerfectScore;
						Grade.QuizScore = QuizScore;
						Grade.Quiz = (QuizScore / QuizPerfectScore) * QuizRatio;
					}
					else
					{
						Grade.QuizPerfectScore = 0;
						Grade.QuizScore = 0;
						Grade.Quiz = 0;
					}
					#endregion

					#region 팀프로젝트 처리
					decimal TeamPorjectScore = 0;

					if (TeamProjectRatio > 0 && TeamProjectPerfectScore > 0)
					{
						if (TeamProjectSubmitList != null)
						{
							TeamPorjectScore = (int)TeamProjectSubmitList.Where(c => c.UserNo == item.UserNo).Sum(c => c.Score);
						}

						Grade.TeamProjectPerfectScore = TeamProjectPerfectScore;
						Grade.TeamProjectScore = TeamPorjectScore;
						Grade.TeamProject = (TeamPorjectScore / TeamProjectPerfectScore) * TeamProjectRatio;
					}
					else
					{
						Grade.TeamProjectPerfectScore = 0;
						Grade.TeamProjectScore = 0;
						Grade.TeamProject = 0;
					}
					#endregion

					#region 기타항목 정리
					decimal EtcScore = 0;
					decimal Etc2Score = 0;
					decimal Etc3Score = 0;
					decimal AnnounceScore = 0;
					decimal AbilityScore = 0;
					decimal Ability2Score = 0;
					decimal Ability3Score = 0;

					CourseEtcList = baseDao.GetList<CourseLecture>("course.COURSE_GRADE_SELECT_D", courseparticipation);

					if (EtcRatio > 0)
					{
						if (CourseEtcList != null)
						{
							CourseLecture courseEtc = CourseEtcList.Where(c => c.UserNo == item.UserNo && c.PointType.Equals("CEIT007")).FirstOrDefault();
							EtcScore = courseEtc != null ? courseEtc.Point : 0;
						}

						Grade.EtcScore = EtcScore;
						Grade.Etc = EtcScore;
					}
					else
					{
						Grade.EtcScore = 0;
						Grade.Etc = 0;
					}
					if (Etc2Ratio > 0)
					{
						if (CourseEtcList != null)
						{
							CourseLecture courseEtc2 = CourseEtcList.Where(c => c.UserNo == item.UserNo && c.PointType.Equals("CEIT008")).FirstOrDefault();
							Etc2Score = courseEtc2 != null ? courseEtc2.Point : 0;
						}

						Grade.Etc2Score = Etc2Score;
						Grade.Etc2 = Etc2Score;
					}
					else
					{
						Grade.Etc2Score = 0;
						Grade.Etc2 = 0;
					}
					if (Etc3Ratio > 0)
					{
						if (CourseEtcList != null)
						{
							CourseLecture courseEtc3 = CourseEtcList.Where(c => c.UserNo == item.UserNo && c.PointType.Equals("CEIT010")).FirstOrDefault();
							Etc3Score = courseEtc3 != null ? courseEtc3.Point : 0;
						}

						Grade.Etc3Score = Etc3Score;
						Grade.Etc3 = Etc3Score;
					}
					else
					{
						Grade.Etc3Score = 0;
						Grade.Etc3 = 0;
					}
					if (AnnounceRatio > 0)
					{
						if (CourseEtcList != null)
						{
							CourseLecture courseAnnounce = CourseEtcList.Where(c => c.UserNo == item.UserNo && c.PointType.Equals("CEIT011")).FirstOrDefault();
							AnnounceScore = courseAnnounce != null ? courseAnnounce.Point : 0;
						}

						Grade.AnnounceScore = AnnounceScore;
						Grade.Announce = AnnounceScore;
					}
					else
					{
						Grade.AnnounceScore = 0;
						Grade.Announce = 0;
					}
					if (AbilityRatio > 0)
					{
						if (CourseEtcList != null)
						{
							CourseLecture courseAbility = CourseEtcList.Where(c => c.UserNo == item.UserNo && c.PointType.Equals("CEIT012")).FirstOrDefault();
							AbilityScore = courseAbility != null ? courseAbility.Point : 0;
						}

						Grade.AbilityScore = AbilityScore;
						Grade.Ability = AbilityScore;
					}
					else
					{
						Grade.AbilityScore = 0;
						Grade.Ability = 0;
					}
					if (Ability2Ratio > 0)
					{
						if (CourseEtcList != null)
						{
							CourseLecture courseAbility2 = CourseEtcList.Where(c => c.UserNo == item.UserNo && c.PointType.Equals("CEIT013")).FirstOrDefault();
							Ability2Score = courseAbility2 != null ? courseAbility2.Point : 0;
						}

						Grade.Ability2Score = Ability2Score;
						Grade.Ability2 = Ability2Score;
					}
					else
					{
						Grade.Ability2Score = 0;
						Grade.Ability2 = 0;
					}
					if (Ability3Ratio > 0)
					{
						if (CourseEtcList != null)
						{
							CourseLecture courseAbility3 = CourseEtcList.Where(c => c.UserNo == item.UserNo && c.PointType.Equals("CEIT014")).FirstOrDefault();
							Ability3Score = courseAbility3 != null ? courseAbility3.Point : 0;
						}

						Grade.Ability3Score = Ability3Score;
						Grade.Ability3 = Ability3Score;
					}
					else
					{
						Grade.Ability3Score = 0;
						Grade.Ability3 = 0;
					}
					#endregion

					#region 참여도 처리
					CourseLecture CourseLectureParicipation = LectureParicipationList.Where(c => c.UserNo == item.UserNo).FirstOrDefault();

					decimal QnaCount = 0;
					if (CourseLectureParicipation != null)
						QnaCount = (CourseLectureParicipation.IsUseParticipationQandA ?? "").Equals("Y") ? CourseLectureParicipation.QandAParticipationCheckCount : 0;

					decimal QnaPerfectScore = 100;
					decimal QnaScore = ((QnaCount * QnaBasisScore) > QnaPerfectScore) ? QnaPerfectScore : (QnaCount * QnaBasisScore);
					decimal Qna = QnaScore * QnaRatio / 100;
					Grade.QnaCount = (int)QnaCount;
					Grade.QnaPerfectScore = QnaPerfectScore;
					Grade.QnaScore = QnaScore;
					Grade.Qna = Qna;


					decimal ReferenceRoomCount = 0;
					if (CourseLectureParicipation != null)
						ReferenceRoomCount = (CourseLectureParicipation.IsUseParticipationPDS ?? "").Equals("Y") ? CourseLectureParicipation.PDSParticipationCheckCount : 0;

					decimal DiscussionCount = 0;
					if (CourseLectureParicipation != null)
						DiscussionCount = (CourseLectureParicipation.IsUseDisscussion ?? "").Equals("Y") ? CourseLectureParicipation.DiscussionCheckCount : 0;

					decimal DiscussionPerfectScore = 100;
					decimal DiscussionScore = ((DiscussionCount * DiscussionBasisScore) > DiscussionPerfectScore) ? DiscussionPerfectScore : (DiscussionCount * DiscussionBasisScore);
					decimal Discussion = DiscussionScore * DiscussionRatio / 100;
					Grade.DiscussionCount = (int)DiscussionCount;
					Grade.DiscussionPerfectScore = DiscussionPerfectScore;
					Grade.DiscussionScore = DiscussionScore;
					Grade.Discussion = Discussion;

					decimal FreeBoardCount = 0;
					if (CourseLectureParicipation != null)
						FreeBoardCount = (CourseLectureParicipation.IsUseParticipationFreeBoard ?? "").Equals("Y") ? CourseLectureParicipation.FreeBoardParticipationCheckCount : 0;

					decimal FreeBoardPerfectScore = 100;
					decimal FreeBoardScore = ((FreeBoardCount * FreeBoardBasisScore) > FreeBoardPerfectScore) ? FreeBoardPerfectScore : (FreeBoardCount * FreeBoardBasisScore);
					decimal FreeBoard = FreeBoardScore * FreeBoardRatio / 100;
					Grade.FreeBoardCount = (int)FreeBoardCount;
					Grade.FreeBoardPerfectScore = FreeBoardPerfectScore;
					Grade.FreeBoardScore = FreeBoardScore;
					Grade.FreeBoard = FreeBoard;

					decimal IntroduceBoardCount = 0;
					if (CourseLectureParicipation != null)
						IntroduceBoardCount = (CourseLectureParicipation.IsUseParticipationIntroduceBoard ?? "").Equals("Y") ? CourseLectureParicipation.IntroduceBoardParticipationCheckCount : 0;

					decimal IntroduceBoardPerfectScore = 100;
					decimal IntroduceBoardScore = ((IntroduceBoardCount * IntroduceBoardBasisScore) > IntroduceBoardPerfectScore) ? IntroduceBoardPerfectScore : (IntroduceBoardCount * IntroduceBoardBasisScore);
					decimal IntroduceBoard = IntroduceBoardScore * IntroduceBoardRatio / 100;
					Grade.IntroduceBoardCount = (int)IntroduceBoardCount;
					Grade.IntroduceBoardPerfectScore = IntroduceBoardPerfectScore;
					Grade.IntroduceBoardScore = IntroduceBoardScore;
					Grade.IntroduceBoard = IntroduceBoard;

					Grade.ParticipationPerfectScore = QnaPerfectScore + DiscussionPerfectScore + FreeBoardPerfectScore + IntroduceBoardPerfectScore;
					Grade.ParticipationScore = QnaScore + DiscussionScore + FreeBoardScore + IntroduceBoardScore;
					Grade.Participation = Qna + Discussion + FreeBoard + IntroduceBoard;
					#endregion

					Grade.MidtermExam = Math.Round(Grade.MidtermExam, 2, MidpointRounding.AwayFromZero);
					Grade.FinalExam = Math.Round(Grade.FinalExam, 2, MidpointRounding.AwayFromZero);
					Grade.Quiz = Math.Round(Grade.Quiz, 2, MidpointRounding.AwayFromZero);
					Grade.HomeWork = Math.Round(Grade.HomeWork, 2, MidpointRounding.AwayFromZero);
					Grade.TeamProject = Math.Round(Grade.TeamProject, 2, MidpointRounding.AwayFromZero);
					Grade.Etc = Math.Round(Grade.Etc, 2, MidpointRounding.AwayFromZero);
					Grade.Etc2 = Math.Round(Grade.Etc2, 2, MidpointRounding.AwayFromZero);
					Grade.Etc3 = Math.Round(Grade.Etc3, 2, MidpointRounding.AwayFromZero);
					Grade.Announce = Math.Round(Grade.Announce, 2, MidpointRounding.AwayFromZero);
					Grade.Ability = Math.Round(Grade.Ability, 2, MidpointRounding.AwayFromZero);
					Grade.Ability2 = Math.Round(Grade.Ability2, 2, MidpointRounding.AwayFromZero);
					Grade.Ability3 = Math.Round(Grade.Ability3, 2, MidpointRounding.AwayFromZero);
					Grade.Participation = Math.Round(Grade.Participation, 2, MidpointRounding.AwayFromZero);

					// 총점계산
					Grade.TotalScore = (int)Math.Round(Grade.MidtermExam + Grade.FinalExam + Grade.Attendance + Grade.Quiz + Grade.HomeWork + Grade.TeamProject
						+ Grade.Etc + Grade.Etc2 + Grade.Etc3 + Grade.Announce + Grade.Ability + Grade.Ability2 + Grade.Ability3
						+ Grade.Participation + Grade.BatchScore);

					Grade.GradeName = "";
					//Grade.GradeSaved = item.GradeSaved;
					//Grade.GradeSavedName = item.GradeSavedName;
					//Grade.BirthDay = item.BirthDay;

					int TotalRateScore = InningLIst.Where(c => DateTime.Parse(c.InningStartDay) <= DateTime.Now).Count();// 출석할 총 갯수(시험은 출석에서 제외)
					int TotalCLAT001Score = studyInningList.Where(c => c.AttendanceStatus.Equals("CLAT001") && c.UserNo == item.UserNo).Count();// 출석한 총 갯수
					int TotalCLAT003Score = studyInningList.Where(c => c.AttendanceStatus.Equals("CLAT003") && c.UserNo == item.UserNo).Count();// 지각한 총 갯수
					int TotalCLAT005Score = studyInningList.Where(c => c.AttendanceStatus.Equals("CLAT005") && c.UserNo == item.UserNo).Count();// 조퇴한 총 갯수 조퇴 세번은 결석 1번으로 간주

					/* 성적 셀렉트박스 등급(평어)관련
                     * 교수자가 직접 등급(평어)을 변경 후 저장하기때문에 수정 시 최종성적처리된 평어를 불러와야하기 떄문에 아래의 소스가 필요함.
                     */
					if (EstimationBasis.EstimationType == "CEST002" && GradeSavedList != null && GradeSavedList.Where(c => c.UserNo == item.UserNo).Count() > 0)
					{
						Grade.GradeName = GradeSavedList.Where(c => c.UserNo == item.UserNo).FirstOrDefault().GradeName;
					}

					if (TotalRateScore - TotalCLAT001Score > (TotalRateScore / 3))
					{
						Grade.FailingGradeYesNo = "Y";
						if (string.IsNullOrEmpty(Grade.GradeName))
						{
							Grade.GradeName = "GRAD013";
						}
						Grade.TotalScore = 0;
						Grade.AttendanceScore = 0;
						Grade.Attendance = 0;
					}
					else
					{
						Grade.FailingGradeYesNo = "N";
					}

					if (string.IsNullOrEmpty(Grade.GradeName))
					{
						if (EstimationBasis.EstimationType == "CEST002")
						{
							//절대평가 등급 자동계산 추가
							ILMS.Design.Domain.Grade.EstimationABSStandard abs = AbsStandard.Where(w => w.StartP <= Grade.TotalScore && w.EndP + 1 > Grade.TotalScore).FirstOrDefault();
							Grade.GradeName = abs == null ? "GRAD013" : abs.Grade;
						}
						else
						{
							Grade.GradeName = "GRAD000";
						}
					}

					Grade.EstimationType = EstimationType;
					GradeList.Add(Grade);
					//}
				}

			}

			return GradeList;
		}

		public IList<CourseLecture> CourseLectureStudentList(int cousreNo, string groupType, string orderBy)
		{
			Hashtable paramHash = new Hashtable();
			paramHash.Add("CourseNo", cousreNo);
			paramHash.Add("GroupType", groupType);
			paramHash.Add("SortType", orderBy);

			return courseDao.CourseLectureStudentList(paramHash);
		}

		public int CourseInsert(CourseViewModel vm)
		{
			return courseDao.CourseInsert(vm);
		}

		public int CourseUpdate(CourseViewModel vm)
		{
			return courseDao.CourseUpdate(vm);
		}

		public int InningDelete(int courseNo, int inningNo, int week, int inningSeqNo)
		{
			Hashtable paramInningDelete = new Hashtable();
			paramInningDelete.Add("CourseNo", courseNo);
			paramInningDelete.Add("InningNo", inningNo);
			paramInningDelete.Add("Week", week);
			paramInningDelete.Add("InningSeqNo", inningSeqNo);

			int cnt = courseDao.InningDelete(paramInningDelete);

			return cnt;
		}

		public int StudyInningInsert(StudyInning studyInning)
		{
			return courseDao.StudyInningInsert(studyInning);
		}

		public int InningSave(CourseViewModel vm)
		{
			int cnt = courseDao.InningSave(vm);

			return cnt;
		}

		public int InningUpdate(CourseViewModel vm)
		{
			int cnt = courseDao.InningUpdate(vm);

			return cnt;
		}

		public int EstimationSave(CourseViewModel vm)
		{
			int cnt = courseDao.EstimationSave(vm);

			return cnt;
		}

		public int GradeUpdate(IList<Grade> GradeList)
		{
			int cnt = courseDao.GradeUpdate(GradeList);

			return cnt;
		}

		public int GradeDelete(IList<Grade> GradeList)
		{
			int cnt = courseDao.GradeDelete(GradeList);

			return cnt;
		}

		public int LectureUserInsert(IList<CourseLecture> CourseLectureList)
		{
			int cnt = courseDao.LectureUserInsert(CourseLectureList);

			return cnt;
		}

	}
}
