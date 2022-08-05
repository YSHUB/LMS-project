<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ContentViewModel>" %>


<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
		var oEditors = [];
		var _ajax = new AjaxHelper();

		fnFromToCalendar("txtStartDay", "txtEndDay", $("#txtStartDay").val());

		$(document).ready(function () {
			$("#editorContentValue").val($("#hdnContents").val());
			$("#txtStartDay").val("<%: Model.Popup != null ? Model.Popup.StartDay : "" %>")
			$("#txtEndDay").val("<%: Model.Popup != null ? Model.Popup.EndDay : "" %>")

        });

        //저장
        $("#btnSave").click(function () {

            if ($("input[name='Popup.PopupTitle']").val() == "") {
                bootAlert("팝업제목를 입력하세요.");
                return false;
            }

            var stDateArr = $("input[name='Popup.StartDay']");
            var endDateArr = $("input[name='Popup.EndDay']");

            if ($(stDateArr).val() == "" || $(endDateArr).val() == "") {
                bootAlert("출력기간은 필수 입력 입니다.");
                return false;
            }

            if ($(stDateArr).val() > $(endDateArr).val()) {
                bootAlert("종료일은 시작일 이후 날짜로 설정해 주세요.");
                return false;
            }

            if ($("input[name= 'Popup.WidthSize']").val() == "") {
                bootAlert("팝업 가로크기를 입력하세요.");
                return false;
            }

            if ($("input[name='Popup.HeightSize']").val() == "") {
                bootAlert("팝업 세로크기를 입력하세요.");
                return false;
            }

            if ($("input[name='Popup.LeftMargin']").val() == "") {
                bootAlert("좌측여백를 입력하세요.");
                return false;
            }

            if ($("input[name='Popup.TopMargin']").val() == "") {
                bootAlert("상단여백을 입력하세요.");
                return false;
            }
            var chkBox = $("input[name='chkPopupGubun']");
            var chkBoxValue = "";

            for (var i = 0; i < chkBox.length; i++) {
                if (chkBox[i].checked) {
                    if (chkBoxValue == "") {
                        chkBoxValue += chkBox[i].value;

                    }
                    else {
                        chkBoxValue += (chkBox[i].value);
                    }
                }

                if (chkBoxValue.length > 1) {
                    chkBoxValue = "A";
                }
            }

            <%
			if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y")) 
            {
            %>
                if (chkBoxValue == "") {
                    bootAlert("PC/Mobile 을 선택하세요.");
                    return false;
                }
            $("input[name='Popup.PopupGubun']").val(chkBoxValue);
            <%
			}
            %>
			fnSubmitContents();
		});

		function selectImageFile() {
			var x = new Date();
			window.open("/Scripts/SE2.8.2/imageUpload.html?" + x.getTime(), "selectimage", "width=400 height=300");
		}

		function pushImage(fileNames, fileNewNames, fileSizes, fileTypes) {
			for (var i = 0; i < fileNames.length; i++) {
				pasteHTML("<img class='userInputImage' alt='' style='max-width:700px;' src='/Files/Temp/" + $(fileNewNames[i]).val() + "'/>");
			}
		}

		function pasteHTML(sHTML) {
			oEditors.getById["txtPopupContent"].exec("PASTE_HTML", [sHTML]);
		}

		function fnSubmitContents() {
			myeditor.outputBodyHTML();

			var contentsText = myeditor.getBodyText(); //editor html내용 text내용으로 가져옴.

			$("#hdnContents").val(contentsText);
			$("#hdnHtmlContents").val(encodeURI(document.getElementById("editorContentValue").value));

			if (document.getElementById("editorContentValue").value == "") {
				bootAlert("내용을 입력하세요.");
				return false;
			}

			try {

				var _content = $("#editorContentValue").val();
				$("#editorContentValue").text(_content);

				if ($("#editorContentValue").val() == "<br>") {
					bootAlert("내용을 입력하세요.");
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


		function fnClose() {
			self.close();
		};

		function abcd() {
			debugger;
			bootAlert('ttt.', function () {
				opener.fnCompleteAdd();
				self.close();
			});
		}
	</script>
</asp:Content>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form id="mainForm" action="/Content/PopupWrite" method="post"  enctype="multipart/form-data">
        <div class="p-4">
        <div class="row">
            <div class="col-12">
                <h2 class="title04">팝업등록</h2>
                <div class="card">
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-12 col-lg-6">
                                <label class="form-label" for="txtPopupTitle">제목 <span class="text-danger">*</span></label>
                                 <input class="form-control" name="Popup.PopupTitle" id="txtPopupTitle" title="PopupTitle" type="text"  value="<%:Model.Popup != null ? Model.Popup.PopupTitle : ""%>">
                            </div>
                            <div class="form-group col-12 col-lg-6">
                                <label class="form-label" for="txtLinkUrl">연결 URL </label>
                                <input class="form-control" name="Popup.LinkUrl" id="txtLinkUrl" title="PopupTitle"  type="text"  value="<%:Model.Popup != null ? Model.Popup.LinkUrl : ""%>">
                            </div>
                            <div class="form-group col-12">
                                <label for="PopupImg" class="form-label">이미지</label>
                                <small class="text-muted <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">이미지 사이즈는 반드시<span class="text-danger"> 700px X 780px</span> 으로 등록하세요.
                                </small>
                                <!-- image type -->
                                    <div class="col-md-4 col-lg-3 mb-2 mb-md-0 ">
                                        <div class="thumb-wrap">
                                            <div class="thumb">
                                                <img id="popImg" src="">
                                            </div>
                                        </div>
                                    </div>

                                <% Html.RenderPartial("./Common/File"
                                , Model.FileList
                                , new ViewDataDictionary {
                                { "name", "FileGroupNo" },
                                { "fname", "PopupFile" },
                                { "imageid", "popImg" },
                                { "value", 0 },
                                { "fileDirType", "Popup"},
                                { "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
                            </div>
                            <div class="form-group col-6 col-md-3">
                                <label class="form-label" for="txtStartDay">팝업 개시 시작일자 <span class="text-danger">*</span></label>
                                <input type="text" id="txtStartDay" name="Popup.StartDay" class="datepicker form-control text-center" title="팝업 개시 시작일자" autocomplete="off"  />
                            </div>
                            <div class="form-group col-6 col-md-3">
                                <label class="form-label" for="txtEndDay">팝업 개시 종료일자 <span class="text-danger">*</span></label>
                                <input type="text" id="txtEndDay" name="Popup.EndDay" class="datepicker form-control text-center" title="팝업 개시 종료일자" autocomplete="off"  />
                            </div>
                            <div class="form-group col-12 col-md-3  <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
                                <label class="form-label" for="chkPC">팝업 위치 <span class="text-danger">*</span></label>
                                <div>
                                    <div class="form-check-inline">
                                        <input id="chkPC" type="checkbox" name="chkPopupGubun" value="P" 
                                        <%= Model.Popup != null && (Model.Popup.PopupGubun.Equals("P") || Model.Popup.PopupGubun.Equals("A")) ? "checked='checked'" : "" %> class="form-check mr-1" /><label for="chkPC" class="form-check-label">PC</label>
                                    </div>
                                    <div class="form-check-inline">
                                        <input id="chkMobile" type="checkbox" name="chkPopupGubun" value="M"
                                        <%= Model.Popup != null && (Model.Popup.PopupGubun.Equals("M") || Model.Popup.PopupGubun.Equals("A")) ? "checked='checked'" : "" %> class="form-check mr-1" /><label for="chkMobile" class="form-check-label">Mobile</label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group col-12 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "col-md-6" : "col-md-3" %>">
                                <label class="form-label" for="chkOutputYesNo">출력여부<span class="text-danger">*</span></label>
                                <label class="switch">
									<input type="checkbox" id="chkOutputYesNo" name="Popup.OutputYesNo"  <%if(Model.Popup != null && Model.Popup.OutputYesNo == "Y"){ %> checked="checked" <%} %> value="Y" >
									<span class="slider round"></span>
								</label>
                            </div>
                    
                            <div class="form-group col-6 col-md-3">
                                <label class="form-label" for="txtWidthSize">가로 크기 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                     <input class="form-control" name="Popup.WidthSize" id="txtWidthSize" title="WidthSize"  type="text" MaxLength="4" typeof="Number"
                                            value="<%:Model.Popup != null ? Model.Popup.WidthSize == 0 ? "0" : Model.Popup.WidthSize.ToString() : "" %>">
                                    <div class="input-group-append"><span class="input-group-text">px</span></div>
                                </div>
                            </div>
                            <div class="form-group col-6 col-md-3">
                                <label class="form-label" for="txtHeightSize">세로 크기 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                <input class="form-control" name="Popup.HeightSize" id="txtHeightSize" title="HeightSize" type="text" maxlength="4" typeof="Number"
                                    value="<%:Model.Popup != null ? Model.Popup.HeightSize == 0 ? "0" : Model.Popup.HeightSize.ToString() : "" %>">
                            <div class="input-group-append"><span class="input-group-text">px</span></div>
                                </div>

                            </div>
                            <div class="form-group col-6 col-md-3">
                                <label class="form-label" for="txtLeftMargin">좌측 시작위치<span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input class="form-control" name="Popup.LeftMargin" id="txtLeftMargin" title="LeftMargin" type="text" maxlength="4" typeof="Number"
                                    value="<%:Model.Popup != null ? Model.Popup.LeftMargin == 0 ? "0" : Model.Popup.LeftMargin.ToString() : "" %>">
                                    <div class="input-group-append"><span class="input-group-text">px</span></div>
                                </div>
                            </div>
                            <div class="form-group col-6 col-md-3">
                                <label class="form-label" for="txtTopMargin">상단 시작위치<span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input class="form-control" name="Popup.TopMargin" id="txtTopMargin" title="TopMargin" type="text" maxlength="4" typeof="Number"
                                    value="<%:Model.Popup != null ? Model.Popup.TopMargin == 0 ? "0" : Model.Popup.TopMargin.ToString() : "" %>">
                                    <div class="input-group-append"><span class="input-group-text">px</span></div>
                                </div>
                            </div>
                            <div class="form-group col-12">
                                <% Html.RenderPartial("./Common/Editor"); %>
                            </div>
                            <div class="form-group col-12 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
                                <label for="txtContents" class="form-label">내용</label>
                                <textarea class="form-control" rows="4" id="txtContents" name="Popup.Contents" ><%: Model.Popup != null? Model.Popup.Contents == null ? "" : Model.Popup.Contents.ToString() : ""  %></textarea>
                            </div>
                        </div>
                    </div>
                <div class="card-footer">
                    <div class="text-right">
                        <button type="button" id="btnSave" class="btn btn-primary">저장</button>
                        <button type="button" id="btnCancel" onclick="fnClose()" class="btn btn-secondary">닫기</button>
                    </div>
                </div>
                </div>
            </div>
        </div>
        </div>
        <input type="hidden" id="hdnContents"       name="Popup.Contents"  value ="<%:Model.Popup != null ? Model.Popup.PopupContents : "" %>"/>
        <input type="hidden" id="hdnHtmlContents"   name="Popup.HtmlContents" />
        <input type="hidden" id="hdnRowState"       name="Popup.RowState"    value="<%: Model.Popup != null ? "U" : "C" %>" />
        <input type="hidden" id="hdnPopupNo"        name="Popup.PopupNo"     value="<%:Model.Popup != null ? Model.Popup.PopupNo : 0 %>" />
        <input type="hidden" id="hdnPopupGubun"     name="Popup.PopupGubun"  value="<%: Model.Popup != null ? Model.Popup.PopupGubun : "" %>" />
    </form>
</asp:Content>
