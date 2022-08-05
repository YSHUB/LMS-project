<%@ Page Language="C#" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.IO" %>
<%@ import Namespace="System.Configuration" %>

<script runat="server">
void Page_Load(Object sender, EventArgs e)
{
    if (Request.ContentType.IndexOf("multipart/form-data") < 0) {
        return;
	}

	Response.ContentType = "application/json";

    foreach (String f in Request.Files.AllKeys) {
        HttpPostedFile file = Request.Files[f];

        String FileName = Path.GetFileName(file.FileName);
        String FilePath = ConfigurationSettings.AppSettings["SAVE_PATH"] + FileName;
		String FileUrl = ConfigurationSettings.AppSettings["SAVE_URL"] + FileName;

		String outputJson = String.Format("\"fileUrl\":\"{0}\",\n\"fileName\":\"{1}\",\n\"fileSize\":{2}",
			FileUrl, FileName, file.ContentLength);

        try {
        	file.SaveAs(FilePath);
       	 	Response.Write("{\n"+outputJson+"\n}");
		} catch (IOException ignore) {}
    }
}
</script>