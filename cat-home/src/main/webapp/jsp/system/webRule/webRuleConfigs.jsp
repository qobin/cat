<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="a" uri="/WEB-INF/app.tld"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="res" uri="http://www.unidal.org/webres"%>
<%@ taglib prefix="w" uri="http://www.unidal.org/web/core"%>

<jsp:useBean id="ctx" type="com.dianping.cat.system.page.config.Context" scope="request"/>
<jsp:useBean id="payload" type="com.dianping.cat.system.page.config.Payload" scope="request"/>
<jsp:useBean id="model" type="com.dianping.cat.system.page.config.Model" scope="request"/>

<a:body>
	<res:useJs value="${res.js.local['jquery.validate.min.js']}" target="head-js" />
	<res:useJs value="${res.js.local['alarm_js']}" target="head-js" />
	<res:useJs value="${res.js.local['dependencyConfig_js']}" target="head-js" />
	<res:useCss value="${res.css.local['select2.css']}" target="head-css" />
	<res:useJs value="${res.js.local['select2.min.js']}" target="head-js" />
	<script type="text/javascript">
		$(document).ready(function() {
			$('#webRuleConfigList').addClass('active');
			
			$(".delete").bind("click", function() {
				return confirm("确定要删除此规则吗(不可恢复)？");
			});
			
			$(document).delegate('.update', 'click', function(e){
				var anchor = this,
					el = $(anchor);
				
				if(e.ctrlKey || e.metaKey){
					return true;
				}else{
					e.preventDefault();
				}
				$.ajax({
					type: "post",
					url: anchor.href,
					success : function(response, textStatus) {
						$('#ruleModalBody').html(response);
						$('#ruleModal').modal();
						$("#id").select2();
						metricValidate();
					}
				});
			});
			
			$(document).delegate("#ruleSubmitButton","click",function(){
				$("#modalSubmit").trigger("click");
			})
			
			var state = '${model.opState}';
			if(state=='Success'){
				$('#state').html('操作成功');
			}else{
				$('#state').html('操作失败');
			}
			setInterval(function(){
				$('#state').html('&nbsp;');
			},3000);
		});
	</script>
	<div class="row-fluid">
        <div class="span2">
			<%@include file="../configTree.jsp"%>
		</div>
		<div class="span10">
			<div id="ruleModal" class="modal hide fade" style="width:650px" tabindex="-1" role="dialog" aria-labelledby="ruleLabel" aria-hidden="true">
				<div class="modal-header text-center">
				    <h3 id="ruleLabel">网络规则配置</h3>
				</div>
				<div class="modal-body" id="ruleModalBody">
				</div>
				<div class="modal-footer">
				    <button class="btn btn-primary" id="ruleSubmitButton">提交</button>
				    <button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
				</div>
			</div>
			<h4 id="state" class="text-center text-error">&nbsp;</h4>
			<table class="table table-striped table-bordered table-condensed table-hover">
	     		<tr class="text-success">
	     			<th width="80%"><h5 class='text-center'>规则id</h5></th>
	     			<th width="20%"><h5 class='text-center'>操作</h5></th>
	     		</tr>
		     	<c:forEach var="item" items="${model.ruleItems}" varStatus="status">
	     			<tr>
	     			<td>${item.id}</td>
		     		<td style="text-align:center;white-space: nowrap">
		     			<a href="?op=webRuleUpdate&key=${item.id}" class="btn update btn-primary btn-small">修改规则</a>
			     		<a href="?op=webRulDelete&key=${item.id}" class="btn btn-primary btn-small btn-danger delete">删除</a>
			     	</td>
		     		</tr>
		     	</c:forEach>
	     	</table>
		    <a href="?op=webRuleUpdate&key=${item.id}" class="btn update btn-primary btn-small btn-success">添加监控规则<i class="icon-plus icon-white"></i></a>
		</div>
	</div>
</a:body>