<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<script type="text/javascript" src="/Common/editor/cheditor.js?22=22"></script>
<textarea id="editorContentValue" class="i_text" title="" rows="15" style="width: 95%;"><%: ViewData["Contents"] %></textarea>
<asp:RequiredFieldValidator runat="server" ID="rfv유효성" ControlToValidate="editorContentValue" ValidationGroup="저장" SetFocusOnError="true" Display="Dynamic" Visible="false">
    <div class="alert alert-danger m-t-xs m-b-none p-xs">
        <span class="glyphicon glyphicon-remove"></span>&nbsp;<asp:Literal runat="server" ID="ltrl필수항목명" />은(는) 필수항목 입니다.
    </div>
</asp:RequiredFieldValidator>
<script type="text/javascript">
    var myeditor = new cheditor();

    myeditor.config.editorHeight = '300px';
    myeditor.config.editorWidth = '100%';
    myeditor.config.editorPath = '/Common/editor/';
	myeditor.inputForm = 'editorContentValue';
    myeditor.config.outputXhtml = false;
    myeditor.run();
			
</script>