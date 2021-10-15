<#macro login path isRegisterForm>
    <h5>Authorisation</h5>
    <form action="${path}" method="post" xmlns="http://www.w3.org/1999/html">
        <div class="form-group">
            <label class="col-sm-2 col-form-label"> User Name : </label>
            <div class="col-sm-6">
            <input type="text" name="username" class="form-control"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 col-form-label"> Password: </label>
            <div class="col-sm-6">
            <input type="password" name="password" class="form-control"/> </div>
        </div>
        <input type="hidden" name="_csrf" value="${_csrf.token}" />
        <button type="submit" class="btn btn-success"><#if isRegisterForm>Create<#else>Sing in</#if></button>

        <#if !isRegisterForm><a href="/registration">add new user</a></#if>
    </form>
</#macro>

<#macro logout>
    <form action="/logout" method="post">
        <input type="hidden" name="_csrf" value="${_csrf.token}" />
        <button type="submit" class="btn btn-danger">Sing out</button>
    </form>
</#macro>