xquery version "1.0";
declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";

(:
    Get as parameter the sutdent number and list the marks of the 
    related student
:)
declare function lp:list-student-marks($student_number as xs:string) {

        (: get the student corresponding to the student number :)
        let $student := doc($lp:students-xml)/students/student[number=$student_number]
        
        (: get the student's modules :)
        let $modules := $student/module
        
        (: get the student's module marks which have a numeric mark from 0 to 100 :)
        let $modules_marked := $modules[@type='mark']
        
        (: get the student's module marks which have been not marked :)
        let $modules_ignored := $modules[@type='other']
        
        (: get the student's　marks　average :)
        let $modules_marked_avg := round-half-to-even(avg($modules_marked), 2)
        
        return
        <student>
            <number>{data($student/number)}</number>
            <marks count="{count($modules_marked)}">
                {lp:print-modules-list($modules_marked)}
                <average>{$modules_marked_avg}</average>
            </marks>
            <ignored-modules count="{count($modules_ignored)}">
                {lp:print-modules-list($modules_ignored)}
            </ignored-modules>
        </student>
};

(:
    This is a utility function to format the module given as parameter
:)
declare function lp:print-modules-list($modules) {
    for $module in $modules
    return
        <module>
            <code>{data($module/@code)}</code>
            <result>{data($module)}</result>
        </module>
};

<query>
    {lp:list-student-marks('100005')}
</query>