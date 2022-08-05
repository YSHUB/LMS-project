<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.BoardViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" action="/System/BoardMasterWrite" method="post">
		<div class="form-row">
			<div class="col-12 col-md-8">
				<div class="card">
					<div class="card-body py-0">
						<div class="table-responsive">
							<table class="table" summary="게시판 마스터 목록">
								<caption>게시판 마스터 목록</caption>
								<thead>
									<tr>
										<th scope="col">마스터번호</th>
										<th scope="col">게시판ID</th>
										<th scope="col">게시판명</th>
										<th scope="col">사용여부</th>
										<th scope="col">관리</th>
									</tr>
								</thead>
								<tbody id="tbody">
									<%
										if (Model.BoardMasterList != null)
										{
											foreach (var item in Model.BoardMasterList)
											{
									%>
												<tr>
													<td class="text-center"><%:item.MasterNo%></td>
													<td class="text-center"><%:item.BoardID%></td>
													<td class="text-center"><%:item.BoardTitle%></td>
													<td class="text-center"><%:item.UseYesNo%></td>
													<td class="text-center"><button type="button" class="text-primary"  title="수정" onclick="fnGetBoardMasterInfo('<%:item.MasterNo%>');"><i class="bi bi-pencil-square"></i></button></td>
												</tr>
									<%
											}
										}
									%>

									<%
										if (Model.BoardMasterList.Count() < 1)
										{ 
									%>
											<tr>
												<td colspan="6" class="text-center">등록된 정보가 없습니다.</td>
											</tr>
									<%	
										} 
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="col-12 col-md-4">
				<div class="card">
					<div class="card-body">
						<div class="form-row">
							<div class="form-group col-6">
								<label for="txtMasterNo" class="form-label">마스터 번호</label>
								<input type="text" id="txtMasterNo" name="BoardMaster.MasterNo" class="form-control text-center" readonly="readonly">
							</div>
							<div class="form-group col-6">
								<label for="txtBoardID" class="form-label">게시판 ID <strong class="text-danger">*</strong></label>
								<input type="text" id="txtBoardID" name="BoardMaster.BoardID" class="form-control">
							</div>
							<div class="form-group col-12">
								<label for="txtBoardTitle" class="form-label">게시판명 <strong class="text-danger">*</strong></label>
								<input type="text" id="txtBoardTitle" name="BoardMaster.BoardTitle" class="form-control">
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkAcceptYesNo" class="form-label">참여도인정</label>
								<label class="switch">
									<input type="checkbox" id="chkAcceptYesNo" name="MeBoardMasternu.BoardIsUseAcceptYesNo" checked="checked">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkFileYesNo" class="form-label">첨부파일</label>
								<label class="switch">
									<input type="checkbox" id="chkFileYesNo" name="BoardMaster.BoardIsUseFileYesNo" checked="checked">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkReplyYesNo" class="form-label">답글여부</label>
								<label class="switch">
									<input type="checkbox" id="chkReplyYesNo" name="BoardMaster.BoardIsUseReplyYesNo">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkSecretYesNo" class="form-label">비밀글</label>
								<label class="switch">
									<input type="checkbox" id="chkSecretYesNo" name="BoardMaster.BoardIsSecretYesNo">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkIsRead" class="form-label">읽음확인</label>
								<label class="switch">
									<input type="checkbox" id="chkIsRead" name="BoardMaster.IsRead">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkIsAnonymous" class="form-label">익명사용</label>
								<label class="switch">
									<input type="checkbox" id="chkIsAnonymous" name="BoardMaster.IsAnonymous">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkIsEvent" class="form-label">이벤트사용</label>
								<label class="switch">
									<input type="checkbox" id="chkIsEvent" name="BoardMaster.IsEvent">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkIsNotice" class="form-label">공지사용</label>
								<label class="switch">
									<input type="checkbox" id="chkIsNotice" name="BoardMaster.IsNotice">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkUseYesNo" class="form-label">사용여부</label>
								<label class="switch">
									<input type="checkbox" id="chkUseYesNo" name="BoardMaster.UseYesNo" checked="checked">
									<span class="slider round"></span>
								</label>
							</div>
						</div>
					</div>
					<div class="card-footer">
						<div class="row align-items-center">
							<div class="col">
								<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
							</div>
							<div class="col-auto text-right">
								<input type="hidden" id="hdnRowState" name="BoardMaster.RowState" />
								<button type="button" id="btnAuth" onclick="fnOpenAuth();" class="btn btn-info">권한관리</button>
								<button type="button" id="btnNew" onclick="fnInit();" class="btn btn-info">신규</button>
								<button type="button" id="btnSave" class="btn btn-primary">저장</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script>

		$(document).ready(function () {
			//초기화
			fnInit();

			$("#btnSave").click(function () {
				if ($("#txtBoardID").val() == "") {
					bootAlert("게시판 ID를 입력하세요.");
					$("#txtBoardID").focus();
					return false;
				}
				else if ($("#txtBoardTitle").val() == "") {
					bootAlert("게시판명을 입력하세요.");
					$("#txtBoardTitle").focus();
					return false;
				}
				else {
					document.forms["mainForm"].submit();
				}
				fnPrevent();
			});
		});

		function fnGetBoardMasterInfo(masterNo) {
			ajaxHelper = new AjaxHelper();
			ajaxHelper.CallAjaxPost("/System/GetBoardMasterList", { masterNo: masterNo }, "fnSetBoardMasterDetail", null);
		}

		function fnSetBoardMasterDetail() {
			var data = ajaxHelper.CallAjaxResult();

			$("#txtMasterNo").val(data.MasterNo);
			$("#txtBoardID").val(data.BoardID);
			$("#txtBoardTitle").val(data.BoardTitle);
			$("#chkAcceptYesNo").prop("checked", data.BoardIsUseAcceptYesNo == "Y");
			$("#chkFileYesNo").prop("checked", data.BoardIsUseFileYesNo == "Y");
			$("#chkReplyYesNo").prop("checked", data.BoardIsUseReplyYesNo == "Y");
			$("#chkSecretYesNo").prop("checked", data.BoardIsSecretYesNo == "Y");
			$("#chkIsRead").prop("checked", data.IsRead == "Y");
			$("#chkIsAnonymous").prop("checked", data.IsAnonymous == "Y");
			$("#chkIsEvent").prop("checked", data.IsEvent == "Y");
			$("#chkIsNotice").prop("checked", data.IsNotice == "Y");
			$("#chkUseYesNo").prop("checked", data.UseYesNo == "Y");
			$("#hdnRowState").val("U");

			$("#btnAuth").show();
		}

		function fnInit() {
			$("#txtMasterNo").val("");
			$("#txtBoardID").val("");
			$("#txtBoardTitle").val("");
			$("#chkAcceptYesNo").prop("checked", false);
			$("#chkFileYesNo").prop("checked", false);
			$("#chkReplyYesNo").prop("checked", false);
			$("#chkSecretYesNo").prop("checked", false);
			$("#chkIsRead").prop("checked", false);
			$("#chkIsAnonymous").prop("checked", false);
			$("#chkIsEvent").prop("checked", false);
			$("#chkIsNotice").prop("checked", false);
			$("#chkUseYesNo").prop("checked", true);
			$("#hdnRowState").val("C");

			$("#btnAuth").hide();
		}

		function fnOpenAuth() {
			fnOpenPopup('/System/BoardAuthority/' + $("#txtMasterNo").val(), 'BoardAuthority', 500, 600, 0, 0, 'auto');
		}
		
	</script>
</asp:Content>