using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using System;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Data.Dao
{
	public class CourseDao : BaseDAO
	{

		public IList<CourseLecture> CourseLectureStudentList(Hashtable hashtable)
		{
			return DaoFactory.Instance.QueryForList<CourseLecture>("team.COURSE_LECTURE_SELECT_D", hashtable);
		}

		public int CourseInsert(CourseViewModel vm)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{

				int subjectNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("course.COURSE_SUBJECT_SAVE_C", vm.Subject));

				if (subjectNo > 0)
				{
					vm.Course.SubjectNo = subjectNo;
					int courseNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("course.COURSE_SAVE_C", vm.Course));

					if (courseNo > 0)
					{
						vm.Course.CourseNo = courseNo;
						DaoFactory.Instance.Update("course.COURSE_PROFESSOR_SAVE_C", vm.Course);
						DaoFactory.Instance.Update("course.COURSE_WEEK_SAVE_C", vm.Course);

						DaoFactory.Instance.CommitTransaction();
					}
					else
					{
						DaoFactory.Instance.RollBackTransaction();
					}
				}
				else
				{
					DaoFactory.Instance.RollBackTransaction();
				}
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int CourseUpdate(CourseViewModel vm)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				rsCount += DaoFactory.Instance.Update("course.COURSE_SUBJECT_SAVE_U", vm.Subject);
				rsCount += DaoFactory.Instance.Update("course.COURSE_SAVE_U", vm.Course);

				if (rsCount > 1)
				{
					rsCount += DaoFactory.Instance.Update("course.COURSE_PROFESSOR_SAVE_C", vm.Course);
					DaoFactory.Instance.CommitTransaction();

				}
				else
				{
					DaoFactory.Instance.RollBackTransaction();
				}
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int InningDelete(Hashtable paramInningDelete)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_B", paramInningDelete);
				rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_E", paramInningDelete);
				rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_F", paramInningDelete);
				rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_G", paramInningDelete);
				rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_H", paramInningDelete);
				rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_I", paramInningDelete);
				rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_D", paramInningDelete);

				DaoFactory.Instance.CommitTransaction();

				//DaoFactory.Instance.RollBackTransaction();
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int StudyInningInsert(StudyInning studyInning)
		{
			int rs = 0;
			DaoFactory.Instance.BeginTransaction();
			try
			{
				rs += DaoFactory.Instance.Update("course.STUDY_INNING_SAVE_A", studyInning);
				Hashtable paramHash = new Hashtable();
				paramHash.Add("AttendanceStatus", studyInning.AttendanceStatus);
				paramHash.Add("StudyInningNo", studyInning.StudyInningNo);
				rs += DaoFactory.Instance.Update("course.STUDY_INNING_SAVE_B", paramHash);
				rs = 1;

			}
			catch (Exception)
			{
				DaoFactory.Instance.RollBackTransaction();
			}
			finally
			{
				DaoFactory.Instance.CommitTransaction();
			}
			return rs;
		}

		public int InningSave(CourseViewModel vm)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// week 저장
				rsCount += DaoFactory.Instance.Update("course.COURSE_WEEK_SAVE_A", vm.CourseInning);
				// inning 저장
				rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_K", vm.CourseInning);
				// studyInning 저장
				rsCount += DaoFactory.Instance.Update("course.STUDY_INNING_SAVE_C", vm.CourseInning);

				if (rsCount > 0)
				{
					// 맛보기 재설정
					if (vm.CourseInning.IsPreview.Equals("Y"))
					{
						rsCount += DaoFactory.Instance.Update("course.COURSE_SAVE_B", vm.CourseInning); // 맛보기 설정하기
					}
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int InningUpdate(CourseViewModel vm)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// week 수정
				rsCount += DaoFactory.Instance.Update("course.COURSE_WEEK_SAVE_B", vm.CourseInning);
				// inning 수정
				rsCount += DaoFactory.Instance.Update("course.COURSE_INNING_SAVE_L", vm.CourseInning);

				if (rsCount > 0)
				{
					// 맛보기 재설정
					if (vm.CourseInning.IsPreview.Equals("Y"))
					{
						rsCount += DaoFactory.Instance.Update("course.COURSE_SAVE_E", vm.CourseInning);
					}
					else
					{
						rsCount += DaoFactory.Instance.Update("course.COURSE_SAVE_F", vm.CourseInning);
					}
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int EstimationSave(CourseViewModel vm)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// 평가항목 저장
				if (vm.EstimationBasis.saveEstimationOut)
				{
					rsCount = DaoFactory.Instance.Update("course.COURSE_EST_SAVE_A", vm.EstimationBasis);
					for (var i =0; i < vm.EstimationItemGubun.Length; i ++)
					{
						vm.EstimationRateScore[i] = (vm.EstimationRateScore[i] == "" || vm.EstimationRateScore[i] == null) ? "0" : vm.EstimationRateScore[i];
						vm.EstimationItemGubun[i] = (vm.EstimationItemGubun[i] == "" || vm.EstimationItemGubun[i] == null) ? "" : vm.EstimationItemGubun[i];

						vm.EstimationBasis.RateScore = Convert.ToInt32(vm.EstimationRateScore[i]);
						vm.EstimationBasis.EstimationItemGubun = vm.EstimationItemGubun[i];

						rsCount = DaoFactory.Instance.Update("course.COURSE_EST_SAVE_B", vm.EstimationBasis);
					}

					vm.Course.CourseNo = vm.EstimationBasis.CourseNo;
					rsCount = DaoFactory.Instance.Update("course.COURSE_SAVE_G", vm.Course);
				}

				// 참여도항목 세부기준 저장
				for (var i = 0; i < vm.ParticipationItemGubun.Length; i++)
				{
					vm.ParticipationRateScore[i] = (vm.ParticipationRateScore[i] == "" || vm.ParticipationRateScore[i] == null) ? "0" : vm.ParticipationRateScore[i];
					vm.ParticipationBasisScore[i] = (vm.ParticipationBasisScore[i] == "" || vm.ParticipationBasisScore[i] == null) ? "0" : vm.ParticipationBasisScore[i];

					vm.ParticipationEstimationBasis.RateScore = Convert.ToInt32(vm.ParticipationRateScore[i]);
					vm.ParticipationEstimationBasis.BasisScore = Convert.ToInt32(vm.ParticipationBasisScore[i]);
					vm.ParticipationEstimationBasis.ParticipationItemGubun = vm.ParticipationItemGubun[i];

					rsCount = DaoFactory.Instance.Update("course.COURSE_EST_SAVE_C", vm.ParticipationEstimationBasis);
				}

				DaoFactory.Instance.CommitTransaction();

			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				rsCount = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int GradeUpdate(IList<Grade> GradeList)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				foreach(Grade grade in GradeList)
				{
					rsCount += DaoFactory.Instance.Update("course.COURSE_GRADE_SAVE_C", grade);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch(Exception ex)
			{
				string message = ex.Message;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}

		public int GradeDelete(IList<Grade> GradeList)
		{
			int rsCount = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				foreach (Grade grade in GradeList)
				{
					rsCount += DaoFactory.Instance.Update("course.COURSE_GRADE_SAVE_D", grade);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception ex)
			{
				string message = ex.Message;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}


		public int LectureUserInsert(IList<CourseLecture> CCL)
		{
			int rsCount = -1;

			DaoFactory.Instance.BeginTransaction();

			try
			{

				foreach (CourseLecture item in CCL)
				{
					Hashtable ht = new Hashtable();
					ht.Add("CourseNo", item.CourseNo);
					ht.Add("UserNo", item.UserNo);
					ht.Add("LectureStatus", "CLST001");
					ht.Add("CreateUserNo", item.CreateUserNo);
					//수강자생성
					Int64 lectureNo = Convert.ToInt64(DaoFactory.Instance.QueryForObject("course.COURSE_LECTURE_SAVE_C", ht));

					if (lectureNo > 0)
					{
						ht.Add("LectureNo", lectureNo);
						//수강데이터생성
						int rs = Convert.ToInt32(DaoFactory.Instance.QueryForObject("course.COURSE_INNING_SAVE_C", ht));

					}
				}

				DaoFactory.Instance.CommitTransaction();

				rsCount = 1;

			}
			catch (Exception ex)
			{
				string message = ex.Message;
				DaoFactory.Instance.RollBackTransaction();
			}

			return rsCount;
		}
	}
}
