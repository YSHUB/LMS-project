<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ImportViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <link href="/site/resource/www/css/contents.css" rel="stylesheet">
    <form id="mainForm" action="/Import/ImportLogList" method="post">
        <!-- 탭버튼 -->
        <ul class="nav nav-tabs">
            <li class="nav-item"><a class="nav-link" href="ImportAssign">소속정보</a> </li>
            <li class="nav-item"><a class="nav-link" href="ImportMember">회원정보</a> </li>
            <li class="nav-item"><a class="nav-link" href="ImportSubject"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>정보</a> </li>
            <li class="nav-item"><a class="nav-link" href="ImportCourse">분반정보</a> </li>
            <li class="nav-item"><a class="nav-link" href="ImportLecture">수강정보</a></li>
            <li class="nav-item"><a class="nav-link active show" href="ImportLogList">연동로그</a> </li>
        </ul>
        <!-- 탭버튼종료 -->
        <div class="row">
            <div class="col-lg-12">
                <div class="alert alert-light bg-light mt-3">
                    <div class="font-size-14">
                        ※ 학사연동을 처음 하시는 경우, 반드시 <span class="text-danger">소속정보 &gt; 회원정보 &gt; <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>정보 &gt; 분반정보 &gt; 수강정보</span>
                        순서대로 연동해 주세요.
                    </div>
				</div>
                <div class="card mb-3">
                    <div class="card-header">
                        <h3 class="card-header-title">연동로그 조회(<strong class="text-primary"><%=Model.PageTotalCount.ToString("#,##0") %></strong>건)</h3>
                    </div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="col-8">
                                <label>연동일 : </label>
                                <div class="input-group">
                                    <input class="form-control" name="StartDate" id="txtStartDate" title="StartDate" type="text" autocomplete="off"  value="<%:Model.StartDate %>" >
                                    <div class="input-group-append">
                                       	<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
                                    </div>
                                    <span class="input-group-text">~</span>
                                    <input class="form-control" name="EndDate" id="txtEndDate" title="EndDate" type="text" autocomplete="off" value="<%:Model.EndDate %>"  >
                                    <div class="input-group-append">
                                      	<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="row">
                            <div class="col-6">
                            </div>
                            <div class="col-6 text-right">
                                <button type="button" class="btn btn-primary" onclick="fnSearch()">검색</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <div class="row">
                            <div class="col">
                            </div>
                            <div class="col-auto text-right">
                                <button type="button" class="btn btn-sm btn-info" onclick="fnExcel()">엑셀 다운로드</button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-bordered table-hover" summary="<%:ConfigurationManager.AppSettings["EmpIDText"].ToString() %> 리스트">
                            <thead>
                                <tr>
                                    <th scope="col">구분</th>
                                    <th scope="col">연동일</th>
                                    <th scope="col">항목</th>
                                    <th scope="col">신규</th>
                                    <th scope="col">수정</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    foreach (var item in Model.LogList)
                                    {
                                %>
                                    <tr>
                                        <td class="text-center"><%:item.IsAuto %></td>
                                        <td class="text-center"><%:item.LinkageDate%></td>
                                        <td class="text-center"><%:item.CodeName %></td>
                                        <td class="text-right"><%:item.InsertCount.ToString("#,##0")%></td>
                                        <td class="text-right"><%:item.UpdateCount.ToString("#,##0")%></td>
                                    </tr>
                                <%
                                }
                                %>
                                <% 
                                  if(Model.LogList.Count.Equals(0))
                                  {
                                %>
                                   <tr><td colspan="5" style="text-align:center;">검색결과가 없습니다.</td></tr>
                                <%
                                  }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- paginate-->
        <%= Html.Pager((int)Model.PageNum, 10, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
        <!--//paginate-->
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
        fnFromToCalendar("txtStartDate", "txtEndDate", "<%:Model.StartDate ==  null ? null :  Model.StartDate  %>");

       $(document).ready(function () {
            $("#txtStartDate").val("<%:Model.StartDate %>");
            $("#txtEndDate").val("<%:Model.EndDate %>");
        });

        function fnSearch() {
            if ($("#txtStartDate").val() != "" && $("#txtEndDate").val() == "") {
                alert("종료일을 선택해주세요.");
                return;
            }
            $("#mainForm").submit();
        }

        function fnExcel() {
            window.location = "/Import/ImportLogListExcel?StartDate=" + "<%:Model.StartDate%>" + "&EndDate=" + "<%:Model.EndDate%>";
        }

    </script>
</asp:Content>
