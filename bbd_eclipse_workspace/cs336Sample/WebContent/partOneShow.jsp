<%@page import="jdk.internal.misc.FileSystemOption"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
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
			String type = request.getParameter("type");
			String typeName = request.getParameter("name");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			//String str = "SELECT * FROM " + ;
			//Run the query against the database.
			//ResultSet result = stmt.executeQuery(str);
			out.print("Info about entry from " + type + ", " + typeName + ":\n");
			if(type.equals("drinkers")){
				out.print("<form method=\"get\" action=\"Part1DrinkerGraphs.jsp\">");
				out.print("<select name=\"name\" size=1>");
				out.print("<option value=\""+typeName+"\">"+typeName+"\'s</option>");
				out.print("</select>");
				out.print("<select name=\"graph\" size=1>");
				out.print("<option value=\"mostOrdered\">Drinker\'s most ordered drinks</option>");
				out.print("<option value=\"spendingWeek\">Drinker\'s spending per day of week</option>");
				out.print("<option value=\"spendingMonth\">Drinker\'s spending per month</option>");
				out.print("</select>&nbsp;<br> <input type=\"submit\" value=\"submit\"></form>");
			} else if(type.equals("bars")){
				out.print("<form method=\"get\" action=\"Part1BarGraphs.jsp\">");
				out.print("<select name=\"name\" size=1>");
				out.print("<option value=\""+typeName+"\">"+typeName+"\'s</option>");
				out.print("</select>");
				out.print("<select name=\"graph\" size=1>");
				out.print("<option value=\"busiestDay\">Bar\'s busiest times of the day</option>");
				out.print("<option value=\"busiestWeek\">Bar\'s busiest times of the week</option>");
				out.print("</select>&nbsp;<br> <input type=\"submit\" value=\"submit\"></form>");
			}else{
				out.print("<form method=\"get\" action=\"Part1BeerGraphs.jsp\">");
				out.print("<select name=\"name\" size=1>");
				out.print("<option value=\""+typeName+"\">Beer\'s throughout the week</option>");
				out.print("</select>&nbsp;<br> <input type=\"submit\" value=\"submit\"></form>");

			}

				
			out.print("<br><br>");
			String query = "";
			ResultSet result;
			
			
			//*******************************************************
			//IF TYPE = DRINKERS*************************************
			//*******************************************************
		if(type.equals("drinkers")){
				
					
		
		//*******************************************************	
		//TABLES OF TRANSACTIONS ORDERED BY TIME GROUPED BY BARS*
		//*******************************************************
		query = "SELECT B.bill_id,bar, date, time, quantity, item, " +
		"items_price, tax_price, tip, total_price  from Bills B " +
		"INNER JOIN Transactions T ON B.bill_id = T.bill_id "+
		"WHERE drinker = \'" + typeName + "\' ORDER BY bar, date, time;";
		result = stmt.executeQuery(query);
		out.print(typeName + "'s transactions, grouped by bar and ordered"
				+ "by time(chronologically, so including date)");		
		out.print("<table>");
		out.print("<tr>");
		out.print("<td> bill_id </td>");
		out.print("<td> bar </td>");
		out.print("<td> date </td>");
		out.print("<td> time </td>");
		out.print("<td> quantity </td>");
		out.print("<td> item </td>");
		out.print("<td> items_price </td>");
		out.print("<td> tax_price </td>");
		out.print("<td> tip </td>");
		out.print("<td> total_price </td>");
		out.print("</tr>");
		
		while (result.next()) {
			out.print("<tr>");
			out.print("<td>");
			out.print(result.getString("bill_id"));
			out.print("</td>");
			out.print("<td>");
			out.print(result.getString("bar"));
			out.print("</td>");
			out.print("<td>");
			out.print(result.getString("date"));
			out.print("</td>");
			out.print("<td>");
			out.print(result.getString("time"));
			out.print("</td>");
			out.print("<td>");
			out.print(result.getString("quantity"));
			out.print("</td>");
			out.print("<td>");
			out.print(result.getString("item"));
			out.print("</td>");
			out.print("<td>");
			out.print(result.getString("items_price"));
			out.print("</td>");
			out.print("<td>");
			out.print(result.getString("tax_price"));
			out.print("</td>");
			out.print("<td>");
			out.print(result.getString("tip"));
			out.print("</td>");
			out.print("<td>");
			out.print(result.getString("total_price"));
			out.print("</td>");
			out.print("</tr>");
		}
		out.print("<br>");
		
		
		//*******************************************************
		//IF TYPE = BAR******************************************
		//*******************************************************
		} else if(type.equals("bars")){
			
			//*******************************************************	
			//TABLES OF TOP 10 DRINKERS*
			//*******************************************************
			query = "SELECT drinker, round(sum(total_price), 2) as money_spent FROM bills "+
					"WHERE bar = \'" + typeName +"\' GROUP BY drinker "+
					"ORDER BY SUM(total_price) DESC	LIMIT 10";

			result = stmt.executeQuery(query);			
			out.print("<table>");			
			out.print("<tr>"+typeName + "\'s top 10 drinkers, also the largest spenders:</tr>");
			out.print("<tr>");
			out.print("<td> drinker </td>");
			out.print("<td> money_spent(dollars) </td>");
			out.print("</tr>");
			while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
				out.print(result.getString("drinker"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("money_spent"));
				out.print("</td>");
				out.print("</tr>");
			}
			
			
			
			//*******************************************************	
			//TABLES OF TOP 10 BEERS*
			//*******************************************************
			query = "SELECT transactions.item as beer_name, sum(quantity) as total_sold "+ 
					"FROM transactions LEFT JOIN bills ON transactions.bill_id = " +
					"bills.bill_id WHERE transactions.type = 'beer' AND bar = \'" + typeName
					+ "\' GROUP BY item	ORDER BY sum(quantity) DESC	LIMIT 10";

			result = stmt.executeQuery(query);
			
			out.print("<table>");
			out.print("<tr>"+typeName + "\'s top 10 beers, also the most popular:</tr>");
			out.print("<tr>");
			out.print("<td> beer_name </td>");
			out.print("<td> total_sold </td>");
			out.print("</tr>");
			while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
				out.print(result.getString("beer_name"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("total_sold"));
				out.print("</td>");
				out.print("</tr>");
			}
			
			
			
			//*******************************************************	
			//TABLES OF TOP 5 MANF SELLING AT THIS BAR*
			//*******************************************************
			query = "SELECT beers.manf as manuf, sum(quantity) as beers_sold " +
					"FROM transactions LEFT JOIN bills ON transactions.bill_id = bills.bill_id "+
					"LEFT JOIN beers ON beers.name = transactions.item "+
					"WHERE transactions.type = \'beer\' AND bar = \'" + typeName +
					"\'	GROUP BY manf ORDER BY sum(quantity) DESC LIMIT 5";

			result = stmt.executeQuery(query);
			
			out.print("<table>");
			out.print("<tr>"+typeName + "\'s top 5 manufacturers who sell at this bar:</tr>");
			out.print("<tr>");
			out.print("<td> manf </td>");
			out.print("<td> beers_sold </td>");
			out.print("</tr>");
			while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
				out.print(result.getString("manuf"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("beers_sold"));
				out.print("</td>");
				out.print("</tr>");
			}
			
			
			//*******************************************************
			//IF TYPE = BEER*****************************************
			//*******************************************************	
		}else{
			//*******************************************************	
			//TOP 5 BARS THIS BEER SELLS AT
			//*******************************************************
			query = "SELECT bills.bar as bar_name, sum(quantity) as beers_sold "+ 
					"FROM transactions LEFT JOIN bills ON transactions.bill_id = bills.bill_id "+
					"WHERE transactions.item = \'" + typeName + 
					"\'	GROUP BY bar ORDER BY sum(quantity) DESC LIMIT 5;";

			result = stmt.executeQuery(query);
			
			out.print("<table>");
			out.print("<tr> Top 5 bars " + typeName +  " sells at:</tr>");
			out.print("<tr>");
			out.print("<td> bar_name </td>");
			out.print("<td> beers_sold </td>");
			out.print("</tr>");
			while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
				out.print(result.getString("bar_name"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("beers_sold"));
				out.print("</td>");
				out.print("</tr>");
			}
					
			//*******************************************************	
			//BIGGEST CONSUMERS OF THIS BEER
			//*******************************************************
			query = "SELECT bills.drinker as drinker, sum(quantity) as beers_bought FROM transactions "+
					"LEFT JOIN bills ON transactions.bill_id = bills.bill_id "+
					"WHERE transactions.item = \'" + typeName + "\'	GROUP BY drinker "+
					"ORDER BY sum(quantity) DESC";

			result = stmt.executeQuery(query);
			
			out.print("<table>");
			out.print("<tr> Top consumers of " + typeName +  ":</tr>");
			out.print("<tr>");
			out.print("<td> drinker </td>");
			out.print("<td> beers_bought </td>");
			out.print("</tr>");
			while (result.next()) {
				out.print("<tr>");
				out.print("<td>");
				out.print(result.getString("drinker"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("beers_bought"));
				out.print("</td>");
				out.print("</tr>");
			}
		}
		
		
		
		%>


	<br>
	
	
		
		
		
		
		
		<%}catch(Exception e){
			out.print(e);
		}
		%>
		
</body>
</html>