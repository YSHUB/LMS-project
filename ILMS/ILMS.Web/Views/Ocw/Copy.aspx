<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/Copy/<%:ViewBag.Course.CourseNo %>" id="mainForm" method="post">

        <div class="card-body bg-light pb-1">
            <div class="form-row">
                <p class="text-danger font-weight-bold"><i class="bi bi-info-circle-fill"></i><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명을 클릭하면 이전에 등록한 OCW 목록을 가져옵니다.</p>
            </div>

            <div class="form-row align-items-end">
                <div class="form-group col-12 ">
                    <label for="ddlTermNo" class="form-label sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> 선택 <strong class="text-danger">*</strong></label>
                    <select id="ddlTermNo" name="TermNo" class="form-control" onchange="javascript:fnChangeCourse();">
                        <%
                            foreach (var term in Model.TermList)
                            {
                        %>
                               <option value=<%:term.TermNo %> <%:term.TermNo == Model.TermNo ? "selected" : "" %> ><%:term.TermName %></option>
                        <%
                            }
                        %>
                    </select>
                </div>
            </div>

            <div id="">
                <ul class="list-style01">
                    <%
                        if (Model.CourseList.Count > 0)
                        {
                            foreach (var course in Model.CourseList)
                            {

                    %>
                            <li><a href="#" onclick="fnSelectCourse(<%:course.CourseNo %>, this);">[<%:course.TermYear + "/" + course.TermName %>] <%:course.SubjectName %></a></li>
                    <%
                            }
                        }
                        else
                        {
                    %>
                        <li>등록된 강의가 없습니다.</li>
                    <% 
                        }
                    %>

                </ul>

            </div>
        </div>

    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        function fnChangeCourse() {
            fnSubmit();
        }

        function fnSelectCourse(courseNo, obj) {
            opener.fnSelectPreCourse(courseNo, $(obj).text());
            self.close();
        }

    </script>

</asp:Content>
