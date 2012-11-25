xquery version "1.0";

declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";

declare function lp:list-courses($course_code as xs:string) {

        let $courses := doc($lp:courses-xml)/courses/course
        let $students := doc($lp:students-xml)/students/student
        
        return
        <invalid-students>
            {
            for $student in $students,
                $course in $courses
            let $student_modules := $student/module/@code
            let $course_modules := $courses/module/@code
            let $modules_diff := distinct-values($student_modules[not(.=$course_modules)])
            where
                $student/course = $course/code and
                not(empty($modules_diff))
            return
                let $student_modules := $student/module/@code
                let $course_modules := $courses/module/@code
                return
                
                <student>
                    <number>{data($student/number)}</number>
                    <course>{data($course/code)}</course>
                    <invalid-modules count="{count($modules_diff)}">
                        {
                        for $module in $modules_diff
                        return
                        <module>{data($module)}</module>
                        }
                    </invalid-modules>
                </student>
            }
        </invalid-students> 
};

<query>
    {lp:list-courses('CM51')}
</query>


(: 

distinct-values($student_modules[not(.=$course_modules)])

- student with module not in the course
    - list student modules and compare with course modules

- student with module witout prereq
- student with prereq modules with mark < 30

:)