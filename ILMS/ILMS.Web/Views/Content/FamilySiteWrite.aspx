<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ContentViewModel>" %>

<asp:Content ID="ContentTitle" ContentPlaceHolderID="Title" runat="server">관련사이트 등록</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form id="mainForm" action="/Content/FamilySiteWrite" method="post" enctype="multipart/form-data">
    <input type="hidden" id="hdnSiteNo" name="FamilySite.SiteNo" value="<%= Model.FamilySite != null ? Model.FamilySite.SiteNo : 0 %>" />
    <div class="p-4">
        <h3 class="title04">관련사이트 등록</h3>
    <div class="card">
        <div class="card-body">
            <div class="form-row">
            <div class="form-group col-12">
                <label for="txtSiteUrl" class="form-label">관련사이트 주소 <span class="text-danger">*</span></label>
                <input class="form-control" name="FamilySite.SiteUrl" id="txtSiteUrl" title="SiteUrl" type="text" value="<%: Model.FamilySite != null ? Model.FamilySite.SiteUrl : ""%>" maxlength="200" >
            </div>
            <div class="form-group col-12">
                <label for="txtSiteName" class="form-label">관련사이트 설명 <span class="text-danger">*</span></label>
                <input class="form-control" name="FamilySite.SiteName" id="txtSiteName" title="SiteUrl" type="text" value="<%: Model.FamilySite != null ? Model.FamilySite.SiteName : ""%>" maxlength="200" >
            </div>
            <div class="form-group col-6 col-md-4">
                 <label for="txtDisplayOrder" class="form-label">정렬순서 <span class="text-danger">*</span></label>
                 <input class="form-control" name="FamilySite.DisplayOrder" id="txtDisplayOrder" title="SiteUrl" type="text" value="<%: Model.FamilySite != null ? Model.FamilySite.DisplayOrder : 0 %>" maxlength="5" typeof="Number" >
            </div>
            <div class="form-group col-6 col-md-4">
                <label for="chkOutputYesNo" class="form-label">출력여부 <span class="text-danger">*</span></label>
                <label class="switch">
					<input type="checkbox" id="chkOutputYesNo"  name="FamilySite.OutputYesNo"  <%if(Model.FamilySite != null && Model.FamilySite.OutputYesNo == "Y"){ %> checked="checked" <%} %> value="Y" >
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
                    <button type="button" id="btnSave" class="btn <%= Model.FamilySite != null ? "btn-warning" : "btn-primary" %>"><%= Model.FamilySite != null ? "수정" : "등록" %></button>
                    <button type="button" id="btnCancel" onclick="window.close()" class="btn btn-secondary">닫기</button>
                </div>
            </div>
        </div>
    </div>
    </div>
   <input type="hidden" id="hdnRowState" name="FamilySite.RowState"  value="<%: Model.FamilySite != null ? "U" : "C" %>" />
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script>
        $(document).ready(function () {

            $(":radio[name='FamilySite.OutputYesNo']").filter("input[value='" + $("#hdnOutputYesNo").val() + "']").attr("checked", "checked");

            $("#btnSave").click(function () {
                if ($("input[name='FamilySite.SiteUrl']").val() == "") {
                    bootAlert("관련사이트 주소를 입력하세요.");
                    return false;
                }

                if ($("input[name='FamilySite.SiteName'").val() == "") {
                    bootAlert("사이트 설명을 입력하세요.");
                    return false;
                }

                if ($("input[name='FamilySite.DisplayOrder'").val() == "") {
                    bootAlert("정렬순서를 입력하세요.");
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
