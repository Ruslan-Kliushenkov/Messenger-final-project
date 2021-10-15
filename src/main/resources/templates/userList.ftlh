<#import "parts/common.ftlh" as c/>

<@c.page>

    <table class="table">
        <thead>
        <tr>
            <th scope="col">Name</th>
            <th scope="col">Role</th>
            <th scope="col"></th>
        </tr>
        </thead>
        <tbody>
        <#list users as user>
            <tr>
                <td>${user.username}</td>
                <td><#list user.roles as role>${role}<#sep>, </#list></td>
                <td><form action="user/${user.id}">
                        <input class="btn btn-warning" type="submit" value="Edit" />
                    </form></td>
                <td><form method="post" action="/user/deleteUser"  class="form-inline">
                    <input type="hidden" name="id" value="${user.id}" class ="form-control" placeholder="id"/>
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-danger btn-sm">X</button>
                </form></td>
            </tr>
        </#list>
        </tbody>
    </table>
</@c.page>