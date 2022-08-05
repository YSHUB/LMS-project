<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ContentViewModel>" %>

<asp:Content ID="ContentTitle" ContentPlaceHolderID="Title" runat="server">배너등록</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentBlock" runat="server">
<form action="/Content/BannerWrite" id="mainForm" method="post"  enctype="multipart/form-data">
    <input type="hidden" id="hdnBannerNo" name="banner.BannerNo" value="<%= Model.Banner != null ? Model.Banner.BannerNo : 0 %>" />
    <div class="p-4">
        <h3 class="title04">배너등록</h3>
        <div class="card">
            <div class="card-body">
                <div class="form-row">
                    <div class="form-group col-12">
                        <label for="txtBannerExplain" class="form-label">배너설명 <span class="text-danger">*</span></label>
                        <input class="form-control" name="banner.BannerExplain" id="txtBannerExplain" title="BannerExplain" type="text" value="<%:Model.Banner != null ?  Model.Banner.BannerExplain : "" %>" maxlength="200" >
                    </div>
                    <div class="form-group col-12">
                        <label for="bannerImg" class="form-label">이미지 <span class="text-danger">*</span></label>
                        <small class="text-muted">
                            이미지 사이즈는 반드시<span class="text-danger"> 980px X 360px</span> 으로 등록하세요.
                        </small>
                            <% Html.RenderPartial("./Common/File"
                            , Model.FileList
                            , new ViewDataDictionary {
                            { "name", "FileGroupNo" },
                            { "fname", "BannerFile" },
                            { "value", 0 },
                            { "fileDirType", "Banner"},
                            { "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
                    </div>
                    <div class="form-group col-12 col-md-4">
                        <label for="txtStartDay" class="form-label">출력시작일자 <span class="text-danger">*</span></label>
                        <input type="text" id="txtStartDay" name="Banner.StartDay" class="datepicker form-control text-center" title="출력시작일자" autocomplete="off" />
                    </div>
                    <div class="form-group col-12 col-md-4">
                        <label for="txtEndDay" class="form-label">출력종료일자 <span class="text-danger">*</span></label>
                        <input type="text" id="txtEndDay" name="Banner.EndDay" class="datepicker form-control text-center" title="출력종료일자"  autocomplete="off" />
                    </div>
                    <div class="form-group col-12 col-md-4">
                        <label for="txtSortNo" class="form-label">정렬순서 <span class="text-danger">*</span></label>
                            <input class="form-control" name="Banner.SortNo" id="txtSortNo" title="SortNo" type="text" value="<%:Model.Banner != null ?  Model.Banner.SortNo : 0 %>" maxlength="4" typeof="Number" >
                    </div>
                    <div class="form-group col-12 col-md-4">
					    <label for="ddlLinkType" class="form-label">연결방식 <strong class="text-danger">*</strong></label>
					    <select class="form-control" id="ddlLinkType" name="Banner.LinkType">
						    <option <%= Model.Banner !=  null ? Model.Banner.LinkType.Equals("") ? "selected='selected'" : "" : ""%>  value="No" >연결안함</option>
                            <option <%= Model.Banner !=  null ? Model.Banner.LinkType.Equals("_self") ? "selected='selected'" : "" : ""%>  value="_self">현재페이지</option>
						    <option <%= Model.Banner !=  null ? Model.Banner.LinkType.Equals("_blank") ? "selected='selected'" : "" : ""%> value="_blank">새페이지</option>
					    </select>
                    </div>
                    <div class="form-group col-12 col-md-8">
                        <label for="txtLinkUrl" class="form-label">연결링크URL</label>
                            <input class="form-control" name="Banner.LinkUrl" id="txtLinkUrl" title="LinkUrl" type="text" value="<%:Model.Banner != null ?  Model.Banner.LinkUrl : "" %>" maxlength="500" >
                    </div>
                    <div class="form-group col-6 col-md-4">
                        <label for="Banner.BannerType" class="form-label">배너위치</label>
                        <select class="form-control" name="Banner.BannerType" id="Banner.BannerType">
                            <option <%=Model.Banner !=  null ? Model.Banner.BannerType == 0 ? "selected='selected'" : "" : ""%>  value="0">Main</option>
                            <option <%=Model.Banner !=  null ? Model.Banner.BannerType == 1 ? "selected='selected'" : "" : ""%>  value="1">Side - 상단배너</option>
                            <option <%=Model.Banner !=  null ? Model.Banner.BannerType == 2 ? "selected='selected'" : "" : ""%>  value="2">Side - 하단배너</option>
                        </select>
                    </div>
                    <div class="form-group col-6 col-md-4">
                        <label class="form-label" for="chkOutputYesNo">출력여부<span class="text-danger">*</span></label>
                        <label class="switch">
                            <input type="checkbox" id="chkOutputYesNo" name="Banner.OutputYesNo" <%if (Model.Banner != null && Model.Banner.OutputYesNo == "Y")
                                { %> checked="checked" <%} %> value="Y">
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <div class="row">
                    <div class="col-12 col-sm-9">
                    </div>
                    <div class="col-12 col-sm-3 text-right">
                        <button type="button" id="btnSave"  class="btn btn-primary"  >등록</button>
                        <button type="button" id="btnCancel" onclick="window.close()" class="btn btn-secondary">닫기</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="hdnRowState"   name="Banner.RowState" value="<%: Model.Banner != null ? "U" : "C" %>" />
</form>
</asp:Content>



<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<script type="text/javascript">
    var _ajax = new AjaxHelper();

    fnFromToCalendar("txtStartDay", "txtEndDay", $("#txtStartDay").val());

    $(document).ready(function () {

        $(":radio[name='banner.OutputYesNo']").filter("input[value='" + $("#hdnOutputYesNo").val() + "']").attr("checked", "checked");
        $(":radio[name='banner.BannerType']").filter("input[value='" + $("#hdnBannerType").val() + "']").attr("checked", "checked");
        $("#txtStartDay").val("<%: Model.Banner != null ? Model.Banner.StartDay : "" %>")
        $("#txtEndDay").val("<%: Model.Banner != null ? Model.Banner.EndDay : "" %>")


        //저장
        $("#btnSave").click(function () {
            if ($("#txtBannerExplain").val() == "") {
                bootAlert("배너설명를 입력하세요.", 1);
                return false;
            }

            var stDateArr = $("input[name='Banner.StartDay']");
            var endDateArr = $("input[name='Banner.EndDay']");

            if ($(stDateArr).val() == "" || $(endDateArr).val() == "") {
                bootAlert("노출기간은 필수 입력 입니다.", 1);
                return false;
            }

            if ($(stDateArr).val() > $(endDateArr).val()) {
                bootAlert("종료일은 시작일 이후 날짜로 설정해 주세요.", 1);
                return false;
            }

            $("#mainForm").submit();
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