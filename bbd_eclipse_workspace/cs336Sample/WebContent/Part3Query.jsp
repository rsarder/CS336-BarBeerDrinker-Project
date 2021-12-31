<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Query:</title>
</head>
<body>
<FORM ACTION="index.jsp" METHOD="GET">
				<INPUT TYPE="submit" VALUE="Go Back">
        	</FORM>
<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			String query = request.getParameter("textarea1");
			out.print("Query: " + query + "<br>");
			stmt.executeUpdate(query);
			
			out.print("Success!");
		
%>


<%
	}catch(SQLException e){
		out.print(e);
	} catch(Exception e){
		out.print(e);
	}

%>

</body>
</html>