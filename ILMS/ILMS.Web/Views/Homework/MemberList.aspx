<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="ContentTitle" ContentPlaceHolderID="Title" runat="server">시험 대상인원 조회</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Homework/MemberList" name="mainForm" id="mainForm" method="post">
        <div class="card card-style01">
            <div class="card-body py-0">
                <div class="table-responsive overflow-auto " style="height: 400px;">
                    <table class="table table-sm table-hover" summary="">
                        <thead>
                            <tr>
                                <th scope="col">
                                    <input  id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');" name="allCheck" class="checkbox" value="" type="checkbox"></th>
                                <th scope="col">소속</th>
                                <th scope="col"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
                                <th scope="col">이름</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
								foreach (var item in Model.HomeworkSubmitList)
								{ 
							%>
                            <tr>
                                <th scope="row">
                                    <input id="chkSel" name="Homework.UserNo" class="checkbox" value="<%= item.UserNo %>" <%= item.TargetYesNo != null && item.TargetYesNo.Equals("Y") ?  "checked='checked'" : ""%> type="checkbox"></th>
                                <th scope="row"><%= item.AssignName%></th>
                                <td class="text-center"><%= item.UserID%></td>
                                <td><%= item.HangulName%></td>
                            </tr>
                            <%
								}
							%>
                        </tbody>
                    </table>
                </div>
            </div>

			<div class="card-footer">
				<div class="text-right">
					<button type="button" class="btn btn-sm btn-primary" id="btn_confirm">등록</button>
					<button type="button" class="btn btn-sm btn-secondary" id="btnCancel" onclick="window.close()">닫기</button>
				</div>
			</div>
        </div>
    </form>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {

            $("#btn_confirm").click(function (e) {
                e.preventDefault();
                if (window.opener != null && !window.opener.closed) {
                    var txtMember = window.opener.document.getElementById("txtGroupCnt");
                    var hdnYesMember = window.opener.document.getElementById("hdnMemberYesList");
                    var hdnNoMember = window.opener.document.getElementById("hdnMemberNoList");
                    txtMember.value = $("input[name='Homework.UserNo']:checked").length;

                    var totalMember = $("input[name='Homework.UserNo']").length;
                    var memberYesList = "";
                    var memberNoList = "";

                    for (var i = 0; i < totalMember; i++) {
                        if ($("input[name='Homework.UserNo']")[i].checked) {
                            if (memberYesList == "") {
                                memberYesList += $("input[name='Homework.UserNo']")[i].value;
                            }
                            else {
                                memberYesList += ("|" + $("input[name='Homework.UserNo']")[i].value);
                            }
                        }
                        else {
                            if (memberNoList == "") {
                                memberNoList += $("input[name='Homework.UserNo']")[i].value;
                            }
                            else {
                                memberNoList += ("|" + $("input[name='Homework.UserNo']")[i].value);
                            }
                        }
                    }
                    hdnYesMember.value = memberYesList;
                    hdnNoMember.value = memberNoList;
                }
                window.close();
            });

        });
    </script>
</asp:Content>