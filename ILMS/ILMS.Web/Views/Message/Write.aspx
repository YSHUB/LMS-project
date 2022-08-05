<%@ Page Language="C#" MasterPageFile="~/Message/master/Message.Master" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.MessageViewModel>" %>

<%--헤더--%>
<asp:Content ID="header" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="modalContainer" ContentPlaceHolderID="modalPlaceHolder" runat="server">
    <%-- 모달창 - 조직 시작 --%>
    <div id="modalEmployee" class="modal fade" role="dialog" tabindex="-1" aria-labelledby="modalEmployeeLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">사용자검색</h5>
                </div>
                <div class="modal-body">
                    <div class="table-filter">
                        <div class="form-inline">
                            <div class="form-group mb-1">
                                <label class="control-label" for="ddlUserGbn">사용자구분 :</label>
                                <div class="ml-2">
                                    <select name="EmployeeJikJong" id="ddlUserGbn" class="form-control form-control-sm" style="width: 100px">
                                        <option selected="selected" value="1"><%:ConfigurationManager.AppSettings["EmpIDText"].ToString() %></option>
                                        <option value="2"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %></option>
                                    </select>
                                </div>
                            </div>
							<div class="form-group ml-2 mb-1">
                                <label class="">성명(ID) :</label>
                                <div class="ml-2">
                                    <input type="text" id="txtSearchText" class="form-control form-control-sm" style="width: 150px" />
                                </div>
                            </div>
                            <div class="form-group ml-2 mb-1">
                                <label class="sr-only">소속선택 :</label>
                                <div class="ml-2">
                                    <label for="AssignSel" class="sr-only">소속전체</label>
                                    <select id="AssignSel" name="AssignSel" class="form-control form-control-sm" style="width: 100px">
                                        <option value="%">소속전체</option>
                                        <%
                                            foreach (var assign in Model.AssignList.Where(w => w.HierarchyLevel >= 2))
                                            {
                                        %>
                                            <option value ="<%: assign.AssignNo %>"> <%:assign.AssignName%> </option>
                                        <%
                                            }
                                        %>

                                    </select>
                                </div>
                            </div>
                            <div class="form-group ml-2">
                                <button id="btnEmployeeSearch" type="button" class="btn btn-primary btn-sm">
                                    <span id="btnEmployeeSearchLoading" class="spinner-border spinner-border-sm sr-only"></span>
                                    조회
                                </button>
                            </div>
                        </div>
                    </div>
                    <div>
                        <div class="search-form card">
                            <div class="card-body pt-0">
                                <div class="row">
                                    <div class="col-12 col-lg">
                                        <div class="row">
                                            <div class="col-md-12 p-0" style="overflow-y: scroll; height: 400px;">
                                                <div>
                                                    <table id="modalTblSenderListEmployee" class="tblSenderList table table-bordered table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 40px;">
                                                                    <input name="chkAll" type="checkbox" class="form-check-input" onclick="onCheckAll(event)">
                                                                </th>
                                                                <th style="width: 100px;">ID</th>
                                                                <th style="width: 100px;">성명</th>
                                                                <th style="width: 120px;">연락처</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody class="tbodyheight45" style="font-size: 13px;">
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-sm" onclick="onSelectDeptUser(this)"><i class="material-icons">check_circle</i> 선택</button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="hideModal('#modalEmployee')"><i class="material-icons">close</i>닫기</button>
                </div>
            </div>
        </div>
    </div>
    <%-- 모달창 - 조직 종료 --%>
</asp:Content>

