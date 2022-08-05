<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ImportViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	
	<!-- 탭버튼 -->
    <ul class="nav nav-tabs">
        <li class="nav-item"><a class="nav-link" href="ImportAssign">소속정보</a> </li>
        <li class="nav-item"><a class="nav-link active show" href="ImportMember">회원정보</a> </li>
        <li class="nav-item"><a class="nav-link" href="ImportSubject"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>정보</a> </li>
        <li class="nav-item"><a class="nav-link" href="ImportCourse">분반정보</a> </li>
        <li class="nav-item"><a class="nav-link" href="ImportLecture">수강정보</a></li>
        <li class="nav-item"><a class="nav-link" href="ImportLogList">연동로그</a> </li>
    </ul>
    <!-- 탭버튼 -->
    <div class="row">
        <div class="col-lg-12">
            <div class="alert alert-light bg-light mt-3">
                <div class="font-size-14">
                    ※ 학사연동을 처음 하시는 경우, 반드시 <span class="text-danger">소속정보 &gt; 회원정보 &gt; <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>정보 &gt; 분반정보 &gt; 수강정보</span>
                    순서대로 연동해 주세요.
                </div>
                <div class="font-size-14">
                    ※ 업데이트 대상 데이터만 조회합니다.
                </div>
			</div>
            <div class="card mb-3">
                <div class="card-header">
                    <h3 class="card-header-title">회원정보 연동</h3>
                </div>
                <div class="card-body">
                    <div class="form-row">
                        <div class="col-8">
                            <div class="form-group col-md-4">
								<label for="">회원구분 : </label>
								<select id="tno" class="form-control">
									<option value="USRT001"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %></option>
									<option value="USRT000"><%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></option>
								</select>
							</div>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-6">
                        </div>
                        <div class="col-6 text-right">
                            <button type="button" class="btn btn-primary">회원정보 확인</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 연동할 데이터가 없습니다.</div>
            <div class="card">
                <div class="card-header">
                    <div class="row">
                        <div class="col">
						    전체 <strong class="text-primary">13,000건</strong> 중 100건의 결과값입니다. 연동을 하시려면 <strong class="text-primary">[업데이트]</strong>를 클릭하세요.
					    </div>
					    <div class="col-auto text-right">
						    <input type="button" class="btn btn-outline-primary" value="업데이트" />
					    </div>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>
                        <strong class="text-danger">미등록된 대학정보</strong>가 있습니다. 대학정보를 먼저 등록하여 주시기 바랍니다.
                    </div>
                </div>

                <div class="card-body p-0">
                    <table class="table table-bordered table-hover" summary="<%:ConfigurationManager.AppSettings["EmpIDText"].ToString() %> 리스트">
                        <thead>
                            <tr>
							    <th scope="col" rowspan="2">No</th>
							    <th colspan="3">LMS</th>
							    <th colspan="3">학사</th>
						    </tr>
						    <tr>
							    <th scope="col"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
                                <th scope="col">이름</th>
                                <th scope="col">소속</th>
                                <th scope="col"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
                                <th scope="col">이름</th>
                                <th scope="col">소속</th>
						    </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>20171175</td>
                                <td>김서</td>
                                <td>회계학과</td>
                                <td>22798</td>
                                <td>박기*</td>
                                <td>회계학과</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>20171175</td>
                                <td>김서</td>
                                <td>회계학과</td>
                                <td>22798</td>
                                <td>박기*</td>
                                <td>회계학과</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
</asp:Content>