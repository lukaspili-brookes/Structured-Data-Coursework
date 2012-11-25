xquery version "1.0";

declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";

declare function lp:list-courses($course_code as xs:string) {

        let $course := doc($lp:courses-xml)/courses/course[code=$course_code]
        let $course_modules_codes := $course/module/@code
        let $students := doc($lp:students-xml)/students
        let $years := distinct-values($students/student[course=$course_code]/year)
        
        return
        <course code="{data($course/code)}">
            {
            for $year in $years
            order by $year ascending
            return
            <year value="{data($year)}">
                {
                for $module_code in $course_modules_codes
                order by $module_code ascending
                return
                <module code="{data($module_code)}">
                    {
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


(: 
- get the course
- get all distinct and ordered years
- get
- get modules for the course

:)