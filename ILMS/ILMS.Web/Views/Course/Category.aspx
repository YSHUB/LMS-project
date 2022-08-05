<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Course/Category" id="mainForm" method="post">
        <h3 class="title04">분류리스트(<strong class="text-primary"><%=Model.CategoryList.Count.ToString("#,##0") %></strong>건)</h3>
        <div class="card">
            <div class="card-body py-0">
                <table class="table table table-hover" summary="분류설정 리스트">
                    <caption>Category 분류설정</caption>
                    <thead>
						<tr>
							<th scope="col">순서</th>
							<th>분류코드</th>
							<th>분류명</th>
							<th>등록일</th>
							<th>공개여부</th>
							<th scope="col">관리</th>
						</tr>
					</thead>
                    <tbody>
                    <% 
                        foreach (var item in Model.CategoryList)
                        { 
                    %>
                        <tr data-info="<%: item.SortNo %>:<%:item.MName %>:<%:item.IsOpen %>">
                            <td><%:item.SortNo %></td>
                            <td><%:item.MNo %></td>
                            <td><%:item.MName %></td>
                            <td><%:item.CDT%></td>
                            <td><%:item.IsOpen == 1 ? "공개" : "비공개"%></td>
                            <td>
                                <a class="text-primary" href="#" onclick="fnModal(<%:item.MNo %>, this)" data-toggle="modal" data-target="#divModal" title="수정"><i class="bi bi-pencil-square"></i></a>
                            </td>
                        </tr>
                    <%
                        }
                    %>

                    <% if (Model.CategoryList.Count.Equals(0))
                        {
                    %>
                          <tr><td colspan="6" class="text-center">검색결과가 없습니다.</td></tr>
                    <%
                        }                  
                    %>
                    </tbody>
                </table>
            </div>
            <div class="card-footer">
                <div class="row">
                    <div class="col-12 text-right">
                        <button type="button" id="btnNew" class="btn btn-primary" onclick="fnModal(0, this)" data-toggle="modal" data-target="#divModal">등록</button>
                    </div>
                </div>
                </div>
            </div>
        
            <%--분류수정 / 등록 modal--%>
            <div class="modal fade show" id="divModal" tabindex="-1" aria-labelledby="newMname" role="dialog" aria-modal="true">
            	<div class="modal-dialog modal-md">
            	    <div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="ModalTitle">신규분류 추가 / 분류설정</h5>
                            <input type="hidden" id="hdnMNo" value="0" />
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
                        <div class="modal-body">
                        	<div class="card">
								<div class="card-body">
									<div class="form-row">
										<div class="form-group col-md-12">
											<label for="txtMName" class="form-label">분류명 <strong class="text-danger">*</strong></label>
											<input type="text" id="txtMName" name="categroy.MName" class="form-control" value="">
										</div>
										<div class="form-group col-md-12">
											<label for="txtSortNo" class="form-label">정렬순서 <strong class="text-danger">*</strong></label>
											<input type="text" id="txtSortNo" name="categroy.SortNo" class="form-control" value="">
										</div>
                                        <div class="form-group col-md-12">
                                            <label class="form-label" for="chkIsOpen">공개여부<span class="text-danger">*</span></label>
                                            <label class="switch">
                                                <input type="checkbox" id="chkIsOpen" name="category.IsOpen" <%if ( Model.CategoryList == null) { %> checked="checked" <%} %> >
                                                <span class="slider round"></span>
                                            </label>
                                        </div>
									</div>
								</div>
								<div class="card-footer">
									<div class="row align-items-center">
										<div class="col-md">
											<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
										</div>
										<div class="col-md-auto text-right">
											<button type="button" class="btn btn-primary"   id="btnSave"    data-dismiss="modal" title="저장">저장</button>
                                            <button type="button" class="btn btn-danger"    id="btnDel"     title="삭제" onclick="fnDelete();">삭제</button>
                                            <button type="button" class="btn btn-secondary" id="btnCancel"  data-dismiss="modal" title="닫기">닫기</button>
										</div>
									</div>
								</div>
							</div>
                        </div>
                    </div>
                </div>
            </div>
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
    <script type="text/javascript">
        // ajax 객체 생성
        var ajaxHelper = new AjaxHelper();

        function fnModal(mno, r) {

            $("#ModalTitle").text(mno < 1 ? "신규분류 추가" : "분류수정");
            $("#btnDel").hide();
            $("#txtMName").val("");
            $("#chkIsOpen").prop("checked", true);
            $("#txtSortNo").val(<%: Model.CategoryList.Count() < 1 ? 1 : (Model.CategoryList.Max(m=>m.SortNo) + 1) %>);
            $("#hdnMNo").val(mno);
            if (mno > 0) {
                var item = $(r).closest("tr").attr("data-info").split(':');
                $("#txtMName").val(item[1]);
                $("#txtSortNo").val(item[0]);
                if (item[2] == "1") {
                    $("#chkIsOpen").prop("checked", true);
                }
                else {
                    $("#chkIsOpen").prop("checked", false);
                }
                $("#btnDel").show();
            }
            $("#txtMName").focus();

        }

        $("#btnSave").click(function () {
            if ($("#txtMName").val() == "") {
                alert("분류키워드명을 입력해주세요.");
                $("#txtMName").focus();
                return false;
            }

            if ($("#txtSortNo").val() == "") {
                alert("정렬순서를 입력해주세요.");
                $("#txtSortNo").focus();
                return false;
            }
            if ($("#chkIsOpen").prop("checked")) {
                var IsOpen = "Y";
            } else {
                IsOpen = "N";
            }

            var objParam = {
                MNo    : $("#hdnMNo").val(),
                SortNo : $("#txtSortNo").val(),
                MName  : $("#txtMName").val(),
                IsOpen : IsOpen
            };
            ajaxHelper.CallAjaxPost("/Course/CategoryAjax", objParam, "fnCbSave");
        });


        function fnCbSave() {
            var ajaxResult = ajaxHelper.CallAjaxResult();
            if (ajaxResult > 0) {
                bootAlert('저장되었습니다', function () {
                    location.reload(true);

                });
            } else {
				bootAlert('저장에 실패하였습니다.');
                return false;
            }
        }

        function fnDelete() {
			bootConfirm("해당 분류키워드명을 삭제하시겠습니까?", function () {
				ajaxHelper.CallAjaxPost("/Course/CategoryDelete", { MNo: $("#hdnMNo").val() }, "fnCbDel");
			});
		}

        function fnCbDel() {
            var ajaxResult = ajaxHelper.CallAjaxResult();
            if (ajaxResult > 0) {
                bootAlert('삭제되었습니다', function () {
                    location.reload(true);

                });
			} else {
				bootAlert("이미 사용하고 있는 분류키워드는 삭제할 수 없습니다.");

				fnPrevent();
			}
        }

	</script>
</asp:Content>