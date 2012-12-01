-- Stage 3

-- Query 1

select query_to_xml(
'select sc.student_number, t.postcode_district || \' \' || a.postcode_area as postcode
from student_courses sc
join students s on sc.student_phone_number = s.phone_number
join addresses a on s.address_id = a.id
join towns t on a.town_id = t.id',
true, false, '');

-- Query 2

select query_to_xml(
	'select sc.year, sc.student_number
	from student_courses sc',
true, false, '');

-- Query 3

select query_to_xml(
	'select sc.student_number, t.postcode_district
	from student_courses sc
	join students s on sc.student_phone_number = s.phone_number
	join addresses a on s.address_id = a.id
	join towns t on a.town_id = t.id'
,true, false, '');

-- Query 4

select query_to_xml(
	'select sc.student_number, t.postcode_district
	from student_courses sc
	join students s on sc.student_phone_number = s.phone_number
	join addresses a on s.address_id = a.id
	join towns t on a.town_id = t.id'
,true, false, '');