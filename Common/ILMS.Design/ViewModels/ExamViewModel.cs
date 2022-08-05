using ILMS.Design.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.ViewModels
{
	//메인페이지
	public class ExamViewModel : BaseViewModel
    {
		[Display(Name = "퀴즈, 시험 리스트")]
		public IList<Exam> QuizList { get; set; }

		[Display(Name = "주차 리스트")]
		public IList<Inning> WeekList { get; set; }

		[Display(Name = "차시 리스트")]
		public IList<Inning> InningList { get; set; }

		[Display(Name = "프로그램과정 리스트")]
		public IList<TeamProject> ProgramList { get; set; }

		[Display(Name = "학기 리스트")]
		public IList<Term> TermList { get; set; }

		[Display(Name = "강좌번호")]
		public int CourseNo { get; set; }

		[Display(Name = "시험번호")]
		public int ExamNo { get; set; }

		[Display(Name = "학습유형")]
		public string StudyType { get; set; }

		[Display(Name = "퀴즈, 시험 상세")]
		public Exam ExamDetail { get; set; }

		[Display(Name = "주차별 문항수 및 배점 설정 리스트")]
		public IList<ExamRandom> RandomList { get; set; }

		[Display(Name = "문제설정 리스트")]
		public IList<ExamQuestion> QuestionList { get; set; }

		[Display(Name = "응시대상자인원")]
		public int ExamCandidate { get; set; }

		[Display(Name = "미응시자인원")]
		public int ExamNonTaker { get; set; }

		[Display(Name = "현재학기여부")]
		public string CurrentTermYn { get; set; }

		[Display(Name = "학기번호")]
		public int TermNo { get; set; }

		[Display(Name = "주차 코드")]
		public string[] hdnRandomDiffCodes { get; set; }

		[Display(Name = "후보 문항수")]
		public string[] hdnQuestionCnt { get; set; }

		[Display(Name = "출제 문항수")]
		public string[] txtRandomDiffCount { get; set; }

		[Display(Name = "문항당 배점")]
		public string[] txtWeekPoint { get; set; }

		[Display(Name = "문제은행번호")]
		public string[] hdnQuestionBankNos { get; set; }

		[Display(Name = "문제은행 배점")]
		public string[] hdnQuestionScores { get; set; }

		[Display(Name = "퀴즈, 시험 응시대상자 상세")]
		public Examinee ExamineeDetail { get; set; }

		[Display(Name = "이전문항")]
		public int PrePage { get; set; }

		[Display(Name = "현재문항")]
		public int CurrentPage { get; set; }

		[Display(Name = "다음문항")]
		public int NextPage { get; set; }

		[Display(Name = "퀴즈, 시험 항목 상세")]
		public ExamQuestion QuestionDetail { get; set; }

		[Display(Name = "관리자여부")]
		public string AdminYn { get; set; }

		[Display(Name = "문제보기 리스트")]
		public IList<ExamineeReply> QuestionExampleList { get; set; }

		[Display(Name = "최초 설정할 시간(sec)")]
		public int initSecond { get; set; }

		[Display(Name = "문항번호")]
		public string[] hdnQuestionNos { get; set; }

		[Display(Name = "응시자답안(이전)")]
		public string[] hdnOldExamineeAnswers { get; set; }

		[Display(Name = "응시자답안(신규)")]
		public string[] hdnExamineeAnswers { get; set; }

		[Display(Name = "퀴즈, 시험 응시대상자 리스트")]
		public IList<Examinee> ExamineeList { get; set; }

		[Display(Name = "미답변 건수")]
		public int noAnswerCnt { get; set; }

		[Display(Name = "만점")]
		public decimal perfectScore { get; set; }

		[Display(Name = "응시자 객관식, 주관식 점수")]
		public ExamineeReply ExamineeScore { get; set; }

		[Display(Name = "평가점수")]
		public decimal[] hdnScores { get; set; }

		[Display(Name = "평가점수")]
		public int[] hdnReplyNos { get; set; }

		[Display(Name = "총 출제문항수")]
		public int totalCntQuestion { get; set; }

		[Display(Name = "추가시험여부 파라미터")]
		public string AddExamGbn { get; set; }

		[Display(Name = "추가시험 Rowstate")]
		public string AddExamRowstate { get; set; }

		[Display(Name = "추가시험 대상자 UserNo")]
		public long[] chkUserNos { get; set; }

		[Display(Name = "추가시험 대상자 여부")]
		public string[] hdnUserYesNos { get; set; }

		[Display(Name = "프로그램과정")]
		public int ProgramNo { get; set; }

		[Display(Name = "시작번호")]
		public int FirstIndex { get; set; }

		[Display(Name = "종료번호")]
		public int LastIndex { get; set; }
	}
}
