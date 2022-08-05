<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Course/WriteOutAdmin" method="post" id="mainForm" enctype="multipart/form-data">
		<div id="content">
			<ul class="nav nav-tabs mt-4" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link active" onclick="fnTab(0)" href="#" role="tab">기본정보</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" onclick="fnTab(1)" href="#" role="tab">주차 설정</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" onclick="fnTab(2)" href="#" role="tab">평가기준 설정</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" onclick="fnTab(3)" href="#" role="tab">콘텐츠 설정</a>
				</li>
			</ul>

			<!-- 기본정보 -->
			<div class="row">
				<div class="col-12 mt-2">
					<div class="card">
						<div class="card-body">
							<div class="form-row">
								<div class="form-group col-12">
									<label for="txtSubjectName" class="form-label"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명 <strong class="text-danger">*</strong></label>
									<input type="text" id="txtSubjectName" title="SubjectName" name="Subject.SubjectName" class="form-control" value="<%:Model.Course != null ? Model.Course.SubjectName : ""%>">
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-3" : "d-none" %>">
									<label for="ddlStudyType" class="form-label">강의형태 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<select class="form-control" id="ddlStudyType" name="Course.StudyType">
											<%
												if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N"))
												{
													foreach (var item in Model.BaseCode)
													{
											%>
													<option value="<%:item.CodeValue %>" <% if (item.CodeValue.Equals(Model.Course != null ? Model.Course.StudyType : "")) { %> selected="selected" <% } %>><%:item.CodeName %></option>
											<%
													}
												}
											%>
										</select>
									</div>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-9" : "d-none" %>">
									<label for="txtClassRoom" class="form-label">강의장소</label>
									<textarea id="txtClassRoom" class="form-control" name="Course.ClassRoom" rows="1"><%:Model.Course != null && !string.IsNullOrEmpty(Model.Course.ClassRoom) ? Model.Course.ClassRoom.Replace("<br/>", "\r\n") : "" %></textarea>
								</div>
								<div class="form-group col-12">
									<label for="txtIntroduce" class="form-label">과정소개</label>
									<textarea id="txtIntroduce" class="form-control" name="Course.Introduce" rows="2"><%:Model.Course != null && !string.IsNullOrEmpty(Model.Course.Introduce) ? Model.Course.Introduce.Replace("<br/>", "\r\n") : "" %></textarea>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-12" : "d-none" %>">
									<label for="txtClassTarget" class="form-label">학습목표</label>
									<textarea id="txtClassTarget" class="form-control" name="Course.ClassTarget" rows="2"><%:Model.Course != null && !string.IsNullOrEmpty(Model.Course.ClassTarget) ? Model.Course.ClassTarget.Replace("<br/>", "\r\n") : "" %></textarea>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-12" : "d-none" %>">
									<label for="txtTextbookData" class="form-label">교재 및 참고자료</label>
									<textarea id="txtTextbookData" class="form-control" name="Course.TextbookData" rows="2"><%:Model.Course != null && !string.IsNullOrEmpty(Model.Course.TextbookData) ? Model.Course.TextbookData.Replace("<br/>", "\r\n") : "" %></textarea>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-4" : "col-6" %>">
									<label for="divCategory" class="form-label">카테고리설정 <strong class="text-danger">*</strong></label>
									<div>
                                        <button class="btn btn-sm btn-outline-info" type="button" data-toggle="modal" data-target="#divCategoryList" title="추가">추가</button>
										<div id="divCategory">
											<%
												if (!string.IsNullOrEmpty(Model.Course.Mnos)) 
												{
													foreach (var item in Model.CategoryList.Where(w=> ("," + Model.Course.Mnos + ",").Contains("," + w.MNo + ",")).ToList()) 
													{
											%>
														<span class="text-nowrap text-secondary" id="spanMnos">
															<%:item.MName %>
															<button type="button" class="text-danger" title="삭제" onclick="fnCategoryDelete(<%:item.MNo %>)"><i class="bi bi-trash"></i></button>
														</span>
											<%
													}
												}
											%>
										</div>										
                                    </div>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-4" : "col-6" %>">
									<label for="divProfessor" class="form-label">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>(담당자) <strong class="text-danger">*</strong></label>
									<div>
                                        <button class="btn btn-sm btn-outline-info" type="button" data-toggle="modal" data-target="#divProfessorList" title="추가">추가</button>
										<div id="divProfessor">
											<%
												foreach (var item in Model.ProfessorList) 
												{
											%>
													<span class="text-nowrap text-secondary" id="spanProfessor">
														<%:item.ProfessorName %>
														<button type="button" class="text-danger" title="삭제" onclick="fnProfessorDelete(<%:item.ProfessorNo %>)"><i class="bi bi-trash"></i></button>
													</span>
											<%
												}
											%>
										</div>										
                                    </div>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-4" : "col-6" %>">
									<label for="ddlTerm" class="form-label"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> <strong class="text-danger">*</strong></label>
									<select id="ddlTerm" name="Course.TermNo" class="form-control">
										<option value=""><%:ConfigurationManager.AppSettings["TermText"].ToString() %>선택</option>
										<%
											foreach (var item in Model.TermList) 
											{
										%>
												<option value="<%:item.TermNo %>" <%if (item.TermNo.Equals(Model.Course == null ? ViewBag.TermNo : Model.Course.TermNo)) { %> selected="selected" <% } %> ><%:item.TermName.ToString() %></option>
										<%
											}
											
										%>
									</select>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-4" : "d-none" %>">
									<label for="txtTargetUser" class="form-label">교육대상</label>
									<div class="input-group">
										<input class="form-control text-left col-8" name="Course.TargetUser" id="txtTargetUser" type="text" autocomplete="off" value="<%:Model.Course.TargetUser %>">
									</div>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-4" : "d-none" %>">
									<label for="txtClassTime" class="form-label">교육시간</label>
									<div class="input-group">
										<input class="form-control text-left col-8" name="Course.ClassTime" id="txtClassTime" type="text" autocomplete="off" value="<%:Model.Course.ClassTime %>">
									</div>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-4" : "d-none" %>">
									<label for="txtCourseExpense" class="form-label">교육비</label>
									<div class="input-group">
										<input class="form-control text-right col-6" name="Course.CourseExpense" id="txtCourseExpense" type="number" autocomplete="off" value="<%:Model.Course.CourseExpense %>">
										<div class="input-group-append">
											<span class="input-group-text">
												원
											</span>
										</div>
									</div>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-4" : "d-none" %>">
									<label for="txtCompletion" class="form-label">수료증</label>
									<div class="input-group">
										<input class="form-control text-left col-8" name="Course.Completion" id="txtCompletion" type="text" autocomplete="off" value="<%:Model.Course.Completion %>">
									</div>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-4" : "d-none" %>">
									<label for="txtSupportDevice" class="form-label">기기지원</label>
									<div class="input-group">
										<input class="form-control text-left col-8" name="Course.SupportDevice" id="txtSupportDevice" type="text" autocomplete="off" value="<%:Model.Course.SupportDevice %>">
									</div>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-2" : "col-6" %>" id="divOpen">
									<label for="chkViewYesNo" class="form-label">공개여부 <strong class="text-danger">*</strong></label>
									<label class="switch">
										<input type="checkbox" id="chkViewYesNo" name="Course.ViewYesNo" <%if (Model.Course.ViewYesNo == null || Model.Course.ViewYesNo.Equals("Y")){ %> checked="checked"<%}  %> >
										<span class="slider round"></span>
									</label>
								</div>
							</div>
							<div class="form-row">
								<div class="form-group col-12 col-md-6">
									<label for="txtRStart" class="form-label">신청기간 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input class="form-control datepicker text-center" name="Course.RStart" id="txtRStart" type="text" placeholder="YYYY-MM-DD" autocomplete="off">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
										<div class="input-group-append input-group-prepend">
											<span class="input-group-text">~</span>
										</div>
										<input class="form-control datepicker text-center" name="Course.REnd" id="txtREnd" type="text" placeholder="YYYY-MM-DD" autocomplete="off">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group col-12 col-md-6">
									<label for="txtLStart" class="form-label">강의기간 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input class="form-control datepicker text-center" name="Course.LStart" id="txtLStart" type="text" placeholder="YYYY-MM-DD" autocomplete="off">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
										<div class="input-group-append input-group-prepend">
											<span class="input-group-text">~</span>
										</div>
										<input class="form-control datepicker text-center" name="Course.LEnd" id="txtLEnd" type="text" placeholder="YYYY-MM-DD" autocomplete="off">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "col-12" : "d-none" %>">
									<label for="txtCourseQA" class="form-label">교육문의</label>
									<textarea id="txtCourseQA" class="form-control" name="Course.CourseQA" rows="1"><%:Model.Course != null && !string.IsNullOrEmpty(Model.Course.CourseQA) ? Model.Course.CourseQA.Replace("<br/>", "\r\n") : "" %></textarea>
								</div>
								<div class="form-row col-12">
                                    <div class="form-group col-12">
                                        <label for="btnUpload" class="form-label">썸네일 등록 </label>
                                        <small class="text-small text-muted">(218*148)</small>
                                        <div>
										 <!-- image type -->
										<div id="divMoocThumbImg" class="col-md-4 col-lg-3 mt-2 mb-2 <%:Model.Course.CourseNo > 0 && !(string.IsNullOrEmpty(Model.Course.SaveFileName)) ? "" : "d-none" %>">
											<div class="thumb-wrap">
												<div class="thumb">
													<img id="moocThumbnailImg" src="<%:(Model.Course != null && !(string.IsNullOrEmpty(Model.Course.SaveFileName))) ? "/" + System.Web.Configuration.WebConfigurationManager.AppSettings["FileRootFolder"].ToString() + Model.Course.SaveFileName : "" %>">
												</div>
											</div>
										</div>
                                            <% Html.RenderPartial("./Common/File"
                                                   , Model.FileList
                                                   , new ViewDataDictionary { {"id", "FileUpload"}
                                                       , { "name", "FileGroupNo" }
                                                       , { "fname", "File" }
                                                       , { "value", Model.FileGroupNo }
                                                       , { "fileDirType", "MOOC"}
                                                       , { "filecount", 1 }
													   , { "imageid", "moocThumbnailImg"}
                                                       , { "width", "100" }
                                                       , { "isimage", 1 }
                                                       , { "FileCustomizeYN", "Y"}
                                                       , { "FileCustomizeTag", "<i class=\"bi bi-upload\"></i> 썸네일 업로드" }
                                                       , { "reloadYN", "Y"}
                                                }); %>
                                        </div>
                                    </div>
                                </div>
							</div>
						</div>
						<div class="card-footer">
							<div class="row align-items-center">
								<div class="col-12 text-right">
									<button type="button" class="btn btn-primary" id="btnSave">저장</button>
									<button type="button" class="btn btn-danger" id="btnDelete">삭제</button>
									<a href="#" class="btn btn-secondary" onclick="fnGo()">목록</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 기본정보 -->

			<!-- 카테고리 추가 모달 -->
			<div class="modal fade show" id="divCategoryList" tabindex="-1" aria-labelledby="category" aria-modal="true" role="dialog">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title h4">카테고리 추가</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-12">
									<div class="card">
										<div class="card-body py-0">
											<div class="table-responsive overflow-auto" style="max-height: 400px">
												<table class="table" id="tblTeamNotMemberList">
													<caption>카테고리 리스트</caption>
													<thead>
														<tr>
															<th scope="row">카테고리</th>
															<th scope="row">관리</th>
														</tr>
													</thead>
													<tbody>
														<%
															if (Model.CategoryList.Count.Equals(0))
															{
														%>
																<tr>
																	<td colspan="2" class="text-center">등록된 카테고리가 없습니다.</td>
																</tr>
														<%
															}
															else 
															{
																foreach (var item in Model.CategoryList) 
																{
														%>
																	<tr>
																		<td>
																			<span class="text-nowrap text-secondary font-size-15"><%:item.MName %></span>
																		</td>
																		<td>
																			<button type="button" title="추가" class="btn btn-outline-primary" onclick="fnCategoryComplete(<%:item.MNo %>, '<%:item.MName %>')">선택</button>
																		</td>
																	</tr>
														<%
																}
															}
														%>
													</tbody>
												</table>
											</div>
										</div>
										<div class="card-footer">
											<div class="row align-items-center">
												<div class="col-md-12 text-right">
													<button type="button" class="btn btn-outline-secondary" data-dismiss="modal" title="닫기">닫기</button>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 카테고리 추가 모달 -->

			<!-- 조교 추가 모달 -->
			<div class="modal fade show" id="divProfessorList" tabindex="-1" aria-labelledby="professorList" aria-modal="true" role="dialog">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title h4" id="professorList">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>(담당자) 추가</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<div class="card search-form m-3">
								<div class="card-body pb-1">
									<div class="form-row align-items-end">
										<div class="form-group col-4">
											<label for="ddlSearchGbn" class="sr-only">검색구분</label>
											<select id="ddlSearchGbn" name="SearchGbn" class="form-control">
												<option value="I"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></option>
												<option value="N">성명</option>
											</select>
										</div>
										<div class="form-group col-4">
											<label for="txtSearchText" class="sr-only">검색어</label>
											<input title="검색어" id="txtSearchText" name="SearchText" class="form-control" type="text" placeholder="검색어" />
										</div>
										<div class="form-group col-auto text-right">
											<button type="button" class="btn btn-secondary" onclick="fnSearchProfessor()">
												<span class="icon search">검색</span>
											</button>
										</div>
									</div>
								</div>
							</div>
							<div class="form-row m-3">
								<div class="col-12 p-0">
									<div class="card">
										<div class="card-body py-0">
											<div class="table-responsive overflow-auto" style="max-height: 400px">
												<table class="table table-hover" summary="조교 검색 목록">
													<caption>조교 검색 목록</caption>
													<thead>
														<tr>
															<%
																if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
																{
															%>
															<th scope="col">소속</th>
															<%
																}
															%>
															<th scope="col">ID</th>
															<th scope="col">성명</th>
															<th scope="col">관리</th>
														</tr>
													</thead>
													<tbody id="tbody">
														<tr>
															<td colspan="4" class="text-center">
																검색된 사용자가 없습니다.
															</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
										<div class="card-footer">
											<div class="row align-items-center">
												<div class="col-12 text-right">
													<button type="button" class="btn btn-outline-secondary" data-dismiss="modal" title="닫기">닫기</button>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>			
						</div>
					</div>
				</div>
			</div>
			<!-- 조교 추가 모달 -->
		</div>

		<input type="hidden" id="hdnProfessorNos" name="Course.ProfessorNos" value="<%:Model.Course.ProfessorNos %>"/>
		<input type="hidden" id="hdnMnos" name="Course.Mnos" value="<%:Model.Course != null ? Model.Course.Mnos : "" %>"/>
		<input type="hidden" id="hdnUserTarget" name="Course.UserTarget" value="<%:Model.Course != null ? Model.Course.TargetUser : "" %>"/>
		<input type="hidden" id="hdnCourseNo" name="Course.CourseNo" value="<%:Model.Course != null ? Model.Course.CourseNo : 0 %>"/>
		<input type="hidden" id="hdnSubjectNo" name="Course.SubjectNo" value="<%:Model.Course != null ? Model.Course.SubjectNo : 0 %>"/>
		<input type="hidden" id="hdnFileGroupNo" name="Course.FileGroupNo" value="<%:Model.Course != null ? Model.Course.FileGroupNo : 0 %>"/>
		<input type="hidden" id="hdnUnivYN" value="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "N" : "Y" %>"/>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {

			fnFromToCalendar("txtLStart", "txtLEnd", $("#txtLStart").val());
			fnFromToCalendar("txtRStart", "txtREnd", $("#txtRStart").val());

			$("#txtLStart").val("<%: Model.Course != null ? Model.Course.LStart : ""%>");
			$("#txtLEnd").val("<%: Model.Course != null ? Model.Course.LEnd : ""%>");
			$("#txtRStart").val("<%: Model.Course != null ? Model.Course.RStart : ""%>");
			$("#txtREnd").val("<%: Model.Course != null ? Model.Course.REnd : ""%>");
		});

		<%-- 탭 이동 --%>
		function fnTab(index) {

			if (index == 0) {
				location.reload();
			} else if (index == 1) {
				if (<%:Model.Course.CourseNo%> > 0) {
					fnGoTab('ListWeekOutAdmin');
				} else {
					fnTabAlert();
				}
			} else if (index == 2) {
				if (<%:Model.Course.CourseNo%> > 0) {
					fnGoTab('EstimationOutWriteAdmin');
				} else {
					fnTabAlert();
				}
			} else if (index == 3) {
				if (<%:Model.Course.CourseNo%> > 0) {
					fnGoTab('OcwOutAdmin');
				} else {
					fnTabAlert();
				}
			}
		}

		function fnGoTab(pageName) {

			location.href = "/Course/" + pageName + "/" + <%:Model.Course.CourseNo%> +"?TermNo=" + <%:ViewBag.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

		function fnTabAlert() {
			bootAlert("기본정보를 등록해야 설정할 수 있습니다.");
		}

		<%-- 썸네일 --%>
		$("body").on("change", "input[type=file]", function (e) {
			$(this).parent().find("input.file_input_textbox").val($(this).val());
			var fbox = $(this).closest("div.fgbox");

			if ($(this).val() != "") {
				_filecontrol = $(this);
				var fname = $(this).val().toUpperCase();
				var fext = fname.split('.')[fname.split('.').length - 1].toUpperCase();

				if (this.id == "FileUpload") {
					if (fbox.attr("data-isimage") == "1" && fext != "JPG" && fext != "JPEG" && fext != "GIF" && fext != "PNG") {
						$(this).val("");
						$("#div_FileUpload").empty();
						bootAlert("이미지만 첨부해주세요.");
						$("#moovThumbnailImg").attr("src", "");
						$("#divMoocThumbImg").addClass("d-none");
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
							reader.onload = function (e) {
								$("#" + $(fitem).closest(".fgbox").attr("data-imageid")).attr("src", e.target.result);
							}
							reader.readAsDataURL(f);
						});
						$("#divMoocThumbImg").removeClass("d-none");
						$("#" + $(this).closest(".fgbox").attr("data-imageid")).show();
					}
				}
			}
		});

		<%-- 카테고리 추가 --%>
		function fnCategoryComplete(mno, mname) {

			if (("," + $("#hdnMnos").val() + ",").indexOf("," + mno + ",") < 0) {
				$("#hdnMnos").val($("#hdnMnos").val() == "" ? mno : ($("#hdnMnos").val() + "," + mno));
				$("#divCategory").append('<span class="text-nowrap text-secondary" id="spanMnos">' + mname + '<button type="button" class="text-danger" title="삭제" onclick="fnCategoryDelete('+ mno +')"><i class="bi bi-trash"></i></button></span>');
				fnSaveAlert();

			} else {
				bootAlert("이미 등록된 카테고리입니다.");
			}
		}

		<%-- 카테고리 삭제 --%>
		function fnCategoryDelete(mno) {

			var i = 0;
			var v = "";
			var Mnos = $("#hdnMnos").val().split(',');

			for (var j = 0; j < Mnos.length; j++) {
				if (Mnos[j] != mno) {
					v += "," + Mnos[j];
				} else {
					i = j;
				}
			}

			$("#hdnMnos").val(v == "" ? "" : v.substr(1));
			$("#divCategory span").eq(i).remove();
			fnSaveAlert();
		}

		<%-- 담당교수 조회 --%>
		function fnSearchProfessor() {

			if ($("#ddlSearchGbn").val() == "") {
				bootAlert("검색구분을 선택하세요.");
				$("#ddlSearchGbn").focus();
				return false;
			}
			else if ($("#txtSearchText").val().length < 2) {
				bootAlert("검색어를 2자 이상입력하세요.");
				$("#txtSearchText").focus();
				return false;
			}
			else {

				ajaxHelper.CallAjaxPost("/Course/SearchProfessor", { searchGbn: $("#ddlSearchGbn").val(), searchText: $("#txtSearchText").val() }, "fnCompleteSearchProfessor");
			}
			fnPrevent();
		}

		function fnCompleteSearchProfessor() {

			var data = ajaxHelper.CallAjaxResult();
			var tbodyHtml = "";

			if (data.length > 0) {
				for (var i = 0; i < data.length; i++) {
					tbodyHtml += '	<tr>';
					<%
						if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
						{
					%>
					tbodyHtml += '		<td class="text-left">' + data[i].AssignName + '</td>';
					<%
						}
					%>
					tbodyHtml += '		<td>' + data[i].UserID + '</td>';
					tbodyHtml += '		<td>' + data[i].HangulName + '</td>';
					tbodyHtml += '		<td>';
					tbodyHtml += '			<button type="button" title="선택" class="btn btn-outline-primary" onclick="fnProfessorComplete(' + data[i].UserNo + ',' + '`' + data[i].HangulName + '`)">선택</button>';
					tbodyHtml += '	</tr>';
				}
			} else {
				tbodyHtml += "<tr>";
				tbodyHtml += "	<td colspan=\"4\" class=\"text-center\">검색된 사용자가 없습니다.</td>";
				tbodyHtml += "</tr>";
			}

			$("#tbody").html(tbodyHtml);
		}

		<%-- 담당교수 선택 --%>
		function fnProfessorComplete(userNo, hangulName) {

			if (("," + $("#hdnProfessorNos").val() + ",").indexOf("," + userNo + ",") < 0) {

				$("#hdnProfessorNos").val($("#hdnProfessorNos").val() == "" ? userNo : ($("#hdnProfessorNos").val() + "," + userNo));
				$("#divProfessor").append('<span class="text-nowrap text-secondary" id="spanProfessor">' + hangulName + '<button type="button" class="text-danger" title="삭제" onclick="fnProfessorDelete(' + userNo + ')"><i class="bi bi-trash"></i></button></span>');
				fnSaveAlert();

			} else {
				bootAlert("이미 등록된 <%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>입니다.");
			}
		}

		<%-- 담당교수 삭제 --%>
		function fnProfessorDelete(professorNo) {

			var i = 0;
			var v = "";
			var professorNos = $("#hdnProfessorNos").val().split(',');

			for (var j = 0; j < professorNos.length; j++) {
				if (professorNos[j] != professorNo) {
					v += "," + professorNos[j];
				} else {
					i = j;
				}
			}

			$("#hdnProfessorNos").val(v == "" ? "" : v.substr(1));
			$("#divProfessor span").eq(i).remove();
			fnSaveAlert();
		}

		function fnSaveAlert() {
			bootAlert("저장해야 반영됩니다.");
		}

		<%-- MOOC 저장 --%>
		$("#btnSave").click(function () {

			if ($("#txtSubjectName").val() == "") {
				bootAlert("<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명을 입력하세요.", function () {

					$("#txtSubjectName").focus();
				});
				return false;
			}

			if ($("#ddlTerm").val() == "") {
				bootAlert("<%:ConfigurationManager.AppSettings["TermText"].ToString() %>를 선택하세요.", function () {
					$("#ddlTerm").focus();
				});

				return false;
			}

			if ($("#spanMnos").text() == "") {
				bootAlert("카테고리를 설정하세요.");
				return false;
			}

			if ($("#spanProfessor").text() == "") {
				bootAlert("담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>를 설정하세요.");
				return false;
			}

			if ($("#txtRStart").val() == "" || $("#txtREnd").val() == "") {
				bootAlert("신청기간을 입력하세요.", function () {

					if ($("#txtRStart").val() == "" && $("#txtREnd").val() == "") {
						$("#txtRStart").focus();
					} else if ($("#txtRStart").val() == "") {
						$("#txtRStart").focus();
					} else if ($("#txtREnd").val() == "") {
						$("#txtREnd").focus();
					}
				});
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtRStart").val())) {
				bootAlert("날짜 형식을 확인해주세요.");
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtREnd").val())) {
				bootAlert("날짜 형식을 확인해주세요.");
				return false;
			}

			if ($("#txtLStart").val() == "" || $("#txtLEnd").val() == "") {
				bootAlert("강의기간을 입력하세요.", function () {

					if ($("#txtLStart").val() == "" && $("#txtLEnd").val() == "") {
						$("#txtLStart").focus();
					} else if ($("#txtLStart").val() == "") {
						$("#txtLStart").focus();
					} else if ($("#txtLEnd").val() == "") {
						$("#txtLEnd").focus();
					}
				});
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtLStart").val())) {
				bootAlert("날짜 형식을 확인해주세요.");
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtLEnd").val())) {
				bootAlert("날짜 형식을 확인해주세요.");
				return false;
			}

			bootAlert("저장하시겠습니까?", function () {
				document.forms["mainForm"].submit();
			});

			fnPrevent();
		})


		<%-- MOOC 삭제 --%>
		$("#btnDelete").click(function () {

			if (confirm("삭제하시겠습니까 ?")) {

				ajaxHelper.CallAjaxPost("/Course/LectureChk", { courseNo: $("#hdnCourseNo").val(), subjectNo: $("#hdnSubjectNo").val() }, "fnCompleteLectureChk");

			}
			return false;
		})

		function fnCompleteLectureChk() {

			var result = ajaxHelper.CallAjaxResult();

			if (result.LectureCount != 0) {

				bootAlert("현재 강좌에 수강생이 있습니다. \n수강생이 없어야 삭제가 가능합니다.");
				return false;
			} else {

				if (confirm("삭제 시 하위분류까지 모두 삭제됩니다.\n삭제하시면 복구가 불가합니다.\n정말 삭제하시겠습니까?")) {
					document.forms[0].action = "/Course/MoocDelete/" + $("#hdnCourseNo").val();
					document.forms[0].submit();
				}

				alert("삭제되었습니다.");
			}

		}

		function fnGo() {

			window.location.href = "/Course/ListOutAdmin/?TermNo=" + '<%:ViewBag.TermNo %>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

		function inputNumberFormat(obj) {
			const valueComma = obj.value;
			obj.value = valueComma.toLocaleString('ko-KR');
		 }

	</script>
</asp:Content>