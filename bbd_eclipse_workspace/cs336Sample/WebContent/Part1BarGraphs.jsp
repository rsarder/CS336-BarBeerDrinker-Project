<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<% 
	StringBuilder myData=new StringBuilder();
	String strData ="";
    String chartTitle="";
    String legend="";
	try{
		//this list will hold the x-axis and y-axis data as a pair
		ArrayList<Map<String,Integer>> list = new ArrayList();
   		Map<String,Integer> map = null;
   		//Get the database connection
   		ApplicationDB db = new ApplicationDB();	
   		Connection con = db.getConnection();		

   		//Create a SQL statement
   		Statement stmt = con.createStatement();
   		String typeName = request.getParameter("name");
   		String graphType = request.getParameter("graph");
   		//Make a query
   		String query = "" ;
   		if(graphType.equalsIgnoreCase("busiestday")){
   	   		query = "select HOUR(CONVERT(TIME, time)) as hour, count(bill_id) as total_bills from bills " +
   	   		"where bar = \'" + typeName + "\' group by HOUR(CONVERT(TIME, time)) order by HOUR(CONVERT(TIME, time)) asc";
   		}else{
   			query = "SELECT day, count(bill_id) as total_bills  FROM bills WHERE bar = \'" + typeName + 
   					"\'	GROUP BY day ORDER BY count(bill_id) DESC";
   		}
   		
   		ResultSet result = stmt.executeQuery(query);

   		while (result.next()) { 
   			map=new HashMap<String,Integer>();
   	   		if(graphType.equalsIgnoreCase("busiestDay")){
   	   			map.put(result.getString("hour"),result.getInt("total_bills"));
   	   		}else{
   	   			map.put(result.getString("day").substring(0,result.getString("day").length()-1),result.getInt("total_bills"));
   	   		}
   			list.add(map);
   	    } 
   	    result.close();
   	    
   	    //Create a String of graph data of the following form: ["Caravan", 3],["Cabana",2],...
        for(Map<String,Integer> hashmap : list){
        		Iterator it = hashmap.entrySet().iterator();
            	while (it.hasNext()) { 
           		Map.Entry pair = (Map.Entry)it.next();
           		String key = pair.getKey().toString().replaceAll("'", "");
           		myData.append("['"+ key +"',"+ pair.getValue() +"],");
           	}
        }
        strData = myData.substring(0, myData.length()-1); //remove the last comma
        //Create the chart title according to what the user selected
   		if(graphType.equalsIgnoreCase("busiestDay")){
          chartTitle = "Busiest Times of Day";
          legend = "Hour";
   		}else{
   			chartTitle = "Busiest Times of Week";
            legend = "Day";
        }
	}catch(SQLException e){
    		out.println(e);
    }
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Graphs</title>
		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script> 
		
			var data = [<%=strData%>]; //contains the data of the graph in the form: [ ["Caravan", 3],["Cabana",2],...]
			var title = '<%=chartTitle%>'; 
			var legend = '<%=legend%>'
			//this is an example of other kind of data
			//var data = [["01/22/2016",108],["01/24/2016",45],["01/25/2016",261],["01/26/2016",224],["01/27/2016",307],["01/28/2016",64]];
			var cat = [];
			data.forEach(function(item) {
			  cat.push(item[0]);
			});
			document.addEventListener('DOMContentLoaded', function () {
			var myChart = Highcharts.chart('graphContainer', {
			    chart: {
			        defaultSeriesType: 'column',
			        events: {
			            //load: requestData
			        }
			    },
			    title: {
			        text: title
			    },
			    xAxis: {
			        text: 'xAxis',
			        categories: cat
			    },
			    yAxis: {
			        text: 'yAxis'
			    },
			    series: [{
			        name: legend,
			        data: data
			    }]
			});
			});
		
		</script>
	</head>
	<body>

	<div id="graphContainer" style="width: 500px; height: 400px; margin: 0 auto"></div>



</body>
</html>