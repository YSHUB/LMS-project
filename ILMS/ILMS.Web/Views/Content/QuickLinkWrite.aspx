<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ContentViewModel>" %>

<asp:Content ID="ContentTitle" ContentPlaceHolderID="Title" runat="server">퀵링크 등록</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form id="mainForm" action="/Content/QuickLinkWrite" method="post" enctype="multipart/form-data">
	<input type="hidden" id="hdnQuickNo" name="QuickLink.QuickNo" value="<%= Model.QuickLink != null ? Model.QuickLink.QuickNo : 0 %>" />
    <div class="p-4">
        <h3 class="title04">퀵링크 등록</h3>
    <div class="card">
        <div class="card-body">
            <div class="form-row">
            <div class="form-group col-12">
                <label for="txtSiteUrl" class="form-label">퀵링크 주소 <span class="text-danger">*</span></label>
                <input class="form-control" name="QuickLink.Url" id="txtUrl" title="Url" type="text" value="<%: Model.QuickLink != null ? Model.QuickLink.Url : ""%>" maxlength="200" >
            </div>
            <div class="form-group col-12">
                <label for="txtSiteName" class="form-label">퀵링크 설명 <span class="text-danger">*</span></label>
                <input class="form-control" name="QuickLink.QuickName" id="QuickName" title="QuickName" type="text" value="<%: Model.QuickLink != null ? Model.QuickLink.QuickName : ""%>" maxlength="200" >
            </div>
			<div class="form-group col-12">
                <label for="bannerImg" class="form-label">이미지 <span class="text-danger">*</span></label>
				<small class="text-muted">
					이미지 사이즈는 <span class="text-danger"> 145px X 40px</span> 으로 등록됩니다.
				</small>
                <% Html.RenderPartial("./Common/File"
				, Model.FileList
				, new ViewDataDictionary {
				{ "name", "FileGroupNo" }, 
				{ "fname", "quicklinkFile" },
				{ "value", 0 },
				{ "fileDirType", "quicklink"},
				{ "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
            </div>
            <div class="form-group col-6 col-md-4">
                 <label for="txtDisplayOrder" class="form-label">정렬순서 <span class="text-danger">*</span></label>
                 <input class="form-control" name="QuickLink.DisplayOrder" id="txtDisplayOrder" title="DisplayOrder" type="text" value="<%: Model.QuickLink != null ? Model.QuickLink.DisplayOrder : 0 %>" maxlength="5" typeof="Number" >
            </div>
            <div class="form-group col-6 col-md-4">
                <label for="chkOutputYesNo" class="form-label">출력여부 <span class="text-danger">*</span></label>
                <label class="switch">
					<input type="checkbox" id="chkOutputYesNo"  name="QuickLink.OutputYesNo"  <%if(Model.QuickLink != null && Model.QuickLink.OutputYesNo == "Y"){ %> checked="checked" <%}else if(Model.QuickLink == null){%>checked="checked"<%}%> value="Y" >
					<span class="slider round"></span>
				</label>
            </div>
        </div>
        </div>
        <div class="card-footer">
            <div class="row">
                <div class="col">
                    
                </div>
                <div class="col-auto">
                    <button type="button" id="btnSave" class="btn <%= Model.QuickLink != null ? "btn-warning" : "btn-primary" %>"><%= Model.QuickLink != null ? "수정" : "등록" %></button>
                    <button type="button" id="btnCancel" onclick="window.close()" class="btn btn-secondary">닫기</button>
                </div>
            </div>
        </div>
    </div>
    </div>
	<input type="hidden" id="hdnRowState" name="QuickLink.RowState"  value="<%: Model.QuickLink != null ? "U" : "C" %>" />
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script>
        $(document).ready(function () {
			
            $("#btnSave").click(function () {
                if ($("input[name='QuickLink.Url']").val() == "") {
					bootAlert("퀵링크 주소를 입력하세요.", function () {
						$("input[name='QuickLink.Url']").focus();
					});
                    return false;
                }

                if ($("input[name='QuickLink.QuickName'").val() == "") {
					bootAlert("퀵링크 설명을 입력하세요.", function () {
						$("input[name='QuickLink.QuickName'").focus();
					});
                    return false;
                }

                if ($("input[name='QuickLink.DisplayOrder'").val() == "") {
					bootAlert("정렬순서를 입력하세요.", function () {
						$("input[name='QuickLink.DisplayOrder'").focus();
					});
                    return false;
				}

				if ($("input[name='quicklinkFile'").val() == "") {
                    bootAlert("이미지를 선택하세요.");
                    return false;
				}

				if ($("#txtDisplayOrder").val() == 0) {
					bootAlert("정렬순서를 입력하세요.", function () {
						$("#txtDisplayOrder").focus();
					});
					return false;
				}
                document.forms["mainForm"].submit();
            });

        });


        function selectImageFile() {
            var x = new Date();
            window.open("/Scripts/SE2.8.2/imageUpload.html?" + x.getTime(), "selectimage", "width=400 height=300");
        }


        function pushImage(fileNames, fileNewNames, fileSizes, fileTypes) {

            for (var i = 0; i < fileNames.length; i++) {
                pasteHTML("<img alt='' class='userInputImage' style='max-width:400px;' src='" + fileNewNames[i] + "'/>");
            }
        }

    </script>
</asp:Content>
