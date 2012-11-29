xquery version "1.0";

declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";
declare variable $lp:fromsql-xml as xs:string := "stage3_sql_query4.xml";

(:
    Function question 3.a
    Get all student's having modules not present in the corresponding course's modules
:)
declare function lp:list-success-by-postcode() {
        let $students := doc($lp:students-xml)/students/student
        let $rows := doc($lp:fromsql-xml)/table/row
        
        (: for each student, in each course :)
        for $postcode in distinct-values($rows/postcode)
        let $postcode_students := $rows[postcode = $postcode]
        order by $postcode
        return
            <postcode value="{data($postcode)}">
                {
                for $postcode_student in $postcode_students,
                    $student in $students
                let $student_marks_avg := round-half-to-even(avg($student/module[@type = 'mark']), 2)
                where
                    $student/number = $postcode_student/student_number
                order by $student_marks_avg descending
                return
                    <student number="{data($student/number)}"
                        course="{data($student/course)}"
                        average="{data($student_marks_avg)}">
                        {
                        for $module in $student/module
                        where $module/@type = 'other'
                        return
                            <ignored-module code="{data($module/@code)}"
                                reason="{data($module)}"/>                  
                        }
                    </student>
                }
            </postcode>
};

<query>
    {lp:list-success-by-postcode()}
</query>