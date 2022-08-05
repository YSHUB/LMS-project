using ILMS.Core.System;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using ILMS.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace ILMS.Web.Controllers
{
	[AuthorFilter(IsMember = true)]
    [RoutePrefix("QuestionBank")]
    public class QuestionBankController : WebBaseController
    {
        public AccountService accountSvc { get; set; }
        public QuestionBankService questionBankSvc { get; set; }

        #region Method

        public IList<QuestionBankQuestion> GetQuestionList(QuestionViewModel vm)
        {
            Hashtable htQuestionList = new Hashtable();
            htQuestionList.Add("RowState", "L");
            htQuestionList.Add("DeleteYesNo", "N");
            htQuestionList.Add("UseYesNo", vm.UseYesNo);
            htQuestionList.Add("Difficulty", string.IsNullOrEmpty(vm.Difficulty) ? null : vm.Difficulty);
            htQuestionList.Add("Question", vm.Question);
            htQuestionList.Add("CreateUserNo", sessionManager.UserNo);
            if (vm.GubunNo > 0) htQuestionList.Add("GubunNo", vm.GubunNo);
            htQuestionList.Add("QuestionBankType", vm.QuestionBankType);
            htQuestionList.Add("FirstIndex", vm.PageNum == null ? 1 : FirstIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
            htQuestionList.Add("LastIndex", vm.PageRowSize == null ? 10000 : LastIndex(Convert.ToInt32(vm.PageRowSize), Convert.ToInt32(vm.PageNum)));
            htQuestionList.Add("SearchText", vm.SearchText ?? "");
            htQuestionList.Add("QuestionType", vm.QuestionType);

            return baseSvc.GetList<QuestionBankQuestion>("questionBankQuestion.QUESTION_SELECT_L", htQuestionList);
        }

		private IList<QuestionBankGubun> GetCategoryList(string questionType = null, string categoryName = null)
        {

            Hashtable paramCategoryHash = new Hashtable();
            paramCategoryHash.Add("RowState", "L");

            paramCategoryHash.Add("DeleteYesNo", "N");
            paramCategoryHash.Add("GubunNo", 0);
            paramCategoryHash.Add("CreateUserNo", sessionManager.UserNo);

            if (questionType != null)
            {
                paramCategoryHash.Add("QuestionType", questionType);
            }
            else
            {
                paramCategoryHash.Add("QuestionType", "MJTP001");
            }

            if (categoryName != null)
            {
                paramCategoryHash.Add("GubunCodeName", categoryName);
            }

            return baseSvc.GetList<QuestionBankGubun>("questionBankGubun.QUESTION_CATEGORY_SELECT_L", paramCategoryHash);
        }

        #endregion

        [Route("Index")]
        [Route("Index/{param1}/{param2}/{param3}")]
        public ActionResult Index(QuestionViewModel vm, string param1, int? param2)
        {
            if (TempData["Message"] != null)
            {
                vm.Message = TempData["Message"].ToString();
            }

            if (!string.IsNullOrEmpty(param2.ToString()))
            {
                vm.GubunNo = (int)param2;
            }

            string test;
            test = string.Format("test{0}{1}{2}", 1, 2, 3);

            vm.QuestionBankType = param1 ?? "MJTP001";
            vm.QuestionType = vm.QuestionType ?? "";
            vm.UseYesNo = vm.UseYesNo ?? "Y";
            vm.Difficulty = vm.Difficulty ?? "";
            vm.PageRowSize = vm.PageRowSize ?? 10000;
            vm.PageNum = vm.PageNum ?? 1;

            vm.CategoryList = GetCategoryList();

            vm.GubunName = vm.CategoryList.Where(x => x.GubunNo.Equals(param2)).Select(x => x.GubunCodeName).SingleOrDefault();

            Hashtable htQuestion = new Hashtable();
            htQuestion.Add("RowState", "B");
            htQuestion.Add("CreateUserNo", sessionManager.UserNo);
            htQuestion.Add("DeleteYesNo", "N");
            htQuestion.Add("GubunType", vm.QuestionBankType);
            htQuestion.Add("GubunNo", vm.GubunNo);
            

            vm.QuestionTypeCountList = baseSvc.GetList<QuestionBankQuestion>("questionBankQuestion.QUESTION_SELECT_B", htQuestion);

            vm.QuestionList = GetQuestionList(vm);

            
            vm.PageTotalCount = vm.QuestionList.FirstOrDefault() != null ? vm.QuestionList.FirstOrDefault().TotalCount : 0;
            vm.Dic = new RouteValueDictionary { { "SearchText", vm.SearchText }, { "pagerowsize", vm.PageRowSize },{"GubunNo",vm.GubunNo },{ "QuestionType", vm.QuestionType } };

            return View(vm);
        }

		[Route("List")]
		[Route("List/{param1}/{param2}")]
        public ActionResult List(QuestionViewModel vm, string param1, int? param2)
        {

            vm.QuestionBankType = param1 ?? "MJTP001";//시험문항
            vm.UseYesNo = vm.UseYesNo ?? "Y";
            vm.Difficulty = vm.Difficulty ?? "";
            vm.CategoryList = GetCategoryList();
            vm.PageRowSize = vm.PageRowSize ?? 10000;
            vm.PageNum = vm.PageNum ?? 1;

            Hashtable htQuestionTypeCountList = new Hashtable();
            htQuestionTypeCountList.Add("RowState", "B");
            htQuestionTypeCountList.Add("CreateUserNo", sessionManager.UserNo);
            htQuestionTypeCountList.Add("DeleteYesNo", "N");
            htQuestionTypeCountList.Add("GubunType", vm.QuestionBankType);
            vm.QuestionTypeCountList = baseSvc.GetList<QuestionBankQuestion>("questionBankQuestion.QUESTION_SELECT_B", htQuestionTypeCountList);

            if (!string.IsNullOrEmpty(param2.ToString()))
            {
                vm.GubunNo = (int)param2;
            }

            vm.QuestionList = GetQuestionList(vm);
            vm.PageTotalCount = 0;
            vm.Dic = new RouteValueDictionary { { "SearchText", vm.SearchText }, { "pagerowsize", vm.PageRowSize } };

            return View(vm);
        }

        [Route("Write")]
        [Route("Write/{param1}/{param2}")]
        public ActionResult Write(string param1 = "MJTP001", int? param2 = 0)
        {
            QuestionViewModel vm = new QuestionViewModel();

            vm.CategoryList = GetCategoryList();
            vm.GubunName = vm.CategoryList.Where(x => x.GubunNo.Equals(param2)).Select(x => x.GubunCodeName).FirstOrDefault();
            if (string.IsNullOrEmpty(param1)) param1 = "MJTP001";
            vm.QuestionBankType = param1;

            Code paramCode = new Code("A", new string[] { "MJTP", "MJQT", "MJDF" });
            vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", paramCode);
            vm.GubunNo = (int)param2;

            return View(vm);
        }
        
        [HttpPost]
        public ActionResult Write(QuestionViewModel vm)
        {

            Hashtable htQuestionBankNo = new Hashtable();
            htQuestionBankNo.Add("RowState", "C");

            #region 파일관련Start

            string saveFolderName = DateTime.Now.ToString("yyyyMMdd");
            Hashtable hashFileFolder = new Hashtable();
            hashFileFolder.Add("RowState", "S");
            hashFileFolder.Add("FolderName", "MJBANK");
            string subFolderName = baseSvc.Get<FileFolder>("common.FILEFOLDER_SELECT_S", hashFileFolder).FolderName;
            #endregion 파일관련 End

            Hashtable htQuestion = new Hashtable();

            htQuestion.Add("RowState", "C");
            htQuestion.Add("Difficulty", (vm.ID == "MJTP002") ? "MJDF001" : vm.Difficulty);
            htQuestion.Add("DeleteYesNo", "N");
            htQuestion.Add("CreateUserNo", sessionManager.UserNo);
            htQuestion.Add("AnswerExplain", vm.AnswerExplain);
            if (!string.IsNullOrEmpty(vm.Question)) htQuestion.Add("Question", Server.UrlDecode(vm.Question.Replace("/Files/Temp", string.Format(@"{0}/{1}/{2}/{3}", ConfigurationManager.AppSettings["BaseUrl"].ToString(), FileRootFolder, saveFolderName, subFolderName))));
            htQuestion.Add("UpdateUserNo", sessionManager.UserNo);
            htQuestion.Add("UseYesNo", vm.UseYesNo == "on" ? "Y" : "N");
            htQuestion.Add("GubunNo", vm.GubunNo);
            htQuestion.Add("QuestionType", vm.QuestionEntity.QuestionType);

            int rsBankNo = baseSvc.Get<int>("questionBankQuestion.QUESTION_SAVE_C", htQuestion);

            List<Hashtable> lstExample = new List<Hashtable>();

            if (!vm.QuestionEntity.QuestionType.Equals("MJQT001"))
            {

                List<string> lstAsnwerNo = new List<string>();

                foreach (string item in vm.CorrectAnswerYesNo)
                {
                    lstAsnwerNo.Add(item);
                }

                for (int i = 0; i < vm.ExampleContents.Length; i++)
                {

                    if (!string.IsNullOrEmpty(vm.ExampleContents[i]))
                    {
                        Hashtable htExample = new Hashtable();

                        QuestionBankExample temp = new QuestionBankExample();
                        long? tempFileGroupNo = 0;
                        tempFileGroupNo = SaveFile(Request.Files, "MJBANKFile", tempFileGroupNo, "MJBANK", i);
                        temp.FileGroupNo = tempFileGroupNo == null ? 0 : (int)tempFileGroupNo;

                        htExample.Add("RowState", "C");
                        htExample.Add("ExampleContents", vm.ExampleContents[i]);
                        htExample.Add("GubunNo", vm.GubunNo);
                        htExample.Add("QuestionBankNo", rsBankNo);
                        htExample.Add("FileGroupNo", temp.FileGroupNo);

                        if (vm.QuestionEntity.QuestionType.Equals("MJQT004"))
                        {
                            htExample.Add("CorrectAnswerYesNo", "Y");
                        }
                        else if (vm.QuestionEntity.QuestionType.Equals("MJQT002") || vm.QuestionEntity.QuestionType.Equals("MJQT003"))//다중선택
                        {
                            if (lstAsnwerNo.Contains((i + 1).ToString()))
                                htExample.Add("CorrectAnswerYesNo", "Y");
                            else
                                htExample.Add("CorrectAnswerYesNo", "N");
                        }
                        lstExample.Add(htExample);

                    }
                }
            }
            int rs = 0;

            foreach (Hashtable item in lstExample)
            {
                rs += baseSvc.Save("questionBankExample.QUESTION_EXAMPLE_SAVE_C", item);
            }

            return RedirectToAction(String.Format("Index/{0}/{1}", vm.QuestionBankType, vm.GubunNo));

        }

        [Route("Update")]
        [Route("Update/{param1}/{param2}")]
        public ActionResult Update(QuestionViewModel vm, string param1, int? param2, int? param3)
        {
            vm.QuestionBankType = param1;
            vm.GubunNo = (int)param2;

            //문제 정보 조회
            Hashtable htQuestion = new Hashtable();
            htQuestion.Add("RowState", "S");
            htQuestion.Add("QuestionBankNo", param3);
            vm.QuestionEntity = baseSvc.Get<QuestionBankQuestion>("questionBankQuestion.QUESTION_SELECT_S", htQuestion);

            //문제 예제 목록 조회
            Hashtable htExample = new Hashtable();
            htExample.Add("RowState", "L");
            htExample.Add("QuestionBankNo", param3);
            vm.ExampleEntity = baseSvc.GetList<QuestionBankExample>("questionBankExample.QUESTION_EXAMPLE_SELECT_L", htExample);

            //파일조회
            foreach (var item in vm.ExampleEntity)
            {
                Hashtable htfile = new Hashtable();
                htfile.Add("RowState", "L");
                htfile.Add("FileGroupNo", item.FileGroupNo);
                item.fileList = baseSvc.GetList<Design.Domain.File>("common.FILE_SELECT_L", htfile);
            }

            //좌측 문제폴더 조회
            vm.CategoryList = GetCategoryList();

            vm.GubunName = vm.QuestionEntity.GubunName;
            if (string.IsNullOrEmpty(param1))
            {
                param1 = "MJTP001";
            }

            

            // 공통코드 (문제은행유형)
            Code paramCode = new Code("A", new string[] { "MJTP", "MJQT", "MJDF" });
            vm.BaseCode = baseSvc.GetList<Code>("common.DETAILCODE_SELECT_A", paramCode);
            

            return View(vm);
        }

        /*
		 [] 내용에 첨부된 이미지 업로드하도록 기능 생성 필요
		 */
        [HttpPost]
        public ActionResult Update(QuestionViewModel vm)
        {

            #region 기존 내용 조회

            Hashtable htQuestionSelect = new Hashtable();
            htQuestionSelect.Add("RowState", "S");
            htQuestionSelect.Add("QuestionBankNo", vm.QuestionEntity.QuestionBankNo);

            vm.QuestionEntity = baseSvc.Get<QuestionBankQuestion>("questionBankQuestion.QUESTION_SELECT_S", htQuestionSelect);

            Hashtable htExampleEntity = new Hashtable();
            htExampleEntity.Add("RowState", "L");
            htExampleEntity.Add("QuestionBankNo", vm.QuestionEntity.QuestionBankNo);
            vm.ExampleEntity = baseSvc.GetList<QuestionBankExample>("questionBankExample.QUESTION_EXAMPLE_SELECT_L", htExampleEntity);
            #endregion

            string saveFolderName = DateTime.Now.ToString("yyyyMMdd");
            string subFolderName = "MJBANK";


            #region 문제 수정
            Hashtable htQuestionUpdate = new Hashtable();

            htQuestionUpdate.Add("RowState", "U");
            htQuestionUpdate.Add("GubunNo", vm.GubunNo);
            htQuestionUpdate.Add("AnswerExplain", vm.AnswerExplain);
            htQuestionUpdate.Add("UpdateUserNo", sessionManager.UserNo);
            htQuestionUpdate.Add("UseYesNo", vm.UseYesNo == "on" ? "Y" : "N");
            htQuestionUpdate.Add("Difficulty", (vm.ID == "MJTP002") ? "MJDF001" : vm.Difficulty);
            htQuestionUpdate.Add("QuestionBankNo", vm.QuestionEntity.QuestionBankNo);

            if (vm.GubunNo != vm.GubunNoOri)
            {
                baseSvc.Save("questionBankQuestion.QUESTION_SAVE_A", htQuestionUpdate);
            }

            if (!string.IsNullOrEmpty(vm.Question))
            {
                htQuestionUpdate.Add("Question", Server.UrlDecode(vm.Question.Replace("/Files/Temp", string.Format(@"{0}/{1}/{2}/{3}", ConfigurationManager.AppSettings["BaseUrl"].ToString(), FileRootFolder, saveFolderName, subFolderName))));
            }

            baseSvc.Get<int>("questionBankQuestion.QUESTION_SAVE_U", htQuestionUpdate);
            

            #endregion

            #region 예제 수정
            if (!vm.QuestionEntity.QuestionType.Equals("MJQT001"))
            {

                //선택 문제에서 선택된 값을 불러온다.
                List<string> lstAsnwerNo = new List<string>();
                foreach (string item in vm.CorrectAnswerYesNo)
                {
                    lstAsnwerNo.Add(item);
                }

                //예제를 수정하기 위한 리스트
                List<Hashtable> lstExample = new List<Hashtable>();

                for (int i = 0; i < Request.Files.Count; i++)
                {

                }

                for (int i = 0; i < vm.ExampleContents.Length; i++)
                {

                    if (!string.IsNullOrEmpty(vm.ExampleContents[i]))
                    {
                        Hashtable htExample = new Hashtable();

                        QuestionBankExample temp = new QuestionBankExample();
                        long? tempFileGroupNo = 0;

                        for (int j = 0; j < Request.Files.Count; j++)
                        {
                            if ("QuestionExampleFile_" + (i + 1) == Request.Files.AllKeys[j])
                            {
                                tempFileGroupNo = SaveFile(Request.Files, "QuestionExampleFile_" + (i + 1), tempFileGroupNo, "MJBANK", j);
                            }
                        }

                        temp.FileGroupNo = tempFileGroupNo == null ? 0 : (int)tempFileGroupNo;

                        htExample.Add("RowState", "U");
                        htExample.Add("ExampleContents", vm.ExampleContents[i]);
                        htExample.Add("GubunNo", vm.GubunNo);
                        htExample.Add("QuestionBankNo", vm.QuestionEntity.QuestionBankNo);
                        if (temp.FileGroupNo != null)
                        {
                            htExample.Add("FileGroupNo", temp.FileGroupNo);
                        }
                        htExample.Add("ExampleNo", vm.ExampleEntity[i].ExampleNo);

                        if (vm.QuestionEntity.QuestionType.Equals("MJQT004"))//단답형
                        {
                            htExample.Add("CorrectAnswerYesNo", "Y");
                        }
                        else if (vm.QuestionEntity.QuestionType.Equals("MJQT002") || vm.QuestionEntity.QuestionType.Equals("MJQT003"))//다중선택
                        {

                            if (lstAsnwerNo.Contains((i).ToString()))
                            {
                                htExample.Add("CorrectAnswerYesNo", "Y");
                            }
                            else
                            {
                                htExample.Add("CorrectAnswerYesNo", "N");
                            }
                        }
                        lstExample.Add(htExample);
                    }
                }

                int rs = 0;

                foreach (Hashtable item in lstExample)
                {
                    rs += baseSvc.Save("questionBankExample.QUESTION_EXAMPLE_SAVE_U", item);
                }

            }
            #endregion



            return RedirectToAction(String.Format("Index/{0}/{1}", vm.QuestionBankType, vm.GubunNo));
        }

        [Route("PrintQuestion")]
        public ActionResult PrintQuestion(PrintQuestionsViewModel vm)
        {

            int GubunNo = vm.GubunNo;
            string CorrectAnswerYesNo = vm.CorrectAnswerYesNo;

            Hashtable paramHash = new Hashtable();
            paramHash.Add("RowState", "A");
            paramHash.Add("GubunNo", GubunNo);
            vm.QuestBankPrtInfo = baseSvc.Get<QuestionBankPrintInfo>("questionBankPrintInfo.QUESTION_PRINT_SELECT_A", paramHash);

            Hashtable paramHash2 = new Hashtable();
            paramHash2.Add("RowState", "L");
            paramHash2.Add("GubunNo", GubunNo);
            paramHash2.Add("CorrectAnswerYesNo", CorrectAnswerYesNo);
            vm.QuestBankPrt = baseSvc.GetList<QuestionBankPrint>("questionBankPrint.QUESTION_PRINT_SELECT_L", paramHash2);

            return View(vm);
        }

        public ActionResult ExcelDownload(QuestionViewModel vm)
        {
            Hashtable hashtable = new Hashtable();
            hashtable.Add("RowState", "L");
            hashtable.Add("GubunNo", vm.GubunNo);
            vm.ExampleEntity = baseSvc.GetList<QuestionBankExample>("questionBankExample.QUESTION_EXAMPLE_SELECT_L", hashtable);

            List<QuestionBankExample> questionNos = (from c in vm.ExampleEntity
                                                     group c by c.QuestionBankNo into gp
                                                     select new QuestionBankExample
                                                     {
                                                         QuestionBankNo = gp.Key,
                                                         AnswerExplain = gp.Max(p => p.AnswerExplain),
                                                         Question = gp.Max(p => p.Question),
                                                         Difficulty = gp.Max(p => p.Difficulty),
                                                         QuestionType = gp.Max(p => p.QuestionType)
                                                     }).ToList();

            foreach (var item in questionNos)
            {
                var temp = (from c in vm.ExampleEntity
                            where c.QuestionBankNo == item.QuestionBankNo
                            select c).OrderBy(c => c.ExampleNo).ToList();
                for (int i = 0; i < temp.Count(); i++)
                {
                    switch (i)
                    {
                        case 0:
                            item.Exam1 = temp[i].ExampleContents;
                            break;
                        case 1:
                            item.Exam2 = temp[i].ExampleContents;
                            break;
                        case 2:
                            item.Exam3 = temp[i].ExampleContents;
                            break;
                        case 3:
                            item.Exam4 = temp[i].ExampleContents;
                            break;
                        case 4:
                            item.Exam5 = temp[i].ExampleContents;
                            break;
                        default:
                            break;
                    }
                    if (temp[i].CorrectAnswerYesNo != null && temp[i].CorrectAnswerYesNo.Equals("Y")) item.Answer = (i + 1).ToString();
                    if (!string.IsNullOrEmpty(temp[i].Answer)) item.Answer = temp[i].Answer;
                }
            }

            foreach (var item in questionNos)
            {
                item.Question = Server.UrlDecode(item.Question);
                var imgStr = Regex.Matches(Server.UrlDecode(item.Question), @"<img([^>]*[^/])>");
                if (imgStr.Count > 0)
                {
                    for (int i = 0; i < imgStr.Count; i++)
                    {
                        try
                        {
                            item.Question = item.Question.Remove(imgStr[i].Index, imgStr[i].Length);
                        }
                        catch (Exception)
                        {
                            throw;
                        }
                    }
                }
            }

            string[] headers = new string[] { "문제번호", "문제내용", "문제주차", "보기1", "보기2", "보기3", "보기4", "보기5", "답안", "답안설명", "문제타입" };
            string[] colums = new string[] { "QuestionBankNo", "Question", "Difficulty", "Exam1", "Exam2", "Exam3", "Exam4", "Exam5", "Answer", "AnswerExplain", "QuestionType" };
            return ExportExcel(headers, colums, questionNos, "Question");

        }

        public ActionResult ExcelUpload(QuestionViewModel vm)
        {
            if (string.IsNullOrEmpty(vm.QuestionBankType))
            {
                vm.QuestionBankType = "MJTP001";

            }

            HttpPostedFileBase f = Request.Files[0];

            string fileName = "";
            string fileNewName = "";
            string fileSize = "";
            string fileType = "";
            if (!Directory.Exists(Server.MapPath("/Files/Temp")))
            {
                Directory.CreateDirectory(Server.MapPath("/Files/Temp/"));
            }
            if (f != null && !string.IsNullOrEmpty(f.FileName))
            {
                fileName = f.FileName.Split('\\').Last();
                fileNewName = sessionManager.UserNo.ToString() + "_" + DateTime.Now.ToString("yyyyMMddHHmmssFFF") + "." + f.FileName.Split('.').Last();
                fileSize = f.ContentLength.ToString();
                fileType = f.FileName.Split('.').Last(); //f.ContentType;
                f.SaveAs(Server.MapPath("/Files/Temp/" + fileNewName));

            }

            string connString = string.Empty;
            string systemCheck = string.Empty;

            if (Environment.Is64BitOperatingSystem) systemCheck = "64";
            else systemCheck = "32";

            if (systemCheck.Equals("64"))
            {
                connString = String.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=Excel 12.0 Xml;", Server.MapPath("/Files/Temp/" + fileNewName));
            }
            else
            {
                connString = String.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=Excel 8.0;", Server.MapPath("/Files/Temp/" + fileNewName));
            }

            OleDbConnection oledbConn = new OleDbConnection(connString);

            try
            {
                oledbConn.Open();
                OleDbCommand cmd = new OleDbCommand("SELECT * FROM [Sheet1$]", oledbConn);
                OleDbDataAdapter oleda = new OleDbDataAdapter();
                oleda.SelectCommand = cmd;
                DataSet ds = new DataSet();
                oleda.Fill(ds, "MBank");
                var tempQuestion = from c in ds.Tables[0].AsEnumerable()
                                   select c;
                List<QuestionBankExample> uploadData = new List<QuestionBankExample>();
                foreach (var item in tempQuestion)
                {
                    QuestionBankExample temp = new QuestionBankExample();

                    temp.QuestionBankNo = item.Field<object>("문제번호") == null ? 0 : int.Parse(item.Field<object>("문제번호").ToString());
                    temp.Question = item.Field<object>("문제내용") == null ? "" : (item.Field<object>("문제내용").ToString());
                    temp.Difficulty = item.Field<object>("예상주차") == null ? "" : "MJDF" + (item.Field<object>("예상주차").ToString());
                    temp.Exam1 = item.Field<object>("보기1") == null ? "" : (item.Field<object>("보기1").ToString());
                    temp.Exam2 = item.Field<object>("보기2") == null ? "" : (item.Field<object>("보기2").ToString());
                    temp.Exam3 = item.Field<object>("보기3") == null ? "" : (item.Field<object>("보기3").ToString());
                    temp.Exam4 = item.Field<object>("보기4") == null ? "" : (item.Field<object>("보기4").ToString());
                    temp.Exam5 = item.Field<object>("보기5") == null ? "" : (item.Field<object>("보기5").ToString());
                    temp.Answer = item.Field<object>("답안") == null ? "" : (item.Field<object>("답안").ToString());
                    temp.AnswerExplain = item.Field<object>("답안설명") == null ? "" : (item.Field<object>("답안설명").ToString());
                    temp.QuestionType = item.Field<object>("문항유형") == null ? "" : "MJQT" + (item.Field<object>("문항유형").ToString());
                    uploadData.Add(temp);
                }

                QuestionAndExampleInsert(vm.GubunNo, uploadData, (int)sessionManager.UserNo);
                TempData["Message"] = "SUCCESS";

            }
			catch
			{
                TempData["Message"] = "FAIL";
            }
            finally
            {
                oledbConn.Close();
            }

            return RedirectToAction(String.Format("Index/{0}/{1}", vm.QuestionBankType, vm.GubunNo));
        }

        public List<string> QuestionAndExampleInsert(int paramGubunNo, List<QuestionBankExample> paramBean, int paramCreateUserNo)
        {
            List<string> errorRow = new List<string>();

            List<QuestionBankQuestion> questions = new List<QuestionBankQuestion>();
            List<QuestionBankExample> examples = new List<QuestionBankExample>();
            int index = 1;

            foreach (var item in paramBean)
            {

                QuestionBankQuestion question = new QuestionBankQuestion();

                question.QuestionBankNo = item.QuestionBankNo;
                question.UseYesNo = "Y";
                question.Difficulty = item.Difficulty;
                question.QuestionType = item.QuestionType;
                question.Question = item.Question;
                question.DeleteYesNo = "N";
                question.CreateUserNo = paramCreateUserNo;
                question.UpdateUserNo = paramCreateUserNo;
                question.AnswerExplain = item.AnswerExplain;
                question.GubunNo = paramGubunNo;
                question.UseCount = 0;

                for (int i = 0; i < 5; i++)
                {
                    QuestionBankExample example = new QuestionBankExample();
                    example.QuestionBankNo = item.QuestionBankNo;
                    example.GubunNo = paramGubunNo;

                    if (item.QuestionType.Equals("MJQT004")) // 단답형
                    {
                        string[] shortAns = item.Answer.Split(',');

                        for (int j = 0; j < shortAns.Length; j++)
                        {
                            if (i == j)
                            {
                                example.ExampleContents = Regex.Replace(shortAns[j], " ", "").Trim();
                                example.CorrectAnswerYesNo = "Y";
                            }
                        }

                        example.ExampleContents = example.ExampleContents ?? string.Empty;
                        example.CorrectAnswerYesNo = example.CorrectAnswerYesNo ?? "N";

                        examples.Add(example);

                    }
                    else
                    {
                        switch (i)
                        {
                            case 0:
                                if (!string.IsNullOrEmpty(item.Exam1))
                                    example.ExampleContents = item.Exam1;
                                break;
                            case 1:
                                if (!string.IsNullOrEmpty(item.Exam2))
                                    example.ExampleContents = item.Exam2;
                                break;
                            case 2:
                                if (!string.IsNullOrEmpty(item.Exam3))
                                    example.ExampleContents = item.Exam3;
                                break;
                            case 3:
                                if (!string.IsNullOrEmpty(item.Exam4))
                                    example.ExampleContents = item.Exam4;
                                break;
                            case 4:
                                if (!string.IsNullOrEmpty(item.Exam5))
                                    example.ExampleContents = item.Exam5;
                                break;
                        }

                        if (item.QuestionType.Equals("MJQT003"))  // 다중선택
                        {
                            string[] multiAns = item.Answer.Split(',');

                            for (int k = 0; k < multiAns.Length; k++)
                            {
                                if ((i + 1) == int.Parse(multiAns[k]))
                                {
                                    example.CorrectAnswerYesNo = "Y";
                                }

                            }
                            if (!string.IsNullOrEmpty(example.ExampleContents))
                            {
                                example.CorrectAnswerYesNo = example.CorrectAnswerYesNo ?? "N";
                                examples.Add(example);
                            }
                            else
                            {
                                break;
                            }
                        }
                        else if (item.QuestionType.Equals("MJQT002")) // 단일선택
                        {

                            example.CorrectAnswerYesNo = ((i + 1) == int.Parse(item.Answer)) ? "Y" : "N";
                            if (!string.IsNullOrEmpty(example.ExampleContents))
                            {
                                examples.Add(example);
                            }
                            else
                            {
                                break;
                            }
                        }
                        else if (item.QuestionType.Equals("MJQT001")) //서술형
                        {
                            example.Answer = item.Answer;
                            examples.Add(example);
                            break;
                        }
                    }
                }

                index++;

                if (!string.IsNullOrEmpty(item.QuestionType) && !string.IsNullOrEmpty(item.Difficulty))
                {
                    questions.Add(question);
                }

            }

            int rsCount = 0;

            foreach (var item in questions)
            {
                long tempSeq = item.QuestionBankNo;
                int rsBankNo = baseSvc.Get<int>("questionBankQuestion.QUESTION_SAVE_C", item);
                var newExamples = (from c in examples
                                   where c.QuestionBankNo == tempSeq
                                   select c).ToList<QuestionBankExample>();
                foreach (var ex in newExamples)
                {
                    ex.QuestionBankNo = rsBankNo;
                    rsCount += baseSvc.Get<int>("questionBankExample.QUESTION_EXAMPLE_SAVE_C", ex);
                }

            }

            return errorRow;
        }


        /// <summary>
        /// 카테고리(폴더) 생성
        /// </summary>
        /// <param name="paramQuestionType"></param>
        /// <param name="paramCategoryName"></param>
        /// <param name="paramGubunNo"></param>
        /// <returns></returns>
        [Route("CategoryCreate")]
        public JsonResult CategoryCreate(string paramQuestionBankType, string paramCategoryName, int paramGubunNo)
        {

            IList<QuestionBankGubun> duplicateList = GetCategoryList(null, paramCategoryName);

            if (duplicateList.Count > 0)
            {
                return this.Json(-1);
            }

            int rs = 0;

            Hashtable hashtable = new Hashtable();
            hashtable.Add("GubunCodeName", paramCategoryName);
            hashtable.Add("QuestionType", paramQuestionBankType);
            hashtable.Add("CreateUserNo", sessionManager.UserNo);
            hashtable.Add("UpdateUserNo", sessionManager.UserNo);
            hashtable.Add("DeleteYesNo", "N");

            if (paramGubunNo > 0)
            {
                hashtable.Add("RowState", "A");
                hashtable.Add("GubunNo", paramGubunNo);
                rs = baseSvc.Save("questionBankGubun.QUESTION_CATEGORY_SAVE_A", hashtable);
            }
            else
            {
                hashtable.Add("RowState", "C");
                rs = baseSvc.Save("questionBankGubun.QUESTION_CATEGORY_SAVE_C", hashtable);
            }
            if (rs > 0)
            {
                return this.Json(GetCategoryList());
            }
            else
            {
                return this.Json(0);
            }

        }

        /// <summary>
        /// 카테고리(폴더) 삭제
        /// </summary>
        /// <param name="paramGubunNo"></param>
        /// <returns></returns>
        [Route("CategoryDelete")]
        public JsonResult CategoryDelete(int paramGubunNo)
        {
            int cnt = 0;
            
            Hashtable hashtable = new Hashtable();
            hashtable.Add("RowState", "D");
            hashtable.Add("GubunNo", paramGubunNo);

            try
            {
                cnt = baseSvc.Save("questionBankGubun.QUESTION_CATEGORY_SAVE_D", hashtable);

            } catch (Exception ex)
			{
                string errorMsg = ex.Message;
                cnt = -1;
			}

            return this.Json(cnt);
        }

        /// <summary>
        /// 카테고리(폴더) 수정
        /// </summary>
        /// <param name="paramQuestionType"></param>
        /// <param name="paramCategoryName"></param>
        /// <param name="paramGubunNo"></param>
        /// <returns></returns>
        [Route("CategoryUpdate")]
        public JsonResult CategoryUpdate(string paramQuestionType, string paramCategoryName, int paramGubunNo)
        {

            Hashtable hashtable = new Hashtable();
            hashtable.Add("RowState", "U");
            hashtable.Add("QuestionType", paramQuestionType);
            hashtable.Add("GubunCodeName", paramCategoryName);
            hashtable.Add("GubunNo", paramGubunNo);

            return this.Json(baseSvc.Save("questionBankGubun.QUESTION_CATEGORY_SAVE_U", hashtable));
        }

        /// <summary>
        /// 문항 삭제
        /// </summary>
        /// <param name="qNo"></param>
        /// <returns></returns>
        [Route("DeleteQuestion")]
        public JsonResult DeleteQuestion(string qNo)
        {
            string[] arrQNO = qNo.Split(',');
            int rs = 0;
            for (int i = 0; i < arrQNO.Length; i++)
            {

                if (!string.IsNullOrEmpty(arrQNO[i]))
                {
                    Hashtable hashtable = new Hashtable();
                    hashtable.Add("RowState", "D");
                    hashtable.Add("QuestionBankNo", arrQNO[i]);
                    hashtable.Add("DeleteYesNo", "Y");
                    hashtable.Add("UpdateUserNo", sessionManager.UserNo);
                    rs += baseSvc.Save("questionBankQuestion.QUESTION_SAVE_D", hashtable);
                }

            }
            return Json(rs);
        }

        public JsonResult TempFileUpload()
        {
            string fileNewName = "";
            string fileFolderPath = Server.MapPath(string.Format(@"\{0}\{1}", FileRootFolder, "Temp"));
            DirectoryInfo dir = new DirectoryInfo(fileFolderPath);
            if (dir.Exists)
            {
                fileNewName = this.TempFileSave(Request.Files, fileFolderPath);
            }
            else
            {
                dir.Create();
                fileNewName = this.TempFileSave(Request.Files, fileFolderPath);
            }
            return this.Json(fileNewName);
        }

        private string TempFileSave(HttpFileCollectionBase files, string fileFolderPath)
        {
            string fileExt = Path.GetExtension(files[0].FileName);
            string newFileName = DateTime.Now.ToString("yyyyMMddHHmmssfff");
            string fileFullPath = string.Format(@"{0}\{1}{2}", fileFolderPath, newFileName, fileExt);
            files[0].SaveAs(fileFullPath);

            return files[0].FileName + ";" + newFileName + fileExt + ";" + files[0].ContentLength.ToString() + ";" + fileExt.Replace(".", "");
        }

    }
}