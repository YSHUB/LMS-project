<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.BoardViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form id="mainForm" action="/Board/Write/<%: Model.Board.CourseNo %>" method="post" enctype="multipart/form-data">
        <div class="card">
			<div class="card-body">
				<div class="form-row">
					<div class="form-group col-12">
						<label for="txtBoardTitle" class="form-label">제목 <strong class="text-danger">*</strong></label>
						<input type="text" name="Board.BoardTitle" id="txtBoardTitle" class="form-control" title="제목" value="<%:Model.Board.BoardTitle %>">
					</div>
					<%
						if (Model.BoardMaster.IsNotice.Equals("Y"))
						{
					%>
					        <div class="form-group col-md-6 mb-0 mb-md-2">
						        <div class=" form-check">
							        <input type="checkbox" class="form-check-input" id ="chkHighestFixYesNo" name="Board.HighestFixYesNo" value="<%:Model.Board.HighestFixYesNo ?? "N" %>" <%: (Model.Board.HighestFixYesNo ?? "N").Equals("Y") ? "checked='checked'" : "" %>>
							        <label class="form-check-label" for="chkHighestFixYesNo">목록에서 최상단 위치에 고정/ [공지] 표시</label>
						        </div>
					        </div>
                    <%
                        } 
                    %>
                    <% 
						if (Model.BoardMaster.IsAnonymous == "Y")
						{
                    %>
					        <div class="form-group col-md-6 mb-0 mb-md-2">
						        <div class=" form-check">
							        <input type="checkbox" class="form-check-input" id ="chkIsAnonymous" name="Board.IsAnonymous" value="<%: Model.Board.IsAnonymous %>" <%: Model.Board.IsAnonymous.Equals(1) ? "checked='checked'" : "" %>>
							        <label class="form-check-label" for="chkIsAnonymous">익명 설정 <small class="text-danger">(공지글의 경우 익명글을 선택해도 적용되지 않음)</small></label>
						        </div>
					        </div>
                    <%
                        } 
                    %>
                    <% 
						if (Model.BoardMaster.BoardIsSecretYesNo == "Y")
						{
                    %>
                            <div class="form-group col-md-6 mb-0 mb-md-2">
						        <div class=" form-check">
							        <input type="checkbox" class="form-check-input" id="chkIsSecret" name="Board.IsSecret" value="<%: Model.Board.IsSecret %>" <%: Model.Board.IsSecret.Equals(1) ? "checked='checked'" : "" %>>
							        <label class="form-check-label" for="chkIsSecret">비밀글 설정 <small class="text-danger">(공지글의 경우 비밀글을 선택해도 적용되지 않음)</small></label>
						        </div>
					        </div>
                    <%
                        } 
                    %>
					<div class="form-group col-12 mt-2">
						<% Html.RenderPartial("./Common/Editor", new ViewDataDictionary {{ "Contents", Model.Board.HtmlContents }});%>
					</div>
                    <%
                        if (Model.BoardMaster.BoardIsUseFileYesNo.Equals("Y")) //첨부파일 사용게시판일때만 보여짐
                        { 
                    %>
					    <div class="form-group col-12">
						    <label for="" class="form-label">파일 첨부</label>
                            <% Html.RenderPartial("./Common/File"
								  , Model.FileList
								  , new ViewDataDictionary {
								        { "name", "FileGroupNo" },
								        { "fname", "BoardFile" },
                                        { "value", Model.FileGroupNo},
                                        {"readmode", (Model.Board.RowState.Equals("U") ? 0 : 1) },
								        { "fileDirType", "Board"},
								        { "filecount", 10 }, { "width", "100" }, {"isimage", 0 } }); %>
					    </div>
                    <%
                        } 
                    %>
				</div>
			</div>
        </div>
		<div class="text-right">
			<button type="button" id="btnSave" class="btn btn-primary">저장</button>
			<a class="btn btn-secondary" role="button" href="/Board/List/<%:Model.CourseNo %>/<%:Model.MasterNo%>">목록</a>
		</div>
    <input type="hidden" id="hdnMasterNo" name="MasterNo" value="<%:Model.MasterNo %>" />
    <input type="hidden" id="hdnCourseNo" name="CourseNo" value="<%:Model.CourseNo %>" />
    <input type="hidden" id="hdnBoardNo" name="Board.BoardNo" value="<%:Model.Board.BoardNo %>" />
    <input type="hidden" id="hdnRowState" name="Board.RowState" value="<%:Model.Board.RowState %>" />
    <input type="hidden" id="hdnUserNo" name="Board.CreateUserNo" value="<%:ViewBag.User.UserNo %>" />
    <input type="hidden" id="hdnIsProf" name="IsProf" value="<%:ViewBag.Course.IsProf%>" />
    <input type="hidden" id="hdnFileGroupNo" name="Board.FileGroupNo" value="<%:Model.Board.FileGroupNo %>" />
    <input type="hidden" id="hdnParentBoardNo" name="ParentBoardNo" value="<%:Model.ParentBoardNo %>" />
    <input type="hidden" id="hdnContents" name="Board.Contents" />
    <input type="hidden" id="hdnHtmlContents" name="Board.HtmlContents" />
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
		var oEditors = [];
        var _ajax = new AjaxHelper();

		$(document).ready(function () {
			var fileSuccess = '<%:Model.FileSuccess%>';
			if (fileSuccess == 1) {
				bootAlert("파일 업로드에 실패했습니다. 게시물을 다시 작성해주세요.");
			}

            $("#h_subjectName").val($("#roommastercourseselect :selected").text());

            // 체크박스 사용시 값이 on으로 들어가서 1, 0 변경 처리
			$("#chkHighestFixYesNo").on("change", function () {
				$(this).val("N");
				if ($(this).prop("checked")) {
					$(this).val("Y");
				}
			});

			$("#chkIsSecret").on("change", function () {
                $(this).val(0);
                if ($(this).prop("checked")) {
                    $(this).val(1);
                }
            });

			$("#chkIsAnonymous").on("change", function () {
				$(this).val(0);
				if ($(this).prop("checked")) {
					$(this).val(1);
                }
            });


            $("#btnSave").click(function () {

				if ($("#hdnMasterNo").val() == "CourseMentoring" && "<%:ViewBag.Course.IsProf%>")
                {
                    if ($("#GroupNo option:selected").val() == 0)
                    {
						bootAlert("그룹을 선택하세요", 1);
                        return false;
                    }
                    if ($("#TeamNo option:selected").val() == "") {
						bootAlert("조를 선택하세요", 1);
                        return false;
                    }

                }
                 
                if($("#boardContent_CategoryNo").val()==""){
					bootAlert("구분을 선택하세요", 1);
                    return false;
                }

				if ($("#txtBoardTitle").val()==""){
					bootAlert("제목을 입력하세요", 1);
                    return false;
                }
                
                fnSubmitContents();

            });

            $("#btn_cancel").click(function(){
             document.forms["boardForm"].reset();
            });
 
        });
    
        function fnSubmitContents() {

            myeditor.outputBodyHTML(); 

            var contentsText = myeditor.getBodyText(); //editor html내용 text내용으로 가져옴.

			$("#hdnContents").val(contentsText);
			$("#hdnHtmlContents").val(encodeURI(document.getElementById("editorContentValue").value));

			if (document.getElementById("editorContentValue").value == "") {
				bootAlert("내용을 입력하세요.", 1);
                return false;
            }

            try {

                var _content = $("#editorContentValue").val();
				$("#editorContentValue").text(_content);
                
				if ($("#editorContentValue").val()=="<br>"){
					bootAlert("내용을 입력하세요.", 1);
                    return false;
                }
			    else if ('<%: ViewBag.User.UserType.Equals("USRT001")?1:0%>' == '1' && $("#boardid").val() == "CourseQA" && $("#EMail").val() == "") {
					bootAlert("<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>를 선택해주세요.", 1);
				    return false;
			    }
			    else {
					var textAreaTexts = $("#editorContentValue").val().split(">");

				    var htmls = "<div>";

				    for (var i = 0; i < textAreaTexts.length; i++) {
					    textAreaTexts[i] = textAreaTexts[i] + ">";
					    htmls += textAreaTexts[i];
				    }
				    htmls += "</div>";

				    var imgs = $(htmls).find(".userInputImage");

				    for (var i = 0; i < imgs.length; i++) {
					    $("#ContentImage").append($.stringFormat("<input type='hidden' name='userImgs' value='{0}' />", $(imgs[i]).attr("src")));
				    }

					$("#editorContentValue").val(encodeURIComponent($("#editorContentValue").val()));

					document.forms["mainForm"].submit();
			    }
		    } catch (e) { }
	    }
	</script>
</asp:Content>