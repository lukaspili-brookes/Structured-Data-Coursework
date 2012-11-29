xquery version "1.0";

declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";
declare variable $lp:fromsql-xml as xs:string := "stage3_sql_query2.xml";

(:
    Function question 3.a
    Get all student's having modules not present in the corresponding course's modules
:)
declare function lp:list-failure-by-year-of-entry() {
        let $students := doc($lp:students-xml)/students/student
        let $rows := doc($lp:fromsql-xml)/table/row
        let $years := distinct-values($rows/year)
        
        (: for each student, in each course :)
        for $year in distinct-values($rows/year)
        let $year_students := $rows[year = $year]
        order by $year
        return
            <year value="{data($year)}">
                {
                for $year_student in $year_students,
                    $student in $students
                where
                    $student/number = $year_student/student_number and
                    (count($student/module[@type = 'other']) > 0 or 
                        min($student/module[@type = 'mark']) < 30)
                return
                    <student number="{data($student/number)}"
                        course="{data($student/course)}">
                        {
                        for $module in $student/module
                        return
                            <module code="{data($module/@code)}" type="{data($module/@type)}">
                                {data($module)}
                            </module>                            
                        }
                    </student>
                }
            </year>
};

<query>
    {lp:list-failure-by-year-of-entry()}
</query>