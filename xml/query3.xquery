xquery version "1.0";

declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";

declare function lp:list-students-1() {

        let $courses := doc($lp:courses-xml)/courses/course
        let $students := doc($lp:students-xml)/students/student
        let $modules := doc($lp:modules-xml)/modules/module
        
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

declare function lp:list-students-2() {

        let $courses := doc($lp:courses-xml)/courses/course
        let $students := doc($lp:students-xml)/students/student
        
        let $modules := doc($lp:modules-xml)/modules/module
        
        
        return
        <invalid-students>
            {
            
            for $student in $students,
                $module in $modules
            let $student_modules := $student/module/@code
            let $module_prereq := $module/reqModule
            where
                $student/module/@code = $module/code and
                not(empty($module_prereq)) and 
                not($student_modules = $module_prereq)
            return
                
                <student>
                    <number>{data($student/number)}</number>
                    <module>{data($module/code)}</module>
                    <reqs>{data($module_prereq)}</reqs>
                </student>
            }
        </invalid-students> 
};

<query>
    {lp:list-students-1()}
    {lp:list-students-2()}
</query>


(: 

distinct-values($student_modules[not(.=$course_modules)])

- student with module not in the course
    - list student modules and compare with course modules

- student with module witout prereq
    - list stuednt modules
    - for each module check on modules.xml if there is a prereq
    - check if prereq is in the set

- student with prereq modules with mark < 30



:)