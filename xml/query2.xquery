xquery version "1.0";

declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";

(:
    Function which list the marks by year and by module
    for the given course code 
:)
declare function lp:list-courses($course_code as xs:string) {

        (: get the course corresponding to the course code :)
        let $course := doc($lp:courses-xml)/courses/course[code=$course_code]
        
        (: get all modules code of the course :)
        let $course_modules_codes := $course/module/@code
        
        (: get all students :)
        let $students := doc($lp:students-xml)/students
        
        (: get all existing years as distinct values to have only unique values :)
        let $years := distinct-values($students/student[course=$course_code]/year)
        
        return
        <course code="{data($course/code)}">
            {
            (: loop on the years, in the ascending order :)
            for $year in $years
            order by $year ascending
            return
            <year value="{data($year)}">
                {
                (: for each year, loop on the course module's codes :)
                for $module_code in $course_modules_codes
                order by $module_code ascending
                return
                <module code="{data($module_code)}">
                    {
                    (: 
                        and then loop on each student's module corresponding to the course, the current year
                        and the current module code in the loop
                    :)
                    for $module in $students/student[course=$course/code and year=$year]/module
                    where $module/@code = $module_code
                    return
                    <mark
                        studentnumber="{data($module/../number)}"
                        type="{data($module/@type)}">
                        {data($module)}
                    </mark>
                    }
                </module>
                }
            </year>
            }
        </course> 
};

<query>
    {lp:list-courses('CM51')}
</query>