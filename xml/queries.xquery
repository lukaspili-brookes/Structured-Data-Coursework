xquery version "1.0";

declare namespace lp="http://www.brookes.ac.uk/lukasz/piliszczuk/xquery";

declare variable $lp:courses-xml as xs:string := "courses.xml";
declare variable $lp:students-xml as xs:string := "students.xml";
declare variable $lp:modules-xml as xs:string := "modules.xml";

declare function lp:list-student-marks($student_number as xs:string) {

        let $student := doc($lp:students-xml)/students/student[number=$student_number]
        let $modules := $student/module
        let $modules_marked := $modules[@type='mark']
        let $modules_ignored := $modules[@type='other']
        
        return
        <student>
            <number>{data($student/number)}</number>
            <marks count="{count($modules_marked)}">
                {lp:print-modules-list($modules_marked)}
                <average>{round-half-to-even(avg($modules_marked), 2)}</average>
            </marks>
            <ignored-modules  count="{count($modules_ignored)}">
                {lp:print-modules-list($modules_ignored)}
            </ignored-modules>
        </student>
};

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