<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/Account/DetailStaff" method="post" id="mainForm">

        <div class="row">
            <div class="col-12 mt-2">
                <h3 class="title04">상세정보</h3>
            </div>
        </div>
        <div class="card d-md-block">
            <div class="card-body">
                 <%--폼로우1 시작--%>
                <div class="form-row">

                    <input type="hidden" id="hdnUserNo" Name="User.UserNo" value='<%:Model.User.UserNo %>' />

                    <div class="form-group col-12 col-md-4">
                        <label for="" class="form-label">구분</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value="<%:Model.User.UserTypeName %>">
                        </div>
                    </div>

                    <div class="form-group col-12 col-md-4">
                        <label for="" class="form-label">이름</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value="<%:Model.User.HangulName %>">
                        </div>
                    </div>

                    <div class="form-group col-12 col-md-4">
                        <label for="" class="form-label"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></label>
                        <div class="input-group">
                            <input type="text" id="" name="User.UserID" class="form-control" readonly="readonly" value="<%:Model.User.UserID %>">
                        </div>
                    </div>
                </div>

                <%--폼로우1 종료--%>

                <%--폼로우2 시작--%>
                <div class="form-row">
                    <div class="form-group col-12 col-md-4">
                        <label for="" class="form-label">계열</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value="<%:Model.Campus %>">
                        </div>
                    </div>

                    <div class="form-group col-12 col-md-4">
                        <label for="" class="form-label">소속</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value="<%:Model.Organization %>">
                        </div>
                    </div>

                    <div class="form-group col-12 col-md-4">
                        <label for="" class="form-label">외국인(교환)</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value='<%:Model.User.ForeignYesNo == "Y" ? "예" : "아니오" %>'>
                        </div>
                    </div>
                </div>

                <%--폼로우2 종료--%>

                <%--폼로우3 시작--%>
                <div class="form-row">
                    <div class="form-group col-12 col-md-4">
                        <label for="" class="form-label">성별</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value='<%:Model.User.SexGubun == "M" ? "남" : "여" %>'>
                        </div>
                    </div>
                </div>
                <%--폼로우3 종료--%>

            </div>
        </div>

        <div class="row">
            <div class="col-12 mt-2">
                <h3 class="title04">연락처정보</h3>
            </div>
        </div>

        <div class="card d-md-block">
            <div class="card-body">
                <%--연락처정보 줄1 시작--%>
                <div class="form-row">
                    <div class="form-group col-12 col-md-6">
                        <label for="" class="form-label">휴대폰</label>
                        <div class="input-group">
                            <input type="text" id="" name="User.Mobile" class="form-control" value='<%:Model.User.Mobile %>'>
                        </div>
                    </div>

                    <div class="form-group col-12 col-md-6">
                        <label for="" class="form-label">이메일</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value='<%:Model.User.Email %>'>
                        </div>
                    </div>
                </div>
                <%--연락처정보 줄1 종료--%>
                <%--연락처정보 줄2 시작--%>
                <div class="form-row">
                    <div class="form-group col-12">
                        <label for="" class="form-label">자택주소</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value='<%:Model.User.HouseAddressOpenYesNo == "Y"? Model.User.HouseAddress1+" "+Model.User.HouseAddress2:"비공개"%>'>
                        </div>
                    </div>
                </div>
                <%--연락처정보 줄2 종료--%>
                 <%--연락처정보 줄3 시작--%>
                <div class="form-row">
                    <div class="form-group col-12">
                        <label for="" class="form-label">자택전화</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value='<%:Model.User.HousePhoneOpenYesNo == "Y"? Model.User.HousePhone:"비공개" %>'>
                        </div>
                    </div>
                </div>
                <%--연락처정보 줄3 종료--%>
                 <%--연락처정보 줄4 시작--%>
                <div class="form-row">
                    <div class="form-group col-12">
                        <label for="" class="form-label">직장주소</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value='<%:Model.User.OfficeAddressOpenYesNo == "Y"?Model.User.OfficeAddress1 + " " +Model.User.OfficeAddress2: "비공개" %>'>
                        </div>
                    </div>
                </div>
                <%--연락처정보 줄4 종료--%>
                 <%--연락처정보 줄5 시작--%>
                <div class="form-row">
                    <div class="form-group col-12">
                        <label for="" class="form-label">직장전화</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value='<%:Model.User.OfficePhoneOpenYesNo == "Y" ? Model.User.OfficePhone: "비공개" %>'>
                        </div>
                    </div>
                </div>
                <%--연락처정보 줄5 종료--%>

                <%--연락처정보 줄1 시작--%>
                <div class="form-row">
                    <div class="form-group col-12 col-md-6">
                        <label for="" class="form-label">페이스북 ID</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value="<%:Model.User.FacebookID %>">
                        </div>
                    </div>

                    <div class="form-group col-12 col-md-6">
                        <label for="" class="form-label">트위터 ID</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly" value="<%: Model.User.TwitterID %>">
                        </div>
                    </div>
                </div>
                <%--연락처정보 줄1 종료--%>

                <%--연락처정보 줄1 시작--%>
                <div class="form-row">
                    <div class="form-group col-12 col-md-6">
                        <label for="" class="form-label">학력사항</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly">
                        </div>
                    </div>

                    <div class="form-group col-12 col-md-6">
                        <label for="" class="form-label">특기사항</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly">
                        </div>
                    </div>
                </div>
                <%--연락처정보 줄1 종료--%>

                <%--연락처정보 줄1 시작--%>
                <div class="form-row">
                    <div class="form-group col-12">
                        <label for="" class="form-label">인사말</label>
                        <div class="input-group">
                            <input type="text" id="" name="" class="form-control" readonly="readonly">
                        </div>
                    </div>
                </div>
                <%--연락처정보 줄1 종료--%>
            </div>
            <div class="card-footer">
                <div class="text-right">
                    <button class="btn btn-danger" type="button" onclick="fnResetPasswordCheck()">비밀번호 초기화</button>
                    <button type="button" class="btn btn-secondary" onclick="fnGo()">목록</button>                    
                </div>
            </div>
        </div>
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">

<script>
    var ajaxHelper = new AjaxHelper();

    function fnResetPasswordCheck() {
        bootConfirm("비밀번호가 사용자의 핸드폰번호 뒤 네자리로 변경됩니다. 초기화하시겠습니까?", fnResetPassword)
    }

    function fnResetPassword() {
        console.trace();

        var form = $("#mainForm").serialize();
        //ajaxHelper.CallAjaxPost("/Common/UserList", form, "fnSetUserList");
        ajaxHelper.CallAjaxPost("/Account/ResetPassword", form, "fnCallBack");
    }

    function fnCallBack() {
        var result = ajaxHelper.CallAjaxResult();
        if (result == 1) {
            bootAlert("비밀번호가 초기화되었습니다.")
        } else {
            bootAlert("오류가 발생하였습니다.")
        }
    }

    function fnGo() {

		window.location = "/Account/ListStaff?AssignNo=" + '<%:Model.AssignNo %>' + "&UserType=" + '<%:Model.UserType%>' + "&SearchOption=" + '<%:Model.SearchOption%>' + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
	}
</script>
</asp:Content>
