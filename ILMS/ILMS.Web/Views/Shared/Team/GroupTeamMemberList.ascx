<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div class="modal fade show" id="divGroupTeamMember" tabindex="-1" aria-labelledby="divGroup" aria-modal="true" role="dialog">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title h4" id="divGroup">조별 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 내역</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">						
				<div class="row">
					<div class="col-12 col-md-6">
						<h5 class="title04">그룹 [<span class="text-primary"><label id="lblGroupName"></label></span>] 팀리스트</h5>
						<div class="card">
							<div class="card-body py-0">
								<table class="table table-hover" summary="팀리스트">
									<caption>팀리스트</caption>
									<thead>
										<tr>
											<th>팀명</th>
											<th>팀인원</th>
											<th>팀원 보기</th>
										</tr>
									</thead>
									<tbody id="tdbTeamList">
										<tr>
											<td colspan="3">등록된 팀이 없습니다.</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="col-12 col-md-6">
						<h5 class="title04"><span class="text-primary"><label id="lblTeamName"></label></span> 팀원 리스트</h5>
						<div class="card">
							<div class="card-body py-0">
								<table class="table table-hover" summary="팀원리스트">
									<caption>팀원 리스트</caption>
									<thead>
										<tr>
											<th>성별</th>
											<th>성명</th>
											<th><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
											<th>팀장</th>
										</tr>
									</thead>
									<tbody id="tdbTeamMemberList">
										<tr>
											<td colspan="4">등록된 팀원이 없습니다.</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="text-right">
					<button type="button" class="btn btn-secondary" data-dismiss="modal" title="닫기">닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>