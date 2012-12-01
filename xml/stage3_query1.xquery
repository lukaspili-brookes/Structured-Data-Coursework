xquery version "1.0";
declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";
declare variable $lp:fromsql-xml as xs:string := "stage3_sql_query1.xml";

declare function lp:list-marks-by-postcodes() {
        let $students := doc($lp:students-xml)/students/student
        let $rows := doc($lp:fromsql-xml)/table/row
        
        (: group by the distinct values of the postcodes :)
        for $postcode in distinct-values($rows/postcode)
        let $postcode_students := $rows[postcode = $postcode]
        order by $postcode
        return
            <postcode value="{data($postcode)}">
                {
                (: and get the associated students by the student number :)
                for $postcode_student in $postcode_students,
                    $student in $students
                where $student/number = $postcode_student/student_number
                return
                    <student number="{data($student/number)}">
                        {
                        for $module in $student/module
                        return
                            <module code="{data($module/@code)}">
                                {data($module)}
                            </module>                            
                        }
                    </student>
                }
            </postcode>
};

<query>
    {lp:list-marks-by-postcodes()}
</query>