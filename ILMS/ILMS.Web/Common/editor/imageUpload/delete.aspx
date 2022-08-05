<%@ Page Language="C#" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.IO" %>

<script runat="server">
void Page_Load(Object sender, EventArgs e)
{
	string deleteFile = Request.Form["filepath"];
	if (!string.IsNullOrEmpty(deleteFile) && File.Exists(deleteFile))
	{
		try {
			File.Delete(deleteFile);

			string fileName = Path.GetFileName(deleteFile);
			string savePath = Path.GetDirectoryName(deleteFile);
			string thumbName = savePath + "\\thumb_" + fileName;

			if (File.Exists(thumbName))
			{
				File.Delete(thumbName);
			}	
		}
		catch (IOException ignore) {}
	}
}
</script>