<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/Account/ListStaff" method="post" id="mainForm">

        <ul class="nav nav-tabs">
            <li class="nav-item"><a class="nav-link" href="ListStudent"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %></a> </li>
            <li class="nav-item"><a class="nav-link active show" href="ListStaff"><%:ConfigurationManager.AppSettings["EmpIDText"].ToString() %></a> </li>
            <li class="nav-item"><a class="nav-link" href="ListManager">관리자</a> </li>
        </ul>
        <div class="card mt-4">
            <div class="card-body pb-1">

                <div class="form-row align-items-end">
                    <div class="form-group col-6 col-md-3 col-lg-2">
                        <label for="ddl소속" class="sr-only">소속</label>
                        <select id="ddl소속" name="AssignNo" class="form-control">
                            <option value="">전체</option>
                            <%
                                if (Model.AssignList == null)
                                {
                            %>
                            <option value="">등록된 소속이 없습니다.</option>
                            <%
                                }
                                else
                                {
                                    foreach (var item in Model.AssignList)
                                    {
                            %>
                            <option value="<%:item.AssignNo %>" <%:item.AssignNo == Model.AssignNo? "selected":"" %> ><%:item.AssignName %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group col-6 col-md-3 col-lg-2">
                        <label for="ddlUserType" class="sr-only">직원구분</label>
                        <select id="ddlUserType" name="UserType" class="form-control">
                            <option value="">전체</option>
                            <% 
                                foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("USRT") &&
                                (c.CodeValue.Equals("USRT007") || c.CodeValue.Equals("USRT009"))
                                ).ToList())
                                {
                            %>
                            <option value="<%:item.CodeValue%>"><%:item.CodeName%></option>

                            <%
                                }
                            %>

                        </select>


                    </div>

                    <div class="form-group col-6 col-md-3 col-lg-2">
                        <label for="ddlSearchGubun" class="sr-only">검색구분</label>
                        <select id="ddlSearchGubun" name="SearchOption" class="form-control">
                            <option value="I" <%: (Model.SearchOption == "I") ? "selected" : "" %>><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></option>
                            <option value="N" <%: (Model.SearchOption == "N") ? "selected" : "" %>>이름</option>
                        </select>
                    </div>

                    <div class="form-group col-6 col-md-3 col-lg-2">
                        <label for="txtSearchText" class="sr-only">검색어</label>
                        <input type="text" class="form-control" name="SearchText" id="txtSearchText" value="<%:Model.SearchText%>" placeholder="검색어 입력" />
                    </div>

                    <div class="form-group col-sm-auto text-right">
                        <button type="submit" id="btnSearch" class="btn btn-secondary">
                            <span class="icon search">검색
                            </span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-body py-0">
                <table class="table" summary="<%:ConfigurationManager.AppSettings["EmpIDText"].ToString() %> 리스트">
                    <caption>Category 분류설정</caption>
                    <thead>
                        <tr>
                            <th scope="col">구분</th>
                            <th scope="col">소속</th>
                            <th scope="col">이름(<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>)</th>
                            <th scope="col" class="d-none d-md-table-cell">연락처</th>
                            <th scope="col" class="d-none d-md-table-cell">이메일</th>

                            <th scope="col">개별회원연동</th>
                        </tr>

                    </thead>
                    <tbody>
                        <% 
                            foreach (var item in Model.UserList)
                            {
                        %>
                        <tr>
                            <td><%:item.UserTypeName %></td>
                            <td><%:item.AssignName%></td>
                            <td><%:item.HangulName %> (<%:item.UserID %>)</td>
                            <td><%:item.Mobile %></td>
                            <td><%:item.Email%></td>

                            <td>
                                <%--<a class="text-primary" href="#" onclick="fnModal('U','<%:item.UserType %>','<%:item.ApprovalGubun %>','<%:item.HangulName %>','<%:item.UserID %>','<%:item.Mobile %>','<%:item.Email %>','<%:item.UserNo %>', this)" data-toggle="modal" data-target="#divModal" title="수정"><i class="bi bi-pencil-square"></i></a>--%>
                                <button type="button" onclick="fnGo('<%:item.UserNo%>')"><i class="bi bi-pencil-square" title="상세보기"></i></button>
                                <button type="button" class="btn btn-sm btn-info" onclick="fnUserInfoUpdate('<%:item.UserID%>','<%:item.UserType%>');">연동하기</button>
                            </td>
                        </tr>
                        <%
                            }
                        %>

                        <% if (Model.UserList.Count.Equals(0))
                            {
                        %>
                        <tr>
                            <td colspan="6" class="text-center">검색결과가 없습니다.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <div class="card-footer">
                <div class="row">
                    
                </div>
            </div>
        </div>
        <%= Html.Pager((int)Model.PageNum, 10, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
        <%--분류수정 / 등록 modal--%>

       
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script>
        var ajaxHelper = new AjaxHelper();

        function fnUserInfoUpdate(userID, UserType) {
            console.trace();

            //ajaxHelper.CallAjaxPost("/Common/UserList", form, "fnSetUserList");
            ajaxHelper.CallAjaxPost("/Account/UserInfoUpdate", { "userID": userID, "userType": UserType }, "fnCallBack");
        }

        function fnCallBack() {
            var result = ajaxHelper.CallAjaxResult();
            if (result == 1) {
                bootAlert("연동이 완료되었습니다.")
            } else {
                bootAlert("오류가 발생하였습니다.")
            }
        }

        function fnGo(userNo) {

			window.location = "/Account/DetailStaff/" + userNo + "?AssignNo=" + '<%:Model.AssignNo %>' + "&UserType=" + '<%:Model.UserType%>' + "&SearchOption=" + '<%:Model.SearchOption%>' + "&SearchText=" + encodeURI(encodeURIComponent('<%:Model.SearchText%>')) + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>
