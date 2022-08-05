using System.Collections.Generic;
using ILMS.Design.Domain;

namespace ILMS.Design.ViewModels
{
	public class PrintQuestionsViewModel : Common
	{
        public string ID { get; set; }
        public int GubunNo { get; set; }
        public string CorrectAnswerYesNo { get; set; }
        public QuestionBankPrintInfo QuestBankPrtInfo { get; set; }
        public IList<QuestionBankPrint> QuestBankPrt { get; set; }
    }
}