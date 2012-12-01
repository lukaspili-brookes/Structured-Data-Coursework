import java.io.*;
import java.util.*;
import java.util.regex.*;

public class studentxml {

	/**
	 * @param args
	 */

	static String filename = "mark_sheets.csv";
	static String outfilename = "students.xml";

	private static void printError(String msg) {
		System.out.println(msg);
		System.exit(1);
	};

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		if (args.length == 1) {
			// the argument is the output file name; by default writes to standard output
			outfilename = args[0];
		};
		if (args.length == 2) {
			// the first argument is the intput file name
			filename = args[0];
			// the second argument is the output file name
			outfilename = args[1];
		};
		// System.out.println("Filename: " + filename + " outfilename: " + outfilename);
		
		try {
			FileInputStream fstream = new FileInputStream(filename);
			// Get the object of DataInputStream
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader r = new BufferedReader(new InputStreamReader(in));
			String line;
			String[] result;
			
			PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(outfilename)));
			
			out.println("<students>");

			String last = "";
			while ((line = r.readLine()) != null) {

				result = line.split(", ");
				String current = result[0];

				if(!current.equals(last)) {

					last = current;

					if(!last.equals("")) {
						out.println("	</student>");
					}

					out.println("	<student>");
					out.println("		<number>" + result[0] + "</number>");
					out.println("		<course>" + result[1] + "</course>");
					out.println("		<year>" + result[2] + "</year>");
				}

				String type = "other";
				try {
					Integer.parseInt(result[4]);
					type = "mark";
				} catch(Exception e) {
					
				}

				out.println("		<module code=\"" + result[3] + "\" type=\"" + type + "\">" + result[4] + "</module>");
				
			}
			r.close();
			out.close();

		} catch (Exception e) {
			printError(e.getMessage());
		}
	}

	public static String toQuery(String value) {
		return "\'" + value + "\', ";
	}

	public static String toQueryLast(String value) {
		return "\'" + value + "\');";
	}

	public static String toQueryInt(int value) {
		return value + ", ";
	}

	public static String toQueryIntLast(int value) {
		return value + ");";
	}	
}
