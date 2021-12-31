<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title></title>
	</head>
	<body>

		<% out.println("Pick something to search into:"); %> 
							  
		<br>
	
		 <!-- Show html form to i) display something, ii) choose an action via a 
		  | radio button -->
		<!-- forms are used to collect user input 
			The default method when submitting form data is GET.
			However, when GET is used, the submitted form data will be visible in the page address field-->
		<form method="get" action="show.jsp">
		    <!-- note the show.jsp will be invoked when the choice is made -->
			<!-- The next lines give HTML for radio buttons being displayed -->
		  <input type="radio" name="command" value="beers"/>See Beer info
		  <br>
		  <input type="radio" name="command" value="bars"/>See Bar info
		    <!-- when the radio for bars is chosen, then 'command' will have value 
		     | 'bars', in the show.jsp file, when you access request.parameters -->
		  <br>
		  <input type="radio" name="command" value="drinkers"/>See Drinker info
		  <br>
		  <input type="submit" value="submit" />
		</form>
		<br><br><br>
		<FORM ACTION="Part3Query.jsp" METHOD="POST">
			Place a SQL update/insert here if you want to update or add to the database:
		
            <BR>
            <TEXTAREA NAME="textarea1" ROWS="10" style="width: 100%; max-width: 100%;"></TEXTAREA>
            <BR>
            <INPUT TYPE="submit" VALUE="submit">
        </FORM>

	
	

</body>
</html>