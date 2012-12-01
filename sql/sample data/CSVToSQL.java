import java.io.*;
import java.util.*;
import java.util.regex.*;

public class CSVToSQL {

	/**
	 * @param args
	 */

	static String filename = "p00601_stage1_sample_data.csv";
	static String outfilename = "p00601_stage1_sample_data.sql";

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

			List<String> exist = new ArrayList<String>();
			List<String> addressesExist = new ArrayList<String>();
			List<Integer> studentsExist = new ArrayList<Integer>();
			List<Integer> coursesExist = new ArrayList<Integer>();
			
			while ((line = r.readLine()) != null) {

				result = line.split(", ");

				String query = "insert into towns values(";
				int townId;
				String name = "";
				String postcode = "";
				String county = "";

				String queryAddresses = "insert into addresses values(";
				int addressId;
				String addressNumber = "";
				String addressStreet = "";
				String addressPostcode = "";

				String queryStudents = "insert into students values(";
				int studentPhoneNumber = 0;
				String studentSurname = "";
				String studentFirstname = "";

				String queryCourses = "insert into student_courses values(";
				int studentNumber = 0;
				String year = "";
				String courseCode = "";

				for (int i = 0; i < result.length; i++) {
					String content = result[i];

					switch (i) {

						// course
						case 0:
							studentNumber = Integer.parseInt(content);
							break;
						case 3:
							courseCode = content;
							break;
						case 4:
							year = content;
							break;

						// student
						case 1:
							studentSurname = content;
							break;
						case 2:
							studentFirstname = content;
							break;
						case 5:
							studentPhoneNumber = Integer.parseInt(content);
							break;

						// addresses
						case 6:
							Pattern p = Pattern.compile("(^|\\s)([0-9]+)($|\\s)");
							Matcher m = p.matcher(content);
							
	    					if(!m.find()) {
	    						throw new RuntimeException("Cannot found for " + content);
	    					}

							addressNumber = m.group(2);
							addressStreet = content.substring(content.indexOf(addressNumber) + addressNumber.length() + 1);
							addressStreet = addressStreet.replaceAll("'", "''");
							break;
						case 10:
							addressPostcode = content;
							break;

						// towns
						case 7:
							name = content;
							break;
						case 9:
							postcode = content;
							break;
						case 8:
							if(result[i].equals("Oxon")) {
								county = "1";
							} else if(result[i].equals("Lancashire")) {
								county = "2";
							} else {
								county = "3";
							}
							break;
					}
				}

				// town id
				if(!exist.contains(name)) {
					townId = exist.size() + 1;
					query += toQueryInt(townId);
					query += toQuery(name);
					query += toQuery(postcode);
					query += toQueryLast(county);
					out.println(query);
					exist.add(name);
				} else {
					townId = exist.indexOf(name) + 1;
				}

				// addresses id
				String addressFull = addressNumber + addressStreet + addressPostcode;
				if(!addressesExist.contains(addressFull)) {
					addressId = addressesExist.size() + 1;
					queryAddresses += toQueryInt(addressId);
					queryAddresses += toQuery(addressNumber);
					queryAddresses += toQuery(addressStreet);
					queryAddresses += toQuery(addressPostcode);
					queryAddresses += toQueryIntLast(townId);

					out.println(queryAddresses);
					addressesExist.add(addressFull);
				} else {
					addressId = addressesExist.indexOf(addressFull) + 1;
				}

				// student
				if(!studentsExist.contains(studentPhoneNumber)) {
					queryStudents += toQueryInt(studentPhoneNumber);
					queryStudents += toQuery(studentSurname);
					queryStudents += toQuery(studentFirstname);
					queryStudents += toQueryIntLast(addressId);

					out.println(queryStudents);
					studentsExist.add(studentPhoneNumber);
				}

				// course
				if(!coursesExist.contains(studentNumber)) {
					queryCourses += toQueryInt(studentNumber);
					queryCourses += toQuery(year);
					queryCourses += toQueryInt(studentPhoneNumber);
					queryCourses += toQueryLast(courseCode);

					out.println(queryCourses);
					coursesExist.add(studentNumber);
				}
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
