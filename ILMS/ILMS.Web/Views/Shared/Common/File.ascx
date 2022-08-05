<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl" %>
<%
    var md = (List<ILMS.Design.Domain.File>)(Model ?? new List<ILMS.Design.Domain.File>());
    var _id = ViewData["id"] ?? "files";
    var _name = ViewData["name"];
    var _fname = ViewData["fname"];
    var _isImage = ViewData["isimage"] ?? "0";
    var _imagepid = ViewData["imageid"] ?? "";
    var _value = ViewData["value"] ?? 0;
    var _width = ViewData["width"] ?? "65%";
    var _fileDirType = ViewData["fileDirType"] ?? "";
    var _filecount = (int)(ViewData["filecount"] ?? 1); //0=무제한
    var _readmode = (int)(ViewData["readmode"] ?? 0);
    var _hidemode = (int)(ViewData["hidemode"] ?? 0);
    var _hidden = (md.Count() > 0 && _filecount == 1) || _readmode == 1 ? "display: none" : "";
    var _dftsrc = ViewData["dftsrc"] ?? "";
    var _fileext = ViewData["fileext"] ?? "*";
    var _hasPreview = ViewData["hasPreview"] ?? "N";
    var _preview = ViewData["preview"] ?? "";
    var _AceeptFileExt = ViewData["_AceeptFileExt"] ?? "";

    var _FileCustomizeYN = (string)ViewData["FileCustomizeYN"] ?? "N"; // file객체 커스터마이징 여부
    var _FileCustomizeTag = (string)ViewData["FileCustomizeTag"] ?? "";
    //var _param = ViewData["param"] as Hashtable ?? new Hashtable();
    var _reloadYN = ViewData["reloadYN"] ?? "N";


    //var _ExtraBtnUse = ViewData["extraBtnUse"]?? "N";
    //var _ExtraBtnView = ViewData["extraBtnView"]?? "";
%>
<div class="fgbox" data-dirtype="<%=_fileDirType %>" data-filecount="<%=_filecount %>" data-isimage="<%=_isImage %>" data-width="<%= _width %>" data-fname="<%= _fname%>" data-imageid="<%=_imagepid %>" data-hidemode="<%=_hidemode %>" data-dftsrc="<%: _dftsrc %>" data-ext="<%: _fileext %>">
    <input type="hidden" class="fgno" name="<%= _name %>" value="<%= _value %>" />
    <div class="filelist">
<%
    foreach (var f in md)
    {
%>
        <div class="fileitembox text-left" id="files<%:_fname%>">
            

<%
	if (_hasPreview == "Y" && _preview != "")
	{
%>
<%=_preview%>
<%
	}
%>
            <a href="/Common/FileDownLoad/<%:f.FileNo %>" title="다운로드"><span class="fileitem"><%= f.OriginFileName %></span></a>&nbsp;&nbsp;
<% 
        if (_readmode == 0)
        {
%>
            <button type="button" class="btn btn-sm btn-danger" onclick="fnFileDeleteNew(<%= f.FileNo %>, this, '<%=_reloadYN %>');" title="삭제">삭제</button>
<%
        }
%>
        </div>
<%
    }
%>
    </div>
<% 
    if (_hidemode == 1 || _filecount == 0 || _filecount > md.Count())
    { 
%>
        <%--<div class="input-group">
		    <input title="첨부파일" id="<%:_id%>" type="file" name="<%=_fname %>" data-empty="1">
		</div>--%>

    <div class="input-group">
        <input title="첨부파일" class="<%:_FileCustomizeYN == "Y" ? "d-none" : ""%>" id="<%:_id%>" type="file" name="<%=_fname %>" data-empty="1" onchange="<%:_FileCustomizeYN == "Y" ? "fnFileUploaderChange(this,\'"+_id+"\');" : ""%>"  >
    </div>


    <%
        if (_FileCustomizeYN == "Y")
        {
    %>

        <button class="btn btn-primary" type="button" onclick="$('#<%:_id%>').trigger('click');" id="btnFileCustom">
    <%      if (!string.IsNullOrEmpty(_FileCustomizeTag))
            {
    %>

            <%: Html.Raw(_FileCustomizeTag)  %>

    <%
            }
            else
            {
    %>
                파일 선택
    <%
            }
        
    %>

        </button>    
        <div id="div_<%:_id%>"></div>

    <%
        }
    %>

<% 
    }
%>
</div>
