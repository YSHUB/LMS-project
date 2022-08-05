using ILMS.Data.Dao;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace ILMS.Service
{
	public class ExamService
	{
		public ExamDao examDao { get; set; }

		public BaseDAO baseDao { get; set; }

		public int ExamSave(ExamViewModel vm)
		{
			int result = 0;

			// 응시시작일시, 응시종료일시 포맷
			if(vm.ExamDetail.StartDayFormat != null)
			{
				DateTime StartDay = DateTime.ParseExact(vm.ExamDetail.StartDayFormat.Replace("-", ""), "yyyyMMdd", null);
				vm.ExamDetail.StartDayFormat = StartDay.AddHours(int.Parse(vm.ExamDetail.StartHours)).AddMinutes(int.Parse(vm.ExamDetail.StartMin)).ToString("yyyy-MM-dd HH:mm:00.000");
			}

			if (vm.ExamDetail.EndDayFormat != null)
			{
				DateTime EndDay = DateTime.ParseExact(vm.ExamDetail.EndDayFormat.Replace("-", ""), "yyyyMMdd", null);
				vm.ExamDetail.EndDayFormat = EndDay.AddHours(int.Parse(vm.ExamDetail.EndHours)).AddMinutes(int.Parse(vm.ExamDetail.EndMin)).ToString("yyyy-MM-dd HH:mm:00.000");
			}

			DaoFactory.Instance.BeginTransaction();

			try
			{
				Examinee examinee;
				ExamQuestion examQuestion;
				ExamRandom examRandom;

				if (vm.ExamDetail.RowState.Equals("C"))
				{
					vm.ExamDetail.ExamNo = 0;
					vm.ExamDetail.ExamNo = baseDao.Get<Exam>("exam.EXAM_SAVE_C", vm.ExamDetail).ExamNo;
					if (vm.ExamDetail.ExamNo != 0) result += result + 1;
				}
				else if (vm.ExamDetail.RowState.Equals("U"))
				{
					// 답안지 삭제
					ExamineeReply examineeReply = new ExamineeReply("D");
					examineeReply.ExamNo = vm.ExamDetail.ExamNo;
					baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_D", examineeReply);

					// 추가 응시자 삭제(시험)
					if (vm.ExamDetail.Gubun.Equals("E") && vm.ExamDetail.AddExamYesNo.Equals("Y"))
					{
						examinee = new Examinee("H");
						examinee.CourseNo = vm.ExamDetail.CourseNo;
						examinee.ExamNo = vm.ExamDetail.ExamNo;
						baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_H", examinee);
					}

					// 응시자 삭제
					examinee = new Examinee("D");
					examinee.ExamNo = vm.ExamDetail.ExamNo;
					baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_D", examinee);

					// 문제 삭제
					examQuestion = new ExamQuestion("D");
					examQuestion.ExamNo = vm.ExamDetail.ExamNo;
					baseDao.Save<ExamQuestion>("exam.EXAM_QUESTION_SAVE_D", examQuestion);

					// 주차별 문항수 및 배점 삭제
					examRandom = new ExamRandom("D");
					examRandom.ExamNo = vm.ExamDetail.ExamNo;
					baseDao.Save<ExamRandom>("exam.EXAM_RANDOM_SAVE_D", examRandom);

					// 퀴즈, 시험 정보 수정
					baseDao.Save<Exam>("exam.EXAM_SAVE_U", vm.ExamDetail);
				}
				else if (vm.ExamDetail.RowState.Equals("D"))
				{
					result += baseDao.Save<Exam>("exam.EXAM_SAVE_D", vm.ExamDetail);
				}

				// 삭제가 아닐 경우(신규, 수정)
				if (!vm.ExamDetail.RowState.Equals("D"))
				{
					// 추가 응시자 저장(시험)
					if (vm.ExamDetail.Gubun.Equals("E") && vm.ExamDetail.AddExamYesNo.Equals("Y"))
					{
						for (var a = 0; a < vm.chkUserNos.Length; a++)
						{
							examinee = new Examinee("I");
							examinee.CourseNo = vm.ExamDetail.CourseNo;
							examinee.ExamNo = vm.ExamDetail.ExamNo;
							examinee.ExamineeUserNo = vm.chkUserNos[a];
							examinee.IsEstiamtionYesNo = "Y";
							examinee.IsResultYesNo = "0";
							baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_I", examinee);
						}
					}

					// 주차별 문항수 및 배점 저장
					for (var i = 0; i < vm.hdnRandomDiffCodes.Length; i++)
					{
						// 성적 미반영의 경우(후보문항수 = 출제문항수, 배점 = 0)
						if (!vm.ExamDetail.Gubun.Equals("E") && vm.ExamDetail.IsGrading.Equals(0))
						{
							vm.txtRandomDiffCount[i] = (vm.hdnQuestionCnt[i] == "" || vm.hdnQuestionCnt[i] == null) ? "0" : vm.hdnQuestionCnt[i];
							vm.txtWeekPoint[i] = "0";
						}

						vm.txtRandomDiffCount[i] = (vm.txtRandomDiffCount[i] == "" || vm.txtRandomDiffCount[i] == null) ? "0" : vm.txtRandomDiffCount[i];

						// 문항수를 입력한 경우
						if (Convert.ToInt32(vm.txtRandomDiffCount[i]) > 0)
						{
							vm.txtWeekPoint[i] = (vm.txtWeekPoint[i] == "" || vm.txtWeekPoint[i] == null) ? "0" : vm.txtWeekPoint[i];

							examRandom = new ExamRandom("C");
							examRandom.ExamNo = vm.ExamDetail.ExamNo;
							examRandom.RowNum = Convert.ToInt32(vm.txtRandomDiffCount[i]);
							examRandom.Difficulty = vm.hdnRandomDiffCodes[i];
							examRandom.EachPoint = Convert.ToInt32(Convert.ToDecimal(vm.txtWeekPoint[i]));
							examRandom.EachPointDec = Convert.ToDecimal(vm.txtWeekPoint[i]);

							baseDao.Save<ExamRandom>("exam.EXAM_RANDOM_SAVE_C", examRandom);
						}
					}

					// 문제 목록 저장
					for (var j = 0; j < vm.hdnQuestionBankNos.Length; j++)
					{
						examQuestion = new ExamQuestion("C");
						examQuestion.ExamNo = vm.ExamDetail.ExamNo;
						examQuestion.QuestionBankNo = Convert.ToInt32(vm.hdnQuestionBankNos[j]);
						examQuestion.EachScore = Convert.ToDouble((vm.hdnQuestionScores[j] == "" || vm.hdnQuestionScores[j] == null) ? "0" : vm.hdnQuestionScores[j]);
						examQuestion.CreateUserNo = vm.ExamDetail.CreateUserNo;

						baseDao.Save<ExamQuestion>("exam.EXAM_QUESTION_SAVE_C", examQuestion);
					}

					// 정상적으로 실행 된 경우 ExamNo 리턴
					result = vm.ExamDetail.ExamNo;
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public int ExamComplete(ExamViewModel vm)
		{
			int result = 0;

			vm.ExamDetail.AddExamYesNo = vm.ExamDetail.AddExamYesNo ?? "N";
			vm.ExamDetail.UseMixYesNo = vm.ExamDetail.UseMixYesNo ?? "N";

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// 수강생 목록
				IList<User> studentList;

				// 주차별 문항수 및 배점 설정 목록
				ExamRandom examRandom = new ExamRandom("S");
				examRandom.ExamNo = vm.ExamDetail.ExamNo;
				examRandom.Gubun = vm.ExamDetail.Gubun;
				IList<ExamRandom> randomList = baseDao.GetList<ExamRandom>("exam.EXAM_RANDOM_SELECT_S", examRandom);

				// 문제 목록
				ExamQuestion examQuestion = new ExamQuestion("L");
				examQuestion.ExamNo = vm.ExamDetail.ExamNo;
				examQuestion.Gubun = vm.ExamDetail.Gubun;
				IList<ExamQuestion> questionList = baseDao.GetList<ExamQuestion>("exam.EXAM_QUESTION_SELECT_L", examQuestion);

				// 등록된 문제가 있는 경우
				if (questionList.Count > 0)
				{
					//주차별 문항수 및 배점이 생성되지 않은 경우(후보문항수 = 출제문항수, 배점 = 0) 생성
					if (randomList.Count < 1)
					{
						baseDao.Save<ExamRandom>("exam.EXAM_RANDOM_SAVE_A", examRandom);
					}

					randomList = baseDao.GetList<ExamRandom>("exam.EXAM_RANDOM_SELECT_S", examRandom);

					Hashtable paramHash = new Hashtable();

					// 추가시험인 경우
					if (vm.ExamDetail.AddExamYesNo.Equals("Y"))
					{
						// 재응시 대상자 목록
						paramHash.Add("RowState", "A");
						paramHash.Add("CourseNo", vm.ExamDetail.CourseNo);
						paramHash.Add("ExamNo", vm.ExamDetail.ExamNo);
						paramHash.Add("IsResultYesNo", "0");
						paramHash.Add("IsEstiamtionYesNo", "Y");

						studentList = baseDao.GetList<User>("exam.EXAMINEE_SELECT_A", paramHash);
					}
					// 퀴즈, 일반적인 시험(재시험 포함) 인 경우
					else
					{
						// 수강생 목록
						paramHash.Add("RowState", "B");
						paramHash.Add("CourseNo", vm.ExamDetail.CourseNo);

						studentList = baseDao.GetList<User>("course.COURSE_LECTURE_SELECT_B", paramHash);
					}

					// 학생수만큼 문제 생성
					foreach (var student in studentList)
					{
						// 퀴즈, 시험 응시자 생성
						Examinee examinee = new Examinee("C");
						examinee.CourseNo = vm.ExamDetail.CourseNo;
						examinee.ExamNo = vm.ExamDetail.ExamNo;
						examinee.ExamineeUserNo = student.UserNo;
						examinee.Week = vm.ExamDetail.Week;
						examinee.InningNo = vm.ExamDetail.InningNo;
						examinee.SubmitType = vm.ExamDetail.SubmitType;
						examinee.ExamItem = vm.ExamDetail.ExamItem;
						examinee.CreateUserNo = vm.ExamDetail.CreateUserNo;

						int examineeNo = baseDao.Get<Examinee>("exam.EXAMINEE_SAVE_C", examinee).ExamineeNo;

						// 문제섞기
						if (vm.ExamDetail.UseMixYesNo.Equals("Y"))
						{
							ArrayList list = new ArrayList();
							for (int i = 0; i < randomList.Count; ++i)
							{
								list.Add(i);
							}

							Random random = new Random();

							while (0 < list.Count)
							{
								int index = random.Next(list.Count);    // 꺼낼 번호를 랜덤하게 선택합니다.
								int random_number = (int)list[index];   // 중복되지 않는 번호를 꺼내왔으니 이것을 사용하세요.
								list.RemoveAt(index);                   // 중복되지 않도록 제거합니다.

								int RamdonCount = randomList[random_number].RowNum; // 출제 문항수
								int j = 0;

								IEnumerable<ExamQuestion> questionTemp = questionList.Where(c => c.Difficulty == randomList[random_number].Difficulty).OrderBy(c => Guid.NewGuid());

								// 답안지 생성
								foreach (ExamQuestion item in questionTemp)
								{
									ExamineeReply examineeReply = new ExamineeReply("C");
									examineeReply.ExamineeNo = examineeNo;
									examineeReply.QuestionNo = item.QuestionNo;
									examineeReply.ExamNo = item.ExamNo;
									result += baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_C", examineeReply);

									j++;

									if (j == RamdonCount) break;
								}
							}
						}
						else
						{
							foreach (ExamRandom random in randomList)
							{
								int RamdonCount = random.RowNum; // 출제 문항수
								int j = 0;

								IEnumerable<ExamQuestion> questionTemp = questionList.Where(c => c.Difficulty == random.Difficulty).OrderBy(c => c.QuestionBankNo);

								// 답안지 생성
								foreach (ExamQuestion item in questionTemp)
								{
									ExamineeReply examineeReply = new ExamineeReply("C");
									examineeReply.ExamineeNo = examineeNo;
									examineeReply.QuestionNo = item.QuestionNo;
									examineeReply.ExamNo = item.ExamNo;
									result += baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_C", examineeReply);

									j++;

									if (j == RamdonCount) break;
								}
							}
						}
					}

					Exam exam = new Exam("E");
					exam.ExamNo = vm.ExamDetail.ExamNo;
					exam.Gubun = vm.ExamDetail.Gubun;
					exam.EstimationGubun = "EXET002"; // 출제완료
					result += baseDao.Save<Exam>("exam.EXAM_SAVE_E", exam);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public int ExamUnComplete(int ExamNo, string Gubun)
		{
			int result = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// 답안지 삭제
				ExamineeReply examineeReply = new ExamineeReply("D");
				examineeReply.ExamNo = ExamNo;
				result += baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_D", examineeReply);

				// 응시자 삭제
				Examinee examinee = new Examinee("D");
				examinee.ExamNo = ExamNo;
				result += baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_D", examinee);

				// 미완료 상태
				Exam exam = new Exam("E");
				exam.ExamNo = ExamNo;
				exam.Gubun = Gubun;
				exam.EstimationGubun = "EXET001"; // 미완료
				result += baseDao.Save<Exam>("exam.EXAM_SAVE_E", exam);

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public Exam ExamDetailInfo(int CourseNo, int ExamNo, string Gubun)
		{
			ExamViewModel vm = new ExamViewModel();

			// 퀴즈, 시험 상세조회
			Exam exam = new Exam("S");
			exam.CourseNo = CourseNo;
			exam.ExamNo = ExamNo;
			exam.Gubun = Gubun;
			vm.ExamDetail = baseDao.Get<Exam>("exam.EXAM_SELECT_S", exam);

			return vm.ExamDetail;
		}

		public Examinee ExamPensonInfo(int CourseNo, int ExamNo, string Gubun, long UserNo, int ExamineeNo)
		{
			ExamViewModel vm = new ExamViewModel();

			// 퀴즈 응시대상자 정보
			Examinee examinee = new Examinee("L");
			examinee.CourseNo = CourseNo;
			examinee.ExamNo = ExamNo;
			examinee.Gubun = Gubun;
			examinee.UserNo = UserNo;
			examinee.ExamineeNo = ExamineeNo;
			vm.ExamineeDetail = baseDao.Get<Examinee>("exam.EXAMINEE_SELECT_L", examinee);

			return vm.ExamineeDetail;
		}

		public IList<ExamQuestion> ExamListInfo(int ExamNo, int ExamineeNo, string Gubun, long UserNo, string AdminYn)
		{
			ExamViewModel vm = new ExamViewModel();

			// 관리자
			if (AdminYn.Equals("Y"))
			{
				// 문제 조회
				ExamQuestion examQuestion = new ExamQuestion("L");
				examQuestion.ExamNo = ExamNo;
				examQuestion.Gubun = Gubun;
				vm.QuestionList = baseDao.GetList<ExamQuestion>("exam.EXAM_QUESTION_SELECT_L", examQuestion).ToList();
			}
			else
			{
				// 문제 조회
				ExamQuestion examQuestion = new ExamQuestion("S");
				examQuestion.ExamNo = ExamNo;
				examQuestion.Gubun = Gubun;
				examQuestion.ExamineeNo = ExamineeNo;
				vm.QuestionList = baseDao.GetList<ExamQuestion>("exam.EXAM_QUESTION_SELECT_S", examQuestion).ToList();
			}

			return vm.QuestionList;
		}

		public IList<ExamineeReply> ExampleListInfo(string ExampleMixYesNo, int ExamNo, int QuestionBankNo, int ExamineeNo)
		{
			ExamViewModel vm = new ExamViewModel();
			vm.QuestionExampleList = new List<ExamineeReply>();

			// 문제 보기 조회
			ExamineeReply examineeReply = new ExamineeReply("L");
			examineeReply.ExamNo = ExamNo;
			examineeReply.QuestionBankNo = QuestionBankNo;
			examineeReply.ExamineeNo = ExamineeNo;
			IList<ExamineeReply> exampleList = baseDao.GetList<ExamineeReply>("exam.EXAMINEE_REPLY_SELECT_L", examineeReply).ToList();

			// 보기섞기
			if(ExampleMixYesNo == "Y")
			{
				Random random = new Random();
				ArrayList list = new ArrayList();

				for (int i = 0; i < exampleList.Count; ++i)
				{
					list.Add(i);
				}

				int j = 0;
				while (0 < list.Count)
				{
					int index = random.Next(list.Count);    // 꺼낼 번호를 랜덤하게 선택합니다.
					int random_number = (int)list[index];   // 중복되지 않는 번호를 꺼내왔으니 이것을 사용하세요.
					list.RemoveAt(index);                   // 중복되지 않도록 제거합니다.

					vm.QuestionExampleList.Add(exampleList[random_number]);

					j++;
				}
			}
			else
			{
				vm.QuestionExampleList = exampleList;
			}

			return vm.QuestionExampleList;
		}

		public int ExamSubmitSave(ExamViewModel vm)
		{
			int result = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// 임시저장
				if (vm.ExamineeDetail.IsResultYesNo.Equals("0"))
				{
					int index = vm.QuestionDetail.RowIndex - 1;
					ExamineeReply examineeReply = new ExamineeReply("U");
					examineeReply.ExamineeNo = vm.QuestionDetail.ExamineeNo;
					examineeReply.CourseNo = vm.ExamDetail.CourseNo;
					examineeReply.ExamNo = vm.ExamDetail.ExamNo;
					examineeReply.QuestionNo = vm.QuestionDetail.QuestionNo;
					examineeReply.ExamineeAnswer = vm.hdnExamineeAnswers[index];

					result += baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_U", examineeReply);
				}
				// 최종저장(응시완료)
				else if (vm.ExamineeDetail.IsResultYesNo.Equals("1"))
				{
					// 전체 답안 저장
					for (var i = 0; i < vm.hdnQuestionNos.Length; i++)
					{
						// 저장된 답 ≠ 새로운 답, 저장된 답이 없는 경우
						if (vm.hdnOldExamineeAnswers[i] == null || vm.hdnOldExamineeAnswers[i] != vm.hdnExamineeAnswers[i])
						{
							ExamineeReply examineeReply = new ExamineeReply("U");
							examineeReply.ExamineeNo = vm.QuestionDetail.ExamineeNo;
							examineeReply.CourseNo = vm.ExamDetail.CourseNo;
							examineeReply.ExamNo = vm.ExamDetail.ExamNo;
							examineeReply.QuestionNo = Convert.ToInt32(vm.hdnQuestionNos[i]);
							examineeReply.ExamineeAnswer = vm.hdnExamineeAnswers[i];

							result += baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_U", examineeReply);
						}
					}

					Examinee examinee = new Examinee("U");
					examinee.ExamineeNo = vm.QuestionDetail.ExamineeNo;
					examinee.IsResultYesNo = vm.ExamineeDetail.IsResultYesNo;

					result += baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_U", examinee);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public IList<Examinee> ExamineeList(string RowState, int CourseNo, int ExamNo, string Gubun, string ExamStatus, string SearchGubun, string SearchText, string SortGubun)
		{
			ExamViewModel vm = new ExamViewModel();

			Examinee examinee = new Examinee(RowState);
			examinee.CourseNo = CourseNo;
			examinee.ExamNo = ExamNo;
			examinee.Gubun = Gubun;
			examinee.ExamStatus = ExamStatus;
			examinee.SearchGubun = SearchGubun;
			examinee.SearchText = SearchText;
			examinee.SortGubun = SortGubun;
			vm.ExamineeList = baseDao.GetList<Examinee>("exam.EXAMINEE_SELECT_" + RowState, examinee).ToList();

			return vm.ExamineeList;
		}
		
		public int OpenYesnoSave(int examNo, string Gubun, string openYesNo)
		{
			int result = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				Exam exam = new Exam("G");
				exam.ExamNo = examNo;
				exam.Gubun = Gubun;
				exam.OpenYesNo = openYesNo;

				result += baseDao.Save<Exam>("exam.EXAM_SAVE_G", exam);

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public int AutoScoringSave(int courseNo, int examNo, string Gubun)
		{
			int result = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				Examinee examinee = new Examinee("A");
				examinee.CourseNo = courseNo;
				examinee.ExamNo = examNo;

				result += baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_A", examinee);

				// 출석처리(시험일때만)
				if (Gubun.Equals("E"))
				{
					result += attendanceCheck("U", courseNo, examNo, 0, 0);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public int chgExamStatus(string btnGubun, int examNo, string Gubun, string statusGubun)
		{
			int result = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				Exam exam = new Exam("E");
				exam.ExamNo = examNo;
				exam.Gubun = Gubun;
				exam.EstimationGubun = (statusGubun.Equals("Y") ? (btnGubun.Equals("O") ? "EXET005" : "EXET003") : "EXET002");

				result += baseDao.Save<Exam>("exam.EXAM_SAVE_E", exam);

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public int deadlineSave(int courseNo, int examNo, int examineeNo, int retestGubun, long updateUserNo, string Gubun)
		{
			int result = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// 마감처리
				Examinee examinee = new Examinee("B");
				examinee.ExamNo = examNo;
				examinee.ExamineeNo = examineeNo;
				examinee.UpdateUserNo = updateUserNo;
				examinee.RetestGubun = retestGubun;

				result += baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_B", examinee);

				// 출석처리(시험일때만)
				if (Gubun.Equals("E"))
				{
					result += attendanceCheck("U", courseNo, examNo, 0, retestGubun);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public int attendanceCheck(string rowstate, int courseNo, int examNo, int examineeNo, int retestGubun)
		{
			int result = 0;

			try
			{
				// 출석처리
				Hashtable paramHash = new Hashtable();
				paramHash.Add("RowState", rowstate);
				paramHash.Add("CourseNo", courseNo);
				paramHash.Add("ExamNo", examNo);
				if(!examineeNo.Equals(0)) paramHash.Add("ExamineeNo", examineeNo);
				if(!retestGubun.Equals(0)) paramHash.Add("RetestGubun", retestGubun);

				result += baseDao.Save<Hashtable>("course.COURSE_INNING_SAVE_U", paramHash);
			}
			catch (Exception)
			{
				result = 0;
			}

			return result;
		}

		public int ExamReset(int courseNo, int examNo, string Gubun, int examineeNo, long userNo)
		{
			int result = 0;

			ExamViewModel vm = new ExamViewModel();

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// 수강생 목록
				Hashtable paramHash = new Hashtable();
				paramHash.Add("RowState", "B");
				paramHash.Add("CourseNo", courseNo);
				IList<User> studentList = baseDao.GetList<User>("course.COURSE_LECTURE_SELECT_B", paramHash);

				if(examineeNo > 0)
				{
					studentList = studentList.Where(c => c.UserNo.Equals(userNo)).ToList();
				}

				// 퀴즈, 시험 상세정보
				vm.ExamDetail = ExamDetailInfo(courseNo, examNo, Gubun);

				// 답안지 삭제
				ExamineeReply examineeReply = new ExamineeReply("D");
				examineeReply.ExamNo = examNo;
				if(examineeNo > 0) examineeReply.ExamineeNo = examineeNo;
				baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_D", examineeReply);

				// 응시자 삭제
				Examinee examinee = new Examinee("D");
				examinee.ExamNo = examNo;
				if (examineeNo > 0) examinee.ExamineeNo = examineeNo;
				baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_D", examinee);

				// 주차별 문항수 및 배점 설정 목록
				ExamRandom examRandom = new ExamRandom("S");
				examRandom.ExamNo = vm.ExamDetail.ExamNo;
				examRandom.Gubun = vm.ExamDetail.Gubun;
				IList<ExamRandom> randomList = baseDao.GetList<ExamRandom>("exam.EXAM_RANDOM_SELECT_S", examRandom);

				// 문제 목록
				ExamQuestion examQuestion = new ExamQuestion("L");
				examQuestion.ExamNo = vm.ExamDetail.ExamNo;
				examQuestion.Gubun = vm.ExamDetail.Gubun;
				IList<ExamQuestion> questionList = baseDao.GetList<ExamQuestion>("exam.EXAM_QUESTION_SELECT_L", examQuestion);

				// 등록된 문제가 있는 경우
				if (questionList.Count > 0)
				{
					//주차별 문항수 및 배점이 생성되지 않은 경우(후보문항수 = 출제문항수, 배점 = 0) 생성
					if (randomList.Count < 1)
					{
						baseDao.Save<ExamRandom>("exam.EXAM_RANDOM_SAVE_A", examRandom);
					}

					randomList = baseDao.GetList<ExamRandom>("exam.EXAM_RANDOM_SELECT_S", examRandom);

					// 학생수만큼 문제 생성
					foreach (var student in studentList)
					{
						// 퀴즈, 시험 응시자 생성
						examinee = new Examinee("C");
						examinee.CourseNo = vm.ExamDetail.CourseNo;
						examinee.ExamNo = vm.ExamDetail.ExamNo;
						examinee.ExamineeUserNo = student.UserNo;
						examinee.Week = vm.ExamDetail.Week;
						examinee.InningNo = vm.ExamDetail.InningNo;
						examinee.SubmitType = vm.ExamDetail.SubmitType;
						examinee.ExamItem = vm.ExamDetail.ExamItem;
						examinee.CreateUserNo = vm.ExamDetail.CreateUserNo;

						int newExamineeNo = baseDao.Get<Examinee>("exam.EXAMINEE_SAVE_C", examinee).ExamineeNo;

						// 문제섞기
						if (vm.ExamDetail.UseMixYesNo.Equals("Y"))
						{
							ArrayList list = new ArrayList();
							for (int i = 0; i < randomList.Count; ++i)
							{
								list.Add(i);
							}

							Random random = new Random();

							while (0 < list.Count)
							{
								int index = random.Next(list.Count);    // 꺼낼 번호를 랜덤하게 선택합니다.
								int random_number = (int)list[index];   // 중복되지 않는 번호를 꺼내왔으니 이것을 사용하세요.
								list.RemoveAt(index);                   // 중복되지 않도록 제거합니다.

								int RamdonCount = randomList[random_number].RowNum; // 출제 문항수
								int j = 0;

								IEnumerable<ExamQuestion> questionTemp = questionList.Where(c => c.Difficulty == randomList[random_number].Difficulty).OrderBy(c => Guid.NewGuid());

								// 답안지 생성
								foreach (ExamQuestion item in questionTemp)
								{
									examineeReply = new ExamineeReply("C");
									examineeReply.ExamineeNo = newExamineeNo;
									examineeReply.QuestionNo = item.QuestionNo;
									examineeReply.ExamNo = item.ExamNo;
									result += baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_C", examineeReply);

									j++;

									if (j == RamdonCount) break;
								}
							}
						}
						else
						{
							foreach (ExamRandom random in randomList)
							{
								int RamdonCount = random.RowNum; // 출제 문항수
								int j = 0;

								IEnumerable<ExamQuestion> questionTemp = questionList.Where(c => c.Difficulty == random.Difficulty).OrderBy(c => c.QuestionBankNo);

								// 답안지 생성
								foreach (ExamQuestion item in questionTemp)
								{
									examineeReply = new ExamineeReply("C");
									examineeReply.ExamineeNo = newExamineeNo;
									examineeReply.QuestionNo = item.QuestionNo;
									examineeReply.ExamNo = item.ExamNo;
									result += baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_C", examineeReply);

									j++;

									if (j == RamdonCount) break;
								}
							}
						}
					}
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public decimal PerfectScore(int examNo, string Gubun)
		{
			decimal result = 0;

			// 주차별 문항수 및 배점 설정 목록
			ExamRandom examRandom = new ExamRandom("S");
			examRandom.ExamNo = examNo;
			examRandom.Gubun = Gubun;
			IList<ExamRandom> randomList = baseDao.GetList<ExamRandom>("exam.EXAM_RANDOM_SELECT_S", examRandom);

			foreach (ExamRandom random in randomList)
			{
				result += (random.RowNum * random.EachPointDec);
			}

			return result;
		}

		public int offSave(ExamViewModel vm, long fileGroupNo, long updateUserNo)
		{
			int result = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				// 출석 초기화 ROWSTATE
				string rowstate = "A";

				// 오프등록 및 해제
				Examinee examinee = new Examinee("E");
				examinee.ExamineeNo = vm.ExamineeDetail.ExamineeNo;
				examinee.OFFYesNo = vm.ExamineeDetail.OFFYesNo;
				examinee.UpdateUserNo = updateUserNo;

				if (vm.ExamineeDetail.OFFYesNo.Equals("Y"))
				{
					examinee.ExamTotalScore = vm.ExamineeDetail.ExamTotalScore;
					examinee.OFFMEMO = vm.ExamineeDetail.OFFMEMO;
					examinee.OFFFile = fileGroupNo;

					// 출석 체크 ROWSTATE
					rowstate = "U";
				}

				result += baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_E", examinee);

				// 출석처리(시험일때만)
				if (vm.ExamineeDetail.Gubun.Equals("E"))
				{
					result += attendanceCheck(rowstate, vm.ExamineeDetail.CourseNo, vm.ExamineeDetail.ExamNo, vm.ExamineeDetail.ExamineeNo, (rowstate.Equals("A") ? 0 : 2));
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public ExamineeReply ExamineeScoreInfo(int ExamNo, string Gubun, int ExamineeNo)
		{
			ExamViewModel vm = new ExamViewModel();

			// 응시자 객관식, 주관식 점수 정보
			ExamineeReply examineeReply = new ExamineeReply("S");
			examineeReply.ExamNo = ExamNo;
			examineeReply.Gubun = Gubun;
			examineeReply.ExamineeNo = ExamineeNo;
			vm.ExamineeScore = baseDao.Get<ExamineeReply>("exam.EXAMINEE_REPLY_SELECT_S", examineeReply);

			return vm.ExamineeScore;
		}

		public int EstimationSave(ExamViewModel vm)
		{
			int result = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				decimal ExamTotalScore = 0;

				// 평가점수 저장
				for (var i = 0; i < vm.hdnReplyNos.Length; i++)
				{
					ExamineeReply examineeReply = new ExamineeReply("A");
					examineeReply.ReplyNo = vm.hdnReplyNos[i];
					examineeReply.Score = Convert.ToInt32(vm.hdnScores[i]);
					examineeReply.ScoreDec = vm.hdnScores[i];

					result += baseDao.Save<ExamineeReply>("exam.EXAMINEE_REPLY_SAVE_A", examineeReply);

					ExamTotalScore += (vm.hdnScores[i] == 0) ? 0 : vm.hdnScores[i];
				}
					
				// 총합, 평가완료여부 저장
				Examinee examinee = new Examinee("F");
				examinee.ExamineeNo = vm.ExamineeDetail.ExamineeNo;
				examinee.Feedback = vm.ExamineeDetail.Feedback;
				examinee.FeedbackUserNo = vm.ExamineeDetail.FeedbackUserNo;
				examinee.IsEstiamtionYesNo = "Y";
				examinee.ExamTotalScore = ExamTotalScore;

				result += baseDao.Save<Examinee>("exam.EXAMINEE_SAVE_F", examinee);

				// 출석처리(시험일때만)
				if (vm.ExamineeDetail.Gubun.Equals("E"))
				{
					result += attendanceCheck("U", vm.ExamineeDetail.CourseNo, vm.ExamineeDetail.ExamNo, vm.ExamineeDetail.ExamineeNo, 2);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public IList<ExamQuestion> ExamStatementList(int ExamNo)
		{
			ExamViewModel vm = new ExamViewModel();

			// 문제 조회
			ExamQuestion examQuestion = new ExamQuestion("A");
			examQuestion.ExamNo = ExamNo;
			vm.QuestionList = baseDao.GetList<ExamQuestion>("exam.EXAM_QUESTION_SELECT_A", examQuestion).ToList();

			return vm.QuestionList;
		}

		public int TotalCntQuestion(int examNo, string Gubun)
		{
			int result = 0;

			// 주차별 문항수 및 배점 설정 목록
			ExamRandom examRandom = new ExamRandom("S");
			examRandom.ExamNo = examNo;
			examRandom.Gubun = Gubun;
			IList<ExamRandom> randomList = baseDao.GetList<ExamRandom>("exam.EXAM_RANDOM_SELECT_S", examRandom);

			foreach (ExamRandom random in randomList)
			{
				result += random.RowNum;
			}

			return result;
		}

		public int ExamAdminListCnt(ExamViewModel vm, string Gubun)
		{
			int result = 0;

			Exam exam = new Exam("D");
			exam.ProgramNo = vm.ProgramNo;
			exam.TermNo = vm.TermNo;
			exam.Gubun = Gubun;
			exam.SearchText = vm.SearchText;

			result = baseDao.GetList<Exam>("exam.EXAM_SELECT_D", exam).Count;

			return result;
		}

		public IList<Exam> ExamAdminList(ExamViewModel vm, string Rowstate, string Gubun)
		{
			Exam exam = new Exam(Rowstate);
			exam.Gubun = Gubun;

			if (vm.CourseNo > 0) exam.CourseNo = vm.CourseNo;
			if (vm.ProgramNo > 0) exam.ProgramNo = vm.ProgramNo;
			if (vm.TermNo > 0) exam.TermNo = vm.TermNo;
			if (vm.SearchText != null && vm.SearchText != "") exam.SearchText = vm.SearchText;

			if (Rowstate.Equals("D"))
			{
				if (vm.FirstIndex > 0) exam.FirstIndex = vm.FirstIndex;
				if (vm.LastIndex > 0) exam.LastIndex = vm.LastIndex;
			}

			vm.QuizList = baseDao.GetList<Exam>("exam.EXAM_SELECT_" + Rowstate, exam).ToList();

			return vm.QuizList;
		}

		public int ExamDetailListCnt(ExamViewModel vm)
		{
			int result = 0;

			Exam exam = new Exam("L");
			exam.CourseNo = vm.CourseNo;
			exam.Gubun = vm.ExamDetail.Gubun;

			result = baseDao.GetList<Exam>("exam.EXAM_SELECT_L", exam).Count;

			return result;
		}
	}
}
