xquery version "1.0";

declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";

(:
    Function question 3.a
    Get all student's having modules not present in the corresponding course's modules
:)
declare function lp:list-students-invalid-modules() {
        let $courses := doc($lp:courses-xml)/courses/course
        let $students := doc($lp:students-xml)/students/student
        
        (: for each student, in each course :)
        for $student in $students,
            $course in $courses
            
        let $student_modules := $student/module/@code (: all student's modules codes :)
        let $course_modules := $course/module/@code (: all course's modules codes :)
        
        (: exclusion between student's modules and course's module,
            to get all student's module that are not in course's module :)
        let $modules_diff := distinct-values($student_modules[not(.=$course_modules)])
        
        where
            (: match the course corresponding to the student's current course in the for loop :)
            $student/course = $course/code and 
            
            (: and where there is studen'ts modules that are not in course module :)
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
};

(:
    Function question 3.b and 3.c
    3.b : Get all student's having modules without having the module's prerequisites modules
    3.c : Get all student's having mark less than 30 in prequisites modules 
:)
declare function lp:list-students-invalid-prequisites() {
        let $students := doc($lp:students-xml)/students/student
        let $modules := doc($lp:modules-xml)/modules/module
            
        (: for each student, in each module :)            
        for $student in $students,
            $module in $modules
            
        (: all current student's modules :)
        let $student_modules := $student/module
        
        (: all current module's prerequisites modules:)
        let $module_prereq := $module/reqModule
        
        (: the current student's module corresponding to the current module in the loop :)
        let $current_student_module := $student_modules[@code=$module/code]
        
        (: the current student's module prerequisite corresponding to the current module in the loop :)
        let $current_student_module_prereq := $student_modules[@code=$module/reqModule]
        
        where
            (: match the module corresponding to the student's current module in the loop :)
            $student_modules/@code = $module/code and
            
            (: and the module must have prerequisites :)
            not(empty($module_prereq)) and
            
            (: and
                - either student is not subscribed to the module prerequisite
                - or either student is subscribed to the module prerequisite and the mark is
                    - less than 30
                    - other type (resit, fail, etc)
            :)
            (not($student_modules/@code = $module_prereq) or
                ($student_modules/@code = $module_prereq and 
                    ($current_student_module_prereq/@type = 'other' or
                    ($current_student_module_prereq/@type = 'mark' and $current_student_module_prereq < 30)
                    )
                )
            )
        return
            <student>
                <number>{data($student/number)}</number>
                <module>{data($module/code)}</module>
                {
                (: if the module's prequisite is missing :)
                if(not($student_modules/@code = $module_prereq))
                then
                    <missing>
                    {
                    for $req_module in $module_prereq
                    return
                        <module code="{data($req_module)}">
                            {data($student_modules[code = $req_module])}
                        </module>
                    }
                    </missing>
                    
                (: else the module's prequisite is not validated :)
                else
                    <invalidate>
                        <module code="{data($current_student_module_prereq/@code)}"
                            type="{data($current_student_module_prereq/@type)}">
                            {data($current_student_module_prereq)}
                        </module>
                    </invalidate>
                }
            </student>
};



<query>
    <invalid-students type="Invalid modules in student courses">
    {lp:list-students-invalid-modules()}
    </invalid-students>
   
    <invalid-students type="Invalid prerequisites modules in student courses">
    {lp:list-students-invalid-prequisites()}
    </invalid-students>
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