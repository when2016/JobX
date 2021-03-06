<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="cron"  uri="http://www.jobx.org"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <style type="text/css">
        .subJobUl li{
            background-color: rgba(0,0,0,0.3);
            border-radius: 1px;
            height: 26px;
            list-style: outside none none;
            margin-top: -27px;
            margin-bottom: 29px;
            margin-left: 100px;
            padding: 4px 15px;
            width: 350px;
        }
        .subjob_del{
            float:right;margin-right:2px
        }
    </style>

    <script type="text/javascript" src="${contextPath}/static/js/job.validata.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            window.jobxValidata = new Validata('${contextPath}','${job.jobId}');
        });
    </script>

</head>

<body>

<!-- Content -->
<section id="content" class="container">

    <!-- Messages Drawer -->
    <jsp:include page="/WEB-INF/layouts/message.jsp"/>

    <!-- Breadcrumb -->
    <ol class="breadcrumb hidden-xs">
        <li class="icon">&#61753;</li>
        当前位置：
        <li><a href="">JobX</a></li>
        <li><a href="">作业管理</a></li>
    </ol>
    <h4 class="page-title">
        <i class="fa fa-edit" aria-hidden="true"></i>
        编辑作业
    </h4>

    <div style="float: right;margin-top: 5px">
        <a onclick="goback();" class="btn btn-sm m-t-10" style="margin-right: 16px;margin-bottom: -4px"><i class="fa fa-mail-reply" aria-hidden="true"></i>&nbsp;返回</a>
    </div>

    <div class="block-area" id="basic">
        <div class="tile p-15">
            <form class="form-horizontal" role="form" id="jobform" action="${contextPath}/job/save.do" method="post"><br>

                <input type="hidden" id="jobId" name="jobId" value="${job.jobId}">
                <input type="hidden" name="command" id="command">
                <input type="hidden" name="userId" value="${job.userId}">
                <input type="hidden" id="agentId" name="agentId" class="input-self" value="${job.agentId}">

                <div class="form-group">
                    <label for="jobName" class="col-lab control-label wid150"><i class="glyphicon glyphicon-tasks"></i>&nbsp;&nbsp;作业名称&nbsp;&nbsp;<b>*&nbsp;</b></label>
                    <div class="col-md-10">
                        <input type="text" class="form-control input-sm" id="jobName" name="jobName" value="${job.jobName}">
                        <span class="tips" tip="必填项,该作业的名称">必填项,该作业的名称</span>
                    </div>
                </div><br>

                <div class="form-group">
                    <label for="agentId" class="col-lab control-label wid150"><i class="glyphicon glyphicon-leaf"></i>&nbsp;&nbsp;执&nbsp;&nbsp;行&nbsp;&nbsp;器&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                    <div class="col-md-10">
                        <input type="text" class="form-control input-sm" value="${job.agentName}&nbsp;&nbsp;&nbsp;${job.host}" readonly>
                        <font color="red">&nbsp;*只读</font>
                        <span class="tips">&nbsp;&nbsp;要执行此作业的机器名称和Host</span>
                    </div>
                </div><br>

                <div class="form-group">
                    <label for="cmd" class="col-lab control-label wid150"><i class="glyphicon glyphicon-th-large"></i>&nbsp;&nbsp;执行命令&nbsp;&nbsp;<b>*&nbsp;</b></label>
                    <div class="col-md-10">
                        <textarea class="form-control input-sm" id="cmd" style="height:200px;resize:vertical">${job.command}</textarea>
                        <span class="tips" tip="请采用unix/linux的shell支持的命令">请采用unix/linux的shell支持的命令</span>
                    </div>
                </div>
                <br>

                <div class="form-group">
                    <label for="successExit" class="col-lab control-label wid150"><i class="glyphicons glyphicons-tags"></i>&nbsp;&nbsp;成功标识&nbsp;&nbsp;<b>*&nbsp;</b></label>
                    <div class="col-md-10">
                        <input type="text" class="form-control input-sm" id="successExit" name="successExit" value="${job.successExit}">
                        <span class="tips" tip="自定义作业执行成功的返回标识(默认执行成功是0)">自定义作业执行成功的返回标识(默认执行成功是0)</span>
                    </div>
                </div>
                <br>

                <div class="form-group">
                    <label class="col-lab control-label wid150"><i class="glyphicon  glyphicon glyphicon-forward"></i>&nbsp;&nbsp;失败重跑&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                    <div class="col-md-10">
                        <label for="redo01" class="radio-label"><input type="radio" name="redo" value="1" id="redo01" ${job.redo eq 1 ? 'checked' : ''}>是&nbsp;&nbsp;&nbsp;</label>
                        <label for="redo00" class="radio-label"><input type="radio" name="redo" value="0" id="redo00" ${job.redo eq 0 ? 'checked' : ''}>否</label>&nbsp;&nbsp;&nbsp;
                        <br><span class="tips">执行失败时是否自动重新执行</span>
                    </div>
                </div>
                <br>

                <div class="form-group countDiv" style="display: ${job.redo eq 1 ? 'block' : 'none'}">
                    <label for="runCount" class="col-lab control-label wid150"><i class="glyphicon glyphicon-repeat"></i>&nbsp;&nbsp;重跑次数&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                    <div class="col-md-10">
                        <input type="text" class="form-control input-sm" id="runCount" name="runCount" value="${job.runCount}">
                        <span class="tips" tip="执行失败时自动重新执行的截止次数">执行失败时自动重新执行的截止次数</span>
                    </div>
                </div>
                <br>

                <div class="form-group">
                    <label for="timeout" class="col-lab control-label wid150"><i class="glyphicon glyphicon-ban-circle"></i>&nbsp;&nbsp;超时时间&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                    <div class="col-md-10">
                        <input type="text" class="form-control input-sm" id="timeout" name="timeout" value="${job.timeout}">
                        <span class="tips" tip="执行作业允许的最大时间,超过则为超时(0:忽略超时时间,分钟为单位)">执行作业允许的最大时间,超过则为超时(0:忽略超时时间,分钟为单位)</span>
                    </div>
                </div>
                <br>

                <div class="form-group">
                    <label class="col-lab control-label wid150"><i class="glyphicon  glyphicon-random"></i>&nbsp;&nbsp;作业类型&nbsp;&nbsp;<b>*&nbsp;</b></label>
                    <div class="col-md-10">
                        <label for="jobType0" class="radio-label"><input type="radio" name="jobType" value="0" id="jobType0" ${job.jobType eq 0 ? 'checked' : ''}>单一作业&nbsp;&nbsp;&nbsp;</label>
                        <label for="jobType1" class="radio-label"><input type="radio" name="jobType" value="1" id="jobType1" ${job.jobType eq 1 ? 'checked' : ''}>流程作业</label>&nbsp;&nbsp;&nbsp;
                        <br><span class="tips" id="jobTypeTip">单一作业: 当前定义作业为要执行的目标&nbsp;流程作业: 有多个作业组成作业组</span>
                    </div>
                </div>
                <br>

                <div class="form-group" id="subJob">
                    <span>
                        <label class="col-lab control-label wid150"><i class="glyphicon glyphicon-tag"></i>&nbsp;&nbsp;子&nbsp;&nbsp;作&nbsp;&nbsp;&nbsp;业&nbsp;&nbsp;&nbsp;&nbsp;</label>
                        <div class="col-md-10">
                            <a data-toggle="modal" href="#jobModal" onclick="jobxValidata.subJob.add()" class="btn btn-sm m-t-10">添加子作业</a>
                            <ul id="subJobDiv" class="subJobUl">
                            <c:forEach var="c" items="${job.children}">
                                <li id="${c.jobId}" >
                                    <span  onclick="jobxValidata.subJob.edit('${c.jobId}')">
                                        <a data-toggle="modal" href="#jobModal" title="编辑"><i class="glyphicon glyphicon-pencil"></i>&nbsp;&nbsp;<span id="name_${c.jobId}">${c.jobName}</span></a>
                                    </span>
                                    <span class='subjob_del' onclick='jobxValidata.subJob.remove(this)'>
                                        <a href='javascript:void(0)' title='删除'><i class='glyphicon glyphicon-trash'></i></a>
                                    </span>
                                    <input type="hidden" name="child.jobId" value="${c.jobId}">
                                    <input type="hidden" name="child.jobName" value="${c.jobName}">
                                    <input type="hidden" name="child.agentId" value="${c.agentId}">
                                    <input type="hidden" name="child.redo" value="${c.redo}">
                                    <input type="hidden" name="child.runCount" value="${c.runCount}">
                                    <input type="hidden" name="child.command" value="${cron:toBase64(c.command)}">
                                    <input type="hidden" name="child.timeout" value="${c.timeout}">
                                    <input type="hidden" name="child.successExit" value="${c.successExit}">
                                    <input type="hidden" name="child.comment" value="${c.comment}">
                                </li>
                            </c:forEach>
                        </div>
                    </span>
                </div><br>

                <div class="form-group" id="runModel" style="display:none">
                    <label class="col-lab control-label wid150"><i class="glyphicon  glyphicon-sort-by-attributes"></i>&nbsp;&nbsp;运行顺序&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                    <div class="col-md-10">
                        <label for="runModel0" class="radio-label"><input type="radio" name="runModel" value="0" id="runModel0" ${job.runModel eq 0 ? 'checked' : ''}>串行&nbsp;&nbsp;&nbsp;</label>
                        <label for="runModel1" class="radio-label"><input type="radio" name="runModel" value="1" id="runModel1" ${job.runModel eq 1 ? 'checked' : ''}>并行</label>&nbsp;&nbsp;&nbsp;
                        <br><span class="tips" id="runModelTip">串行: 流程任务里的每个任务按照定义的顺序依次执行</span>
                    </div>
                </div>
                <br>

                <div class="form-group">
                    <label class="col-lab control-label wid150"><i class="glyphicon glyphicon-warning-sign"></i>&nbsp;&nbsp;失败报警&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                    <div class="col-md-10">
                        <label for="warning1" class="radio-label"><input type="radio" name="warning" value="1" id="warning1" ${job.warning eq true ? 'checked' : ''}>是&nbsp;&nbsp;&nbsp;</label>
                        <label for="warning0" class="radio-label"><input type="radio" name="warning" value="0" id="warning0" ${job.warning eq false ? 'checked' : ''}>否</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </br><span class="tips" tip="任务执行失败时是否发信息报警">任务执行失败时是否发信息报警</span>
                    </div>
                </div>
                <br>

                <div class="form-group contact">
                    <label for="mobile" class="col-lab control-label wid150"><i class="glyphicon glyphicon-comment"></i>&nbsp;&nbsp;报警手机&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                    <div class="col-md-10">
                        <input type="text" class="form-control input-sm" id="mobile" name="mobile" value="${job.mobile}">
                        <span class="tips" tip="任务执行失败时将发送短信给此手机,多个请以逗号(英文)隔开">任务执行失败时将发送短信给此手机,多个请以逗号(英文)隔开</span>
                    </div>
                </div>
                <br>

                <div class="form-group contact" style="display: ${job.warning eq true ? 'block' : 'none'}">
                    <label for="email" class="col-lab control-label wid150"><i class="glyphicon glyphicon-envelope"></i>&nbsp;&nbsp;报警邮箱&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                    <div class="col-md-10">
                        <input type="text" class="form-control input-sm" id="email" name="email" value="${job.email}">
                        <span class="tips" tip="任务执行失败时将发送报告给此邮箱,多个请以逗号(英文)隔开">任务执行失败时将发送报告给此邮箱,多个请以逗号(英文)隔开</span>
                    </div>
                </div>
                <br>

                <div class="form-group">
                    <label for="comment" class="col-lab control-label wid150"><i class="glyphicon glyphicon-magnet"></i>&nbsp;&nbsp;描&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                    <div class="col-md-10">
                        <textarea class="form-control input-sm" id="comment" name="comment" style="height: 50px;">${job.comment}</textarea>
                    </div>
                </div>
                <br>

                <div class="form-group">
                    <div class="col-md-offset-1 col-md-10">
                        <button type="button" id="save-btn" class="btn btn-sm m-t-10"><i class="icon">&#61717;</i>&nbsp;保存</button>&nbsp;&nbsp;
                        <button type="button" onclick="history.back()" class="btn btn-sm m-t-10"><i class="icon">&#61740;</i>&nbsp;取消</button>
                    </div>
                </div>

            </form>
        </div>
    </div>

    <%--添加流程作业弹窗--%>
    <div class="modal fade" id="jobModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button class="close btn-float" data-dismiss="modal" aria-hidden="true"><i class="md md-close"></i>
                    </button>
                    <h4 id="subTitle" action="add" tid="">添加子作业</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form" id="subForm"><br>

                        <input type="hidden" id="itemRedo" value="1"/>
                        <div class="form-group">
                            <label for="agentId1" class="col-lab control-label wid100" title="要执行此作业的机器名称和IP地址">执&nbsp;&nbsp;行&nbsp;&nbsp;器&nbsp;&nbsp;&nbsp;</label>
                            <div class="col-md-9">
                                <select id="agentId1" name="agentId1" class="form-control m-b-10 ">
                                    <c:forEach var="d" items="${agents}">
                                        <option value="${d.agentId}">${d.host}&nbsp;(${d.name})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="jobName1" class="col-lab control-label wid100" title="作业名称必填">作业名称&nbsp;<b>*</b></label>
                            <div class="col-md-9">
                                <input type="text" class="form-control " id="jobName1">
                                <span class="tips" tip="必填项,该作业的名称">必填项,该作业的名称</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="cmd1" class="col-lab control-label wid100" title="请采用unix/linux的shell支持的命令">执行命令&nbsp;<b>*</b></label>
                            <div class="col-md-9">
                                <textarea class="form-control" id="cmd1" name="cmd1" style="height:100px;resize:vertical"></textarea>
                                <span class="tips" tip="请采用unix/linux的shell支持的命令">请采用unix/linux的shell支持的命令</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="successExit1" class="col-lab control-label wid100">成功标识&nbsp;<b>*</b></label>
                            <div class="col-md-9">
                                <input type="text" class="form-control" id="successExit1" name="successExit1" value="0">
                                <span class="tips" tip="自定义作业执行成功的返回标识(默认执行成功是0)">自定义作业执行成功的返回标识(默认执行成功是0)</span>
                            </div>
                        </div>
                        <br>

                        <div class="form-group">
                            <label class="col-lab control-label wid100" title="执行失败时是否自动重新执行">失败重跑&nbsp;&nbsp;&nbsp;</label>&nbsp;&nbsp;
                            <label for="redo1" class="radio-label"><input type="radio" name="itemRedo" id="redo1" checked> 是&nbsp;&nbsp;&nbsp;</label>
                            <label for="redo0" class="radio-label"><input type="radio" name="itemRedo" id="redo0">否</label><br>
                        </div>
                        <br>
                        <div class="form-group countDiv1">
                            <label for="runCount1" class="col-lab control-label wid100" title="执行失败时自动重新执行的截止次数">重跑次数&nbsp;&nbsp;&nbsp;</label>&nbsp;&nbsp;
                            <div class="col-md-9">
                                <input type="text" class="form-control " id="runCount1"/>
                                <span class="tips" tip="执行失败时自动重新执行的截止次数">执行失败时自动重新执行的截止次数</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="timeout1" class="col-lab control-label wid100">超时时间&nbsp;<b>*</b></label>
                            <div class="col-md-9">
                                <input type="text" class="form-control" id="timeout1" value="0">
                                <span class="tips" tip="执行作业允许的最大时间,超过则为超时(0:忽略超时时间,分钟为单位)">执行作业允许的最大时间,超过则为超时(0:忽略超时时间,分钟为单位)</span>
                            </div>
                        </div>
                        <br>

                        <div class="form-group">
                            <label for="comment1" class="col-lab control-label wid100" title="此作业内容的描述">描&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述&nbsp;&nbsp;&nbsp;</label>&nbsp;&nbsp;
                            <div class="col-md-9">
                                <input type="text" class="form-control " id="comment1"/>&nbsp;
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <center>
                        <button type="button" class="btn btn-sm" id="subjob-btn">保存</button>&nbsp;&nbsp;
                        <button type="button" class="btn btn-sm" data-dismiss="modal">关闭</button>
                    </center>
                </div>
            </div>
        </div>
    </div>

</section>

</body>

</html>

