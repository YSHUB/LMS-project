<%@ Page Language="C#" MasterPageFile="~/Views/Shared/sub.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="roadmap">
	<div class="roadmap-01">
	<h3 class="title04">사업구성</h3>
	<div class="mt-3 table-bordered">
	<table class="table table-line text-center">
	<colgroup>
	<col style="width: 10%;">
	<col>
	</colgroup>
	<thead>
	<tr>
	<th scope="col">대상</th>
	<th scope="col">교육구성</th>
	</tr>
	</thead>
	<tbody>
	<tr>
	<th scope="row" rowspan="2">공급 기업</th>
	<td>
	<div class="row row-1">
	<div class="col-lg-4">
	<dl class="focus">
	<dt>마이스터 데이터 취득, 데이터 분석<sup>1)</sup></dt>
	<dd>데이터 취득 및 추출, 분석 등 기반기술 교육</dd>
	</dl>
	</div>
	<div class="col-lg-4">
	<dl>
	<dt>마이스터 로봇화 실무<sup>2)</sup></dt>
	<dd>기반기술+공정시스템 적용 실무</dd>
	</dl>
	</div>
	<div class="col-lg-4">
	<dl>
	<dt>(특별)마이스터 로봇화 공동 프로젝트형 실습</dt>
	<dd>
	마이스터 로봇화 공정실습 팀프로젝트
	<small>* 공정기획부터 로봇화까지 주도적으로 참여하는 문제해결형 교육</small>
	</dd>
	</dl>
	</div>
	</div>

	</td>
	</tr>
	<tr>
	<td>
	마이스터 로봇화를 위한 로봇AI를 구성할 수 있는 ‘마이스터 로봇화 SI기업’, ‘마이스터 로봇화 빅데이터 기업’
	</td>
	</tr>
	<tr>
	<th scope="row" rowspan="2">활용 기업</th>
	<td>
	<div class="row row-2">
	<div class="col-lg-8">
	<dl class="focus">
	<dt>마이스터 로봇화 기본<sup>1)</sup></dt>
	<dd>- 마이스터 로봇화 이해를 위한 기본소양 (빅데이터 기반기술, 로봇화 등 이해)</dd>
	</dl>
	</div>
	<div class="col-lg-4">
	<dl>
	<dt>로봇활용</dt>
	<dd>- 로봇 및 주변장비 운용 실습<br>- 마이스터 로봇화 공정 운영실습</dd>
	</dl>
	</div>
                        
	</div>
	</td>
	</tr>
	<tr>
	<td>
	마이스터 로봇화를 통해 확보된 로봇AI를 통해 제조업 현장에서 제품을 생산하는 ‘마이스터 로봇화 활용기업’
	</td>
	</tr>
	</tbody>
	</table>
	</div>

	<div class="mt-3">
	<p class="mb-1"><sup>1)</sup> 2022년도 진행 교육과정</p>
	<p><sup>2)</sup> 마이스터 로봇화 실무 과정은 금속가공/전자제품/자동차부품 분야별 특화 교육과정으로 2023~2025년도에 걸쳐 테스트베드 기반 교육과정으로 진행 예정</p>
	</div>

	</div>

	</div>
</asp:Content>
