<#import "parts/common.ftlh" as c>
<#include "parts/security.ftlh">
<@c.page>
    <div class="form-row">
        <div class="form-group col-md-6">
            <form method="get" action="main" class="form-inline">
                <input type="text" name="filter" class="form-control" value="${filter?ifExists}"
                       placeholder="Search by tag">
                <button type="submit" class="btn btn-secondary">Найти</button>
            </form>
        </div>
    </div>

    <div class="form-group">
        <form method="post" action="/mainPost" enctype="multipart/form-data">
            <input type="text" class="form-control" name="text" placeholder="Введите сообщение"/>
            <input type="text" class="form-control" name="tag" placeholder="Тэг">
            <div class="form-group">
                <div class="custom-file">
                    <input type="file" name="file" id="customFile">
                    <label class="custom-file-label" for="customFile">Choose file</label>
                </div>
            </div>

            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-success">Добавить</button>
        </form>
    </div>





    <#list messages as message>
        <div class="card" style="width: 18rem;">
            <div>
                <#if message.filename??>
                    <img src="/img/${message.filename}" class="card-img-top">
                </#if>
                <#if isAdmin>
                    <i>(${message.id})</i>
                </#if>
                <h5 class="card-title">${message.text}</h5>
                <h6 class="card-subtitle mb-2 text-muted">${message.tag}</h6>
                <form method="post" action="like" class="form-inline">
                    <input type="hidden" name="messageId" value="${message.id}" class="form-control"
                           placeholder="message"/>
                    <input type="hidden" value="${_csrf.token}" name="_csrf">
                    <button type="submit" class="btn btn-secondary" data-toggle="tooltip" data-placement="right"
                            title="Press to like it">
                        ${message.likes}
                    </button>
                </form>
                <#if isAdmin>
                    <form method="post" action="delete" class="form-inline">
                        <input type="hidden" name="id" value="${message.id}" class="form-control" placeholder="id"/>
                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-danger btn-sm">X</button>
                    </form>
                </#if>
                <div class="card-footer text-muted">
                    ${message.authorName}
                    <#if message.date??>
                        ${message.date}
                    </#if>
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">Comments</h5>
                        </div>
                        <div class="card-body">
                    <#list message.messageComment as comment>
                            <p class="card-text">
                                ${comment}
                            </p>
                    </#list>
                        </div>
                        </div>
                    <form method="post" action="/comment" class="form-inline">
                        <input type="hidden" name="messageId" value="${message.id}" class="form-control" placeholder="id"/>
                        <input type="text" name="comment" class="form-control" placeholder="Comment this message.."/>
                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-danger">Comment</button>
                    </form>
                </div>
            </div>
        </div>
    <#else>
        No message
    </#list>
    <#if isAdmin>
        <div class="form-row">
            <div class="form-group col-md-4">
                <form method="post" action="delete" class="form-inline">
                    <input type="text" name="id" class="form-control" placeholder="id"/>
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </#if>
</@c.page>