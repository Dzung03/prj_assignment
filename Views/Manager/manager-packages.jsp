<%-- 
    Document   : manager-packages
    Created on : Mar 9, 2026, 9:24:07 PM
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.ServicePackage" %>

<html>
    <head>
        <title>Admin - Packages</title>
    </head>

    <body>

        <h2>Manage Service Packages</h2>

        <table border="1">

            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Price</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <%
                List<ServicePackage> packages =
                    (List<ServicePackage>) request.getAttribute("packages");

                for(ServicePackage p : packages){
            %>

            <tr>

                <td><%= p.getId() %></td>

                <td><%= p.getName() %></td>

                <td><%= p.getDefaultBasePrice() %></td>

                <td>
                    <%= p.isActive() ? "Active" : "Inactive" %>
                </td>

                <td>

                    <a href="package-detail?id=<%= p.getId() %>">
                        View
                    </a>

                    |

                    <a href="package-delete?id=<%= p.getId() %>">
                        Delete
                    </a>

                </td>

            </tr>

            <%
                }
            %>

        </table>

    </body>
</html>
