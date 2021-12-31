<%@page import="jdk.internal.misc.FileSystemOption"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT * FROM " + entity;
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
		<tr>    
			<td>Name</td>
			<td>
				<%ArrayList<String> itemNames = new ArrayList<String>();
				if (entity.equals("beers"))
					out.print("manf");
				if(entity.equals("bars"))
					out.print("state");
				if(entity.equals("drinkers")) 
					out.print("phone");
				%>
			</td>
			<td>
			<%
				if(entity.equals("drinkers")){
					out.print("state");			
				}
				%>
			</td>
		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td><%= result.getString("name") %></td>
					<% itemNames.add(result.getString("name"));%>
					<td>
						<% if (entity.equals("beers")){ %>
							<%= result.getString("manf")%>
						<% }else if (entity.equals("bars")){ %>
							<%= result.getString("state")%>
						<% } else if(entity.equals("drinkers")){%>
							<%= result.getString("phone")%>
							<%} %>
							
					</td>
					<%
				if(entity.equals("drinkers")){
					out.print("<td>");%>
					<%=result.getString("state")%>
					<%
					out.print("</td>");
					
				}%>
				
				</tr>
				<%} %>
				
				
	</table>
	
	<br>
	
	<label>Get information on...</label>
<form method="get" action="partOneShow.jsp">	
	<select name="type" size=1>
		<%
			if(entity.equals("bars")){
				out.print("<option value=\"");
				out.print("bars");
				out.print("\">bars:</option>");
			} else if(entity.equals("beers")){
				out.print("<option value=\"");
				out.print("beers");
				out.print("\">beers:</option>");
			} else{
				out.print("<option value=\"");
				out.print("drinkers");
				out.print("\">drinkers:</option>");
			}
		%>
	</select>
	<select name="name" size=1>
		<%request.setAttribute("itemNames",itemNames); %>
    	<c:forEach var="names" items="${itemNames}">
        	<option><c:out value="${names}"/></option>
    	</c:forEach>
	</select>
	<br>
    <input type="submit" value="Submit"> 
 </form>
				
				
				

			<% 
			//close the connection.
			db.closeConnection(con);
			%>

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>