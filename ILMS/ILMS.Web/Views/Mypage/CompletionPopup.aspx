<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="ContentTitle" ContentPlaceHolderID="Title" runat="server">수료증 출력</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <div class="print">
            <div class="wrap">
                <div class="box">
                    <p class="certi-num">제 <%:Model.LectureUserDetail.PrintDay.Substring(0,4) %>-<%:Model.LectureUserDetail.PrintNum %> 호</p>
                    <h1>수&nbsp;료&nbsp;증</h1>
                    <p class="info">
                        성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 : <%:Model.LectureUserDetail.HangulName %><br />
                        생 년 월 일 : <%:Model.LectureUserDetail.ResidentNo %><br />
                        교 육 과 정 : <%:Model.LectureUserDetail.SubjectName %><br />
                        교 육 기 간 : <%:Model.LectureUserDetail.StartDay %> ~ <%:Model.LectureUserDetail.EndDay %> <br />
                    </p>
                    <p class="copy"><span style="padding-left: 1.2em;"></span>위 사람은 <%:ConfigurationManager.AppSettings["CertIssueDept"].ToString() %>에서 실시한 『<%:Model.LectureUserDetail.SubjectName %>』을(를) 수료하였으므로 이 증서를 수여합니다.</p>
                    <p class="year"><%:Model.LectureUserDetail.PrintDay %></p>
                    <div class="sign">
                        <p class="name"><%:ConfigurationManager.AppSettings["CertIssueNm"].ToString() %></p>
                   </div>
                </div>
            </div>
        </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptBlock" runat="server">
   <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <link href="/common/css/icommon.css" rel="stylesheet" />
    <link href="/site/resource/www/css/print.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            <%if (!ConfigurationManager.AppSettings["CertIssueDept"].ToString().Equals("(사)부산산학융합원")) {%>
            document.getElementsByClassName("name")[0].style.background = "none";
            <%}%>

			document.getElementsByClassName("bg-primary")[0].className += " d-none";
        });
    </script>
</asp:Content>