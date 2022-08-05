<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.FacilityViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server"><%:Model.FacilityType == "FACILITY" ? "시설" : Model.FacilityType == "EQUIPMENT" ? "장비" : "시설"%> <%:Model.Facility != null ? "수정" : "등록"%></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" method="post" enctype="multipart/form-data">
		<input type="hidden" name="Facility.FacilityType" id="hdnFacilityType" value="<%:Model.Facility != null ? Model.Facility.FacilityType : Model.FacilityType %>" />
		<input type="hidden" name="Facility.FacilityNo" id="hdnFacilityNo" value="<%:Model.Facility != null ? Model.Facility.FacilityNo : 0 %>" />
		<input type="hidden" name="Facility.FileGroupNo" id="hdnThumFileGroupNo" value="<%:Model.Facility != null ? Model.Facility.FileGroupNo : 0 %>" />


		<!-- 기본 정보 -->
		<div class="tab-pane fade show p-4" id="contInfo" role="tabpanel" aria-labelledby="contInfo-tab">
			<h4 class="title04"><%:Model.FacilityType == "FACILITY" ? "시설" : Model.FacilityType == "EQUIPMENT" ? "장비" : "시설"%> <%:Model.Facility != null ? "수정" : "등록" %></h4>
			<div class="card">
				<div class="card-body">
					<div class="row">
						<div class="col-12">
							<div class="form-row">
								<div class="form-group col-6 col-md-3">
									<label for="ddlFacilityType" class="form-label">타입 <strong class="text-danger">*</strong></label>
									<select id="ddlFacilityType" onchange="fnTypeSelect()" class="form-control" disabled="disabled">
										<option value="FACILITY" <%:Model.FacilityType == "FACILITY" ? "selected=\"selected\"" : ""%>>시설</option>
										<option value="EQUIPMENT" <%:Model.FacilityType == "EQUIPMENT" ? "selected=\"selected\"" : "" %>>장비</option>
									</select>
								</div>
								<div class="form-group col-6 col-md-3">
									<label for="ddlFacilitySourceType" class="form-label">카테고리<strong class="text-danger">*</strong></label>
									<select id="ddlFacilityCategory" name="Facility.Category" onchange="" class="form-control">
										<option value="">선택</option>
										<%
											foreach (var codes in Model.BaseCode)
											{
										%>
										<option value="<%:codes.CodeValue %>" <%if (codes.CodeValue.Equals(Model.Facility == null ? "" : Model.Facility.Category)){ %>
											selected="selected" <%} %>><%:codes.CodeName %></option>
										<%
											}
										%>
									</select>
								</div>
								<%
									if (Model.FacilityType == "FACILITY")
									{
								%>
								<div class="form-group col-6 col-md-3">
									<label for="nmMaxUserCount" class="form-label">최대수용인원<strong class="text-danger">*</strong></label>
									<input type="number" id="nmMaxUserCount" name="Facility.MaxUserCount" class="form-control text-right" value="<%:Model.Facility != null ? Model.Facility.MaxUserCount : 0 %>"" />
								</div>
								<%
									}
								%>
								<div class="form-group col-6 col-md-3">
									<label for="ddlIsFree" class="form-label">유료/무료 <strong class="text-danger">*</strong></label>
									<select id="ddlIsFree" name="Facility.IsFree" onchange="fnIsFreeSelect()" class="form-control">
										<option value="CHARGED" <%:Model.Facility != null ? Model.Facility.IsFree == "CHARGED" ? "selected=\"selected\"" : "" : ""%>>유료</option>
										<option value="FREE" <%:Model.Facility != null ? Model.Facility.IsFree == "FREE" ? "selected=\"selected\"" : "" : ""%>>무료</option>
									</select>
								</div>

								<div class="form-group col-12" id="dvExpense">
									<label for="txtFacilityExpense" class="form-label">비용</label>
									<div class="input-group">
										<input class="form-control text-right col-4" name="Facility.FacilityExpense" id="txtFacilityExpense" type="number" autocomplete="off" value="<%:Model.Facility.FacilityExpense %>">
										<div class="input-group-append">
											<span class="input-group-text">
												원
											</span>
										</div>
									</div>
								</div>

								<div class="form-group col-12">
									<label for="txtContNm" class="form-label"><%:Model.FacilityType == "FACILITY" ? "시설" : Model.FacilityType == "EQUIPMENT" ? "장비" : "시설"%>명 <strong class="text-danger">*</strong></label>
									<input type="text" id="txtContNm" name="Facility.FacilityName" class="form-control" value="<%:Model.Facility != null ? Model.Facility.FacilityName : "" %>" />
								</div>
							</div>

							<div class="form-row">
								<div class="form-group col-12">
									<label for="txtFacilityText" class="form-label"><%:Model.FacilityType == "FACILITY" ? "시설" : Model.FacilityType == "EQUIPMENT" ? "장비" : "시설"%> 설명 </label>
									<textarea class="form-control" id="txtFacilityText" name="Facility.FacilityText" rows="5"><%: Model.Facility != null ? Model.Facility.FacilityText ?? "" : ""%></textarea>
								</div>
							</div>
							<div class="form-row">
								<div class="form-group col-12">
									<label for="btnUpload" class="form-label">사진 등록 </label>
									<div>
										<!-- image type -->
										<%
											if (Model.Facility != null && Model.FileList != null) {
										%>
										<div id="divFacilityStoredImagePlaceHolder" class="form-row">
										<%
												foreach (var images in Model.FileList){ 
										%>
										<div id="div_<%:images.OriginFileName %>" class="col-md-4 col-lg-3 mt-2 mb-2">
											<div class="thumb-wrap">
												<div class="thumb">
													<img id="FacilityImg" src="/Files/<%:!(string.IsNullOrEmpty(images.SaveFileName)) ? images.SaveFileName : "" %>">
												</div>
											</div>
										</div>
										<%	
												}
										%>
										</div>
										<%
											}
										%>

										<div id="divFacilityImagePlaceHolder" class="form-row">
										</div>

										<% Html.RenderPartial("./Common/File"
													   , Model.FileList
													   , new ViewDataDictionary { { "name", "Facility.FileGroupNo" }
													   , { "fname", "FacilityImgFile" }
													   , { "value", Model.Facility != null ? Model.Facility.FileGroupNo : 0 }
													   , { "fileDirType", "Facility"}
													   , { "filecount", 10 }
													   , { "width", "100" }
													   , { "isimage", 1 }}); %>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 text-right">
					<input type="button" onclick="fnSaveFacility();" class="btn btn-primary" value="저장" />
					<%--<input type="button" onclick="fnDelConfirm();" class="btn btn-danger <%:(Model.Facility.FacilityNo > 0 && Model.Facility.FacilityDeletePossibleYN == "Y") ? "" : "d-none"%>" value="삭제" />--%>
					<input type="button" onclick="window.close();" class="btn btn-secondary" value="닫기" />
				</div>
			</div>
		</div>

	</form>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var check = false;

		// ajax 객체 생성
		var ajaxHelper = new AjaxHelper();
		var _ajax = new AjaxHelper();
		var _ajax2 = new AjaxHelper();

		$(document).ready(function () {

			fnCallbackDelFile = function (strParam) { //사진 삭제 후 추가 함수 실행을 위한 함수 재정의
				var result = ajaxHelper.CallAjaxResult();
				if (result == 1) {
					
					if (($(_deletea).closest(".fgbox").attr("data-imageid") || "") != "") {
						$("#" + $(_deletea).closest(".fgbox").attr("data-imageid")).attr("src", "/content/images/common/arrow_white.png");
					}
					if (_fbox.attr("data-hidemode") == "1") {
						_fbox.find(".input-group").show();
					}
					$(_deletea).closest(".fileitembox").remove();
					fnResetFile(strParam);
					alert("삭제되었습니다.", 1);
					
					var deleteImage = document.getElementById("div_" + $(_deletea).closest(".fileitembox").children()[0].innerText);
					deleteImage.setAttribute("class", "d-none");
				}
				else {
					alert("삭제할 권한이 없습니다.", 1);
				}
			}

			if ($("#ddlIsFree").val() == "FREE") {
				$("#dvExpense").addClass("d-none");
			}

		});

		$("body").on("change", "input[type=file]", function (e) {

			$(this).parent().find("input.file_input_textbox").val($(this).val());
			var fbox = $(this).closest("div.fgbox");

			if ($(this).val() != "") {
				_filecontrol = $(this);
				var fname = $(this).val().toUpperCase();
				var fext = fname.split('.')[fname.split('.').length - 1].toUpperCase();
				if (this.id == "files") {
					if (fbox.attr("data-isimage") == "1" && fext != "JPG" && fext != "JPEG" && fext != "GIF" && fext != "PNG") {
						$(this).val("");
						$("#div_files").empty();
						bootAlert("이미지만 첨부해주세요.");
						$("#FacilityImg").attr("src", "");
					} else {
						var files = e.target.files;
						var filesArr = Array.prototype.slice.call(files);
						var fitem = $(this);

						filesArr.forEach(function (f) {
							if (!f.type.match("image.*")) {
								//alert("Not Image File.");
								return;
							}
							sel_file = f;
							var reader = new FileReader();
							reader.onload = function (g) {
								var thumb1 = document.createElement("div");
								thumb1.setAttribute("class", "d-none");
								thumb1.setAttribute("id", "div_" + fname);

								var thumb2 = document.createElement("div");
								thumb2.setAttribute("class", "thumb-wrap");

								var thumb3 = document.createElement("div");
								thumb3.setAttribute("class", "thumb");

								var thumbImg = document.createElement("img");
								thumbImg.setAttribute("src", g.target.result);

								thumb3.appendChild(thumbImg);
								thumb2.appendChild(thumb3);
								thumb1.appendChild(thumb2);

								var addContainer = document.getElementById("divFacilityImagePlaceHolder");
								addContainer.appendChild(thumb1);

								for (var num = 0; num < addContainer.children.length; num++) {
									addContainer.children[num].setAttribute("class", "d-none");
								}

								var fgbox = document.getElementsByClassName("fgbox")[0].children;

								for (var index = 0; index < fgbox.length; index++) {
									if (fgbox[index].firstElementChild != null) {
										if (fgbox[index].firstElementChild.value != null) {
											var element = document.getElementById("div_" + fgbox[index].firstElementChild.value.toUpperCase());
											if (element != null) {
												element.setAttribute("class", "col-md-4 col-lg-3 mt-2 mb-2");
											}
										}
									}
								}
							}
							reader.readAsDataURL(f);
						});
					}
				}
			}
		});

		function fnSaveFacility() {
			if ($("#ddlFacilityCategory").val() == "") {
				bootAlert("카테고리 선택해주세요.");
				$("ddlFacilityCategory").focus();
				return;
			}
			<%
				if (Model.FacilityType == "FACILITY")
				{ 
			%>
			if ($("#nmMaxUserCount").val() == 0 ) {
				bootAlert("최대수용인원을 입력해주세요.");
				$("ddlFacilityCategory").focus();
				return;
			}
			<%
				}
			%>
			if ($("#txtContNm").val() == "") {
				bootAlert("<%:Model.FacilityType == "FACILITY" ? "시설" : Model.FacilityType == "EQUIPMENT" ? "장비" : "시설"%>명을 입력해주세요.");
				$("txtContNm").focus();
				return;
			}
			if ($("#ddlIsFree").val() == "CHARGED") {
				if (!($("#txtFacilityExpense").val() > 0)) {
					bootAlert("<%:Model.FacilityType == "FACILITY" ? "시설" : Model.FacilityType == "EQUIPMENT" ? "장비" : "시설"%>을 유료로 선택할 경우 비용을 입력해야합니다.");
					$("txtFacilityExpense").focus();
					return;
				}
			}

			bootConfirm("저장하시겠습니까?", function () {
				debugger;
				var formData = new FormData($("#mainForm")[0]);

				_ajax.CallAjaxPostFile("/Facility/WriteFacility", formData, "cbWrite");
			});
		}

		function cbWrite() {
			var result = _ajax.CallAjaxResult();

			if (result > 0) {
				bootAlert("저장되었습니다.", function () {
					opener.parent.location.reload();
					window.close();
				});
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}

		}

		function fnTypeSelect() {
			_ajax2.CallAjaxPost("/Facility/FacilityTypeSelect", { FacilityType: $("#ddlFacilityType").val() }, "cbResult");
		}

		function cbResult() {
			var result = _ajax2.CallAjaxResult();
			var objDDL = null;
			objDDL = $("#ddlFacilityCategory");
			objDDL.find("option").remove().end();
			if (result != null) {
				if (result.length > 0) {
					objDDL.append("<option value=''>선택</option>\r\n");
					for (var i = 0; i < result.length; i++) {
						objDDL.append("<option value='" + result[i].CodeValue + "'>" + result[i].CodeName + "</option>\r\n");
					}
				}
				else {
					objDDL.append("<option value=''>선택</option>\r\n");
				}
			}
			else {
				alert("error occured.");
			}
		}

		function fnIsFreeSelect() {
			debugger;
			if ($("#ddlIsFree").val() == "FREE") {
				$("#dvExpense").addClass("d-none");
			}
			else {
				$("#dvExpense").removeClass("d-none");
			}
		}

	</script>

</asp:Content>
