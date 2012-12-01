xquery version "1.0";
declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";
declare variable $lp:fromsql-xml as xs:string := "stage3_sql_query4.xml";

declare function lp:list-success-by-postcode() {
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
                    
                (: for each student, get the average of all module's mark
                    where the mark is of the type "mark"
                :)
                let $student_marks_avg := round-half-to-even(avg($student/module[@type = 'mark']), 2)
                
                where
                    $student/number = $postcode_student/student_number
                order by $student_marks_avg descending
                return
                    <student number="{data($student/number)}"
                        course="{data($student/course)}"
                        average="{data($student_marks_avg)}">
                        {
                        (: and show all module's mark ignored in the average because of the type "other"
                            which means resit, failure or medical resit
                        :)
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