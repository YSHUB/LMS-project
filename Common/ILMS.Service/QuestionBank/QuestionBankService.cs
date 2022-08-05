using ILMS.Data.Dao;
using ILMS.Design.Domain;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace ILMS.Service
{
	public class QuestionBankService : BaseService
    {
        public QuestionBankDao questionBankDao { get; set; }

    }

}