<asp:Content ID="script1" ContentPlaceHolderID="scripts" runat="server">
    <script>

		$(document).ready(function () {
            initializeMessageContainer();
            setStateRender('SysGb', 'employee');
            setStateRender('modalReciverEl', '#modalEmployee');
            setStateRender('modalReviverTableEl', '#modalTblSenderListEmployee');

            $('#modalEmployee').on('shown.bs.modal', function () {

                $("#modalTblSenderListEmployee > tbody").empty();
            });

            $('#btnEmployeeSearch').on('click', function (e) {
                e.preventDefault();
                searchEmployee();
            });

			$('#txtSearchText').on('keydown', function (e) {
                if (e.keyCode == 13) {
                    searchEmployee();
                }
			});
          
			$('.table-filter').find('.ui-datepicker-trigger').css('width', '33px').css('height', '24px');

			var senderNo = "<%=Request.Form["stno"]%>";
			if (senderNo != "") {

				var serviceParams = {};
				serviceParams['StaffNo'] = senderNo;

				var stateContainer = currentStateContainer();

				var variables = "#{-},-";

                getReceiverInfo(serviceParams, function (data) {
                   
					var checkedSender = [];

					$(data).each(function (i, item) {
						let stud = {};

						stud['userID'] = item.UserID;
						stud['userName'] = item.HangulName;
						stud['phone'] = item.Mobile.replace(/-/g, '');
						checkedSender.push(stud['userID'] + '|' + stud['userName'] + '|' + stud['phone']+ '|' + variables);

					});

					var addedCount = stateContainer.addCnt;
					var selUser = stateContainer.selectedReceivers;
					var selected = stateContainer.selected;
					var selectedUsers = [];

					for (var i = 0; i < checkedSender.length; i++) {
						if (!selUser[checkedSender[i]]) {

							selUser.push(checkedSender[i]);
						}
					}

					for (var i = 0; i < selUser.length; i++) {

						selectedUsers.push({
							userID: selUser[i].split('|')[0],
							userName: selUser[i].split('|')[1],
							phone: selUser[i].split('|')[2],
							ismobile: fnIsMobile(selUser[i].split('|')[2]),
							orgName: '',
							lectureName: '',
							variables: selUser[i].split('|')[3]
						});
						selected[selUser[i].split('|')[0]] = true;
						addedCount++;
					}

					setStateRender('selected', selected);
					setStateRender('selectedUsers', selectedUsers);
					setStateRender('pageOfItemsReceiver', selectedUsers);

					setStateRender('addCnt', addedCount);
					setStateRender('selectedReceivers', selUser);
				});
			}

		});

        function searchEmployee() {

            if (parent.startSpin) {
                parent.startSpin();
            }

            $('#btnEmployeeSearchLoading').removeClass('sr-only');
			$('#btnEmployeeSearch').text('Loading..');
            let userGbn = $('#ddlUserGbn').val();
			let assignInfo = $('#AssignSel').val();
			let staffNo = $('#txtSearchText').val();

            getEmployeeService(userGbn, assignInfo, staffNo, function (data) {
                
                let stateContainer = currentStateContainer();
                let tmpUser = [];
                let receivers = Array.from(stateContainer.selectedReceivers);
                $(data).each(function (i, item) {
                    //let exists = receivers.find(f => f.split('|')[0] == item.UserID) ? true : false;
                    var exists = receivers.find(function (f) {
						return f.split('|')[0] == item.UserID;
                    }) ? true : false;
					let validMobile = fnIsMobile(item.Mobile.replace(/-/g, ''));
                    let stud = {};
                    let user = {};

					stud['userID'] = item.UserID;
                    stud['userName'] = item.HangulName;
					stud['phone'] = item.Mobile.replace(/-/g, '');
                    stud['deptNM'] = '';
                    user['user'] = stud;
                    user['isDisabled'] = (exists == true || validMobile == false);
                    tmpUser.push(user);
                });

                setStateRender('deptUsers', tmpUser);
                setStateRender('pageOfItemsDept', tmpUser);

                if (parent.stopSpin) {
                    parent.stopSpin();
                }
                $('#btnEmployeeSearchLoading').addClass('sr-only');
                $('#btnEmployeeSearch').text('조회');
            });
		}

		function getReceiverInfo(serviceOption, callBack) {

			$.ajax({
				type: "GET",
				data: { users: serviceOption.StaffNo },
				url: '/Message/GetReceiverList',
				dataType: "json",
				async: false,
				success: function success(data) {
					if (callBack) {
						callBack(data);
					}
				},
				error: function error(xhr, status, _error16) {
					console.log(xhr);
				},
				always: function always() {
					console.log("always");
				}
			});
		}

	</script>
</asp:Content>
