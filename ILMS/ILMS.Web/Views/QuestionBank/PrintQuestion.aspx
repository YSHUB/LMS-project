<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <div class="p-4">
        <%-- 상단 --%>
        <div class="row">
            <div class="col-md">
                <h2 class="title04">[<span class="text-primary"><%: Model.QuestBankPrtInfo.ExamTitle.ToString() %></span>] 폴더 문항 정보</h2>
            </div>
            <div class="col-md-auto text-right">
                <a href="javascript:window.print();" class="btn btn-lg btn-primary">인쇄</a>
            </div>
        </div>
        <%-- 상단 --%>

        <%-- 문제카드 --%>
        <%
            var preQuestNo = 0;
            var newQuest = "";
            var openFlagLi = "N";
            var openFlagDiv = "N";
            var parentQuestionType = "";
            foreach (var item in Model.QuestBankPrt)
            {
                if (!string.IsNullOrEmpty(item.QuestionType.ToString()))
                {
                    parentQuestionType = item.QuestionType.ToString();
                }

                if (preQuestNo != item.QuestionBankNo)
                {
                    newQuest = "Y"; // 신규문제
                }
                else
                {
                    newQuest = "N";
                }

                if (newQuest == "Y")
                {
                    if (openFlagLi == "Y")
                    {
                        openFlagLi = "N";
        %>          </ol>
    </div>
    </div>
			</div>
	<%
        }

        if (openFlagDiv == "Y")
        {
            openFlagDiv = "N";
    %>
	</div>
	<%
        }

        openFlagDiv = "Y";
    %>
    <div class="card card-style01 mt-4">
        <%                                
            }
            if (item.QAGubun == "A")
            {
        %>
        <div class="card-header">
            <div class="row no-gutters align-items-center">
                <div class="col">

                    <div class="row">
                        <div class="col-md">
                            <p class="title06"><strong class="badge badge-primary mr-2">문제<%:item.RowNo%></strong><%: (item.Contents != null) ? Html.Raw(HttpUtility.UrlDecode(item.Contents.Replace("<p>","").Replace("</p>",""))) : Html.Raw("")%></p>
                        </div>
                        <%
                            if (parentQuestionType == "MJQT003")
                            {
                        %>
                            <div class="col-md-auto text-right">
                                <dl class="row dl-style01">
                                    <dt class="col-auto">정답 수</dt>
                                    <dd class="col-auto"><%:item.AnswerCount%>개</dd>
                                </dl>
                            </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <% if (item.QuestionType == "MJQT001" || item.QuestionType == "MJQT004")
            {
        %>
        <%  
            }
        %>
        <%
            }
            else if ((item.QAGubun == "B" && parentQuestionType != "MJQT004") || item.CorrectAnswerYesNo.ToString() == "Y")
            {

                if (openFlagLi == "N")
                {
                    openFlagLi = "Y";
        %>
        <div class="card-body">
            <div class="row">
                <div class="col-12">

                    <ol class="list-style01">
                        <%
                            }
                        %>
                        <li class="	<%:(Model.CorrectAnswerYesNo.ToString() == "Y") ? "text-primary font-weight-bold" : ""%>">
                            <%-- 사진 입력될 곳 --%>

                            <%:  (item.Contents != null && item.SaveFileName == null) ? item.Contents : "" %>

                            <% 
                                if (Model.CorrectAnswerYesNo.ToString() == "Y" &&(!string.IsNullOrEmpty(item.CorrectAnswerYesNo)? item.CorrectAnswerYesNo.ToString() : "N" )== "Y")
                                {
                            %> 
                                <i class="bi bi-check-circle-fill"></i>
                            <%
                                }
                            %>

                            <%if (item.SaveFileName != null)
                                {
                            %>
                            <div class="form-row">
                                <div class="col-12 col-md-8 col-lg-4">
                                    <img src="/files<%:item.SaveFileName %>" class="w-100" />
                                </div>
                            </div>
                            <%
                              }
                            %>

                        </li>
                        <%
                            }
                                preQuestNo = item.QuestionBankNo;
                            }

                            if (openFlagLi == "Y")
                            {
                                openFlagLi = "N";
                        %>
                    </ol>
                </div>
            </div>
        </div>
        <%
            }

            if (openFlagDiv == "Y")
            {
                openFlagDiv = "N";
        %>
    </div>
    <%
        }
    %>
    <%-- 문제카드 --%>

	</div>

</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

        $(document).ready(function () {

        });// end of ready

    </script>
</asp:Content>
